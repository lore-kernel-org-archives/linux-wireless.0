Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17802C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 17:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA2732146D
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 17:40:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cinyNuMb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA2732146D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390021AbeKTEEy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 23:04:54 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40138 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389229AbeKTEEx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 23:04:53 -0500
Received: by mail-ot1-f67.google.com with SMTP id s5so28400760oth.7;
        Mon, 19 Nov 2018 09:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=2e9GmcmvDnjGTuB1UfTZyLTxmQvy2ZTf8CtPcYRwmyw=;
        b=cinyNuMbhZwoBooqNjdQCQXEyqUn9PWdVEcJO3QAaD38dMD0JTKECO/+eFs4SAdVNf
         hXAcrsAW2bGSbWcyZdoywh14I9OTpmZvD6egdT8DYDroeUARVTKh6CXn7EgRmx0NmAXI
         kfv6f9s5ciRZ61RCfpSvGDh/YWelagNgn4UeQy1k07rYARL6SUwdW8p2U3LjAkyUH2/k
         u48EKEgAKPDoIoQrQpUqr11qhBgH7aaR5uGtSFsvEQ5WyMmcCaGf+zo9JfSFTUMFoInW
         VZ+ywBVW2jVtnd7tZ6fYZbwexYA65KmDruJCImACX7AbUmHhugS7MSk/bIOn9GqNRQ3m
         EyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language;
        bh=2e9GmcmvDnjGTuB1UfTZyLTxmQvy2ZTf8CtPcYRwmyw=;
        b=AhsKGJoSQKu7rtGsYb6IRI3p0jqmivMegCFv+zOVfmCqE8i6z8fgAfU2E+7XKF8K/C
         DOLXlXX99eU7rAXIsVyyzNDNDpknCuBnDAZ2Y0SIWIPotmx6WxwZ6Pbv/MzKW3Mg4W2g
         mWbthsblFRwXWxD+Cw89Of6CDol1kpk3wujm2hzEW0s/glihtJJ23VBLHsPHED7PN0u0
         s7ypwRbHeZz2W3k4Nsik8hq959H6CY11hlutJckjRRD95mzL2Zj3i26sz2KcschkyuxB
         /Sd5t89OV2Ma8p9ufgYySl3DKHc2GD1eBmfjmjLfMaR/nGE8ZiJrBaLXhnIUZpxAl1re
         tyHA==
X-Gm-Message-State: AGRZ1gLK69+Mr8bHE1u5PKsmAvSz2I7yIVvFKC+dKJuUsmkv2vLGwWfN
        3c1T6W6xDMuoDUqjqwGDuqTWHlfT
X-Google-Smtp-Source: AJdET5e+XjKBFXz+Rxp9CyF7WVAMWiceRdQROvcYhefZffuhjAGM4Mog9sltdSTMVvTSE/qhhGl4cw==
X-Received: by 2002:a9d:2cbc:: with SMTP id p57mr12985701otb.1.1542649225187;
        Mon, 19 Nov 2018 09:40:25 -0800 (PST)
Received: from [192.168.1.104] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id w186-v6sm13869955oig.52.2018.11.19.09.40.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Nov 2018 09:40:21 -0800 (PST)
Subject: Re: [PATCH v3 3/3] b43: Use cordic algorithm from kernel library
To:     Priit Laes <plaes@plaes.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
 <d93962cdc5a32fe99e6e5a25172920d28583aa6a.1542219596.git-series.plaes@plaes.org>
 <d630ca3e-4070-5395-54c2-e20e0c552dc3@lwfinger.net>
 <20181118082327.ttrz2nl5owi2hoqv@plaes.org>
 <df798743-10bb-0455-be83-2fb59eca3209@lwfinger.net>
 <20181119112755.qtthenx54v3tnok3@plaes.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <fe3efdcb-3488-2fa5-f749-3e7366609697@lwfinger.net>
