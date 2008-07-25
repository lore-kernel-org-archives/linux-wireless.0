Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:17707 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYGYB25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 21:28:57 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3783050wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 18:28:57 -0700 (PDT)
Message-ID: <3ace41890807241828y31579f86ifd959b74c62bef5d@mail.gmail.com> (sfid-20080725_032902_651808_76001002)
Date: Fri, 25 Jul 2008 02:28:57 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <200807241337.59688.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <3ace41890807232028u576371a6ra944431327cac76c@mail.gmail.com>
	 <488815DE.2000903@lwfinger.net>
	 <200807241337.59688.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2008 at 5:37 PM, Herton Ronaldo Krzesinski
<herton@mandriva.com.br> wrote:
<sniped>
> For me it works with or without the patch, may be there is some condition that
> triggers the bug that I'm not hitting. But I still have the same problem that
> I previously reported about power management, but the bug isn't on that
> commit and doesn't have to do with power management, later I found that an
> ifconfig <interface> down + ifconfig <interface> up works too, it's something
> on userspace that triggers the bug (shortly after I modprobe the module, udev
> calls automatically scripts to configure the interface, if I disable this in
> udev and run commands manually interface works here, I'll see if I catch this
> other problem, may be a race in initialization code somewhere).

Some kind of race condition is quite likely. I think I have seen two
instances of dhclient
being launched by udevd quite routinely; and I seems to notice that I have to
do ifconfig up, iwconfig etc in fairly quick succession and in some
specific order to get
it to work, and sometimes killing off udevd launched dhclient and do my own.

I notice that dhclient seems to want to ifconfig the interface down if
it can't get an ip address
(this seems extra to me - there are occasions when I want to have a
bare interface without address up?).

So what's the verdict so far? I am tracking fedora 9 koji test kernels
mostly, and something between
kernel-2.6.25.11-92.fc9 and kernel-2.6.25.11-93.fc9 broke rtl8187. I
just checked out the source rpm
itself, and the difference is just in the wireless area, and supposedly one of
 http://marc.info/?l=linux-wireless&m=121606436000705&w=2 . I think
this is what most agreed - i.e.
nobody is getting much success with latest wireless with rtl8187?

Both the power management hook and the tx seq no removal are among those.
the iwconfig power off doesn't do it for me (it seems to default to
off anyway?),
but I had one success with the tx seq fix having quite substantial
traffic - 50MB? - going through
before I reboot or otherwise lose the connectivity in some non-problematic way
 and didn't get it back ever.

The journey continues...

Hin-Tak
