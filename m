Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4B326B971
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 01:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785289322; cv=none; b=iKbVNzZuDZD9tmKGfLPcI+fwOCfrfhuc+kDL10Hr3wAE2oJs4oUw02B0q2oeY6bad22DkB6Mur4eYQR/urHbCgIlaNTyfjOsgJnaHrAk6+MBNYNydELDqNe/NhX95K0jUGQ81nZiK5niyaLdEmBaWW69W3ScPeXb8qref25uyE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785289322; c=relaxed/simple;
	bh=xgtwDLpMx75M6cJhml2wykY+v7WLNZg/BF0MgF4i6Fw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FrNmk1xaF8QGwKNozADN11xWBasLhFxYmqTE8qt9Pgx/F6QPOUqhw8do56A9GH8Tjuw/zRd2zHBuL+pSBp0WWIU9unkKwcQBlGETf02oaLDscT4rTfNjX9wC9VJzIrwvJTBPcRAvUCDnJR93PbJ+JDsfDbwVt1zewUDe6hxUAuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T04RaezX; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T04RaezX"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cacb8416a1so4945215ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 18:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785289321; x=1785894121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ml7zMT6FKGqHMb+nFINtzjOLq021Bu5npY5UipcxAyM=;
        b=T04RaezX0R5uN7cYyWckUujbc1gnHguchjRaArfVn2PKaep+FHNTTh5z8QmMmMYsQS
         IwlqjS3i9PtayZqlaYni8LL9Xwr/X6wwV8cfS19mgGswx65ASL521sCBMMziYZttY7UC
         Oe3h1NsDZ4pnsc4CjllU9g9+7c1DLW7T3y7FW2JOTZJyy03H4Ctq4h8kUlVdqT6oJVFb
         SkE/FrdBB4u5/ngV2eku0Xa6mBAr+Jq662+BGXcXouPXiN2TThK929IgzbziD2yQQdH9
         3aU7i0Sj0WIqpl2Bx0Q+/wVoHKpmh5/GrICyFcf/eGxLWfuvEoQeX0kUlUD8FTROESwM
         9Ukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785289321; x=1785894121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ml7zMT6FKGqHMb+nFINtzjOLq021Bu5npY5UipcxAyM=;
        b=RC9XUnqzdfnII5RxIFQee5Wtnoqy2SwkQENtGvMEvBOL+AvUapWzxr3gEq7TP8A8rI
         /3l6wPniGwqjz939D3vknuCg34+70svd6sR4kUyWpOd25W9wu0ptTQHQPrtg7ClsGOzg
         /XowOS/ugtfZkH681w9bUNNVOZsPF/6ikQISsOvXx3+4IHGPT/3X5XX3wjmENdPLgiXB
         mWDXIPNL1SWkq6G0mCa72XuQbofN34IaNoacSV08FxOOa14xUnciQ8D8qoH3mivV2p59
         cF8Sgc0eZfIZKXlmbjaWI+XW+GqcB/I2PXiiJ+Cp5nud8L1tIbQoc4CqsujDtk2KXzDv
         yzKg==
X-Forwarded-Encrypted: i=1; AHgh+RqUMAgQokdSYyYtgQ41CAwk+lY4Mo42yChJLg+u5RTxreii8RYkpTM09yN0BPKaVQ95MDefoqt/q71TvW2J6w==@vger.kernel.org
X-Gm-Message-State: AOJu0YycPhL1t4NwU33C18PMlMKFXqz/QUfjbFUffc0QT/pE1EMSpTMw
	+1PvOIOdz1SGkI94e1XmkL+dCXRx+8LhQPrCtR9iKKBw6NEB1RgGCZHc
X-Gm-Gg: AR+sD12sdtwGnxxhalEitRJ4bFeWB3rpzCGwr/8QctK7yd1F9FU3KIGECgY1o46x84/
	K3kkgQ9JAjTWwtZLCLqkHO0k6WpSL52IcsV1sOOUcN72yCPAe6PO3mLSJy7M6kNt6AJ/ZMutuiz
	9zK3cr+TPywvTXZUBy5Z6t3ljVlyXayII7gbhYWiEleK4MTAUdXn/Rtn7680Z7O2axmmrhrvZ3Q
	EvYCA1G87JbiKBYDvgdJzqsloDIxAH8+StP8iCJs9e9vs3xjM4UrYYS9jFtoUNRz342C1yRKR3u
	7IzV/dftG7JSUfbRlCSbTNQLIaApOJouZM3VvNtKawSc6NkxQ2hLHlVkjrb4EnSzmgPX2kODQvm
	5GA/qhkrEJJfeUZ+frCK65kdKcUxpTpDO7NlerfowlAob68SsFFBG9mqvhE2O2iDOD5l13tUqeY
	y0gV0MHheYSCkjPqlIkfWwBfGhaiWJCiSERs9DZkCh+QZtadrY+jZKOddAsnGMYhi2PJZX5Jy9D
	3orGLS7oGq5TcKBKmM=