Date:   Mon, 19 Nov 2018 11:40:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181119112755.qtthenx54v3tnok3@plaes.org>
Content-Type: multipart/mixed;
 boundary="------------FD22EC480DE4FF646E0A5039"
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a multi-part message in MIME format.
--------------FD22EC480DE4FF646E0A5039
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/18 5:27 AM, Priit Laes wrote:
> On Sun, Nov 18, 2018 at 01:35:57PM -0600, Larry Finger wrote:
>> On 11/18/18 2:23 AM, Priit Laes wrote:
>>> On Sat, Nov 17, 2018 at 09:31:35PM -0600, Larry Finger wrote:
>>>> On 11/14/18 12:27 PM, Priit Laes wrote:
>>>>> Kernel library has a common cordic algorithm which is identical
>>>>> to internally implementatd one, so use it and drop the duplicate
>>>>> implementation.
>>>>>
>>
>> My test setup has a hardware failure, thus I cannot test your patch, but I
>> now believe it to be correct. Thus your first and third patches may be
>> annotated with
>> ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
>>
>> One thing that should be done is to fix the error in the b43 code for stable
>> as it was introduced in 2.6.34. I propose adding the attached patched to
>> your series placed between your current 2nd and 3rd patches so that the old
>> kernels get fixed. Of course, your 3rd patch will need to be revised. If all
>> 4 of the patches get submitted together there will be no problems with the
>> timing. My change will exist for seconds in the mainline kernel, but it will
>> get propagated back through stable.
> 
> Thanks!
> 
>>  From b42ae73ef7505de93e4c66fb9f66930e3f3d969a Mon Sep 17 00:00:00 2001
>> From: Larry Finger <Larry.Finger@lwfinger.net>
>> Date: Sun, 18 Nov 2018 13:15:07 -0600
>> Subject: [PATCH] b43: Fix error in cordic routine
>> MIME-Version: 1.0
>> Content-Type: text/plain; charset=UTF-8
>> Content-Transfer-Encoding: 8bit
>> To: kvalo@codeaurora.org
>> Cc: linux-wireless@vger.kernel.org
>>
>> The cordic routine for calculating sines and cosines that was added in
>> commit 986504540306 ("b43: make cordic common (LP-PHY and N-PHY need it)")
>> contains an error whereby a quantity declared u32 can in fact go negative.
> 
> It seems to be different commit though:
> commit 6f98e62a9 ("b43: update cordic code to match current specs")

Thanks for catching that mistake. I must have gotten one line off in my copy and 
paste. The respun version of my patch is attached.

I have now been able to test b43 on an LP-PHY device. I do not see any major 
changes, but there has to be some effect.

Larry
Larry


--------------FD22EC480DE4FF646E0A5039
Content-Type: text/x-patch;
 name="0001-b43-Fix-error-in-cordic-routine.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="0001-b43-Fix-error-in-cordic-routine.patch"

From b42ae73ef7505de93e4c66fb9f66930e3f3d969a Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 18 Nov 2018 13:15:07 -0600
Subject: [PATCH] b43: Fix error in cordic routine
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org

The cordic routine for calculating sines and cosines that was added in
commit 6f98e62a9f1b ("b43: update cordic code to match current specs")
contains an error whereby a quantity declared u32 can in fact go negative.

This problem was detected by Priit Laes who is switching b43 to use the
routine in the library functions of the kernel.

Fixes: 6f98e62a9f1b ("b43: update cordic code to match current specs")
Reported-by: Priit Laes <plaes@plaes.org>
Cc: Rafał Miłecki <zajec5@gmail.com>
Cc: Stable <stable@vger.kernel.org> # 2.6.34
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/broadcom/b43/phy_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_common.c b/drivers/net/wireless/broadcom/b43/phy_common.c
index 85f2ca989565..ef3ffa5ad466 100644
--- a/drivers/net/wireless/broadcom/b43/phy_common.c
+++ b/drivers/net/wireless/broadcom/b43/phy_common.c
@@ -616,7 +616,7 @@ struct b43_c32 b43_cordic(int theta)
 	u8 i;
 	s32 tmp;
 	s8 signx = 1;
-	u32 angle = 0;
+	s32 angle = 0;
 	struct b43_c32 ret = { .i = 39797, .q = 0, };
 
 	while (theta > (180 << 16))
-- 
2.16.4


--------------FD22EC480DE4FF646E0A5039--
