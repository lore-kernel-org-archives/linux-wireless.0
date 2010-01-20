Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49926 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab0ATAGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 19:06:31 -0500
Received: by ewy19 with SMTP id 19so451288ewy.21
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 16:06:30 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Michael Buesch" <mb@bu3sch.de>
Subject: [RFC] How to store HT (40MHz) support
Date: Wed, 20 Jan 2010 01:06:37 +0100
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6s09akf9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In N-PHY code we have to make some decisions based on fact if band is 40MHz.

AFAIU when registering device, driver reports to mac80211 HT capability and this is not implemented yet. For that we will need to modify:
static struct ieee80211_supported_band b43_band_5GHz_nphy = { ... }

Then mac80211 can request switching to 40MHz usage using ieee80211_ops.config (which we handle in b43_op_config).

Is that correct? If so, is attached patch fine for storing 40MHz usage? We don't report HT support to mac80211 so it should not request 40MHz usage for now.




diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 9c5c7c9..641c7de 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3571,6 +3571,9 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
  	dev = wl->current_dev;
  	phy = &dev->phy;

+	if (phy->supports_40mhz)
+		phy->use_40mhz = conf_is_ht(conf);
+
  	b43_mac_suspend(dev);

  	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 9edd4e8..62c7028 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -212,6 +212,10 @@ struct b43_phy {
  	bool supports_2ghz;
  	bool supports_5ghz;

+	/* Band width support and usage */
+	bool supports_40mhz;
+	bool use_40mhz;
+
  	/* GMODE bit enabled? */
  	bool gmode;

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index e77f1f2..ed8f372 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1787,7 +1787,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,

  	b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x8AA9);

-	if (1 /* FIXME: the band width is 20 MHz */)
+	if (!dev->phy.use_40mhz)
  		freq = 2500;
  	else
  		freq = 5000;




-- 
Rafał