X-Received: by 2002:a17:902:e78b:b0:2c7:f12d:5d37 with SMTP id d9443c01a7336-2d015b0d13cmr52744405ad.17.1785289320686;
        Tue, 28 Jul 2026 18:42:00 -0700 (PDT)
Received: from cyh-System-Product-Name.. ([129.227.183.200])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a15893sm3593545ad.4.2026.07.28.18.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 18:42:00 -0700 (PDT)
From: yhchen312@gmail.com
To: pkshih@realtek.com
Cc: damon.chen@realtek.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Yuhang.chen" <yhchen312@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] wifi: rtw89: pci: add .shutdown callback to stop rfkill polling on reboot
Date: Wed, 29 Jul 2026 09:41:42 +0800
Message-Id: <20260729014142.2746777-1-yhchen312@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <142c91dfc7334136a5dabc4f91504ec6@realtek.com>
References: <142c91dfc7334136a5dabc4f91504ec6@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Yuhang.chen" <yhchen312@gmail.com>

Since the hardware rfkill polling was introduced, arm64 platforms can
panic with an asynchronous SError during warm reboot:

  SError Interrupt on CPU8, code 0x00000000be000011 -- SError
  Workqueue: events_power_efficient rfkill_poll [rfkill]
    rtw89_pci_ops_read8+0x94/0x160 [rtw89_pci]
    rtw89_core_rfkill_poll+0x50/0x1e0 [rtw89_core]
    rtw89_ops_rfkill_poll+0x40/0x68 [rtw89_core]
    ieee80211_rfkill_poll+0x3c/0x70 [mac80211]
    cfg80211_rfkill_poll+0x40/0x2a0 [cfg80211]
    rfkill_poll+0x30/0x88 [rfkill]
  Kernel panic - not syncing: Asynchronous SError Interrupt

On the reboot path the kernel only runs device_shutdown(), which calls
each driver's .shutdown callback; .remove is not invoked.  The rtw89 PCI
driver had no .shutdown callback, so nothing stopped the rfkill polling
work while the platform was tearing the PCIe link down.  Once the link
is gone, the next MMIO read from the poll handler targets a
non-responding device and is reported as a fatal asynchronous SError on
arm64.

Add rtw89_pci_shutdown(), wired to all rtw89 PCI device drivers, which
sets a new RTW89_FLAG_SHUTDOWN flag (mirroring the USB
RTW89_FLAG_UNPLUGGED pattern).  When the flag is set,
rtw89_ops_rfkill_poll() returns early, so no MMIO read is issued to the
chip after shutdown begins and the SError no longer occurs.

This does not call the full .remove path from .shutdown, to keep the
shutdown handler minimal and avoid running the non-idempotent teardown
twice.

Fixes: 0b38e6277aed ("wifi: rtw89: add support for hardware rfkill")
Cc: stable@vger.kernel.org
Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Yuhang.chen <yhchen312@gmail.com>
---
v2: per Ping-Ke Shih's review [1], replace the rtw89_pci_remove() call
    from .shutdown with a flag-based approach (set RTW89_FLAG_SHUTDOWN
    and bail out early in rtw89_ops_rfkill_poll), and extend the fix to
    all rtw89 PCI device drivers instead of 8852BE only.

[1] https://lore.kernel.org/all/142c91dfc7334136a5dabc4f91504ec6@realtek.com/
---
 drivers/net/wireless/realtek/rtw89/core.h       |  1 +
 drivers/net/wireless/realtek/rtw89/mac80211.c   |  3 ++-
 drivers/net/wireless/realtek/rtw89/pci.c        | 13 +++++++++++++
 drivers/net/wireless/realtek/rtw89/pci.h        |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8851be.c  |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c  |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852be.c  |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852bte.c |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c  |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8922ae.c  |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8922de.c  |  1 +
 11 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 5547888d7e67..a85b9c39c257 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -5373,6 +5373,7 @@ enum rtw89_flags {
 	RTW89_FLAG_CHANGING_INTERFACE,
 	RTW89_FLAG_HW_RFKILL_STATE,
 	RTW89_FLAG_UNPLUGGED,
+	RTW89_FLAG_SHUTDOWN,
 
 	NUM_OF_RTW89_FLAGS,
 };
diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index aade5c5b79e8..9baedfde7085 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -1979,7 +1979,8 @@ static void rtw89_ops_rfkill_poll(struct ieee80211_hw *hw)
 	lockdep_assert_wiphy(hw->wiphy);
 
 	/* wl_disable GPIO get floating when entering LPS */
