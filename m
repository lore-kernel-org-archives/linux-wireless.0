Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:1349 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYAAASP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2007 19:18:15 -0500
Received: by ug-out-1314.google.com with SMTP id z38so2349171ugc.16
        for <linux-wireless@vger.kernel.org>; Mon, 31 Dec 2007 16:18:14 -0800 (PST)
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ssb: add 'ssb_pcihost_set_power_state' function
Date: Tue, 1 Jan 2008 01:16:46 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mb@bu3sch.de
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200801010116.46190.mboton@gmail.com> (sfid-20080101_001837_027675_541C4672)
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the 'ssb_pcihost_set_power_state' function.

This function allows us to set the power state of a PCI device
(for example b44 ethernet device).=20

Signed-off-by: Miguel Bot=C3=B3n <mboton@gmail.com>

diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index a21ab29..aa70fd0 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -349,6 +349,13 @@ static inline void ssb_pcihost_unregister(struct p=
ci_driver *driver)
 {
 	pci_unregister_driver(driver);
 }
+
+static inline
+void ssb_pcihost_set_power_state(struct ssb_device *sdev, pci_power_t =
state)
+{
+	if (sdev->bus->bustype =3D=3D SSB_BUSTYPE_PCI)
+		pci_set_power_state(sdev->bus->host_pci, state);
+}
 #endif /* CONFIG_SSB_PCIHOST */
=20
=20

--=20
	Miguel Bot=C3=B3n
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
