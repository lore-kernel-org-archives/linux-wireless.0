Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f51.google.com ([209.85.213.51]:55350 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab2FVWBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 18:01:10 -0400
Received: by yhnn12 with SMTP id n12so2301757yhn.10
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 15:01:09 -0700 (PDT)
Message-ID: <4FE4EB22.8090709@lwfinger.net> (sfid-20120623_000114_512509_6172A239)
Date: Fri, 22 Jun 2012 17:01:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xun Ouyang <ilhebe999@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: please help me, fedora make modules error
References: <loom.20120622T225528-225@post.gmane.org>
In-Reply-To: <loom.20120622T225528-225@post.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/22/2012 04:04 PM, Xun Ouyang wrote:
> After I install ncurses-devel, I used the command menuconfig, but I did not
> change anything, just the default value, and then , "make modules'
>
>
> [root@linux123 wireless-testing]# make modules
> make[1]: Nothing to be done for `all'.
>    CHK     include/linux/version.h
>    CHK     include/generated/utsrelease.h
>    CALL    scripts/checksyscalls.sh
>    CC [M]  drivers/net/wireless/at76c50x-usb.o
> In file included from drivers/net/wireless/at76c50x-usb.c:46:0:
> include/net/mac80211.h: In function ‘ieee80211_tx_info_clear_status’:
> include/net/mac80211.h:639:2: error: size of unnamed array is negative
> include/net/mac80211.h:644:2: error: size of unnamed array is negative
> make[3]: *** [drivers/net/wireless/at76c50x-usb.o] Error 1
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
>
> The content in line 639 and 644 are all:like
> BUILD_BUG_ON(offsetof(struct XXXXXXX) !=XXX);
>
> If I comment this line out, it "seems" this problem fixed.
> And I tried to make modules again, the same error(BUILD_BUG_ON
> (offsetof(struct XXXXXXX) !=XXX);)  came out but different
> file, different lines.And repeatedly.
> I do not think there are so many error that need to be fixed since I
> just change a few lines of codes which seems unrelated to theses errors.
>
>
> I really do not know what to do.Anyone can help me? Thank you so much.

What kernel are you using?

This problem is fixed in the latest version from wireless-testing.

Larry