-	if (test_bit(RTW89_FLAG_RUNNING, rtwdev->flags))
+	if (test_bit(RTW89_FLAG_RUNNING, rtwdev->flags) ||
+	    test_bit(RTW89_FLAG_SHUTDOWN, rtwdev->flags))
 		return;
 
 	rtw89_core_rfkill_poll(rtwdev, false);
diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 102bae488180..61c54b52be1f 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -4874,6 +4874,19 @@ void rtw89_pci_remove(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(rtw89_pci_remove);
 
+void rtw89_pci_shutdown(struct pci_dev *pdev)
+{
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct rtw89_dev *rtwdev;
+
+	if (!hw)
+		return;
+
+	rtwdev = hw->priv;
+	set_bit(RTW89_FLAG_SHUTDOWN, rtwdev->flags);
+}
+EXPORT_SYMBOL(rtw89_pci_shutdown);
+
 MODULE_AUTHOR("Realtek Corporation");
 MODULE_DESCRIPTION("Realtek PCI 802.11ax wireless driver");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/realtek/rtw89/pci.h b/drivers/net/wireless/realtek/rtw89/pci.h
index c3f2d0df5846..0728120d721f 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -1751,6 +1751,7 @@ struct pci_device_id;
 
 int rtw89_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id);
 void rtw89_pci_remove(struct pci_dev *pdev);
+void rtw89_pci_shutdown(struct pci_dev *pdev);
 void rtw89_pci_basic_cfg(struct rtw89_dev *rtwdev, bool resume);
 void rtw89_pci_ops_reset(struct rtw89_dev *rtwdev);
 int rtw89_pci_ltr_set(struct rtw89_dev *rtwdev, bool en);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851be.c b/drivers/net/wireless/realtek/rtw89/rtw8851be.c
index 640672eb0d26..61e6c997b206 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851be.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851be.c
@@ -93,6 +93,7 @@ static struct pci_driver rtw89_8851be_driver = {
 	.id_table	= rtw89_8851be_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown	= rtw89_pci_shutdown,
 	.driver.pm	= &rtw89_pm_ops,
 	.err_handler    = &rtw89_pci_err_handler,
 };
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852ae.c b/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
index 64306cdc1ee4..e6fbcf75f1ad 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
@@ -95,6 +95,7 @@ static struct pci_driver rtw89_8852ae_driver = {
 	.id_table	= rtw89_8852ae_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown	= rtw89_pci_shutdown,
 	.driver.pm	= &rtw89_pm_ops,
 	.err_handler    = &rtw89_pci_err_handler,
 };
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852be.c b/drivers/net/wireless/realtek/rtw89/rtw8852be.c
index 5bc0a6a99d1d..25463342ac89 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852be.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852be.c
@@ -97,6 +97,7 @@ static struct pci_driver rtw89_8852be_driver = {
 	.id_table	= rtw89_8852be_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown	= rtw89_pci_shutdown,
 	.driver.pm	= &rtw89_pm_ops,
 	.err_handler    = &rtw89_pci_err_handler,
 };
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852bte.c b/drivers/net/wireless/realtek/rtw89/rtw8852bte.c
index 49a72ca835ac..bf22be739f39 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bte.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bte.c
@@ -99,6 +99,7 @@ static struct pci_driver rtw89_8852bte_driver = {
 	.id_table	= rtw89_8852bte_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown	= rtw89_pci_shutdown,
 	.driver.pm	= &rtw89_pm_ops,
 	.err_handler    = &rtw89_pci_err_handler,
 };
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852ce.c b/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
index 3c64c0539205..b8d4d9f02686 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
@@ -122,6 +122,7 @@ static struct pci_driver rtw89_8852ce_driver = {
 	.id_table	= rtw89_8852ce_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown	= rtw89_pci_shutdown,
 	.driver.pm	= &rtw89_pm_ops,
 	.err_handler    = &rtw89_pci_err_handler,
 };
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922ae.c b/drivers/net/wireless/realtek/rtw89/rtw8922ae.c
index 5527a8db393b..54bcd3f3d008 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922ae.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922ae.c
@@ -111,6 +111,7 @@ static struct pci_driver rtw89_8922ae_driver = {
 	.id_table	= rtw89_8922ae_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown	= rtw89_pci_shutdown,
 	.driver.pm	= &rtw89_pm_ops_be,
 	.err_handler    = &rtw89_pci_err_handler,
 };
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922de.c b/drivers/net/wireless/realtek/rtw89/rtw8922de.c
index a1a81c338be3..65476a35a323 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922de.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922de.c
@@ -111,6 +111,7 @@ static struct pci_driver rtw89_8922de_driver = {
 	.id_table	= rtw89_8922de_id_table,
 	.probe		= rtw89_pci_probe,
 	.remove		= rtw89_pci_remove,
+	.shutdown	= rtw89_pci_shutdown,
 	.driver.pm	= &rtw89_pm_ops_be,
 	.err_handler    = &rtw89_pci_err_handler,
 };
-- 
2.34.1

