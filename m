Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33654 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbbD2IGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 04:06:19 -0400
Received: by oica37 with SMTP id a37so15722763oic.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 01:06:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87r3r45jxs.fsf@kamboji.qca.qualcomm.com>
References: <1428519117-15833-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<87r3r45jxs.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 29 Apr 2015 10:06:18 +0200
Message-ID: <CAA2SeNL=5gC0aQNM5JvBpGnm9sGsd-Nuxt5FdGirzXHDKV9hPA@mail.gmail.com> (sfid-20150429_100626_479149_F9F39AEA)
Subject: Re: [PATCH] ath9k: fix per-packet tx power configuration
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Do not use ieee80211_vif pointer in ath_get_rate_txpower() since it has been
>> overwritten by setup_frame_info() and it will result in a corrupted tx power
>> configuration. Set per-packet tx power in setup_frame_info() according to
>> current vif tx power.
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
>
> I'm planning to send this fix to 4.1, is that ok?
>

I agree. That patch has been tested on an urban noisy link and the RX
signal strength is solid. The throughput is stable as well. The patch
hopefully fixes the issue reported in the commit
'c09396eb8e5a8df668174993c6400763022b2466 - ath9k: disable TPC support
again (for now)'

Best regards,
Lorenzo

> --
> Kalle Valo



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
