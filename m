Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbYCIVum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:50:42 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:50:41 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 02/24] rt2x00: Initialize TX control field in data entries
Date: Sun, 9 Mar 2008 22:38:54 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092238.55051.IvDoorn@gmail.com> (sfid-20080309_215045_796288_AFECF040)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

In the TX path, the driver didn't copy the TX control data structure. Thus, it
was invalid in the TX done handler, causing serious trouble and misbehaviour.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00pci.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00usb.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 1960d93..7867ec6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -67,6 +67,7 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	skbdesc->desc_len = queue->desc_size;
 	skbdesc->entry = entry;
 
+	memcpy(&priv_tx->control, control, sizeof(priv_tx->control));
 	memcpy(priv_tx->data, skb->data, skb->len);
 	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 512ff39..eec9111 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -206,6 +206,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	skbdesc->desc_len = queue->desc_size;
 	skbdesc->entry = entry;
 
+	memcpy(&priv_tx->control, control, sizeof(priv_tx->control));
 	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 
 	/*
-- 
1.5.4.3

