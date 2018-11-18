Return-Path: <SRS0=hThr=N5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37DF6C43610
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Nov 2018 19:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF12020869
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Nov 2018 19:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KGMulZRk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF12020869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbeKSF5G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 00:57:06 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37412 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbeKSF5F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 00:57:05 -0500
Received: by mail-ot1-f67.google.com with SMTP id 40so25812023oth.4;
        Sun, 18 Nov 2018 11:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=s+NNnct2IJGmIUrNgaz8ix2VFknPNnqkrN45qKqKZQ4=;
        b=KGMulZRkmfpp67m+a9AR19UOvPGeXwHHgoO5LodgdUQ9WJ3JD44h1lf0dzaHvltShU
         oiZK+eCQ6+zNSEUok1kdGWQ+FnTio+cfvWJkxbshB3fbPdEepad/AKtzrTqJP71hnAmU
         scPb+qtmB9iQOi5wjkyF7V6dUnSh9joJkml3iZJ8fzQyB45xazyOXs3z+/zchHcXzzMn
         fYg9naPjgulqHSg09y9rN/yb6bjGrlIfooq1Jywu+L7a6i9+NV59jLDYQ464i6KNIZK5
         VTQEi8TRKtuVWLGp8l4BH0I+7iRPj3KAHKSfhoQ/4oBVrnpRm4BW45P6GYWb3aSwkIoW
         FuEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:subject:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language;
        bh=s+NNnct2IJGmIUrNgaz8ix2VFknPNnqkrN45qKqKZQ4=;
        b=BjMkBH7pE2dAlxXQCz3IxidffNVAru6oaOc+lgx+5oCaGr7i9P/AMAaiKvxHQF1KTT
         WQwIf9EsuexJmaTVi6NRY5HSsGvHN78CHg9d2ORqubYgBZRdO6cgMaM9Z00dNVvD43K/
         ChkBHpvqpYpP9GFhztxRyKPUfDxB38FDDNXYidsKc/DtLCc90blkHWvw/RTCC/Qlpy9N
         yBH+gkFIb6QXZsMz3iCeqFiQV985s03XJa51okOGRXvwFkFJlzQJ/6sanL10/xF+u8TI
         T8VLkzwkPGgWM82lP5HMdgrbfDx9rirnhvIfr9KzSiGLB7W6o395e3969vVjnqc4w1s2
         Xd8A==
X-Gm-Message-State: AGRZ1gJBZOYziFTd3sYgS3pU+yNJnc0gKbjsO/xlaBZd0AkFGf2G30OH
        x1vbsF3vlATG5Yw1HLF+Y79NOTvu
X-Google-Smtp-Source: AJdET5d3csLZvJZMojhVGO+KpBRsDodUvmjEPvBbEOfI8lAL7NE3gJpofizKZTN43E/t5E4lYraxQg==
X-Received: by 2002:a9d:3408:: with SMTP id v8mr12111708otb.237.1542569756536;
        Sun, 18 Nov 2018 11:35:56 -0800 (PST)
