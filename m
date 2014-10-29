Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:64482 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbaJ2R5z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:57:55 -0400
Received: by mail-wi0-f177.google.com with SMTP id ex7so5316124wid.4
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:57:54 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 29/48] staging: vt6655: channel.c remove dead functions
Date: Wed, 29 Oct 2014 17:55:47 +0000
Message-Id: <1414605366-9335-30-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185804_070657_0C408759)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/channel.c | 113 ---------------------------------------
 drivers/staging/vt6655/channel.h |  13 -----
 2 files changed, 126 deletions(-)

diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index a7b39d4..41146eb 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -167,66 +167,6 @@ void vnt_init_bands(struct vnt_private *priv)
 }
 
 /**
- * is_channel_valid() - Is Country Channel Valid
- *  @ChanneIndex: defined as VT3253 MAC channel:
- *              1   = 2.4G channel 1
- *              2   = 2.4G channel 2
- *              ...
- *              14  = 2.4G channel 14
- *              15  = 4.9G channel 183
- *              16  = 4.9G channel 184
- *              .....
- *  Output: true if the specified 5GHz band is allowed to be used,
- *          false otherwise.
- * 4.9G => Ch 183, 184, 185, 187, 188, 189, 192, 196 (Value:15 ~ 22)
- *
- * 5G => Ch 7, 8, 9, 11, 12, 16, 34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64,
- * 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 149, 153, 157, 161, 165 (Value 23 ~ 56)
- */
-
-bool is_channel_valid(unsigned int ChannelIndex)
-{
-	bool bValid;
-
-	bValid = false;
-	/* If Channel Index is invalid, return invalid */
-	if ((ChannelIndex > CB_MAX_CHANNEL) ||
-	    (ChannelIndex == 0)) {
-		bValid = false;
-		goto exit;
-	}
-exit:
-	return bValid;
-}
-
-/**
- * channel_get_list() - Get Available Channel List for a given country
- * @CountryCode: The country code defined in country.h
- *
- * Output:
- *      pbyChannelTable:   (QWORD *) correspondent bit mask
- *                          of available channels
- *                          0x0000000000000001 means channel 1 is supported
- *                          0x0000000000000003 means channel 1,2 are supported
- *                          0x000000000000000F means channel 1,2,..15 are supported
- */
-
-bool channel_get_list(unsigned int uCountryCodeIdx, unsigned char *pbyChannelTable)
-{
-	return true;
-}
-
-unsigned char get_channel_mapping(void *pDeviceHandler, unsigned char byChannelNumber, CARD_PHY_TYPE ePhyType)
-{
-	return 0;
-}
-
-unsigned char get_channel_number(void *pDeviceHandler, unsigned char byChannelIndex)
-{
-	return 0;
-}
-
-/**
  * set_channel() - Set NIC media channel
  *
  * @pDeviceHandler: The adapter to be set
@@ -277,56 +217,3 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 
 	return bResult;
 }
-
-/**
- * set_country_info() - Set Channel Info of Country
- *
- * Return Value: none.
- *
- */
-
-void set_country_info(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, void *pIE)
-{
-}
-
-/**
- *
- * set_support_channels() - Set Support Channels IE defined in 802.11h
- *
- * @hDeviceContext: device structure point
- *
- * Return Value: none.
- *
- */
-
-unsigned char set_support_channels(void *pDeviceHandler, unsigned char *pbyIEs)
-{
-	unsigned char byLen = 0;
-	return byLen;
-}
-
-void set_country_IE(void *pDeviceHandler, void *pIE)
-{
-}
-
-bool get_channel_map_info(void *pDeviceHandler, unsigned int uChannelIndex,
-			  unsigned char *pbyChannelNumber, unsigned char *pbyMap)
-{
-	return 0;
-}
-
-void set_channel_map_info(void *pDeviceHandler, unsigned int uChannelIndex,
-			  unsigned char byMap)
-{
-}
-
-void clear_channel_map_info(void *pDeviceHandler)
-{
-
-}
-
-unsigned char auto_channel_select(void *pDeviceHandler, CARD_PHY_TYPE ePHYType)
-{
-	unsigned char byOptionChannel = 0;
-	return byOptionChannel;
-}
diff --git a/drivers/staging/vt6655/channel.h b/drivers/staging/vt6655/channel.h
index 78ab642..ee00f4e 100644
--- a/drivers/staging/vt6655/channel.h
+++ b/drivers/staging/vt6655/channel.h
@@ -28,19 +28,6 @@
 
 void vnt_init_bands(struct vnt_private *);
 
-bool is_channel_valid(unsigned int CountryCode);
-unsigned char get_channel_mapping(void *pDeviceHandler, unsigned char byChannelNumber, CARD_PHY_TYPE ePhyType);
-bool channel_get_list(unsigned int uCountryCodeIdx, unsigned char *pbyChannelTable);
-unsigned char get_channel_number(void *pDeviceHandler, unsigned char byChannelIndex);
 bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel);
-void set_country_info(void *pDeviceHandler, CARD_PHY_TYPE ePHYType, void *pIE);
-unsigned char set_support_channels(void *pDeviceHandler, unsigned char *pbyIEs);
-void set_country_IE(void *pDeviceHandler, void *pIE);
-bool get_channel_map_info(void *pDeviceHandler, unsigned int uChannelIndex,
-			  unsigned char *pbyChannelNumber, unsigned char *pbyMap);
-void set_channel_map_info(void *pDeviceHandler, unsigned int uChannelIndex,
-			  unsigned char byMap);
-void clear_channel_map_info(void *pDeviceHandler);
-unsigned char auto_channel_select(void *pDeviceHandler, CARD_PHY_TYPE ePHYType);
 
 #endif /* _CHANNEL_H_ */
-- 
2.1.0

