Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbbCIRIv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 13:08:51 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1425680126-25928-1-git-send-email-Jes.Sorensen@redhat.com>
	<1425680126-25928-2-git-send-email-Jes.Sorensen@redhat.com>
	<54FB6DFC.3040509@lwfinger.net>
Date: Mon, 09 Mar 2015 13:08:47 -0400
In-Reply-To: <54FB6DFC.3040509@lwfinger.net> (Larry Finger's message of "Sat,
	07 Mar 2015 15:30:36 -0600")
Message-ID: <wrfjsideqesg.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150309_180855_369067_1465F895)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> Quilt reports the following when this patch is refreshed:
>
> Warning: trailing whitespace in lines 2862,3273,3492,3521 of
> drivers/net/wireless/rtl8xxxu.c

Hi Larry,

I fixed up the trailing whitespaces in v2 (and added a
(setq show-trailing-whitespace t) to my config file).

> I have not analyzed all the temporary manipulations of rtl8xxxu_debug
> to see what you are doing; however, I suggest that you add a module
> parameter so that debugging can be enabled without rebuilding the
> module. That way a user who is using a distro binary can enable
> debugging without the hassle of a full kernel rebuild.

I added a module paramter, and worked around the %@#$%#$%#$ dynamic
debug issues to get the driver to actually print stuff when you set it.
For some reason I was convinced I already had this as a module
parameter.

> Because this driver is under drivers/net, checkpatch.pl adds
> additional tests that may not be used in other trees. For instance, it
> complains when it finds a block comment that starts with a bare
> "/*". What is usually done is to use "/**" instead.

This part I will leave as is.

> I think I understand why some of the "#if 0" blocks are present, but
> others are not clear. For example, I see no value of keeping code that
> is labelled "only for PCIe". Is it your intention to add the RTL8723AE
> to this driver?

I prefer to keep them in place for now, as it makes it easier for me to
debug the tables when I compare them to the tables in the vendor
driver. I will eventually remove those, but it's to early to do that
just yet.

> Running checkpatch.pl on this patch results in total of 24 errors, 99
> warnings, and 105 checks. From your mail exchange with Joe Perches, I
> understand that you will not wish to fix all of these; however, the
> errors should be handled. The fewer of the warnings or checks that are
> left, the better, if only to prevent interference from the script
> kiddies.

I should have run checkpatch on Friday when I posted the first
version. Some of the formatting was due to converting from printk() to
other wrappers.

It's rather disturbing how checkpatch has been turned into a trolling
tool used by the script kiddies to harrass actual development, and to
bump their number of commits in the git log, but I guess there isn't
much to do about it. As always, I very much appreciate real bug reports!

> I like the clean look of the code. That is particularly impressive
> given the look of the original. I wish I had the hardware on which to
> test it. Perhaps I can wedge it into a kernel version that builds and
> runs on my Radxa Rock,

Thanks, I tried hard to keep it clean, even though there were parts of
badness that crept over from the original driver. In particular in the
radio configuration portions.

Cheers,
Jes