Received: from [192.168.1.104] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id p203sm20826582oic.49.2018.11.18.11.35.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Nov 2018 11:35:55 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
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
Message-ID: <df798743-10bb-0455-be83-2fb59eca3209@lwfinger.net>
Date:   Sun, 18 Nov 2018 13:35:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181118082327.ttrz2nl5owi2hoqv@plaes.org>
Content-Type: multipart/mixed;
 boundary="------------A4EEE76D88D7EF2499287287"
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a multi-part message in MIME format.
--------------A4EEE76D88D7EF2499287287
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/18 2:23 AM, Priit Laes wrote:
> On Sat, Nov 17, 2018 at 09:31:35PM -0600, Larry Finger wrote:
>> On 11/14/18 12:27 PM, Priit Laes wrote:
>>> Kernel library has a common cordic algorithm which is identical
>>> to internally implementatd one, so use it and drop the duplicate
>>> implementation.
>>>
>>> Signed-off-by: Priit Laes <plaes@plaes.org>
>>> ---
>>>    drivers/net/wireless/broadcom/b43/Kconfig      |  1 +-
>>>    drivers/net/wireless/broadcom/b43/phy_common.c | 47 +-------------------
>>>    drivers/net/wireless/broadcom/b43/phy_common.h |  9 +----
>>>    drivers/net/wireless/broadcom/b43/phy_lp.c     | 13 ++---
>>>    drivers/net/wireless/broadcom/b43/phy_n.c      | 13 ++---
>>>    5 files changed, 15 insertions(+), 68 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/b43/Kconfig b/drivers/net/wireless/broadcom/b43/Kconfig
>>> index fba8560..3e41457 100644
>>> --- a/drivers/net/wireless/broadcom/b43/Kconfig
>>> +++ b/drivers/net/wireless/broadcom/b43/Kconfig
>>> @@ -4,6 +4,7 @@ config B43
>>>    	select BCMA if B43_BCMA
>>>    	select SSB if B43_SSB
>>>    	select FW_LOADER
>>> +	select CORDIC
>>>    	---help---
>>>    	  b43 is a driver for the Broadcom 43xx series wireless devices.
>>> diff --git a/drivers/net/wireless/broadcom/b43/phy_common.c b/drivers/net/wireless/broadcom/b43/phy_common.c
>>> index 85f2ca9..98c4fa5 100644
>>> --- a/drivers/net/wireless/broadcom/b43/phy_common.c
>>> +++ b/drivers/net/wireless/broadcom/b43/phy_common.c
>>> @@ -604,50 +604,3 @@ void b43_phy_force_clock(struct b43_wldev *dev, bool force)
>>>    #endif
>>>    	}
>>>    }
>>> -
>>> -/* http://bcm-v4.sipsolutions.net/802.11/PHY/Cordic */
>>> -struct b43_c32 b43_cordic(int theta)
>>> -{
>>> -	static const u32 arctg[] = {
>>> -		2949120, 1740967, 919879, 466945, 234379, 117304,
>>> -		  58666,   29335,  14668,   7334,   3667,   1833,
>>> -		    917,     458,    229,    115,     57,     29,
>>> -	};
>>> -	u8 i;
>>> -	s32 tmp;
>>> -	s8 signx = 1;
>>> -	u32 angle = 0;
>>> -	struct b43_c32 ret = { .i = 39797, .q = 0, };
>>> -
>>> -	while (theta > (180 << 16))
>>> -		theta -= (360 << 16);
>>> -	while (theta < -(180 << 16))
>>> -		theta += (360 << 16);
>>> -
>>> -	if (theta > (90 << 16)) {
>>> -		theta -= (180 << 16);
>>> -		signx = -1;
>>> -	} else if (theta < -(90 << 16)) {
>>> -		theta += (180 << 16);
>>> -		signx = -1;
>>> -	}
>>> -
>>> -	for (i = 0; i <= 17; i++) {
>>> -		if (theta > angle) {
>>> -			tmp = ret.i - (ret.q >> i);
>>> -			ret.q += ret.i >> i;
>>> -			ret.i = tmp;
>>> -			angle += arctg[i];
>>> -		} else {
>>> -			tmp = ret.i + (ret.q >> i);
>>> -			ret.q -= ret.i >> i;
>>> -			ret.i = tmp;
>>> -			angle -= arctg[i];
>>> -		}
>>> -	}
>>> -
>>> -	ret.i *= signx;
>>> -	ret.q *= signx;
>>> -
>>> -	return ret;
>>> -}
>>> diff --git a/drivers/net/wireless/broadcom/b43/phy_common.h b/drivers/net/wireless/broadcom/b43/phy_common.h
>>> index 57a1ad8..4213cac 100644
>>> --- a/drivers/net/wireless/broadcom/b43/phy_common.h
>>> +++ b/drivers/net/wireless/broadcom/b43/phy_common.h
>>> @@ -7,13 +7,6 @@
>>>    struct b43_wldev;
>>> -/* Complex number using 2 32-bit signed integers */
>>> -struct b43_c32 { s32 i, q; };
>>> -
>>> -#define CORDIC_CONVERT(value)	(((value) >= 0) ? \
>>> -				 ((((value) >> 15) + 1) >> 1) : \
>>> -				 -((((-(value)) >> 15) + 1) >> 1))
>>> -
>>>    /* PHY register routing bits */
>>>    #define B43_PHYROUTE			0x0C00 /* PHY register routing bits mask */
>>>    #define  B43_PHYROUTE_BASE		0x0000 /* Base registers */
>>> @@ -450,6 +443,4 @@ bool b43_is_40mhz(struct b43_wldev *dev);
>>>    void b43_phy_force_clock(struct b43_wldev *dev, bool force);
>>> -struct b43_c32 b43_cordic(int theta);
>>> -
>>>    #endif /* LINUX_B43_PHY_COMMON_H_ */
>>> diff --git a/drivers/net/wireless/broadcom/b43/phy_lp.c b/drivers/net/wireless/broadcom/b43/phy_lp.c
>>> index 6922cbb..1718e3b 100644
>>> --- a/drivers/net/wireless/broadcom/b43/phy_lp.c
>>> +++ b/drivers/net/wireless/broadcom/b43/phy_lp.c
>>> @@ -23,6 +23,7 @@
>>>    */
>>> +#include <linux/cordic.h>
>>>    #include <linux/slab.h>
>>>    #include "b43.h"
>>> @@ -1780,9 +1781,9 @@ static void lpphy_start_tx_tone(struct b43_wldev *dev, s32 freq, u16 max)
>>>    {
>>>    	struct b43_phy_lp *lpphy = dev->phy.lp;
>>>    	u16 buf[64];
>>> -	int i, samples = 0, angle = 0;
>>> +	int i, samples = 0, theta = 0;
>>>    	int rotation = (((36 * freq) / 20) << 16) / 100;
>>> -	struct b43_c32 sample;
>>> +	struct cordic_iq sample;
>>>    	lpphy->tx_tone_freq = freq;
>>> @@ -1798,10 +1799,10 @@ static void lpphy_start_tx_tone(struct b43_wldev *dev, s32 freq, u16 max)
>>>    	}
>>>    	for (i = 0; i < samples; i++) {
>>> -		sample = b43_cordic(angle);
>>> -		angle += rotation;
>>> -		buf[i] = CORDIC_CONVERT((sample.i * max) & 0xFF) << 8;
>>> -		buf[i] |= CORDIC_CONVERT((sample.q * max) & 0xFF);
>>> +		sample = cordic_calc_iq(theta);
>>> +		theta += rotation;
>>> +		buf[i] = CORDIC_FLOAT((sample.i * max) & 0xFF) << 8;
>>> +		buf[i] |= CORDIC_FLOAT((sample.q * max) & 0xFF);
>>>    	}
>>>    	b43_lptab_write_bulk(dev, B43_LPTAB16(5, 0), samples, buf);
>>> diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
>>> index 44ab080..1f9378a 100644
>>> --- a/drivers/net/wireless/broadcom/b43/phy_n.c
>>> +++ b/drivers/net/wireless/broadcom/b43/phy_n.c
>>> @@ -23,6 +23,7 @@
>>>    */
>>> +#include <linux/cordic.h>
>>>    #include <linux/delay.h>
>>>    #include <linux/slab.h>
>>>    #include <linux/types.h>
>>> @@ -1513,7 +1514,7 @@ static void b43_radio_init2055(struct b43_wldev *dev)
>>>    /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/LoadSampleTable */
>>>    static int b43_nphy_load_samples(struct b43_wldev *dev,
>>> -					struct b43_c32 *samples, u16 len) {
>>> +					struct cordic_iq *samples, u16 len) {
>>>    	struct b43_phy_n *nphy = dev->phy.n;
>>>    	u16 i;
>>>    	u32 *data;
>>> @@ -1544,7 +1545,7 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
>>>    {
>>>    	int i;
>>>    	u16 bw, len, rot, angle;
>>> -	struct b43_c32 *samples;
>>> +	struct cordic_iq *samples;
>>>    	bw = b43_is_40mhz(dev) ? 40 : 20;
>>>    	len = bw << 3;
>>> @@ -1561,7 +1562,7 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
>>>    		len = bw << 1;
>>>    	}
>>> -	samples = kcalloc(len, sizeof(struct b43_c32), GFP_KERNEL);
>>> +	samples = kcalloc(len, sizeof(struct cordic_iq), GFP_KERNEL);
>>>    	if (!samples) {
>>>    		b43err(dev->wl, "allocation for samples generation failed\n");
>>>    		return 0;
>>> @@ -1570,10 +1571,10 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
>>>    	angle = 0;
>>>    	for (i = 0; i < len; i++) {
>>> -		samples[i] = b43_cordic(angle);
>>> +		samples[i] = cordic_calc_iq(angle);
>>>    		angle += rot;
>>> -		samples[i].q = CORDIC_CONVERT(samples[i].q * max);
>>> -		samples[i].i = CORDIC_CONVERT(samples[i].i * max);
>>> +		samples[i].q = CORDIC_FLOAT(samples[i].q * max);
>>> +		samples[i].i = CORDIC_FLOAT(samples[i].i * max);
>>>    	}
>>>    	i = b43_nphy_load_samples(dev, samples, len);
>>
>> There is a fundamental flaw in this patch. Routine b43_cordic() takes an
>> angle in degrees scaled by 2^16, whereas cordic_calc_iq() takes an angle in
>> degrees. For a given input, the two routines must get different answers. At
>> a minimum, the calculation of rot would need to remove the left shift of 16.
> 
> Thanks for the hint. I modified my "test harness" a bit to plot out values
> from -360 .. 360 and transformed the theta for b43_cordic argument using CORDIC_FIXED macro:
> 
> b43_cordic(CORDIC_FIXED(theta));
> cordic_calc_iq(theta);
> 
> Then I plotted the results and well.. they are not that pretty. While the results give
> identical answers between certain ranges of degrees, the cordic algorithm for b43 seems
> to be broken for certain ranges: (-270..-180 ; -90 .. 0; 90.. 180 and 270..360).
> 
> You can find my test harnesses here:
> 
> https://gist.github.com/plaes/284993a4fc65e0926d0628a11f0cf874

I found a problem with the b43 implementation. The local variables for that 
routine includes

         u32 angle = 0;

If one looks further down in the algorithm, if the reduced value of "theta" is 
less than 0, then "angle" should be negative. That causes the calculation to 
blow up. This explains why some ranges of angles got the same result for both 
routines. When that declaration is changed to "int angle = 0", the two routines 
give the same answer for all inputs.

My test setup has a hardware failure, thus I cannot test your patch, but I now 
believe it to be correct. Thus your first and third patches may be annotated with
ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

One thing that should be done is to fix the error in the b43 code for stable as 
it was introduced in 2.6.34. I propose adding the attached patched to your 
series placed between your current 2nd and 3rd patches so that the old kernels 
get fixed. Of course, your 3rd patch will need to be revised. If all 4 of the 
patches get submitted together there will be no problems with the timing. My 
change will exist for seconds in the mainline kernel, but it will get propagated 
back through stable.

Thanks,

Larry





















--------------A4EEE76D88D7EF2499287287
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
commit 986504540306 ("b43: make cordic common (LP-PHY and N-PHY need it)")
contains an error whereby a quantity declared u32 can in fact go negative.

This problem was detected by Priit Laes who is switching b43 to use the
routine in the library functions of the kernel.

Fixes: 986504540306 ("b43: make cordic common (LP-PHY and N-PHY need it)")
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


--------------A4EEE76D88D7EF2499287287--
