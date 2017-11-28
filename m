Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0166.hostedemail.com ([216.40.44.166]:41501 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752506AbdK1Q5j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Nov 2017 11:57:39 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave03.hostedemail.com (Postfix) with ESMTP id D695D18036D58
        for <linux-wireless@vger.kernel.org>; Tue, 28 Nov 2017 16:49:20 +0000 (UTC)
Message-ID: <1511887757.19952.38.camel@perches.com> (sfid-20171128_175742_614278_66858E9E)
Subject: drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c: Odd array
 size
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "Larry.Finger" <Larry.Finger@lwfinger.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 28 Nov 2017 08:49:17 -0800
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

61 entries in this table:

static const u8 OFDM_CONFIG[] = {
	0x10, 0x0F, 0x0A, 0x0C, 0x14, 0xFA, 0xFF, 0x50,
	0x00, 0x50, 0x00, 0x00, 0x00, 0x5C, 0x00, 0x00,
	0x40, 0x00, 0x40, 0x00, 0x00, 0x00, 0xA8, 0x26,
	0x32, 0x33, 0x06, 0xA5, 0x6F, 0x55, 0xC8, 0xBB,
	0x0A, 0xE1, 0x2C, 0x4A, 0x86, 0x83, 0x34, 0x00,
	0x4F, 0x24, 0x6F, 0xC2, 0x03, 0x40, 0x80, 0x00,
	0xC0, 0xC1, 0x58, 0xF1, 0x00, 0xC4, 0x90, 0x3e,
	0xD8, 0x3C, 0x7B, 0x10, 0x10
};

but only 60 written?

static void rtl8187se_write_ofdm_config(struct ieee80211_hw *dev)
{
	/* write OFDM_CONFIG table */
	int i;

	for (i = 0; i < 60; i++)
		rtl8225se_write_phy_ofdm(dev, i, OFDM_CONFIG[i]);

}

This is the only use of OFDM_CONFIG.

What is the defect here?

Should 60 be ARRAY_SIZE(OFDM_CONFIG) or should the array be shortened?

One too many entries or one too few a write?
My guess would be one too few a write.
