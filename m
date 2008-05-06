Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:17966 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764634AbYEFJGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 05:06:30 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1581025rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2008 02:06:28 -0700 (PDT)
Message-ID: <a32f33a40805060206l1af71db0tced88dd3d3d08c30@mail.gmail.com> (sfid-20080506_110553_846073_8255B8FB)
Date: Tue, 6 May 2008 11:06:28 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Luis Correia" <luis.f.correia@gmail.com>
Subject: Re: [Rt2400-devel] rt2500usb current git BUG
Cc: rt2400-devel@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <efe7343f0804291454p40914cadpf06846270d080e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <efe7343f0804291454p40914cadpf06846270d080e2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

[Extended CC list with linux-wireless and Johannes Berg]

>  CentOS 5.1, running with latest GIT kernel, rt2500usb, full dmesg
>  output follows.
>
>  This is using NetworkManager to get things done.
>
>  The "BUG: scheduling while atomic: rt2500usb/3817/0x00000002" thing
>  appears right after plugging in the stick.

I found the cause of this problem, rt2500usb and rt73usb require
scheduled register access,
this is a known fact, that is the reason why things like ERP and
Beacon configuration
which are per-interface settings are done within a workqueue.
However, this is where the problem starts, in the workqueue rt2x00
needs to iterate over
all interfaces, because for each interface the configuration routine
must be run. But
to iterate over all interfaces, mac80211 grabs the rcu lock
guaranteeing rt2x00 can no
longer perform any register access even though it is running in a workqueue.
For the ERP configuration we might work around this by storing the ERP
settings in
a temporary location and change the setting to something that matches
most active
interfaces best. This means that slot time and preamble settings will
always be short
when at least 1 interface has it set to short.

The real problem is with beaconing, the only way we could get around
this issue is
creating a local skb in which we store the beacons given to us, and
after all iterations
are over, write the beacons one by one to the hardware.
Obviously this results in race conditions where the beacon might be
written to the
hardware while the interface is being removed... Which would mean we
could end up
having to cripple rt2x00 again and remove all support for virtual
interfaces... :S

Johannes, do you have any suggestions?

Ivo
