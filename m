Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:48816 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759587AbYEFJtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 05:49:06 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1597067rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2008 02:49:05 -0700 (PDT)
Message-ID: <a32f33a40805060249s2e20455fk88825329386b7475@mail.gmail.com> (sfid-20080506_114900_897135_33C7C1AD)
Date: Tue, 6 May 2008 11:49:05 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [Rt2400-devel] rt2500usb current git BUG
Cc: "Luis Correia" <luis.f.correia@gmail.com>,
	rt2400-devel@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1210066571.8012.73.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <efe7343f0804291454p40914cadpf06846270d080e2@mail.gmail.com>
	 <a32f33a40805060206l1af71db0tced88dd3d3d08c30@mail.gmail.com>
	 <1210066571.8012.73.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/6/08, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > The real problem is with beaconing, the only way we could get around
> > this issue is
> > creating a local skb in which we store the beacons given to us, and
> > after all iterations
> > are over, write the beacons one by one to the hardware.
> > Obviously this results in race conditions where the beacon might be
> > written to the
> > hardware while the interface is being removed... Which would mean we
> > could end up
> > having to cripple rt2x00 again and remove all support for virtual
> > interfaces... :S
> >
> > Johannes, do you have any suggestions?
>
> Well you could
>  (a) keep your own BSS interfaces list but you might need a mutex and
>      two work structs to make it flawless
>  (b) provide, in mac80211, an iterator that takes the RTNL instead of
>      RCU, I think that should work

But hadn't you removed the RTNL locking to make the multi-BSS code easier?
I think I can code around the problem to make the ERP configuration do
a simple check if any interface has short preamble, and if that is the
case all interfaces will have short preamble. The same would go for
short slot time.
Apparently the current code was broken in that respect anyway since it
would assume the timing of the last interface in the list.

As for the beaconing, the only location I cannot get around updating
the beacon in the driver from scheduled context is in the
suspend/resume path. And I believe resuming a mac80211 network
interface is already a source of problems anyway...
Well I'll dive a bit deeper into this and see what can be done about this.

Ivo
