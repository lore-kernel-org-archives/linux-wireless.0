Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbYCIVvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:22 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:22 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 19/24] rt2x00: Always enable TSF ticking
Date: Sun, 9 Mar 2008 22:47:43 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092247.43406.IvDoorn@gmail.com> (sfid-20080309_215403_116275_43FFB016)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whatever mode we are in, according to the legacy drivers
we should always enable TSF ticking/counting.
We should also always enable the TBCN/TBTT field,
this field is only disabled during beacon regeneration.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 ++
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 ++
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 ++
 drivers/net/wireless/rt2x00/rt61pci.c   |    2 ++
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 ++
 5 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 70f711e..e2bb634 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -291,7 +291,9 @@ static void rt2400pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		 * Enable synchronisation.
 		 */
 		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, conf->sync);
+		rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index a46206c..4e312cb 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -294,7 +294,9 @@ static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		 * Enable synchronisation.
 		 */
 		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, conf->sync);
+		rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 43da93a..8dfebfd 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -343,7 +343,9 @@ static void rt2500usb_config_intf(struct rt2x00_dev *rt2x00dev,
 		rt2500usb_register_write(rt2x00dev, TXRX_CSR18, reg);
 
 		rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
+		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 1);
 		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, conf->sync);
+		rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 1);
 		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 62eff52..d11d3e5 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -343,7 +343,9 @@ static void rt61pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		 * Enable synchronisation.
 		 */
 		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, conf->sync);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index e0dd3ad..03a72ce 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -355,7 +355,9 @@ static void rt73usb_config_intf(struct rt2x00_dev *rt2x00dev,
 		 * Enable synchronisation.
 		 */
 		rt73usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, conf->sync);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 		rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 	}
 
-- 
1.5.4.3

