Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40588 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1C2Ixu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 04:53:50 -0400
Received: by wya21 with SMTP id 21so3548058wya.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 01:53:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D9144AC.7040705@lockie.ca>
References: <4D8E96B5.7090707@lockie.ca>
	<AANLkTimNtNruB5Maoa5EOkK_zJ35oEsP35-f8jvS88hm@mail.gmail.com>
	<4D9144AC.7040705@lockie.ca>
Date: Tue, 29 Mar 2011 14:23:49 +0530
Message-ID: <AANLkTinqRL6a7SNj+DgKVyerR5ShGyjUzwpnBDkv-Z-r@mail.gmail.com>
Subject: Re: what does this mean
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: James <bjlockie@lockie.ca>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 29, 2011 at 8:02 AM, James <bjlockie@lockie.ca> wrote:
> On 03/27/11 07:53, Mohammed Shafi wrote:
>> On Sun, Mar 27, 2011 at 7:15 AM, James <bjlockie@lockie.ca> wrote:
>>> I tried the 2011 03 26 compat-wireless and it gives this error when I
>>> try a scan (it finds some networks but I know there are more).
>>>
>>> sudo iw dev wlan0 scan | grep -i ssid
>>>
>>> ath: timeout (100000 us) on reg 0x9c20: 0x00000000 & 0x00000001 !=
>>> 0x00000001
>>> ath: Could not kill baseband RX
>> James, this is a fatal error.
> Is there anyway to increase the timeout or reset the hardware without
> rebooting?

this is the default timeout in hw.h
#define AH_WAIT_TIMEOUT             100000 /* (us) */

may be you can try increasing the timeout specifically for this

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 4361704..6d528ba 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -976,7 +976,7 @@ static bool ar5008_hw_rfbus_req(struct ath_hw *ah)
 {
        REG_WRITE(ah, AR_PHY_RFBUS_REQ, AR_PHY_RFBUS_REQ_EN);
        return ath9k_hw_wait(ah, AR_PHY_RFBUS_GRANT, AR_PHY_RFBUS_GRANT_EN,
-                          AR_PHY_RFBUS_GRANT_EN, AH_WAIT_TIMEOUT);
+                          AR_PHY_RFBUS_GRANT_EN, 1000000);
 }

and this is also there in ar9003_phy.c

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
