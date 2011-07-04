Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42802 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab1GDVC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 17:02:59 -0400
Received: by gyh3 with SMTP id 3so2052133gyh.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 14:02:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ipriyuoi.fsf@purkki.adurom.net>
References: <1309758467-1712-1-git-send-email-nbd@openwrt.org>
	<1309758467-1712-2-git-send-email-nbd@openwrt.org>
	<1309758467-1712-3-git-send-email-nbd@openwrt.org>
	<1309758467-1712-4-git-send-email-nbd@openwrt.org>
	<1309758467-1712-5-git-send-email-nbd@openwrt.org>
	<1309758467-1712-6-git-send-email-nbd@openwrt.org>
	<1309758467-1712-7-git-send-email-nbd@openwrt.org>
	<CAFtRNNyPJOtjW8vDnjveqmMD3snt_iaDV45p3QZEOKrSyED3yg@mail.gmail.com>
	<4E1190FF.9010701@openwrt.org>
	<CAFtRNNyyx2e3YhKgGwG4h678dEKkQwdVf8pXBtWqYHZzx9r0cQ@mail.gmail.com>
	<87ipriyuoi.fsf@purkki.adurom.net>
Date: Tue, 5 Jul 2011 00:02:58 +0300
Message-ID: <CAFtRNNzEZg0zipr9NFSOtBDsk-px9oqASfBV2uSa_E5TvHOn4Q@mail.gmail.com> (sfid-20110704_230302_696535_AAEB0ED1)
Subject: Re: [PATCH 7/8] ath5k: disable 32KHz sleep clock operation
From: Nick Kossifidis <mickflemm@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/4 Kalle Valo <kvalo@adurom.com>:
> Nick Kossifidis <mickflemm@gmail.com> writes:
>
>> O.K. let's comment it out then and add some information that it's
>> disabled by default on available HALs...
>
> Leaving dead code lying around is bad. Why not add a comment with some
> pointers how to get the old code if someone wants to do that? For
> example git commit id is a good reference and I'm sure it will work
> even after 10 years.
>

OK but either we remove the whole thing (ath5k_hw_set_sleep_cloc also,
it's not being called anywhere else) or go the other way and leave it
there with a comment or a debugfs/modparam. I believe having it as a
debugfs/modparam option is better, after all it worked so far for most
cards, we didn't had any bug reports related to 32KHz operation (at
least I don't remember any).



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
