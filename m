Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3326945DF52
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 11:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784804807; cv=none; b=cwnmA6GPeZedK145Tq8en107kjdit24dssGjPTWTlyme6RghZYYv6YZBRgbbU5LiPybmGfmHX+3oXdx/hCgrjIIDbwtShxqOx6z/GWdMBUJi4F3vOgqu2a8lDp6oe1QuuttgBj+kKDR+GnjPZ6RvsR0fNrX14RXcosJeUWgNq40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784804807; c=relaxed/simple;
	bh=XyK/F04jVT8nk097h3dRFP6Lizc2UTupl0iWR22iKyY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=DjTiap7yPxjl6hiLiWA0hNVohIaDzonQ8ZzUoWFzfCE1JSzEbKruX+QKivOBaumIkpyiS6lnQfwfn4Eep9vjLSs1qOZI9ac/ToZHOn0GZ/IfpH9H4Pfr/a6mhgJbMSlo/Hodh+mpqPVhdwHc6B13rvQ675tkrbFmSmt/grfbBg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=K/DQtkBk; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="K/DQtkBk"
Received: (wp-smtpd smtp.wp.pl 5017 invoked from network); 23 Jul 2026 13:06:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1784804801; bh=7IL1PALLM0bq4uPu+K4ySUVq4ePx+41rTG/vyE8+w4U=;
          h=From:To:Subject;
          b=K/DQtkBkfhi6Nal6NbhOS8zCXvGcZ3xWeozmbSBTNalKuvit7d3nZ08cObl7H1BrJ
           T+8v4WpdlY2PQRYonRZDwCKQFlZa1qGip5OnjNkd/QHgImOrJgaDjnZZmHsni9Awc8
           Haa+wif/3FqRAqKrLaIwUirW7ctrrPQpEFY8f+55MjZZgRJ7Aqh3YHNzb7YZCtC/Tq
           gACv/bJS0HEaeEYMCQuoW02jTPWmXJt5a7fKzeJknWFfC4XMpG7lMu+nBQvy7tO1+I
           gpMWVWt0807n9FNjji7QH8yaJX6R56pyNDpbeCLqsWcGXCBTJg6lS0Qr2lL0RNT0yx
           bLbEYLfaw5WDg==
Received: from 77-236-11-167.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.11.167])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 23 Jul 2026 13:06:41 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: rtl818x: initialize eeprom_93cx6 struct to zero
Date: Thu, 23 Jul 2026 13:06:40 +0200
Message-Id: <20260723110640.8588-1-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: f5b9cb95a285533866671dff001b0ff3
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [YbL3]                               

From: Stanislaw Gruszka <stf_xl@wp.pl>

Commit 7738a7ab9d12 ("misc: eeprom: eeprom_93cx6: Add quirk for extra
read clock cycle") added extra 'quirk' field to struct eeprom_93cx6.

Many existing users of eeprom_93cx6, including rtl818x drivers, allocate
the structure on the stack without initializing all fields. As a result,
the added quirk field has an undefined value and can randomly cause
reading wrong data from the EEPROM.

Fix by initializing the structures with {}.

Fixes: 7738a7ab9d12 ("misc: eeprom: eeprom_93cx6: Add quirk for extra read clock cycle")
Cc: stable@kernel.org # v6.13+
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c | 2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index 070c0431c482..4a5989172a5e 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -1652,7 +1652,7 @@ static void rtl8180_eeprom_register_write(struct eeprom_93cx6 *eeprom)
 
 static void rtl8180_eeprom_read(struct rtl8180_priv *priv)
 {
-	struct eeprom_93cx6 eeprom;
+	struct eeprom_93cx6 eeprom = {};
 	int eeprom_cck_table_adr;
 	u16 eeprom_val;
 	int i;
diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
index 1d21c468a236..a766712187f7 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -1445,7 +1445,7 @@ static int rtl8187_probe(struct usb_interface *intf,
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct ieee80211_hw *dev;
 	struct rtl8187_priv *priv;
-	struct eeprom_93cx6 eeprom;
+	struct eeprom_93cx6 eeprom = {};
 	struct ieee80211_channel *channel;
 	const char *chip_name;
 	u16 txpwr, reg;
-- 
2.50.1

