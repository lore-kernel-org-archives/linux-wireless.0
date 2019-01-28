Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7580EC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 20:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4022C21738
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 20:56:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="us1NT7w7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfA1U4z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 15:56:55 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38585 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfA1U4z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 15:56:55 -0500
Received: by mail-ot1-f65.google.com with SMTP id e12so15947590otl.5
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 12:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=RL98/9QZlF5TNZfVGeTgnqpJZRrJJM6JtEWgzW/vPp8=;
        b=us1NT7w7V1FPtW7lAccBCQiL684EvXe3I74OtzkJtPyJc3gEltu8ld8hYZl7x/DEkH
         eKAxpDt5ya50YMAIAblQhK2xRFXT5jv2pfTBUzd+KIVfRV/ZFeCrEB9Ji+J6ddV1X6iQ
         tfMN61/6nT0EsJUeAHpcJ3lX+lwaXmkyCPJ83YSFN+orlVwiHY0XpBohkzeDBdsm+Tkq
         4umvzCXurG+9oTf2DW/39nFNWlhjh5XvY4Uio1y1g3YCsA5HhCFeM4Zy7TfHJa3U6kO4
         fEEol+lItD83/Lu7wJD0+aherVVTqjgyLZsuJl/z/T88WYteP0Pn8MSnk1+NfH1VG+nh
         vndw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language;
        bh=RL98/9QZlF5TNZfVGeTgnqpJZRrJJM6JtEWgzW/vPp8=;
        b=EI0eMhCBCBXRAIUYMNxuWXZeq7wX27s0FrI0IyIPN6gQwrQkhYgMwLO+ZXHRhDE9At
         Xpsvh+UdDSpmI8vGXBC09b7JvLUyZRyhJLKEd2gYI+YK72pqQJuNzwM7IRDAu4SPjOYk
         9oDZS55BJRMAY06L4u8GuCKgC08j1nFs9fkNrFArI0rS7yhsVG6cio04yAHCxFMpGp2H
         5RLtmafRtPu2uuU/y0lxdAHq6/tpQ7RKhpoME3d/div3/2Zbplh4KnKf5YY7aaKEaKaS
         hXaeoni6xvEmwd9/Tc2Qpu8kpnPjgnSw1mFY/X/A8S4ER7D+Sr9Q6wpCD+At52ZUvTwg
         BZ8A==
X-Gm-Message-State: AJcUukfnkN1gEXdpanS9DdTowDvDU6ciBC6mD7iIdrth1dagkii02/2z
        NoPSQEcM86PzQWiOVSF+cQnQoIjC
X-Google-Smtp-Source: ALg8bN6ea84GshdsqLmF7roSBnoShUup4qy/AwFbIsjf5uxmNHFt2+pX1uwVFBTUqp93vscCUARzng==
X-Received: by 2002:a9d:2661:: with SMTP id a88mr17885567otb.91.1548709014355;
        Mon, 28 Jan 2019 12:56:54 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id u19sm5379807oia.31.2019.01.28.12.56.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 12:56:53 -0800 (PST)
Subject: Re: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
To:     =?UTF-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>
Cc:     Pkshih <pkshih@realtek.com>, tehuang@realtek.com,
        briannorris@chromium.org, sgruszka@redhat.com,
        linux-wireless@vger.kernel.org
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <043aedf4-0ed4-e128-3cd2-242aaef128f6@lwfinger.net>
Date:   Mon, 28 Jan 2019 14:56:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
Content-Type: multipart/mixed;
 boundary="------------E4D2F68B98824868CFAF1C68"
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a multi-part message in MIME format.
--------------E4D2F68B98824868CFAF1C68
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Tony,

I had not tested rtw88 for some time, so I built a kernel with the V3 patches 
and found that rtw88 crashed with a NULL pointer dereference. I did some 
debugging and found that the problem was in routine rtw_chip_efuse_enable() 
where fw->firmware was NULL.

Next I verified that rtw_load_firmware() had been called, which gave a clue that 
the firmware had not finished loading by the time rtw_chip_efuse_enable() was 
called. By adding a wait_for_completion() call before the 
rtw_download_firmware() call, the problem was fixed. The problem was a race 
between calling rtw_chip_efuse_enable() and the firmware load from disk. 
Obviously, the speed ratio between my CPU and the disk system is much different 
on my laptop than on your test machines, thus I have the problem.

The patch I used is attached.

Larry

--------------E4D2F68B98824868CFAF1C68
Content-Type: text/x-patch;
 name="rtw88_fix_race_at_start.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtw88_fix_race_at_start.patch"

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index a189c4500fd9..690c0a68a038 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -902,6 +902,7 @@ static int rtw_chip_efuse_enable(struct rtw_dev *rtwdev)
 		goto err;
 	}
 
+	wait_for_completion(&fw->completion);
 	rtw_write8(rtwdev, REG_C2HEVT, C2H_HW_FEATURE_DUMP);
 	ret = rtw_download_firmware(rtwdev, fw->firmware->data,
 				    fw->firmware->size);

--------------E4D2F68B98824868CFAF1C68--
