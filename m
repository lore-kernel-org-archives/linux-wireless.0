Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:48078 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab0ATRzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 12:55:42 -0500
Received: by pxi12 with SMTP id 12so5808312pxi.33
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2010 09:55:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7f313e3f1001200147o1045ede5l935aff4c3e892ba7@mail.gmail.com>
References: <7f313e3f1001200145y45837e38k205a4f0eb0d7fe85@mail.gmail.com>
	<7f313e3f1001200147o1045ede5l935aff4c3e892ba7@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 20 Jan 2010 09:55:21 -0800
Message-ID: <43e72e891001200955k55c4311etd55e3d4e1ae3ae22@mail.gmail.com>
Subject: Re: Problems with regulatory domains
To: JJ Merelo <jjmerelo@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 20, 2010 at 1:47 AM, JJ Merelo <jjmerelo@gmail.com> wrote:
> Hi,
> I have posted this help request:
> http://ubuntuforums.org/showthread.php?t=1385125 at the ubuntu forums
> related to the problems setting regulatory domains in my laptop, which
> seems to affect only WPA for some reason (or maybe that's just
> incidental, regulatory domain does not matter too much, and the
> problems is an entirely different piece of cake) Can you please take a
> look at it, and give me some pointers on what can be going on? Thanks

On your forum post you have something like:

> cfg80211: Calling CRDA for country: ES
> cfg80211: Received country IE:
>
> Which seems to be that my machine is defined as being in IE

Heh, no IE stands for Information Element, that line indicates your AP
has sent out country IEs on its beacons and on that beacon it is
indicating your are in ES.

> instead of Spain... and then

The rest of your post indicates you had issues disconnecting after the
country IE. I recommend to *not* use the module parameter as you are
using, and just let your cfg80211 do the job. Your intel card already
has regulatory information internally and it just world roams, with
Intel cards cfg80211 just works by doing more work and helping
compliance further, nothing further.

Any issue with the module parameter should still be address but I just
do recommend to not use it anyway.

Now, as for your disconnect issue, you need to provide more
information. Please provide the channel the AP is on, your 'iw list'
output, prior to associating to the AP and also the same output
*after* you have associated. Also then please get iw from git:

And then apply this patch:

http://bombadil.infradead.org/~mcgrof/patches/iw/show-country-ie.patch

And provide the output of your scan, just the section for your AP is important.

I should note 2.6.31 is old and has reached its end of life, no more
fixes will be applied to it, you may want to then install the latest
stable wireless drivers from 2.6.32. Ubuntu has a package for this. Go
read:

https://wiki.ubuntu.com/KernelTeam/LinuxWireless
http://wireless.kernel.org/en/users/Documentation/Reporting_bugs

http://wireless.kernel.org/en/users/Download/stable

  Luis
  Luis
