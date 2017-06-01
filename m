Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47075 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751152AbdFAD1e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 23:27:34 -0400
From: "Tobin C. Harding" <me@tobin.cc>
To: linux-wireless@vger.kernel.org
Cc: "Tobin C. Harding" <me@tobin.cc>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Tycho Andersen <tycho@tycho.ws>
Subject: [RFC 1/3] staging: ks7010: move WEXT files to sub directory
Date: Thu,  1 Jun 2017 13:27:06 +1000
Message-Id: <1496287628-16787-2-git-send-email-me@tobin.cc> (sfid-20170601_052808_673383_12AE76EE)
In-Reply-To: <1496287628-16787-1-git-send-email-me@tobin.cc>
References: <1496287628-16787-1-git-send-email-me@tobin.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current driver implements the WEXT interface. WEXT is in maintenance
mode, we need to re-write the driver using cfg80211. The current
driver is handy as a reference for the new implementation, we can keep
it in tree for now.

Move WEXT driver to sub directory, add dummy Makefile and Kconfig so
build completes successfully but does not process any files from the
WEXT directory.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 drivers/staging/ks7010/Kconfig              |    6 +-
 drivers/staging/ks7010/Makefile             |    3 -
 drivers/staging/ks7010/TODO                 |   36 -
 drivers/staging/ks7010/eap_packet.h         |  144 --
 drivers/staging/ks7010/ks7010_sdio.c        | 1079 ----------
 drivers/staging/ks7010/ks7010_sdio.h        |  164 --
 drivers/staging/ks7010/ks_hostif.c          | 2638 -----------------------
 drivers/staging/ks7010/ks_hostif.h          |  685 ------
 drivers/staging/ks7010/ks_wlan.h            |  514 -----
 drivers/staging/ks7010/ks_wlan_ioctl.h      |   67 -
 drivers/staging/ks7010/ks_wlan_net.c        | 2999 ---------------------------
 drivers/staging/ks7010/michael_mic.c        |  148 --
 drivers/staging/ks7010/michael_mic.h        |   25 -
 drivers/staging/ks7010/wext/Kconfig         |   10 +
 drivers/staging/ks7010/wext/Makefile        |    4 +
 drivers/staging/ks7010/wext/TODO            |   36 +
 drivers/staging/ks7010/wext/eap_packet.h    |  144 ++
 drivers/staging/ks7010/wext/ks7010_sdio.c   | 1079 ++++++++++
 drivers/staging/ks7010/wext/ks7010_sdio.h   |  164 ++
 drivers/staging/ks7010/wext/ks_hostif.c     | 2638 +++++++++++++++++++++++
 drivers/staging/ks7010/wext/ks_hostif.h     |  685 ++++++
 drivers/staging/ks7010/wext/ks_wlan.h       |  514 +++++
 drivers/staging/ks7010/wext/ks_wlan_ioctl.h |   67 +
 drivers/staging/ks7010/wext/ks_wlan_net.c   | 2999 +++++++++++++++++++++++++++
 drivers/staging/ks7010/wext/michael_mic.c   |  148 ++
 drivers/staging/ks7010/wext/michael_mic.h   |   25 +
 26 files changed, 8514 insertions(+), 8507 deletions(-)
 delete mode 100644 drivers/staging/ks7010/TODO
 delete mode 100644 drivers/staging/ks7010/eap_packet.h
 delete mode 100644 drivers/staging/ks7010/ks7010_sdio.c
 delete mode 100644 drivers/staging/ks7010/ks7010_sdio.h
 delete mode 100644 drivers/staging/ks7010/ks_hostif.c
 delete mode 100644 drivers/staging/ks7010/ks_hostif.h
 delete mode 100644 drivers/staging/ks7010/ks_wlan.h
 delete mode 100644 drivers/staging/ks7010/ks_wlan_ioctl.h
 delete mode 100644 drivers/staging/ks7010/ks_wlan_net.c
 delete mode 100644 drivers/staging/ks7010/michael_mic.c
 delete mode 100644 drivers/staging/ks7010/michael_mic.h
 create mode 100644 drivers/staging/ks7010/wext/Kconfig
 create mode 100644 drivers/staging/ks7010/wext/Makefile
 create mode 100644 drivers/staging/ks7010/wext/TODO
 create mode 100644 drivers/staging/ks7010/wext/eap_packet.h
 create mode 100644 drivers/staging/ks7010/wext/ks7010_sdio.c
 create mode 100644 drivers/staging/ks7010/wext/ks7010_sdio.h
 create mode 100644 drivers/staging/ks7010/wext/ks_hostif.c
 create mode 100644 drivers/staging/ks7010/wext/ks_hostif.h
 create mode 100644 drivers/staging/ks7010/wext/ks_wlan.h
 create mode 100644 drivers/staging/ks7010/wext/ks_wlan_ioctl.h
 create mode 100644 drivers/staging/ks7010/wext/ks_wlan_net.c
 create mode 100644 drivers/staging/ks7010/wext/michael_mic.c
 create mode 100644 drivers/staging/ks7010/wext/michael_mic.h

diff --git a/drivers/staging/ks7010/Kconfig b/drivers/staging/ks7010/Kconfig
index 0b92176..437b928 100644
--- a/drivers/staging/ks7010/Kconfig
+++ b/drivers/staging/ks7010/Kconfig
@@ -1,10 +1,6 @@
 config KS7010
 	tristate "KeyStream KS7010 SDIO support"
-	depends on MMC && WIRELESS
-	select WIRELESS_EXT
-	select WEXT_PRIV
-	select FW_LOADER
-	help
+	---help---
 	  This is a driver for KeyStream KS7010 based SDIO WIFI cards. It is
 	  found on at least later Spectec SDW-821 (FCC-ID "S2Y-WLAN-11G-K" only,
 	  sadly not FCC-ID "S2Y-WLAN-11B-G") and Spectec SDW-823 microSD cards.
diff --git a/drivers/staging/ks7010/Makefile b/drivers/staging/ks7010/Makefile
index 69fcf8d..f58cf9a 100644
--- a/drivers/staging/ks7010/Makefile
+++ b/drivers/staging/ks7010/Makefile
@@ -1,4 +1 @@
 obj-$(CONFIG_KS7010) += ks7010.o
-
-ccflags-y 	     += -DKS_WLAN_DEBUG=0
-ks7010-y	     := michael_mic.o ks_hostif.o ks_wlan_net.o ks7010_sdio.o
diff --git a/drivers/staging/ks7010/TODO b/drivers/staging/ks7010/TODO
deleted file mode 100644
index d393ca5..0000000
--- a/drivers/staging/ks7010/TODO
+++ /dev/null
@@ -1,36 +0,0 @@
-KS7010 Linux driver
-===================
-
-This driver is based on source code from the Ben Nanonote extra repository [1]
-which is based on the original v007 release from Renesas [2]. Some more
-background info about the chipset can be found here [3] and here [4]. Thank
-you to all which already participated in cleaning up the driver so far!
-
-[1] http://projects.qi-hardware.com/index.php/p/openwrt-packages/source/tree/master/ks7010/src
-[2] http://downloads.qi-hardware.com/software/ks7010_sdio_v007.tar.bz2
-[3] http://en.qi-hardware.com/wiki/Ben_NanoNote_Wi-Fi
-[4] https://wikidevi.com/wiki/Renesas
-
-TODO
-----
-
-First a few words what not to do (at least not blindly):
-
-- don't be overly strict with the 80 char limit. Only if it REALLY makes the
-  code more readable
-
-Now the TODOs:
-
-- fix codechecker warnings (checkpatch, sparse, smatch). But PLEASE make sure
-  that you are not only silencing the warning but really fixing code. You
-  should understand the change you submit.
-- fix the 'card removal' event when card is inserted when booting
-- check what other upstream wireless mechanisms can be used instead of the
-  custom ones here
-- replace custom Michael MIC implementation with the kernel
-  implementation. This task is only required for a *clean* WEXT interface.
-
-Please send any patches to:
-Greg Kroah-Hartman <gregkh@linuxfoundation.org>
-Wolfram Sang <wsa@the-dreams.de>
-Linux Driver Project Developer List <driverdev-devel@linuxdriverproject.org>
diff --git a/drivers/staging/ks7010/eap_packet.h b/drivers/staging/ks7010/eap_packet.h
deleted file mode 100644
index b2d25ef..0000000
--- a/drivers/staging/ks7010/eap_packet.h
+++ /dev/null
@@ -1,144 +0,0 @@
-#ifndef EAP_PACKET_H
-#define EAP_PACKET_H
-
-#include <linux/compiler.h>
-
-#define WBIT(n) (1 << (n))
-
-#ifndef ETH_ALEN
-#define ETH_ALEN 6
-#endif
-
-#define ETHER_HDR_SIZE 20
-
-struct ether_hdr {
-	unsigned char h_dest[ETH_ALEN];	/* destination eth addr */
-	unsigned char h_source[ETH_ALEN];	/* source ether addr    */
-	unsigned char h_dest_snap;
-	unsigned char h_source_snap;
-	unsigned char h_command;
-	unsigned char h_vendor_id[3];
-	unsigned short h_proto;	/* packet type ID field */
-#define ETHER_PROTOCOL_TYPE_EAP		0x888e
-#define ETHER_PROTOCOL_TYPE_IP		0x0800
-#define ETHER_PROTOCOL_TYPE_ARP		0x0806
-	/* followed by length octets of data */
-} __packed;
-
-struct ieee802_1x_hdr {
-	unsigned char version;
-	unsigned char type;
-	unsigned short length;
-	/* followed by length octets of data */
-} __packed;
-
-#define EAPOL_VERSION 2
-
-enum { IEEE802_1X_TYPE_EAP_PACKET = 0,
-	IEEE802_1X_TYPE_EAPOL_START = 1,
-	IEEE802_1X_TYPE_EAPOL_LOGOFF = 2,
-	IEEE802_1X_TYPE_EAPOL_KEY = 3,
-	IEEE802_1X_TYPE_EAPOL_ENCAPSULATED_ASF_ALERT = 4
-};
-
-enum { EAPOL_KEY_TYPE_RC4 = 1, EAPOL_KEY_TYPE_RSN = 2,
-	EAPOL_KEY_TYPE_WPA = 254
-};
-
-#define IEEE8021X_REPLAY_COUNTER_LEN 8
-#define IEEE8021X_KEY_SIGN_LEN 16
-#define IEEE8021X_KEY_IV_LEN 16
-
-#define IEEE8021X_KEY_INDEX_FLAG 0x80
-#define IEEE8021X_KEY_INDEX_MASK 0x03
-
-struct ieee802_1x_eapol_key {
-	unsigned char type;
-	unsigned short key_length;
-	/*
-	 * does not repeat within the life of the keying material used to
-	 * encrypt the Key field; 64-bit NTP timestamp MAY be used here
-	 */
-	unsigned char replay_counter[IEEE8021X_REPLAY_COUNTER_LEN];
-	unsigned char key_iv[IEEE8021X_KEY_IV_LEN]; /* cryptographically random
-						     * number
-						     */
-	unsigned char key_index;	/*
-					 * key flag in the most significant bit:
-					 * 0 = broadcast (default key),
-					 * 1 = unicast (key mapping key);
-					 * key index is in the 7 least
-					 * significant bits
-					 */
-	/*
-	 * HMAC-MD5 message integrity check computed with MS-MPPE-Send-Key as
-	 * the key
-	 */
-	unsigned char key_signature[IEEE8021X_KEY_SIGN_LEN];
-
-	/*
-	 * followed by key: if packet body length = 44 + key length, then the
-	 * key field (of key_length bytes) contains the key in encrypted form;
-	 * if packet body length = 44, key field is absent and key_length
-	 * represents the number of least significant octets from
-	 * MS-MPPE-Send-Key attribute to be used as the keying material;
-	 * RC4 key used in encryption = Key-IV + MS-MPPE-Recv-Key
-	 */
-} __packed;
-
-#define WPA_NONCE_LEN 32
-#define WPA_REPLAY_COUNTER_LEN 8
-
-struct wpa_eapol_key {
-	unsigned char type;
-	unsigned short key_info;
-	unsigned short key_length;
-	unsigned char replay_counter[WPA_REPLAY_COUNTER_LEN];
-	unsigned char key_nonce[WPA_NONCE_LEN];
-	unsigned char key_iv[16];
-	unsigned char key_rsc[8];
-	unsigned char key_id[8];	/* Reserved in IEEE 802.11i/RSN */
-	unsigned char key_mic[16];
-	unsigned short key_data_length;
-	/* followed by key_data_length bytes of key_data */
-} __packed;
-
-#define WPA_KEY_INFO_TYPE_MASK (WBIT(0) | WBIT(1) | WBIT(2))
-#define WPA_KEY_INFO_TYPE_HMAC_MD5_RC4 WBIT(0)
-#define WPA_KEY_INFO_TYPE_HMAC_SHA1_AES WBIT(1)
-#define WPA_KEY_INFO_KEY_TYPE WBIT(3)	/* 1 = Pairwise, 0 = Group key */
-/* bit4..5 is used in WPA, but is reserved in IEEE 802.11i/RSN */
-#define WPA_KEY_INFO_KEY_INDEX_MASK (WBIT(4) | WBIT(5))
-#define WPA_KEY_INFO_KEY_INDEX_SHIFT 4
-#define WPA_KEY_INFO_INSTALL WBIT(6)	/* pairwise */
-#define WPA_KEY_INFO_TXRX WBIT(6)	/* group */
-#define WPA_KEY_INFO_ACK WBIT(7)
-#define WPA_KEY_INFO_MIC WBIT(8)
-#define WPA_KEY_INFO_SECURE WBIT(9)
-#define WPA_KEY_INFO_ERROR WBIT(10)
-#define WPA_KEY_INFO_REQUEST WBIT(11)
-#define WPA_KEY_INFO_ENCR_KEY_DATA WBIT(12)	/* IEEE 802.11i/RSN only */
-
-#define WPA_CAPABILITY_PREAUTH WBIT(0)
-
-#define GENERIC_INFO_ELEM 0xdd
-#define RSN_INFO_ELEM 0x30
-
-enum {
-	REASON_UNSPECIFIED = 1,
-	REASON_DEAUTH_LEAVING = 3,
-	REASON_INVALID_IE = 13,
-	REASON_MICHAEL_MIC_FAILURE = 14,
-	REASON_4WAY_HANDSHAKE_TIMEOUT = 15,
-	REASON_GROUP_KEY_UPDATE_TIMEOUT = 16,
-	REASON_IE_IN_4WAY_DIFFERS = 17,
-	REASON_GROUP_CIPHER_NOT_VALID = 18,
-	REASON_PAIRWISE_CIPHER_NOT_VALID = 19,
-	REASON_AKMP_NOT_VALID = 20,
-	REASON_UNSUPPORTED_RSN_IE_VERSION = 21,
-	REASON_INVALID_RSN_IE_CAPAB = 22,
-	REASON_IEEE_802_1X_AUTH_FAILED = 23,
-	REASON_CIPHER_SUITE_REJECTED = 24
-};
-
-#endif /* EAP_PACKET_H */
diff --git a/drivers/staging/ks7010/ks7010_sdio.c b/drivers/staging/ks7010/ks7010_sdio.c
deleted file mode 100644
index c325f48..0000000
--- a/drivers/staging/ks7010/ks7010_sdio.c
+++ /dev/null
@@ -1,1079 +0,0 @@
-/*
- *   Driver for KeyStream, KS7010 based SDIO cards.
- *
- *   Copyright (C) 2006-2008 KeyStream Corp.
- *   Copyright (C) 2009 Renesas Technology Corp.
- *   Copyright (C) 2016 Sang Engineering, Wolfram Sang
- *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License version 2 as
- *   published by the Free Software Foundation.
- */
-
-#include <linux/firmware.h>
-#include <linux/mmc/card.h>
-#include <linux/mmc/sdio_func.h>
-#include <linux/workqueue.h>
-#include <linux/atomic.h>
-
-#include "ks_wlan.h"
-#include "ks_wlan_ioctl.h"
-#include "ks_hostif.h"
-#include "ks7010_sdio.h"
-
-#define KS7010_FUNC_NUM 1
-#define KS7010_IO_BLOCK_SIZE 512
-#define KS7010_MAX_CLOCK 25000000
-
-static const struct sdio_device_id ks7010_sdio_ids[] = {
-	{SDIO_DEVICE(SDIO_VENDOR_ID_KS_CODE_A, SDIO_DEVICE_ID_KS_7010)},
-	{SDIO_DEVICE(SDIO_VENDOR_ID_KS_CODE_B, SDIO_DEVICE_ID_KS_7010)},
-	{ /* all zero */ }
-};
-MODULE_DEVICE_TABLE(sdio, ks7010_sdio_ids);
-
-#define inc_txqhead(priv) \
-	(priv->tx_dev.qhead = (priv->tx_dev.qhead + 1) % TX_DEVICE_BUFF_SIZE)
-#define inc_txqtail(priv) \
-	(priv->tx_dev.qtail = (priv->tx_dev.qtail + 1) % TX_DEVICE_BUFF_SIZE)
-#define cnt_txqbody(priv) \
-	(((priv->tx_dev.qtail + TX_DEVICE_BUFF_SIZE) - (priv->tx_dev.qhead)) % TX_DEVICE_BUFF_SIZE)
-
-#define inc_rxqhead(priv) \
-	(priv->rx_dev.qhead = (priv->rx_dev.qhead + 1) % RX_DEVICE_BUFF_SIZE)
-#define inc_rxqtail(priv) \
-	(priv->rx_dev.qtail = (priv->rx_dev.qtail + 1) % RX_DEVICE_BUFF_SIZE)
-#define cnt_rxqbody(priv) \
-	(((priv->rx_dev.qtail + RX_DEVICE_BUFF_SIZE) - (priv->rx_dev.qhead)) % RX_DEVICE_BUFF_SIZE)
-
-/* Read single byte from device address into byte (CMD52) */
-static int ks7010_sdio_readb(struct ks_wlan_private *priv, unsigned int address,
-			     unsigned char *byte)
-{
-	struct sdio_func *func = priv->ks_sdio_card->func;
-	int ret;
-
-	*byte = sdio_readb(func, address, &ret);
-
-	return ret;
-}
-
-/* Read length bytes from device address into buffer (CMD53) */
-static int ks7010_sdio_read(struct ks_wlan_private *priv, unsigned int address,
-			    unsigned char *buffer, int length)
-{
-	struct sdio_func *func = priv->ks_sdio_card->func;
-
-	return sdio_memcpy_fromio(func, buffer, address, length);
-}
-
-/* Write single byte to device address (CMD52) */
-static int ks7010_sdio_writeb(struct ks_wlan_private *priv,
-			      unsigned int address, unsigned char byte)
-{
-	struct sdio_func *func = priv->ks_sdio_card->func;
-	int ret;
-
-	sdio_writeb(func, byte, address, &ret);
-
-	return ret;
-}
-
-/* Write length bytes to device address from buffer (CMD53) */
-static int ks7010_sdio_write(struct ks_wlan_private *priv, unsigned int address,
-			     unsigned char *buffer, int length)
-{
-	struct sdio_func *func = priv->ks_sdio_card->func;
-
-	return sdio_memcpy_toio(func, address, buffer, length);
-}
-
-static void ks_wlan_hw_sleep_doze_request(struct ks_wlan_private *priv)
-{
-	int ret;
-
-	DPRINTK(4, "\n");
-
-	/* clear request */
-	atomic_set(&priv->sleepstatus.doze_request, 0);
-
-	if (atomic_read(&priv->sleepstatus.status) == 0) {
-		ret = ks7010_sdio_writeb(priv, GCR_B, GCR_B_DOZE);
-		if (ret) {
-			DPRINTK(1, " error : GCR_B\n");
-			goto set_sleep_mode;
-		}
-		DPRINTK(3, "sleep_mode=SLP_SLEEP\n");
-		atomic_set(&priv->sleepstatus.status, 1);
-		priv->last_doze = jiffies;
-	} else {
-		DPRINTK(1, "sleep_mode=%d\n", priv->sleep_mode);
-	}
-
-set_sleep_mode:
-	priv->sleep_mode = atomic_read(&priv->sleepstatus.status);
-}
-
-static void ks_wlan_hw_sleep_wakeup_request(struct ks_wlan_private *priv)
-{
-	int ret;
-
-	DPRINTK(4, "\n");
-
-	/* clear request */
-	atomic_set(&priv->sleepstatus.wakeup_request, 0);
-
-	if (atomic_read(&priv->sleepstatus.status) == 1) {
-		ret = ks7010_sdio_writeb(priv, WAKEUP, WAKEUP_REQ);
-		if (ret) {
-			DPRINTK(1, " error : WAKEUP\n");
-			goto set_sleep_mode;
-		}
-		DPRINTK(4, "wake up : WAKEUP\n");
-		atomic_set(&priv->sleepstatus.status, 0);
-		priv->last_wakeup = jiffies;
-		++priv->wakeup_count;
-	} else {
-		DPRINTK(1, "sleep_mode=%d\n", priv->sleep_mode);
-	}
-
-set_sleep_mode:
-	priv->sleep_mode = atomic_read(&priv->sleepstatus.status);
-}
-
-void ks_wlan_hw_wakeup_request(struct ks_wlan_private *priv)
-{
-	int ret;
-
-	DPRINTK(4, "\n");
-	if (atomic_read(&priv->psstatus.status) == PS_SNOOZE) {
-		ret = ks7010_sdio_writeb(priv, WAKEUP, WAKEUP_REQ);
-		if (ret)
-			DPRINTK(1, " error : WAKEUP\n");
-		else
-			DPRINTK(4, "wake up : WAKEUP\n");
-
-		priv->last_wakeup = jiffies;
-		++priv->wakeup_count;
-	} else {
-		DPRINTK(1, "psstatus=%d\n",
-			atomic_read(&priv->psstatus.status));
-	}
-}
-
-static void _ks_wlan_hw_power_save(struct ks_wlan_private *priv)
-{
-	unsigned char byte;
-	int ret;
-
-	if (priv->reg.power_mgmt == POWER_MGMT_ACTIVE)
-		return;
-
-	if (priv->reg.operation_mode != MODE_INFRASTRUCTURE)
-		return;
-
-	if (!is_connect_status(priv->connect_status))
-		return;
-
-	if (priv->dev_state != DEVICE_STATE_SLEEP)
-		return;
-
-	if (atomic_read(&priv->psstatus.status) == PS_SNOOZE)
-		return;
-
-	DPRINTK(5, "\npsstatus.status=%d\npsstatus.confirm_wait=%d\npsstatus.snooze_guard=%d\ncnt_txqbody=%d\n",
-		atomic_read(&priv->psstatus.status),
-		atomic_read(&priv->psstatus.confirm_wait),
-		atomic_read(&priv->psstatus.snooze_guard),
-		cnt_txqbody(priv));
-
-	if (atomic_read(&priv->psstatus.confirm_wait) ||
-	    atomic_read(&priv->psstatus.snooze_guard) ||
-	    cnt_txqbody(priv)) {
-		queue_delayed_work(priv->wq, &priv->rw_dwork, 0);
-		return;
-	}
-
-	ret = ks7010_sdio_readb(priv, INT_PENDING, &byte);
-	if (ret) {
-		DPRINTK(1, " error : INT_PENDING\n");
-		goto queue_delayed_work;
-	}
-	if (byte)
-		goto queue_delayed_work;
-
-	ret = ks7010_sdio_writeb(priv, GCR_B, GCR_B_DOZE);
-	if (ret) {
-		DPRINTK(1, " error : GCR_B\n");
-		goto queue_delayed_work;
-	}
-	atomic_set(&priv->psstatus.status, PS_SNOOZE);
-	DPRINTK(3, "psstatus.status=PS_SNOOZE\n");
-
-	return;
-
-queue_delayed_work:
-	queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
-}
-
-int ks_wlan_hw_power_save(struct ks_wlan_private *priv)
-{
-	queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
-	return 0;
-}
-
-static int enqueue_txdev(struct ks_wlan_private *priv, unsigned char *p,
-			 unsigned long size,
-			 void (*complete_handler)(struct ks_wlan_private *priv,
-						  struct sk_buff *skb),
-			 struct sk_buff *skb)
-{
-	struct tx_device_buffer *sp;
-	int ret;
-
-	if (priv->dev_state < DEVICE_STATE_BOOT) {
-		ret = -EPERM;
-		goto err_complete;
-	}
-
-	if ((TX_DEVICE_BUFF_SIZE - 1) <= cnt_txqbody(priv)) {
-		DPRINTK(1, "tx buffer overflow\n");
-		ret = -EOVERFLOW;
-		goto err_complete;
-	}
-
-	sp = &priv->tx_dev.tx_dev_buff[priv->tx_dev.qtail];
-	sp->sendp = p;
-	sp->size = size;
-	sp->complete_handler = complete_handler;
-	sp->skb = skb;
-	inc_txqtail(priv);
-
-	return 0;
-
-err_complete:
-	kfree(p);
-	if (complete_handler)
-		(*complete_handler)(priv, skb);
-
-	return ret;
-}
-
-/* write data */
-static int write_to_device(struct ks_wlan_private *priv, unsigned char *buffer,
-			   unsigned long size)
-{
-	struct hostif_hdr *hdr;
-	int ret;
-
-	hdr = (struct hostif_hdr *)buffer;
-
-	DPRINTK(4, "size=%d\n", hdr->size);
-	if (hdr->event < HIF_DATA_REQ || HIF_REQ_MAX < hdr->event) {
-		DPRINTK(1, "unknown event=%04X\n", hdr->event);
-		return 0;
-	}
-
-	ret = ks7010_sdio_write(priv, DATA_WINDOW, buffer, size);
-	if (ret) {
-		DPRINTK(1, " write error : retval=%d\n", ret);
-		return ret;
-	}
-
-	ret = ks7010_sdio_writeb(priv, WRITE_STATUS, REG_STATUS_BUSY);
-	if (ret) {
-		DPRINTK(1, " error : WRITE_STATUS\n");
-		return ret;
-	}
-
-	return 0;
-}
-
-static void tx_device_task(struct ks_wlan_private *priv)
-{
-	struct tx_device_buffer *sp;
-	int ret;
-
-	DPRINTK(4, "\n");
-	if (cnt_txqbody(priv) <= 0 ||
-	    atomic_read(&priv->psstatus.status) == PS_SNOOZE)
-		return;
-
-	sp = &priv->tx_dev.tx_dev_buff[priv->tx_dev.qhead];
-	if (priv->dev_state >= DEVICE_STATE_BOOT) {
-		ret = write_to_device(priv, sp->sendp, sp->size);
-		if (ret) {
-			DPRINTK(1, "write_to_device error !!(%d)\n", ret);
-			queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
-			return;
-		}
-	}
-	kfree(sp->sendp);
-	if (sp->complete_handler)	/* TX Complete */
-		(*sp->complete_handler)(priv, sp->skb);
-	inc_txqhead(priv);
-
-	if (cnt_txqbody(priv) > 0)
-		queue_delayed_work(priv->wq, &priv->rw_dwork, 0);
-}
-
-int ks_wlan_hw_tx(struct ks_wlan_private *priv, void *p, unsigned long size,
-		  void (*complete_handler)(struct ks_wlan_private *priv,
-					   struct sk_buff *skb),
-		  struct sk_buff *skb)
-{
-	int result = 0;
-	struct hostif_hdr *hdr;
-
-	hdr = (struct hostif_hdr *)p;
-
-	if (hdr->event < HIF_DATA_REQ || HIF_REQ_MAX < hdr->event) {
-		DPRINTK(1, "unknown event=%04X\n", hdr->event);
-		return 0;
-	}
-
-	/* add event to hostt buffer */
-	priv->hostt.buff[priv->hostt.qtail] = hdr->event;
-	priv->hostt.qtail = (priv->hostt.qtail + 1) % SME_EVENT_BUFF_SIZE;
-
-	DPRINTK(4, "event=%04X\n", hdr->event);
-	spin_lock(&priv->tx_dev.tx_dev_lock);
-	result = enqueue_txdev(priv, p, size, complete_handler, skb);
-	spin_unlock(&priv->tx_dev.tx_dev_lock);
-
-	if (cnt_txqbody(priv) > 0)
-		queue_delayed_work(priv->wq, &priv->rw_dwork, 0);
-
-	return result;
-}
-
-static void rx_event_task(unsigned long dev)
-{
-	struct ks_wlan_private *priv = (struct ks_wlan_private *)dev;
-	struct rx_device_buffer *rp;
-
-	DPRINTK(4, "\n");
-
-	if (cnt_rxqbody(priv) > 0 && priv->dev_state >= DEVICE_STATE_BOOT) {
-		rp = &priv->rx_dev.rx_dev_buff[priv->rx_dev.qhead];
-		hostif_receive(priv, rp->data, rp->size);
-		inc_rxqhead(priv);
-
-		if (cnt_rxqbody(priv) > 0)
-			tasklet_schedule(&priv->rx_bh_task);
-	}
-}
-
-static void ks_wlan_hw_rx(struct ks_wlan_private *priv, uint16_t size)
-{
-	int ret;
-	struct rx_device_buffer *rx_buffer;
-	struct hostif_hdr *hdr;
-	unsigned short event = 0;
-
-	DPRINTK(4, "\n");
-
-	/* receive data */
-	if (cnt_rxqbody(priv) >= (RX_DEVICE_BUFF_SIZE - 1)) {
-		DPRINTK(1, "rx buffer overflow\n");
-		return;
-	}
-	rx_buffer = &priv->rx_dev.rx_dev_buff[priv->rx_dev.qtail];
-
-	ret = ks7010_sdio_read(priv, DATA_WINDOW, &rx_buffer->data[0],
-			       hif_align_size(size));
-	if (ret)
-		return;
-
-	/* length check */
-	if (size > 2046 || size == 0) {
-#ifdef KS_WLAN_DEBUG
-		if (KS_WLAN_DEBUG > 5)
-			print_hex_dump_bytes("INVALID DATA dump: ",
-					     DUMP_PREFIX_OFFSET,
-					     rx_buffer->data, 32);
-#endif
-		ret = ks7010_sdio_writeb(priv, READ_STATUS, REG_STATUS_IDLE);
-		if (ret)
-			DPRINTK(1, " error : READ_STATUS\n");
-
-		/* length check fail */
-		return;
-	}
-
-	hdr = (struct hostif_hdr *)&rx_buffer->data[0];
-	rx_buffer->size = le16_to_cpu(hdr->size) + sizeof(hdr->size);
-	event = hdr->event;
-	inc_rxqtail(priv);
-
-	ret = ks7010_sdio_writeb(priv, READ_STATUS, REG_STATUS_IDLE);
-	if (ret)
-		DPRINTK(1, " error : READ_STATUS\n");
-
-	if (atomic_read(&priv->psstatus.confirm_wait)) {
-		if (IS_HIF_CONF(event)) {
-			DPRINTK(4, "IS_HIF_CONF true !!\n");
-			atomic_dec(&priv->psstatus.confirm_wait);
-		}
-	}
-
-	tasklet_schedule(&priv->rx_bh_task);
-}
-
-static void ks7010_rw_function(struct work_struct *work)
-{
-	struct ks_wlan_private *priv;
-	unsigned char byte;
-	int ret;
-
-	priv = container_of(work, struct ks_wlan_private, rw_dwork.work);
-
-	DPRINTK(4, "\n");
-
-	/* wait after DOZE */
-	if (time_after(priv->last_doze + ((30 * HZ) / 1000), jiffies)) {
-		DPRINTK(4, "wait after DOZE\n");
-		queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
-		return;
-	}
-
-	/* wait after WAKEUP */
-	while (time_after(priv->last_wakeup + ((30 * HZ) / 1000), jiffies)) {
-		DPRINTK(4, "wait after WAKEUP\n");
-		dev_info(&priv->ks_sdio_card->func->dev,
-			 "wake: %lu %lu\n",
-			 priv->last_wakeup + (30 * HZ) / 1000,
-				jiffies);
-		msleep(30);
-	}
-
-	sdio_claim_host(priv->ks_sdio_card->func);
-
-	/* power save wakeup */
-	if (atomic_read(&priv->psstatus.status) == PS_SNOOZE) {
-		if (cnt_txqbody(priv) > 0) {
-			ks_wlan_hw_wakeup_request(priv);
-			queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
-		}
-		goto release_host;
-	}
-
-	/* sleep mode doze */
-	if (atomic_read(&priv->sleepstatus.doze_request) == 1) {
-		ks_wlan_hw_sleep_doze_request(priv);
-		goto release_host;
-	}
-	/* sleep mode wakeup */
-	if (atomic_read(&priv->sleepstatus.wakeup_request) == 1) {
-		ks_wlan_hw_sleep_wakeup_request(priv);
-		goto release_host;
-	}
-
-	/* read (WriteStatus/ReadDataSize FN1:00_0014) */
-	ret = ks7010_sdio_readb(priv, WSTATUS_RSIZE, &byte);
-	if (ret) {
-		DPRINTK(1, " error : WSTATUS_RSIZE psstatus=%d\n",
-			atomic_read(&priv->psstatus.status));
-		goto release_host;
-	}
-	DPRINTK(4, "WSTATUS_RSIZE=%02X\n", byte);
-
-	if (byte & RSIZE_MASK) {	/* Read schedule */
-		ks_wlan_hw_rx(priv, (uint16_t)((byte & RSIZE_MASK) << 4));
-	}
-	if ((byte & WSTATUS_MASK))
-		tx_device_task(priv);
-
-	_ks_wlan_hw_power_save(priv);
-
-release_host:
-	sdio_release_host(priv->ks_sdio_card->func);
-}
-
-static void ks_sdio_interrupt(struct sdio_func *func)
-{
-	int ret;
-	struct ks_sdio_card *card;
-	struct ks_wlan_private *priv;
-	unsigned char status, rsize, byte;
-
-	card = sdio_get_drvdata(func);
-	priv = card->priv;
-	DPRINTK(4, "\n");
-
-	if (priv->dev_state < DEVICE_STATE_BOOT)
-		goto queue_delayed_work;
-
-	ret = ks7010_sdio_readb(priv, INT_PENDING, &status);
-	if (ret) {
-		DPRINTK(1, "error : INT_PENDING\n");
-		goto queue_delayed_work;
-	}
-	DPRINTK(4, "INT_PENDING=%02X\n", status);
-
-	/* schedule task for interrupt status */
-	/* bit7 -> Write General Communication B register */
-	/* read (General Communication B register) */
-	/* bit5 -> Write Status Idle */
-	/* bit2 -> Read Status Busy  */
-	if (status & INT_GCR_B ||
-	    atomic_read(&priv->psstatus.status) == PS_SNOOZE) {
-		ret = ks7010_sdio_readb(priv, GCR_B, &byte);
-		if (ret) {
-			DPRINTK(1, " error : GCR_B\n");
-			goto queue_delayed_work;
-		}
-		if (byte == GCR_B_ACTIVE) {
-			if (atomic_read(&priv->psstatus.status) == PS_SNOOZE) {
-				atomic_set(&priv->psstatus.status, PS_WAKEUP);
-				priv->wakeup_count = 0;
-			}
-			complete(&priv->psstatus.wakeup_wait);
-		}
-	}
-
-	do {
-		/* read (WriteStatus/ReadDataSize FN1:00_0014) */
-		ret = ks7010_sdio_readb(priv, WSTATUS_RSIZE, &byte);
-		if (ret) {
-			DPRINTK(1, " error : WSTATUS_RSIZE\n");
-			goto queue_delayed_work;
-		}
-		DPRINTK(4, "WSTATUS_RSIZE=%02X\n", byte);
-		rsize = byte & RSIZE_MASK;
-		if (rsize != 0)		/* Read schedule */
-			ks_wlan_hw_rx(priv, (uint16_t)(rsize << 4));
-
-		if (byte & WSTATUS_MASK) {
-			if (atomic_read(&priv->psstatus.status) == PS_SNOOZE) {
-				if (cnt_txqbody(priv)) {
-					ks_wlan_hw_wakeup_request(priv);
-					queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
-					return;
-				}
-			} else {
-				tx_device_task(priv);
-			}
-		}
-	} while (rsize);
-
-queue_delayed_work:
-	queue_delayed_work(priv->wq, &priv->rw_dwork, 0);
-}
-
-static int trx_device_init(struct ks_wlan_private *priv)
-{
-	priv->tx_dev.qhead = 0;
-	priv->tx_dev.qtail = 0;
-
-	priv->rx_dev.qhead = 0;
-	priv->rx_dev.qtail = 0;
-
-	spin_lock_init(&priv->tx_dev.tx_dev_lock);
-	spin_lock_init(&priv->rx_dev.rx_dev_lock);
-
-	tasklet_init(&priv->rx_bh_task, rx_event_task, (unsigned long)priv);
-
-	return 0;
-}
-
-static void trx_device_exit(struct ks_wlan_private *priv)
-{
-	struct tx_device_buffer *sp;
-
-	/* tx buffer clear */
-	while (cnt_txqbody(priv) > 0) {
-		sp = &priv->tx_dev.tx_dev_buff[priv->tx_dev.qhead];
-		kfree(sp->sendp);
-		if (sp->complete_handler)	/* TX Complete */
-			(*sp->complete_handler)(priv, sp->skb);
-		inc_txqhead(priv);
-	}
-
-	tasklet_kill(&priv->rx_bh_task);
-}
-
-static int ks7010_sdio_update_index(struct ks_wlan_private *priv, u32 index)
-{
-	int ret;
-	unsigned char *data_buf;
-
-	data_buf = kmalloc(sizeof(u32), GFP_KERNEL);
-	if (!data_buf)
-		return -ENOMEM;
-
-	memcpy(data_buf, &index, sizeof(index));
-	ret = ks7010_sdio_write(priv, WRITE_INDEX, data_buf, sizeof(index));
-	if (ret)
-		goto err_free_data_buf;
-
-	ret = ks7010_sdio_write(priv, READ_INDEX, data_buf, sizeof(index));
-	if (ret)
-		goto err_free_data_buf;
-
-	return 0;
-
-err_free_data_buf:
-	kfree(data_buf);
-
-	return ret;
-}
-
-#define ROM_BUFF_SIZE (64 * 1024)
-static int ks7010_sdio_data_compare(struct ks_wlan_private *priv, u32 address,
-				    unsigned char *data, unsigned int size)
-{
-	int ret;
-	unsigned char *read_buf;
-
-	read_buf = kmalloc(ROM_BUFF_SIZE, GFP_KERNEL);
-	if (!read_buf)
-		return -ENOMEM;
-
-	ret = ks7010_sdio_read(priv, address, read_buf, size);
-	if (ret)
-		goto err_free_read_buf;
-
-	if (memcmp(data, read_buf, size) != 0) {
-		ret = -EIO;
-		DPRINTK(0, "data compare error (%d)\n", ret);
-		goto err_free_read_buf;
-	}
-
-	return 0;
-
-err_free_read_buf:
-	kfree(read_buf);
-
-	return ret;
-}
-
-static int ks7010_upload_firmware(struct ks_sdio_card *card)
-{
-	struct ks_wlan_private *priv = card->priv;
-	unsigned int size, offset, n = 0;
-	unsigned char *rom_buf;
-	unsigned char byte = 0;
-	int ret;
-	unsigned int length;
-	const struct firmware *fw_entry = NULL;
-
-	rom_buf = kmalloc(ROM_BUFF_SIZE, GFP_KERNEL);
-	if (!rom_buf)
-		return -ENOMEM;
-
-	sdio_claim_host(card->func);
-
-	/* Firmware running ? */
-	ret = ks7010_sdio_readb(priv, GCR_A, &byte);
-	if (byte == GCR_A_RUN) {
-		DPRINTK(0, "MAC firmware running ...\n");
-		goto release_host_and_free;
-	}
-
-	ret = request_firmware(&fw_entry, ROM_FILE,
-			       &priv->ks_sdio_card->func->dev);
-	if (ret)
-		goto release_host_and_free;
-
-	length = fw_entry->size;
-
-	n = 0;
-	do {
-		if (length >= ROM_BUFF_SIZE) {
-			size = ROM_BUFF_SIZE;
-			length = length - ROM_BUFF_SIZE;
-		} else {
-			size = length;
-			length = 0;
-		}
-		DPRINTK(4, "size = %d\n", size);
-		if (size == 0)
-			break;
-		memcpy(rom_buf, fw_entry->data + n, size);
-
-		offset = n;
-		ret = ks7010_sdio_update_index(priv, KS7010_IRAM_ADDRESS + offset);
-		if (ret)
-			goto release_firmware;
-
-		ret = ks7010_sdio_write(priv, DATA_WINDOW, rom_buf, size);
-		if (ret)
-			goto release_firmware;
-
-		ret = ks7010_sdio_data_compare(priv, DATA_WINDOW, rom_buf, size);
-		if (ret)
-			goto release_firmware;
-
-		n += size;
-
-	} while (size);
-
-	ret = ks7010_sdio_writeb(priv, GCR_A, GCR_A_REMAP);
-	if (ret)
-		goto release_firmware;
-
-	DPRINTK(4, " REMAP Request : GCR_A\n");
-
-	/* Firmware running check */
-	for (n = 0; n < 50; ++n) {
-		mdelay(10);	/* wait_ms(10); */
-		ret = ks7010_sdio_readb(priv, GCR_A, &byte);
-		if (ret)
-			goto release_firmware;
-
-		if (byte == GCR_A_RUN)
-			break;
-	}
-	DPRINTK(4, "firmware wakeup (%d)!!!!\n", n);
-	if ((50) <= n) {
-		DPRINTK(1, "firmware can't start\n");
-		ret = -EIO;
-		goto release_firmware;
-	}
-
-	ret = 0;
-
- release_firmware:
-	release_firmware(fw_entry);
- release_host_and_free:
-	sdio_release_host(card->func);
-	kfree(rom_buf);
-
-	return ret;
-}
-
-static void ks7010_card_init(struct ks_wlan_private *priv)
-{
-	DPRINTK(5, "\ncard_init_task()\n");
-
-	init_completion(&priv->confirm_wait);
-
-	DPRINTK(5, "init_completion()\n");
-
-	/* get mac address & firmware version */
-	hostif_sme_enqueue(priv, SME_START);
-
-	DPRINTK(5, "hostif_sme_enqueu()\n");
-
-	if (!wait_for_completion_interruptible_timeout
-	    (&priv->confirm_wait, 5 * HZ)) {
-		DPRINTK(1, "wait time out!! SME_START\n");
-	}
-
-	if (priv->mac_address_valid && priv->version_size != 0)
-		priv->dev_state = DEVICE_STATE_PREINIT;
-
-	hostif_sme_enqueue(priv, SME_GET_EEPROM_CKSUM);
-
-	/* load initial wireless parameter */
-	hostif_sme_enqueue(priv, SME_STOP_REQUEST);
-
-	hostif_sme_enqueue(priv, SME_RTS_THRESHOLD_REQUEST);
-	hostif_sme_enqueue(priv, SME_FRAGMENTATION_THRESHOLD_REQUEST);
-
-	hostif_sme_enqueue(priv, SME_WEP_INDEX_REQUEST);
-	hostif_sme_enqueue(priv, SME_WEP_KEY1_REQUEST);
-	hostif_sme_enqueue(priv, SME_WEP_KEY2_REQUEST);
-	hostif_sme_enqueue(priv, SME_WEP_KEY3_REQUEST);
-	hostif_sme_enqueue(priv, SME_WEP_KEY4_REQUEST);
-
-	hostif_sme_enqueue(priv, SME_WEP_FLAG_REQUEST);
-	hostif_sme_enqueue(priv, SME_RSN_ENABLED_REQUEST);
-	hostif_sme_enqueue(priv, SME_MODE_SET_REQUEST);
-	hostif_sme_enqueue(priv, SME_START_REQUEST);
-
-	if (!wait_for_completion_interruptible_timeout
-	    (&priv->confirm_wait, 5 * HZ)) {
-		DPRINTK(1, "wait time out!! wireless parameter set\n");
-	}
-
-	if (priv->dev_state >= DEVICE_STATE_PREINIT) {
-		DPRINTK(1, "DEVICE READY!!\n");
-		priv->dev_state = DEVICE_STATE_READY;
-	} else {
-		DPRINTK(1, "dev_state=%d\n", priv->dev_state);
-	}
-}
-
-static void ks7010_init_defaults(struct ks_wlan_private *priv)
-{
-	priv->reg.tx_rate = TX_RATE_AUTO;
-	priv->reg.preamble = LONG_PREAMBLE;
-	priv->reg.power_mgmt = POWER_MGMT_ACTIVE;
-	priv->reg.scan_type = ACTIVE_SCAN;
-	priv->reg.beacon_lost_count = 20;
-	priv->reg.rts = 2347UL;
-	priv->reg.fragment = 2346UL;
-	priv->reg.phy_type = D_11BG_COMPATIBLE_MODE;
-	priv->reg.cts_mode = CTS_MODE_FALSE;
-	priv->reg.rate_set.body[11] = TX_RATE_54M;
-	priv->reg.rate_set.body[10] = TX_RATE_48M;
-	priv->reg.rate_set.body[9] = TX_RATE_36M;
-	priv->reg.rate_set.body[8] = TX_RATE_18M;
-	priv->reg.rate_set.body[7] = TX_RATE_9M;
-	priv->reg.rate_set.body[6] = TX_RATE_24M | BASIC_RATE;
-	priv->reg.rate_set.body[5] = TX_RATE_12M | BASIC_RATE;
-	priv->reg.rate_set.body[4] = TX_RATE_6M | BASIC_RATE;
-	priv->reg.rate_set.body[3] = TX_RATE_11M | BASIC_RATE;
-	priv->reg.rate_set.body[2] = TX_RATE_5M | BASIC_RATE;
-	priv->reg.rate_set.body[1] = TX_RATE_2M | BASIC_RATE;
-	priv->reg.rate_set.body[0] = TX_RATE_1M | BASIC_RATE;
-	priv->reg.tx_rate = TX_RATE_FULL_AUTO;
-	priv->reg.rate_set.size = 12;
-}
-
-static int ks7010_sdio_probe(struct sdio_func *func,
-			     const struct sdio_device_id *device)
-{
-	struct ks_wlan_private *priv;
-	struct ks_sdio_card *card;
-	struct net_device *netdev;
-	unsigned char byte;
-	int ret;
-
-	DPRINTK(5, "ks7010_sdio_probe()\n");
-
-	priv = NULL;
-	netdev = NULL;
-
-	card = kzalloc(sizeof(*card), GFP_KERNEL);
-	if (!card)
-		return -ENOMEM;
-
-	card->func = func;
-
-	sdio_claim_host(func);
-
-	ret = sdio_set_block_size(func, KS7010_IO_BLOCK_SIZE);
-	DPRINTK(5, "multi_block=%d sdio_set_block_size()=%d %d\n",
-		func->card->cccr.multi_block, func->cur_blksize, ret);
-
-	ret = sdio_enable_func(func);
-	DPRINTK(5, "sdio_enable_func() %d\n", ret);
-	if (ret)
-		goto err_free_card;
-
-	/* interrupt disable */
-	sdio_writeb(func, 0, INT_ENABLE, &ret);
-	if (ret)
-		goto err_free_card;
-	sdio_writeb(func, 0xff, INT_PENDING, &ret);
-	if (ret)
-		goto err_disable_func;
-
-	/* setup interrupt handler */
-	ret = sdio_claim_irq(func, ks_sdio_interrupt);
-	if (ret)
-		goto err_disable_func;
-
-	sdio_release_host(func);
-
-	sdio_set_drvdata(func, card);
-
-	DPRINTK(5, "class = 0x%X, vendor = 0x%X, device = 0x%X\n",
-		func->class, func->vendor, func->device);
-
-	/* private memory allocate */
-	netdev = alloc_etherdev(sizeof(*priv));
-	if (!netdev) {
-		dev_err(&card->func->dev, "ks7010 : Unable to alloc new net device\n");
-		goto err_release_irq;
-	}
-	if (dev_alloc_name(netdev, "wlan%d") < 0) {
-		dev_err(&card->func->dev,
-			"ks7010 :  Couldn't get name!\n");
-		goto err_free_netdev;
-	}
-
-	priv = netdev_priv(netdev);
-
-	card->priv = priv;
-	SET_NETDEV_DEV(netdev, &card->func->dev);	/* for create sysfs symlinks */
-
-	/* private memory initialize */
-	priv->ks_sdio_card = card;
-
-	priv->dev_state = DEVICE_STATE_PREBOOT;
-	priv->net_dev = netdev;
-	priv->firmware_version[0] = '\0';
-	priv->version_size = 0;
-	priv->last_doze = jiffies;
-	priv->last_wakeup = jiffies;
-	memset(&priv->nstats, 0, sizeof(priv->nstats));
-	memset(&priv->wstats, 0, sizeof(priv->wstats));
-
-	/* sleep mode */
-	atomic_set(&priv->sleepstatus.doze_request, 0);
-	atomic_set(&priv->sleepstatus.wakeup_request, 0);
-	atomic_set(&priv->sleepstatus.wakeup_request, 0);
-
-	trx_device_init(priv);
-	hostif_init(priv);
-	ks_wlan_net_start(netdev);
-
-	ks7010_init_defaults(priv);
-
-	ret = ks7010_upload_firmware(card);
-	if (ret) {
-		dev_err(&card->func->dev,
-			"ks7010: firmware load failed !! return code = %d\n",
-			 ret);
-		goto err_free_netdev;
-	}
-
-	/* interrupt setting */
-	/* clear Interrupt status write (ARMtoSD_InterruptPending FN1:00_0024) */
-	sdio_claim_host(func);
-	ret = ks7010_sdio_writeb(priv, INT_PENDING, 0xff);
-	sdio_release_host(func);
-	if (ret)
-		DPRINTK(1, " error : INT_PENDING\n");
-
-	/* enable ks7010sdio interrupt */
-	byte = (INT_GCR_B | INT_READ_STATUS | INT_WRITE_STATUS);
-	sdio_claim_host(func);
-	ret = ks7010_sdio_writeb(priv, INT_ENABLE, byte);
-	sdio_release_host(func);
-	if (ret)
-		DPRINTK(1, " err : INT_ENABLE\n");
-
-	DPRINTK(4, " enable Interrupt : INT_ENABLE=%02X\n", byte);
-	priv->dev_state = DEVICE_STATE_BOOT;
-
-	priv->wq = create_workqueue("wq");
-	if (!priv->wq) {
-		DPRINTK(1, "create_workqueue failed !!\n");
-		goto err_free_netdev;
-	}
-
-	INIT_DELAYED_WORK(&priv->rw_dwork, ks7010_rw_function);
-	ks7010_card_init(priv);
-
-	ret = register_netdev(priv->net_dev);
-	if (ret)
-		goto err_free_netdev;
-
-	return 0;
-
- err_free_netdev:
-	free_netdev(priv->net_dev);
-	card->priv = NULL;
- err_release_irq:
-	sdio_claim_host(func);
-	sdio_release_irq(func);
- err_disable_func:
-	sdio_disable_func(func);
- err_free_card:
-	sdio_release_host(func);
-	sdio_set_drvdata(func, NULL);
-	kfree(card);
-
-	return -ENODEV;
-}
-
-/* send stop request to MAC */
-static int send_stop_request(struct sdio_func *func)
-{
-	struct hostif_stop_request_t *pp;
-	struct ks_sdio_card *card;
-	size_t size;
-
-	card = sdio_get_drvdata(func);
-
-	pp = kzalloc(hif_align_size(sizeof(*pp)), GFP_KERNEL);
-	if (!pp) {
-		DPRINTK(3, "allocate memory failed..\n");
-		return -ENOMEM;
-	}
-
-	size = sizeof(*pp) - sizeof(pp->header.size);
-	pp->header.size = cpu_to_le16((uint16_t)size);
-	pp->header.event = cpu_to_le16((uint16_t)HIF_STOP_REQ);
-
-	sdio_claim_host(func);
-	write_to_device(card->priv, (unsigned char *)pp,
-			hif_align_size(sizeof(*pp)));
-	sdio_release_host(func);
-
-	kfree(pp);
-	return 0;
-}
-
-static void ks7010_sdio_remove(struct sdio_func *func)
-{
-	int ret;
-	struct ks_sdio_card *card;
-	struct ks_wlan_private *priv;
-
-	DPRINTK(1, "ks7010_sdio_remove()\n");
-
-	card = sdio_get_drvdata(func);
-
-	if (!card)
-		return;
-
-	DPRINTK(1, "priv = card->priv\n");
-	priv = card->priv;
-	if (priv) {
-		struct net_device *netdev = priv->net_dev;
-
-		ks_wlan_net_stop(netdev);
-		DPRINTK(1, "ks_wlan_net_stop\n");
-
-		/* interrupt disable */
-		sdio_claim_host(func);
-		sdio_writeb(func, 0, INT_ENABLE, &ret);
-		sdio_writeb(func, 0xff, INT_PENDING, &ret);
-		sdio_release_host(func);
-		DPRINTK(1, "interrupt disable\n");
-
-		ret = send_stop_request(func);
-		if (ret)	/* memory allocation failure */
-			return;
-
-		DPRINTK(1, "STOP Req\n");
-
-		if (priv->wq) {
-			flush_workqueue(priv->wq);
-			destroy_workqueue(priv->wq);
-		}
-		DPRINTK(1, "destroy_workqueue(priv->wq);\n");
-
-		hostif_exit(priv);
-		DPRINTK(1, "hostif_exit\n");
-
-		unregister_netdev(netdev);
-
-		trx_device_exit(priv);
-		free_netdev(priv->net_dev);
-		card->priv = NULL;
-	}
-
-	sdio_claim_host(func);
-	sdio_release_irq(func);
-	DPRINTK(1, "sdio_release_irq()\n");
-	sdio_disable_func(func);
-	DPRINTK(1, "sdio_disable_func()\n");
-	sdio_release_host(func);
-
-	sdio_set_drvdata(func, NULL);
-
-	kfree(card);
-	DPRINTK(1, "kfree()\n");
-
-	DPRINTK(5, " Bye !!\n");
-}
-
-static struct sdio_driver ks7010_sdio_driver = {
-	.name = "ks7010_sdio",
-	.id_table = ks7010_sdio_ids,
-	.probe = ks7010_sdio_probe,
-	.remove = ks7010_sdio_remove,
-};
-
-module_driver(ks7010_sdio_driver, sdio_register_driver, sdio_unregister_driver);
-MODULE_AUTHOR("Sang Engineering, Qi-Hardware, KeyStream");
-MODULE_DESCRIPTION("Driver for KeyStream KS7010 based SDIO cards");
-MODULE_LICENSE("GPL v2");
-MODULE_FIRMWARE(ROM_FILE);
diff --git a/drivers/staging/ks7010/ks7010_sdio.h b/drivers/staging/ks7010/ks7010_sdio.h
deleted file mode 100644
index e4f56a1..0000000
--- a/drivers/staging/ks7010/ks7010_sdio.h
+++ /dev/null
@@ -1,164 +0,0 @@
-/*
- *   Driver for KeyStream, KS7010 based SDIO cards.
- *
- *   Copyright (C) 2006-2008 KeyStream Corp.
- *   Copyright (C) 2009 Renesas Technology Corp.
- *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License version 2 as
- *   published by the Free Software Foundation.
- */
-#ifndef _KS7010_SDIO_H
-#define _KS7010_SDIO_H
-
-#ifdef	DEVICE_ALIGNMENT
-#undef	DEVICE_ALIGNMENT
-#endif
-#define DEVICE_ALIGNMENT 32
-
-/*  SDIO KeyStream vendor and device */
-#define SDIO_VENDOR_ID_KS_CODE_A	0x005b
-#define SDIO_VENDOR_ID_KS_CODE_B	0x0023
-/* Older sources suggest earlier versions were named 7910 or 79xx */
-#define SDIO_DEVICE_ID_KS_7010		0x7910
-
-/* Read/Write Status Register */
-#define READ_STATUS		0x000000
-#define WRITE_STATUS		0x00000C
-enum reg_status_type {
-	REG_STATUS_BUSY,
-	REG_STATUS_IDLE
-};
-
-/* Read Index Register */
-#define READ_INDEX		0x000004
-
-/* Read Data Size Register */
-#define READ_DATA_SIZE		0x000008
-
-/* Write Index Register */
-#define WRITE_INDEX		0x000010
-
-/* Write Status/Read Data Size Register
- * for network packet (less than 2048 bytes data)
- */
-#define WSTATUS_RSIZE		0x000014
-#define WSTATUS_MASK		0x80	/* Write Status Register value */
-#define RSIZE_MASK		0x7F	/* Read Data Size Register value [10:4] */
-
-/* ARM to SD interrupt Enable */
-#define INT_ENABLE		0x000020
-/* ARM to SD interrupt Pending */
-#define INT_PENDING		0x000024
-
-#define INT_GCR_B              BIT(7)
-#define INT_GCR_A              BIT(6)
-#define INT_WRITE_STATUS       BIT(5)
-#define INT_WRITE_INDEX        BIT(4)
-#define INT_WRITE_SIZE         BIT(3)
-#define INT_READ_STATUS        BIT(2)
-#define INT_READ_INDEX         BIT(1)
-#define INT_READ_SIZE          BIT(0)
-
-/* General Communication Register A */
-#define GCR_A			0x000028
-enum gen_com_reg_a {
-	GCR_A_INIT,
-	GCR_A_REMAP,
-	GCR_A_RUN
-};
-
-/* General Communication Register B */
-#define GCR_B			0x00002C
-enum gen_com_reg_b {
-	GCR_B_ACTIVE,
-	GCR_B_DOZE
-};
-
-/* Wakeup Register */
-#define WAKEUP			0x008018
-#define WAKEUP_REQ		0x5a
-
-/* AHB Data Window  0x010000-0x01FFFF */
-#define DATA_WINDOW		0x010000
-#define WINDOW_SIZE		(64 * 1024)
-
-#define KS7010_IRAM_ADDRESS	0x06000000
-
-/**
- * struct ks_sdio_card - SDIO device data.
- *
- * Structure is used as the &struct sdio_func private data.
- *
- * @func: Pointer to the SDIO function device.
- * @priv: Pointer to the &struct net_device private data.
- */
-struct ks_sdio_card {
-	struct sdio_func *func;
-	struct ks_wlan_private *priv;
-};
-
-/* Tx Device struct */
-#define	TX_DEVICE_BUFF_SIZE	1024
-
-/**
- * struct tx_device_buffer - Queue item for the tx queue.
- * @sendp: Pointer to the send request data.
- * @size: Size of @sendp data.
- * @complete_handler: Function called once data write to device is complete.
- * @arg1: First argument to @complete_handler.
- * @arg2: Second argument to @complete_handler.
- */
-struct tx_device_buffer {
-	unsigned char *sendp;
-	unsigned int size;
-	void (*complete_handler)(struct ks_wlan_private *priv,
-				 struct sk_buff *skb);
-	struct sk_buff *skb;
-};
-
-/**
- * struct tx_device - Tx buffer queue.
- * @tx_device_buffer: Queue buffer.
- * @qhead: Head of tx queue.
- * @qtail: Tail of tx queue.
- * @tx_dev_lock: Queue lock.
- */
-struct tx_device {
-	struct tx_device_buffer tx_dev_buff[TX_DEVICE_BUFF_SIZE];
-	unsigned int qhead;
-	unsigned int qtail;
-	spinlock_t tx_dev_lock;	/* protect access to the queue */
-};
-
-/* Rx Device struct */
-#define	RX_DATA_SIZE	(2 + 2 + 2347 + 1)
-#define	RX_DEVICE_BUFF_SIZE	32
-
-/**
- * struct rx_device_buffer - Queue item for the rx queue.
- * @data: rx data.
- * @size: Size of @data.
- */
-struct rx_device_buffer {
-	unsigned char data[RX_DATA_SIZE];
-	unsigned int size;
-};
-
-/**
- * struct rx_device - Rx buffer queue.
- * @rx_device_buffer: Queue buffer.
- * @qhead: Head of rx queue.
- * @qtail: Tail of rx queue.
- * @rx_dev_lock: Queue lock.
- */
-struct rx_device {
-	struct rx_device_buffer rx_dev_buff[RX_DEVICE_BUFF_SIZE];
-	unsigned int qhead;
-	unsigned int qtail;
-	spinlock_t rx_dev_lock;	/* protect access to the queue */
-};
-
-#define	ROM_FILE "ks7010sd.rom"
-
-#endif /* _KS7010_SDIO_H */
diff --git a/drivers/staging/ks7010/ks_hostif.c b/drivers/staging/ks7010/ks_hostif.c
deleted file mode 100644
index 49e9542..0000000
--- a/drivers/staging/ks7010/ks_hostif.c
+++ /dev/null
@@ -1,2638 +0,0 @@
-/*
- *   Driver for KeyStream wireless LAN cards.
- *
- *   Copyright (C) 2005-2008 KeyStream Corp.
- *   Copyright (C) 2009 Renesas Technology Corp.
- *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License version 2 as
- *   published by the Free Software Foundation.
- */
-
-#include "ks_wlan.h"
-#include "ks_hostif.h"
-#include "eap_packet.h"
-#include "michael_mic.h"
-
-#include <linux/etherdevice.h>
-#include <linux/if_ether.h>
-#include <linux/if_arp.h>
-
-/* Include Wireless Extension definition and check version */
-#include <net/iw_handler.h>	/* New driver API */
-
-/* macro */
-#define inc_smeqhead(priv) \
-	(priv->sme_i.qhead = (priv->sme_i.qhead + 1) % SME_EVENT_BUFF_SIZE)
-#define inc_smeqtail(priv) \
-	(priv->sme_i.qtail = (priv->sme_i.qtail + 1) % SME_EVENT_BUFF_SIZE)
-#define cnt_smeqbody(priv) \
-	(((priv->sme_i.qtail + SME_EVENT_BUFF_SIZE) - (priv->sme_i.qhead)) % SME_EVENT_BUFF_SIZE)
-
-#define KS_WLAN_MEM_FLAG (GFP_ATOMIC)
-
-static
-inline u8 get_BYTE(struct ks_wlan_private *priv)
-{
-	u8 data;
-
-	data = *(priv->rxp)++;
-	/* length check in advance ! */
-	--(priv->rx_size);
-	return data;
-}
-
-static
-inline u16 get_WORD(struct ks_wlan_private *priv)
-{
-	u16 data;
-
-	data = (get_BYTE(priv) & 0xff);
-	data |= ((get_BYTE(priv) << 8) & 0xff00);
-	return data;
-}
-
-static
-inline u32 get_DWORD(struct ks_wlan_private *priv)
-{
-	u32 data;
-
-	data = (get_BYTE(priv) & 0xff);
-	data |= ((get_BYTE(priv) << 8) & 0x0000ff00);
-	data |= ((get_BYTE(priv) << 16) & 0x00ff0000);
-	data |= ((get_BYTE(priv) << 24) & 0xff000000);
-	return data;
-}
-
-static void ks_wlan_hw_wakeup_task(struct work_struct *work)
-{
-	struct ks_wlan_private *priv;
-	int ps_status;
-	long time_left;
-
-	priv = container_of(work, struct ks_wlan_private, wakeup_work);
-	ps_status = atomic_read(&priv->psstatus.status);
-
-	if (ps_status == PS_SNOOZE) {
-		ks_wlan_hw_wakeup_request(priv);
-		time_left = wait_for_completion_interruptible_timeout(
-				&priv->psstatus.wakeup_wait,
-				msecs_to_jiffies(20));
-		if (time_left <= 0) {
-			DPRINTK(1, "wake up timeout or interrupted !!!\n");
-			schedule_work(&priv->wakeup_work);
-			return;
-		}
-	} else {
-		DPRINTK(1, "ps_status=%d\n", ps_status);
-	}
-
-	/* power save */
-	if (atomic_read(&priv->sme_task.count) > 0) {
-		DPRINTK(4, "sme task enable.\n");
-		tasklet_enable(&priv->sme_task);
-	}
-}
-
-static
-int ks_wlan_do_power_save(struct ks_wlan_private *priv)
-{
-	DPRINTK(4, "psstatus.status=%d\n", atomic_read(&priv->psstatus.status));
-
-	if (is_connect_status(priv->connect_status))
-		hostif_sme_enqueue(priv, SME_POW_MNGMT_REQUEST);
-	else
-		priv->dev_state = DEVICE_STATE_READY;
-	return 0;
-}
-
-static
-int get_current_ap(struct ks_wlan_private *priv, struct link_ap_info_t *ap_info)
-{
-	struct local_ap_t *ap;
-	union iwreq_data wrqu;
-	struct net_device *netdev = priv->net_dev;
-
-	DPRINTK(3, "\n");
-	ap = &priv->current_ap;
-
-	if (is_disconnect_status(priv->connect_status)) {
-		memset(ap, 0, sizeof(struct local_ap_t));
-		return -EPERM;
-	}
-
-	/* bssid */
-	memcpy(ap->bssid, ap_info->bssid, ETH_ALEN);
-	/* essid */
-	memcpy(ap->ssid.body, priv->reg.ssid.body,
-	       priv->reg.ssid.size);
-	ap->ssid.size = priv->reg.ssid.size;
-	/* rate_set */
-	memcpy(ap->rate_set.body, ap_info->rate_set.body,
-	       ap_info->rate_set.size);
-	ap->rate_set.size = ap_info->rate_set.size;
-	if (ap_info->ext_rate_set.size != 0) {
-		/* rate_set */
-		memcpy(&ap->rate_set.body[ap->rate_set.size],
-		       ap_info->ext_rate_set.body,
-		       ap_info->ext_rate_set.size);
-		ap->rate_set.size += ap_info->ext_rate_set.size;
-	}
-	/* channel */
-	ap->channel = ap_info->ds_parameter.channel;
-	/* rssi */
-	ap->rssi = ap_info->rssi;
-	/* sq */
-	ap->sq = ap_info->sq;
-	/* noise */
-	ap->noise = ap_info->noise;
-	/* capability */
-	ap->capability = ap_info->capability;
-	/* rsn */
-	if ((ap_info->rsn_mode & RSN_MODE_WPA2) &&
-	    (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)) {
-		ap->rsn_ie.id = 0x30;
-		if (ap_info->rsn.size <= RSN_IE_BODY_MAX) {
-			ap->rsn_ie.size = ap_info->rsn.size;
-			memcpy(ap->rsn_ie.body, ap_info->rsn.body,
-			       ap_info->rsn.size);
-		} else {
-			ap->rsn_ie.size = RSN_IE_BODY_MAX;
-			memcpy(ap->rsn_ie.body, ap_info->rsn.body,
-			       RSN_IE_BODY_MAX);
-		}
-	} else if ((ap_info->rsn_mode & RSN_MODE_WPA) &&
-		   (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA)) {
-		ap->wpa_ie.id = 0xdd;
-		if (ap_info->rsn.size <= RSN_IE_BODY_MAX) {
-			ap->wpa_ie.size = ap_info->rsn.size;
-			memcpy(ap->wpa_ie.body, ap_info->rsn.body,
-			       ap_info->rsn.size);
-		} else {
-			ap->wpa_ie.size = RSN_IE_BODY_MAX;
-			memcpy(ap->wpa_ie.body, ap_info->rsn.body,
-			       RSN_IE_BODY_MAX);
-		}
-	} else {
-		ap->rsn_ie.id = 0;
-		ap->rsn_ie.size = 0;
-		ap->wpa_ie.id = 0;
-		ap->wpa_ie.size = 0;
-	}
-
-	wrqu.data.length = 0;
-	wrqu.data.flags = 0;
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	if (is_connect_status(priv->connect_status)) {
-		memcpy(wrqu.ap_addr.sa_data,
-		       priv->current_ap.bssid, ETH_ALEN);
-		DPRINTK(3,
-			"IWEVENT: connect bssid=%pM\n", wrqu.ap_addr.sa_data);
-		wireless_send_event(netdev, SIOCGIWAP, &wrqu, NULL);
-	}
-	DPRINTK(4, "\n    Link AP\n");
-	DPRINTK(4, "    bssid=%02X:%02X:%02X:%02X:%02X:%02X\n"
-		   "    essid=%s\n"
-		   "    rate_set=%02X,%02X,%02X,%02X,%02X,%02X,%02X,%02X\n"
-		   "    channel=%d\n"
-		   "    rssi=%d\n"
-		   "    sq=%d\n"
-		   "    capability=%04X\n",
-		ap->bssid[0], ap->bssid[1], ap->bssid[2],
-		ap->bssid[3], ap->bssid[4], ap->bssid[5],
-		&(ap->ssid.body[0]),
-		ap->rate_set.body[0], ap->rate_set.body[1],
-		ap->rate_set.body[2], ap->rate_set.body[3],
-		ap->rate_set.body[4], ap->rate_set.body[5],
-		ap->rate_set.body[6], ap->rate_set.body[7],
-		ap->channel, ap->rssi, ap->sq, ap->capability);
-	DPRINTK(4, "\n    Link AP\n    rsn.mode=%d\n    rsn.size=%d\n",
-		ap_info->rsn_mode, ap_info->rsn.size);
-	DPRINTK(4, "\n    ext_rate_set_size=%d\n    rate_set_size=%d\n",
-		ap_info->ext_rate_set.size, ap_info->rate_set.size);
-
-	return 0;
-}
-
-static
-int get_ap_information(struct ks_wlan_private *priv, struct ap_info_t *ap_info,
-		       struct local_ap_t *ap)
-{
-	unsigned char *bp;
-	int bsize, offset;
-
-	DPRINTK(3, "\n");
-	memset(ap, 0, sizeof(struct local_ap_t));
-
-	/* bssid */
-	memcpy(ap->bssid, ap_info->bssid, ETH_ALEN);
-	/* rssi */
-	ap->rssi = ap_info->rssi;
-	/* sq */
-	ap->sq = ap_info->sq;
-	/* noise */
-	ap->noise = ap_info->noise;
-	/* capability */
-	ap->capability = ap_info->capability;
-	/* channel */
-	ap->channel = ap_info->ch_info;
-
-	bp = ap_info->body;
-	bsize = ap_info->body_size;
-	offset = 0;
-
-	while (bsize > offset) {
-		/* DPRINTK(4, "Element ID=%d\n",*bp); */
-		switch (*bp) {
-		case 0:	/* ssid */
-			if (*(bp + 1) <= SSID_MAX_SIZE) {
-				ap->ssid.size = *(bp + 1);
-			} else {
-				DPRINTK(1, "size over :: ssid size=%d\n",
-					*(bp + 1));
-				ap->ssid.size = SSID_MAX_SIZE;
-			}
-			memcpy(ap->ssid.body, bp + 2, ap->ssid.size);
-			break;
-		case 1:	/* rate */
-		case 50:	/* ext rate */
-			if ((*(bp + 1) + ap->rate_set.size) <=
-			    RATE_SET_MAX_SIZE) {
-				memcpy(&ap->rate_set.body[ap->rate_set.size],
-				       bp + 2, *(bp + 1));
-				ap->rate_set.size += *(bp + 1);
-			} else {
-				DPRINTK(1, "size over :: rate size=%d\n",
-					(*(bp + 1) + ap->rate_set.size));
-				memcpy(&ap->rate_set.body[ap->rate_set.size],
-				       bp + 2,
-				       RATE_SET_MAX_SIZE - ap->rate_set.size);
-				ap->rate_set.size +=
-				    (RATE_SET_MAX_SIZE - ap->rate_set.size);
-			}
-			break;
-		case 3:	/* DS parameter */
-			break;
-		case 48:	/* RSN(WPA2) */
-			ap->rsn_ie.id = *bp;
-			if (*(bp + 1) <= RSN_IE_BODY_MAX) {
-				ap->rsn_ie.size = *(bp + 1);
-			} else {
-				DPRINTK(1, "size over :: rsn size=%d\n",
-					*(bp + 1));
-				ap->rsn_ie.size = RSN_IE_BODY_MAX;
-			}
-			memcpy(ap->rsn_ie.body, bp + 2, ap->rsn_ie.size);
-			break;
-		case 221:	/* WPA */
-			if (memcmp(bp + 2, "\x00\x50\xf2\x01", 4) == 0) {	/* WPA OUI check */
-				ap->wpa_ie.id = *bp;
-				if (*(bp + 1) <= RSN_IE_BODY_MAX) {
-					ap->wpa_ie.size = *(bp + 1);
-				} else {
-					DPRINTK(1,
-						"size over :: wpa size=%d\n",
-						*(bp + 1));
-					ap->wpa_ie.size = RSN_IE_BODY_MAX;
-				}
-				memcpy(ap->wpa_ie.body, bp + 2,
-				       ap->wpa_ie.size);
-			}
-			break;
-
-		case 2:	/* FH parameter */
-		case 4:	/* CF parameter */
-		case 5:	/* TIM */
-		case 6:	/* IBSS parameter */
-		case 7:	/* Country */
-		case 42:	/* ERP information */
-		case 47:	/* Reserve ID 47 Broadcom AP */
-			break;
-		default:
-			DPRINTK(4, "unknown Element ID=%d\n", *bp);
-			break;
-		}
-		offset += 2;	/* id & size field */
-		offset += *(bp + 1);	/* +size offset */
-		bp += (*(bp + 1) + 2);	/* pointer update */
-	}
-
-	return 0;
-}
-
-static
-int hostif_data_indication_wpa(struct ks_wlan_private *priv,
-			       unsigned short auth_type)
-{
-	struct ether_hdr *eth_hdr;
-	unsigned short eth_proto;
-	unsigned char recv_mic[8];
-	char buf[128];
-	unsigned long now;
-	struct mic_failure_t *mic_failure;
-	struct michael_mic_t michael_mic;
-	union iwreq_data wrqu;
-	unsigned int key_index = auth_type - 1;
-	struct wpa_key_t *key = &priv->wpa.key[key_index];
-
-	eth_hdr = (struct ether_hdr *)(priv->rxp);
-	eth_proto = ntohs(eth_hdr->h_proto);
-
-	if (eth_hdr->h_dest_snap != eth_hdr->h_source_snap) {
-		DPRINTK(1, "invalid data format\n");
-		priv->nstats.rx_errors++;
-		return -EINVAL;
-	}
-	if (((auth_type == TYPE_PMK1 &&
-	      priv->wpa.pairwise_suite == IW_AUTH_CIPHER_TKIP) ||
-	     (auth_type == TYPE_GMK1 &&
-	      priv->wpa.group_suite == IW_AUTH_CIPHER_TKIP) ||
-	     (auth_type == TYPE_GMK2 &&
-	      priv->wpa.group_suite == IW_AUTH_CIPHER_TKIP)) &&
-	    key->key_len) {
-		DPRINTK(4, "TKIP: protocol=%04X: size=%u\n",
-			eth_proto, priv->rx_size);
-		/* MIC save */
-		memcpy(&recv_mic[0], (priv->rxp) + ((priv->rx_size) - 8), 8);
-		priv->rx_size = priv->rx_size - 8;
-		if (auth_type > 0 && auth_type < 4) {	/* auth_type check */
-			MichaelMICFunction(&michael_mic,
-					   (uint8_t *)key->rx_mic_key,
-					   (uint8_t *)priv->rxp,
-					   (int)priv->rx_size,
-					   (uint8_t)0,	/* priority */
-					   (uint8_t *)michael_mic.Result);
-		}
-		if (memcmp(michael_mic.Result, recv_mic, 8) != 0) {
-			now = jiffies;
-			mic_failure = &priv->wpa.mic_failure;
-			/* MIC FAILURE */
-			if (mic_failure->last_failure_time &&
-			    (now - mic_failure->last_failure_time) / HZ >= 60) {
-				mic_failure->failure = 0;
-			}
-			DPRINTK(4, "MIC FAILURE\n");
-			if (mic_failure->failure == 0) {
-				mic_failure->failure = 1;
-				mic_failure->counter = 0;
-			} else if (mic_failure->failure == 1) {
-				mic_failure->failure = 2;
-				mic_failure->counter =
-					(uint16_t)((now - mic_failure->last_failure_time) / HZ);
-				if (!mic_failure->counter)	/*  range 1-60 */
-					mic_failure->counter = 1;
-			}
-			priv->wpa.mic_failure.last_failure_time = now;
-
-			/*  needed parameters: count, keyid, key type, TSC */
-			sprintf(buf,
-				"MLME-MICHAELMICFAILURE.indication(keyid=%d %scast addr=%pM)",
-				key_index,
-				eth_hdr->h_dest[0] & 0x01 ? "broad" : "uni",
-				eth_hdr->h_source);
-			memset(&wrqu, 0, sizeof(wrqu));
-			wrqu.data.length = strlen(buf);
-			DPRINTK(4, "IWEVENT:MICHAELMICFAILURE\n");
-			wireless_send_event(priv->net_dev, IWEVCUSTOM, &wrqu,
-					    buf);
-			return -EINVAL;
-		}
-	}
-	return 0;
-}
-
-static
-void hostif_data_indication(struct ks_wlan_private *priv)
-{
-	unsigned int rx_ind_size;	/* indicate data size */
-	struct sk_buff *skb;
-	unsigned short auth_type;
-	unsigned char temp[256];
-	struct ether_hdr *eth_hdr;
-	unsigned short eth_proto;
-	struct ieee802_1x_hdr *aa1x_hdr;
-	size_t size;
-	int ret;
-
-	DPRINTK(3, "\n");
-
-	/* min length check */
-	if (priv->rx_size <= ETH_HLEN) {
-		DPRINTK(3, "rx_size = %d\n", priv->rx_size);
-		priv->nstats.rx_errors++;
-		return;
-	}
-
-	auth_type = get_WORD(priv);	/* AuthType */
-	get_WORD(priv);	/* Reserve Area */
-
-	eth_hdr = (struct ether_hdr *)(priv->rxp);
-	eth_proto = ntohs(eth_hdr->h_proto);
-	DPRINTK(3, "ether protocol = %04X\n", eth_proto);
-
-	/* source address check */
-	if (memcmp(&priv->eth_addr[0], eth_hdr->h_source, ETH_ALEN) == 0) {
-		DPRINTK(1, "invalid : source is own mac address !!\n");
-		DPRINTK(1,
-			"eth_hdrernet->h_dest=%02X:%02X:%02X:%02X:%02X:%02X\n",
-			eth_hdr->h_source[0], eth_hdr->h_source[1],
-			eth_hdr->h_source[2], eth_hdr->h_source[3],
-			eth_hdr->h_source[4], eth_hdr->h_source[5]);
-		priv->nstats.rx_errors++;
-		return;
-	}
-
-	/*  for WPA */
-	if (auth_type != TYPE_DATA && priv->wpa.rsn_enabled) {
-		ret = hostif_data_indication_wpa(priv, auth_type);
-		if (ret)
-			return;
-	}
-
-	if ((priv->connect_status & FORCE_DISCONNECT) ||
-	    priv->wpa.mic_failure.failure == 2) {
-		return;
-	}
-
-	/* check 13th byte at rx data */
-	switch (*(priv->rxp + 12)) {
-	case 0xAA:	/* SNAP */
-		rx_ind_size = priv->rx_size - 6;
-		skb = dev_alloc_skb(rx_ind_size);
-		if (!skb) {
-			priv->nstats.rx_dropped++;
-			return;
-		}
-		DPRINTK(4, "SNAP, rx_ind_size = %d\n", rx_ind_size);
-
-		size = ETH_ALEN * 2;
-		memcpy(skb_put(skb, size), priv->rxp, size);
-
-		/* (SNAP+UI..) skip */
-
-		size = rx_ind_size - (ETH_ALEN * 2);
-		memcpy(skb_put(skb, size), &eth_hdr->h_proto, size);
-
-		aa1x_hdr = (struct ieee802_1x_hdr *)(priv->rxp + ETHER_HDR_SIZE);
-		break;
-	case 0xF0:	/* NETBEUI/NetBIOS */
-		rx_ind_size = (priv->rx_size + 2);
-		skb = dev_alloc_skb(rx_ind_size);
-		if (!skb) {
-			priv->nstats.rx_dropped++;
-			return;
-		}
-		DPRINTK(3, "NETBEUI/NetBIOS rx_ind_size=%d\n", rx_ind_size);
-
-		memcpy(skb_put(skb, 12), priv->rxp, 12);	/* 8802/FDDI MAC copy */
-
-		temp[0] = (((rx_ind_size - 12) >> 8) & 0xff);	/* NETBEUI size add */
-		temp[1] = ((rx_ind_size - 12) & 0xff);
-		memcpy(skb_put(skb, 2), temp, 2);
-
-		memcpy(skb_put(skb, rx_ind_size - 14), priv->rxp + 12,
-		       rx_ind_size - 14);	/* copy after Type */
-
-		aa1x_hdr = (struct ieee802_1x_hdr *)(priv->rxp + 14);
-		break;
-	default:	/* other rx data */
-		DPRINTK(2, "invalid data format\n");
-		priv->nstats.rx_errors++;
-		return;
-	}
-
-	if (aa1x_hdr->type == IEEE802_1X_TYPE_EAPOL_KEY &&
-	    priv->wpa.rsn_enabled)
-		atomic_set(&priv->psstatus.snooze_guard, 1);
-
-	/* rx indication */
-	skb->dev = priv->net_dev;
-	skb->protocol = eth_type_trans(skb, skb->dev);
-	priv->nstats.rx_packets++;
-	priv->nstats.rx_bytes += rx_ind_size;
-	netif_rx(skb);
-}
-
-static
-void hostif_mib_get_confirm(struct ks_wlan_private *priv)
-{
-	struct net_device *dev = priv->net_dev;
-	u32 mib_status;
-	u32 mib_attribute;
-	u16 mib_val_size;
-	u16 mib_val_type;
-
-	DPRINTK(3, "\n");
-
-	mib_status = get_DWORD(priv);	/* MIB status */
-	mib_attribute = get_DWORD(priv);	/* MIB atttibute */
-	mib_val_size = get_WORD(priv);	/* MIB value size */
-	mib_val_type = get_WORD(priv);	/* MIB value type */
-
-	if (mib_status) {
-		/* in case of error */
-		DPRINTK(1, "attribute=%08X, status=%08X\n", mib_attribute,
-			mib_status);
-		return;
-	}
-
-	switch (mib_attribute) {
-	case DOT11_MAC_ADDRESS:
-		/* MAC address */
-		DPRINTK(3, " mib_attribute=DOT11_MAC_ADDRESS\n");
-		hostif_sme_enqueue(priv, SME_GET_MAC_ADDRESS);
-		memcpy(priv->eth_addr, priv->rxp, ETH_ALEN);
-		priv->mac_address_valid = 1;
-		dev->dev_addr[0] = priv->eth_addr[0];
-		dev->dev_addr[1] = priv->eth_addr[1];
-		dev->dev_addr[2] = priv->eth_addr[2];
-		dev->dev_addr[3] = priv->eth_addr[3];
-		dev->dev_addr[4] = priv->eth_addr[4];
-		dev->dev_addr[5] = priv->eth_addr[5];
-		dev->dev_addr[6] = 0x00;
-		dev->dev_addr[7] = 0x00;
-		netdev_info(dev, "MAC ADDRESS = %pM\n", priv->eth_addr);
-		break;
-	case DOT11_PRODUCT_VERSION:
-		/* firmware version */
-		DPRINTK(3, " mib_attribute=DOT11_PRODUCT_VERSION\n");
-		priv->version_size = priv->rx_size;
-		memcpy(priv->firmware_version, priv->rxp, priv->rx_size);
-		priv->firmware_version[priv->rx_size] = '\0';
-		netdev_info(dev, "firmware ver. = %s\n",
-			    priv->firmware_version);
-		hostif_sme_enqueue(priv, SME_GET_PRODUCT_VERSION);
-		/* wake_up_interruptible_all(&priv->confirm_wait); */
-		complete(&priv->confirm_wait);
-		break;
-	case LOCAL_GAIN:
-		memcpy(&priv->gain, priv->rxp, sizeof(priv->gain));
-		DPRINTK(3, "TxMode=%d, RxMode=%d, TxGain=%d, RxGain=%d\n",
-			priv->gain.TxMode, priv->gain.RxMode, priv->gain.TxGain,
-			priv->gain.RxGain);
-		break;
-	case LOCAL_EEPROM_SUM:
-		memcpy(&priv->eeprom_sum, priv->rxp, sizeof(priv->eeprom_sum));
-		DPRINTK(1, "eeprom_sum.type=%x, eeprom_sum.result=%x\n",
-			priv->eeprom_sum.type, priv->eeprom_sum.result);
-		if (priv->eeprom_sum.type == 0) {
-			priv->eeprom_checksum = EEPROM_CHECKSUM_NONE;
-		} else if (priv->eeprom_sum.type == 1) {
-			if (priv->eeprom_sum.result == 0) {
-				priv->eeprom_checksum = EEPROM_NG;
-				netdev_info(dev, "LOCAL_EEPROM_SUM NG\n");
-			} else if (priv->eeprom_sum.result == 1) {
-				priv->eeprom_checksum = EEPROM_OK;
-			}
-		} else {
-			netdev_err(dev, "LOCAL_EEPROM_SUM error!\n");
-		}
-		break;
-	default:
-		DPRINTK(1, "mib_attribute=%08x\n", (unsigned int)mib_attribute);
-		break;
-	}
-}
-
-static
-void hostif_mib_set_confirm(struct ks_wlan_private *priv)
-{
-	u32 mib_status;	/* +04 MIB Status */
-	u32 mib_attribute;	/* +08 MIB attribute */
-
-	DPRINTK(3, "\n");
-
-	mib_status = get_DWORD(priv);	/* MIB Status */
-	mib_attribute = get_DWORD(priv);	/* MIB attribute */
-
-	if (mib_status) {
-		/* in case of error */
-		DPRINTK(1, "error :: attribute=%08X, status=%08X\n",
-			mib_attribute, mib_status);
-	}
-
-	switch (mib_attribute) {
-	case DOT11_RTS_THRESHOLD:
-		hostif_sme_enqueue(priv, SME_RTS_THRESHOLD_CONFIRM);
-		break;
-	case DOT11_FRAGMENTATION_THRESHOLD:
-		hostif_sme_enqueue(priv, SME_FRAGMENTATION_THRESHOLD_CONFIRM);
-		break;
-	case DOT11_WEP_DEFAULT_KEY_ID:
-		if (!priv->wpa.wpa_enabled)
-			hostif_sme_enqueue(priv, SME_WEP_INDEX_CONFIRM);
-		break;
-	case DOT11_WEP_DEFAULT_KEY_VALUE1:
-		DPRINTK(2, "DOT11_WEP_DEFAULT_KEY_VALUE1:mib_status=%d\n",
-			(int)mib_status);
-		if (priv->wpa.rsn_enabled)
-			hostif_sme_enqueue(priv, SME_SET_PMK_TSC);
-		else
-			hostif_sme_enqueue(priv, SME_WEP_KEY1_CONFIRM);
-		break;
-	case DOT11_WEP_DEFAULT_KEY_VALUE2:
-		DPRINTK(2, "DOT11_WEP_DEFAULT_KEY_VALUE2:mib_status=%d\n",
-			(int)mib_status);
-		if (priv->wpa.rsn_enabled)
-			hostif_sme_enqueue(priv, SME_SET_GMK1_TSC);
-		else
-			hostif_sme_enqueue(priv, SME_WEP_KEY2_CONFIRM);
-		break;
-	case DOT11_WEP_DEFAULT_KEY_VALUE3:
-		DPRINTK(2, "DOT11_WEP_DEFAULT_KEY_VALUE3:mib_status=%d\n",
-			(int)mib_status);
-		if (priv->wpa.rsn_enabled)
-			hostif_sme_enqueue(priv, SME_SET_GMK2_TSC);
-		else
-			hostif_sme_enqueue(priv, SME_WEP_KEY3_CONFIRM);
-		break;
-	case DOT11_WEP_DEFAULT_KEY_VALUE4:
-		DPRINTK(2, "DOT11_WEP_DEFAULT_KEY_VALUE4:mib_status=%d\n",
-			(int)mib_status);
-		if (!priv->wpa.rsn_enabled)
-			hostif_sme_enqueue(priv, SME_WEP_KEY4_CONFIRM);
-		break;
-	case DOT11_PRIVACY_INVOKED:
-		if (!priv->wpa.rsn_enabled)
-			hostif_sme_enqueue(priv, SME_WEP_FLAG_CONFIRM);
-		break;
-	case DOT11_RSN_ENABLED:
-		DPRINTK(2, "DOT11_RSN_ENABLED:mib_status=%d\n",
-			(int)mib_status);
-		hostif_sme_enqueue(priv, SME_RSN_ENABLED_CONFIRM);
-		break;
-	case LOCAL_RSN_MODE:
-		hostif_sme_enqueue(priv, SME_RSN_MODE_CONFIRM);
-		break;
-	case LOCAL_MULTICAST_ADDRESS:
-		hostif_sme_enqueue(priv, SME_MULTICAST_REQUEST);
-		break;
-	case LOCAL_MULTICAST_FILTER:
-		hostif_sme_enqueue(priv, SME_MULTICAST_CONFIRM);
-		break;
-	case LOCAL_CURRENTADDRESS:
-		priv->mac_address_valid = 1;
-		break;
-	case DOT11_RSN_CONFIG_MULTICAST_CIPHER:
-		DPRINTK(2, "DOT11_RSN_CONFIG_MULTICAST_CIPHER:mib_status=%d\n",
-			(int)mib_status);
-		hostif_sme_enqueue(priv, SME_RSN_MCAST_CONFIRM);
-		break;
-	case DOT11_RSN_CONFIG_UNICAST_CIPHER:
-		DPRINTK(2, "DOT11_RSN_CONFIG_UNICAST_CIPHER:mib_status=%d\n",
-			(int)mib_status);
-		hostif_sme_enqueue(priv, SME_RSN_UCAST_CONFIRM);
-		break;
-	case DOT11_RSN_CONFIG_AUTH_SUITE:
-		DPRINTK(2, "DOT11_RSN_CONFIG_AUTH_SUITE:mib_status=%d\n",
-			(int)mib_status);
-		hostif_sme_enqueue(priv, SME_RSN_AUTH_CONFIRM);
-		break;
-	case DOT11_PMK_TSC:
-		DPRINTK(2, "DOT11_PMK_TSC:mib_status=%d\n", (int)mib_status);
-		break;
-	case DOT11_GMK1_TSC:
-		DPRINTK(2, "DOT11_GMK1_TSC:mib_status=%d\n", (int)mib_status);
-		if (atomic_read(&priv->psstatus.snooze_guard))
-			atomic_set(&priv->psstatus.snooze_guard, 0);
-		break;
-	case DOT11_GMK2_TSC:
-		DPRINTK(2, "DOT11_GMK2_TSC:mib_status=%d\n", (int)mib_status);
-		if (atomic_read(&priv->psstatus.snooze_guard))
-			atomic_set(&priv->psstatus.snooze_guard, 0);
-		break;
-	case LOCAL_PMK:
-		DPRINTK(2, "LOCAL_PMK:mib_status=%d\n", (int)mib_status);
-		break;
-	case LOCAL_GAIN:
-		DPRINTK(2, "LOCAL_GAIN:mib_status=%d\n", (int)mib_status);
-		break;
-#ifdef WPS
-	case LOCAL_WPS_ENABLE:
-		DPRINTK(2, "LOCAL_WPS_ENABLE:mib_status=%d\n", (int)mib_status);
-		break;
-	case LOCAL_WPS_PROBE_REQ:
-		DPRINTK(2, "LOCAL_WPS_PROBE_REQ:mib_status=%d\n",
-			(int)mib_status);
-		break;
-#endif /* WPS */
-	case LOCAL_REGION:
-		DPRINTK(2, "LOCAL_REGION:mib_status=%d\n", (int)mib_status);
-	default:
-		break;
-	}
-}
-
-static
-void hostif_power_mgmt_confirm(struct ks_wlan_private *priv)
-{
-	DPRINTK(3, "\n");
-
-	if (priv->reg.power_mgmt > POWER_MGMT_ACTIVE &&
-	    priv->reg.operation_mode == MODE_INFRASTRUCTURE) {
-		atomic_set(&priv->psstatus.confirm_wait, 0);
-		priv->dev_state = DEVICE_STATE_SLEEP;
-		ks_wlan_hw_power_save(priv);
-	} else {
-		priv->dev_state = DEVICE_STATE_READY;
-	}
-}
-
-static
-void hostif_sleep_confirm(struct ks_wlan_private *priv)
-{
-	DPRINTK(3, "\n");
-
-	atomic_set(&priv->sleepstatus.doze_request, 1);
-	queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
-}
-
-static
-void hostif_start_confirm(struct ks_wlan_private *priv)
-{
-#ifdef WPS
-	union iwreq_data wrqu;
-
-	wrqu.data.length = 0;
-	wrqu.data.flags = 0;
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	if (is_connect_status(priv->connect_status)) {
-		eth_zero_addr(wrqu.ap_addr.sa_data);
-		DPRINTK(3, "IWEVENT: disconnect\n");
-		wireless_send_event(priv->net_dev, SIOCGIWAP, &wrqu, NULL);
-	}
-#endif
-	DPRINTK(3, " scan_ind_count=%d\n", priv->scan_ind_count);
-	hostif_sme_enqueue(priv, SME_START_CONFIRM);
-}
-
-static
-void hostif_connect_indication(struct ks_wlan_private *priv)
-{
-	unsigned short connect_code;
-	unsigned int tmp = 0;
-	unsigned int old_status = priv->connect_status;
-	struct net_device *netdev = priv->net_dev;
-	union iwreq_data wrqu0;
-
-	connect_code = get_WORD(priv);
-
-	switch (connect_code) {
-	case RESULT_CONNECT:	/* connect */
-		DPRINTK(3, "connect :: scan_ind_count=%d\n",
-			priv->scan_ind_count);
-		if (!(priv->connect_status & FORCE_DISCONNECT))
-			netif_carrier_on(netdev);
-		tmp = FORCE_DISCONNECT & priv->connect_status;
-		priv->connect_status = tmp + CONNECT_STATUS;
-		break;
-	case RESULT_DISCONNECT:	/* disconnect */
-		DPRINTK(3, "disconnect :: scan_ind_count=%d\n",
-			priv->scan_ind_count);
-		netif_carrier_off(netdev);
-		tmp = FORCE_DISCONNECT & priv->connect_status;
-		priv->connect_status = tmp + DISCONNECT_STATUS;
-		break;
-	default:
-		DPRINTK(1, "unknown connect_code=%d :: scan_ind_count=%d\n",
-			connect_code, priv->scan_ind_count);
-		netif_carrier_off(netdev);
-		tmp = FORCE_DISCONNECT & priv->connect_status;
-		priv->connect_status = tmp + DISCONNECT_STATUS;
-		break;
-	}
-
-	get_current_ap(priv, (struct link_ap_info_t *)priv->rxp);
-	if (is_connect_status(priv->connect_status) &&
-	    is_disconnect_status(old_status)) {
-		/* for power save */
-		atomic_set(&priv->psstatus.snooze_guard, 0);
-		atomic_set(&priv->psstatus.confirm_wait, 0);
-	}
-	ks_wlan_do_power_save(priv);
-
-	wrqu0.data.length = 0;
-	wrqu0.data.flags = 0;
-	wrqu0.ap_addr.sa_family = ARPHRD_ETHER;
-	if (is_disconnect_status(priv->connect_status) &&
-	    is_connect_status(old_status)) {
-		eth_zero_addr(wrqu0.ap_addr.sa_data);
-		DPRINTK(3, "IWEVENT: disconnect\n");
-		DPRINTK(3, "disconnect :: scan_ind_count=%d\n",
-			priv->scan_ind_count);
-		wireless_send_event(netdev, SIOCGIWAP, &wrqu0, NULL);
-	}
-	priv->scan_ind_count = 0;
-}
-
-static
-void hostif_scan_indication(struct ks_wlan_private *priv)
-{
-	int i;
-	struct ap_info_t *ap_info;
-
-	DPRINTK(3, "scan_ind_count = %d\n", priv->scan_ind_count);
-	ap_info = (struct ap_info_t *)(priv->rxp);
-
-	if (priv->scan_ind_count) {
-		for (i = 0; i < priv->aplist.size; i++) {	/* bssid check */
-			if (memcmp(ap_info->bssid,
-				   priv->aplist.ap[i].bssid, ETH_ALEN) != 0)
-				continue;
-
-			if (ap_info->frame_type == FRAME_TYPE_PROBE_RESP)
-				get_ap_information(priv, ap_info,
-						   &priv->aplist.ap[i]);
-			return;
-		}
-	}
-	priv->scan_ind_count++;
-	if (priv->scan_ind_count < LOCAL_APLIST_MAX + 1) {
-		DPRINTK(4, " scan_ind_count=%d :: aplist.size=%d\n",
-			priv->scan_ind_count, priv->aplist.size);
-		get_ap_information(priv, (struct ap_info_t *)(priv->rxp),
-				   &(priv->aplist.ap[priv->scan_ind_count - 1]));
-		priv->aplist.size = priv->scan_ind_count;
-	} else {
-		DPRINTK(4, " count over :: scan_ind_count=%d\n",
-			priv->scan_ind_count);
-	}
-}
-
-static
-void hostif_stop_confirm(struct ks_wlan_private *priv)
-{
-	unsigned int tmp = 0;
-	unsigned int old_status = priv->connect_status;
-	struct net_device *netdev = priv->net_dev;
-	union iwreq_data wrqu0;
-
-	DPRINTK(3, "\n");
-	if (priv->dev_state == DEVICE_STATE_SLEEP)
-		priv->dev_state = DEVICE_STATE_READY;
-
-	/* disconnect indication */
-	if (is_connect_status(priv->connect_status)) {
-		netif_carrier_off(netdev);
-		tmp = FORCE_DISCONNECT & priv->connect_status;
-		priv->connect_status = tmp | DISCONNECT_STATUS;
-		netdev_info(netdev, "IWEVENT: disconnect\n");
-
-		wrqu0.data.length = 0;
-		wrqu0.data.flags = 0;
-		wrqu0.ap_addr.sa_family = ARPHRD_ETHER;
-		if (is_disconnect_status(priv->connect_status) &&
-		    is_connect_status(old_status)) {
-			eth_zero_addr(wrqu0.ap_addr.sa_data);
-			DPRINTK(3, "IWEVENT: disconnect\n");
-			netdev_info(netdev, "IWEVENT: disconnect\n");
-			DPRINTK(3, "disconnect :: scan_ind_count=%d\n",
-				priv->scan_ind_count);
-			wireless_send_event(netdev, SIOCGIWAP, &wrqu0, NULL);
-		}
-		priv->scan_ind_count = 0;
-	}
-
-	hostif_sme_enqueue(priv, SME_STOP_CONFIRM);
-}
-
-static
-void hostif_ps_adhoc_set_confirm(struct ks_wlan_private *priv)
-{
-	DPRINTK(3, "\n");
-	priv->infra_status = 0;	/* infrastructure mode cancel */
-	hostif_sme_enqueue(priv, SME_MODE_SET_CONFIRM);
-}
-
-static
-void hostif_infrastructure_set_confirm(struct ks_wlan_private *priv)
-{
-	u16 result_code;
-
-	DPRINTK(3, "\n");
-	result_code = get_WORD(priv);
-	DPRINTK(3, "result code = %d\n", result_code);
-	priv->infra_status = 1;	/* infrastructure mode set */
-	hostif_sme_enqueue(priv, SME_MODE_SET_CONFIRM);
-}
-
-static
-void hostif_adhoc_set_confirm(struct ks_wlan_private *priv)
-{
-	DPRINTK(3, "\n");
-	priv->infra_status = 1;	/* infrastructure mode set */
-	hostif_sme_enqueue(priv, SME_MODE_SET_CONFIRM);
-}
-
-static
-void hostif_associate_indication(struct ks_wlan_private *priv)
-{
-	struct association_request_t *assoc_req;
-	struct association_response_t *assoc_resp;
-	unsigned char *pb;
-	union iwreq_data wrqu;
-	char buf[IW_CUSTOM_MAX];
-	char *pbuf = &buf[0];
-	int i;
-
-	static const char associnfo_leader0[] = "ASSOCINFO(ReqIEs=";
-	static const char associnfo_leader1[] = " RespIEs=";
-
-	DPRINTK(3, "\n");
-	assoc_req = (struct association_request_t *)(priv->rxp);
-	assoc_resp = (struct association_response_t *)(assoc_req + 1);
-	pb = (unsigned char *)(assoc_resp + 1);
-
-	memset(&wrqu, 0, sizeof(wrqu));
-	memcpy(pbuf, associnfo_leader0, sizeof(associnfo_leader0) - 1);
-	wrqu.data.length += sizeof(associnfo_leader0) - 1;
-	pbuf += sizeof(associnfo_leader0) - 1;
-
-	for (i = 0; i < assoc_req->reqIEs_size; i++)
-		pbuf += sprintf(pbuf, "%02x", *(pb + i));
-	wrqu.data.length += (assoc_req->reqIEs_size) * 2;
-
-	memcpy(pbuf, associnfo_leader1, sizeof(associnfo_leader1) - 1);
-	wrqu.data.length += sizeof(associnfo_leader1) - 1;
-	pbuf += sizeof(associnfo_leader1) - 1;
-
-	pb += assoc_req->reqIEs_size;
-	for (i = 0; i < assoc_resp->respIEs_size; i++)
-		pbuf += sprintf(pbuf, "%02x", *(pb + i));
-	wrqu.data.length += (assoc_resp->respIEs_size) * 2;
-
-	pbuf += sprintf(pbuf, ")");
-	wrqu.data.length += 1;
-
-	DPRINTK(3, "IWEVENT:ASSOCINFO\n");
-	wireless_send_event(priv->net_dev, IWEVCUSTOM, &wrqu, buf);
-}
-
-static
-void hostif_bss_scan_confirm(struct ks_wlan_private *priv)
-{
-	unsigned int result_code;
-	struct net_device *dev = priv->net_dev;
-	union iwreq_data wrqu;
-
-	result_code = get_DWORD(priv);
-	DPRINTK(2, "result=%d :: scan_ind_count=%d\n", result_code,
-		priv->scan_ind_count);
-
-	priv->sme_i.sme_flag &= ~SME_AP_SCAN;
-	hostif_sme_enqueue(priv, SME_BSS_SCAN_CONFIRM);
-
-	wrqu.data.length = 0;
-	wrqu.data.flags = 0;
-	DPRINTK(3, "IWEVENT: SCAN CONFIRM\n");
-	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
-	priv->scan_ind_count = 0;
-}
-
-static
-void hostif_phy_information_confirm(struct ks_wlan_private *priv)
-{
-	struct iw_statistics *wstats = &priv->wstats;
-	unsigned char rssi, signal, noise;
-	unsigned char LinkSpeed;
-	unsigned int TransmittedFrameCount, ReceivedFragmentCount;
-	unsigned int FailedCount, FCSErrorCount;
-
-	DPRINTK(3, "\n");
-	rssi = get_BYTE(priv);
-	signal = get_BYTE(priv);
-	noise = get_BYTE(priv);
-	LinkSpeed = get_BYTE(priv);
-	TransmittedFrameCount = get_DWORD(priv);
-	ReceivedFragmentCount = get_DWORD(priv);
-	FailedCount = get_DWORD(priv);
-	FCSErrorCount = get_DWORD(priv);
-
-	DPRINTK(4, "phyinfo confirm rssi=%d signal=%d\n", rssi, signal);
-	priv->current_rate = (LinkSpeed & RATE_MASK);
-	wstats->qual.qual = signal;
-	wstats->qual.level = 256 - rssi;
-	wstats->qual.noise = 0;	/* invalid noise value */
-	wstats->qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
-
-	DPRINTK(3, "\n    rssi=%u\n"
-		   "    signal=%u\n"
-		   "    LinkSpeed=%ux500Kbps\n"
-		   "    TransmittedFrameCount=%u\n"
-		   "    ReceivedFragmentCount=%u\n"
-		   "    FailedCount=%u\n"
-		   "    FCSErrorCount=%u\n",
-		rssi, signal, LinkSpeed, TransmittedFrameCount,
-		ReceivedFragmentCount, FailedCount, FCSErrorCount);
-
-	/* wake_up_interruptible_all(&priv->confirm_wait); */
-	complete(&priv->confirm_wait);
-}
-
-static
-void hostif_mic_failure_confirm(struct ks_wlan_private *priv)
-{
-	DPRINTK(3, "mic_failure=%u\n", priv->wpa.mic_failure.failure);
-	hostif_sme_enqueue(priv, SME_MIC_FAILURE_CONFIRM);
-}
-
-static
-void hostif_event_check(struct ks_wlan_private *priv)
-{
-	unsigned short event;
-
-	DPRINTK(4, "\n");
-	event = get_WORD(priv);	/* get event */
-	switch (event) {
-	case HIF_DATA_IND:
-		hostif_data_indication(priv);
-		break;
-	case HIF_MIB_GET_CONF:
-		hostif_mib_get_confirm(priv);
-		break;
-	case HIF_MIB_SET_CONF:
-		hostif_mib_set_confirm(priv);
-		break;
-	case HIF_POWER_MGMT_CONF:
-		hostif_power_mgmt_confirm(priv);
-		break;
-	case HIF_SLEEP_CONF:
-		hostif_sleep_confirm(priv);
-		break;
-	case HIF_START_CONF:
-		hostif_start_confirm(priv);
-		break;
-	case HIF_CONNECT_IND:
-		hostif_connect_indication(priv);
-		break;
-	case HIF_STOP_CONF:
-		hostif_stop_confirm(priv);
-		break;
-	case HIF_PS_ADH_SET_CONF:
-		hostif_ps_adhoc_set_confirm(priv);
-		break;
-	case HIF_INFRA_SET_CONF:
-	case HIF_INFRA_SET2_CONF:
-		hostif_infrastructure_set_confirm(priv);
-		break;
-	case HIF_ADH_SET_CONF:
-	case HIF_ADH_SET2_CONF:
-		hostif_adhoc_set_confirm(priv);
-		break;
-	case HIF_ASSOC_INFO_IND:
-		hostif_associate_indication(priv);
-		break;
-	case HIF_MIC_FAILURE_CONF:
-		hostif_mic_failure_confirm(priv);
-		break;
-	case HIF_SCAN_CONF:
-		hostif_bss_scan_confirm(priv);
-		break;
-	case HIF_PHY_INFO_CONF:
-	case HIF_PHY_INFO_IND:
-		hostif_phy_information_confirm(priv);
-		break;
-	case HIF_SCAN_IND:
-		hostif_scan_indication(priv);
-		break;
-	case HIF_AP_SET_CONF:
-	default:
-		//DPRINTK(1, "undefined event[%04X]\n", event);
-		netdev_err(priv->net_dev, "undefined event[%04X]\n", event);
-		/* wake_up_all(&priv->confirm_wait); */
-		complete(&priv->confirm_wait);
-		break;
-	}
-
-	/* add event to hostt buffer */
-	priv->hostt.buff[priv->hostt.qtail] = event;
-	priv->hostt.qtail = (priv->hostt.qtail + 1) % SME_EVENT_BUFF_SIZE;
-}
-
-/* allocate size bytes, set header size and event */
-static void *hostif_generic_request(size_t size, int event)
-{
-	struct hostif_hdr *p;
-
-	p = kzalloc(hif_align_size(size), KS_WLAN_MEM_FLAG);
-	if (!p)
-		return NULL;
-
-	p->size = cpu_to_le16((u16)(size - sizeof(p->size)));
-	p->event = cpu_to_le16(event);
-
-	return p;
-}
-
-int hostif_data_request(struct ks_wlan_private *priv, struct sk_buff *skb)
-{
-	unsigned int skb_len = 0;
-
-	unsigned char *buffer = NULL;
-	unsigned int length = 0;
-	struct hostif_data_request_t *pp;
-	unsigned char *p;
-	int result = 0;
-	unsigned short eth_proto;
-	struct ether_hdr *eth_hdr;
-	struct michael_mic_t michael_mic;
-	unsigned short keyinfo = 0;
-	struct ieee802_1x_hdr *aa1x_hdr;
-	struct wpa_eapol_key *eap_key;
-	struct ethhdr *eth;
-	size_t size;
-	int ret;
-
-	skb_len = skb->len;
-	if (skb_len > ETH_FRAME_LEN) {
-		DPRINTK(1, "bad length skb_len=%d\n", skb_len);
-		ret = -EOVERFLOW;
-		goto err_kfree_skb;
-	}
-
-	if (is_disconnect_status(priv->connect_status) ||
-	    (priv->connect_status & FORCE_DISCONNECT) ||
-	    priv->wpa.mic_failure.stop) {
-		DPRINTK(3, " DISCONNECT\n");
-		if (netif_queue_stopped(priv->net_dev))
-			netif_wake_queue(priv->net_dev);
-		if (skb)
-			dev_kfree_skb(skb);
-
-		return 0;
-	}
-
-	/* for PowerSave */
-	if (atomic_read(&priv->psstatus.status) == PS_SNOOZE) {	/* power save wakeup */
-		if (!netif_queue_stopped(priv->net_dev))
-			netif_stop_queue(priv->net_dev);
-	}
-
-	size = sizeof(*pp) + 6 + skb_len + 8;
-	pp = kmalloc(hif_align_size(size), KS_WLAN_MEM_FLAG);
-	if (!pp) {
-		ret = -ENOMEM;
-		goto err_kfree_skb;
-	}
-
-	p = (unsigned char *)pp->data;
-
-	buffer = skb->data;
-	length = skb->len;
-
-	/* skb check */
-	eth = (struct ethhdr *)skb->data;
-	if (memcmp(&priv->eth_addr[0], eth->h_source, ETH_ALEN) != 0) {
-		DPRINTK(1, "invalid mac address !!\n");
-		DPRINTK(1, "ethernet->h_source=%pM\n", eth->h_source);
-		ret = -ENXIO;
-		goto err_kfree;
-	}
-
-	/* dest and src MAC address copy */
-	size = ETH_ALEN * 2;
-	memcpy(p, buffer, size);
-	p += size;
-	buffer += size;
-	length -= size;
-
-	/* EtherType/Length check */
-	if (*(buffer + 1) + (*buffer << 8) > 1500) {
-		/* ProtocolEAP = *(buffer+1) + (*buffer << 8); */
-		/* DPRINTK(2, "Send [SNAP]Type %x\n",ProtocolEAP); */
-		/* SAP/CTL/OUI(6 byte) add */
-		*p++ = 0xAA;	/* DSAP */
-		*p++ = 0xAA;	/* SSAP */
-		*p++ = 0x03;	/* CTL */
-		*p++ = 0x00;	/* OUI ("000000") */
-		*p++ = 0x00;	/* OUI ("000000") */
-		*p++ = 0x00;	/* OUI ("000000") */
-		skb_len += 6;
-	} else {
-		DPRINTK(4, "DIX\n");
-		/* Length(2 byte) delete */
-		buffer += 2;
-		length -= 2;
-		skb_len -= 2;
-	}
-
-	/* pp->data copy */
-	memcpy(p, buffer, length);
-
-	p += length;
-
-	/* for WPA */
-	eth_hdr = (struct ether_hdr *)&pp->data[0];
-	eth_proto = ntohs(eth_hdr->h_proto);
-
-	/* for MIC FAILURE REPORT check */
-	if (eth_proto == ETHER_PROTOCOL_TYPE_EAP &&
-	    priv->wpa.mic_failure.failure > 0) {
-		aa1x_hdr = (struct ieee802_1x_hdr *)(eth_hdr + 1);
-		if (aa1x_hdr->type == IEEE802_1X_TYPE_EAPOL_KEY) {
-			eap_key = (struct wpa_eapol_key *)(aa1x_hdr + 1);
-			keyinfo = ntohs(eap_key->key_info);
-		}
-	}
-
-	if (priv->wpa.rsn_enabled && priv->wpa.key[0].key_len) {
-		if (eth_proto == ETHER_PROTOCOL_TYPE_EAP &&
-		    priv->wpa.key[1].key_len == 0 &&
-		    priv->wpa.key[2].key_len == 0 &&
-		    priv->wpa.key[3].key_len == 0) {
-			pp->auth_type = cpu_to_le16((uint16_t)TYPE_AUTH);	/* no encryption */
-		} else {
-			if (priv->wpa.pairwise_suite == IW_AUTH_CIPHER_TKIP) {
-				MichaelMICFunction(&michael_mic,
-						   (uint8_t *)priv->wpa.key[0].tx_mic_key,
-						   (uint8_t *)&pp->data[0],
-						   (int)skb_len,
-						   (uint8_t)0,	/* priority */
-						   (uint8_t *)michael_mic.Result);
-				memcpy(p, michael_mic.Result, 8);
-				length += 8;
-				skb_len += 8;
-				p += 8;
-				pp->auth_type =
-				    cpu_to_le16((uint16_t)TYPE_DATA);
-
-			} else if (priv->wpa.pairwise_suite ==
-				   IW_AUTH_CIPHER_CCMP) {
-				pp->auth_type =
-				    cpu_to_le16((uint16_t)TYPE_DATA);
-			}
-		}
-	} else {
-		if (eth_proto == ETHER_PROTOCOL_TYPE_EAP)
-			pp->auth_type = cpu_to_le16((uint16_t)TYPE_AUTH);
-		else
-			pp->auth_type = cpu_to_le16((uint16_t)TYPE_DATA);
-	}
-
-	/* header value set */
-	pp->header.size =
-	    cpu_to_le16((uint16_t)
-			(sizeof(*pp) - sizeof(pp->header.size) + skb_len));
-	pp->header.event = cpu_to_le16((uint16_t)HIF_DATA_REQ);
-
-	/* tx request */
-	result = ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp) + skb_len),
-			       send_packet_complete, skb);
-
-	/* MIC FAILURE REPORT check */
-	if (eth_proto == ETHER_PROTOCOL_TYPE_EAP &&
-	    priv->wpa.mic_failure.failure > 0) {
-		if (keyinfo & WPA_KEY_INFO_ERROR &&
-		    keyinfo & WPA_KEY_INFO_REQUEST) {
-			DPRINTK(3, " MIC ERROR Report SET : %04X\n", keyinfo);
-			hostif_sme_enqueue(priv, SME_MIC_FAILURE_REQUEST);
-		}
-		if (priv->wpa.mic_failure.failure == 2)
-			priv->wpa.mic_failure.stop = 1;
-	}
-
-	return result;
-
-err_kfree:
-	kfree(pp);
-err_kfree_skb:
-	dev_kfree_skb(skb);
-
-	return ret;
-}
-
-#define ps_confirm_wait_inc(priv)					 \
-	do {								 \
-		if (atomic_read(&priv->psstatus.status) > PS_ACTIVE_SET) \
-			atomic_inc(&priv->psstatus.confirm_wait);	 \
-	} while (0)
-
-static
-void hostif_mib_get_request(struct ks_wlan_private *priv,
-			    unsigned long mib_attribute)
-{
-	struct hostif_mib_get_request_t *pp;
-
-	DPRINTK(3, "\n");
-
-	pp = hostif_generic_request(sizeof(*pp), HIF_MIB_GET_REQ);
-	if (!pp)
-		return;
-
-	pp->mib_attribute = cpu_to_le32((uint32_t)mib_attribute);
-
-	/* send to device request */
-	ps_confirm_wait_inc(priv);
-	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
-}
-
-static
-void hostif_mib_set_request(struct ks_wlan_private *priv,
-			    unsigned long mib_attribute, unsigned short size,
-			    unsigned short type, void *vp)
-{
-	struct hostif_mib_set_request_t *pp;
-
-	DPRINTK(3, "\n");
-
-	if (priv->dev_state < DEVICE_STATE_BOOT) {
-		DPRINTK(3, "DeviceRemove\n");
-		return;
-	}
-
-	pp = hostif_generic_request(sizeof(*pp), HIF_MIB_SET_REQ);
-	if (!pp)
-		return;
-
-	pp->mib_attribute = cpu_to_le32((uint32_t)mib_attribute);
-	pp->mib_value.size = cpu_to_le16((uint16_t)size);
-	pp->mib_value.type = cpu_to_le16((uint16_t)type);
-	memcpy(&pp->mib_value.body, vp, size);
-
-	/* send to device request */
-	ps_confirm_wait_inc(priv);
-	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp) + size), NULL, NULL);
-}
-
-static
-void hostif_start_request(struct ks_wlan_private *priv, unsigned char mode)
-{
-	struct hostif_start_request_t *pp;
-
-	DPRINTK(3, "\n");
-
-	pp = hostif_generic_request(sizeof(*pp), HIF_START_REQ);
-	if (!pp)
-		return;
-
-	pp->mode = cpu_to_le16((uint16_t)mode);
-
-	/* send to device request */
-	ps_confirm_wait_inc(priv);
-	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
-
-	priv->aplist.size = 0;
-	priv->scan_ind_count = 0;
-}
-
-static
-void hostif_ps_adhoc_set_request(struct ks_wlan_private *priv)
-{
-	struct hostif_ps_adhoc_set_request_t *pp;
-	u16 capability;
-
-	DPRINTK(3, "\n");
-
-	pp = hostif_generic_request(sizeof(*pp), HIF_PS_ADH_SET_REQ);
-	if (!pp)
-		return;
-
-	pp->phy_type = cpu_to_le16((uint16_t)(priv->reg.phy_type));
-	pp->cts_mode = cpu_to_le16((uint16_t)(priv->reg.cts_mode));
-	pp->scan_type = cpu_to_le16((uint16_t)(priv->reg.scan_type));
-	pp->channel = cpu_to_le16((uint16_t)(priv->reg.channel));
-	pp->rate_set.size = priv->reg.rate_set.size;
-	memcpy(&pp->rate_set.body[0], &priv->reg.rate_set.body[0],
-	       priv->reg.rate_set.size);
-
-	capability = 0x0000;
-	if (priv->reg.preamble == SHORT_PREAMBLE) {
-		/* short preamble */
-		capability |= BSS_CAP_SHORT_PREAMBLE;
-	}
-	capability &= ~(BSS_CAP_PBCC);	/* pbcc not support */
-	if (priv->reg.phy_type != D_11B_ONLY_MODE) {
-		capability |= BSS_CAP_SHORT_SLOT_TIME;	/* ShortSlotTime support */
-		capability &= ~(BSS_CAP_DSSS_OFDM);	/* DSSS OFDM */
-	}
-	pp->capability = cpu_to_le16((uint16_t)capability);
-
-	/* send to device request */
-	ps_confirm_wait_inc(priv);
-	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
-}
-
-static
-void hostif_infrastructure_set_request(struct ks_wlan_private *priv)
-{
-	struct hostif_infrastructure_set_request_t *pp;
-	u16 capability;
-
-	DPRINTK(3, "ssid.size=%d\n", priv->reg.ssid.size);
-
-	pp = hostif_generic_request(sizeof(*pp), HIF_INFRA_SET_REQ);
-	if (!pp)
-		return;
-
-	pp->phy_type = cpu_to_le16((uint16_t)(priv->reg.phy_type));
-	pp->cts_mode = cpu_to_le16((uint16_t)(priv->reg.cts_mode));
-	pp->scan_type = cpu_to_le16((uint16_t)(priv->reg.scan_type));
-
-	pp->rate_set.size = priv->reg.rate_set.size;
-	memcpy(&pp->rate_set.body[0], &priv->reg.rate_set.body[0],
-	       priv->reg.rate_set.size);
-	pp->ssid.size = priv->reg.ssid.size;
-	memcpy(&pp->ssid.body[0], &priv->reg.ssid.body[0], priv->reg.ssid.size);
-
-	capability = 0x0000;
-	if (priv->reg.preamble == SHORT_PREAMBLE) {
-		/* short preamble */
-		capability |= BSS_CAP_SHORT_PREAMBLE;
-	}
-	capability &= ~(BSS_CAP_PBCC);	/* pbcc not support */
-	if (priv->reg.phy_type != D_11B_ONLY_MODE) {
-		capability |= BSS_CAP_SHORT_SLOT_TIME;	/* ShortSlotTime support */
-		capability &= ~(BSS_CAP_DSSS_OFDM);	/* DSSS OFDM not support */
-	}
-	pp->capability = cpu_to_le16((uint16_t)capability);
-	pp->beacon_lost_count =
-	    cpu_to_le16((uint16_t)(priv->reg.beacon_lost_count));
-	pp->auth_type = cpu_to_le16((uint16_t)(priv->reg.authenticate_type));
-
-	pp->channel_list.body[0] = 1;
-	pp->channel_list.body[1] = 8;
-	pp->channel_list.body[2] = 2;
-	pp->channel_list.body[3] = 9;
-	pp->channel_list.body[4] = 3;
-	pp->channel_list.body[5] = 10;
-	pp->channel_list.body[6] = 4;
-	pp->channel_list.body[7] = 11;
-	pp->channel_list.body[8] = 5;
-	pp->channel_list.body[9] = 12;
-	pp->channel_list.body[10] = 6;
-	pp->channel_list.body[11] = 13;
-	pp->channel_list.body[12] = 7;
-	if (priv->reg.phy_type == D_11G_ONLY_MODE) {
-		pp->channel_list.size = 13;
-	} else {
-		pp->channel_list.body[13] = 14;
-		pp->channel_list.size = 14;
-	}
-
-	/* send to device request */
-	ps_confirm_wait_inc(priv);
-	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
-}
-
-static void hostif_infrastructure_set2_request(struct ks_wlan_private *priv)
-{
-	struct hostif_infrastructure_set2_request_t *pp;
-	u16 capability;
-
-	DPRINTK(2, "ssid.size=%d\n", priv->reg.ssid.size);
-
-	pp = hostif_generic_request(sizeof(*pp), HIF_INFRA_SET2_REQ);
-	if (!pp)
-		return;
-
-	pp->phy_type = cpu_to_le16((uint16_t)(priv->reg.phy_type));
-	pp->cts_mode = cpu_to_le16((uint16_t)(priv->reg.cts_mode));
-	pp->scan_type = cpu_to_le16((uint16_t)(priv->reg.scan_type));
-
-	pp->rate_set.size = priv->reg.rate_set.size;
-	memcpy(&pp->rate_set.body[0], &priv->reg.rate_set.body[0],
-	       priv->reg.rate_set.size);
-	pp->ssid.size = priv->reg.ssid.size;
-	memcpy(&pp->ssid.body[0], &priv->reg.ssid.body[0], priv->reg.ssid.size);
-
-	capability = 0x0000;
-	if (priv->reg.preamble == SHORT_PREAMBLE) {
-		/* short preamble */
-		capability |= BSS_CAP_SHORT_PREAMBLE;
-	}
-	capability &= ~(BSS_CAP_PBCC);	/* pbcc not support */
-	if (priv->reg.phy_type != D_11B_ONLY_MODE) {
-		capability |= BSS_CAP_SHORT_SLOT_TIME;	/* ShortSlotTime support */
-		capability &= ~(BSS_CAP_DSSS_OFDM);	/* DSSS OFDM not support */
-	}
-	pp->capability = cpu_to_le16((uint16_t)capability);
-	pp->beacon_lost_count =
-	    cpu_to_le16((uint16_t)(priv->reg.beacon_lost_count));
-	pp->auth_type = cpu_to_le16((uint16_t)(priv->reg.authenticate_type));
-
-	pp->channel_list.body[0] = 1;
-	pp->channel_list.body[1] = 8;
-	pp->channel_list.body[2] = 2;
-	pp->channel_list.body[3] = 9;
-	pp->channel_list.body[4] = 3;
-	pp->channel_list.body[5] = 10;
-	pp->channel_list.body[6] = 4;
-	pp->channel_list.body[7] = 11;
-	pp->channel_list.body[8] = 5;
-	pp->channel_list.body[9] = 12;
-	pp->channel_list.body[10] = 6;
-	pp->channel_list.body[11] = 13;
-	pp->channel_list.body[12] = 7;
-	if (priv->reg.phy_type == D_11G_ONLY_MODE) {
-		pp->channel_list.size = 13;
-	} else {
-		pp->channel_list.body[13] = 14;
-		pp->channel_list.size = 14;
-	}
-
-	memcpy(pp->bssid, priv->reg.bssid, ETH_ALEN);
-
-	/* send to device request */
-	ps_confirm_wait_inc(priv);
-	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
-}
-
-static
-void hostif_adhoc_set_request(struct ks_wlan_private *priv)
-{
-	struct hostif_adhoc_set_request_t *pp;
-	u16 capability;
-
-	DPRINTK(3, "\n");
-
-	pp = hostif_generic_request(sizeof(*pp), HIF_ADH_SET_REQ);
-	if (!pp)
-		return;
-
-	pp->phy_type = cpu_to_le16((uint16_t)(priv->reg.phy_type));
-	pp->cts_mode = cpu_to_le16((uint16_t)(priv->reg.cts_mode));
-	pp->scan_type = cpu_to_le16((uint16_t)(priv->reg.scan_type));
-	pp->channel = cpu_to_le16((uint16_t)(priv->reg.channel));
-	pp->rate_set.size = priv->reg.rate_set.size;
-	memcpy(&pp->rate_set.body[0], &priv->reg.rate_set.body[0],
-	       priv->reg.rate_set.size);
-	pp->ssid.size = priv->reg.ssid.size;
-	memcpy(&pp->ssid.body[0], &priv->reg.ssid.body[0], priv->reg.ssid.size);
-
-	capability = 0x0000;
-	if (priv->reg.preamble == SHORT_PREAMBLE) {
-		/* short preamble */
-		capability |= BSS_CAP_SHORT_PREAMBLE;
-	}
-	capability &= ~(BSS_CAP_PBCC);	/* pbcc not support */
-	if (priv->reg.phy_type != D_11B_ONLY_MODE) {
-		capability |= BSS_CAP_SHORT_SLOT_TIME;	/* ShortSlotTime support */
-		capability &= ~(BSS_CAP_DSSS_OFDM);	/* DSSS OFDM not support */
-	}
-	pp->capability = cpu_to_le16((uint16_t)capability);
-
-	/* send to device request */
-	ps_confirm_wait_inc(priv);
-	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
-}
-
-static
-void hostif_adhoc_set2_request(struct ks_wlan_private *priv)
-{
-	struct hostif_adhoc_set2_request_t *pp;
-	u16 capability;
-
-	DPRINTK(3, "\n");
-
-	pp = hostif_generic_request(sizeof(*pp), HIF_ADH_SET_REQ);
-	if (!pp)
-		return;
-
-	pp->phy_type = cpu_to_le16((uint16_t)(priv->reg.phy_type));
-	pp->cts_mode = cpu_to_le16((uint16_t)(priv->reg.cts_mode));
-	pp->scan_type = cpu_to_le16((uint16_t)(priv->reg.scan_type));
-	pp->rate_set.size = priv->reg.rate_set.size;
-	memcpy(&pp->rate_set.body[0], &priv->reg.rate_set.body[0],
-	       priv->reg.rate_set.size);
-	pp->ssid.size = priv->reg.ssid.size;
-	memcpy(&pp->ssid.body[0], &priv->reg.ssid.body[0], priv->reg.ssid.size);
-
-	capability = 0x0000;
-	if (priv->reg.preamble == SHORT_PREAMBLE) {
-		/* short preamble */
-		capability |= BSS_CAP_SHORT_PREAMBLE;
-	}
-	capability &= ~(BSS_CAP_PBCC);	/* pbcc not support */
-	if (priv->reg.phy_type != D_11B_ONLY_MODE) {
-		capability |= BSS_CAP_SHORT_SLOT_TIME;	/* ShortSlotTime support */
-		capability &= ~(BSS_CAP_DSSS_OFDM);	/* DSSS OFDM not support */
-	}
-	pp->capability = cpu_to_le16((uint16_t)capability);
-
-	pp->channel_list.body[0] = priv->reg.channel;
-	pp->channel_list.size = 1;
-	memcpy(pp->bssid, priv->reg.bssid, ETH_ALEN);
-
-	/* send to device request */
-	ps_confirm_wait_inc(priv);
-	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
-}
-
-static
-void hostif_stop_request(struct ks_wlan_private *priv)
-{
-	struct hostif_stop_request_t *pp;
-
-	DPRINTK(3, "\n");
-
-	pp = hostif_generic_request(sizeof(*pp), HIF_STOP_REQ);
-	if (!pp)
-		return;
-
-	/* send to device request */
-	ps_confirm_wait_inc(priv);
-	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
-}
-
-static
-void hostif_phy_information_request(struct ks_wlan_private *priv)
-{
-	struct hostif_phy_information_request_t *pp;
-
-	DPRINTK(3, "\n");
-
-	pp = hostif_generic_request(sizeof(*pp), HIF_PHY_INFO_REQ);
-	if (!pp)
-		return;
-
-	if (priv->reg.phy_info_timer) {
-		pp->type = cpu_to_le16((uint16_t)TIME_TYPE);
-		pp->time = cpu_to_le16((uint16_t)(priv->reg.phy_info_timer));
-	} else {
-		pp->type = cpu_to_le16((uint16_t)NORMAL_TYPE);
-		pp->time = cpu_to_le16((uint16_t)0);
-	}
-
-	/* send to device request */
-	ps_confirm_wait_inc(priv);
-	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
-}
-
-static
-void hostif_power_mgmt_request(struct ks_wlan_private *priv,
-			       unsigned long mode, unsigned long wake_up,
-			       unsigned long receiveDTIMs)
-{
-	struct hostif_power_mgmt_request_t *pp;
-
-	DPRINTK(3, "mode=%lu wake_up=%lu receiveDTIMs=%lu\n", mode, wake_up,
-		receiveDTIMs);
-
-	pp = hostif_generic_request(sizeof(*pp), HIF_POWER_MGMT_REQ);
-	if (!pp)
-		return;
-
-	pp->mode = cpu_to_le32((uint32_t)mode);
-	pp->wake_up = cpu_to_le32((uint32_t)wake_up);
-	pp->receiveDTIMs = cpu_to_le32((uint32_t)receiveDTIMs);
-
-	/* send to device request */
-	ps_confirm_wait_inc(priv);
-	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
-}
-
-static
-void hostif_sleep_request(struct ks_wlan_private *priv,
-			  enum sleep_mode_type mode)
-{
-	struct hostif_sleep_request_t *pp;
-
-	DPRINTK(3, "mode=%lu\n", (long)mode);
-
-	if (mode == SLP_SLEEP) {
-		pp = hostif_generic_request(sizeof(*pp), HIF_SLEEP_REQ);
-		if (!pp)
-			return;
-
-		/* send to device request */
-		ps_confirm_wait_inc(priv);
-		ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL,
-			      NULL);
-	} else if (mode == SLP_ACTIVE) {
-		atomic_set(&priv->sleepstatus.wakeup_request, 1);
-		queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
-	} else {
-		DPRINTK(3, "invalid mode %ld\n", (long)mode);
-		return;
-	}
-}
-
-static
-void hostif_bss_scan_request(struct ks_wlan_private *priv,
-			     unsigned long scan_type, uint8_t *scan_ssid,
-			     uint8_t scan_ssid_len)
-{
-	struct hostif_bss_scan_request_t *pp;
-
-	DPRINTK(2, "\n");
-
-	pp = hostif_generic_request(sizeof(*pp), HIF_SCAN_REQ);
-	if (!pp)
-		return;
-
-	pp->scan_type = scan_type;
-
-	pp->ch_time_min = cpu_to_le32((uint32_t)110);	/* default value */
-	pp->ch_time_max = cpu_to_le32((uint32_t)130);	/* default value */
-	pp->channel_list.body[0] = 1;
-	pp->channel_list.body[1] = 8;
-	pp->channel_list.body[2] = 2;
-	pp->channel_list.body[3] = 9;
-	pp->channel_list.body[4] = 3;
-	pp->channel_list.body[5] = 10;
-	pp->channel_list.body[6] = 4;
-	pp->channel_list.body[7] = 11;
-	pp->channel_list.body[8] = 5;
-	pp->channel_list.body[9] = 12;
-	pp->channel_list.body[10] = 6;
-	pp->channel_list.body[11] = 13;
-	pp->channel_list.body[12] = 7;
-	if (priv->reg.phy_type == D_11G_ONLY_MODE) {
-		pp->channel_list.size = 13;
-	} else {
-		pp->channel_list.body[13] = 14;
-		pp->channel_list.size = 14;
-	}
-	pp->ssid.size = 0;
-
-	/* specified SSID SCAN */
-	if (scan_ssid_len > 0 && scan_ssid_len <= 32) {
-		pp->ssid.size = scan_ssid_len;
-		memcpy(&pp->ssid.body[0], scan_ssid, scan_ssid_len);
-	}
-
-	/* send to device request */
-	ps_confirm_wait_inc(priv);
-	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
-
-	priv->aplist.size = 0;
-	priv->scan_ind_count = 0;
-}
-
-static
-void hostif_mic_failure_request(struct ks_wlan_private *priv,
-				unsigned short failure_count,
-				unsigned short timer)
-{
-	struct hostif_mic_failure_request_t *pp;
-
-	DPRINTK(3, "count=%d :: timer=%d\n", failure_count, timer);
-
-	pp = hostif_generic_request(sizeof(*pp), HIF_MIC_FAILURE_REQ);
-	if (!pp)
-		return;
-
-	pp->failure_count = cpu_to_le16((uint16_t)failure_count);
-	pp->timer = cpu_to_le16((uint16_t)timer);
-
-	/* send to device request */
-	ps_confirm_wait_inc(priv);
-	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
-}
-
-/* Device I/O Receive indicate */
-static void devio_rec_ind(struct ks_wlan_private *priv, unsigned char *p,
-			  unsigned int size)
-{
-	if (priv->device_open_status) {
-		spin_lock(&priv->dev_read_lock);	/* request spin lock */
-		priv->dev_data[atomic_read(&priv->rec_count)] = p;
-		priv->dev_size[atomic_read(&priv->rec_count)] = size;
-
-		if (atomic_read(&priv->event_count) != DEVICE_STOCK_COUNT) {
-			/* rx event count inc */
-			atomic_inc(&priv->event_count);
-		}
-		atomic_inc(&priv->rec_count);
-		if (atomic_read(&priv->rec_count) == DEVICE_STOCK_COUNT)
-			atomic_set(&priv->rec_count, 0);
-
-		wake_up_interruptible_all(&priv->devread_wait);
-
-		/* release spin lock */
-		spin_unlock(&priv->dev_read_lock);
-	}
-}
-
-void hostif_receive(struct ks_wlan_private *priv, unsigned char *p,
-		    unsigned int size)
-{
-	DPRINTK(4, "\n");
-
-	devio_rec_ind(priv, p, size);
-
-	priv->rxp = p;
-	priv->rx_size = size;
-
-	if (get_WORD(priv) == priv->rx_size) {	/* length check !! */
-		hostif_event_check(priv);	/* event check */
-	}
-}
-
-static
-void hostif_sme_set_wep(struct ks_wlan_private *priv, int type)
-{
-	u32 val;
-
-	switch (type) {
-	case SME_WEP_INDEX_REQUEST:
-		val = cpu_to_le32((uint32_t)(priv->reg.wep_index));
-		hostif_mib_set_request(priv, DOT11_WEP_DEFAULT_KEY_ID,
-				       sizeof(val), MIB_VALUE_TYPE_INT, &val);
-		break;
-	case SME_WEP_KEY1_REQUEST:
-		if (!priv->wpa.wpa_enabled)
-			hostif_mib_set_request(priv,
-					       DOT11_WEP_DEFAULT_KEY_VALUE1,
-					       priv->reg.wep_key[0].size,
-					       MIB_VALUE_TYPE_OSTRING,
-					       &priv->reg.wep_key[0].val[0]);
-		break;
-	case SME_WEP_KEY2_REQUEST:
-		if (!priv->wpa.wpa_enabled)
-			hostif_mib_set_request(priv,
-					       DOT11_WEP_DEFAULT_KEY_VALUE2,
-					       priv->reg.wep_key[1].size,
-					       MIB_VALUE_TYPE_OSTRING,
-					       &priv->reg.wep_key[1].val[0]);
-		break;
-	case SME_WEP_KEY3_REQUEST:
-		if (!priv->wpa.wpa_enabled)
-			hostif_mib_set_request(priv,
-					       DOT11_WEP_DEFAULT_KEY_VALUE3,
-					       priv->reg.wep_key[2].size,
-					       MIB_VALUE_TYPE_OSTRING,
-					       &priv->reg.wep_key[2].val[0]);
-		break;
-	case SME_WEP_KEY4_REQUEST:
-		if (!priv->wpa.wpa_enabled)
-			hostif_mib_set_request(priv,
-					       DOT11_WEP_DEFAULT_KEY_VALUE4,
-					       priv->reg.wep_key[3].size,
-					       MIB_VALUE_TYPE_OSTRING,
-					       &priv->reg.wep_key[3].val[0]);
-		break;
-	case SME_WEP_FLAG_REQUEST:
-		val = cpu_to_le32((uint32_t)(priv->reg.privacy_invoked));
-		hostif_mib_set_request(priv, DOT11_PRIVACY_INVOKED,
-				       sizeof(val), MIB_VALUE_TYPE_BOOL, &val);
-		break;
-	}
-}
-
-struct wpa_suite_t {
-	unsigned short size;
-	unsigned char suite[4][CIPHER_ID_LEN];
-} __packed;
-
-struct rsn_mode_t {
-	u32 rsn_mode;
-	u16 rsn_capability;
-} __packed;
-
-static
-void hostif_sme_set_rsn(struct ks_wlan_private *priv, int type)
-{
-	struct wpa_suite_t wpa_suite;
-	struct rsn_mode_t rsn_mode;
-	u32 val;
-
-	memset(&wpa_suite, 0, sizeof(wpa_suite));
-
-	switch (type) {
-	case SME_RSN_UCAST_REQUEST:
-		wpa_suite.size = cpu_to_le16((uint16_t)1);
-		switch (priv->wpa.pairwise_suite) {
-		case IW_AUTH_CIPHER_NONE:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA2_NONE, CIPHER_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA_NONE, CIPHER_ID_LEN);
-			break;
-		case IW_AUTH_CIPHER_WEP40:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA2_WEP40, CIPHER_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA_WEP40, CIPHER_ID_LEN);
-			break;
-		case IW_AUTH_CIPHER_TKIP:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA2_TKIP, CIPHER_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA_TKIP, CIPHER_ID_LEN);
-			break;
-		case IW_AUTH_CIPHER_CCMP:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA2_CCMP, CIPHER_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA_CCMP, CIPHER_ID_LEN);
-			break;
-		case IW_AUTH_CIPHER_WEP104:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA2_WEP104, CIPHER_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA_WEP104, CIPHER_ID_LEN);
-			break;
-		}
-
-		hostif_mib_set_request(priv, DOT11_RSN_CONFIG_UNICAST_CIPHER,
-				       sizeof(wpa_suite.size) +
-				       CIPHER_ID_LEN * wpa_suite.size,
-				       MIB_VALUE_TYPE_OSTRING, &wpa_suite);
-		break;
-	case SME_RSN_MCAST_REQUEST:
-		switch (priv->wpa.group_suite) {
-		case IW_AUTH_CIPHER_NONE:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA2_NONE, CIPHER_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA_NONE, CIPHER_ID_LEN);
-			break;
-		case IW_AUTH_CIPHER_WEP40:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA2_WEP40, CIPHER_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA_WEP40, CIPHER_ID_LEN);
-			break;
-		case IW_AUTH_CIPHER_TKIP:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA2_TKIP, CIPHER_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA_TKIP, CIPHER_ID_LEN);
-			break;
-		case IW_AUTH_CIPHER_CCMP:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA2_CCMP, CIPHER_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA_CCMP, CIPHER_ID_LEN);
-			break;
-		case IW_AUTH_CIPHER_WEP104:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA2_WEP104, CIPHER_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       CIPHER_ID_WPA_WEP104, CIPHER_ID_LEN);
-			break;
-		}
-
-		hostif_mib_set_request(priv, DOT11_RSN_CONFIG_MULTICAST_CIPHER,
-				       CIPHER_ID_LEN, MIB_VALUE_TYPE_OSTRING,
-				       &wpa_suite.suite[0][0]);
-		break;
-	case SME_RSN_AUTH_REQUEST:
-		wpa_suite.size = cpu_to_le16((uint16_t)1);
-		switch (priv->wpa.key_mgmt_suite) {
-		case IW_AUTH_KEY_MGMT_802_1X:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       KEY_MGMT_ID_WPA2_1X, KEY_MGMT_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       KEY_MGMT_ID_WPA_1X, KEY_MGMT_ID_LEN);
-			break;
-		case IW_AUTH_KEY_MGMT_PSK:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       KEY_MGMT_ID_WPA2_PSK, KEY_MGMT_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       KEY_MGMT_ID_WPA_PSK, KEY_MGMT_ID_LEN);
-			break;
-		case 0:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       KEY_MGMT_ID_WPA2_NONE, KEY_MGMT_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       KEY_MGMT_ID_WPA_NONE, KEY_MGMT_ID_LEN);
-			break;
-		case 4:
-			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
-				memcpy(&wpa_suite.suite[0][0],
-				       KEY_MGMT_ID_WPA2_WPANONE,
-				       KEY_MGMT_ID_LEN);
-			else
-				memcpy(&wpa_suite.suite[0][0],
-				       KEY_MGMT_ID_WPA_WPANONE,
-				       KEY_MGMT_ID_LEN);
-			break;
-		}
-
-		hostif_mib_set_request(priv, DOT11_RSN_CONFIG_AUTH_SUITE,
-				       sizeof(wpa_suite.size) +
-				       KEY_MGMT_ID_LEN * wpa_suite.size,
-				       MIB_VALUE_TYPE_OSTRING, &wpa_suite);
-		break;
-	case SME_RSN_ENABLED_REQUEST:
-		val = cpu_to_le32((uint32_t)(priv->wpa.rsn_enabled));
-		hostif_mib_set_request(priv, DOT11_RSN_ENABLED,
-				       sizeof(val), MIB_VALUE_TYPE_BOOL, &val);
-		break;
-	case SME_RSN_MODE_REQUEST:
-		if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2) {
-			rsn_mode.rsn_mode =
-			    cpu_to_le32((uint32_t)RSN_MODE_WPA2);
-			rsn_mode.rsn_capability = cpu_to_le16((uint16_t)0);
-		} else if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA) {
-			rsn_mode.rsn_mode =
-			    cpu_to_le32((uint32_t)RSN_MODE_WPA);
-			rsn_mode.rsn_capability = cpu_to_le16((uint16_t)0);
-		} else {
-			rsn_mode.rsn_mode =
-			    cpu_to_le32((uint32_t)RSN_MODE_NONE);
-			rsn_mode.rsn_capability = cpu_to_le16((uint16_t)0);
-		}
-		hostif_mib_set_request(priv, LOCAL_RSN_MODE, sizeof(rsn_mode),
-				       MIB_VALUE_TYPE_OSTRING, &rsn_mode);
-		break;
-	}
-}
-
-static
-void hostif_sme_mode_setup(struct ks_wlan_private *priv)
-{
-	unsigned char rate_size;
-	unsigned char rate_octet[RATE_SET_MAX_SIZE];
-	int i = 0;
-
-	/* rate setting if rate segging is auto for changing phy_type (#94) */
-	if (priv->reg.tx_rate == TX_RATE_FULL_AUTO) {
-		if (priv->reg.phy_type == D_11B_ONLY_MODE) {
-			priv->reg.rate_set.body[3] = TX_RATE_11M;
-			priv->reg.rate_set.body[2] = TX_RATE_5M;
-			priv->reg.rate_set.body[1] = TX_RATE_2M | BASIC_RATE;
-			priv->reg.rate_set.body[0] = TX_RATE_1M | BASIC_RATE;
-			priv->reg.rate_set.size = 4;
-		} else {	/* D_11G_ONLY_MODE or D_11BG_COMPATIBLE_MODE */
-			priv->reg.rate_set.body[11] = TX_RATE_54M;
-			priv->reg.rate_set.body[10] = TX_RATE_48M;
-			priv->reg.rate_set.body[9] = TX_RATE_36M;
-			priv->reg.rate_set.body[8] = TX_RATE_18M;
-			priv->reg.rate_set.body[7] = TX_RATE_9M;
-			priv->reg.rate_set.body[6] = TX_RATE_24M | BASIC_RATE;
-			priv->reg.rate_set.body[5] = TX_RATE_12M | BASIC_RATE;
-			priv->reg.rate_set.body[4] = TX_RATE_6M | BASIC_RATE;
-			priv->reg.rate_set.body[3] = TX_RATE_11M | BASIC_RATE;
-			priv->reg.rate_set.body[2] = TX_RATE_5M | BASIC_RATE;
-			priv->reg.rate_set.body[1] = TX_RATE_2M | BASIC_RATE;
-			priv->reg.rate_set.body[0] = TX_RATE_1M | BASIC_RATE;
-			priv->reg.rate_set.size = 12;
-		}
-	}
-
-	/* rate mask by phy setting */
-	if (priv->reg.phy_type == D_11B_ONLY_MODE) {
-		for (i = 0; i < priv->reg.rate_set.size; i++) {
-			if (!IS_11B_RATE(priv->reg.rate_set.body[i]))
-				break;
-
-			if ((priv->reg.rate_set.body[i] & RATE_MASK) >= TX_RATE_5M) {
-				rate_octet[i] = priv->reg.rate_set.body[i] &
-						RATE_MASK;
-			} else {
-				rate_octet[i] = priv->reg.rate_set.body[i];
-			}
-		}
-
-	} else {	/* D_11G_ONLY_MODE or D_11BG_COMPATIBLE_MODE */
-		for (i = 0; i < priv->reg.rate_set.size; i++) {
-			if (!IS_11BG_RATE(priv->reg.rate_set.body[i]))
-				break;
-
-			if (IS_OFDM_EXT_RATE(priv->reg.rate_set.body[i])) {
-				rate_octet[i] = priv->reg.rate_set.body[i] &
-						RATE_MASK;
-			} else {
-				rate_octet[i] = priv->reg.rate_set.body[i];
-			}
-		}
-	}
-	rate_size = i;
-	if (rate_size == 0) {
-		if (priv->reg.phy_type == D_11G_ONLY_MODE)
-			rate_octet[0] = TX_RATE_6M | BASIC_RATE;
-		else
-			rate_octet[0] = TX_RATE_2M | BASIC_RATE;
-		rate_size = 1;
-	}
-
-	/* rate set update */
-	priv->reg.rate_set.size = rate_size;
-	memcpy(&priv->reg.rate_set.body[0], &rate_octet[0], rate_size);
-
-	switch (priv->reg.operation_mode) {
-	case MODE_PSEUDO_ADHOC:
-		/* Pseudo Ad-Hoc mode */
-		hostif_ps_adhoc_set_request(priv);
-		break;
-	case MODE_INFRASTRUCTURE:
-		/* Infrastructure mode */
-		if (!is_valid_ether_addr((u8 *)priv->reg.bssid)) {
-			hostif_infrastructure_set_request(priv);
-		} else {
-			hostif_infrastructure_set2_request(priv);
-			DPRINTK(2,
-				"Infra bssid = %pM\n", priv->reg.bssid);
-		}
-		break;
-	case MODE_ADHOC:
-		/* IEEE802.11 Ad-Hoc mode */
-		if (!is_valid_ether_addr((u8 *)priv->reg.bssid)) {
-			hostif_adhoc_set_request(priv);
-		} else {
-			hostif_adhoc_set2_request(priv);
-			DPRINTK(2,
-				"Adhoc bssid = %pM\n", priv->reg.bssid);
-		}
-		break;
-	default:
-		break;
-	}
-}
-
-static
-void hostif_sme_multicast_set(struct ks_wlan_private *priv)
-{
-	struct net_device *dev = priv->net_dev;
-	int mc_count;
-	struct netdev_hw_addr *ha;
-	char set_address[NIC_MAX_MCAST_LIST * ETH_ALEN];
-	unsigned long filter_type;
-	int i = 0;
-
-	DPRINTK(3, "\n");
-
-	spin_lock(&priv->multicast_spin);
-
-	memset(set_address, 0, NIC_MAX_MCAST_LIST * ETH_ALEN);
-
-	if (dev->flags & IFF_PROMISC) {
-		filter_type = cpu_to_le32((uint32_t)MCAST_FILTER_PROMISC);
-		hostif_mib_set_request(priv, LOCAL_MULTICAST_FILTER,
-				       sizeof(filter_type), MIB_VALUE_TYPE_BOOL,
-				       &filter_type);
-		goto spin_unlock;
-	}
-
-	if ((netdev_mc_count(dev) > NIC_MAX_MCAST_LIST) ||
-	    (dev->flags & IFF_ALLMULTI)) {
-		filter_type = cpu_to_le32((uint32_t)MCAST_FILTER_MCASTALL);
-		hostif_mib_set_request(priv, LOCAL_MULTICAST_FILTER,
-				       sizeof(filter_type), MIB_VALUE_TYPE_BOOL,
-				       &filter_type);
-		goto spin_unlock;
-	}
-
-	if (priv->sme_i.sme_flag & SME_MULTICAST) {
-		mc_count = netdev_mc_count(dev);
-		netdev_for_each_mc_addr(ha, dev) {
-			memcpy(&set_address[i * ETH_ALEN], ha->addr, ETH_ALEN);
-			i++;
-		}
-		priv->sme_i.sme_flag &= ~SME_MULTICAST;
-		hostif_mib_set_request(priv, LOCAL_MULTICAST_ADDRESS,
-				       ETH_ALEN * mc_count,
-				       MIB_VALUE_TYPE_OSTRING,
-				       &set_address[0]);
-	} else {
-		filter_type = cpu_to_le32((uint32_t)MCAST_FILTER_MCAST);
-		priv->sme_i.sme_flag |= SME_MULTICAST;
-		hostif_mib_set_request(priv, LOCAL_MULTICAST_FILTER,
-				       sizeof(filter_type), MIB_VALUE_TYPE_BOOL,
-				       &filter_type);
-	}
-
-spin_unlock:
-	spin_unlock(&priv->multicast_spin);
-}
-
-static
-void hostif_sme_power_mgmt_set(struct ks_wlan_private *priv)
-{
-	unsigned long mode, wake_up, receiveDTIMs;
-
-	DPRINTK(3, "\n");
-	switch (priv->reg.power_mgmt) {
-	case POWER_MGMT_ACTIVE:
-		mode = POWER_ACTIVE;
-		wake_up = 0;
-		receiveDTIMs = 0;
-		break;
-	case POWER_MGMT_SAVE1:
-		if (priv->reg.operation_mode == MODE_INFRASTRUCTURE) {
-			mode = POWER_SAVE;
-			wake_up = 0;
-			receiveDTIMs = 0;
-		} else {
-			mode = POWER_ACTIVE;
-			wake_up = 0;
-			receiveDTIMs = 0;
-		}
-		break;
-	case POWER_MGMT_SAVE2:
-		if (priv->reg.operation_mode == MODE_INFRASTRUCTURE) {
-			mode = POWER_SAVE;
-			wake_up = 0;
-			receiveDTIMs = 1;
-		} else {
-			mode = POWER_ACTIVE;
-			wake_up = 0;
-			receiveDTIMs = 0;
-		}
-		break;
-	default:
-		mode = POWER_ACTIVE;
-		wake_up = 0;
-		receiveDTIMs = 0;
-		break;
-	}
-	hostif_power_mgmt_request(priv, mode, wake_up, receiveDTIMs);
-}
-
-static
-void hostif_sme_sleep_set(struct ks_wlan_private *priv)
-{
-	DPRINTK(3, "\n");
-	switch (priv->sleep_mode) {
-	case SLP_SLEEP:
-		hostif_sleep_request(priv, priv->sleep_mode);
-		break;
-	case SLP_ACTIVE:
-		hostif_sleep_request(priv, priv->sleep_mode);
-		break;
-	default:
-		break;
-	}
-}
-
-static
-void hostif_sme_set_key(struct ks_wlan_private *priv, int type)
-{
-	u32 val;
-
-	switch (type) {
-	case SME_SET_FLAG:
-		val = cpu_to_le32((uint32_t)(priv->reg.privacy_invoked));
-		hostif_mib_set_request(priv, DOT11_PRIVACY_INVOKED,
-				       sizeof(val), MIB_VALUE_TYPE_BOOL, &val);
-		break;
-	case SME_SET_TXKEY:
-		val = cpu_to_le32((uint32_t)(priv->wpa.txkey));
-		hostif_mib_set_request(priv, DOT11_WEP_DEFAULT_KEY_ID,
-				       sizeof(val), MIB_VALUE_TYPE_INT, &val);
-		break;
-	case SME_SET_KEY1:
-		hostif_mib_set_request(priv, DOT11_WEP_DEFAULT_KEY_VALUE1,
-				       priv->wpa.key[0].key_len,
-				       MIB_VALUE_TYPE_OSTRING,
-				       &priv->wpa.key[0].key_val[0]);
-		break;
-	case SME_SET_KEY2:
-		hostif_mib_set_request(priv, DOT11_WEP_DEFAULT_KEY_VALUE2,
-				       priv->wpa.key[1].key_len,
-				       MIB_VALUE_TYPE_OSTRING,
-				       &priv->wpa.key[1].key_val[0]);
-		break;
-	case SME_SET_KEY3:
-		hostif_mib_set_request(priv, DOT11_WEP_DEFAULT_KEY_VALUE3,
-				       priv->wpa.key[2].key_len,
-				       MIB_VALUE_TYPE_OSTRING,
-				       &priv->wpa.key[2].key_val[0]);
-		break;
-	case SME_SET_KEY4:
-		hostif_mib_set_request(priv, DOT11_WEP_DEFAULT_KEY_VALUE4,
-				       priv->wpa.key[3].key_len,
-				       MIB_VALUE_TYPE_OSTRING,
-				       &priv->wpa.key[3].key_val[0]);
-		break;
-	case SME_SET_PMK_TSC:
-		hostif_mib_set_request(priv, DOT11_PMK_TSC,
-				       WPA_RX_SEQ_LEN, MIB_VALUE_TYPE_OSTRING,
-				       &priv->wpa.key[0].rx_seq[0]);
-		break;
-	case SME_SET_GMK1_TSC:
-		hostif_mib_set_request(priv, DOT11_GMK1_TSC,
-				       WPA_RX_SEQ_LEN, MIB_VALUE_TYPE_OSTRING,
-				       &priv->wpa.key[1].rx_seq[0]);
-		break;
-	case SME_SET_GMK2_TSC:
-		hostif_mib_set_request(priv, DOT11_GMK2_TSC,
-				       WPA_RX_SEQ_LEN, MIB_VALUE_TYPE_OSTRING,
-				       &priv->wpa.key[2].rx_seq[0]);
-		break;
-	}
-}
-
-static
-void hostif_sme_set_pmksa(struct ks_wlan_private *priv)
-{
-	struct pmk_cache_t {
-		u16 size;
-		struct {
-			u8 bssid[ETH_ALEN];
-			u8 pmkid[IW_PMKID_LEN];
-		} __packed list[PMK_LIST_MAX];
-	} __packed pmkcache;
-	struct pmk_t *pmk;
-	int i;
-
-	DPRINTK(4, "pmklist.size=%d\n", priv->pmklist.size);
-	i = 0;
-	list_for_each_entry(pmk, &priv->pmklist.head, list) {
-		if (i < PMK_LIST_MAX) {
-			memcpy(pmkcache.list[i].bssid, pmk->bssid, ETH_ALEN);
-			memcpy(pmkcache.list[i].pmkid, pmk->pmkid,
-			       IW_PMKID_LEN);
-			i++;
-		}
-	}
-	pmkcache.size = cpu_to_le16((uint16_t)(priv->pmklist.size));
-	hostif_mib_set_request(priv, LOCAL_PMK,
-			       sizeof(priv->pmklist.size) + (ETH_ALEN +
-							     IW_PMKID_LEN) *
-			       (priv->pmklist.size), MIB_VALUE_TYPE_OSTRING,
-			       &pmkcache);
-}
-
-/* execute sme */
-static
-void hostif_sme_execute(struct ks_wlan_private *priv, int event)
-{
-	u32 val;
-
-	DPRINTK(3, "event=%d\n", event);
-	switch (event) {
-	case SME_START:
-		if (priv->dev_state == DEVICE_STATE_BOOT)
-			hostif_mib_get_request(priv, DOT11_MAC_ADDRESS);
-		break;
-	case SME_MULTICAST_REQUEST:
-		hostif_sme_multicast_set(priv);
-		break;
-	case SME_MACADDRESS_SET_REQUEST:
-		hostif_mib_set_request(priv, LOCAL_CURRENTADDRESS, ETH_ALEN,
-				       MIB_VALUE_TYPE_OSTRING,
-				       &priv->eth_addr[0]);
-		break;
-	case SME_BSS_SCAN_REQUEST:
-		hostif_bss_scan_request(priv, priv->reg.scan_type,
-					priv->scan_ssid, priv->scan_ssid_len);
-		break;
-	case SME_POW_MNGMT_REQUEST:
-		hostif_sme_power_mgmt_set(priv);
-		break;
-	case SME_PHY_INFO_REQUEST:
-		hostif_phy_information_request(priv);
-		break;
-	case SME_MIC_FAILURE_REQUEST:
-		if (priv->wpa.mic_failure.failure == 1) {
-			hostif_mic_failure_request(priv,
-						   priv->wpa.mic_failure.failure - 1,
-						   0);
-		} else if (priv->wpa.mic_failure.failure == 2) {
-			hostif_mic_failure_request(priv,
-						   priv->wpa.mic_failure.failure - 1,
-						   priv->wpa.mic_failure.counter);
-		} else {
-			DPRINTK(4, "SME_MIC_FAILURE_REQUEST: failure count=%u error?\n",
-				priv->wpa.mic_failure.failure);
-		}
-		break;
-	case SME_MIC_FAILURE_CONFIRM:
-		if (priv->wpa.mic_failure.failure == 2) {
-			if (priv->wpa.mic_failure.stop)
-				priv->wpa.mic_failure.stop = 0;
-			priv->wpa.mic_failure.failure = 0;
-			hostif_start_request(priv, priv->reg.operation_mode);
-		}
-		break;
-	case SME_GET_MAC_ADDRESS:
-		if (priv->dev_state == DEVICE_STATE_BOOT)
-			hostif_mib_get_request(priv, DOT11_PRODUCT_VERSION);
-		break;
-	case SME_GET_PRODUCT_VERSION:
-		if (priv->dev_state == DEVICE_STATE_BOOT)
-			priv->dev_state = DEVICE_STATE_PREINIT;
-		break;
-	case SME_STOP_REQUEST:
-		hostif_stop_request(priv);
-		break;
-	case SME_RTS_THRESHOLD_REQUEST:
-		val = cpu_to_le32((uint32_t)(priv->reg.rts));
-		hostif_mib_set_request(priv, DOT11_RTS_THRESHOLD,
-				       sizeof(val), MIB_VALUE_TYPE_INT, &val);
-		break;
-	case SME_FRAGMENTATION_THRESHOLD_REQUEST:
-		val = cpu_to_le32((uint32_t)(priv->reg.fragment));
-		hostif_mib_set_request(priv, DOT11_FRAGMENTATION_THRESHOLD,
-				       sizeof(val), MIB_VALUE_TYPE_INT, &val);
-		break;
-	case SME_WEP_INDEX_REQUEST:
-	case SME_WEP_KEY1_REQUEST:
-	case SME_WEP_KEY2_REQUEST:
-	case SME_WEP_KEY3_REQUEST:
-	case SME_WEP_KEY4_REQUEST:
-	case SME_WEP_FLAG_REQUEST:
-		hostif_sme_set_wep(priv, event);
-		break;
-	case SME_RSN_UCAST_REQUEST:
-	case SME_RSN_MCAST_REQUEST:
-	case SME_RSN_AUTH_REQUEST:
-	case SME_RSN_ENABLED_REQUEST:
-	case SME_RSN_MODE_REQUEST:
-		hostif_sme_set_rsn(priv, event);
-		break;
-	case SME_SET_FLAG:
-	case SME_SET_TXKEY:
-	case SME_SET_KEY1:
-	case SME_SET_KEY2:
-	case SME_SET_KEY3:
-	case SME_SET_KEY4:
-	case SME_SET_PMK_TSC:
-	case SME_SET_GMK1_TSC:
-	case SME_SET_GMK2_TSC:
-		hostif_sme_set_key(priv, event);
-		break;
-	case SME_SET_PMKSA:
-		hostif_sme_set_pmksa(priv);
-		break;
-#ifdef WPS
-	case SME_WPS_ENABLE_REQUEST:
-		hostif_mib_set_request(priv, LOCAL_WPS_ENABLE,
-				       sizeof(priv->wps.wps_enabled),
-				       MIB_VALUE_TYPE_INT,
-				       &priv->wps.wps_enabled);
-		break;
-	case SME_WPS_PROBE_REQUEST:
-		hostif_mib_set_request(priv, LOCAL_WPS_PROBE_REQ,
-				       priv->wps.ielen,
-				       MIB_VALUE_TYPE_OSTRING, priv->wps.ie);
-		break;
-#endif /* WPS */
-	case SME_MODE_SET_REQUEST:
-		hostif_sme_mode_setup(priv);
-		break;
-	case SME_SET_GAIN:
-		hostif_mib_set_request(priv, LOCAL_GAIN,
-				       sizeof(priv->gain),
-				       MIB_VALUE_TYPE_OSTRING, &priv->gain);
-		break;
-	case SME_GET_GAIN:
-		hostif_mib_get_request(priv, LOCAL_GAIN);
-		break;
-	case SME_GET_EEPROM_CKSUM:
-		priv->eeprom_checksum = EEPROM_FW_NOT_SUPPORT;	/* initialize */
-		hostif_mib_get_request(priv, LOCAL_EEPROM_SUM);
-		break;
-	case SME_START_REQUEST:
-		hostif_start_request(priv, priv->reg.operation_mode);
-		break;
-	case SME_START_CONFIRM:
-		/* for power save */
-		atomic_set(&priv->psstatus.snooze_guard, 0);
-		atomic_set(&priv->psstatus.confirm_wait, 0);
-		if (priv->dev_state == DEVICE_STATE_PREINIT)
-			priv->dev_state = DEVICE_STATE_INIT;
-		/* wake_up_interruptible_all(&priv->confirm_wait); */
-		complete(&priv->confirm_wait);
-		break;
-	case SME_SLEEP_REQUEST:
-		hostif_sme_sleep_set(priv);
-		break;
-	case SME_SET_REGION:
-		val = cpu_to_le32((uint32_t)(priv->region));
-		hostif_mib_set_request(priv, LOCAL_REGION,
-				       sizeof(val), MIB_VALUE_TYPE_INT, &val);
-		break;
-	case SME_MULTICAST_CONFIRM:
-	case SME_BSS_SCAN_CONFIRM:
-	case SME_POW_MNGMT_CONFIRM:
-	case SME_PHY_INFO_CONFIRM:
-	case SME_STOP_CONFIRM:
-	case SME_RTS_THRESHOLD_CONFIRM:
-	case SME_FRAGMENTATION_THRESHOLD_CONFIRM:
-	case SME_WEP_INDEX_CONFIRM:
-	case SME_WEP_KEY1_CONFIRM:
-	case SME_WEP_KEY2_CONFIRM:
-	case SME_WEP_KEY3_CONFIRM:
-	case SME_WEP_KEY4_CONFIRM:
-	case SME_WEP_FLAG_CONFIRM:
-	case SME_RSN_UCAST_CONFIRM:
-	case SME_RSN_MCAST_CONFIRM:
-	case SME_RSN_AUTH_CONFIRM:
-	case SME_RSN_ENABLED_CONFIRM:
-	case SME_RSN_MODE_CONFIRM:
-	case SME_MODE_SET_CONFIRM:
-		break;
-	case SME_TERMINATE:
-	default:
-		break;
-	}
-}
-
-static
-void hostif_sme_task(unsigned long dev)
-{
-	struct ks_wlan_private *priv = (struct ks_wlan_private *)dev;
-
-	DPRINTK(3, "\n");
-
-	if (priv->dev_state < DEVICE_STATE_BOOT)
-		return;
-
-	if (cnt_smeqbody(priv) <= 0)
-		return;
-
-	hostif_sme_execute(priv, priv->sme_i.event_buff[priv->sme_i.qhead]);
-	inc_smeqhead(priv);
-	if (cnt_smeqbody(priv) > 0)
-		tasklet_schedule(&priv->sme_task);
-}
-
-/* send to Station Management Entity module */
-void hostif_sme_enqueue(struct ks_wlan_private *priv, unsigned short event)
-{
-	DPRINTK(3, "\n");
-
-	/* enqueue sme event */
-	if (cnt_smeqbody(priv) < (SME_EVENT_BUFF_SIZE - 1)) {
-		priv->sme_i.event_buff[priv->sme_i.qtail] = event;
-		inc_smeqtail(priv);
-#ifdef KS_WLAN_DEBUG
-		if (priv->sme_i.max_event_count < cnt_smeqbody(priv))
-			priv->sme_i.max_event_count = cnt_smeqbody(priv);
-#endif /* KS_WLAN_DEBUG */
-	} else {
-		/* in case of buffer overflow */
-		netdev_err(priv->net_dev, "sme queue buffer overflow\n");
-	}
-
-	tasklet_schedule(&priv->sme_task);
-}
-
-int hostif_init(struct ks_wlan_private *priv)
-{
-	int i;
-
-	DPRINTK(3, "\n");
-
-	priv->aplist.size = 0;
-	for (i = 0; i < LOCAL_APLIST_MAX; i++)
-		memset(&priv->aplist.ap[i], 0, sizeof(struct local_ap_t));
-	priv->infra_status = 0;
-	priv->current_rate = 4;
-	priv->connect_status = DISCONNECT_STATUS;
-
-	spin_lock_init(&priv->multicast_spin);
-
-	spin_lock_init(&priv->dev_read_lock);
-	init_waitqueue_head(&priv->devread_wait);
-	priv->dev_count = 0;
-	atomic_set(&priv->event_count, 0);
-	atomic_set(&priv->rec_count, 0);
-
-	/* for power save */
-	atomic_set(&priv->psstatus.status, PS_NONE);
-	atomic_set(&priv->psstatus.confirm_wait, 0);
-	atomic_set(&priv->psstatus.snooze_guard, 0);
-	init_completion(&priv->psstatus.wakeup_wait);
-	INIT_WORK(&priv->wakeup_work, ks_wlan_hw_wakeup_task);
-
-	/* WPA */
-	memset(&priv->wpa, 0, sizeof(priv->wpa));
-	priv->wpa.rsn_enabled = 0;
-	priv->wpa.mic_failure.failure = 0;
-	priv->wpa.mic_failure.last_failure_time = 0;
-	priv->wpa.mic_failure.stop = 0;
-	memset(&priv->pmklist, 0, sizeof(priv->pmklist));
-	INIT_LIST_HEAD(&priv->pmklist.head);
-	for (i = 0; i < PMK_LIST_MAX; i++)
-		INIT_LIST_HEAD(&priv->pmklist.pmk[i].list);
-
-	priv->sme_i.sme_status = SME_IDLE;
-	priv->sme_i.qhead = 0;
-	priv->sme_i.qtail = 0;
-#ifdef KS_WLAN_DEBUG
-	priv->sme_i.max_event_count = 0;
-#endif
-	spin_lock_init(&priv->sme_i.sme_spin);
-	priv->sme_i.sme_flag = 0;
-
-	tasklet_init(&priv->sme_task, hostif_sme_task, (unsigned long)priv);
-
-	return 0;
-}
-
-void hostif_exit(struct ks_wlan_private *priv)
-{
-	tasklet_kill(&priv->sme_task);
-}
diff --git a/drivers/staging/ks7010/ks_hostif.h b/drivers/staging/ks7010/ks_hostif.h
deleted file mode 100644
index d758076..0000000
--- a/drivers/staging/ks7010/ks_hostif.h
+++ /dev/null
@@ -1,685 +0,0 @@
-/*
- *   Driver for KeyStream wireless LAN
- *
- *   Copyright (c) 2005-2008 KeyStream Corp.
- *   Copyright (C) 2009 Renesas Technology Corp.
- *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License version 2 as
- *   published by the Free Software Foundation.
- */
-
-#ifndef _KS_HOSTIF_H_
-#define _KS_HOSTIF_H_
-
-#include <linux/compiler.h>
-
-/*
- * HOST-MAC I/F events
- */
-#define HIF_DATA_REQ		0xE001
-#define HIF_DATA_IND		0xE801
-#define HIF_MIB_GET_REQ		0xE002
-#define HIF_MIB_GET_CONF	0xE802
-#define HIF_MIB_SET_REQ		0xE003
-#define HIF_MIB_SET_CONF	0xE803
-#define HIF_POWER_MGMT_REQ	0xE004
-#define HIF_POWER_MGMT_CONF	0xE804
-#define HIF_START_REQ		0xE005
-#define HIF_START_CONF		0xE805
-#define HIF_CONNECT_IND		0xE806
-#define HIF_STOP_REQ		0xE006
-#define HIF_STOP_CONF		0xE807
-#define HIF_PS_ADH_SET_REQ	0xE007
-#define HIF_PS_ADH_SET_CONF	0xE808
-#define HIF_INFRA_SET_REQ	0xE008
-#define HIF_INFRA_SET_CONF	0xE809
-#define HIF_ADH_SET_REQ		0xE009
-#define HIF_ADH_SET_CONF	0xE80A
-#define HIF_AP_SET_REQ		0xE00A
-#define HIF_AP_SET_CONF		0xE80B
-#define HIF_ASSOC_INFO_IND	0xE80C
-#define HIF_MIC_FAILURE_REQ	0xE00B
-#define HIF_MIC_FAILURE_CONF	0xE80D
-#define HIF_SCAN_REQ		0xE00C
-#define HIF_SCAN_CONF		0xE80E
-#define HIF_PHY_INFO_REQ	0xE00D
-#define HIF_PHY_INFO_CONF	0xE80F
-#define HIF_SLEEP_REQ		0xE00E
-#define HIF_SLEEP_CONF		0xE810
-#define HIF_PHY_INFO_IND	0xE811
-#define HIF_SCAN_IND		0xE812
-#define HIF_INFRA_SET2_REQ	0xE00F
-#define HIF_INFRA_SET2_CONF	0xE813
-#define HIF_ADH_SET2_REQ	0xE010
-#define HIF_ADH_SET2_CONF	0xE814
-
-#define HIF_REQ_MAX		0xE010
-
-/*
- * HOST-MAC I/F data structure
- * Byte alignmet Little Endian
- */
-
-struct hostif_hdr {
-	u16 size;
-	u16 event;
-} __packed;
-
-struct hostif_data_request_t {
-	struct hostif_hdr header;
-	u16 auth_type;
-#define TYPE_DATA 0x0000
-#define TYPE_AUTH 0x0001
-	u16 reserved;
-	u8 data[0];
-} __packed;
-
-struct hostif_data_indication_t {
-	struct hostif_hdr header;
-	u16 auth_type;
-/* #define TYPE_DATA 0x0000 */
-#define TYPE_PMK1 0x0001
-#define TYPE_GMK1 0x0002
-#define TYPE_GMK2 0x0003
-	u16 reserved;
-	u8 data[0];
-} __packed;
-
-#define CHANNEL_LIST_MAX_SIZE 14
-struct channel_list_t {
-	u8 size;
-	u8 body[CHANNEL_LIST_MAX_SIZE];
-	u8 pad;
-} __packed;
-
-/* MIB Attribute */
-#define DOT11_MAC_ADDRESS                 0x21010100	/* MAC Address (R) */
-#define DOT11_PRODUCT_VERSION             0x31024100	/* FirmWare Version (R) */
-#define DOT11_RTS_THRESHOLD               0x21020100	/* RTS Threshold (R/W) */
-#define DOT11_FRAGMENTATION_THRESHOLD     0x21050100	/* Fragment Threshold (R/W) */
-#define DOT11_PRIVACY_INVOKED             0x15010100	/* WEP ON/OFF (W) */
-#define DOT11_WEP_DEFAULT_KEY_ID          0x15020100	/* WEP Index (W) */
-#define DOT11_WEP_DEFAULT_KEY_VALUE1      0x13020101	/* WEP Key#1(TKIP AES: PairwiseTemporalKey) (W) */
-#define DOT11_WEP_DEFAULT_KEY_VALUE2      0x13020102	/* WEP Key#2(TKIP AES: GroupKey1) (W) */
-#define DOT11_WEP_DEFAULT_KEY_VALUE3      0x13020103	/* WEP Key#3(TKIP AES: GroupKey2) (W) */
-#define DOT11_WEP_DEFAULT_KEY_VALUE4      0x13020104	/* WEP Key#4 (W) */
-#define DOT11_WEP_LIST                    0x13020100	/* WEP LIST */
-#define	DOT11_DESIRED_SSID		  0x11090100	/* SSID */
-#define	DOT11_CURRENT_CHANNEL		  0x45010100	/* channel set */
-#define	DOT11_OPERATION_RATE_SET	  0x11110100	/* rate set */
-
-#define LOCAL_AP_SEARCH_INTEAVAL          0xF1010100	/* AP search interval (R/W) */
-#define LOCAL_CURRENTADDRESS              0xF1050100	/* MAC Address change (W) */
-#define LOCAL_MULTICAST_ADDRESS           0xF1060100	/* Multicast Address (W) */
-#define LOCAL_MULTICAST_FILTER            0xF1060200	/* Multicast Address Filter enable/disable (W) */
-#define LOCAL_SEARCHED_AP_LIST            0xF1030100	/* AP list (R) */
-#define LOCAL_LINK_AP_STATUS              0xF1040100	/* Link AP status (R) */
-#define	LOCAL_PACKET_STATISTICS		  0xF1020100	/* tx,rx packets statistics */
-#define LOCAL_AP_SCAN_LIST_TYPE_SET	  0xF1030200	/* AP_SCAN_LIST_TYPE */
-
-#define DOT11_RSN_ENABLED                 0x15070100	/* WPA enable/disable (W) */
-#define LOCAL_RSN_MODE                    0x56010100	/* RSN mode WPA/WPA2 (W) */
-#define DOT11_RSN_CONFIG_MULTICAST_CIPHER 0x51040100	/* GroupKeyCipherSuite (W) */
-#define DOT11_RSN_CONFIG_UNICAST_CIPHER   0x52020100	/* PairwiseKeyCipherSuite (W) */
-#define DOT11_RSN_CONFIG_AUTH_SUITE       0x53020100	/* AuthenticationKeyManagementSuite (W) */
-#define DOT11_RSN_CONFIG_VERSION          0x51020100	/* RSN version (W) */
-#define LOCAL_RSN_CONFIG_ALL              0x5F010100	/* RSN CONFIG ALL (W) */
-#define DOT11_PMK_TSC                     0x55010100	/* PMK_TSC (W) */
-#define DOT11_GMK1_TSC                    0x55010101	/* GMK1_TSC (W) */
-#define DOT11_GMK2_TSC                    0x55010102	/* GMK2_TSC (W) */
-#define DOT11_GMK3_TSC                    0x55010103	/* GMK3_TSC */
-#define LOCAL_PMK                         0x58010100	/* Pairwise Master Key cache (W) */
-
-#define LOCAL_REGION                      0xF10A0100	/* Region setting */
-
-#ifdef WPS
-#define LOCAL_WPS_ENABLE                  0xF10B0100	/* WiFi Protected Setup */
-#define LOCAL_WPS_PROBE_REQ               0xF10C0100	/* WPS Probe Request */
-#endif /* WPS */
-
-#define LOCAL_GAIN                        0xF10D0100	/* Carrer sense threshold for demo ato show */
-#define LOCAL_EEPROM_SUM                  0xF10E0100	/* EEPROM checksum information */
-
-struct hostif_mib_get_request_t {
-	struct hostif_hdr header;
-	u32 mib_attribute;
-} __packed;
-
-struct hostif_mib_value_t {
-	u16 size;
-	u16 type;
-#define MIB_VALUE_TYPE_NULL     0
-#define MIB_VALUE_TYPE_INT      1
-#define MIB_VALUE_TYPE_BOOL     2
-#define MIB_VALUE_TYPE_COUNT32  3
-#define MIB_VALUE_TYPE_OSTRING  4
-	u8 body[0];
-} __packed;
-
-struct hostif_mib_get_confirm_t {
-	struct hostif_hdr header;
-	u32 mib_status;
-#define MIB_SUCCESS    0
-#define MIB_INVALID    1
-#define MIB_READ_ONLY  2
-#define MIB_WRITE_ONLY 3
-	u32 mib_attribute;
-	struct hostif_mib_value_t mib_value;
-} __packed;
-
-struct hostif_mib_set_request_t {
-	struct hostif_hdr header;
-	u32 mib_attribute;
-	struct hostif_mib_value_t mib_value;
-} __packed;
-
-struct hostif_mib_set_confirm_t {
-	struct hostif_hdr header;
-	u32 mib_status;
-	u32 mib_attribute;
-} __packed;
-
-struct hostif_power_mgmt_request_t {
-	struct hostif_hdr header;
-	u32 mode;
-#define POWER_ACTIVE  1
-#define POWER_SAVE    2
-	u32 wake_up;
-#define SLEEP_FALSE 0
-#define SLEEP_TRUE  1	/* not used */
-	u32 receiveDTIMs;
-#define DTIM_FALSE 0
-#define DTIM_TRUE  1
-} __packed;
-
-enum power_mgmt_mode_type {
-	POWER_MGMT_ACTIVE,
-	POWER_MGMT_SAVE1,
-	POWER_MGMT_SAVE2
-};
-
-#define	RESULT_SUCCESS            0
-#define	RESULT_INVALID_PARAMETERS 1
-#define	RESULT_NOT_SUPPORTED      2
-/* #define	RESULT_ALREADY_RUNNING    3 */
-#define	RESULT_ALREADY_RUNNING    7
-
-struct hostif_power_mgmt_confirm_t {
-	struct hostif_hdr header;
-	u16 result_code;
-} __packed;
-
-struct hostif_start_request_t {
-	struct hostif_hdr header;
-	u16 mode;
-#define MODE_PSEUDO_ADHOC   0
-#define MODE_INFRASTRUCTURE 1
-#define MODE_AP             2	/* not used */
-#define MODE_ADHOC          3
-} __packed;
-
-struct hostif_start_confirm_t {
-	struct hostif_hdr header;
-	u16 result_code;
-} __packed;
-
-#define SSID_MAX_SIZE 32
-struct ssid_t {
-	u8 size;
-	u8 body[SSID_MAX_SIZE];
-	u8 ssid_pad;
-} __packed;
-
-#define RATE_SET_MAX_SIZE 16
-struct rate_set8_t {
-	u8 size;
-	u8 body[8];
-	u8 rate_pad;
-} __packed;
-
-struct FhParms_t {
-	u16 dwellTime;
-	u8 hopSet;
-	u8 hopPattern;
-	u8 hopIndex;
-} __packed;
-
-struct DsParms_t {
-	u8 channel;
-} __packed;
-
-struct CfParms_t {
-	u8 count;
-	u8 period;
-	u16 maxDuration;
-	u16 durRemaining;
-} __packed;
-
-struct IbssParms_t {
-	u16 atimWindow;
-} __packed;
-
-struct rsn_t {
-	u8 size;
-#define RSN_BODY_SIZE 64
-	u8 body[RSN_BODY_SIZE];
-} __packed;
-
-struct ErpParams_t {
-	u8 erp_info;
-} __packed;
-
-struct rate_set16_t {
-	u8 size;
-	u8 body[16];
-	u8 rate_pad;
-} __packed;
-
-struct ap_info_t {
-	u8 bssid[6];	/* +00 */
-	u8 rssi;	/* +06 */
-	u8 sq;	/* +07 */
-	u8 noise;	/* +08 */
-	u8 pad0;	/* +09 */
-	u16 beacon_period;	/* +10 */
-	u16 capability;	/* +12 */
-#define BSS_CAP_ESS             BIT(0)
-#define BSS_CAP_IBSS            BIT(1)
-#define BSS_CAP_CF_POLABLE      BIT(2)
-#define BSS_CAP_CF_POLL_REQ     BIT(3)
-#define BSS_CAP_PRIVACY         BIT(4)
-#define BSS_CAP_SHORT_PREAMBLE  BIT(5)
-#define BSS_CAP_PBCC            BIT(6)
-#define BSS_CAP_CHANNEL_AGILITY BIT(7)
-#define BSS_CAP_SHORT_SLOT_TIME BIT(10)
-#define BSS_CAP_DSSS_OFDM       BIT(13)
-	u8 frame_type;	/* +14 */
-	u8 ch_info;	/* +15 */
-#define FRAME_TYPE_BEACON	0x80
-#define FRAME_TYPE_PROBE_RESP	0x50
-	u16 body_size;	/* +16 */
-	u8 body[1024];	/* +18 */
-	/* +1032 */
-} __packed;
-
-struct link_ap_info_t {
-	u8 bssid[6];	/* +00 */
-	u8 rssi;	/* +06 */
-	u8 sq;	/* +07 */
-	u8 noise;	/* +08 */
-	u8 pad0;	/* +09 */
-	u16 beacon_period;	/* +10 */
-	u16 capability;	/* +12 */
-	struct rate_set8_t rate_set;	/* +14 */
-	struct FhParms_t fh_parameter;	/* +24 */
-	struct DsParms_t ds_parameter;	/* +29 */
-	struct CfParms_t cf_parameter;	/* +30 */
-	struct IbssParms_t ibss_parameter;	/* +36 */
-	struct ErpParams_t erp_parameter;	/* +38 */
-	u8 pad1;	/* +39 */
-	struct rate_set8_t ext_rate_set;	/* +40 */
-	u8 DTIM_period;	/* +50 */
-	u8 rsn_mode;	/* +51 */
-#define RSN_MODE_NONE	0
-#define RSN_MODE_WPA	1
-#define RSN_MODE_WPA2	2
-	struct {
-		u8 size;	/* +52 */
-		u8 body[128];	/* +53 */
-	} __packed rsn;
-} __packed;
-
-struct hostif_connect_indication_t {
-	struct hostif_hdr header;
-	u16 connect_code;
-#define RESULT_CONNECT    0
-#define RESULT_DISCONNECT 1
-	struct link_ap_info_t link_ap_info;
-} __packed;
-
-struct hostif_stop_request_t {
-	struct hostif_hdr header;
-} __packed;
-
-struct hostif_stop_confirm_t {
-	struct hostif_hdr header;
-	u16 result_code;
-} __packed;
-
-/**
- * struct hostif_ps_adhoc_set_request_t - pseudo adhoc mode
- * @capability: bit5  : preamble
- *              bit6  : pbcc - Not supported always 0
- *              bit10 : ShortSlotTime
- *              bit13 : DSSS-OFDM - Not supported always 0
- */
-struct hostif_ps_adhoc_set_request_t {
-	struct hostif_hdr header;
-	u16 phy_type;
-#define D_11B_ONLY_MODE		0
-#define D_11G_ONLY_MODE		1
-#define D_11BG_COMPATIBLE_MODE	2
-#define D_11A_ONLY_MODE		3
-	u16 cts_mode;
-#define CTS_MODE_FALSE	0
-#define CTS_MODE_TRUE	1
-	u16 channel;
-	struct rate_set16_t rate_set;
-	u16 capability;
-	u16 scan_type;
-} __packed;
-
-struct hostif_ps_adhoc_set_confirm_t {
-	struct hostif_hdr header;
-	u16 result_code;
-} __packed;
-
-/**
- * struct hostif_infrastructure_set_request_t
- * @capability: bit5  : preamble
- *              bit6  : pbcc - Not supported always 0
- *              bit10 : ShortSlotTime
- *              bit13 : DSSS-OFDM - Not supported always 0
- */
-struct hostif_infrastructure_set_request_t {
-	struct hostif_hdr header;
-	u16 phy_type;
-	u16 cts_mode;
-	struct rate_set16_t rate_set;
-	struct ssid_t ssid;
-	u16 capability;
-	u16 beacon_lost_count;
-	u16 auth_type;
-#define AUTH_TYPE_OPEN_SYSTEM 0
-#define AUTH_TYPE_SHARED_KEY  1
-	struct channel_list_t channel_list;
-	u16 scan_type;
-} __packed;
-
-/**
- * struct hostif_infrastructure_set2_request_t
- * @capability: bit5  : preamble
- *              bit6  : pbcc - Not supported always 0
- *              bit10 : ShortSlotTime
- *              bit13 : DSSS-OFDM - Not supported always 0
- */
-struct hostif_infrastructure_set2_request_t {
-	struct hostif_hdr header;
-	u16 phy_type;
-	u16 cts_mode;
-	struct rate_set16_t rate_set;
-	struct ssid_t ssid;
-	u16 capability;
-	u16 beacon_lost_count;
-	u16 auth_type;
-#define AUTH_TYPE_OPEN_SYSTEM 0
-#define AUTH_TYPE_SHARED_KEY  1
-	struct channel_list_t channel_list;
-	u16 scan_type;
-	u8 bssid[ETH_ALEN];
-} __packed;
-
-struct hostif_infrastructure_set_confirm_t {
-	struct hostif_hdr header;
-	u16 result_code;
-} __packed;
-
-/**
- * struct hostif_adhoc_set_request_t
- * @capability: bit5  : preamble
- *              bit6  : pbcc - Not supported always 0
- *              bit10 : ShortSlotTime
- *              bit13 : DSSS-OFDM - Not supported always 0
- */
-struct hostif_adhoc_set_request_t {
-	struct hostif_hdr header;
-	u16 phy_type;
-	u16 cts_mode;
-	u16 channel;
-	struct rate_set16_t rate_set;
-	struct ssid_t ssid;
-	u16 capability;
-	u16 scan_type;
-} __packed;
-
-/**
- * struct hostif_adhoc_set2_request_t
- * @capability: bit5  : preamble
- *              bit6  : pbcc - Not supported always 0
- *              bit10 : ShortSlotTime
- *              bit13 : DSSS-OFDM - Not supported always 0
- */
-struct hostif_adhoc_set2_request_t {
-	struct hostif_hdr header;
-	u16 phy_type;
-	u16 cts_mode;
-	u16 reserved;
-	struct rate_set16_t rate_set;
-	struct ssid_t ssid;
-	u16 capability;
-	u16 scan_type;
-	struct channel_list_t channel_list;
-	u8 bssid[ETH_ALEN];
-} __packed;
-
-struct hostif_adhoc_set_confirm_t {
-	struct hostif_hdr header;
-	u16 result_code;
-} __packed;
-
-struct last_associate_t {
-	u8 type;
-	u8 status;
-} __packed;
-
-struct association_request_t {
-	u8 type;
-#define FRAME_TYPE_ASSOC_REQ	0x00
-#define FRAME_TYPE_REASSOC_REQ	0x20
-	u8 pad;
-	u16 capability;
-	u16 listen_interval;
-	u8 ap_address[6];
-	u16 reqIEs_size;
-} __packed;
-
-struct association_response_t {
-	u8 type;
-#define FRAME_TYPE_ASSOC_RESP	0x10
-#define FRAME_TYPE_REASSOC_RESP	0x30
-	u8 pad;
-	u16 capability;
-	u16 status;
-	u16 association_id;
-	u16 respIEs_size;
-} __packed;
-
-struct hostif_associate_indication_t {
-	struct hostif_hdr header;
-	struct association_request_t assoc_req;
-	struct association_response_t assoc_resp;
-	/* followed by (reqIEs_size + respIEs_size) octets of data */
-	/* reqIEs data *//* respIEs data */
-} __packed;
-
-struct hostif_bss_scan_request_t {
-	struct hostif_hdr header;
-	u8 scan_type;
-#define ACTIVE_SCAN  0
-#define PASSIVE_SCAN 1
-	u8 pad[3];
-	u32 ch_time_min;
-	u32 ch_time_max;
-	struct channel_list_t channel_list;
-	struct ssid_t ssid;
-} __packed;
-
-struct hostif_bss_scan_confirm_t {
-	struct hostif_hdr header;
-	u16 result_code;
-	u16 reserved;
-} __packed;
-
-struct hostif_phy_information_request_t {
-	struct hostif_hdr header;
-	u16 type;
-#define NORMAL_TYPE	0
-#define TIME_TYPE	1
-	u16 time;	/* unit 100ms */
-} __packed;
-
-struct hostif_phy_information_confirm_t {
-	struct hostif_hdr header;
-	u8 rssi;
-	u8 sq;
-	u8 noise;
-	u8 link_speed;
-	u32 tx_frame;
-	u32 rx_frame;
-	u32 tx_error;
-	u32 rx_error;
-} __packed;
-
-enum sleep_mode_type {
-	SLP_ACTIVE,
-	SLP_SLEEP
-};
-
-struct hostif_sleep_request_t {
-	struct hostif_hdr header;
-} __packed;
-
-struct hostif_sleep_confirm_t {
-	struct hostif_hdr header;
-	u16 result_code;
-} __packed;
-
-struct hostif_mic_failure_request_t {
-	struct hostif_hdr header;
-	u16 failure_count;
-	u16 timer;
-} __packed;
-
-struct hostif_mic_failure_confirm_t {
-	struct hostif_hdr header;
-	u16 result_code;
-} __packed;
-
-#define BASIC_RATE	0x80
-#define RATE_MASK	0x7F
-
-#define TX_RATE_AUTO      0xff
-#define TX_RATE_1M_FIXED  0
-#define TX_RATE_2M_FIXED  1
-#define TX_RATE_1_2M_AUTO 2
-#define TX_RATE_5M_FIXED  3
-#define TX_RATE_11M_FIXED 4
-
-#define TX_RATE_FULL_AUTO	0
-#define TX_RATE_11_AUTO		1
-#define TX_RATE_11B_AUTO	2
-#define TX_RATE_11BG_AUTO	3
-#define TX_RATE_MANUAL_AUTO	4
-#define TX_RATE_FIXED		5
-
-/* 11b rate */
-#define TX_RATE_1M	(uint8_t)(10 / 5)	/* 11b 11g basic rate */
-#define TX_RATE_2M	(uint8_t)(20 / 5)	/* 11b 11g basic rate */
-#define TX_RATE_5M	(uint8_t)(55 / 5)	/* 11g basic rate */
-#define TX_RATE_11M	(uint8_t)(110 / 5)	/* 11g basic rate */
-
-/* 11g rate */
-#define TX_RATE_6M	(uint8_t)(60 / 5)	/* 11g basic rate */
-#define TX_RATE_12M	(uint8_t)(120 / 5)	/* 11g basic rate */
-#define TX_RATE_24M	(uint8_t)(240 / 5)	/* 11g basic rate */
-#define TX_RATE_9M	(uint8_t)(90 / 5)
-#define TX_RATE_18M	(uint8_t)(180 / 5)
-#define TX_RATE_36M	(uint8_t)(360 / 5)
-#define TX_RATE_48M	(uint8_t)(480 / 5)
-#define TX_RATE_54M	(uint8_t)(540 / 5)
-
-#define IS_11B_RATE(A) (((A & RATE_MASK) == TX_RATE_1M) || ((A & RATE_MASK) == TX_RATE_2M) || \
-			((A & RATE_MASK) == TX_RATE_5M) || ((A & RATE_MASK) == TX_RATE_11M))
-
-#define IS_OFDM_RATE(A) (((A & RATE_MASK) == TX_RATE_6M) || ((A & RATE_MASK) == TX_RATE_12M) || \
-			 ((A & RATE_MASK) == TX_RATE_24M) || ((A & RATE_MASK) == TX_RATE_9M) || \
-			 ((A & RATE_MASK) == TX_RATE_18M) || ((A & RATE_MASK) == TX_RATE_36M) || \
-			 ((A & RATE_MASK) == TX_RATE_48M) || ((A & RATE_MASK) == TX_RATE_54M))
-
-#define IS_11BG_RATE(A) (IS_11B_RATE(A) || IS_OFDM_RATE(A))
-
-#define IS_OFDM_EXT_RATE(A) (((A & RATE_MASK) == TX_RATE_9M) || ((A & RATE_MASK) == TX_RATE_18M) || \
-			     ((A & RATE_MASK) == TX_RATE_36M) || ((A & RATE_MASK) == TX_RATE_48M) || \
-			     ((A & RATE_MASK) == TX_RATE_54M))
-
-enum connect_status_type {
-	CONNECT_STATUS,
-	DISCONNECT_STATUS
-};
-
-enum preamble_type {
-	LONG_PREAMBLE,
-	SHORT_PREAMBLE
-};
-
-enum multicast_filter_type {
-	MCAST_FILTER_MCAST,
-	MCAST_FILTER_MCASTALL,
-	MCAST_FILTER_PROMISC,
-};
-
-#define NIC_MAX_MCAST_LIST 32
-
-/* macro function */
-#define HIF_EVENT_MASK 0xE800
-#define IS_HIF_IND(_EVENT)  ((_EVENT & HIF_EVENT_MASK) == 0xE800  && \
-			     ((_EVENT & ~HIF_EVENT_MASK) == 0x0001 || \
-			     (_EVENT & ~HIF_EVENT_MASK) == 0x0006 || \
-			     (_EVENT & ~HIF_EVENT_MASK) == 0x000C || \
-			     (_EVENT & ~HIF_EVENT_MASK) == 0x0011 || \
-			     (_EVENT & ~HIF_EVENT_MASK) == 0x0012))
-
-#define IS_HIF_CONF(_EVENT) ((_EVENT & HIF_EVENT_MASK) == 0xE800  && \
-			     (_EVENT & ~HIF_EVENT_MASK) > 0x0000  && \
-			     (_EVENT & ~HIF_EVENT_MASK) < 0x0012  && \
-			     !IS_HIF_IND(_EVENT))
-
-#ifdef __KERNEL__
-
-#include "ks_wlan.h"
-
-/* function prototype */
-int hostif_data_request(struct ks_wlan_private *priv, struct sk_buff *skb);
-void hostif_receive(struct ks_wlan_private *priv, unsigned char *p,
-		    unsigned int size);
-void hostif_sme_enqueue(struct ks_wlan_private *priv, uint16_t event);
-int hostif_init(struct ks_wlan_private *priv);
-void hostif_exit(struct ks_wlan_private *priv);
-int ks_wlan_hw_tx(struct ks_wlan_private *priv, void *p, unsigned long size,
-		  void (*complete_handler)(struct ks_wlan_private *priv,
-					   struct sk_buff *skb),
-		  struct sk_buff *skb);
-void send_packet_complete(struct ks_wlan_private *priv, struct sk_buff *skb);
-
-void ks_wlan_hw_wakeup_request(struct ks_wlan_private *priv);
-int ks_wlan_hw_power_save(struct ks_wlan_private *priv);
-
-static
-inline int hif_align_size(int size)
-{
-#ifdef	KS_ATOM
-	if (size < 1024)
-		size = 1024;
-#endif
-#ifdef	DEVICE_ALIGNMENT
-	return (size % DEVICE_ALIGNMENT) ? size + DEVICE_ALIGNMENT -
-	    (size % DEVICE_ALIGNMENT) : size;
-#else
-	return size;
-#endif
-}
-
-#endif /* __KERNEL__ */
-
-#endif /* _KS_HOSTIF_H_ */
diff --git a/drivers/staging/ks7010/ks_wlan.h b/drivers/staging/ks7010/ks_wlan.h
deleted file mode 100644
index cd4f56d..0000000
--- a/drivers/staging/ks7010/ks_wlan.h
+++ /dev/null
@@ -1,514 +0,0 @@
-/*
- *   Driver for KeyStream IEEE802.11 b/g wireless LAN cards.
- *
- *   Copyright (C) 2006-2008 KeyStream Corp.
- *   Copyright (C) 2009 Renesas Technology Corp.
- *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License version 2 as
- *   published by the Free Software Foundation.
- */
-
-#ifndef _KS_WLAN_H
-#define _KS_WLAN_H
-
-#define WPS
-
-#include <linux/interrupt.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-#include <linux/spinlock.h>	/* spinlock_t */
-#include <linux/sched.h>	/* wait_queue_head_t */
-#include <linux/types.h>	/* pid_t */
-#include <linux/netdevice.h>	/* struct net_device_stats,  struct sk_buff */
-#include <linux/etherdevice.h>
-#include <linux/wireless.h>
-#include <linux/atomic.h>	/* struct atomic_t */
-#include <linux/timer.h>	/* struct timer_list */
-#include <linux/string.h>
-#include <linux/completion.h>	/* struct completion */
-#include <linux/workqueue.h>
-
-#include <linux/io.h>
-
-#include "ks7010_sdio.h"
-
-#ifdef KS_WLAN_DEBUG
-#define DPRINTK(n, fmt, args...) \
-	do { \
-		if (KS_WLAN_DEBUG > (n)) \
-			pr_notice("%s: "fmt, __func__, ## args); \
-	} while (0)
-#else
-#define DPRINTK(n, fmt, args...)
-#endif
-
-struct ks_wlan_parameter {
-	u8 operation_mode;	/* Operation Mode */
-	u8 channel;	/*  Channel */
-	u8 tx_rate;	/*  Transmit Rate */
-	struct {
-		u8 size;
-		u8 body[16];
-	} rate_set;
-	u8 bssid[ETH_ALEN];	/* BSSID */
-	struct {
-		u8 size;
-		u8 body[32 + 1];
-	} ssid;	/*  SSID */
-	u8 preamble;	/*  Preamble */
-	u8 power_mgmt;
-	u32 scan_type;	/*  AP List Scan Type */
-#define BEACON_LOST_COUNT_MIN 0
-#define BEACON_LOST_COUNT_MAX 65535
-	u32 beacon_lost_count;	/*  Beacon Lost Count */
-	u32 rts;	/*  RTS Threashold */
-	u32 fragment;	/*  Fragmentation Threashold */
-	u32 privacy_invoked;
-	u32 wep_index;
-	struct {
-		u8 size;
-		u8 val[13 * 2 + 1];
-	} wep_key[4];
-	u16 authenticate_type;
-	u16 phy_type;	/* 11b/11g/11bg mode type */
-	u16 cts_mode;	/* for 11g/11bg mode cts mode */
-	u16 phy_info_timer;	/* phy information timer */
-};
-
-enum {
-	DEVICE_STATE_OFF = 0,	/* this means hw_unavailable is != 0 */
-	DEVICE_STATE_PREBOOT,	/* we are in a pre-boot state (empty RAM) */
-	DEVICE_STATE_BOOT,	/* boot state (fw upload, run fw) */
-	DEVICE_STATE_PREINIT,	/* pre-init state */
-	DEVICE_STATE_INIT,	/* init state (restore MIB backup to device) */
-	DEVICE_STATE_READY,	/* driver&device are in operational state */
-	DEVICE_STATE_SLEEP	/* device in sleep mode */
-};
-
-/* SME flag */
-#define SME_MODE_SET	    BIT(0)
-#define SME_RTS             BIT(1)
-#define SME_FRAG            BIT(2)
-#define SME_WEP_FLAG        BIT(3)
-#define SME_WEP_INDEX       BIT(4)
-#define SME_WEP_VAL1        BIT(5)
-#define SME_WEP_VAL2        BIT(6)
-#define SME_WEP_VAL3        BIT(7)
-#define SME_WEP_VAL4        BIT(8)
-#define SME_WEP_VAL_MASK    (SME_WEP_VAL1 | SME_WEP_VAL2 | SME_WEP_VAL3 | SME_WEP_VAL4)
-#define SME_RSN             BIT(9)
-#define SME_RSN_MULTICAST   BIT(10)
-#define SME_RSN_UNICAST	    BIT(11)
-#define SME_RSN_AUTH	    BIT(12)
-
-#define SME_AP_SCAN         BIT(13)
-#define SME_MULTICAST       BIT(14)
-
-/* SME Event */
-enum {
-	SME_START,
-
-	SME_MULTICAST_REQUEST,
-	SME_MACADDRESS_SET_REQUEST,
-	SME_BSS_SCAN_REQUEST,
-	SME_SET_FLAG,
-	SME_SET_TXKEY,
-	SME_SET_KEY1,
-	SME_SET_KEY2,
-	SME_SET_KEY3,
-	SME_SET_KEY4,
-	SME_SET_PMK_TSC,
-	SME_SET_GMK1_TSC,
-	SME_SET_GMK2_TSC,
-	SME_SET_GMK3_TSC,
-	SME_SET_PMKSA,
-	SME_POW_MNGMT_REQUEST,
-	SME_PHY_INFO_REQUEST,
-	SME_MIC_FAILURE_REQUEST,
-	SME_GET_MAC_ADDRESS,
-	SME_GET_PRODUCT_VERSION,
-	SME_STOP_REQUEST,
-	SME_RTS_THRESHOLD_REQUEST,
-	SME_FRAGMENTATION_THRESHOLD_REQUEST,
-	SME_WEP_INDEX_REQUEST,
-	SME_WEP_KEY1_REQUEST,
-	SME_WEP_KEY2_REQUEST,
-	SME_WEP_KEY3_REQUEST,
-	SME_WEP_KEY4_REQUEST,
-	SME_WEP_FLAG_REQUEST,
-	SME_RSN_UCAST_REQUEST,
-	SME_RSN_MCAST_REQUEST,
-	SME_RSN_AUTH_REQUEST,
-	SME_RSN_ENABLED_REQUEST,
-	SME_RSN_MODE_REQUEST,
-#ifdef WPS
-	SME_WPS_ENABLE_REQUEST,
-	SME_WPS_PROBE_REQUEST,
-#endif
-	SME_SET_GAIN,
-	SME_GET_GAIN,
-	SME_SLEEP_REQUEST,
-	SME_SET_REGION,
-	SME_MODE_SET_REQUEST,
-	SME_START_REQUEST,
-	SME_GET_EEPROM_CKSUM,
-
-	SME_MIC_FAILURE_CONFIRM,
-	SME_START_CONFIRM,
-
-	SME_MULTICAST_CONFIRM,
-	SME_BSS_SCAN_CONFIRM,
-	SME_GET_CURRENT_AP,
-	SME_POW_MNGMT_CONFIRM,
-	SME_PHY_INFO_CONFIRM,
-	SME_STOP_CONFIRM,
-	SME_RTS_THRESHOLD_CONFIRM,
-	SME_FRAGMENTATION_THRESHOLD_CONFIRM,
-	SME_WEP_INDEX_CONFIRM,
-	SME_WEP_KEY1_CONFIRM,
-	SME_WEP_KEY2_CONFIRM,
-	SME_WEP_KEY3_CONFIRM,
-	SME_WEP_KEY4_CONFIRM,
-	SME_WEP_FLAG_CONFIRM,
-	SME_RSN_UCAST_CONFIRM,
-	SME_RSN_MCAST_CONFIRM,
-	SME_RSN_AUTH_CONFIRM,
-	SME_RSN_ENABLED_CONFIRM,
-	SME_RSN_MODE_CONFIRM,
-	SME_MODE_SET_CONFIRM,
-	SME_SLEEP_CONFIRM,
-
-	SME_RSN_SET_CONFIRM,
-	SME_WEP_SET_CONFIRM,
-	SME_TERMINATE,
-
-	SME_EVENT_SIZE	/* end */
-};
-
-/* SME Status */
-enum {
-	SME_IDLE,
-	SME_SETUP,
-	SME_DISCONNECT,
-	SME_CONNECT
-};
-
-#define	SME_EVENT_BUFF_SIZE	128
-
-struct sme_info {
-	int sme_status;
-	int event_buff[SME_EVENT_BUFF_SIZE];
-	unsigned int qhead;
-	unsigned int qtail;
-#ifdef KS_WLAN_DEBUG
-	/* for debug */
-	unsigned int max_event_count;
-#endif
-	spinlock_t sme_spin;
-	unsigned long sme_flag;
-};
-
-struct hostt_t {
-	int buff[SME_EVENT_BUFF_SIZE];
-	unsigned int qhead;
-	unsigned int qtail;
-};
-
-#define RSN_IE_BODY_MAX 64
-struct rsn_ie_t {
-	u8 id;	/* 0xdd = WPA or 0x30 = RSN */
-	u8 size;	/* max ? 255 ? */
-	u8 body[RSN_IE_BODY_MAX];
-} __packed;
-
-#ifdef WPS
-#define WPS_IE_BODY_MAX 255
-struct wps_ie_t {
-	u8 id;	/* 221 'dd <len> 00 50 F2 04' */
-	u8 size;	/* max ? 255 ? */
-	u8 body[WPS_IE_BODY_MAX];
-} __packed;
-#endif /* WPS */
-
-struct local_ap_t {
-	u8 bssid[6];
-	u8 rssi;
-	u8 sq;
-	struct {
-		u8 size;
-		u8 body[32];
-		u8 ssid_pad;
-	} ssid;
-	struct {
-		u8 size;
-		u8 body[16];
-		u8 rate_pad;
-	} rate_set;
-	u16 capability;
-	u8 channel;
-	u8 noise;
-	struct rsn_ie_t wpa_ie;
-	struct rsn_ie_t rsn_ie;
-#ifdef WPS
-	struct wps_ie_t wps_ie;
-#endif /* WPS */
-};
-
-#define LOCAL_APLIST_MAX 31
-#define LOCAL_CURRENT_AP LOCAL_APLIST_MAX
-struct local_aplist_t {
-	int size;
-	struct local_ap_t ap[LOCAL_APLIST_MAX + 1];
-};
-
-struct local_gain_t {
-	u8 TxMode;
-	u8 RxMode;
-	u8 TxGain;
-	u8 RxGain;
-};
-
-struct local_eeprom_sum_t {
-	u8 type;
-	u8 result;
-};
-
-enum {
-	EEPROM_OK,
-	EEPROM_CHECKSUM_NONE,
-	EEPROM_FW_NOT_SUPPORT,
-	EEPROM_NG,
-};
-
-/* Power Save Status */
-enum {
-	PS_NONE,
-	PS_ACTIVE_SET,
-	PS_SAVE_SET,
-	PS_CONF_WAIT,
-	PS_SNOOZE,
-	PS_WAKEUP
-};
-
-struct power_save_status_t {
-	atomic_t status;	/* initialvalue 0 */
-	struct completion wakeup_wait;
-	atomic_t confirm_wait;
-	atomic_t snooze_guard;
-};
-
-struct sleep_status_t {
-	atomic_t status;	/* initialvalue 0 */
-	atomic_t doze_request;
-	atomic_t wakeup_request;
-};
-
-/* WPA */
-struct scan_ext_t {
-	unsigned int flag;
-	char ssid[IW_ESSID_MAX_SIZE + 1];
-};
-
-enum {
-	CIPHER_NONE,
-	CIPHER_WEP40,
-	CIPHER_TKIP,
-	CIPHER_CCMP,
-	CIPHER_WEP104
-};
-
-#define CIPHER_ID_WPA_NONE    "\x00\x50\xf2\x00"
-#define CIPHER_ID_WPA_WEP40   "\x00\x50\xf2\x01"
-#define CIPHER_ID_WPA_TKIP    "\x00\x50\xf2\x02"
-#define CIPHER_ID_WPA_CCMP    "\x00\x50\xf2\x04"
-#define CIPHER_ID_WPA_WEP104  "\x00\x50\xf2\x05"
-
-#define CIPHER_ID_WPA2_NONE   "\x00\x0f\xac\x00"
-#define CIPHER_ID_WPA2_WEP40  "\x00\x0f\xac\x01"
-#define CIPHER_ID_WPA2_TKIP   "\x00\x0f\xac\x02"
-#define CIPHER_ID_WPA2_CCMP   "\x00\x0f\xac\x04"
-#define CIPHER_ID_WPA2_WEP104 "\x00\x0f\xac\x05"
-
-#define CIPHER_ID_LEN    4
-
-enum {
-	KEY_MGMT_802_1X,
-	KEY_MGMT_PSK,
-	KEY_MGMT_WPANONE,
-};
-
-#define KEY_MGMT_ID_WPA_NONE     "\x00\x50\xf2\x00"
-#define KEY_MGMT_ID_WPA_1X       "\x00\x50\xf2\x01"
-#define KEY_MGMT_ID_WPA_PSK      "\x00\x50\xf2\x02"
-#define KEY_MGMT_ID_WPA_WPANONE  "\x00\x50\xf2\xff"
-
-#define KEY_MGMT_ID_WPA2_NONE    "\x00\x0f\xac\x00"
-#define KEY_MGMT_ID_WPA2_1X      "\x00\x0f\xac\x01"
-#define KEY_MGMT_ID_WPA2_PSK     "\x00\x0f\xac\x02"
-#define KEY_MGMT_ID_WPA2_WPANONE "\x00\x0f\xac\xff"
-
-#define KEY_MGMT_ID_LEN  4
-
-#define MIC_KEY_SIZE 8
-
-struct wpa_key_t {
-	u32 ext_flags;	/* IW_ENCODE_EXT_xxx */
-	u8 tx_seq[IW_ENCODE_SEQ_MAX_SIZE];	/* LSB first */
-	u8 rx_seq[IW_ENCODE_SEQ_MAX_SIZE];	/* LSB first */
-	struct sockaddr addr;	/* ff:ff:ff:ff:ff:ff for broadcast/multicast
-				 * (group) keys or unicast address for
-				 * individual keys
-				 */
-	u16 alg;
-	u16 key_len;	/* WEP: 5 or 13, TKIP: 32, CCMP: 16 */
-	u8 key_val[IW_ENCODING_TOKEN_MAX];
-	u8 tx_mic_key[MIC_KEY_SIZE];
-	u8 rx_mic_key[MIC_KEY_SIZE];
-};
-
-#define WPA_KEY_INDEX_MAX 4
-#define WPA_RX_SEQ_LEN 6
-
-struct mic_failure_t {
-	u16 failure;	/* MIC Failure counter 0 or 1 or 2 */
-	u16 counter;	/* 1sec counter 0-60 */
-	u32 last_failure_time;
-	int stop;	/* stop flag */
-};
-
-struct wpa_status_t {
-	int wpa_enabled;
-	unsigned int rsn_enabled;
-	int version;
-	int pairwise_suite;	/* unicast cipher */
-	int group_suite;	/* multicast cipher */
-	int key_mgmt_suite;	/* authentication key management suite */
-	int auth_alg;
-	int txkey;
-	struct wpa_key_t key[WPA_KEY_INDEX_MAX];
-	struct scan_ext_t scan_ext;
-	struct mic_failure_t mic_failure;
-};
-
-#include <linux/list.h>
-#define PMK_LIST_MAX 8
-struct pmk_list_t {
-	u16 size;
-	struct list_head head;
-	struct pmk_t {
-		struct list_head list;
-		u8 bssid[ETH_ALEN];
-		u8 pmkid[IW_PMKID_LEN];
-	} pmk[PMK_LIST_MAX];
-};
-
-#ifdef WPS
-struct wps_status_t {
-	int wps_enabled;
-	int ielen;
-	u8 ie[255];
-};
-#endif /* WPS */
-
-struct ks_wlan_private {
-	/* hardware information */
-	struct ks_sdio_card *ks_sdio_card;
-	struct workqueue_struct *wq;
-	struct delayed_work rw_dwork;
-	struct tasklet_struct rx_bh_task;
-
-	struct net_device *net_dev;
-	int reg_net;	/* register_netdev */
-	struct net_device_stats nstats;
-	struct iw_statistics wstats;
-
-	struct completion confirm_wait;
-
-	/* trx device & sme */
-	struct tx_device tx_dev;
-	struct rx_device rx_dev;
-	struct sme_info sme_i;
-	u8 *rxp;
-	unsigned int rx_size;
-	struct tasklet_struct sme_task;
-	struct work_struct wakeup_work;
-	int scan_ind_count;
-
-	unsigned char eth_addr[ETH_ALEN];
-
-	struct local_aplist_t aplist;
-	struct local_ap_t current_ap;
-	struct power_save_status_t psstatus;
-	struct sleep_status_t sleepstatus;
-	struct wpa_status_t wpa;
-	struct pmk_list_t pmklist;
-	/* wireless parameter */
-	struct ks_wlan_parameter reg;
-	u8 current_rate;
-
-	char nick[IW_ESSID_MAX_SIZE + 1];
-
-	spinlock_t multicast_spin;
-
-	spinlock_t dev_read_lock;
-	wait_queue_head_t devread_wait;
-
-	unsigned int need_commit;	/* for ioctl */
-
-	/* DeviceIoControl */
-	int device_open_status;
-	atomic_t event_count;
-	atomic_t rec_count;
-	int dev_count;
-#define DEVICE_STOCK_COUNT 20
-	unsigned char *dev_data[DEVICE_STOCK_COUNT];
-	int dev_size[DEVICE_STOCK_COUNT];
-
-	/* ioctl : IOCTL_FIRMWARE_VERSION */
-	unsigned char firmware_version[128 + 1];
-	int version_size;
-
-	int mac_address_valid;	/* Mac Address Status */
-
-	int dev_state;
-
-	struct sk_buff *skb;
-	unsigned int cur_rx;	/* Index into the Rx buffer of next Rx pkt. */
-	/* spinlock_t lock; */
-#define FORCE_DISCONNECT    0x80000000
-#define CONNECT_STATUS_MASK 0x7FFFFFFF
-	u32 connect_status;	/* connect status */
-	int infra_status;	/* Infractructure status */
-
-	u8 data_buff[0x1000];
-
-	u8 scan_ssid_len;
-	u8 scan_ssid[IW_ESSID_MAX_SIZE + 1];
-	struct local_gain_t gain;
-#ifdef WPS
-	struct net_device *l2_dev;
-	int l2_fd;
-	struct wps_status_t wps;
-#endif /* WPS */
-	u8 sleep_mode;
-
-	u8 region;
-	struct local_eeprom_sum_t eeprom_sum;
-	u8 eeprom_checksum;
-
-	struct hostt_t hostt;
-
-	unsigned long last_doze;
-	unsigned long last_wakeup;
-
-	uint wakeup_count;	/* for detect wakeup loop */
-};
-
-int ks_wlan_net_start(struct net_device *dev);
-int ks_wlan_net_stop(struct net_device *dev);
-bool is_connect_status(u32 status);
-bool is_disconnect_status(u32 status);
-
-#endif /* _KS_WLAN_H */
diff --git a/drivers/staging/ks7010/ks_wlan_ioctl.h b/drivers/staging/ks7010/ks_wlan_ioctl.h
deleted file mode 100644
index 28b381c..0000000
--- a/drivers/staging/ks7010/ks_wlan_ioctl.h
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- *   Driver for KeyStream 11b/g wireless LAN
- *
- *   Copyright (c) 2005-2008 KeyStream Corp.
- *   Copyright (C) 2009 Renesas Technology Corp.
- *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License version 2 as
- *   published by the Free Software Foundation.
- */
-
-#ifndef _KS_WLAN_IOCTL_H
-#define _KS_WLAN_IOCTL_H
-
-#include <linux/wireless.h>
-/* The low order bit identify a SET (0) or a GET (1) ioctl.  */
-
-/*					(SIOCIWFIRSTPRIV + 0) */
-/* former KS_WLAN_GET_DRIVER_VERSION	(SIOCIWFIRSTPRIV + 1) */
-/*					(SIOCIWFIRSTPRIV + 2) */
-#define KS_WLAN_GET_FIRM_VERSION	(SIOCIWFIRSTPRIV + 3)
-#ifdef WPS
-#define KS_WLAN_SET_WPS_ENABLE		(SIOCIWFIRSTPRIV + 4)
-#define KS_WLAN_GET_WPS_ENABLE		(SIOCIWFIRSTPRIV + 5)
-#define KS_WLAN_SET_WPS_PROBE_REQ	(SIOCIWFIRSTPRIV + 6)
-#endif
-#define KS_WLAN_GET_EEPROM_CKSUM	(SIOCIWFIRSTPRIV + 7)
-#define KS_WLAN_SET_PREAMBLE		(SIOCIWFIRSTPRIV + 8)
-#define KS_WLAN_GET_PREAMBLE		(SIOCIWFIRSTPRIV + 9)
-#define KS_WLAN_SET_POWER_SAVE		(SIOCIWFIRSTPRIV + 10)
-#define KS_WLAN_GET_POWER_SAVE		(SIOCIWFIRSTPRIV + 11)
-#define KS_WLAN_SET_SCAN_TYPE		(SIOCIWFIRSTPRIV + 12)
-#define KS_WLAN_GET_SCAN_TYPE		(SIOCIWFIRSTPRIV + 13)
-#define KS_WLAN_SET_RX_GAIN		(SIOCIWFIRSTPRIV + 14)
-#define KS_WLAN_GET_RX_GAIN		(SIOCIWFIRSTPRIV + 15)
-#define KS_WLAN_HOSTT			(SIOCIWFIRSTPRIV + 16)	/* unused */
-//#define KS_WLAN_SET_REGION            (SIOCIWFIRSTPRIV + 17)
-#define KS_WLAN_SET_BEACON_LOST		(SIOCIWFIRSTPRIV + 18)
-#define KS_WLAN_GET_BEACON_LOST		(SIOCIWFIRSTPRIV + 19)
-
-#define KS_WLAN_SET_TX_GAIN		(SIOCIWFIRSTPRIV + 20)
-#define KS_WLAN_GET_TX_GAIN		(SIOCIWFIRSTPRIV + 21)
-
-/* for KS7010 */
-#define KS_WLAN_SET_PHY_TYPE		(SIOCIWFIRSTPRIV + 22)
-#define KS_WLAN_GET_PHY_TYPE		(SIOCIWFIRSTPRIV + 23)
-#define KS_WLAN_SET_CTS_MODE		(SIOCIWFIRSTPRIV + 24)
-#define KS_WLAN_GET_CTS_MODE		(SIOCIWFIRSTPRIV + 25)
-/*					(SIOCIWFIRSTPRIV + 26) */
-/*					(SIOCIWFIRSTPRIV + 27) */
-#define KS_WLAN_SET_SLEEP_MODE		(SIOCIWFIRSTPRIV + 28)	/* sleep mode */
-#define KS_WLAN_GET_SLEEP_MODE		(SIOCIWFIRSTPRIV + 29)	/* sleep mode */
-/*					(SIOCIWFIRSTPRIV + 30) */
-/*					(SIOCIWFIRSTPRIV + 31) */
-
-#ifdef __KERNEL__
-
-#include "ks_wlan.h"
-#include <linux/netdevice.h>
-
-int ks_wlan_read_config_file(struct ks_wlan_private *priv);
-int ks_wlan_setup_parameter(struct ks_wlan_private *priv,
-			    unsigned int commit_flag);
-
-#endif /* __KERNEL__ */
-
-#endif /* _KS_WLAN_IOCTL_H */
diff --git a/drivers/staging/ks7010/ks_wlan_net.c b/drivers/staging/ks7010/ks_wlan_net.c
deleted file mode 100644
index 5a43f19..0000000
--- a/drivers/staging/ks7010/ks_wlan_net.c
+++ /dev/null
@@ -1,2999 +0,0 @@
-/*
- *   Driver for KeyStream 11b/g wireless LAN
- *
- *   Copyright (C) 2005-2008 KeyStream Corp.
- *   Copyright (C) 2009 Renesas Technology Corp.
- *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License version 2 as
- *   published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/compiler.h>
-#include <linux/init.h>
-#include <linux/ioport.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/if_arp.h>
-#include <linux/rtnetlink.h>
-#include <linux/delay.h>
-#include <linux/completion.h>
-#include <linux/mii.h>
-#include <linux/pci.h>
-#include <linux/ctype.h>
-#include <linux/timer.h>
-#include <linux/atomic.h>
-#include <linux/io.h>
-#include <linux/uaccess.h>
-
-static int wep_on_off;
-#define	WEP_OFF		0
-#define	WEP_ON_64BIT	1
-#define	WEP_ON_128BIT	2
-
-#include "ks_wlan.h"
-#include "ks_hostif.h"
-#include "ks_wlan_ioctl.h"
-
-/* Include Wireless Extension definition and check version */
-#include <linux/wireless.h>
-#define WIRELESS_SPY	/* enable iwspy support */
-#include <net/iw_handler.h>	/* New driver API */
-
-/* Frequency list (map channels to frequencies) */
-static const long frequency_list[] = { 2412, 2417, 2422, 2427, 2432, 2437, 2442,
-	2447, 2452, 2457, 2462, 2467, 2472, 2484
-};
-
-/* A few details needed for WEP (Wireless Equivalent Privacy) */
-#define MAX_KEY_SIZE 13	/* 128 (?) bits */
-#define MIN_KEY_SIZE  5	/* 40 bits RC4 - WEP */
-struct wep_key {
-	u16 len;
-	u8 key[16];	/* 40-bit and 104-bit keys */
-};
-
-/* Backward compatibility */
-#ifndef IW_ENCODE_NOKEY
-#define IW_ENCODE_NOKEY 0x0800	/* Key is write only, so not present */
-#define IW_ENCODE_MODE  (IW_ENCODE_DISABLED | IW_ENCODE_RESTRICTED | IW_ENCODE_OPEN)
-#endif /* IW_ENCODE_NOKEY */
-
-/* List of Wireless Handlers (new API) */
-static const struct iw_handler_def ks_wlan_handler_def;
-
-#define KSC_OPNOTSUPP	/* Operation Not Support */
-
-/*
- *	function prototypes
- */
-static int ks_wlan_open(struct net_device *dev);
-static void ks_wlan_tx_timeout(struct net_device *dev);
-static int ks_wlan_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static int ks_wlan_close(struct net_device *dev);
-static void ks_wlan_set_multicast_list(struct net_device *dev);
-static struct net_device_stats *ks_wlan_get_stats(struct net_device *dev);
-static int ks_wlan_set_mac_address(struct net_device *dev, void *addr);
-static int ks_wlan_netdev_ioctl(struct net_device *dev, struct ifreq *rq,
-				int cmd);
-
-static atomic_t update_phyinfo;
-static struct timer_list update_phyinfo_timer;
-static
-int ks_wlan_update_phy_information(struct ks_wlan_private *priv)
-{
-	struct iw_statistics *wstats = &priv->wstats;
-
-	DPRINTK(4, "in_interrupt = %ld\n", in_interrupt());
-
-	if (priv->dev_state < DEVICE_STATE_READY)
-		return -EBUSY;	/* not finished initialize */
-
-	if (atomic_read(&update_phyinfo))
-		return -EPERM;
-
-	/* The status */
-	wstats->status = priv->reg.operation_mode;	/* Operation mode */
-
-	/* Signal quality and co. But where is the noise level ??? */
-	hostif_sme_enqueue(priv, SME_PHY_INFO_REQUEST);
-
-	/* interruptible_sleep_on_timeout(&priv->confirm_wait, HZ/2); */
-	if (!wait_for_completion_interruptible_timeout
-	    (&priv->confirm_wait, HZ / 2)) {
-		DPRINTK(1, "wait time out!!\n");
-	}
-
-	atomic_inc(&update_phyinfo);
-	update_phyinfo_timer.expires = jiffies + HZ;	/* 1sec */
-	add_timer(&update_phyinfo_timer);
-
-	return 0;
-}
-
-static
-void ks_wlan_update_phyinfo_timeout(unsigned long ptr)
-{
-	DPRINTK(4, "in_interrupt = %ld\n", in_interrupt());
-	atomic_set(&update_phyinfo, 0);
-}
-
-int ks_wlan_setup_parameter(struct ks_wlan_private *priv,
-			    unsigned int commit_flag)
-{
-	DPRINTK(2, "\n");
-
-	hostif_sme_enqueue(priv, SME_STOP_REQUEST);
-
-	if (commit_flag & SME_RTS)
-		hostif_sme_enqueue(priv, SME_RTS_THRESHOLD_REQUEST);
-	if (commit_flag & SME_FRAG)
-		hostif_sme_enqueue(priv, SME_FRAGMENTATION_THRESHOLD_REQUEST);
-
-	if (commit_flag & SME_WEP_INDEX)
-		hostif_sme_enqueue(priv, SME_WEP_INDEX_REQUEST);
-	if (commit_flag & SME_WEP_VAL1)
-		hostif_sme_enqueue(priv, SME_WEP_KEY1_REQUEST);
-	if (commit_flag & SME_WEP_VAL2)
-		hostif_sme_enqueue(priv, SME_WEP_KEY2_REQUEST);
-	if (commit_flag & SME_WEP_VAL3)
-		hostif_sme_enqueue(priv, SME_WEP_KEY3_REQUEST);
-	if (commit_flag & SME_WEP_VAL4)
-		hostif_sme_enqueue(priv, SME_WEP_KEY4_REQUEST);
-	if (commit_flag & SME_WEP_FLAG)
-		hostif_sme_enqueue(priv, SME_WEP_FLAG_REQUEST);
-
-	if (commit_flag & SME_RSN) {
-		hostif_sme_enqueue(priv, SME_RSN_ENABLED_REQUEST);
-		hostif_sme_enqueue(priv, SME_RSN_MODE_REQUEST);
-	}
-	if (commit_flag & SME_RSN_MULTICAST)
-		hostif_sme_enqueue(priv, SME_RSN_MCAST_REQUEST);
-	if (commit_flag & SME_RSN_UNICAST)
-		hostif_sme_enqueue(priv, SME_RSN_UCAST_REQUEST);
-	if (commit_flag & SME_RSN_AUTH)
-		hostif_sme_enqueue(priv, SME_RSN_AUTH_REQUEST);
-
-	hostif_sme_enqueue(priv, SME_MODE_SET_REQUEST);
-
-	hostif_sme_enqueue(priv, SME_START_REQUEST);
-
-	return 0;
-}
-
-/*
- * Initial Wireless Extension code for Ks_Wlannet driver by :
- *	Jean Tourrilhes <jt@hpl.hp.com> - HPL - 17 November 00
- * Conversion to new driver API by :
- *	Jean Tourrilhes <jt@hpl.hp.com> - HPL - 26 March 02
- * Javier also did a good amount of work here, adding some new extensions
- * and fixing my code. Let's just say that without him this code just
- * would not work at all... - Jean II
- */
-
-static int ks_wlan_get_name(struct net_device *dev,
-			    struct iw_request_info *info, char *cwrq,
-			    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	if (priv->dev_state < DEVICE_STATE_READY)
-		strcpy(cwrq, "NOT READY!");
-	else if (priv->reg.phy_type == D_11B_ONLY_MODE)
-		strcpy(cwrq, "IEEE 802.11b");
-	else if (priv->reg.phy_type == D_11G_ONLY_MODE)
-		strcpy(cwrq, "IEEE 802.11g");
-	else
-		strcpy(cwrq, "IEEE 802.11b/g");
-
-	return 0;
-}
-
-static int ks_wlan_set_freq(struct net_device *dev,
-			    struct iw_request_info *info, struct iw_freq *fwrq,
-			    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	int channel;
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	/* If setting by frequency, convert to a channel */
-	if ((fwrq->e == 1) &&
-	    (fwrq->m >= (int)2.412e8) && (fwrq->m <= (int)2.487e8)) {
-		int f = fwrq->m / 100000;
-		int c = 0;
-
-		while ((c < 14) && (f != frequency_list[c]))
-			c++;
-		/* Hack to fall through... */
-		fwrq->e = 0;
-		fwrq->m = c + 1;
-	}
-	/* Setting by channel number */
-	if ((fwrq->m > 1000) || (fwrq->e > 0))
-		return -EOPNOTSUPP;
-
-	channel = fwrq->m;
-	/* We should do a better check than that,
-	 * based on the card capability !!!
-	 */
-	if ((channel < 1) || (channel > 14)) {
-		netdev_dbg(dev, "%s: New channel value of %d is invalid!\n",
-			   dev->name, fwrq->m);
-		return -EINVAL;
-	}
-
-	/* Yes ! We can set it !!! */
-	priv->reg.channel = (u8)(channel);
-	priv->need_commit |= SME_MODE_SET;
-
-	return -EINPROGRESS;	/* Call commit handler */
-}
-
-static int ks_wlan_get_freq(struct net_device *dev,
-			    struct iw_request_info *info, struct iw_freq *fwrq,
-			    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	int f;
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	if (is_connect_status(priv->connect_status))
-		f = (int)priv->current_ap.channel;
-	else
-		f = (int)priv->reg.channel;
-
-	fwrq->m = frequency_list[f - 1] * 100000;
-	fwrq->e = 1;
-
-	return 0;
-}
-
-static int ks_wlan_set_essid(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_point *dwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	size_t len;
-
-	DPRINTK(2, " %d\n", dwrq->flags);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	/* Check if we asked for `any' */
-	if (!dwrq->flags) {
-		/* Just send an empty SSID list */
-		memset(priv->reg.ssid.body, 0, sizeof(priv->reg.ssid.body));
-		priv->reg.ssid.size = 0;
-	} else {
-#if 1
-		len = dwrq->length;
-		/* iwconfig uses nul termination in SSID.. */
-		if (len > 0 && extra[len - 1] == '\0')
-			len--;
-
-		/* Check the size of the string */
-		if (len > IW_ESSID_MAX_SIZE)
-			return -EINVAL;
-
-#else
-		/* Check the size of the string */
-		if (dwrq->length > IW_ESSID_MAX_SIZE + 1)
-			return -E2BIG;
-
-#endif
-
-		/* Set the SSID */
-		memset(priv->reg.ssid.body, 0, sizeof(priv->reg.ssid.body));
-
-#if 1
-		memcpy(priv->reg.ssid.body, extra, len);
-		priv->reg.ssid.size = len;
-#else
-		memcpy(priv->reg.ssid.body, extra, dwrq->length);
-		priv->reg.ssid.size = dwrq->length;
-#endif
-	}
-	/* Write it to the card */
-	priv->need_commit |= SME_MODE_SET;
-
-//      return  -EINPROGRESS;   /* Call commit handler */
-	ks_wlan_setup_parameter(priv, priv->need_commit);
-	priv->need_commit = 0;
-	return 0;
-}
-
-static int ks_wlan_get_essid(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_point *dwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	/* Note : if dwrq->flags != 0, we should
-	 * get the relevant SSID from the SSID list...
-	 */
-	if (priv->reg.ssid.size != 0) {
-		/* Get the current SSID */
-		memcpy(extra, priv->reg.ssid.body, priv->reg.ssid.size);
-
-		/* If none, we may want to get the one that was set */
-
-		/* Push it out ! */
-		dwrq->length = priv->reg.ssid.size;
-		dwrq->flags = 1;	/* active */
-	} else {
-		dwrq->length = 0;
-		dwrq->flags = 0;	/* ANY */
-	}
-
-	return 0;
-}
-
-static int ks_wlan_set_wap(struct net_device *dev, struct iw_request_info *info,
-			   struct sockaddr *ap_addr, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	DPRINTK(2, "\n");
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	if (priv->reg.operation_mode == MODE_ADHOC ||
-	    priv->reg.operation_mode == MODE_INFRASTRUCTURE) {
-		memcpy(priv->reg.bssid, &ap_addr->sa_data, ETH_ALEN);
-
-		if (is_valid_ether_addr((u8 *)priv->reg.bssid))
-			priv->need_commit |= SME_MODE_SET;
-
-	} else {
-		eth_zero_addr(priv->reg.bssid);
-		return -EOPNOTSUPP;
-	}
-
-	DPRINTK(2, "bssid = %pM\n", priv->reg.bssid);
-
-	/* Write it to the card */
-	if (priv->need_commit) {
-		priv->need_commit |= SME_MODE_SET;
-		return -EINPROGRESS;	/* Call commit handler */
-	}
-	return 0;
-}
-
-static int ks_wlan_get_wap(struct net_device *dev, struct iw_request_info *info,
-			   struct sockaddr *awrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	if (is_connect_status(priv->connect_status))
-		memcpy(awrq->sa_data, priv->current_ap.bssid, ETH_ALEN);
-	else
-		eth_zero_addr(awrq->sa_data);
-
-	awrq->sa_family = ARPHRD_ETHER;
-
-	return 0;
-}
-
-static int ks_wlan_set_nick(struct net_device *dev,
-			    struct iw_request_info *info, struct iw_point *dwrq,
-			    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	/* Check the size of the string */
-	if (dwrq->length > 16 + 1)
-		return -E2BIG;
-
-	memset(priv->nick, 0, sizeof(priv->nick));
-	memcpy(priv->nick, extra, dwrq->length);
-
-	return -EINPROGRESS;	/* Call commit handler */
-}
-
-static int ks_wlan_get_nick(struct net_device *dev,
-			    struct iw_request_info *info, struct iw_point *dwrq,
-			    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	strncpy(extra, priv->nick, 16);
-	extra[16] = '\0';
-	dwrq->length = strlen(extra) + 1;
-
-	return 0;
-}
-
-static int ks_wlan_set_rate(struct net_device *dev,
-			    struct iw_request_info *info, struct iw_param *vwrq,
-			    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	int i = 0;
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	if (priv->reg.phy_type == D_11B_ONLY_MODE) {
-		if (vwrq->fixed == 1) {
-			switch (vwrq->value) {
-			case 11000000:
-			case 5500000:
-				priv->reg.rate_set.body[0] =
-				    (uint8_t)(vwrq->value / 500000);
-				break;
-			case 2000000:
-			case 1000000:
-				priv->reg.rate_set.body[0] =
-				    ((uint8_t)(vwrq->value / 500000)) |
-				    BASIC_RATE;
-				break;
-			default:
-				return -EINVAL;
-			}
-			priv->reg.tx_rate = TX_RATE_FIXED;
-			priv->reg.rate_set.size = 1;
-		} else {	/* vwrq->fixed == 0 */
-			if (vwrq->value > 0) {
-				switch (vwrq->value) {
-				case 11000000:
-					priv->reg.rate_set.body[3] =
-					    TX_RATE_11M;
-					i++;
-				case 5500000:
-					priv->reg.rate_set.body[2] = TX_RATE_5M;
-					i++;
-				case 2000000:
-					priv->reg.rate_set.body[1] =
-					    TX_RATE_2M | BASIC_RATE;
-					i++;
-				case 1000000:
-					priv->reg.rate_set.body[0] =
-					    TX_RATE_1M | BASIC_RATE;
-					i++;
-					break;
-				default:
-					return -EINVAL;
-				}
-				priv->reg.tx_rate = TX_RATE_MANUAL_AUTO;
-				priv->reg.rate_set.size = i;
-			} else {
-				priv->reg.rate_set.body[3] = TX_RATE_11M;
-				priv->reg.rate_set.body[2] = TX_RATE_5M;
-				priv->reg.rate_set.body[1] =
-				    TX_RATE_2M | BASIC_RATE;
-				priv->reg.rate_set.body[0] =
-				    TX_RATE_1M | BASIC_RATE;
-				priv->reg.tx_rate = TX_RATE_FULL_AUTO;
-				priv->reg.rate_set.size = 4;
-			}
-		}
-	} else {	/* D_11B_ONLY_MODE or  D_11BG_COMPATIBLE_MODE */
-		if (vwrq->fixed == 1) {
-			switch (vwrq->value) {
-			case 54000000:
-			case 48000000:
-			case 36000000:
-			case 18000000:
-			case 9000000:
-				priv->reg.rate_set.body[0] =
-				    (uint8_t)(vwrq->value / 500000);
-				break;
-			case 24000000:
-			case 12000000:
-			case 11000000:
-			case 6000000:
-			case 5500000:
-			case 2000000:
-			case 1000000:
-				priv->reg.rate_set.body[0] =
-				    ((uint8_t)(vwrq->value / 500000)) |
-				    BASIC_RATE;
-				break;
-			default:
-				return -EINVAL;
-			}
-			priv->reg.tx_rate = TX_RATE_FIXED;
-			priv->reg.rate_set.size = 1;
-		} else {	/* vwrq->fixed == 0 */
-			if (vwrq->value > 0) {
-				switch (vwrq->value) {
-				case 54000000:
-					priv->reg.rate_set.body[11] =
-					    TX_RATE_54M;
-					i++;
-				case 48000000:
-					priv->reg.rate_set.body[10] =
-					    TX_RATE_48M;
-					i++;
-				case 36000000:
-					priv->reg.rate_set.body[9] =
-					    TX_RATE_36M;
-					i++;
-				case 24000000:
-				case 18000000:
-				case 12000000:
-				case 11000000:
-				case 9000000:
-				case 6000000:
-					if (vwrq->value == 24000000) {
-						priv->reg.rate_set.body[8] =
-						    TX_RATE_18M;
-						i++;
-						priv->reg.rate_set.body[7] =
-						    TX_RATE_9M;
-						i++;
-						priv->reg.rate_set.body[6] =
-						    TX_RATE_24M | BASIC_RATE;
-						i++;
-						priv->reg.rate_set.body[5] =
-						    TX_RATE_12M | BASIC_RATE;
-						i++;
-						priv->reg.rate_set.body[4] =
-						    TX_RATE_6M | BASIC_RATE;
-						i++;
-						priv->reg.rate_set.body[3] =
-						    TX_RATE_11M | BASIC_RATE;
-						i++;
-					} else if (vwrq->value == 18000000) {
-						priv->reg.rate_set.body[7] =
-						    TX_RATE_18M;
-						i++;
-						priv->reg.rate_set.body[6] =
-						    TX_RATE_9M;
-						i++;
-						priv->reg.rate_set.body[5] =
-						    TX_RATE_12M | BASIC_RATE;
-						i++;
-						priv->reg.rate_set.body[4] =
-						    TX_RATE_6M | BASIC_RATE;
-						i++;
-						priv->reg.rate_set.body[3] =
-						    TX_RATE_11M | BASIC_RATE;
-						i++;
-					} else if (vwrq->value == 12000000) {
-						priv->reg.rate_set.body[6] =
-						    TX_RATE_9M;
-						i++;
-						priv->reg.rate_set.body[5] =
-						    TX_RATE_12M | BASIC_RATE;
-						i++;
-						priv->reg.rate_set.body[4] =
-						    TX_RATE_6M | BASIC_RATE;
-						i++;
-						priv->reg.rate_set.body[3] =
-						    TX_RATE_11M | BASIC_RATE;
-						i++;
-					} else if (vwrq->value == 11000000) {
-						priv->reg.rate_set.body[5] =
-						    TX_RATE_9M;
-						i++;
-						priv->reg.rate_set.body[4] =
-						    TX_RATE_6M | BASIC_RATE;
-						i++;
-						priv->reg.rate_set.body[3] =
-						    TX_RATE_11M | BASIC_RATE;
-						i++;
-					} else if (vwrq->value == 9000000) {
-						priv->reg.rate_set.body[4] =
-						    TX_RATE_9M;
-						i++;
-						priv->reg.rate_set.body[3] =
-						    TX_RATE_6M | BASIC_RATE;
-						i++;
-					} else {	/* vwrq->value == 6000000 */
-						priv->reg.rate_set.body[3] =
-						    TX_RATE_6M | BASIC_RATE;
-						i++;
-					}
-				case 5500000:
-					priv->reg.rate_set.body[2] =
-					    TX_RATE_5M | BASIC_RATE;
-					i++;
-				case 2000000:
-					priv->reg.rate_set.body[1] =
-					    TX_RATE_2M | BASIC_RATE;
-					i++;
-				case 1000000:
-					priv->reg.rate_set.body[0] =
-					    TX_RATE_1M | BASIC_RATE;
-					i++;
-					break;
-				default:
-					return -EINVAL;
-				}
-				priv->reg.tx_rate = TX_RATE_MANUAL_AUTO;
-				priv->reg.rate_set.size = i;
-			} else {
-				priv->reg.rate_set.body[11] = TX_RATE_54M;
-				priv->reg.rate_set.body[10] = TX_RATE_48M;
-				priv->reg.rate_set.body[9] = TX_RATE_36M;
-				priv->reg.rate_set.body[8] = TX_RATE_18M;
-				priv->reg.rate_set.body[7] = TX_RATE_9M;
-				priv->reg.rate_set.body[6] =
-				    TX_RATE_24M | BASIC_RATE;
-				priv->reg.rate_set.body[5] =
-				    TX_RATE_12M | BASIC_RATE;
-				priv->reg.rate_set.body[4] =
-				    TX_RATE_6M | BASIC_RATE;
-				priv->reg.rate_set.body[3] =
-				    TX_RATE_11M | BASIC_RATE;
-				priv->reg.rate_set.body[2] =
-				    TX_RATE_5M | BASIC_RATE;
-				priv->reg.rate_set.body[1] =
-				    TX_RATE_2M | BASIC_RATE;
-				priv->reg.rate_set.body[0] =
-				    TX_RATE_1M | BASIC_RATE;
-				priv->reg.tx_rate = TX_RATE_FULL_AUTO;
-				priv->reg.rate_set.size = 12;
-			}
-		}
-	}
-
-	priv->need_commit |= SME_MODE_SET;
-
-	return -EINPROGRESS;	/* Call commit handler */
-}
-
-static int ks_wlan_get_rate(struct net_device *dev,
-			    struct iw_request_info *info, struct iw_param *vwrq,
-			    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	DPRINTK(2, "in_interrupt = %ld update_phyinfo = %d\n",
-		in_interrupt(), atomic_read(&update_phyinfo));
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	if (!atomic_read(&update_phyinfo))
-		ks_wlan_update_phy_information(priv);
-
-	vwrq->value = ((priv->current_rate) & RATE_MASK) * 500000;
-	if (priv->reg.tx_rate == TX_RATE_FIXED)
-		vwrq->fixed = 1;
-	else
-		vwrq->fixed = 0;
-
-	return 0;
-}
-
-static int ks_wlan_set_rts(struct net_device *dev, struct iw_request_info *info,
-			   struct iw_param *vwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	int rthr = vwrq->value;
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	if (vwrq->disabled)
-		rthr = 2347;
-	if ((rthr < 0) || (rthr > 2347))
-		return -EINVAL;
-
-	priv->reg.rts = rthr;
-	priv->need_commit |= SME_RTS;
-
-	return -EINPROGRESS;	/* Call commit handler */
-}
-
-static int ks_wlan_get_rts(struct net_device *dev, struct iw_request_info *info,
-			   struct iw_param *vwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	vwrq->value = priv->reg.rts;
-	vwrq->disabled = (vwrq->value >= 2347);
-	vwrq->fixed = 1;
-
-	return 0;
-}
-
-static int ks_wlan_set_frag(struct net_device *dev,
-			    struct iw_request_info *info, struct iw_param *vwrq,
-			    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	int fthr = vwrq->value;
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	if (vwrq->disabled)
-		fthr = 2346;
-	if ((fthr < 256) || (fthr > 2346))
-		return -EINVAL;
-
-	fthr &= ~0x1;	/* Get an even value - is it really needed ??? */
-	priv->reg.fragment = fthr;
-	priv->need_commit |= SME_FRAG;
-
-	return -EINPROGRESS;	/* Call commit handler */
-}
-
-static int ks_wlan_get_frag(struct net_device *dev,
-			    struct iw_request_info *info, struct iw_param *vwrq,
-			    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	vwrq->value = priv->reg.fragment;
-	vwrq->disabled = (vwrq->value >= 2346);
-	vwrq->fixed = 1;
-
-	return 0;
-}
-
-static int ks_wlan_set_mode(struct net_device *dev,
-			    struct iw_request_info *info, __u32 *uwrq,
-			    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	DPRINTK(2, "mode=%d\n", *uwrq);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	switch (*uwrq) {
-	case IW_MODE_ADHOC:
-		priv->reg.operation_mode = MODE_ADHOC;
-		priv->need_commit |= SME_MODE_SET;
-		break;
-	case IW_MODE_INFRA:
-		priv->reg.operation_mode = MODE_INFRASTRUCTURE;
-		priv->need_commit |= SME_MODE_SET;
-		break;
-	case IW_MODE_AUTO:
-	case IW_MODE_MASTER:
-	case IW_MODE_REPEAT:
-	case IW_MODE_SECOND:
-	case IW_MODE_MONITOR:
-	default:
-		return -EINVAL;
-	}
-
-	return -EINPROGRESS;	/* Call commit handler */
-}
-
-static int ks_wlan_get_mode(struct net_device *dev,
-			    struct iw_request_info *info, __u32 *uwrq,
-			    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	/* If not managed, assume it's ad-hoc */
-	switch (priv->reg.operation_mode) {
-	case MODE_INFRASTRUCTURE:
-		*uwrq = IW_MODE_INFRA;
-		break;
-	case MODE_ADHOC:
-		*uwrq = IW_MODE_ADHOC;
-		break;
-	default:
-		*uwrq = IW_MODE_ADHOC;
-	}
-
-	return 0;
-}
-
-static int ks_wlan_set_encode(struct net_device *dev,
-			      struct iw_request_info *info,
-			      struct iw_point *dwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	struct wep_key key;
-	int index = (dwrq->flags & IW_ENCODE_INDEX);
-	int current_index = priv->reg.wep_index;
-	int i;
-
-	DPRINTK(2, "flags=%04X\n", dwrq->flags);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	/* index check */
-	if ((index < 0) || (index > 4))
-		return -EINVAL;
-	else if (index == 0)
-		index = current_index;
-	else
-		index--;
-
-	/* Is WEP supported ? */
-	/* Basic checking: do we have a key to set ? */
-	if (dwrq->length > 0) {
-		if (dwrq->length > MAX_KEY_SIZE) {	/* Check the size of the key */
-			return -EINVAL;
-		}
-		if (dwrq->length > MIN_KEY_SIZE) {	/* Set the length */
-			key.len = MAX_KEY_SIZE;
-			priv->reg.privacy_invoked = 0x01;
-			priv->need_commit |= SME_WEP_FLAG;
-			wep_on_off = WEP_ON_128BIT;
-		} else {
-			if (dwrq->length > 0) {
-				key.len = MIN_KEY_SIZE;
-				priv->reg.privacy_invoked = 0x01;
-				priv->need_commit |= SME_WEP_FLAG;
-				wep_on_off = WEP_ON_64BIT;
-			} else {	/* Disable the key */
-				key.len = 0;
-			}
-		}
-		/* Check if the key is not marked as invalid */
-		if (!(dwrq->flags & IW_ENCODE_NOKEY)) {
-			/* Cleanup */
-			memset(key.key, 0, MAX_KEY_SIZE);
-			/* Copy the key in the driver */
-			if (copy_from_user
-			    (key.key, dwrq->pointer, dwrq->length)) {
-				key.len = 0;
-				return -EFAULT;
-			}
-			/* Send the key to the card */
-			priv->reg.wep_key[index].size = key.len;
-			for (i = 0; i < (priv->reg.wep_key[index].size); i++)
-				priv->reg.wep_key[index].val[i] = key.key[i];
-
-			priv->need_commit |= (SME_WEP_VAL1 << index);
-			priv->reg.wep_index = index;
-			priv->need_commit |= SME_WEP_INDEX;
-		}
-	} else {
-		if (dwrq->flags & IW_ENCODE_DISABLED) {
-			priv->reg.wep_key[0].size = 0;
-			priv->reg.wep_key[1].size = 0;
-			priv->reg.wep_key[2].size = 0;
-			priv->reg.wep_key[3].size = 0;
-			priv->reg.privacy_invoked = 0x00;
-			if (priv->reg.authenticate_type == AUTH_TYPE_SHARED_KEY)
-				priv->need_commit |= SME_MODE_SET;
-
-			priv->reg.authenticate_type = AUTH_TYPE_OPEN_SYSTEM;
-			wep_on_off = WEP_OFF;
-			priv->need_commit |= SME_WEP_FLAG;
-		} else {
-			/* Do we want to just set the transmit key index ? */
-			if ((index >= 0) && (index < 4)) {
-				/* set_wep_key(priv, index, 0, 0, 1);   xxx */
-				if (priv->reg.wep_key[index].size != 0) {
-					priv->reg.wep_index = index;
-					priv->need_commit |= SME_WEP_INDEX;
-				} else {
-					return -EINVAL;
-				}
-			}
-		}
-	}
-
-	/* Commit the changes if needed */
-	if (dwrq->flags & IW_ENCODE_MODE)
-		priv->need_commit |= SME_WEP_FLAG;
-
-	if (dwrq->flags & IW_ENCODE_OPEN) {
-		if (priv->reg.authenticate_type == AUTH_TYPE_SHARED_KEY)
-			priv->need_commit |= SME_MODE_SET;
-
-		priv->reg.authenticate_type = AUTH_TYPE_OPEN_SYSTEM;
-	} else if (dwrq->flags & IW_ENCODE_RESTRICTED) {
-		if (priv->reg.authenticate_type == AUTH_TYPE_OPEN_SYSTEM)
-			priv->need_commit |= SME_MODE_SET;
-
-		priv->reg.authenticate_type = AUTH_TYPE_SHARED_KEY;
-	}
-//      return -EINPROGRESS;            /* Call commit handler */
-	if (priv->need_commit) {
-		ks_wlan_setup_parameter(priv, priv->need_commit);
-		priv->need_commit = 0;
-	}
-	return 0;
-}
-
-static int ks_wlan_get_encode(struct net_device *dev,
-			      struct iw_request_info *info,
-			      struct iw_point *dwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	char zeros[16];
-	int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	dwrq->flags = IW_ENCODE_DISABLED;
-
-	/* Check encryption mode */
-	switch (priv->reg.authenticate_type) {
-	case AUTH_TYPE_OPEN_SYSTEM:
-		dwrq->flags = IW_ENCODE_OPEN;
-		break;
-	case AUTH_TYPE_SHARED_KEY:
-		dwrq->flags = IW_ENCODE_RESTRICTED;
-		break;
-	}
-
-	memset(zeros, 0, sizeof(zeros));
-
-	/* Which key do we want ? -1 -> tx index */
-	if ((index < 0) || (index >= 4))
-		index = priv->reg.wep_index;
-	if (priv->reg.privacy_invoked) {
-		dwrq->flags &= ~IW_ENCODE_DISABLED;
-		/* dwrq->flags |= IW_ENCODE_NOKEY; */
-	}
-	dwrq->flags |= index + 1;
-	DPRINTK(2, "encoding flag = 0x%04X\n", dwrq->flags);
-	/* Copy the key to the user buffer */
-	if ((index >= 0) && (index < 4))
-		dwrq->length = priv->reg.wep_key[index].size;
-	if (dwrq->length > 16)
-		dwrq->length = 0;
-#if 1	/* IW_ENCODE_NOKEY; */
-	if (dwrq->length) {
-		if ((index >= 0) && (index < 4))
-			memcpy(extra, priv->reg.wep_key[index].val,
-			       dwrq->length);
-	} else {
-		memcpy(extra, zeros, dwrq->length);
-	}
-#endif
-	return 0;
-}
-
-#ifndef KSC_OPNOTSUPP
-static int ks_wlan_set_txpow(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_param *vwrq, char *extra)
-{
-	return -EOPNOTSUPP;	/* Not Support */
-}
-
-static int ks_wlan_get_txpow(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_param *vwrq, char *extra)
-{
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	/* Not Support */
-	vwrq->value = 0;
-	vwrq->disabled = (vwrq->value == 0);
-	vwrq->fixed = 1;
-	return 0;
-}
-
-static int ks_wlan_set_retry(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_param *vwrq, char *extra)
-{
-	return -EOPNOTSUPP;	/* Not Support */
-}
-
-static int ks_wlan_get_retry(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_param *vwrq, char *extra)
-{
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	/* Not Support */
-	vwrq->value = 0;
-	vwrq->disabled = (vwrq->value == 0);
-	vwrq->fixed = 1;
-	return 0;
-}
-#endif /* KSC_OPNOTSUPP */
-
-static int ks_wlan_get_range(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_point *dwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	struct iw_range *range = (struct iw_range *)extra;
-	int i, k;
-
-	DPRINTK(2, "\n");
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	dwrq->length = sizeof(struct iw_range);
-	memset(range, 0, sizeof(*range));
-	range->min_nwid = 0x0000;
-	range->max_nwid = 0x0000;
-	range->num_channels = 14;
-	/* Should be based on cap_rid.country to give only
-	 * what the current card support
-	 */
-	k = 0;
-	for (i = 0; i < 13; i++) {	/* channel 1 -- 13 */
-		range->freq[k].i = i + 1;	/* List index */
-		range->freq[k].m = frequency_list[i] * 100000;
-		range->freq[k++].e = 1;	/* Values in table in MHz -> * 10^5 * 10 */
-	}
-	range->num_frequency = k;
-	if (priv->reg.phy_type == D_11B_ONLY_MODE || priv->reg.phy_type == D_11BG_COMPATIBLE_MODE) {	/* channel 14 */
-		range->freq[13].i = 14;	/* List index */
-		range->freq[13].m = frequency_list[13] * 100000;
-		range->freq[13].e = 1;	/* Values in table in MHz -> * 10^5 * 10 */
-		range->num_frequency = 14;
-	}
-
-	/* Hum... Should put the right values there */
-	range->max_qual.qual = 100;
-	range->max_qual.level = 256 - 128;	/* 0 dBm? */
-	range->max_qual.noise = 256 - 128;
-	range->sensitivity = 1;
-
-	if (priv->reg.phy_type == D_11B_ONLY_MODE) {
-		range->bitrate[0] = 1e6;
-		range->bitrate[1] = 2e6;
-		range->bitrate[2] = 5.5e6;
-		range->bitrate[3] = 11e6;
-		range->num_bitrates = 4;
-	} else {	/* D_11G_ONLY_MODE or D_11BG_COMPATIBLE_MODE */
-		range->bitrate[0] = 1e6;
-		range->bitrate[1] = 2e6;
-		range->bitrate[2] = 5.5e6;
-		range->bitrate[3] = 11e6;
-
-		range->bitrate[4] = 6e6;
-		range->bitrate[5] = 9e6;
-		range->bitrate[6] = 12e6;
-		if (IW_MAX_BITRATES < 9) {
-			range->bitrate[7] = 54e6;
-			range->num_bitrates = 8;
-		} else {
-			range->bitrate[7] = 18e6;
-			range->bitrate[8] = 24e6;
-			range->bitrate[9] = 36e6;
-			range->bitrate[10] = 48e6;
-			range->bitrate[11] = 54e6;
-
-			range->num_bitrates = 12;
-		}
-	}
-
-	/* Set an indication of the max TCP throughput
-	 * in bit/s that we can expect using this interface.
-	 * May be use for QoS stuff... Jean II
-	 */
-	if (i > 2)
-		range->throughput = 5000 * 1000;
-	else
-		range->throughput = 1500 * 1000;
-
-	range->min_rts = 0;
-	range->max_rts = 2347;
-	range->min_frag = 256;
-	range->max_frag = 2346;
-
-	range->encoding_size[0] = 5;	/* WEP: RC4 40 bits */
-	range->encoding_size[1] = 13;	/* WEP: RC4 ~128 bits */
-	range->num_encoding_sizes = 2;
-	range->max_encoding_tokens = 4;
-
-	/* power management not support */
-	range->pmp_flags = IW_POWER_ON;
-	range->pmt_flags = IW_POWER_ON;
-	range->pm_capa = 0;
-
-	/* Transmit Power - values are in dBm( or mW) */
-	range->txpower[0] = -256;
-	range->num_txpower = 1;
-	range->txpower_capa = IW_TXPOW_DBM;
-	/* range->txpower_capa = IW_TXPOW_MWATT; */
-
-	range->we_version_source = 21;
-	range->we_version_compiled = WIRELESS_EXT;
-
-	range->retry_capa = IW_RETRY_ON;
-	range->retry_flags = IW_RETRY_ON;
-	range->r_time_flags = IW_RETRY_ON;
-
-	/* Experimental measurements - boundary 11/5.5 Mb/s
-	 *
-	 * Note : with or without the (local->rssi), results
-	 * are somewhat different. - Jean II
-	 */
-	range->avg_qual.qual = 50;
-	range->avg_qual.level = 186;	/* -70 dBm */
-	range->avg_qual.noise = 0;
-
-	/* Event capability (kernel + driver) */
-	range->event_capa[0] = (IW_EVENT_CAPA_K_0 |
-				IW_EVENT_CAPA_MASK(SIOCGIWAP) |
-				IW_EVENT_CAPA_MASK(SIOCGIWSCAN));
-	range->event_capa[1] = IW_EVENT_CAPA_K_1;
-	range->event_capa[4] = (IW_EVENT_CAPA_MASK(IWEVCUSTOM) |
-				IW_EVENT_CAPA_MASK(IWEVMICHAELMICFAILURE));
-
-	/* encode extension (WPA) capability */
-	range->enc_capa = (IW_ENC_CAPA_WPA |
-			   IW_ENC_CAPA_WPA2 |
-			   IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP);
-	return 0;
-}
-
-static int ks_wlan_set_power(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_param *vwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	if (vwrq->disabled) {
-		priv->reg.power_mgmt = POWER_MGMT_ACTIVE;
-	} else {
-		if (priv->reg.operation_mode == MODE_INFRASTRUCTURE)
-			priv->reg.power_mgmt = POWER_MGMT_SAVE1;
-		else
-			return -EINVAL;
-	}
-
-	hostif_sme_enqueue(priv, SME_POW_MNGMT_REQUEST);
-
-	return 0;
-}
-
-static int ks_wlan_get_power(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_param *vwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	if (priv->reg.power_mgmt > 0)
-		vwrq->disabled = 0;
-	else
-		vwrq->disabled = 1;
-
-	return 0;
-}
-
-static int ks_wlan_get_iwstats(struct net_device *dev,
-			       struct iw_request_info *info,
-			       struct iw_quality *vwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	vwrq->qual = 0;	/* not supported */
-	vwrq->level = priv->wstats.qual.level;
-	vwrq->noise = 0;	/* not supported */
-	vwrq->updated = 0;
-
-	return 0;
-}
-
-#ifndef KSC_OPNOTSUPP
-
-static int ks_wlan_set_sens(struct net_device *dev,
-			    struct iw_request_info *info, struct iw_param *vwrq,
-			    char *extra)
-{
-	return -EOPNOTSUPP;	/* Not Support */
-}
-
-static int ks_wlan_get_sens(struct net_device *dev,
-			    struct iw_request_info *info, struct iw_param *vwrq,
-			    char *extra)
-{
-	/* Not Support */
-	vwrq->value = 0;
-	vwrq->disabled = (vwrq->value == 0);
-	vwrq->fixed = 1;
-	return 0;
-}
-#endif /* KSC_OPNOTSUPP */
-
-/* Note : this is deprecated in favor of IWSCAN */
-static int ks_wlan_get_aplist(struct net_device *dev,
-			      struct iw_request_info *info,
-			      struct iw_point *dwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	struct sockaddr *address = (struct sockaddr *)extra;
-	struct iw_quality qual[LOCAL_APLIST_MAX];
-
-	int i;
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	for (i = 0; i < priv->aplist.size; i++) {
-		memcpy(address[i].sa_data, &(priv->aplist.ap[i].bssid[0]),
-		       ETH_ALEN);
-		address[i].sa_family = ARPHRD_ETHER;
-		qual[i].level = 256 - priv->aplist.ap[i].rssi;
-		qual[i].qual = priv->aplist.ap[i].sq;
-		qual[i].noise = 0;	/* invalid noise value */
-		qual[i].updated = 7;
-	}
-	if (i) {
-		dwrq->flags = 1;	/* Should be define'd */
-		memcpy(extra + sizeof(struct sockaddr) * i,
-		       &qual, sizeof(struct iw_quality) * i);
-	}
-	dwrq->length = i;
-
-	return 0;
-}
-
-static int ks_wlan_set_scan(struct net_device *dev,
-			    struct iw_request_info *info,
-			    union iwreq_data *wrqu, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	struct iw_scan_req *req = NULL;
-
-	DPRINTK(2, "\n");
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	/* specified SSID SCAN */
-	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
-	    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
-		req = (struct iw_scan_req *)extra;
-		priv->scan_ssid_len = req->essid_len;
-		memcpy(priv->scan_ssid, req->essid, priv->scan_ssid_len);
-	} else {
-		priv->scan_ssid_len = 0;
-	}
-
-	priv->sme_i.sme_flag |= SME_AP_SCAN;
-	hostif_sme_enqueue(priv, SME_BSS_SCAN_REQUEST);
-
-	/* At this point, just return to the user. */
-
-	return 0;
-}
-
-/*
- * Translate scan data returned from the card to a card independent
- * format that the Wireless Tools will understand - Jean II
- */
-static inline char *ks_wlan_translate_scan(struct net_device *dev,
-					   struct iw_request_info *info,
-					   char *current_ev, char *end_buf,
-					   struct local_ap_t *ap)
-{
-	/* struct ks_wlan_private *priv = (struct ks_wlan_private *)dev->priv; */
-	struct iw_event iwe;	/* Temporary buffer */
-	u16 capabilities;
-	char *current_val;	/* For rates */
-	int i;
-	static const char rsn_leader[] = "rsn_ie=";
-	static const char wpa_leader[] = "wpa_ie=";
-	char buf0[RSN_IE_BODY_MAX * 2 + 30];
-	char buf1[RSN_IE_BODY_MAX * 2 + 30];
-	char *pbuf;
-	/* First entry *MUST* be the AP MAC address */
-	iwe.cmd = SIOCGIWAP;
-	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-	memcpy(iwe.u.ap_addr.sa_data, ap->bssid, ETH_ALEN);
-	current_ev =
-	    iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-				 IW_EV_ADDR_LEN);
-
-	/* Other entries will be displayed in the order we give them */
-
-	/* Add the ESSID */
-	iwe.u.data.length = ap->ssid.size;
-	if (iwe.u.data.length > 32)
-		iwe.u.data.length = 32;
-	iwe.cmd = SIOCGIWESSID;
-	iwe.u.data.flags = 1;
-	current_ev =
-	    iwe_stream_add_point(info, current_ev, end_buf, &iwe,
-				 ap->ssid.body);
-
-	/* Add mode */
-	iwe.cmd = SIOCGIWMODE;
-	capabilities = le16_to_cpu(ap->capability);
-	if (capabilities & (BSS_CAP_ESS | BSS_CAP_IBSS)) {
-		if (capabilities & BSS_CAP_ESS)
-			iwe.u.mode = IW_MODE_INFRA;
-		else
-			iwe.u.mode = IW_MODE_ADHOC;
-		current_ev =
-		    iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-					 IW_EV_UINT_LEN);
-	}
-
-	/* Add frequency */
-	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = ap->channel;
-	iwe.u.freq.m = frequency_list[iwe.u.freq.m - 1] * 100000;
-	iwe.u.freq.e = 1;
-	current_ev =
-	    iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-				 IW_EV_FREQ_LEN);
-
-	/* Add quality statistics */
-	iwe.cmd = IWEVQUAL;
-	iwe.u.qual.level = 256 - ap->rssi;
-	iwe.u.qual.qual = ap->sq;
-	iwe.u.qual.noise = 0;	/* invalid noise value */
-	current_ev =
-	    iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-				 IW_EV_QUAL_LEN);
-
-	/* Add encryption capability */
-	iwe.cmd = SIOCGIWENCODE;
-	if (capabilities & BSS_CAP_PRIVACY)
-		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
-	else
-		iwe.u.data.flags = IW_ENCODE_DISABLED;
-	iwe.u.data.length = 0;
-	current_ev =
-	    iwe_stream_add_point(info, current_ev, end_buf, &iwe,
-				 ap->ssid.body);
-
-	/* Rate : stuffing multiple values in a single event require a bit
-	 * more of magic - Jean II
-	 */
-	current_val = current_ev + IW_EV_LCP_LEN;
-
-	iwe.cmd = SIOCGIWRATE;
-
-	/* These two flags are ignored... */
-	iwe.u.bitrate.fixed = 0;
-	iwe.u.bitrate.disabled = 0;
-
-	/* Max 16 values */
-	for (i = 0; i < 16; i++) {
-		/* NULL terminated */
-		if (i >= ap->rate_set.size)
-			break;
-		/* Bit rate given in 500 kb/s units (+ 0x80) */
-		iwe.u.bitrate.value = ((ap->rate_set.body[i] & 0x7f) * 500000);
-		/* Add new value to event */
-		current_val =
-		    iwe_stream_add_value(info, current_ev, current_val, end_buf,
-					 &iwe, IW_EV_PARAM_LEN);
-	}
-	/* Check if we added any event */
-	if ((current_val - current_ev) > IW_EV_LCP_LEN)
-		current_ev = current_val;
-
-#define GENERIC_INFO_ELEM_ID 0xdd
-#define RSN_INFO_ELEM_ID 0x30
-	if (ap->rsn_ie.id == RSN_INFO_ELEM_ID && ap->rsn_ie.size != 0) {
-		pbuf = &buf0[0];
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVCUSTOM;
-		memcpy(buf0, rsn_leader, sizeof(rsn_leader) - 1);
-		iwe.u.data.length += sizeof(rsn_leader) - 1;
-		pbuf += sizeof(rsn_leader) - 1;
-
-		pbuf += sprintf(pbuf, "%02x", ap->rsn_ie.id);
-		pbuf += sprintf(pbuf, "%02x", ap->rsn_ie.size);
-		iwe.u.data.length += 4;
-
-		for (i = 0; i < ap->rsn_ie.size; i++)
-			pbuf += sprintf(pbuf, "%02x", ap->rsn_ie.body[i]);
-		iwe.u.data.length += (ap->rsn_ie.size) * 2;
-
-		DPRINTK(4, "ap->rsn.size=%d\n", ap->rsn_ie.size);
-
-		current_ev =
-		    iwe_stream_add_point(info, current_ev, end_buf, &iwe,
-					 &buf0[0]);
-	}
-	if (ap->wpa_ie.id == GENERIC_INFO_ELEM_ID && ap->wpa_ie.size != 0) {
-		pbuf = &buf1[0];
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVCUSTOM;
-		memcpy(buf1, wpa_leader, sizeof(wpa_leader) - 1);
-		iwe.u.data.length += sizeof(wpa_leader) - 1;
-		pbuf += sizeof(wpa_leader) - 1;
-
-		pbuf += sprintf(pbuf, "%02x", ap->wpa_ie.id);
-		pbuf += sprintf(pbuf, "%02x", ap->wpa_ie.size);
-		iwe.u.data.length += 4;
-
-		for (i = 0; i < ap->wpa_ie.size; i++)
-			pbuf += sprintf(pbuf, "%02x", ap->wpa_ie.body[i]);
-		iwe.u.data.length += (ap->wpa_ie.size) * 2;
-
-		DPRINTK(4, "ap->rsn.size=%d\n", ap->wpa_ie.size);
-		DPRINTK(4, "iwe.u.data.length=%d\n", iwe.u.data.length);
-
-		current_ev =
-		    iwe_stream_add_point(info, current_ev, end_buf, &iwe,
-					 &buf1[0]);
-	}
-
-	/* The other data in the scan result are not really
-	 * interesting, so for now drop it - Jean II
-	 */
-	return current_ev;
-}
-
-static int ks_wlan_get_scan(struct net_device *dev,
-			    struct iw_request_info *info, struct iw_point *dwrq,
-			    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	int i;
-	char *current_ev = extra;
-
-	DPRINTK(2, "\n");
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	if (priv->sme_i.sme_flag & SME_AP_SCAN) {
-		DPRINTK(2, "flag AP_SCAN\n");
-		return -EAGAIN;
-	}
-
-	if (priv->aplist.size == 0) {
-		/* Client error, no scan results...
-		 * The caller need to restart the scan.
-		 */
-		DPRINTK(2, "aplist 0\n");
-		return -ENODATA;
-	}
-
-	/* Read and parse all entries */
-	for (i = 0; i < priv->aplist.size; i++) {
-		if ((extra + dwrq->length) - current_ev <= IW_EV_ADDR_LEN) {
-			dwrq->length = 0;
-			return -E2BIG;
-		}
-		/* Translate to WE format this entry */
-		current_ev = ks_wlan_translate_scan(dev, info, current_ev,
-						    extra + dwrq->length,
-						    &priv->aplist.ap[i]);
-	}
-	/* Length of data */
-	dwrq->length = (current_ev - extra);
-	dwrq->flags = 0;
-
-	return 0;
-}
-
-/* called after a bunch of SET operations */
-static int ks_wlan_config_commit(struct net_device *dev,
-				 struct iw_request_info *info, void *zwrq,
-				 char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (!priv->need_commit)
-		return 0;
-
-	ks_wlan_setup_parameter(priv, priv->need_commit);
-	priv->need_commit = 0;
-	return 0;
-}
-
-/* set association ie params */
-static int ks_wlan_set_genie(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_point *dwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	DPRINTK(2, "\n");
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	return 0;
-//      return -EOPNOTSUPP;
-}
-
-static int ks_wlan_set_auth_mode(struct net_device *dev,
-				 struct iw_request_info *info,
-				 struct iw_param *vwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	int index = (vwrq->flags & IW_AUTH_INDEX);
-	int value = vwrq->value;
-
-	DPRINTK(2, "index=%d:value=%08X\n", index, value);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	switch (index) {
-	case IW_AUTH_WPA_VERSION:	/* 0 */
-		switch (value) {
-		case IW_AUTH_WPA_VERSION_DISABLED:
-			priv->wpa.version = value;
-			if (priv->wpa.rsn_enabled)
-				priv->wpa.rsn_enabled = 0;
-			priv->need_commit |= SME_RSN;
-			break;
-		case IW_AUTH_WPA_VERSION_WPA:
-		case IW_AUTH_WPA_VERSION_WPA2:
-			priv->wpa.version = value;
-			if (!(priv->wpa.rsn_enabled))
-				priv->wpa.rsn_enabled = 1;
-			priv->need_commit |= SME_RSN;
-			break;
-		default:
-			return -EOPNOTSUPP;
-		}
-		break;
-	case IW_AUTH_CIPHER_PAIRWISE:	/* 1 */
-		switch (value) {
-		case IW_AUTH_CIPHER_NONE:
-			if (priv->reg.privacy_invoked) {
-				priv->reg.privacy_invoked = 0x00;
-				priv->need_commit |= SME_WEP_FLAG;
-			}
-			break;
-		case IW_AUTH_CIPHER_WEP40:
-		case IW_AUTH_CIPHER_TKIP:
-		case IW_AUTH_CIPHER_CCMP:
-		case IW_AUTH_CIPHER_WEP104:
-			if (!priv->reg.privacy_invoked) {
-				priv->reg.privacy_invoked = 0x01;
-				priv->need_commit |= SME_WEP_FLAG;
-			}
-			priv->wpa.pairwise_suite = value;
-			priv->need_commit |= SME_RSN_UNICAST;
-			break;
-		default:
-			return -EOPNOTSUPP;
-		}
-		break;
-	case IW_AUTH_CIPHER_GROUP:	/* 2 */
-		switch (value) {
-		case IW_AUTH_CIPHER_NONE:
-			if (priv->reg.privacy_invoked) {
-				priv->reg.privacy_invoked = 0x00;
-				priv->need_commit |= SME_WEP_FLAG;
-			}
-			break;
-		case IW_AUTH_CIPHER_WEP40:
-		case IW_AUTH_CIPHER_TKIP:
-		case IW_AUTH_CIPHER_CCMP:
-		case IW_AUTH_CIPHER_WEP104:
-			if (!priv->reg.privacy_invoked) {
-				priv->reg.privacy_invoked = 0x01;
-				priv->need_commit |= SME_WEP_FLAG;
-			}
-			priv->wpa.group_suite = value;
-			priv->need_commit |= SME_RSN_MULTICAST;
-			break;
-		default:
-			return -EOPNOTSUPP;
-		}
-		break;
-	case IW_AUTH_KEY_MGMT:	/* 3 */
-		switch (value) {
-		case IW_AUTH_KEY_MGMT_802_1X:
-		case IW_AUTH_KEY_MGMT_PSK:
-		case 0:	/* NONE or 802_1X_NO_WPA */
-		case 4:	/* WPA_NONE */
-			priv->wpa.key_mgmt_suite = value;
-			priv->need_commit |= SME_RSN_AUTH;
-			break;
-		default:
-			return -EOPNOTSUPP;
-		}
-		break;
-	case IW_AUTH_80211_AUTH_ALG:	/* 6 */
-		switch (value) {
-		case IW_AUTH_ALG_OPEN_SYSTEM:
-			priv->wpa.auth_alg = value;
-			priv->reg.authenticate_type = AUTH_TYPE_OPEN_SYSTEM;
-			break;
-		case IW_AUTH_ALG_SHARED_KEY:
-			priv->wpa.auth_alg = value;
-			priv->reg.authenticate_type = AUTH_TYPE_SHARED_KEY;
-			break;
-		case IW_AUTH_ALG_LEAP:
-		default:
-			return -EOPNOTSUPP;
-		}
-		priv->need_commit |= SME_MODE_SET;
-		break;
-	case IW_AUTH_WPA_ENABLED:	/* 7 */
-		priv->wpa.wpa_enabled = value;
-		break;
-	case IW_AUTH_PRIVACY_INVOKED:	/* 10 */
-		if ((value && !priv->reg.privacy_invoked) ||
-		    (!value && priv->reg.privacy_invoked)) {
-			priv->reg.privacy_invoked = value ? 0x01 : 0x00;
-			priv->need_commit |= SME_WEP_FLAG;
-		}
-		break;
-	case IW_AUTH_RX_UNENCRYPTED_EAPOL:	/* 4 */
-	case IW_AUTH_TKIP_COUNTERMEASURES:	/* 5 */
-	case IW_AUTH_DROP_UNENCRYPTED:	/* 8 */
-	case IW_AUTH_ROAMING_CONTROL:	/* 9 */
-	default:
-		break;
-	}
-
-	/* return -EINPROGRESS; */
-	if (priv->need_commit) {
-		ks_wlan_setup_parameter(priv, priv->need_commit);
-		priv->need_commit = 0;
-	}
-	return 0;
-}
-
-static int ks_wlan_get_auth_mode(struct net_device *dev,
-				 struct iw_request_info *info,
-				 struct iw_param *vwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	int index = (vwrq->flags & IW_AUTH_INDEX);
-
-	DPRINTK(2, "index=%d\n", index);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	/*  WPA (not used ?? wpa_supplicant) */
-	switch (index) {
-	case IW_AUTH_WPA_VERSION:
-		vwrq->value = priv->wpa.version;
-		break;
-	case IW_AUTH_CIPHER_PAIRWISE:
-		vwrq->value = priv->wpa.pairwise_suite;
-		break;
-	case IW_AUTH_CIPHER_GROUP:
-		vwrq->value = priv->wpa.group_suite;
-		break;
-	case IW_AUTH_KEY_MGMT:
-		vwrq->value = priv->wpa.key_mgmt_suite;
-		break;
-	case IW_AUTH_80211_AUTH_ALG:
-		vwrq->value = priv->wpa.auth_alg;
-		break;
-	case IW_AUTH_WPA_ENABLED:
-		vwrq->value = priv->wpa.rsn_enabled;
-		break;
-	case IW_AUTH_RX_UNENCRYPTED_EAPOL:	/* OK??? */
-	case IW_AUTH_TKIP_COUNTERMEASURES:
-	case IW_AUTH_DROP_UNENCRYPTED:
-	default:
-		/* return -EOPNOTSUPP; */
-		break;
-	}
-	return 0;
-}
-
-/* set encoding token & mode (WPA)*/
-static int ks_wlan_set_encode_ext(struct net_device *dev,
-				  struct iw_request_info *info,
-				  struct iw_point *dwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	struct iw_encode_ext *enc;
-	int index = dwrq->flags & IW_ENCODE_INDEX;
-	unsigned int commit = 0;
-	struct wpa_key_t *key;
-
-	enc = (struct iw_encode_ext *)extra;
-	if (!enc)
-		return -EINVAL;
-
-	DPRINTK(2, "flags=%04X:: ext_flags=%08X\n", dwrq->flags,
-		enc->ext_flags);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	if (index < 1 || index > 4)
-		return -EINVAL;
-	index--;
-	key = &priv->wpa.key[index];
-
-	if (dwrq->flags & IW_ENCODE_DISABLED)
-		key->key_len = 0;
-
-	key->ext_flags = enc->ext_flags;
-	if (enc->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
-		priv->wpa.txkey = index;
-		commit |= SME_WEP_INDEX;
-	} else if (enc->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
-		memcpy(&key->rx_seq[0], &enc->rx_seq[0], IW_ENCODE_SEQ_MAX_SIZE);
-	}
-
-	memcpy(&key->addr.sa_data[0], &enc->addr.sa_data[0], ETH_ALEN);
-
-	switch (enc->alg) {
-	case IW_ENCODE_ALG_NONE:
-		if (priv->reg.privacy_invoked) {
-			priv->reg.privacy_invoked = 0x00;
-			commit |= SME_WEP_FLAG;
-		}
-		key->key_len = 0;
-
-		break;
-	case IW_ENCODE_ALG_WEP:
-	case IW_ENCODE_ALG_CCMP:
-		if (!priv->reg.privacy_invoked) {
-			priv->reg.privacy_invoked = 0x01;
-			commit |= SME_WEP_FLAG;
-		}
-		if (enc->key_len) {
-			memcpy(&key->key_val[0], &enc->key[0], enc->key_len);
-			key->key_len = enc->key_len;
-			commit |= (SME_WEP_VAL1 << index);
-		}
-		break;
-	case IW_ENCODE_ALG_TKIP:
-		if (!priv->reg.privacy_invoked) {
-			priv->reg.privacy_invoked = 0x01;
-			commit |= SME_WEP_FLAG;
-		}
-		if (enc->key_len == 32) {
-			memcpy(&key->key_val[0], &enc->key[0], enc->key_len - 16);
-			key->key_len = enc->key_len - 16;
-			if (priv->wpa.key_mgmt_suite == 4) {	/* WPA_NONE */
-				memcpy(&key->tx_mic_key[0], &enc->key[16], 8);
-				memcpy(&key->rx_mic_key[0], &enc->key[16], 8);
-			} else {
-				memcpy(&key->tx_mic_key[0], &enc->key[16], 8);
-				memcpy(&key->rx_mic_key[0], &enc->key[24], 8);
-			}
-			commit |= (SME_WEP_VAL1 << index);
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-	key->alg = enc->alg;
-
-	if (commit) {
-		if (commit & SME_WEP_INDEX)
-			hostif_sme_enqueue(priv, SME_SET_TXKEY);
-		if (commit & SME_WEP_VAL_MASK)
-			hostif_sme_enqueue(priv, SME_SET_KEY1 + index);
-		if (commit & SME_WEP_FLAG)
-			hostif_sme_enqueue(priv, SME_WEP_FLAG_REQUEST);
-	}
-
-	return 0;
-}
-
-/* get encoding token & mode (WPA)*/
-static int ks_wlan_get_encode_ext(struct net_device *dev,
-				  struct iw_request_info *info,
-				  struct iw_point *dwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	/* WPA (not used ?? wpa_supplicant)
-	 * struct ks_wlan_private *priv = (struct ks_wlan_private *)dev->priv;
-	 * struct iw_encode_ext *enc;
-	 * enc = (struct iw_encode_ext *)extra;
-	 * int index = dwrq->flags & IW_ENCODE_INDEX;
-	 * WPA (not used ?? wpa_supplicant)
-	 */
-	return 0;
-}
-
-static int ks_wlan_set_pmksa(struct net_device *dev,
-			     struct iw_request_info *info,
-			     struct iw_point *dwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	struct iw_pmksa *pmksa;
-	int i;
-	struct pmk_t *pmk;
-	struct list_head *ptr;
-
-	DPRINTK(2, "\n");
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	if (!extra)
-		return -EINVAL;
-
-	pmksa = (struct iw_pmksa *)extra;
-	DPRINTK(2, "cmd=%d\n", pmksa->cmd);
-
-	switch (pmksa->cmd) {
-	case IW_PMKSA_ADD:
-		if (list_empty(&priv->pmklist.head)) {	/* new list */
-			for (i = 0; i < PMK_LIST_MAX; i++) {
-				pmk = &priv->pmklist.pmk[i];
-				if (memcmp("\x00\x00\x00\x00\x00\x00",
-					   pmk->bssid, ETH_ALEN) == 0)
-					break; /* loop */
-			}
-			memcpy(pmk->bssid, pmksa->bssid.sa_data, ETH_ALEN);
-			memcpy(pmk->pmkid, pmksa->pmkid, IW_PMKID_LEN);
-			list_add(&pmk->list, &priv->pmklist.head);
-			priv->pmklist.size++;
-			break;	/* case */
-		}
-		/* search cache data */
-		list_for_each(ptr, &priv->pmklist.head) {
-			pmk = list_entry(ptr, struct pmk_t, list);
-			if (memcmp(pmksa->bssid.sa_data, pmk->bssid, ETH_ALEN) == 0) {
-				memcpy(pmk->pmkid, pmksa->pmkid, IW_PMKID_LEN);
-				list_move(&pmk->list, &priv->pmklist.head);
-				break; /* list_for_each */
-			}
-		}
-		if (ptr != &priv->pmklist.head)	/* not find address. */
-			break;	/* case */
-
-		if (priv->pmklist.size < PMK_LIST_MAX) {	/* new cache data */
-			for (i = 0; i < PMK_LIST_MAX; i++) {
-				pmk = &priv->pmklist.pmk[i];
-				if (memcmp("\x00\x00\x00\x00\x00\x00",
-					   pmk->bssid, ETH_ALEN) == 0)
-					break; /* loop */
-			}
-			memcpy(pmk->bssid, pmksa->bssid.sa_data, ETH_ALEN);
-			memcpy(pmk->pmkid, pmksa->pmkid, IW_PMKID_LEN);
-			list_add(&pmk->list, &priv->pmklist.head);
-			priv->pmklist.size++;
-		} else {	/* overwrite old cache data */
-			pmk = list_entry(priv->pmklist.head.prev, struct pmk_t,
-					 list);
-			memcpy(pmk->bssid, pmksa->bssid.sa_data, ETH_ALEN);
-			memcpy(pmk->pmkid, pmksa->pmkid, IW_PMKID_LEN);
-			list_move(&pmk->list, &priv->pmklist.head);
-		}
-		break;
-	case IW_PMKSA_REMOVE:
-		if (list_empty(&priv->pmklist.head)) {	/* list empty */
-			return -EINVAL;
-		}
-		/* search cache data */
-		list_for_each(ptr, &priv->pmklist.head) {
-			pmk = list_entry(ptr, struct pmk_t, list);
-			if (memcmp(pmksa->bssid.sa_data, pmk->bssid, ETH_ALEN) == 0) {
-				eth_zero_addr(pmk->bssid);
-				memset(pmk->pmkid, 0, IW_PMKID_LEN);
-				list_del_init(&pmk->list);
-				break;
-			}
-		}
-		if (ptr == &priv->pmklist.head) {	/* not find address. */
-			return 0;
-		}
-
-		break;
-	case IW_PMKSA_FLUSH:
-		memset(&priv->pmklist, 0, sizeof(priv->pmklist));
-		INIT_LIST_HEAD(&priv->pmklist.head);
-		for (i = 0; i < PMK_LIST_MAX; i++)
-			INIT_LIST_HEAD(&priv->pmklist.pmk[i].list);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	hostif_sme_enqueue(priv, SME_SET_PMKSA);
-	return 0;
-}
-
-static struct iw_statistics *ks_get_wireless_stats(struct net_device *dev)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	struct iw_statistics *wstats = &priv->wstats;
-
-	if (!atomic_read(&update_phyinfo)) {
-		if (priv->dev_state < DEVICE_STATE_READY)
-			return NULL;	/* not finished initialize */
-		else
-			return wstats;
-	}
-
-	/* Packets discarded in the wireless adapter due to wireless
-	 * specific problems
-	 */
-	wstats->discard.nwid = 0;	/* Rx invalid nwid      */
-	wstats->discard.code = 0;	/* Rx invalid crypt     */
-	wstats->discard.fragment = 0;	/* Rx invalid frag      */
-	wstats->discard.retries = 0;	/* Tx excessive retries */
-	wstats->discard.misc = 0;	/* Invalid misc         */
-	wstats->miss.beacon = 0;	/* Missed beacon        */
-
-	return wstats;
-}
-
-static int ks_wlan_set_stop_request(struct net_device *dev,
-				    struct iw_request_info *info, __u32 *uwrq,
-				    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	DPRINTK(2, "\n");
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	if (!(*uwrq))
-		return -EINVAL;
-
-	hostif_sme_enqueue(priv, SME_STOP_REQUEST);
-	return 0;
-}
-
-#include <linux/ieee80211.h>
-static int ks_wlan_set_mlme(struct net_device *dev,
-			    struct iw_request_info *info, struct iw_point *dwrq,
-			    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	struct iw_mlme *mlme = (struct iw_mlme *)extra;
-	__u32 mode;
-
-	DPRINTK(2, ":%d :%d\n", mlme->cmd, mlme->reason_code);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	switch (mlme->cmd) {
-	case IW_MLME_DEAUTH:
-		if (mlme->reason_code == WLAN_REASON_MIC_FAILURE)
-			return 0;
-	case IW_MLME_DISASSOC:
-		mode = 1;
-		return ks_wlan_set_stop_request(dev, NULL, &mode, NULL);
-	default:
-		return -EOPNOTSUPP;	/* Not Support */
-	}
-}
-
-static int ks_wlan_get_firmware_version(struct net_device *dev,
-					struct iw_request_info *info,
-					struct iw_point *dwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	strcpy(extra, priv->firmware_version);
-	dwrq->length = priv->version_size + 1;
-	return 0;
-}
-
-static int ks_wlan_set_preamble(struct net_device *dev,
-				struct iw_request_info *info, __u32 *uwrq,
-				char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	if (*uwrq == LONG_PREAMBLE) {	/* 0 */
-		priv->reg.preamble = LONG_PREAMBLE;
-	} else if (*uwrq == SHORT_PREAMBLE) {	/* 1 */
-		priv->reg.preamble = SHORT_PREAMBLE;
-	} else {
-		return -EINVAL;
-	}
-
-	priv->need_commit |= SME_MODE_SET;
-	return -EINPROGRESS;	/* Call commit handler */
-}
-
-static int ks_wlan_get_preamble(struct net_device *dev,
-				struct iw_request_info *info, __u32 *uwrq,
-				char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	*uwrq = priv->reg.preamble;
-	return 0;
-}
-
-static int ks_wlan_set_power_mgmt(struct net_device *dev,
-				  struct iw_request_info *info, __u32 *uwrq,
-				  char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	if (*uwrq == POWER_MGMT_ACTIVE) {	/* 0 */
-		priv->reg.power_mgmt = POWER_MGMT_ACTIVE;
-	} else if (*uwrq == POWER_MGMT_SAVE1) {	/* 1 */
-		if (priv->reg.operation_mode == MODE_INFRASTRUCTURE)
-			priv->reg.power_mgmt = POWER_MGMT_SAVE1;
-		else
-			return -EINVAL;
-	} else if (*uwrq == POWER_MGMT_SAVE2) {	/* 2 */
-		if (priv->reg.operation_mode == MODE_INFRASTRUCTURE)
-			priv->reg.power_mgmt = POWER_MGMT_SAVE2;
-		else
-			return -EINVAL;
-	} else {
-		return -EINVAL;
-	}
-
-	hostif_sme_enqueue(priv, SME_POW_MNGMT_REQUEST);
-
-	return 0;
-}
-
-static int ks_wlan_get_power_mgmt(struct net_device *dev,
-				  struct iw_request_info *info, __u32 *uwrq,
-				  char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-
-	/* for SLEEP MODE */
-	*uwrq = priv->reg.power_mgmt;
-	return 0;
-}
-
-static int ks_wlan_set_scan_type(struct net_device *dev,
-				 struct iw_request_info *info, __u32 *uwrq,
-				 char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	if (*uwrq == ACTIVE_SCAN) {	/* 0 */
-		priv->reg.scan_type = ACTIVE_SCAN;
-	} else if (*uwrq == PASSIVE_SCAN) {	/* 1 */
-		priv->reg.scan_type = PASSIVE_SCAN;
-	} else {
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int ks_wlan_get_scan_type(struct net_device *dev,
-				 struct iw_request_info *info, __u32 *uwrq,
-				 char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	*uwrq = priv->reg.scan_type;
-	return 0;
-}
-
-static int ks_wlan_set_beacon_lost(struct net_device *dev,
-				   struct iw_request_info *info, __u32 *uwrq,
-				   char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	if (*uwrq >= BEACON_LOST_COUNT_MIN && *uwrq <= BEACON_LOST_COUNT_MAX)
-		priv->reg.beacon_lost_count = *uwrq;
-	else
-		return -EINVAL;
-
-	if (priv->reg.operation_mode == MODE_INFRASTRUCTURE) {
-		priv->need_commit |= SME_MODE_SET;
-		return -EINPROGRESS;	/* Call commit handler */
-	} else {
-		return 0;
-	}
-}
-
-static int ks_wlan_get_beacon_lost(struct net_device *dev,
-				   struct iw_request_info *info, __u32 *uwrq,
-				   char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	*uwrq = priv->reg.beacon_lost_count;
-	return 0;
-}
-
-static int ks_wlan_set_phy_type(struct net_device *dev,
-				struct iw_request_info *info, __u32 *uwrq,
-				char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	if (*uwrq == D_11B_ONLY_MODE) {	/* 0 */
-		priv->reg.phy_type = D_11B_ONLY_MODE;
-	} else if (*uwrq == D_11G_ONLY_MODE) {	/* 1 */
-		priv->reg.phy_type = D_11G_ONLY_MODE;
-	} else if (*uwrq == D_11BG_COMPATIBLE_MODE) {	/* 2 */
-		priv->reg.phy_type = D_11BG_COMPATIBLE_MODE;
-	} else {
-		return -EINVAL;
-	}
-
-	priv->need_commit |= SME_MODE_SET;
-	return -EINPROGRESS;	/* Call commit handler */
-}
-
-static int ks_wlan_get_phy_type(struct net_device *dev,
-				struct iw_request_info *info, __u32 *uwrq,
-				char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	*uwrq = priv->reg.phy_type;
-	return 0;
-}
-
-static int ks_wlan_set_cts_mode(struct net_device *dev,
-				struct iw_request_info *info, __u32 *uwrq,
-				char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	if (*uwrq == CTS_MODE_FALSE) {	/* 0 */
-		priv->reg.cts_mode = CTS_MODE_FALSE;
-	} else if (*uwrq == CTS_MODE_TRUE) {	/* 1 */
-		if (priv->reg.phy_type == D_11G_ONLY_MODE ||
-		    priv->reg.phy_type == D_11BG_COMPATIBLE_MODE) {
-			priv->reg.cts_mode = CTS_MODE_TRUE;
-		} else {
-			priv->reg.cts_mode = CTS_MODE_FALSE;
-		}
-	} else {
-		return -EINVAL;
-	}
-
-	priv->need_commit |= SME_MODE_SET;
-	return -EINPROGRESS;	/* Call commit handler */
-}
-
-static int ks_wlan_get_cts_mode(struct net_device *dev,
-				struct iw_request_info *info, __u32 *uwrq,
-				char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	*uwrq = priv->reg.cts_mode;
-	return 0;
-}
-
-static int ks_wlan_set_sleep_mode(struct net_device *dev,
-				  struct iw_request_info *info,
-				  __u32 *uwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	DPRINTK(2, "\n");
-
-	if (*uwrq == SLP_SLEEP) {
-		priv->sleep_mode = *uwrq;
-		netdev_info(dev, "SET_SLEEP_MODE %d\n", priv->sleep_mode);
-
-		hostif_sme_enqueue(priv, SME_STOP_REQUEST);
-		hostif_sme_enqueue(priv, SME_SLEEP_REQUEST);
-
-	} else if (*uwrq == SLP_ACTIVE) {
-		priv->sleep_mode = *uwrq;
-		netdev_info(dev, "SET_SLEEP_MODE %d\n", priv->sleep_mode);
-		hostif_sme_enqueue(priv, SME_SLEEP_REQUEST);
-	} else {
-		netdev_err(dev, "SET_SLEEP_MODE %d errror\n", *uwrq);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int ks_wlan_get_sleep_mode(struct net_device *dev,
-				  struct iw_request_info *info,
-				  __u32 *uwrq, char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	DPRINTK(2, "GET_SLEEP_MODE %d\n", priv->sleep_mode);
-	*uwrq = priv->sleep_mode;
-
-	return 0;
-}
-
-#ifdef WPS
-
-static int ks_wlan_set_wps_enable(struct net_device *dev,
-				  struct iw_request_info *info, __u32 *uwrq,
-				  char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	DPRINTK(2, "\n");
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	if (*uwrq == 0 || *uwrq == 1)
-		priv->wps.wps_enabled = *uwrq;
-	else
-		return -EINVAL;
-
-	hostif_sme_enqueue(priv, SME_WPS_ENABLE_REQUEST);
-
-	return 0;
-}
-
-static int ks_wlan_get_wps_enable(struct net_device *dev,
-				  struct iw_request_info *info, __u32 *uwrq,
-				  char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	DPRINTK(2, "\n");
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	*uwrq = priv->wps.wps_enabled;
-	netdev_info(dev, "return=%d\n", *uwrq);
-
-	return 0;
-}
-
-static int ks_wlan_set_wps_probe_req(struct net_device *dev,
-				     struct iw_request_info *info,
-				     struct iw_point *dwrq, char *extra)
-{
-	u8 *p = extra;
-	unsigned char len;
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	DPRINTK(2, "\n");
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	DPRINTK(2, "dwrq->length=%d\n", dwrq->length);
-
-	/* length check */
-	if (p[1] + 2 != dwrq->length || dwrq->length > 256)
-		return -EINVAL;
-
-	priv->wps.ielen = p[1] + 2 + 1;	/* IE header + IE + sizeof(len) */
-	len = p[1] + 2;	/* IE header + IE */
-
-	memcpy(priv->wps.ie, &len, sizeof(len));
-	p = memcpy(priv->wps.ie + 1, p, len);
-
-	DPRINTK(2, "%d(%#x): %02X %02X %02X %02X ... %02X %02X %02X\n",
-		priv->wps.ielen, priv->wps.ielen, p[0], p[1], p[2], p[3],
-		p[priv->wps.ielen - 3], p[priv->wps.ielen - 2],
-		p[priv->wps.ielen - 1]);
-
-	hostif_sme_enqueue(priv, SME_WPS_PROBE_REQUEST);
-
-	return 0;
-}
-#endif /* WPS */
-
-static int ks_wlan_set_tx_gain(struct net_device *dev,
-			       struct iw_request_info *info, __u32 *uwrq,
-			       char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	if (*uwrq >= 0 && *uwrq <= 0xFF)	/* 0-255 */
-		priv->gain.TxGain = (uint8_t)*uwrq;
-	else
-		return -EINVAL;
-
-	if (priv->gain.TxGain < 0xFF)
-		priv->gain.TxMode = 1;
-	else
-		priv->gain.TxMode = 0;
-
-	hostif_sme_enqueue(priv, SME_SET_GAIN);
-	return 0;
-}
-
-static int ks_wlan_get_tx_gain(struct net_device *dev,
-			       struct iw_request_info *info, __u32 *uwrq,
-			       char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	*uwrq = priv->gain.TxGain;
-	hostif_sme_enqueue(priv, SME_GET_GAIN);
-	return 0;
-}
-
-static int ks_wlan_set_rx_gain(struct net_device *dev,
-			       struct iw_request_info *info, __u32 *uwrq,
-			       char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	if (*uwrq >= 0 && *uwrq <= 0xFF)	/* 0-255 */
-		priv->gain.RxGain = (uint8_t)*uwrq;
-	else
-		return -EINVAL;
-
-	if (priv->gain.RxGain < 0xFF)
-		priv->gain.RxMode = 1;
-	else
-		priv->gain.RxMode = 0;
-
-	hostif_sme_enqueue(priv, SME_SET_GAIN);
-	return 0;
-}
-
-static int ks_wlan_get_rx_gain(struct net_device *dev,
-			       struct iw_request_info *info, __u32 *uwrq,
-			       char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->sleep_mode == SLP_SLEEP)
-		return -EPERM;
-	/* for SLEEP MODE */
-	*uwrq = priv->gain.RxGain;
-	hostif_sme_enqueue(priv, SME_GET_GAIN);
-	return 0;
-}
-
-static int ks_wlan_get_eeprom_cksum(struct net_device *dev,
-				    struct iw_request_info *info, __u32 *uwrq,
-				    char *extra)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	*uwrq = priv->eeprom_checksum;
-	return 0;
-}
-
-static void print_hif_event(struct net_device *dev, int event)
-{
-	switch (event) {
-	case HIF_DATA_REQ:
-		netdev_info(dev, "HIF_DATA_REQ\n");
-		break;
-	case HIF_DATA_IND:
-		netdev_info(dev, "HIF_DATA_IND\n");
-		break;
-	case HIF_MIB_GET_REQ:
-		netdev_info(dev, "HIF_MIB_GET_REQ\n");
-		break;
-	case HIF_MIB_GET_CONF:
-		netdev_info(dev, "HIF_MIB_GET_CONF\n");
-		break;
-	case HIF_MIB_SET_REQ:
-		netdev_info(dev, "HIF_MIB_SET_REQ\n");
-		break;
-	case HIF_MIB_SET_CONF:
-		netdev_info(dev, "HIF_MIB_SET_CONF\n");
-		break;
-	case HIF_POWER_MGMT_REQ:
-		netdev_info(dev, "HIF_POWER_MGMT_REQ\n");
-		break;
-	case HIF_POWER_MGMT_CONF:
-		netdev_info(dev, "HIF_POWER_MGMT_CONF\n");
-		break;
-	case HIF_START_REQ:
-		netdev_info(dev, "HIF_START_REQ\n");
-		break;
-	case HIF_START_CONF:
-		netdev_info(dev, "HIF_START_CONF\n");
-		break;
-	case HIF_CONNECT_IND:
-		netdev_info(dev, "HIF_CONNECT_IND\n");
-		break;
-	case HIF_STOP_REQ:
-		netdev_info(dev, "HIF_STOP_REQ\n");
-		break;
-	case HIF_STOP_CONF:
-		netdev_info(dev, "HIF_STOP_CONF\n");
-		break;
-	case HIF_PS_ADH_SET_REQ:
-		netdev_info(dev, "HIF_PS_ADH_SET_REQ\n");
-		break;
-	case HIF_PS_ADH_SET_CONF:
-		netdev_info(dev, "HIF_PS_ADH_SET_CONF\n");
-		break;
-	case HIF_INFRA_SET_REQ:
-		netdev_info(dev, "HIF_INFRA_SET_REQ\n");
-		break;
-	case HIF_INFRA_SET_CONF:
-		netdev_info(dev, "HIF_INFRA_SET_CONF\n");
-		break;
-	case HIF_ADH_SET_REQ:
-		netdev_info(dev, "HIF_ADH_SET_REQ\n");
-		break;
-	case HIF_ADH_SET_CONF:
-		netdev_info(dev, "HIF_ADH_SET_CONF\n");
-		break;
-	case HIF_AP_SET_REQ:
-		netdev_info(dev, "HIF_AP_SET_REQ\n");
-		break;
-	case HIF_AP_SET_CONF:
-		netdev_info(dev, "HIF_AP_SET_CONF\n");
-		break;
-	case HIF_ASSOC_INFO_IND:
-		netdev_info(dev, "HIF_ASSOC_INFO_IND\n");
-		break;
-	case HIF_MIC_FAILURE_REQ:
-		netdev_info(dev, "HIF_MIC_FAILURE_REQ\n");
-		break;
-	case HIF_MIC_FAILURE_CONF:
-		netdev_info(dev, "HIF_MIC_FAILURE_CONF\n");
-		break;
-	case HIF_SCAN_REQ:
-		netdev_info(dev, "HIF_SCAN_REQ\n");
-		break;
-	case HIF_SCAN_CONF:
-		netdev_info(dev, "HIF_SCAN_CONF\n");
-		break;
-	case HIF_PHY_INFO_REQ:
-		netdev_info(dev, "HIF_PHY_INFO_REQ\n");
-		break;
-	case HIF_PHY_INFO_CONF:
-		netdev_info(dev, "HIF_PHY_INFO_CONF\n");
-		break;
-	case HIF_SLEEP_REQ:
-		netdev_info(dev, "HIF_SLEEP_REQ\n");
-		break;
-	case HIF_SLEEP_CONF:
-		netdev_info(dev, "HIF_SLEEP_CONF\n");
-		break;
-	case HIF_PHY_INFO_IND:
-		netdev_info(dev, "HIF_PHY_INFO_IND\n");
-		break;
-	case HIF_SCAN_IND:
-		netdev_info(dev, "HIF_SCAN_IND\n");
-		break;
-	case HIF_INFRA_SET2_REQ:
-		netdev_info(dev, "HIF_INFRA_SET2_REQ\n");
-		break;
-	case HIF_INFRA_SET2_CONF:
-		netdev_info(dev, "HIF_INFRA_SET2_CONF\n");
-		break;
-	case HIF_ADH_SET2_REQ:
-		netdev_info(dev, "HIF_ADH_SET2_REQ\n");
-		break;
-	case HIF_ADH_SET2_CONF:
-		netdev_info(dev, "HIF_ADH_SET2_CONF\n");
-	}
-}
-
-/* get host command history */
-static int ks_wlan_hostt(struct net_device *dev, struct iw_request_info *info,
-			 __u32 *uwrq, char *extra)
-{
-	int i, event;
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	for (i = 63; i >= 0; i--) {
-		event =
-		    priv->hostt.buff[(priv->hostt.qtail - 1 - i) %
-				     SME_EVENT_BUFF_SIZE];
-		print_hif_event(dev, event);
-	}
-	return 0;
-}
-
-/* Structures to export the Wireless Handlers */
-
-static const struct iw_priv_args ks_wlan_private_args[] = {
-/*{ cmd, set_args, get_args, name[16] } */
-	{KS_WLAN_GET_FIRM_VERSION, IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_CHAR | (128 + 1), "GetFirmwareVer"},
-#ifdef WPS
-	{KS_WLAN_SET_WPS_ENABLE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE, "SetWPSEnable"},
-	{KS_WLAN_GET_WPS_ENABLE, IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetW"},
-	{KS_WLAN_SET_WPS_PROBE_REQ, IW_PRIV_TYPE_BYTE | 2047, IW_PRIV_TYPE_NONE,
-	 "SetWPSProbeReq"},
-#endif /* WPS */
-	{KS_WLAN_SET_PREAMBLE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE, "SetPreamble"},
-	{KS_WLAN_GET_PREAMBLE, IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetPreamble"},
-	{KS_WLAN_SET_POWER_SAVE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE, "SetPowerSave"},
-	{KS_WLAN_GET_POWER_SAVE, IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetPowerSave"},
-	{KS_WLAN_SET_SCAN_TYPE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE, "SetScanType"},
-	{KS_WLAN_GET_SCAN_TYPE, IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetScanType"},
-	{KS_WLAN_SET_RX_GAIN, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE, "SetRxGain"},
-	{KS_WLAN_GET_RX_GAIN, IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetRxGain"},
-	{KS_WLAN_HOSTT, IW_PRIV_TYPE_NONE, IW_PRIV_TYPE_CHAR | (128 + 1),
-	 "hostt"},
-	{KS_WLAN_SET_BEACON_LOST, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE, "SetBeaconLost"},
-	{KS_WLAN_GET_BEACON_LOST, IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetBeaconLost"},
-	{KS_WLAN_SET_SLEEP_MODE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE, "SetSleepMode"},
-	{KS_WLAN_GET_SLEEP_MODE, IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetSleepMode"},
-	{KS_WLAN_SET_TX_GAIN, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE, "SetTxGain"},
-	{KS_WLAN_GET_TX_GAIN, IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetTxGain"},
-	{KS_WLAN_SET_PHY_TYPE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE, "SetPhyType"},
-	{KS_WLAN_GET_PHY_TYPE, IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetPhyType"},
-	{KS_WLAN_SET_CTS_MODE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE, "SetCtsMode"},
-	{KS_WLAN_GET_CTS_MODE, IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetCtsMode"},
-	{KS_WLAN_GET_EEPROM_CKSUM, IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetChecksum"},
-};
-
-static const iw_handler ks_wlan_handler[] = {
-	(iw_handler)ks_wlan_config_commit,	/* SIOCSIWCOMMIT */
-	(iw_handler)ks_wlan_get_name,	/* SIOCGIWNAME */
-	(iw_handler)NULL,	/* SIOCSIWNWID */
-	(iw_handler)NULL,	/* SIOCGIWNWID */
-	(iw_handler)ks_wlan_set_freq,	/* SIOCSIWFREQ */
-	(iw_handler)ks_wlan_get_freq,	/* SIOCGIWFREQ */
-	(iw_handler)ks_wlan_set_mode,	/* SIOCSIWMODE */
-	(iw_handler)ks_wlan_get_mode,	/* SIOCGIWMODE */
-#ifndef KSC_OPNOTSUPP
-	(iw_handler)ks_wlan_set_sens,	/* SIOCSIWSENS */
-	(iw_handler)ks_wlan_get_sens,	/* SIOCGIWSENS */
-#else /* KSC_OPNOTSUPP */
-	(iw_handler)NULL,	/* SIOCSIWSENS */
-	(iw_handler)NULL,	/* SIOCGIWSENS */
-#endif /* KSC_OPNOTSUPP */
-	(iw_handler)NULL,	/* SIOCSIWRANGE */
-	(iw_handler)ks_wlan_get_range,	/* SIOCGIWRANGE */
-	(iw_handler)NULL,	/* SIOCSIWPRIV */
-	(iw_handler)NULL,	/* SIOCGIWPRIV */
-	(iw_handler)NULL,	/* SIOCSIWSTATS */
-	(iw_handler)ks_wlan_get_iwstats,	/* SIOCGIWSTATS */
-	(iw_handler)NULL,	/* SIOCSIWSPY */
-	(iw_handler)NULL,	/* SIOCGIWSPY */
-	(iw_handler)NULL,	/* SIOCSIWTHRSPY */
-	(iw_handler)NULL,	/* SIOCGIWTHRSPY */
-	(iw_handler)ks_wlan_set_wap,	/* SIOCSIWAP */
-	(iw_handler)ks_wlan_get_wap,	/* SIOCGIWAP */
-//      (iw_handler)NULL,                      /* SIOCSIWMLME */
-	(iw_handler)ks_wlan_set_mlme,	/* SIOCSIWMLME */
-	(iw_handler)ks_wlan_get_aplist,	/* SIOCGIWAPLIST */
-	(iw_handler)ks_wlan_set_scan,	/* SIOCSIWSCAN */
-	(iw_handler)ks_wlan_get_scan,	/* SIOCGIWSCAN */
-	(iw_handler)ks_wlan_set_essid,	/* SIOCSIWESSID */
-	(iw_handler)ks_wlan_get_essid,	/* SIOCGIWESSID */
-	(iw_handler)ks_wlan_set_nick,	/* SIOCSIWNICKN */
-	(iw_handler)ks_wlan_get_nick,	/* SIOCGIWNICKN */
-	(iw_handler)NULL,	/* -- hole -- */
-	(iw_handler)NULL,	/* -- hole -- */
-	(iw_handler)ks_wlan_set_rate,	/* SIOCSIWRATE */
-	(iw_handler)ks_wlan_get_rate,	/* SIOCGIWRATE */
-	(iw_handler)ks_wlan_set_rts,	/* SIOCSIWRTS */
-	(iw_handler)ks_wlan_get_rts,	/* SIOCGIWRTS */
-	(iw_handler)ks_wlan_set_frag,	/* SIOCSIWFRAG */
-	(iw_handler)ks_wlan_get_frag,	/* SIOCGIWFRAG */
-#ifndef KSC_OPNOTSUPP
-	(iw_handler)ks_wlan_set_txpow,	/* SIOCSIWTXPOW */
-	(iw_handler)ks_wlan_get_txpow,	/* SIOCGIWTXPOW */
-	(iw_handler)ks_wlan_set_retry,	/* SIOCSIWRETRY */
-	(iw_handler)ks_wlan_get_retry,	/* SIOCGIWRETRY */
-#else /* KSC_OPNOTSUPP */
-	(iw_handler)NULL,	/* SIOCSIWTXPOW */
-	(iw_handler)NULL,	/* SIOCGIWTXPOW */
-	(iw_handler)NULL,	/* SIOCSIWRETRY */
-	(iw_handler)NULL,	/* SIOCGIWRETRY */
-#endif /* KSC_OPNOTSUPP */
-	(iw_handler)ks_wlan_set_encode,	/* SIOCSIWENCODE */
-	(iw_handler)ks_wlan_get_encode,	/* SIOCGIWENCODE */
-	(iw_handler)ks_wlan_set_power,	/* SIOCSIWPOWER */
-	(iw_handler)ks_wlan_get_power,	/* SIOCGIWPOWER */
-	(iw_handler)NULL,	/* -- hole -- */
-	(iw_handler)NULL,	/* -- hole -- */
-//      (iw_handler)NULL,                      /* SIOCSIWGENIE */
-	(iw_handler)ks_wlan_set_genie,	/* SIOCSIWGENIE */
-	(iw_handler)NULL,	/* SIOCGIWGENIE */
-	(iw_handler)ks_wlan_set_auth_mode,	/* SIOCSIWAUTH */
-	(iw_handler)ks_wlan_get_auth_mode,	/* SIOCGIWAUTH */
-	(iw_handler)ks_wlan_set_encode_ext,	/* SIOCSIWENCODEEXT */
-	(iw_handler)ks_wlan_get_encode_ext,	/* SIOCGIWENCODEEXT */
-	(iw_handler)ks_wlan_set_pmksa,	/* SIOCSIWPMKSA */
-	(iw_handler)NULL,	/* -- hole -- */
-};
-
-/* private_handler */
-static const iw_handler ks_wlan_private_handler[] = {
-	(iw_handler)NULL,	/*  0 */
-	(iw_handler)NULL,	/*  1, used to be: KS_WLAN_GET_DRIVER_VERSION */
-	(iw_handler)NULL,	/*  2 */
-	(iw_handler)ks_wlan_get_firmware_version,	/*  3 KS_WLAN_GET_FIRM_VERSION */
-#ifdef WPS
-	(iw_handler)ks_wlan_set_wps_enable,	/*  4 KS_WLAN_SET_WPS_ENABLE  */
-	(iw_handler)ks_wlan_get_wps_enable,	/*  5 KS_WLAN_GET_WPS_ENABLE  */
-	(iw_handler)ks_wlan_set_wps_probe_req,	/*  6 KS_WLAN_SET_WPS_PROBE_REQ */
-#else
-	(iw_handler)NULL,	/*  4 */
-	(iw_handler)NULL,	/*  5 */
-	(iw_handler)NULL,	/*  6 */
-#endif /* WPS */
-
-	(iw_handler)ks_wlan_get_eeprom_cksum,	/*  7 KS_WLAN_GET_CONNECT */
-	(iw_handler)ks_wlan_set_preamble,	/*  8 KS_WLAN_SET_PREAMBLE */
-	(iw_handler)ks_wlan_get_preamble,	/*  9 KS_WLAN_GET_PREAMBLE */
-	(iw_handler)ks_wlan_set_power_mgmt,	/* 10 KS_WLAN_SET_POWER_SAVE */
-	(iw_handler)ks_wlan_get_power_mgmt,	/* 11 KS_WLAN_GET_POWER_SAVE */
-	(iw_handler)ks_wlan_set_scan_type,	/* 12 KS_WLAN_SET_SCAN_TYPE */
-	(iw_handler)ks_wlan_get_scan_type,	/* 13 KS_WLAN_GET_SCAN_TYPE */
-	(iw_handler)ks_wlan_set_rx_gain,	/* 14 KS_WLAN_SET_RX_GAIN */
-	(iw_handler)ks_wlan_get_rx_gain,	/* 15 KS_WLAN_GET_RX_GAIN */
-	(iw_handler)ks_wlan_hostt,	/* 16 KS_WLAN_HOSTT */
-	(iw_handler)NULL,	/* 17 */
-	(iw_handler)ks_wlan_set_beacon_lost,	/* 18 KS_WLAN_SET_BECAN_LOST */
-	(iw_handler)ks_wlan_get_beacon_lost,	/* 19 KS_WLAN_GET_BECAN_LOST */
-	(iw_handler)ks_wlan_set_tx_gain,	/* 20 KS_WLAN_SET_TX_GAIN */
-	(iw_handler)ks_wlan_get_tx_gain,	/* 21 KS_WLAN_GET_TX_GAIN */
-	(iw_handler)ks_wlan_set_phy_type,	/* 22 KS_WLAN_SET_PHY_TYPE */
-	(iw_handler)ks_wlan_get_phy_type,	/* 23 KS_WLAN_GET_PHY_TYPE */
-	(iw_handler)ks_wlan_set_cts_mode,	/* 24 KS_WLAN_SET_CTS_MODE */
-	(iw_handler)ks_wlan_get_cts_mode,	/* 25 KS_WLAN_GET_CTS_MODE */
-	(iw_handler)NULL,	/* 26 */
-	(iw_handler)NULL,	/* 27 */
-	(iw_handler)ks_wlan_set_sleep_mode,	/* 28 KS_WLAN_SET_SLEEP_MODE */
-	(iw_handler)ks_wlan_get_sleep_mode,	/* 29 KS_WLAN_GET_SLEEP_MODE */
-	(iw_handler)NULL,	/* 30 */
-	(iw_handler)NULL,	/* 31 */
-};
-
-static const struct iw_handler_def ks_wlan_handler_def = {
-	.num_standard = sizeof(ks_wlan_handler) / sizeof(iw_handler),
-	.num_private = sizeof(ks_wlan_private_handler) / sizeof(iw_handler),
-	.num_private_args =
-	    sizeof(ks_wlan_private_args) / sizeof(struct iw_priv_args),
-	.standard = (iw_handler *)ks_wlan_handler,
-	.private = (iw_handler *)ks_wlan_private_handler,
-	.private_args = (struct iw_priv_args *)ks_wlan_private_args,
-	.get_wireless_stats = ks_get_wireless_stats,
-};
-
-static int ks_wlan_netdev_ioctl(struct net_device *dev, struct ifreq *rq,
-				int cmd)
-{
-	int ret;
-	struct iwreq *wrq = (struct iwreq *)rq;
-
-	switch (cmd) {
-	case SIOCIWFIRSTPRIV + 20:	/* KS_WLAN_SET_STOP_REQ */
-		ret = ks_wlan_set_stop_request(dev, NULL, &wrq->u.mode, NULL);
-		break;
-		// All other calls are currently unsupported
-	default:
-		ret = -EOPNOTSUPP;
-	}
-
-	DPRINTK(5, "return=%d\n", ret);
-	return ret;
-}
-
-static
-struct net_device_stats *ks_wlan_get_stats(struct net_device *dev)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	if (priv->dev_state < DEVICE_STATE_READY)
-		return NULL;	/* not finished initialize */
-
-	return &priv->nstats;
-}
-
-static
-int ks_wlan_set_mac_address(struct net_device *dev, void *addr)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	struct sockaddr *mac_addr = (struct sockaddr *)addr;
-
-	if (netif_running(dev))
-		return -EBUSY;
-	memcpy(dev->dev_addr, mac_addr->sa_data, dev->addr_len);
-	memcpy(priv->eth_addr, mac_addr->sa_data, ETH_ALEN);
-
-	priv->mac_address_valid = 0;
-	hostif_sme_enqueue(priv, SME_MACADDRESS_SET_REQUEST);
-	netdev_info(dev, "ks_wlan:  MAC ADDRESS = %pM\n", priv->eth_addr);
-	return 0;
-}
-
-static
-void ks_wlan_tx_timeout(struct net_device *dev)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	DPRINTK(1, "head(%d) tail(%d)!!\n", priv->tx_dev.qhead,
-		priv->tx_dev.qtail);
-	if (!netif_queue_stopped(dev))
-		netif_stop_queue(dev);
-	priv->nstats.tx_errors++;
-	netif_wake_queue(dev);
-}
-
-static
-int ks_wlan_start_xmit(struct sk_buff *skb, struct net_device *dev)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-	int ret;
-
-	DPRINTK(3, "in_interrupt()=%ld\n", in_interrupt());
-
-	if (!skb) {
-		netdev_err(dev, "ks_wlan:  skb == NULL!!!\n");
-		return 0;
-	}
-	if (priv->dev_state < DEVICE_STATE_READY) {
-		dev_kfree_skb(skb);
-		return 0;	/* not finished initialize */
-	}
-
-	if (netif_running(dev))
-		netif_stop_queue(dev);
-
-	ret = hostif_data_request(priv, skb);
-	netif_trans_update(dev);
-
-	if (ret)
-		DPRINTK(4, "hostif_data_request error: =%d\n", ret);
-
-	return 0;
-}
-
-void send_packet_complete(struct ks_wlan_private *priv, struct sk_buff *skb)
-{
-	DPRINTK(3, "\n");
-
-	priv->nstats.tx_packets++;
-
-	if (netif_queue_stopped(priv->net_dev))
-		netif_wake_queue(priv->net_dev);
-
-	if (skb) {
-		priv->nstats.tx_bytes += skb->len;
-		dev_kfree_skb(skb);
-	}
-}
-
-/*
- * Set or clear the multicast filter for this adaptor.
- * This routine is not state sensitive and need not be SMP locked.
- */
-static
-void ks_wlan_set_multicast_list(struct net_device *dev)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	DPRINTK(4, "\n");
-	if (priv->dev_state < DEVICE_STATE_READY)
-		return;	/* not finished initialize */
-	hostif_sme_enqueue(priv, SME_MULTICAST_REQUEST);
-}
-
-static
-int ks_wlan_open(struct net_device *dev)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	priv->cur_rx = 0;
-
-	if (!priv->mac_address_valid) {
-		netdev_err(dev, "ks_wlan : %s Not READY !!\n", dev->name);
-		return -EBUSY;
-	}
-	netif_start_queue(dev);
-
-	return 0;
-}
-
-static
-int ks_wlan_close(struct net_device *dev)
-{
-	netif_stop_queue(dev);
-
-	DPRINTK(4, "%s: Shutting down ethercard, status was 0x%4.4x.\n",
-		dev->name, 0x00);
-
-	return 0;
-}
-
-/* Operational parameters that usually are not changed. */
-/* Time in jiffies before concluding the transmitter is hung. */
-#define TX_TIMEOUT  (3 * HZ)
-static const unsigned char dummy_addr[] = {
-	0x00, 0x0b, 0xe3, 0x00, 0x00, 0x00
-};
-
-static const struct net_device_ops ks_wlan_netdev_ops = {
-	.ndo_start_xmit = ks_wlan_start_xmit,
-	.ndo_open = ks_wlan_open,
-	.ndo_stop = ks_wlan_close,
-	.ndo_do_ioctl = ks_wlan_netdev_ioctl,
-	.ndo_set_mac_address = ks_wlan_set_mac_address,
-	.ndo_get_stats = ks_wlan_get_stats,
-	.ndo_tx_timeout = ks_wlan_tx_timeout,
-	.ndo_set_rx_mode = ks_wlan_set_multicast_list,
-};
-
-int ks_wlan_net_start(struct net_device *dev)
-{
-	struct ks_wlan_private *priv;
-	/* int rc; */
-
-	priv = netdev_priv(dev);
-	priv->mac_address_valid = 0;
-	priv->need_commit = 0;
-
-	priv->device_open_status = 1;
-
-	/* phy information update timer */
-	atomic_set(&update_phyinfo, 0);
-	setup_timer(&update_phyinfo_timer, ks_wlan_update_phyinfo_timeout,
-		    (unsigned long)priv);
-
-	/* dummy address set */
-	memcpy(priv->eth_addr, dummy_addr, ETH_ALEN);
-	dev->dev_addr[0] = priv->eth_addr[0];
-	dev->dev_addr[1] = priv->eth_addr[1];
-	dev->dev_addr[2] = priv->eth_addr[2];
-	dev->dev_addr[3] = priv->eth_addr[3];
-	dev->dev_addr[4] = priv->eth_addr[4];
-	dev->dev_addr[5] = priv->eth_addr[5];
-	dev->dev_addr[6] = 0x00;
-	dev->dev_addr[7] = 0x00;
-
-	/* The ks_wlan-specific entries in the device structure. */
-	dev->netdev_ops = &ks_wlan_netdev_ops;
-	dev->wireless_handlers = (struct iw_handler_def *)&ks_wlan_handler_def;
-	dev->watchdog_timeo = TX_TIMEOUT;
-
-	netif_carrier_off(dev);
-
-	return 0;
-}
-
-int ks_wlan_net_stop(struct net_device *dev)
-{
-	struct ks_wlan_private *priv = netdev_priv(dev);
-
-	priv->device_open_status = 0;
-	del_timer_sync(&update_phyinfo_timer);
-
-	if (netif_running(dev))
-		netif_stop_queue(dev);
-
-	return 0;
-}
-
-/**
- * is_connect_status() - return true if status is 'connected'
- * @status: high bit is used as FORCE_DISCONNECT, low bits used for
- * 	connect status.
- */
-bool is_connect_status(u32 status)
-{
-	return (status & CONNECT_STATUS_MASK) == CONNECT_STATUS;
-}
-
-/**
- * is_disconnect_status() - return true if status is 'disconnected'
- * @status: high bit is used as FORCE_DISCONNECT, low bits used for
- * 	disconnect status.
- */
-bool is_disconnect_status(u32 status)
-{
-	return (status & CONNECT_STATUS_MASK) == DISCONNECT_STATUS;
-}
diff --git a/drivers/staging/ks7010/michael_mic.c b/drivers/staging/ks7010/michael_mic.c
deleted file mode 100644
index 80497ef..0000000
--- a/drivers/staging/ks7010/michael_mic.c
+++ /dev/null
@@ -1,148 +0,0 @@
-/*
- *   Driver for KeyStream wireless LAN
- *
- *   Copyright (C) 2005-2008 KeyStream Corp.
- *   Copyright (C) 2009 Renesas Technology Corp.
- *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License version 2 as
- *   published by the Free Software Foundation.
- */
-
-#include <linux/types.h>
-#include <linux/string.h>
-#include "michael_mic.h"
-
-// Rotation functions on 32 bit values
-#define ROL32(A, n)	(((A) << (n)) | (((A) >> (32 - (n))) & ((1UL << (n)) - 1)))
-#define ROR32(A, n)	ROL32((A), 32 - (n))
-// Convert from Byte[] to UInt32 in a portable way
-#define getUInt32(A, B)	((uint32_t)(A[B + 0] << 0) \
-		+ (A[B + 1] << 8) + (A[B + 2] << 16) + (A[B + 3] << 24))
-
-// Convert from UInt32 to Byte[] in a portable way
-#define putUInt32(A, B, C)					\
-do {								\
-	A[B + 0] = (uint8_t)(C & 0xff);				\
-	A[B + 1] = (uint8_t)((C >> 8) & 0xff);			\
-	A[B + 2] = (uint8_t)((C >> 16) & 0xff);			\
-	A[B + 3] = (uint8_t)((C >> 24) & 0xff);			\
-} while (0)
-
-// Reset the state to the empty message.
-#define MichaelClear(A)			\
-do {					\
-	A->L = A->K0;			\
-	A->R = A->K1;			\
-	A->nBytesInM = 0;		\
-} while (0)
-
-static
-void MichaelInitializeFunction(struct michael_mic_t *Mic, uint8_t *key)
-{
-	// Set the key
-	Mic->K0 = getUInt32(key, 0);
-	Mic->K1 = getUInt32(key, 4);
-
-	//clear();
-	MichaelClear(Mic);
-}
-
-#define MichaelBlockFunction(L, R)				\
-do {								\
-	R ^= ROL32(L, 17);					\
-	L += R;							\
-	R ^= ((L & 0xff00ff00) >> 8) | ((L & 0x00ff00ff) << 8);	\
-	L += R;							\
-	R ^= ROL32(L, 3);					\
-	L += R;							\
-	R ^= ROR32(L, 2);					\
-	L += R;							\
-} while (0)
-
-static
-void MichaelAppend(struct michael_mic_t *Mic, uint8_t *src, int nBytes)
-{
-	int addlen;
-
-	if (Mic->nBytesInM) {
-		addlen = 4 - Mic->nBytesInM;
-		if (addlen > nBytes)
-			addlen = nBytes;
-		memcpy(&Mic->M[Mic->nBytesInM], src, addlen);
-		Mic->nBytesInM += addlen;
-		src += addlen;
-		nBytes -= addlen;
-
-		if (Mic->nBytesInM < 4)
-			return;
-
-		Mic->L ^= getUInt32(Mic->M, 0);
-		MichaelBlockFunction(Mic->L, Mic->R);
-		Mic->nBytesInM = 0;
-	}
-
-	while (nBytes >= 4) {
-		Mic->L ^= getUInt32(src, 0);
-		MichaelBlockFunction(Mic->L, Mic->R);
-		src += 4;
-		nBytes -= 4;
-	}
-
-	if (nBytes > 0) {
-		Mic->nBytesInM = nBytes;
-		memcpy(Mic->M, src, nBytes);
-	}
-}
-
-static
-void MichaelGetMIC(struct michael_mic_t *Mic, uint8_t *dst)
-{
-	u8 *data = Mic->M;
-
-	switch (Mic->nBytesInM) {
-	case 0:
-		Mic->L ^= 0x5a;
-		break;
-	case 1:
-		Mic->L ^= data[0] | 0x5a00;
-		break;
-	case 2:
-		Mic->L ^= data[0] | (data[1] << 8) | 0x5a0000;
-		break;
-	case 3:
-		Mic->L ^= data[0] | (data[1] << 8) | (data[2] << 16) |
-		    0x5a000000;
-		break;
-	}
-	MichaelBlockFunction(Mic->L, Mic->R);
-	MichaelBlockFunction(Mic->L, Mic->R);
-	// The appendByte function has already computed the result.
-	putUInt32(dst, 0, Mic->L);
-	putUInt32(dst, 4, Mic->R);
-
-	// Reset to the empty message.
-	MichaelClear(Mic);
-}
-
-void MichaelMICFunction(struct michael_mic_t *Mic, u8 *Key,
-			u8 *Data, int Len, u8 priority,
-			u8 *Result)
-{
-	u8 pad_data[4] = { priority, 0, 0, 0 };
-	// Compute the MIC value
-	/*
-	 * IEEE802.11i  page 47
-	 * Figure 43g TKIP MIC processing format
-	 * +--+--+--------+--+----+--+--+--+--+--+--+--+--+
-	 * |6 |6 |1       |3 |M   |1 |1 |1 |1 |1 |1 |1 |1 | Octet
-	 * +--+--+--------+--+----+--+--+--+--+--+--+--+--+
-	 * |DA|SA|Priority|0 |Data|M0|M1|M2|M3|M4|M5|M6|M7|
-	 * +--+--+--------+--+----+--+--+--+--+--+--+--+--+
-	 */
-	MichaelInitializeFunction(Mic, Key);
-	MichaelAppend(Mic, (uint8_t *)Data, 12);	/* |DA|SA| */
-	MichaelAppend(Mic, pad_data, 4);	/* |Priority|0|0|0| */
-	MichaelAppend(Mic, (uint8_t *)(Data + 12), Len - 12);	/* |Data| */
-	MichaelGetMIC(Mic, Result);
-}
diff --git a/drivers/staging/ks7010/michael_mic.h b/drivers/staging/ks7010/michael_mic.h
deleted file mode 100644
index 758e429..0000000
--- a/drivers/staging/ks7010/michael_mic.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- *   Driver for KeyStream wireless LAN
- *
- *   Copyright (C) 2005-2008 KeyStream Corp.
- *   Copyright (C) 2009 Renesas Technology Corp.
- *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License version 2 as
- *   published by the Free Software Foundation.
- */
-
-/* MichaelMIC routine define */
-struct michael_mic_t {
-	u32 K0;	// Key
-	u32 K1;	// Key
-	u32 L;	// Current state
-	u32 R;	// Current state
-	u8 M[4];	// Message accumulator (single word)
-	int nBytesInM;	// # bytes in M
-	u8 Result[8];
-};
-
-void MichaelMICFunction(struct michael_mic_t *Mic, u8 *Key,
-			u8 *Data, int Len, u8 priority,
-			u8 *Result);
diff --git a/drivers/staging/ks7010/wext/Kconfig b/drivers/staging/ks7010/wext/Kconfig
new file mode 100644
index 0000000..0b92176
--- /dev/null
+++ b/drivers/staging/ks7010/wext/Kconfig
@@ -0,0 +1,10 @@
+config KS7010
+	tristate "KeyStream KS7010 SDIO support"
+	depends on MMC && WIRELESS
+	select WIRELESS_EXT
+	select WEXT_PRIV
+	select FW_LOADER
+	help
+	  This is a driver for KeyStream KS7010 based SDIO WIFI cards. It is
+	  found on at least later Spectec SDW-821 (FCC-ID "S2Y-WLAN-11G-K" only,
+	  sadly not FCC-ID "S2Y-WLAN-11B-G") and Spectec SDW-823 microSD cards.
diff --git a/drivers/staging/ks7010/wext/Makefile b/drivers/staging/ks7010/wext/Makefile
new file mode 100644
index 0000000..69fcf8d
--- /dev/null
+++ b/drivers/staging/ks7010/wext/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_KS7010) += ks7010.o
+
+ccflags-y 	     += -DKS_WLAN_DEBUG=0
+ks7010-y	     := michael_mic.o ks_hostif.o ks_wlan_net.o ks7010_sdio.o
diff --git a/drivers/staging/ks7010/wext/TODO b/drivers/staging/ks7010/wext/TODO
new file mode 100644
index 0000000..d393ca5
--- /dev/null
+++ b/drivers/staging/ks7010/wext/TODO
@@ -0,0 +1,36 @@
+KS7010 Linux driver
+===================
+
+This driver is based on source code from the Ben Nanonote extra repository [1]
+which is based on the original v007 release from Renesas [2]. Some more
+background info about the chipset can be found here [3] and here [4]. Thank
+you to all which already participated in cleaning up the driver so far!
+
+[1] http://projects.qi-hardware.com/index.php/p/openwrt-packages/source/tree/master/ks7010/src
+[2] http://downloads.qi-hardware.com/software/ks7010_sdio_v007.tar.bz2
+[3] http://en.qi-hardware.com/wiki/Ben_NanoNote_Wi-Fi
+[4] https://wikidevi.com/wiki/Renesas
+
+TODO
+----
+
+First a few words what not to do (at least not blindly):
+
+- don't be overly strict with the 80 char limit. Only if it REALLY makes the
+  code more readable
+
+Now the TODOs:
+
+- fix codechecker warnings (checkpatch, sparse, smatch). But PLEASE make sure
+  that you are not only silencing the warning but really fixing code. You
+  should understand the change you submit.
+- fix the 'card removal' event when card is inserted when booting
+- check what other upstream wireless mechanisms can be used instead of the
+  custom ones here
+- replace custom Michael MIC implementation with the kernel
+  implementation. This task is only required for a *clean* WEXT interface.
+
+Please send any patches to:
+Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+Wolfram Sang <wsa@the-dreams.de>
+Linux Driver Project Developer List <driverdev-devel@linuxdriverproject.org>
diff --git a/drivers/staging/ks7010/wext/eap_packet.h b/drivers/staging/ks7010/wext/eap_packet.h
new file mode 100644
index 0000000..b2d25ef
--- /dev/null
+++ b/drivers/staging/ks7010/wext/eap_packet.h
@@ -0,0 +1,144 @@
+#ifndef EAP_PACKET_H
+#define EAP_PACKET_H
+
+#include <linux/compiler.h>
+
+#define WBIT(n) (1 << (n))
+
+#ifndef ETH_ALEN
+#define ETH_ALEN 6
+#endif
+
+#define ETHER_HDR_SIZE 20
+
+struct ether_hdr {
+	unsigned char h_dest[ETH_ALEN];	/* destination eth addr */
+	unsigned char h_source[ETH_ALEN];	/* source ether addr    */
+	unsigned char h_dest_snap;
+	unsigned char h_source_snap;
+	unsigned char h_command;
+	unsigned char h_vendor_id[3];
+	unsigned short h_proto;	/* packet type ID field */
+#define ETHER_PROTOCOL_TYPE_EAP		0x888e
+#define ETHER_PROTOCOL_TYPE_IP		0x0800
+#define ETHER_PROTOCOL_TYPE_ARP		0x0806
+	/* followed by length octets of data */
+} __packed;
+
+struct ieee802_1x_hdr {
+	unsigned char version;
+	unsigned char type;
+	unsigned short length;
+	/* followed by length octets of data */
+} __packed;
+
+#define EAPOL_VERSION 2
+
+enum { IEEE802_1X_TYPE_EAP_PACKET = 0,
+	IEEE802_1X_TYPE_EAPOL_START = 1,
+	IEEE802_1X_TYPE_EAPOL_LOGOFF = 2,
+	IEEE802_1X_TYPE_EAPOL_KEY = 3,
+	IEEE802_1X_TYPE_EAPOL_ENCAPSULATED_ASF_ALERT = 4
+};
+
+enum { EAPOL_KEY_TYPE_RC4 = 1, EAPOL_KEY_TYPE_RSN = 2,
+	EAPOL_KEY_TYPE_WPA = 254
+};
+
+#define IEEE8021X_REPLAY_COUNTER_LEN 8
+#define IEEE8021X_KEY_SIGN_LEN 16
+#define IEEE8021X_KEY_IV_LEN 16
+
+#define IEEE8021X_KEY_INDEX_FLAG 0x80
+#define IEEE8021X_KEY_INDEX_MASK 0x03
+
+struct ieee802_1x_eapol_key {
+	unsigned char type;
+	unsigned short key_length;
+	/*
+	 * does not repeat within the life of the keying material used to
+	 * encrypt the Key field; 64-bit NTP timestamp MAY be used here
+	 */
+	unsigned char replay_counter[IEEE8021X_REPLAY_COUNTER_LEN];
+	unsigned char key_iv[IEEE8021X_KEY_IV_LEN]; /* cryptographically random
+						     * number
+						     */
+	unsigned char key_index;	/*
+					 * key flag in the most significant bit:
+					 * 0 = broadcast (default key),
+					 * 1 = unicast (key mapping key);
+					 * key index is in the 7 least
+					 * significant bits
+					 */
+	/*
+	 * HMAC-MD5 message integrity check computed with MS-MPPE-Send-Key as
+	 * the key
+	 */
+	unsigned char key_signature[IEEE8021X_KEY_SIGN_LEN];
+
+	/*
+	 * followed by key: if packet body length = 44 + key length, then the
+	 * key field (of key_length bytes) contains the key in encrypted form;
+	 * if packet body length = 44, key field is absent and key_length
+	 * represents the number of least significant octets from
+	 * MS-MPPE-Send-Key attribute to be used as the keying material;
+	 * RC4 key used in encryption = Key-IV + MS-MPPE-Recv-Key
+	 */
+} __packed;
+
+#define WPA_NONCE_LEN 32
+#define WPA_REPLAY_COUNTER_LEN 8
+
+struct wpa_eapol_key {
+	unsigned char type;
+	unsigned short key_info;
+	unsigned short key_length;
+	unsigned char replay_counter[WPA_REPLAY_COUNTER_LEN];
+	unsigned char key_nonce[WPA_NONCE_LEN];
+	unsigned char key_iv[16];
+	unsigned char key_rsc[8];
+	unsigned char key_id[8];	/* Reserved in IEEE 802.11i/RSN */
+	unsigned char key_mic[16];
+	unsigned short key_data_length;
+	/* followed by key_data_length bytes of key_data */
+} __packed;
+
+#define WPA_KEY_INFO_TYPE_MASK (WBIT(0) | WBIT(1) | WBIT(2))
+#define WPA_KEY_INFO_TYPE_HMAC_MD5_RC4 WBIT(0)
+#define WPA_KEY_INFO_TYPE_HMAC_SHA1_AES WBIT(1)
+#define WPA_KEY_INFO_KEY_TYPE WBIT(3)	/* 1 = Pairwise, 0 = Group key */
+/* bit4..5 is used in WPA, but is reserved in IEEE 802.11i/RSN */
+#define WPA_KEY_INFO_KEY_INDEX_MASK (WBIT(4) | WBIT(5))
+#define WPA_KEY_INFO_KEY_INDEX_SHIFT 4
+#define WPA_KEY_INFO_INSTALL WBIT(6)	/* pairwise */
+#define WPA_KEY_INFO_TXRX WBIT(6)	/* group */
+#define WPA_KEY_INFO_ACK WBIT(7)
+#define WPA_KEY_INFO_MIC WBIT(8)
+#define WPA_KEY_INFO_SECURE WBIT(9)
+#define WPA_KEY_INFO_ERROR WBIT(10)
+#define WPA_KEY_INFO_REQUEST WBIT(11)
+#define WPA_KEY_INFO_ENCR_KEY_DATA WBIT(12)	/* IEEE 802.11i/RSN only */
+
+#define WPA_CAPABILITY_PREAUTH WBIT(0)
+
+#define GENERIC_INFO_ELEM 0xdd
+#define RSN_INFO_ELEM 0x30
+
+enum {
+	REASON_UNSPECIFIED = 1,
+	REASON_DEAUTH_LEAVING = 3,
+	REASON_INVALID_IE = 13,
+	REASON_MICHAEL_MIC_FAILURE = 14,
+	REASON_4WAY_HANDSHAKE_TIMEOUT = 15,
+	REASON_GROUP_KEY_UPDATE_TIMEOUT = 16,
+	REASON_IE_IN_4WAY_DIFFERS = 17,
+	REASON_GROUP_CIPHER_NOT_VALID = 18,
+	REASON_PAIRWISE_CIPHER_NOT_VALID = 19,
+	REASON_AKMP_NOT_VALID = 20,
+	REASON_UNSUPPORTED_RSN_IE_VERSION = 21,
+	REASON_INVALID_RSN_IE_CAPAB = 22,
+	REASON_IEEE_802_1X_AUTH_FAILED = 23,
+	REASON_CIPHER_SUITE_REJECTED = 24
+};
+
+#endif /* EAP_PACKET_H */
diff --git a/drivers/staging/ks7010/wext/ks7010_sdio.c b/drivers/staging/ks7010/wext/ks7010_sdio.c
new file mode 100644
index 0000000..c325f48
--- /dev/null
+++ b/drivers/staging/ks7010/wext/ks7010_sdio.c
@@ -0,0 +1,1079 @@
+/*
+ *   Driver for KeyStream, KS7010 based SDIO cards.
+ *
+ *   Copyright (C) 2006-2008 KeyStream Corp.
+ *   Copyright (C) 2009 Renesas Technology Corp.
+ *   Copyright (C) 2016 Sang Engineering, Wolfram Sang
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License version 2 as
+ *   published by the Free Software Foundation.
+ */
+
+#include <linux/firmware.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/workqueue.h>
+#include <linux/atomic.h>
+
+#include "ks_wlan.h"
+#include "ks_wlan_ioctl.h"
+#include "ks_hostif.h"
+#include "ks7010_sdio.h"
+
+#define KS7010_FUNC_NUM 1
+#define KS7010_IO_BLOCK_SIZE 512
+#define KS7010_MAX_CLOCK 25000000
+
+static const struct sdio_device_id ks7010_sdio_ids[] = {
+	{SDIO_DEVICE(SDIO_VENDOR_ID_KS_CODE_A, SDIO_DEVICE_ID_KS_7010)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_KS_CODE_B, SDIO_DEVICE_ID_KS_7010)},
+	{ /* all zero */ }
+};
+MODULE_DEVICE_TABLE(sdio, ks7010_sdio_ids);
+
+#define inc_txqhead(priv) \
+	(priv->tx_dev.qhead = (priv->tx_dev.qhead + 1) % TX_DEVICE_BUFF_SIZE)
+#define inc_txqtail(priv) \
+	(priv->tx_dev.qtail = (priv->tx_dev.qtail + 1) % TX_DEVICE_BUFF_SIZE)
+#define cnt_txqbody(priv) \
+	(((priv->tx_dev.qtail + TX_DEVICE_BUFF_SIZE) - (priv->tx_dev.qhead)) % TX_DEVICE_BUFF_SIZE)
+
+#define inc_rxqhead(priv) \
+	(priv->rx_dev.qhead = (priv->rx_dev.qhead + 1) % RX_DEVICE_BUFF_SIZE)
+#define inc_rxqtail(priv) \
+	(priv->rx_dev.qtail = (priv->rx_dev.qtail + 1) % RX_DEVICE_BUFF_SIZE)
+#define cnt_rxqbody(priv) \
+	(((priv->rx_dev.qtail + RX_DEVICE_BUFF_SIZE) - (priv->rx_dev.qhead)) % RX_DEVICE_BUFF_SIZE)
+
+/* Read single byte from device address into byte (CMD52) */
+static int ks7010_sdio_readb(struct ks_wlan_private *priv, unsigned int address,
+			     unsigned char *byte)
+{
+	struct sdio_func *func = priv->ks_sdio_card->func;
+	int ret;
+
+	*byte = sdio_readb(func, address, &ret);
+
+	return ret;
+}
+
+/* Read length bytes from device address into buffer (CMD53) */
+static int ks7010_sdio_read(struct ks_wlan_private *priv, unsigned int address,
+			    unsigned char *buffer, int length)
+{
+	struct sdio_func *func = priv->ks_sdio_card->func;
+
+	return sdio_memcpy_fromio(func, buffer, address, length);
+}
+
+/* Write single byte to device address (CMD52) */
+static int ks7010_sdio_writeb(struct ks_wlan_private *priv,
+			      unsigned int address, unsigned char byte)
+{
+	struct sdio_func *func = priv->ks_sdio_card->func;
+	int ret;
+
+	sdio_writeb(func, byte, address, &ret);
+
+	return ret;
+}
+
+/* Write length bytes to device address from buffer (CMD53) */
+static int ks7010_sdio_write(struct ks_wlan_private *priv, unsigned int address,
+			     unsigned char *buffer, int length)
+{
+	struct sdio_func *func = priv->ks_sdio_card->func;
+
+	return sdio_memcpy_toio(func, address, buffer, length);
+}
+
+static void ks_wlan_hw_sleep_doze_request(struct ks_wlan_private *priv)
+{
+	int ret;
+
+	DPRINTK(4, "\n");
+
+	/* clear request */
+	atomic_set(&priv->sleepstatus.doze_request, 0);
+
+	if (atomic_read(&priv->sleepstatus.status) == 0) {
+		ret = ks7010_sdio_writeb(priv, GCR_B, GCR_B_DOZE);
+		if (ret) {
+			DPRINTK(1, " error : GCR_B\n");
+			goto set_sleep_mode;
+		}
+		DPRINTK(3, "sleep_mode=SLP_SLEEP\n");
+		atomic_set(&priv->sleepstatus.status, 1);
+		priv->last_doze = jiffies;
+	} else {
+		DPRINTK(1, "sleep_mode=%d\n", priv->sleep_mode);
+	}
+
+set_sleep_mode:
+	priv->sleep_mode = atomic_read(&priv->sleepstatus.status);
+}
+
+static void ks_wlan_hw_sleep_wakeup_request(struct ks_wlan_private *priv)
+{
+	int ret;
+
+	DPRINTK(4, "\n");
+
+	/* clear request */
+	atomic_set(&priv->sleepstatus.wakeup_request, 0);
+
+	if (atomic_read(&priv->sleepstatus.status) == 1) {
+		ret = ks7010_sdio_writeb(priv, WAKEUP, WAKEUP_REQ);
+		if (ret) {
+			DPRINTK(1, " error : WAKEUP\n");
+			goto set_sleep_mode;
+		}
+		DPRINTK(4, "wake up : WAKEUP\n");
+		atomic_set(&priv->sleepstatus.status, 0);
+		priv->last_wakeup = jiffies;
+		++priv->wakeup_count;
+	} else {
+		DPRINTK(1, "sleep_mode=%d\n", priv->sleep_mode);
+	}
+
+set_sleep_mode:
+	priv->sleep_mode = atomic_read(&priv->sleepstatus.status);
+}
+
+void ks_wlan_hw_wakeup_request(struct ks_wlan_private *priv)
+{
+	int ret;
+
+	DPRINTK(4, "\n");
+	if (atomic_read(&priv->psstatus.status) == PS_SNOOZE) {
+		ret = ks7010_sdio_writeb(priv, WAKEUP, WAKEUP_REQ);
+		if (ret)
+			DPRINTK(1, " error : WAKEUP\n");
+		else
+			DPRINTK(4, "wake up : WAKEUP\n");
+
+		priv->last_wakeup = jiffies;
+		++priv->wakeup_count;
+	} else {
+		DPRINTK(1, "psstatus=%d\n",
+			atomic_read(&priv->psstatus.status));
+	}
+}
+
+static void _ks_wlan_hw_power_save(struct ks_wlan_private *priv)
+{
+	unsigned char byte;
+	int ret;
+
+	if (priv->reg.power_mgmt == POWER_MGMT_ACTIVE)
+		return;
+
+	if (priv->reg.operation_mode != MODE_INFRASTRUCTURE)
+		return;
+
+	if (!is_connect_status(priv->connect_status))
+		return;
+
+	if (priv->dev_state != DEVICE_STATE_SLEEP)
+		return;
+
+	if (atomic_read(&priv->psstatus.status) == PS_SNOOZE)
+		return;
+
+	DPRINTK(5, "\npsstatus.status=%d\npsstatus.confirm_wait=%d\npsstatus.snooze_guard=%d\ncnt_txqbody=%d\n",
+		atomic_read(&priv->psstatus.status),
+		atomic_read(&priv->psstatus.confirm_wait),
+		atomic_read(&priv->psstatus.snooze_guard),
+		cnt_txqbody(priv));
+
+	if (atomic_read(&priv->psstatus.confirm_wait) ||
+	    atomic_read(&priv->psstatus.snooze_guard) ||
+	    cnt_txqbody(priv)) {
+		queue_delayed_work(priv->wq, &priv->rw_dwork, 0);
+		return;
+	}
+
+	ret = ks7010_sdio_readb(priv, INT_PENDING, &byte);
+	if (ret) {
+		DPRINTK(1, " error : INT_PENDING\n");
+		goto queue_delayed_work;
+	}
+	if (byte)
+		goto queue_delayed_work;
+
+	ret = ks7010_sdio_writeb(priv, GCR_B, GCR_B_DOZE);
+	if (ret) {
+		DPRINTK(1, " error : GCR_B\n");
+		goto queue_delayed_work;
+	}
+	atomic_set(&priv->psstatus.status, PS_SNOOZE);
+	DPRINTK(3, "psstatus.status=PS_SNOOZE\n");
+
+	return;
+
+queue_delayed_work:
+	queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
+}
+
+int ks_wlan_hw_power_save(struct ks_wlan_private *priv)
+{
+	queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
+	return 0;
+}
+
+static int enqueue_txdev(struct ks_wlan_private *priv, unsigned char *p,
+			 unsigned long size,
+			 void (*complete_handler)(struct ks_wlan_private *priv,
+						  struct sk_buff *skb),
+			 struct sk_buff *skb)
+{
+	struct tx_device_buffer *sp;
+	int ret;
+
+	if (priv->dev_state < DEVICE_STATE_BOOT) {
+		ret = -EPERM;
+		goto err_complete;
+	}
+
+	if ((TX_DEVICE_BUFF_SIZE - 1) <= cnt_txqbody(priv)) {
+		DPRINTK(1, "tx buffer overflow\n");
+		ret = -EOVERFLOW;
+		goto err_complete;
+	}
+
+	sp = &priv->tx_dev.tx_dev_buff[priv->tx_dev.qtail];
+	sp->sendp = p;
+	sp->size = size;
+	sp->complete_handler = complete_handler;
+	sp->skb = skb;
+	inc_txqtail(priv);
+
+	return 0;
+
+err_complete:
+	kfree(p);
+	if (complete_handler)
+		(*complete_handler)(priv, skb);
+
+	return ret;
+}
+
+/* write data */
+static int write_to_device(struct ks_wlan_private *priv, unsigned char *buffer,
+			   unsigned long size)
+{
+	struct hostif_hdr *hdr;
+	int ret;
+
+	hdr = (struct hostif_hdr *)buffer;
+
+	DPRINTK(4, "size=%d\n", hdr->size);
+	if (hdr->event < HIF_DATA_REQ || HIF_REQ_MAX < hdr->event) {
+		DPRINTK(1, "unknown event=%04X\n", hdr->event);
+		return 0;
+	}
+
+	ret = ks7010_sdio_write(priv, DATA_WINDOW, buffer, size);
+	if (ret) {
+		DPRINTK(1, " write error : retval=%d\n", ret);
+		return ret;
+	}
+
+	ret = ks7010_sdio_writeb(priv, WRITE_STATUS, REG_STATUS_BUSY);
+	if (ret) {
+		DPRINTK(1, " error : WRITE_STATUS\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void tx_device_task(struct ks_wlan_private *priv)
+{
+	struct tx_device_buffer *sp;
+	int ret;
+
+	DPRINTK(4, "\n");
+	if (cnt_txqbody(priv) <= 0 ||
+	    atomic_read(&priv->psstatus.status) == PS_SNOOZE)
+		return;
+
+	sp = &priv->tx_dev.tx_dev_buff[priv->tx_dev.qhead];
+	if (priv->dev_state >= DEVICE_STATE_BOOT) {
+		ret = write_to_device(priv, sp->sendp, sp->size);
+		if (ret) {
+			DPRINTK(1, "write_to_device error !!(%d)\n", ret);
+			queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
+			return;
+		}
+	}
+	kfree(sp->sendp);
+	if (sp->complete_handler)	/* TX Complete */
+		(*sp->complete_handler)(priv, sp->skb);
+	inc_txqhead(priv);
+
+	if (cnt_txqbody(priv) > 0)
+		queue_delayed_work(priv->wq, &priv->rw_dwork, 0);
+}
+
+int ks_wlan_hw_tx(struct ks_wlan_private *priv, void *p, unsigned long size,
+		  void (*complete_handler)(struct ks_wlan_private *priv,
+					   struct sk_buff *skb),
+		  struct sk_buff *skb)
+{
+	int result = 0;
+	struct hostif_hdr *hdr;
+
+	hdr = (struct hostif_hdr *)p;
+
+	if (hdr->event < HIF_DATA_REQ || HIF_REQ_MAX < hdr->event) {
+		DPRINTK(1, "unknown event=%04X\n", hdr->event);
+		return 0;
+	}
+
+	/* add event to hostt buffer */
+	priv->hostt.buff[priv->hostt.qtail] = hdr->event;
+	priv->hostt.qtail = (priv->hostt.qtail + 1) % SME_EVENT_BUFF_SIZE;
+
+	DPRINTK(4, "event=%04X\n", hdr->event);
+	spin_lock(&priv->tx_dev.tx_dev_lock);
+	result = enqueue_txdev(priv, p, size, complete_handler, skb);
+	spin_unlock(&priv->tx_dev.tx_dev_lock);
+
+	if (cnt_txqbody(priv) > 0)
+		queue_delayed_work(priv->wq, &priv->rw_dwork, 0);
+
+	return result;
+}
+
+static void rx_event_task(unsigned long dev)
+{
+	struct ks_wlan_private *priv = (struct ks_wlan_private *)dev;
+	struct rx_device_buffer *rp;
+
+	DPRINTK(4, "\n");
+
+	if (cnt_rxqbody(priv) > 0 && priv->dev_state >= DEVICE_STATE_BOOT) {
+		rp = &priv->rx_dev.rx_dev_buff[priv->rx_dev.qhead];
+		hostif_receive(priv, rp->data, rp->size);
+		inc_rxqhead(priv);
+
+		if (cnt_rxqbody(priv) > 0)
+			tasklet_schedule(&priv->rx_bh_task);
+	}
+}
+
+static void ks_wlan_hw_rx(struct ks_wlan_private *priv, uint16_t size)
+{
+	int ret;
+	struct rx_device_buffer *rx_buffer;
+	struct hostif_hdr *hdr;
+	unsigned short event = 0;
+
+	DPRINTK(4, "\n");
+
+	/* receive data */
+	if (cnt_rxqbody(priv) >= (RX_DEVICE_BUFF_SIZE - 1)) {
+		DPRINTK(1, "rx buffer overflow\n");
+		return;
+	}
+	rx_buffer = &priv->rx_dev.rx_dev_buff[priv->rx_dev.qtail];
+
+	ret = ks7010_sdio_read(priv, DATA_WINDOW, &rx_buffer->data[0],
+			       hif_align_size(size));
+	if (ret)
+		return;
+
+	/* length check */
+	if (size > 2046 || size == 0) {
+#ifdef KS_WLAN_DEBUG
+		if (KS_WLAN_DEBUG > 5)
+			print_hex_dump_bytes("INVALID DATA dump: ",
+					     DUMP_PREFIX_OFFSET,
+					     rx_buffer->data, 32);
+#endif
+		ret = ks7010_sdio_writeb(priv, READ_STATUS, REG_STATUS_IDLE);
+		if (ret)
+			DPRINTK(1, " error : READ_STATUS\n");
+
+		/* length check fail */
+		return;
+	}
+
+	hdr = (struct hostif_hdr *)&rx_buffer->data[0];
+	rx_buffer->size = le16_to_cpu(hdr->size) + sizeof(hdr->size);
+	event = hdr->event;
+	inc_rxqtail(priv);
+
+	ret = ks7010_sdio_writeb(priv, READ_STATUS, REG_STATUS_IDLE);
+	if (ret)
+		DPRINTK(1, " error : READ_STATUS\n");
+
+	if (atomic_read(&priv->psstatus.confirm_wait)) {
+		if (IS_HIF_CONF(event)) {
+			DPRINTK(4, "IS_HIF_CONF true !!\n");
+			atomic_dec(&priv->psstatus.confirm_wait);
+		}
+	}
+
+	tasklet_schedule(&priv->rx_bh_task);
+}
+
+static void ks7010_rw_function(struct work_struct *work)
+{
+	struct ks_wlan_private *priv;
+	unsigned char byte;
+	int ret;
+
+	priv = container_of(work, struct ks_wlan_private, rw_dwork.work);
+
+	DPRINTK(4, "\n");
+
+	/* wait after DOZE */
+	if (time_after(priv->last_doze + ((30 * HZ) / 1000), jiffies)) {
+		DPRINTK(4, "wait after DOZE\n");
+		queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
+		return;
+	}
+
+	/* wait after WAKEUP */
+	while (time_after(priv->last_wakeup + ((30 * HZ) / 1000), jiffies)) {
+		DPRINTK(4, "wait after WAKEUP\n");
+		dev_info(&priv->ks_sdio_card->func->dev,
+			 "wake: %lu %lu\n",
+			 priv->last_wakeup + (30 * HZ) / 1000,
+				jiffies);
+		msleep(30);
+	}
+
+	sdio_claim_host(priv->ks_sdio_card->func);
+
+	/* power save wakeup */
+	if (atomic_read(&priv->psstatus.status) == PS_SNOOZE) {
+		if (cnt_txqbody(priv) > 0) {
+			ks_wlan_hw_wakeup_request(priv);
+			queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
+		}
+		goto release_host;
+	}
+
+	/* sleep mode doze */
+	if (atomic_read(&priv->sleepstatus.doze_request) == 1) {
+		ks_wlan_hw_sleep_doze_request(priv);
+		goto release_host;
+	}
+	/* sleep mode wakeup */
+	if (atomic_read(&priv->sleepstatus.wakeup_request) == 1) {
+		ks_wlan_hw_sleep_wakeup_request(priv);
+		goto release_host;
+	}
+
+	/* read (WriteStatus/ReadDataSize FN1:00_0014) */
+	ret = ks7010_sdio_readb(priv, WSTATUS_RSIZE, &byte);
+	if (ret) {
+		DPRINTK(1, " error : WSTATUS_RSIZE psstatus=%d\n",
+			atomic_read(&priv->psstatus.status));
+		goto release_host;
+	}
+	DPRINTK(4, "WSTATUS_RSIZE=%02X\n", byte);
+
+	if (byte & RSIZE_MASK) {	/* Read schedule */
+		ks_wlan_hw_rx(priv, (uint16_t)((byte & RSIZE_MASK) << 4));
+	}
+	if ((byte & WSTATUS_MASK))
+		tx_device_task(priv);
+
+	_ks_wlan_hw_power_save(priv);
+
+release_host:
+	sdio_release_host(priv->ks_sdio_card->func);
+}
+
+static void ks_sdio_interrupt(struct sdio_func *func)
+{
+	int ret;
+	struct ks_sdio_card *card;
+	struct ks_wlan_private *priv;
+	unsigned char status, rsize, byte;
+
+	card = sdio_get_drvdata(func);
+	priv = card->priv;
+	DPRINTK(4, "\n");
+
+	if (priv->dev_state < DEVICE_STATE_BOOT)
+		goto queue_delayed_work;
+
+	ret = ks7010_sdio_readb(priv, INT_PENDING, &status);
+	if (ret) {
+		DPRINTK(1, "error : INT_PENDING\n");
+		goto queue_delayed_work;
+	}
+	DPRINTK(4, "INT_PENDING=%02X\n", status);
+
+	/* schedule task for interrupt status */
+	/* bit7 -> Write General Communication B register */
+	/* read (General Communication B register) */
+	/* bit5 -> Write Status Idle */
+	/* bit2 -> Read Status Busy  */
+	if (status & INT_GCR_B ||
+	    atomic_read(&priv->psstatus.status) == PS_SNOOZE) {
+		ret = ks7010_sdio_readb(priv, GCR_B, &byte);
+		if (ret) {
+			DPRINTK(1, " error : GCR_B\n");
+			goto queue_delayed_work;
+		}
+		if (byte == GCR_B_ACTIVE) {
+			if (atomic_read(&priv->psstatus.status) == PS_SNOOZE) {
+				atomic_set(&priv->psstatus.status, PS_WAKEUP);
+				priv->wakeup_count = 0;
+			}
+			complete(&priv->psstatus.wakeup_wait);
+		}
+	}
+
+	do {
+		/* read (WriteStatus/ReadDataSize FN1:00_0014) */
+		ret = ks7010_sdio_readb(priv, WSTATUS_RSIZE, &byte);
+		if (ret) {
+			DPRINTK(1, " error : WSTATUS_RSIZE\n");
+			goto queue_delayed_work;
+		}
+		DPRINTK(4, "WSTATUS_RSIZE=%02X\n", byte);
+		rsize = byte & RSIZE_MASK;
+		if (rsize != 0)		/* Read schedule */
+			ks_wlan_hw_rx(priv, (uint16_t)(rsize << 4));
+
+		if (byte & WSTATUS_MASK) {
+			if (atomic_read(&priv->psstatus.status) == PS_SNOOZE) {
+				if (cnt_txqbody(priv)) {
+					ks_wlan_hw_wakeup_request(priv);
+					queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
+					return;
+				}
+			} else {
+				tx_device_task(priv);
+			}
+		}
+	} while (rsize);
+
+queue_delayed_work:
+	queue_delayed_work(priv->wq, &priv->rw_dwork, 0);
+}
+
+static int trx_device_init(struct ks_wlan_private *priv)
+{
+	priv->tx_dev.qhead = 0;
+	priv->tx_dev.qtail = 0;
+
+	priv->rx_dev.qhead = 0;
+	priv->rx_dev.qtail = 0;
+
+	spin_lock_init(&priv->tx_dev.tx_dev_lock);
+	spin_lock_init(&priv->rx_dev.rx_dev_lock);
+
+	tasklet_init(&priv->rx_bh_task, rx_event_task, (unsigned long)priv);
+
+	return 0;
+}
+
+static void trx_device_exit(struct ks_wlan_private *priv)
+{
+	struct tx_device_buffer *sp;
+
+	/* tx buffer clear */
+	while (cnt_txqbody(priv) > 0) {
+		sp = &priv->tx_dev.tx_dev_buff[priv->tx_dev.qhead];
+		kfree(sp->sendp);
+		if (sp->complete_handler)	/* TX Complete */
+			(*sp->complete_handler)(priv, sp->skb);
+		inc_txqhead(priv);
+	}
+
+	tasklet_kill(&priv->rx_bh_task);
+}
+
+static int ks7010_sdio_update_index(struct ks_wlan_private *priv, u32 index)
+{
+	int ret;
+	unsigned char *data_buf;
+
+	data_buf = kmalloc(sizeof(u32), GFP_KERNEL);
+	if (!data_buf)
+		return -ENOMEM;
+
+	memcpy(data_buf, &index, sizeof(index));
+	ret = ks7010_sdio_write(priv, WRITE_INDEX, data_buf, sizeof(index));
+	if (ret)
+		goto err_free_data_buf;
+
+	ret = ks7010_sdio_write(priv, READ_INDEX, data_buf, sizeof(index));
+	if (ret)
+		goto err_free_data_buf;
+
+	return 0;
+
+err_free_data_buf:
+	kfree(data_buf);
+
+	return ret;
+}
+
+#define ROM_BUFF_SIZE (64 * 1024)
+static int ks7010_sdio_data_compare(struct ks_wlan_private *priv, u32 address,
+				    unsigned char *data, unsigned int size)
+{
+	int ret;
+	unsigned char *read_buf;
+
+	read_buf = kmalloc(ROM_BUFF_SIZE, GFP_KERNEL);
+	if (!read_buf)
+		return -ENOMEM;
+
+	ret = ks7010_sdio_read(priv, address, read_buf, size);
+	if (ret)
+		goto err_free_read_buf;
+
+	if (memcmp(data, read_buf, size) != 0) {
+		ret = -EIO;
+		DPRINTK(0, "data compare error (%d)\n", ret);
+		goto err_free_read_buf;
+	}
+
+	return 0;
+
+err_free_read_buf:
+	kfree(read_buf);
+
+	return ret;
+}
+
+static int ks7010_upload_firmware(struct ks_sdio_card *card)
+{
+	struct ks_wlan_private *priv = card->priv;
+	unsigned int size, offset, n = 0;
+	unsigned char *rom_buf;
+	unsigned char byte = 0;
+	int ret;
+	unsigned int length;
+	const struct firmware *fw_entry = NULL;
+
+	rom_buf = kmalloc(ROM_BUFF_SIZE, GFP_KERNEL);
+	if (!rom_buf)
+		return -ENOMEM;
+
+	sdio_claim_host(card->func);
+
+	/* Firmware running ? */
+	ret = ks7010_sdio_readb(priv, GCR_A, &byte);
+	if (byte == GCR_A_RUN) {
+		DPRINTK(0, "MAC firmware running ...\n");
+		goto release_host_and_free;
+	}
+
+	ret = request_firmware(&fw_entry, ROM_FILE,
+			       &priv->ks_sdio_card->func->dev);
+	if (ret)
+		goto release_host_and_free;
+
+	length = fw_entry->size;
+
+	n = 0;
+	do {
+		if (length >= ROM_BUFF_SIZE) {
+			size = ROM_BUFF_SIZE;
+			length = length - ROM_BUFF_SIZE;
+		} else {
+			size = length;
+			length = 0;
+		}
+		DPRINTK(4, "size = %d\n", size);
+		if (size == 0)
+			break;
+		memcpy(rom_buf, fw_entry->data + n, size);
+
+		offset = n;
+		ret = ks7010_sdio_update_index(priv, KS7010_IRAM_ADDRESS + offset);
+		if (ret)
+			goto release_firmware;
+
+		ret = ks7010_sdio_write(priv, DATA_WINDOW, rom_buf, size);
+		if (ret)
+			goto release_firmware;
+
+		ret = ks7010_sdio_data_compare(priv, DATA_WINDOW, rom_buf, size);
+		if (ret)
+			goto release_firmware;
+
+		n += size;
+
+	} while (size);
+
+	ret = ks7010_sdio_writeb(priv, GCR_A, GCR_A_REMAP);
+	if (ret)
+		goto release_firmware;
+
+	DPRINTK(4, " REMAP Request : GCR_A\n");
+
+	/* Firmware running check */
+	for (n = 0; n < 50; ++n) {
+		mdelay(10);	/* wait_ms(10); */
+		ret = ks7010_sdio_readb(priv, GCR_A, &byte);
+		if (ret)
+			goto release_firmware;
+
+		if (byte == GCR_A_RUN)
+			break;
+	}
+	DPRINTK(4, "firmware wakeup (%d)!!!!\n", n);
+	if ((50) <= n) {
+		DPRINTK(1, "firmware can't start\n");
+		ret = -EIO;
+		goto release_firmware;
+	}
+
+	ret = 0;
+
+ release_firmware:
+	release_firmware(fw_entry);
+ release_host_and_free:
+	sdio_release_host(card->func);
+	kfree(rom_buf);
+
+	return ret;
+}
+
+static void ks7010_card_init(struct ks_wlan_private *priv)
+{
+	DPRINTK(5, "\ncard_init_task()\n");
+
+	init_completion(&priv->confirm_wait);
+
+	DPRINTK(5, "init_completion()\n");
+
+	/* get mac address & firmware version */
+	hostif_sme_enqueue(priv, SME_START);
+
+	DPRINTK(5, "hostif_sme_enqueu()\n");
+
+	if (!wait_for_completion_interruptible_timeout
+	    (&priv->confirm_wait, 5 * HZ)) {
+		DPRINTK(1, "wait time out!! SME_START\n");
+	}
+
+	if (priv->mac_address_valid && priv->version_size != 0)
+		priv->dev_state = DEVICE_STATE_PREINIT;
+
+	hostif_sme_enqueue(priv, SME_GET_EEPROM_CKSUM);
+
+	/* load initial wireless parameter */
+	hostif_sme_enqueue(priv, SME_STOP_REQUEST);
+
+	hostif_sme_enqueue(priv, SME_RTS_THRESHOLD_REQUEST);
+	hostif_sme_enqueue(priv, SME_FRAGMENTATION_THRESHOLD_REQUEST);
+
+	hostif_sme_enqueue(priv, SME_WEP_INDEX_REQUEST);
+	hostif_sme_enqueue(priv, SME_WEP_KEY1_REQUEST);
+	hostif_sme_enqueue(priv, SME_WEP_KEY2_REQUEST);
+	hostif_sme_enqueue(priv, SME_WEP_KEY3_REQUEST);
+	hostif_sme_enqueue(priv, SME_WEP_KEY4_REQUEST);
+
+	hostif_sme_enqueue(priv, SME_WEP_FLAG_REQUEST);
+	hostif_sme_enqueue(priv, SME_RSN_ENABLED_REQUEST);
+	hostif_sme_enqueue(priv, SME_MODE_SET_REQUEST);
+	hostif_sme_enqueue(priv, SME_START_REQUEST);
+
+	if (!wait_for_completion_interruptible_timeout
+	    (&priv->confirm_wait, 5 * HZ)) {
+		DPRINTK(1, "wait time out!! wireless parameter set\n");
+	}
+
+	if (priv->dev_state >= DEVICE_STATE_PREINIT) {
+		DPRINTK(1, "DEVICE READY!!\n");
+		priv->dev_state = DEVICE_STATE_READY;
+	} else {
+		DPRINTK(1, "dev_state=%d\n", priv->dev_state);
+	}
+}
+
+static void ks7010_init_defaults(struct ks_wlan_private *priv)
+{
+	priv->reg.tx_rate = TX_RATE_AUTO;
+	priv->reg.preamble = LONG_PREAMBLE;
+	priv->reg.power_mgmt = POWER_MGMT_ACTIVE;
+	priv->reg.scan_type = ACTIVE_SCAN;
+	priv->reg.beacon_lost_count = 20;
+	priv->reg.rts = 2347UL;
+	priv->reg.fragment = 2346UL;
+	priv->reg.phy_type = D_11BG_COMPATIBLE_MODE;
+	priv->reg.cts_mode = CTS_MODE_FALSE;
+	priv->reg.rate_set.body[11] = TX_RATE_54M;
+	priv->reg.rate_set.body[10] = TX_RATE_48M;
+	priv->reg.rate_set.body[9] = TX_RATE_36M;
+	priv->reg.rate_set.body[8] = TX_RATE_18M;
+	priv->reg.rate_set.body[7] = TX_RATE_9M;
+	priv->reg.rate_set.body[6] = TX_RATE_24M | BASIC_RATE;
+	priv->reg.rate_set.body[5] = TX_RATE_12M | BASIC_RATE;
+	priv->reg.rate_set.body[4] = TX_RATE_6M | BASIC_RATE;
+	priv->reg.rate_set.body[3] = TX_RATE_11M | BASIC_RATE;
+	priv->reg.rate_set.body[2] = TX_RATE_5M | BASIC_RATE;
+	priv->reg.rate_set.body[1] = TX_RATE_2M | BASIC_RATE;
+	priv->reg.rate_set.body[0] = TX_RATE_1M | BASIC_RATE;
+	priv->reg.tx_rate = TX_RATE_FULL_AUTO;
+	priv->reg.rate_set.size = 12;
+}
+
+static int ks7010_sdio_probe(struct sdio_func *func,
+			     const struct sdio_device_id *device)
+{
+	struct ks_wlan_private *priv;
+	struct ks_sdio_card *card;
+	struct net_device *netdev;
+	unsigned char byte;
+	int ret;
+
+	DPRINTK(5, "ks7010_sdio_probe()\n");
+
+	priv = NULL;
+	netdev = NULL;
+
+	card = kzalloc(sizeof(*card), GFP_KERNEL);
+	if (!card)
+		return -ENOMEM;
+
+	card->func = func;
+
+	sdio_claim_host(func);
+
+	ret = sdio_set_block_size(func, KS7010_IO_BLOCK_SIZE);
+	DPRINTK(5, "multi_block=%d sdio_set_block_size()=%d %d\n",
+		func->card->cccr.multi_block, func->cur_blksize, ret);
+
+	ret = sdio_enable_func(func);
+	DPRINTK(5, "sdio_enable_func() %d\n", ret);
+	if (ret)
+		goto err_free_card;
+
+	/* interrupt disable */
+	sdio_writeb(func, 0, INT_ENABLE, &ret);
+	if (ret)
+		goto err_free_card;
+	sdio_writeb(func, 0xff, INT_PENDING, &ret);
+	if (ret)
+		goto err_disable_func;
+
+	/* setup interrupt handler */
+	ret = sdio_claim_irq(func, ks_sdio_interrupt);
+	if (ret)
+		goto err_disable_func;
+
+	sdio_release_host(func);
+
+	sdio_set_drvdata(func, card);
+
+	DPRINTK(5, "class = 0x%X, vendor = 0x%X, device = 0x%X\n",
+		func->class, func->vendor, func->device);
+
+	/* private memory allocate */
+	netdev = alloc_etherdev(sizeof(*priv));
+	if (!netdev) {
+		dev_err(&card->func->dev, "ks7010 : Unable to alloc new net device\n");
+		goto err_release_irq;
+	}
+	if (dev_alloc_name(netdev, "wlan%d") < 0) {
+		dev_err(&card->func->dev,
+			"ks7010 :  Couldn't get name!\n");
+		goto err_free_netdev;
+	}
+
+	priv = netdev_priv(netdev);
+
+	card->priv = priv;
+	SET_NETDEV_DEV(netdev, &card->func->dev);	/* for create sysfs symlinks */
+
+	/* private memory initialize */
+	priv->ks_sdio_card = card;
+
+	priv->dev_state = DEVICE_STATE_PREBOOT;
+	priv->net_dev = netdev;
+	priv->firmware_version[0] = '\0';
+	priv->version_size = 0;
+	priv->last_doze = jiffies;
+	priv->last_wakeup = jiffies;
+	memset(&priv->nstats, 0, sizeof(priv->nstats));
+	memset(&priv->wstats, 0, sizeof(priv->wstats));
+
+	/* sleep mode */
+	atomic_set(&priv->sleepstatus.doze_request, 0);
+	atomic_set(&priv->sleepstatus.wakeup_request, 0);
+	atomic_set(&priv->sleepstatus.wakeup_request, 0);
+
+	trx_device_init(priv);
+	hostif_init(priv);
+	ks_wlan_net_start(netdev);
+
+	ks7010_init_defaults(priv);
+
+	ret = ks7010_upload_firmware(card);
+	if (ret) {
+		dev_err(&card->func->dev,
+			"ks7010: firmware load failed !! return code = %d\n",
+			 ret);
+		goto err_free_netdev;
+	}
+
+	/* interrupt setting */
+	/* clear Interrupt status write (ARMtoSD_InterruptPending FN1:00_0024) */
+	sdio_claim_host(func);
+	ret = ks7010_sdio_writeb(priv, INT_PENDING, 0xff);
+	sdio_release_host(func);
+	if (ret)
+		DPRINTK(1, " error : INT_PENDING\n");
+
+	/* enable ks7010sdio interrupt */
+	byte = (INT_GCR_B | INT_READ_STATUS | INT_WRITE_STATUS);
+	sdio_claim_host(func);
+	ret = ks7010_sdio_writeb(priv, INT_ENABLE, byte);
+	sdio_release_host(func);
+	if (ret)
+		DPRINTK(1, " err : INT_ENABLE\n");
+
+	DPRINTK(4, " enable Interrupt : INT_ENABLE=%02X\n", byte);
+	priv->dev_state = DEVICE_STATE_BOOT;
+
+	priv->wq = create_workqueue("wq");
+	if (!priv->wq) {
+		DPRINTK(1, "create_workqueue failed !!\n");
+		goto err_free_netdev;
+	}
+
+	INIT_DELAYED_WORK(&priv->rw_dwork, ks7010_rw_function);
+	ks7010_card_init(priv);
+
+	ret = register_netdev(priv->net_dev);
+	if (ret)
+		goto err_free_netdev;
+
+	return 0;
+
+ err_free_netdev:
+	free_netdev(priv->net_dev);
+	card->priv = NULL;
+ err_release_irq:
+	sdio_claim_host(func);
+	sdio_release_irq(func);
+ err_disable_func:
+	sdio_disable_func(func);
+ err_free_card:
+	sdio_release_host(func);
+	sdio_set_drvdata(func, NULL);
+	kfree(card);
+
+	return -ENODEV;
+}
+
+/* send stop request to MAC */
+static int send_stop_request(struct sdio_func *func)
+{
+	struct hostif_stop_request_t *pp;
+	struct ks_sdio_card *card;
+	size_t size;
+
+	card = sdio_get_drvdata(func);
+
+	pp = kzalloc(hif_align_size(sizeof(*pp)), GFP_KERNEL);
+	if (!pp) {
+		DPRINTK(3, "allocate memory failed..\n");
+		return -ENOMEM;
+	}
+
+	size = sizeof(*pp) - sizeof(pp->header.size);
+	pp->header.size = cpu_to_le16((uint16_t)size);
+	pp->header.event = cpu_to_le16((uint16_t)HIF_STOP_REQ);
+
+	sdio_claim_host(func);
+	write_to_device(card->priv, (unsigned char *)pp,
+			hif_align_size(sizeof(*pp)));
+	sdio_release_host(func);
+
+	kfree(pp);
+	return 0;
+}
+
+static void ks7010_sdio_remove(struct sdio_func *func)
+{
+	int ret;
+	struct ks_sdio_card *card;
+	struct ks_wlan_private *priv;
+
+	DPRINTK(1, "ks7010_sdio_remove()\n");
+
+	card = sdio_get_drvdata(func);
+
+	if (!card)
+		return;
+
+	DPRINTK(1, "priv = card->priv\n");
+	priv = card->priv;
+	if (priv) {
+		struct net_device *netdev = priv->net_dev;
+
+		ks_wlan_net_stop(netdev);
+		DPRINTK(1, "ks_wlan_net_stop\n");
+
+		/* interrupt disable */
+		sdio_claim_host(func);
+		sdio_writeb(func, 0, INT_ENABLE, &ret);
+		sdio_writeb(func, 0xff, INT_PENDING, &ret);
+		sdio_release_host(func);
+		DPRINTK(1, "interrupt disable\n");
+
+		ret = send_stop_request(func);
+		if (ret)	/* memory allocation failure */
+			return;
+
+		DPRINTK(1, "STOP Req\n");
+
+		if (priv->wq) {
+			flush_workqueue(priv->wq);
+			destroy_workqueue(priv->wq);
+		}
+		DPRINTK(1, "destroy_workqueue(priv->wq);\n");
+
+		hostif_exit(priv);
+		DPRINTK(1, "hostif_exit\n");
+
+		unregister_netdev(netdev);
+
+		trx_device_exit(priv);
+		free_netdev(priv->net_dev);
+		card->priv = NULL;
+	}
+
+	sdio_claim_host(func);
+	sdio_release_irq(func);
+	DPRINTK(1, "sdio_release_irq()\n");
+	sdio_disable_func(func);
+	DPRINTK(1, "sdio_disable_func()\n");
+	sdio_release_host(func);
+
+	sdio_set_drvdata(func, NULL);
+
+	kfree(card);
+	DPRINTK(1, "kfree()\n");
+
+	DPRINTK(5, " Bye !!\n");
+}
+
+static struct sdio_driver ks7010_sdio_driver = {
+	.name = "ks7010_sdio",
+	.id_table = ks7010_sdio_ids,
+	.probe = ks7010_sdio_probe,
+	.remove = ks7010_sdio_remove,
+};
+
+module_driver(ks7010_sdio_driver, sdio_register_driver, sdio_unregister_driver);
+MODULE_AUTHOR("Sang Engineering, Qi-Hardware, KeyStream");
+MODULE_DESCRIPTION("Driver for KeyStream KS7010 based SDIO cards");
+MODULE_LICENSE("GPL v2");
+MODULE_FIRMWARE(ROM_FILE);
diff --git a/drivers/staging/ks7010/wext/ks7010_sdio.h b/drivers/staging/ks7010/wext/ks7010_sdio.h
new file mode 100644
index 0000000..e4f56a1
--- /dev/null
+++ b/drivers/staging/ks7010/wext/ks7010_sdio.h
@@ -0,0 +1,164 @@
+/*
+ *   Driver for KeyStream, KS7010 based SDIO cards.
+ *
+ *   Copyright (C) 2006-2008 KeyStream Corp.
+ *   Copyright (C) 2009 Renesas Technology Corp.
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License version 2 as
+ *   published by the Free Software Foundation.
+ */
+#ifndef _KS7010_SDIO_H
+#define _KS7010_SDIO_H
+
+#ifdef	DEVICE_ALIGNMENT
+#undef	DEVICE_ALIGNMENT
+#endif
+#define DEVICE_ALIGNMENT 32
+
+/*  SDIO KeyStream vendor and device */
+#define SDIO_VENDOR_ID_KS_CODE_A	0x005b
+#define SDIO_VENDOR_ID_KS_CODE_B	0x0023
+/* Older sources suggest earlier versions were named 7910 or 79xx */
+#define SDIO_DEVICE_ID_KS_7010		0x7910
+
+/* Read/Write Status Register */
+#define READ_STATUS		0x000000
+#define WRITE_STATUS		0x00000C
+enum reg_status_type {
+	REG_STATUS_BUSY,
+	REG_STATUS_IDLE
+};
+
+/* Read Index Register */
+#define READ_INDEX		0x000004
+
+/* Read Data Size Register */
+#define READ_DATA_SIZE		0x000008
+
+/* Write Index Register */
+#define WRITE_INDEX		0x000010
+
+/* Write Status/Read Data Size Register
+ * for network packet (less than 2048 bytes data)
+ */
+#define WSTATUS_RSIZE		0x000014
+#define WSTATUS_MASK		0x80	/* Write Status Register value */
+#define RSIZE_MASK		0x7F	/* Read Data Size Register value [10:4] */
+
+/* ARM to SD interrupt Enable */
+#define INT_ENABLE		0x000020
+/* ARM to SD interrupt Pending */
+#define INT_PENDING		0x000024
+
+#define INT_GCR_B              BIT(7)
+#define INT_GCR_A              BIT(6)
+#define INT_WRITE_STATUS       BIT(5)
+#define INT_WRITE_INDEX        BIT(4)
+#define INT_WRITE_SIZE         BIT(3)
+#define INT_READ_STATUS        BIT(2)
+#define INT_READ_INDEX         BIT(1)
+#define INT_READ_SIZE          BIT(0)
+
+/* General Communication Register A */
+#define GCR_A			0x000028
+enum gen_com_reg_a {
+	GCR_A_INIT,
+	GCR_A_REMAP,
+	GCR_A_RUN
+};
+
+/* General Communication Register B */
+#define GCR_B			0x00002C
+enum gen_com_reg_b {
+	GCR_B_ACTIVE,
+	GCR_B_DOZE
+};
+
+/* Wakeup Register */
+#define WAKEUP			0x008018
+#define WAKEUP_REQ		0x5a
+
+/* AHB Data Window  0x010000-0x01FFFF */
+#define DATA_WINDOW		0x010000
+#define WINDOW_SIZE		(64 * 1024)
+
+#define KS7010_IRAM_ADDRESS	0x06000000
+
+/**
+ * struct ks_sdio_card - SDIO device data.
+ *
+ * Structure is used as the &struct sdio_func private data.
+ *
+ * @func: Pointer to the SDIO function device.
+ * @priv: Pointer to the &struct net_device private data.
+ */
+struct ks_sdio_card {
+	struct sdio_func *func;
+	struct ks_wlan_private *priv;
+};
+
+/* Tx Device struct */
+#define	TX_DEVICE_BUFF_SIZE	1024
+
+/**
+ * struct tx_device_buffer - Queue item for the tx queue.
+ * @sendp: Pointer to the send request data.
+ * @size: Size of @sendp data.
+ * @complete_handler: Function called once data write to device is complete.
+ * @arg1: First argument to @complete_handler.
+ * @arg2: Second argument to @complete_handler.
+ */
+struct tx_device_buffer {
+	unsigned char *sendp;
+	unsigned int size;
+	void (*complete_handler)(struct ks_wlan_private *priv,
+				 struct sk_buff *skb);
+	struct sk_buff *skb;
+};
+
+/**
+ * struct tx_device - Tx buffer queue.
+ * @tx_device_buffer: Queue buffer.
+ * @qhead: Head of tx queue.
+ * @qtail: Tail of tx queue.
+ * @tx_dev_lock: Queue lock.
+ */
+struct tx_device {
+	struct tx_device_buffer tx_dev_buff[TX_DEVICE_BUFF_SIZE];
+	unsigned int qhead;
+	unsigned int qtail;
+	spinlock_t tx_dev_lock;	/* protect access to the queue */
+};
+
+/* Rx Device struct */
+#define	RX_DATA_SIZE	(2 + 2 + 2347 + 1)
+#define	RX_DEVICE_BUFF_SIZE	32
+
+/**
+ * struct rx_device_buffer - Queue item for the rx queue.
+ * @data: rx data.
+ * @size: Size of @data.
+ */
+struct rx_device_buffer {
+	unsigned char data[RX_DATA_SIZE];
+	unsigned int size;
+};
+
+/**
+ * struct rx_device - Rx buffer queue.
+ * @rx_device_buffer: Queue buffer.
+ * @qhead: Head of rx queue.
+ * @qtail: Tail of rx queue.
+ * @rx_dev_lock: Queue lock.
+ */
+struct rx_device {
+	struct rx_device_buffer rx_dev_buff[RX_DEVICE_BUFF_SIZE];
+	unsigned int qhead;
+	unsigned int qtail;
+	spinlock_t rx_dev_lock;	/* protect access to the queue */
+};
+
+#define	ROM_FILE "ks7010sd.rom"
+
+#endif /* _KS7010_SDIO_H */
diff --git a/drivers/staging/ks7010/wext/ks_hostif.c b/drivers/staging/ks7010/wext/ks_hostif.c
new file mode 100644
index 0000000..49e9542
--- /dev/null
+++ b/drivers/staging/ks7010/wext/ks_hostif.c
@@ -0,0 +1,2638 @@
+/*
+ *   Driver for KeyStream wireless LAN cards.
+ *
+ *   Copyright (C) 2005-2008 KeyStream Corp.
+ *   Copyright (C) 2009 Renesas Technology Corp.
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License version 2 as
+ *   published by the Free Software Foundation.
+ */
+
+#include "ks_wlan.h"
+#include "ks_hostif.h"
+#include "eap_packet.h"
+#include "michael_mic.h"
+
+#include <linux/etherdevice.h>
+#include <linux/if_ether.h>
+#include <linux/if_arp.h>
+
+/* Include Wireless Extension definition and check version */
+#include <net/iw_handler.h>	/* New driver API */
+
+/* macro */
+#define inc_smeqhead(priv) \
+	(priv->sme_i.qhead = (priv->sme_i.qhead + 1) % SME_EVENT_BUFF_SIZE)
+#define inc_smeqtail(priv) \
+	(priv->sme_i.qtail = (priv->sme_i.qtail + 1) % SME_EVENT_BUFF_SIZE)
+#define cnt_smeqbody(priv) \
+	(((priv->sme_i.qtail + SME_EVENT_BUFF_SIZE) - (priv->sme_i.qhead)) % SME_EVENT_BUFF_SIZE)
+
+#define KS_WLAN_MEM_FLAG (GFP_ATOMIC)
+
+static
+inline u8 get_BYTE(struct ks_wlan_private *priv)
+{
+	u8 data;
+
+	data = *(priv->rxp)++;
+	/* length check in advance ! */
+	--(priv->rx_size);
+	return data;
+}
+
+static
+inline u16 get_WORD(struct ks_wlan_private *priv)
+{
+	u16 data;
+
+	data = (get_BYTE(priv) & 0xff);
+	data |= ((get_BYTE(priv) << 8) & 0xff00);
+	return data;
+}
+
+static
+inline u32 get_DWORD(struct ks_wlan_private *priv)
+{
+	u32 data;
+
+	data = (get_BYTE(priv) & 0xff);
+	data |= ((get_BYTE(priv) << 8) & 0x0000ff00);
+	data |= ((get_BYTE(priv) << 16) & 0x00ff0000);
+	data |= ((get_BYTE(priv) << 24) & 0xff000000);
+	return data;
+}
+
+static void ks_wlan_hw_wakeup_task(struct work_struct *work)
+{
+	struct ks_wlan_private *priv;
+	int ps_status;
+	long time_left;
+
+	priv = container_of(work, struct ks_wlan_private, wakeup_work);
+	ps_status = atomic_read(&priv->psstatus.status);
+
+	if (ps_status == PS_SNOOZE) {
+		ks_wlan_hw_wakeup_request(priv);
+		time_left = wait_for_completion_interruptible_timeout(
+				&priv->psstatus.wakeup_wait,
+				msecs_to_jiffies(20));
+		if (time_left <= 0) {
+			DPRINTK(1, "wake up timeout or interrupted !!!\n");
+			schedule_work(&priv->wakeup_work);
+			return;
+		}
+	} else {
+		DPRINTK(1, "ps_status=%d\n", ps_status);
+	}
+
+	/* power save */
+	if (atomic_read(&priv->sme_task.count) > 0) {
+		DPRINTK(4, "sme task enable.\n");
+		tasklet_enable(&priv->sme_task);
+	}
+}
+
+static
+int ks_wlan_do_power_save(struct ks_wlan_private *priv)
+{
+	DPRINTK(4, "psstatus.status=%d\n", atomic_read(&priv->psstatus.status));
+
+	if (is_connect_status(priv->connect_status))
+		hostif_sme_enqueue(priv, SME_POW_MNGMT_REQUEST);
+	else
+		priv->dev_state = DEVICE_STATE_READY;
+	return 0;
+}
+
+static
+int get_current_ap(struct ks_wlan_private *priv, struct link_ap_info_t *ap_info)
+{
+	struct local_ap_t *ap;
+	union iwreq_data wrqu;
+	struct net_device *netdev = priv->net_dev;
+
+	DPRINTK(3, "\n");
+	ap = &priv->current_ap;
+
+	if (is_disconnect_status(priv->connect_status)) {
+		memset(ap, 0, sizeof(struct local_ap_t));
+		return -EPERM;
+	}
+
+	/* bssid */
+	memcpy(ap->bssid, ap_info->bssid, ETH_ALEN);
+	/* essid */
+	memcpy(ap->ssid.body, priv->reg.ssid.body,
+	       priv->reg.ssid.size);
+	ap->ssid.size = priv->reg.ssid.size;
+	/* rate_set */
+	memcpy(ap->rate_set.body, ap_info->rate_set.body,
+	       ap_info->rate_set.size);
+	ap->rate_set.size = ap_info->rate_set.size;
+	if (ap_info->ext_rate_set.size != 0) {
+		/* rate_set */
+		memcpy(&ap->rate_set.body[ap->rate_set.size],
+		       ap_info->ext_rate_set.body,
+		       ap_info->ext_rate_set.size);
+		ap->rate_set.size += ap_info->ext_rate_set.size;
+	}
+	/* channel */
+	ap->channel = ap_info->ds_parameter.channel;
+	/* rssi */
+	ap->rssi = ap_info->rssi;
+	/* sq */
+	ap->sq = ap_info->sq;
+	/* noise */
+	ap->noise = ap_info->noise;
+	/* capability */
+	ap->capability = ap_info->capability;
+	/* rsn */
+	if ((ap_info->rsn_mode & RSN_MODE_WPA2) &&
+	    (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)) {
+		ap->rsn_ie.id = 0x30;
+		if (ap_info->rsn.size <= RSN_IE_BODY_MAX) {
+			ap->rsn_ie.size = ap_info->rsn.size;
+			memcpy(ap->rsn_ie.body, ap_info->rsn.body,
+			       ap_info->rsn.size);
+		} else {
+			ap->rsn_ie.size = RSN_IE_BODY_MAX;
+			memcpy(ap->rsn_ie.body, ap_info->rsn.body,
+			       RSN_IE_BODY_MAX);
+		}
+	} else if ((ap_info->rsn_mode & RSN_MODE_WPA) &&
+		   (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA)) {
+		ap->wpa_ie.id = 0xdd;
+		if (ap_info->rsn.size <= RSN_IE_BODY_MAX) {
+			ap->wpa_ie.size = ap_info->rsn.size;
+			memcpy(ap->wpa_ie.body, ap_info->rsn.body,
+			       ap_info->rsn.size);
+		} else {
+			ap->wpa_ie.size = RSN_IE_BODY_MAX;
+			memcpy(ap->wpa_ie.body, ap_info->rsn.body,
+			       RSN_IE_BODY_MAX);
+		}
+	} else {
+		ap->rsn_ie.id = 0;
+		ap->rsn_ie.size = 0;
+		ap->wpa_ie.id = 0;
+		ap->wpa_ie.size = 0;
+	}
+
+	wrqu.data.length = 0;
+	wrqu.data.flags = 0;
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	if (is_connect_status(priv->connect_status)) {
+		memcpy(wrqu.ap_addr.sa_data,
+		       priv->current_ap.bssid, ETH_ALEN);
+		DPRINTK(3,
+			"IWEVENT: connect bssid=%pM\n", wrqu.ap_addr.sa_data);
+		wireless_send_event(netdev, SIOCGIWAP, &wrqu, NULL);
+	}
+	DPRINTK(4, "\n    Link AP\n");
+	DPRINTK(4, "    bssid=%02X:%02X:%02X:%02X:%02X:%02X\n"
+		   "    essid=%s\n"
+		   "    rate_set=%02X,%02X,%02X,%02X,%02X,%02X,%02X,%02X\n"
+		   "    channel=%d\n"
+		   "    rssi=%d\n"
+		   "    sq=%d\n"
+		   "    capability=%04X\n",
+		ap->bssid[0], ap->bssid[1], ap->bssid[2],
+		ap->bssid[3], ap->bssid[4], ap->bssid[5],
+		&(ap->ssid.body[0]),
+		ap->rate_set.body[0], ap->rate_set.body[1],
+		ap->rate_set.body[2], ap->rate_set.body[3],
+		ap->rate_set.body[4], ap->rate_set.body[5],
+		ap->rate_set.body[6], ap->rate_set.body[7],
+		ap->channel, ap->rssi, ap->sq, ap->capability);
+	DPRINTK(4, "\n    Link AP\n    rsn.mode=%d\n    rsn.size=%d\n",
+		ap_info->rsn_mode, ap_info->rsn.size);
+	DPRINTK(4, "\n    ext_rate_set_size=%d\n    rate_set_size=%d\n",
+		ap_info->ext_rate_set.size, ap_info->rate_set.size);
+
+	return 0;
+}
+
+static
+int get_ap_information(struct ks_wlan_private *priv, struct ap_info_t *ap_info,
+		       struct local_ap_t *ap)
+{
+	unsigned char *bp;
+	int bsize, offset;
+
+	DPRINTK(3, "\n");
+	memset(ap, 0, sizeof(struct local_ap_t));
+
+	/* bssid */
+	memcpy(ap->bssid, ap_info->bssid, ETH_ALEN);
+	/* rssi */
+	ap->rssi = ap_info->rssi;
+	/* sq */
+	ap->sq = ap_info->sq;
+	/* noise */
+	ap->noise = ap_info->noise;
+	/* capability */
+	ap->capability = ap_info->capability;
+	/* channel */
+	ap->channel = ap_info->ch_info;
+
+	bp = ap_info->body;
+	bsize = ap_info->body_size;
+	offset = 0;
+
+	while (bsize > offset) {
+		/* DPRINTK(4, "Element ID=%d\n",*bp); */
+		switch (*bp) {
+		case 0:	/* ssid */
+			if (*(bp + 1) <= SSID_MAX_SIZE) {
+				ap->ssid.size = *(bp + 1);
+			} else {
+				DPRINTK(1, "size over :: ssid size=%d\n",
+					*(bp + 1));
+				ap->ssid.size = SSID_MAX_SIZE;
+			}
+			memcpy(ap->ssid.body, bp + 2, ap->ssid.size);
+			break;
+		case 1:	/* rate */
+		case 50:	/* ext rate */
+			if ((*(bp + 1) + ap->rate_set.size) <=
+			    RATE_SET_MAX_SIZE) {
+				memcpy(&ap->rate_set.body[ap->rate_set.size],
+				       bp + 2, *(bp + 1));
+				ap->rate_set.size += *(bp + 1);
+			} else {
+				DPRINTK(1, "size over :: rate size=%d\n",
+					(*(bp + 1) + ap->rate_set.size));
+				memcpy(&ap->rate_set.body[ap->rate_set.size],
+				       bp + 2,
+				       RATE_SET_MAX_SIZE - ap->rate_set.size);
+				ap->rate_set.size +=
+				    (RATE_SET_MAX_SIZE - ap->rate_set.size);
+			}
+			break;
+		case 3:	/* DS parameter */
+			break;
+		case 48:	/* RSN(WPA2) */
+			ap->rsn_ie.id = *bp;
+			if (*(bp + 1) <= RSN_IE_BODY_MAX) {
+				ap->rsn_ie.size = *(bp + 1);
+			} else {
+				DPRINTK(1, "size over :: rsn size=%d\n",
+					*(bp + 1));
+				ap->rsn_ie.size = RSN_IE_BODY_MAX;
+			}
+			memcpy(ap->rsn_ie.body, bp + 2, ap->rsn_ie.size);
+			break;
+		case 221:	/* WPA */
+			if (memcmp(bp + 2, "\x00\x50\xf2\x01", 4) == 0) {	/* WPA OUI check */
+				ap->wpa_ie.id = *bp;
+				if (*(bp + 1) <= RSN_IE_BODY_MAX) {
+					ap->wpa_ie.size = *(bp + 1);
+				} else {
+					DPRINTK(1,
+						"size over :: wpa size=%d\n",
+						*(bp + 1));
+					ap->wpa_ie.size = RSN_IE_BODY_MAX;
+				}
+				memcpy(ap->wpa_ie.body, bp + 2,
+				       ap->wpa_ie.size);
+			}
+			break;
+
+		case 2:	/* FH parameter */
+		case 4:	/* CF parameter */
+		case 5:	/* TIM */
+		case 6:	/* IBSS parameter */
+		case 7:	/* Country */
+		case 42:	/* ERP information */
+		case 47:	/* Reserve ID 47 Broadcom AP */
+			break;
+		default:
+			DPRINTK(4, "unknown Element ID=%d\n", *bp);
+			break;
+		}
+		offset += 2;	/* id & size field */
+		offset += *(bp + 1);	/* +size offset */
+		bp += (*(bp + 1) + 2);	/* pointer update */
+	}
+
+	return 0;
+}
+
+static
+int hostif_data_indication_wpa(struct ks_wlan_private *priv,
+			       unsigned short auth_type)
+{
+	struct ether_hdr *eth_hdr;
+	unsigned short eth_proto;
+	unsigned char recv_mic[8];
+	char buf[128];
+	unsigned long now;
+	struct mic_failure_t *mic_failure;
+	struct michael_mic_t michael_mic;
+	union iwreq_data wrqu;
+	unsigned int key_index = auth_type - 1;
+	struct wpa_key_t *key = &priv->wpa.key[key_index];
+
+	eth_hdr = (struct ether_hdr *)(priv->rxp);
+	eth_proto = ntohs(eth_hdr->h_proto);
+
+	if (eth_hdr->h_dest_snap != eth_hdr->h_source_snap) {
+		DPRINTK(1, "invalid data format\n");
+		priv->nstats.rx_errors++;
+		return -EINVAL;
+	}
+	if (((auth_type == TYPE_PMK1 &&
+	      priv->wpa.pairwise_suite == IW_AUTH_CIPHER_TKIP) ||
+	     (auth_type == TYPE_GMK1 &&
+	      priv->wpa.group_suite == IW_AUTH_CIPHER_TKIP) ||
+	     (auth_type == TYPE_GMK2 &&
+	      priv->wpa.group_suite == IW_AUTH_CIPHER_TKIP)) &&
+	    key->key_len) {
+		DPRINTK(4, "TKIP: protocol=%04X: size=%u\n",
+			eth_proto, priv->rx_size);
+		/* MIC save */
+		memcpy(&recv_mic[0], (priv->rxp) + ((priv->rx_size) - 8), 8);
+		priv->rx_size = priv->rx_size - 8;
+		if (auth_type > 0 && auth_type < 4) {	/* auth_type check */
+			MichaelMICFunction(&michael_mic,
+					   (uint8_t *)key->rx_mic_key,
+					   (uint8_t *)priv->rxp,
+					   (int)priv->rx_size,
+					   (uint8_t)0,	/* priority */
+					   (uint8_t *)michael_mic.Result);
+		}
+		if (memcmp(michael_mic.Result, recv_mic, 8) != 0) {
+			now = jiffies;
+			mic_failure = &priv->wpa.mic_failure;
+			/* MIC FAILURE */
+			if (mic_failure->last_failure_time &&
+			    (now - mic_failure->last_failure_time) / HZ >= 60) {
+				mic_failure->failure = 0;
+			}
+			DPRINTK(4, "MIC FAILURE\n");
+			if (mic_failure->failure == 0) {
+				mic_failure->failure = 1;
+				mic_failure->counter = 0;
+			} else if (mic_failure->failure == 1) {
+				mic_failure->failure = 2;
+				mic_failure->counter =
+					(uint16_t)((now - mic_failure->last_failure_time) / HZ);
+				if (!mic_failure->counter)	/*  range 1-60 */
+					mic_failure->counter = 1;
+			}
+			priv->wpa.mic_failure.last_failure_time = now;
+
+			/*  needed parameters: count, keyid, key type, TSC */
+			sprintf(buf,
+				"MLME-MICHAELMICFAILURE.indication(keyid=%d %scast addr=%pM)",
+				key_index,
+				eth_hdr->h_dest[0] & 0x01 ? "broad" : "uni",
+				eth_hdr->h_source);
+			memset(&wrqu, 0, sizeof(wrqu));
+			wrqu.data.length = strlen(buf);
+			DPRINTK(4, "IWEVENT:MICHAELMICFAILURE\n");
+			wireless_send_event(priv->net_dev, IWEVCUSTOM, &wrqu,
+					    buf);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static
+void hostif_data_indication(struct ks_wlan_private *priv)
+{
+	unsigned int rx_ind_size;	/* indicate data size */
+	struct sk_buff *skb;
+	unsigned short auth_type;
+	unsigned char temp[256];
+	struct ether_hdr *eth_hdr;
+	unsigned short eth_proto;
+	struct ieee802_1x_hdr *aa1x_hdr;
+	size_t size;
+	int ret;
+
+	DPRINTK(3, "\n");
+
+	/* min length check */
+	if (priv->rx_size <= ETH_HLEN) {
+		DPRINTK(3, "rx_size = %d\n", priv->rx_size);
+		priv->nstats.rx_errors++;
+		return;
+	}
+
+	auth_type = get_WORD(priv);	/* AuthType */
+	get_WORD(priv);	/* Reserve Area */
+
+	eth_hdr = (struct ether_hdr *)(priv->rxp);
+	eth_proto = ntohs(eth_hdr->h_proto);
+	DPRINTK(3, "ether protocol = %04X\n", eth_proto);
+
+	/* source address check */
+	if (memcmp(&priv->eth_addr[0], eth_hdr->h_source, ETH_ALEN) == 0) {
+		DPRINTK(1, "invalid : source is own mac address !!\n");
+		DPRINTK(1,
+			"eth_hdrernet->h_dest=%02X:%02X:%02X:%02X:%02X:%02X\n",
+			eth_hdr->h_source[0], eth_hdr->h_source[1],
+			eth_hdr->h_source[2], eth_hdr->h_source[3],
+			eth_hdr->h_source[4], eth_hdr->h_source[5]);
+		priv->nstats.rx_errors++;
+		return;
+	}
+
+	/*  for WPA */
+	if (auth_type != TYPE_DATA && priv->wpa.rsn_enabled) {
+		ret = hostif_data_indication_wpa(priv, auth_type);
+		if (ret)
+			return;
+	}
+
+	if ((priv->connect_status & FORCE_DISCONNECT) ||
+	    priv->wpa.mic_failure.failure == 2) {
+		return;
+	}
+
+	/* check 13th byte at rx data */
+	switch (*(priv->rxp + 12)) {
+	case 0xAA:	/* SNAP */
+		rx_ind_size = priv->rx_size - 6;
+		skb = dev_alloc_skb(rx_ind_size);
+		if (!skb) {
+			priv->nstats.rx_dropped++;
+			return;
+		}
+		DPRINTK(4, "SNAP, rx_ind_size = %d\n", rx_ind_size);
+
+		size = ETH_ALEN * 2;
+		memcpy(skb_put(skb, size), priv->rxp, size);
+
+		/* (SNAP+UI..) skip */
+
+		size = rx_ind_size - (ETH_ALEN * 2);
+		memcpy(skb_put(skb, size), &eth_hdr->h_proto, size);
+
+		aa1x_hdr = (struct ieee802_1x_hdr *)(priv->rxp + ETHER_HDR_SIZE);
+		break;
+	case 0xF0:	/* NETBEUI/NetBIOS */
+		rx_ind_size = (priv->rx_size + 2);
+		skb = dev_alloc_skb(rx_ind_size);
+		if (!skb) {
+			priv->nstats.rx_dropped++;
+			return;
+		}
+		DPRINTK(3, "NETBEUI/NetBIOS rx_ind_size=%d\n", rx_ind_size);
+
+		memcpy(skb_put(skb, 12), priv->rxp, 12);	/* 8802/FDDI MAC copy */
+
+		temp[0] = (((rx_ind_size - 12) >> 8) & 0xff);	/* NETBEUI size add */
+		temp[1] = ((rx_ind_size - 12) & 0xff);
+		memcpy(skb_put(skb, 2), temp, 2);
+
+		memcpy(skb_put(skb, rx_ind_size - 14), priv->rxp + 12,
+		       rx_ind_size - 14);	/* copy after Type */
+
+		aa1x_hdr = (struct ieee802_1x_hdr *)(priv->rxp + 14);
+		break;
+	default:	/* other rx data */
+		DPRINTK(2, "invalid data format\n");
+		priv->nstats.rx_errors++;
+		return;
+	}
+
+	if (aa1x_hdr->type == IEEE802_1X_TYPE_EAPOL_KEY &&
+	    priv->wpa.rsn_enabled)
+		atomic_set(&priv->psstatus.snooze_guard, 1);
+
+	/* rx indication */
+	skb->dev = priv->net_dev;
+	skb->protocol = eth_type_trans(skb, skb->dev);
+	priv->nstats.rx_packets++;
+	priv->nstats.rx_bytes += rx_ind_size;
+	netif_rx(skb);
+}
+
+static
+void hostif_mib_get_confirm(struct ks_wlan_private *priv)
+{
+	struct net_device *dev = priv->net_dev;
+	u32 mib_status;
+	u32 mib_attribute;
+	u16 mib_val_size;
+	u16 mib_val_type;
+
+	DPRINTK(3, "\n");
+
+	mib_status = get_DWORD(priv);	/* MIB status */
+	mib_attribute = get_DWORD(priv);	/* MIB atttibute */
+	mib_val_size = get_WORD(priv);	/* MIB value size */
+	mib_val_type = get_WORD(priv);	/* MIB value type */
+
+	if (mib_status) {
+		/* in case of error */
+		DPRINTK(1, "attribute=%08X, status=%08X\n", mib_attribute,
+			mib_status);
+		return;
+	}
+
+	switch (mib_attribute) {
+	case DOT11_MAC_ADDRESS:
+		/* MAC address */
+		DPRINTK(3, " mib_attribute=DOT11_MAC_ADDRESS\n");
+		hostif_sme_enqueue(priv, SME_GET_MAC_ADDRESS);
+		memcpy(priv->eth_addr, priv->rxp, ETH_ALEN);
+		priv->mac_address_valid = 1;
+		dev->dev_addr[0] = priv->eth_addr[0];
+		dev->dev_addr[1] = priv->eth_addr[1];
+		dev->dev_addr[2] = priv->eth_addr[2];
+		dev->dev_addr[3] = priv->eth_addr[3];
+		dev->dev_addr[4] = priv->eth_addr[4];
+		dev->dev_addr[5] = priv->eth_addr[5];
+		dev->dev_addr[6] = 0x00;
+		dev->dev_addr[7] = 0x00;
+		netdev_info(dev, "MAC ADDRESS = %pM\n", priv->eth_addr);
+		break;
+	case DOT11_PRODUCT_VERSION:
+		/* firmware version */
+		DPRINTK(3, " mib_attribute=DOT11_PRODUCT_VERSION\n");
+		priv->version_size = priv->rx_size;
+		memcpy(priv->firmware_version, priv->rxp, priv->rx_size);
+		priv->firmware_version[priv->rx_size] = '\0';
+		netdev_info(dev, "firmware ver. = %s\n",
+			    priv->firmware_version);
+		hostif_sme_enqueue(priv, SME_GET_PRODUCT_VERSION);
+		/* wake_up_interruptible_all(&priv->confirm_wait); */
+		complete(&priv->confirm_wait);
+		break;
+	case LOCAL_GAIN:
+		memcpy(&priv->gain, priv->rxp, sizeof(priv->gain));
+		DPRINTK(3, "TxMode=%d, RxMode=%d, TxGain=%d, RxGain=%d\n",
+			priv->gain.TxMode, priv->gain.RxMode, priv->gain.TxGain,
+			priv->gain.RxGain);
+		break;
+	case LOCAL_EEPROM_SUM:
+		memcpy(&priv->eeprom_sum, priv->rxp, sizeof(priv->eeprom_sum));
+		DPRINTK(1, "eeprom_sum.type=%x, eeprom_sum.result=%x\n",
+			priv->eeprom_sum.type, priv->eeprom_sum.result);
+		if (priv->eeprom_sum.type == 0) {
+			priv->eeprom_checksum = EEPROM_CHECKSUM_NONE;
+		} else if (priv->eeprom_sum.type == 1) {
+			if (priv->eeprom_sum.result == 0) {
+				priv->eeprom_checksum = EEPROM_NG;
+				netdev_info(dev, "LOCAL_EEPROM_SUM NG\n");
+			} else if (priv->eeprom_sum.result == 1) {
+				priv->eeprom_checksum = EEPROM_OK;
+			}
+		} else {
+			netdev_err(dev, "LOCAL_EEPROM_SUM error!\n");
+		}
+		break;
+	default:
+		DPRINTK(1, "mib_attribute=%08x\n", (unsigned int)mib_attribute);
+		break;
+	}
+}
+
+static
+void hostif_mib_set_confirm(struct ks_wlan_private *priv)
+{
+	u32 mib_status;	/* +04 MIB Status */
+	u32 mib_attribute;	/* +08 MIB attribute */
+
+	DPRINTK(3, "\n");
+
+	mib_status = get_DWORD(priv);	/* MIB Status */
+	mib_attribute = get_DWORD(priv);	/* MIB attribute */
+
+	if (mib_status) {
+		/* in case of error */
+		DPRINTK(1, "error :: attribute=%08X, status=%08X\n",
+			mib_attribute, mib_status);
+	}
+
+	switch (mib_attribute) {
+	case DOT11_RTS_THRESHOLD:
+		hostif_sme_enqueue(priv, SME_RTS_THRESHOLD_CONFIRM);
+		break;
+	case DOT11_FRAGMENTATION_THRESHOLD:
+		hostif_sme_enqueue(priv, SME_FRAGMENTATION_THRESHOLD_CONFIRM);
+		break;
+	case DOT11_WEP_DEFAULT_KEY_ID:
+		if (!priv->wpa.wpa_enabled)
+			hostif_sme_enqueue(priv, SME_WEP_INDEX_CONFIRM);
+		break;
+	case DOT11_WEP_DEFAULT_KEY_VALUE1:
+		DPRINTK(2, "DOT11_WEP_DEFAULT_KEY_VALUE1:mib_status=%d\n",
+			(int)mib_status);
+		if (priv->wpa.rsn_enabled)
+			hostif_sme_enqueue(priv, SME_SET_PMK_TSC);
+		else
+			hostif_sme_enqueue(priv, SME_WEP_KEY1_CONFIRM);
+		break;
+	case DOT11_WEP_DEFAULT_KEY_VALUE2:
+		DPRINTK(2, "DOT11_WEP_DEFAULT_KEY_VALUE2:mib_status=%d\n",
+			(int)mib_status);
+		if (priv->wpa.rsn_enabled)
+			hostif_sme_enqueue(priv, SME_SET_GMK1_TSC);
+		else
+			hostif_sme_enqueue(priv, SME_WEP_KEY2_CONFIRM);
+		break;
+	case DOT11_WEP_DEFAULT_KEY_VALUE3:
+		DPRINTK(2, "DOT11_WEP_DEFAULT_KEY_VALUE3:mib_status=%d\n",
+			(int)mib_status);
+		if (priv->wpa.rsn_enabled)
+			hostif_sme_enqueue(priv, SME_SET_GMK2_TSC);
+		else
+			hostif_sme_enqueue(priv, SME_WEP_KEY3_CONFIRM);
+		break;
+	case DOT11_WEP_DEFAULT_KEY_VALUE4:
+		DPRINTK(2, "DOT11_WEP_DEFAULT_KEY_VALUE4:mib_status=%d\n",
+			(int)mib_status);
+		if (!priv->wpa.rsn_enabled)
+			hostif_sme_enqueue(priv, SME_WEP_KEY4_CONFIRM);
+		break;
+	case DOT11_PRIVACY_INVOKED:
+		if (!priv->wpa.rsn_enabled)
+			hostif_sme_enqueue(priv, SME_WEP_FLAG_CONFIRM);
+		break;
+	case DOT11_RSN_ENABLED:
+		DPRINTK(2, "DOT11_RSN_ENABLED:mib_status=%d\n",
+			(int)mib_status);
+		hostif_sme_enqueue(priv, SME_RSN_ENABLED_CONFIRM);
+		break;
+	case LOCAL_RSN_MODE:
+		hostif_sme_enqueue(priv, SME_RSN_MODE_CONFIRM);
+		break;
+	case LOCAL_MULTICAST_ADDRESS:
+		hostif_sme_enqueue(priv, SME_MULTICAST_REQUEST);
+		break;
+	case LOCAL_MULTICAST_FILTER:
+		hostif_sme_enqueue(priv, SME_MULTICAST_CONFIRM);
+		break;
+	case LOCAL_CURRENTADDRESS:
+		priv->mac_address_valid = 1;
+		break;
+	case DOT11_RSN_CONFIG_MULTICAST_CIPHER:
+		DPRINTK(2, "DOT11_RSN_CONFIG_MULTICAST_CIPHER:mib_status=%d\n",
+			(int)mib_status);
+		hostif_sme_enqueue(priv, SME_RSN_MCAST_CONFIRM);
+		break;
+	case DOT11_RSN_CONFIG_UNICAST_CIPHER:
+		DPRINTK(2, "DOT11_RSN_CONFIG_UNICAST_CIPHER:mib_status=%d\n",
+			(int)mib_status);
+		hostif_sme_enqueue(priv, SME_RSN_UCAST_CONFIRM);
+		break;
+	case DOT11_RSN_CONFIG_AUTH_SUITE:
+		DPRINTK(2, "DOT11_RSN_CONFIG_AUTH_SUITE:mib_status=%d\n",
+			(int)mib_status);
+		hostif_sme_enqueue(priv, SME_RSN_AUTH_CONFIRM);
+		break;
+	case DOT11_PMK_TSC:
+		DPRINTK(2, "DOT11_PMK_TSC:mib_status=%d\n", (int)mib_status);
+		break;
+	case DOT11_GMK1_TSC:
+		DPRINTK(2, "DOT11_GMK1_TSC:mib_status=%d\n", (int)mib_status);
+		if (atomic_read(&priv->psstatus.snooze_guard))
+			atomic_set(&priv->psstatus.snooze_guard, 0);
+		break;
+	case DOT11_GMK2_TSC:
+		DPRINTK(2, "DOT11_GMK2_TSC:mib_status=%d\n", (int)mib_status);
+		if (atomic_read(&priv->psstatus.snooze_guard))
+			atomic_set(&priv->psstatus.snooze_guard, 0);
+		break;
+	case LOCAL_PMK:
+		DPRINTK(2, "LOCAL_PMK:mib_status=%d\n", (int)mib_status);
+		break;
+	case LOCAL_GAIN:
+		DPRINTK(2, "LOCAL_GAIN:mib_status=%d\n", (int)mib_status);
+		break;
+#ifdef WPS
+	case LOCAL_WPS_ENABLE:
+		DPRINTK(2, "LOCAL_WPS_ENABLE:mib_status=%d\n", (int)mib_status);
+		break;
+	case LOCAL_WPS_PROBE_REQ:
+		DPRINTK(2, "LOCAL_WPS_PROBE_REQ:mib_status=%d\n",
+			(int)mib_status);
+		break;
+#endif /* WPS */
+	case LOCAL_REGION:
+		DPRINTK(2, "LOCAL_REGION:mib_status=%d\n", (int)mib_status);
+	default:
+		break;
+	}
+}
+
+static
+void hostif_power_mgmt_confirm(struct ks_wlan_private *priv)
+{
+	DPRINTK(3, "\n");
+
+	if (priv->reg.power_mgmt > POWER_MGMT_ACTIVE &&
+	    priv->reg.operation_mode == MODE_INFRASTRUCTURE) {
+		atomic_set(&priv->psstatus.confirm_wait, 0);
+		priv->dev_state = DEVICE_STATE_SLEEP;
+		ks_wlan_hw_power_save(priv);
+	} else {
+		priv->dev_state = DEVICE_STATE_READY;
+	}
+}
+
+static
+void hostif_sleep_confirm(struct ks_wlan_private *priv)
+{
+	DPRINTK(3, "\n");
+
+	atomic_set(&priv->sleepstatus.doze_request, 1);
+	queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
+}
+
+static
+void hostif_start_confirm(struct ks_wlan_private *priv)
+{
+#ifdef WPS
+	union iwreq_data wrqu;
+
+	wrqu.data.length = 0;
+	wrqu.data.flags = 0;
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	if (is_connect_status(priv->connect_status)) {
+		eth_zero_addr(wrqu.ap_addr.sa_data);
+		DPRINTK(3, "IWEVENT: disconnect\n");
+		wireless_send_event(priv->net_dev, SIOCGIWAP, &wrqu, NULL);
+	}
+#endif
+	DPRINTK(3, " scan_ind_count=%d\n", priv->scan_ind_count);
+	hostif_sme_enqueue(priv, SME_START_CONFIRM);
+}
+
+static
+void hostif_connect_indication(struct ks_wlan_private *priv)
+{
+	unsigned short connect_code;
+	unsigned int tmp = 0;
+	unsigned int old_status = priv->connect_status;
+	struct net_device *netdev = priv->net_dev;
+	union iwreq_data wrqu0;
+
+	connect_code = get_WORD(priv);
+
+	switch (connect_code) {
+	case RESULT_CONNECT:	/* connect */
+		DPRINTK(3, "connect :: scan_ind_count=%d\n",
+			priv->scan_ind_count);
+		if (!(priv->connect_status & FORCE_DISCONNECT))
+			netif_carrier_on(netdev);
+		tmp = FORCE_DISCONNECT & priv->connect_status;
+		priv->connect_status = tmp + CONNECT_STATUS;
+		break;
+	case RESULT_DISCONNECT:	/* disconnect */
+		DPRINTK(3, "disconnect :: scan_ind_count=%d\n",
+			priv->scan_ind_count);
+		netif_carrier_off(netdev);
+		tmp = FORCE_DISCONNECT & priv->connect_status;
+		priv->connect_status = tmp + DISCONNECT_STATUS;
+		break;
+	default:
+		DPRINTK(1, "unknown connect_code=%d :: scan_ind_count=%d\n",
+			connect_code, priv->scan_ind_count);
+		netif_carrier_off(netdev);
+		tmp = FORCE_DISCONNECT & priv->connect_status;
+		priv->connect_status = tmp + DISCONNECT_STATUS;
+		break;
+	}
+
+	get_current_ap(priv, (struct link_ap_info_t *)priv->rxp);
+	if (is_connect_status(priv->connect_status) &&
+	    is_disconnect_status(old_status)) {
+		/* for power save */
+		atomic_set(&priv->psstatus.snooze_guard, 0);
+		atomic_set(&priv->psstatus.confirm_wait, 0);
+	}
+	ks_wlan_do_power_save(priv);
+
+	wrqu0.data.length = 0;
+	wrqu0.data.flags = 0;
+	wrqu0.ap_addr.sa_family = ARPHRD_ETHER;
+	if (is_disconnect_status(priv->connect_status) &&
+	    is_connect_status(old_status)) {
+		eth_zero_addr(wrqu0.ap_addr.sa_data);
+		DPRINTK(3, "IWEVENT: disconnect\n");
+		DPRINTK(3, "disconnect :: scan_ind_count=%d\n",
+			priv->scan_ind_count);
+		wireless_send_event(netdev, SIOCGIWAP, &wrqu0, NULL);
+	}
+	priv->scan_ind_count = 0;
+}
+
+static
+void hostif_scan_indication(struct ks_wlan_private *priv)
+{
+	int i;
+	struct ap_info_t *ap_info;
+
+	DPRINTK(3, "scan_ind_count = %d\n", priv->scan_ind_count);
+	ap_info = (struct ap_info_t *)(priv->rxp);
+
+	if (priv->scan_ind_count) {
+		for (i = 0; i < priv->aplist.size; i++) {	/* bssid check */
+			if (memcmp(ap_info->bssid,
+				   priv->aplist.ap[i].bssid, ETH_ALEN) != 0)
+				continue;
+
+			if (ap_info->frame_type == FRAME_TYPE_PROBE_RESP)
+				get_ap_information(priv, ap_info,
+						   &priv->aplist.ap[i]);
+			return;
+		}
+	}
+	priv->scan_ind_count++;
+	if (priv->scan_ind_count < LOCAL_APLIST_MAX + 1) {
+		DPRINTK(4, " scan_ind_count=%d :: aplist.size=%d\n",
+			priv->scan_ind_count, priv->aplist.size);
+		get_ap_information(priv, (struct ap_info_t *)(priv->rxp),
+				   &(priv->aplist.ap[priv->scan_ind_count - 1]));
+		priv->aplist.size = priv->scan_ind_count;
+	} else {
+		DPRINTK(4, " count over :: scan_ind_count=%d\n",
+			priv->scan_ind_count);
+	}
+}
+
+static
+void hostif_stop_confirm(struct ks_wlan_private *priv)
+{
+	unsigned int tmp = 0;
+	unsigned int old_status = priv->connect_status;
+	struct net_device *netdev = priv->net_dev;
+	union iwreq_data wrqu0;
+
+	DPRINTK(3, "\n");
+	if (priv->dev_state == DEVICE_STATE_SLEEP)
+		priv->dev_state = DEVICE_STATE_READY;
+
+	/* disconnect indication */
+	if (is_connect_status(priv->connect_status)) {
+		netif_carrier_off(netdev);
+		tmp = FORCE_DISCONNECT & priv->connect_status;
+		priv->connect_status = tmp | DISCONNECT_STATUS;
+		netdev_info(netdev, "IWEVENT: disconnect\n");
+
+		wrqu0.data.length = 0;
+		wrqu0.data.flags = 0;
+		wrqu0.ap_addr.sa_family = ARPHRD_ETHER;
+		if (is_disconnect_status(priv->connect_status) &&
+		    is_connect_status(old_status)) {
+			eth_zero_addr(wrqu0.ap_addr.sa_data);
+			DPRINTK(3, "IWEVENT: disconnect\n");
+			netdev_info(netdev, "IWEVENT: disconnect\n");
+			DPRINTK(3, "disconnect :: scan_ind_count=%d\n",
+				priv->scan_ind_count);
+			wireless_send_event(netdev, SIOCGIWAP, &wrqu0, NULL);
+		}
+		priv->scan_ind_count = 0;
+	}
+
+	hostif_sme_enqueue(priv, SME_STOP_CONFIRM);
+}
+
+static
+void hostif_ps_adhoc_set_confirm(struct ks_wlan_private *priv)
+{
+	DPRINTK(3, "\n");
+	priv->infra_status = 0;	/* infrastructure mode cancel */
+	hostif_sme_enqueue(priv, SME_MODE_SET_CONFIRM);
+}
+
+static
+void hostif_infrastructure_set_confirm(struct ks_wlan_private *priv)
+{
+	u16 result_code;
+
+	DPRINTK(3, "\n");
+	result_code = get_WORD(priv);
+	DPRINTK(3, "result code = %d\n", result_code);
+	priv->infra_status = 1;	/* infrastructure mode set */
+	hostif_sme_enqueue(priv, SME_MODE_SET_CONFIRM);
+}
+
+static
+void hostif_adhoc_set_confirm(struct ks_wlan_private *priv)
+{
+	DPRINTK(3, "\n");
+	priv->infra_status = 1;	/* infrastructure mode set */
+	hostif_sme_enqueue(priv, SME_MODE_SET_CONFIRM);
+}
+
+static
+void hostif_associate_indication(struct ks_wlan_private *priv)
+{
+	struct association_request_t *assoc_req;
+	struct association_response_t *assoc_resp;
+	unsigned char *pb;
+	union iwreq_data wrqu;
+	char buf[IW_CUSTOM_MAX];
+	char *pbuf = &buf[0];
+	int i;
+
+	static const char associnfo_leader0[] = "ASSOCINFO(ReqIEs=";
+	static const char associnfo_leader1[] = " RespIEs=";
+
+	DPRINTK(3, "\n");
+	assoc_req = (struct association_request_t *)(priv->rxp);
+	assoc_resp = (struct association_response_t *)(assoc_req + 1);
+	pb = (unsigned char *)(assoc_resp + 1);
+
+	memset(&wrqu, 0, sizeof(wrqu));
+	memcpy(pbuf, associnfo_leader0, sizeof(associnfo_leader0) - 1);
+	wrqu.data.length += sizeof(associnfo_leader0) - 1;
+	pbuf += sizeof(associnfo_leader0) - 1;
+
+	for (i = 0; i < assoc_req->reqIEs_size; i++)
+		pbuf += sprintf(pbuf, "%02x", *(pb + i));
+	wrqu.data.length += (assoc_req->reqIEs_size) * 2;
+
+	memcpy(pbuf, associnfo_leader1, sizeof(associnfo_leader1) - 1);
+	wrqu.data.length += sizeof(associnfo_leader1) - 1;
+	pbuf += sizeof(associnfo_leader1) - 1;
+
+	pb += assoc_req->reqIEs_size;
+	for (i = 0; i < assoc_resp->respIEs_size; i++)
+		pbuf += sprintf(pbuf, "%02x", *(pb + i));
+	wrqu.data.length += (assoc_resp->respIEs_size) * 2;
+
+	pbuf += sprintf(pbuf, ")");
+	wrqu.data.length += 1;
+
+	DPRINTK(3, "IWEVENT:ASSOCINFO\n");
+	wireless_send_event(priv->net_dev, IWEVCUSTOM, &wrqu, buf);
+}
+
+static
+void hostif_bss_scan_confirm(struct ks_wlan_private *priv)
+{
+	unsigned int result_code;
+	struct net_device *dev = priv->net_dev;
+	union iwreq_data wrqu;
+
+	result_code = get_DWORD(priv);
+	DPRINTK(2, "result=%d :: scan_ind_count=%d\n", result_code,
+		priv->scan_ind_count);
+
+	priv->sme_i.sme_flag &= ~SME_AP_SCAN;
+	hostif_sme_enqueue(priv, SME_BSS_SCAN_CONFIRM);
+
+	wrqu.data.length = 0;
+	wrqu.data.flags = 0;
+	DPRINTK(3, "IWEVENT: SCAN CONFIRM\n");
+	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
+	priv->scan_ind_count = 0;
+}
+
+static
+void hostif_phy_information_confirm(struct ks_wlan_private *priv)
+{
+	struct iw_statistics *wstats = &priv->wstats;
+	unsigned char rssi, signal, noise;
+	unsigned char LinkSpeed;
+	unsigned int TransmittedFrameCount, ReceivedFragmentCount;
+	unsigned int FailedCount, FCSErrorCount;
+
+	DPRINTK(3, "\n");
+	rssi = get_BYTE(priv);
+	signal = get_BYTE(priv);
+	noise = get_BYTE(priv);
+	LinkSpeed = get_BYTE(priv);
+	TransmittedFrameCount = get_DWORD(priv);
+	ReceivedFragmentCount = get_DWORD(priv);
+	FailedCount = get_DWORD(priv);
+	FCSErrorCount = get_DWORD(priv);
+
+	DPRINTK(4, "phyinfo confirm rssi=%d signal=%d\n", rssi, signal);
+	priv->current_rate = (LinkSpeed & RATE_MASK);
+	wstats->qual.qual = signal;
+	wstats->qual.level = 256 - rssi;
+	wstats->qual.noise = 0;	/* invalid noise value */
+	wstats->qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
+
+	DPRINTK(3, "\n    rssi=%u\n"
+		   "    signal=%u\n"
+		   "    LinkSpeed=%ux500Kbps\n"
+		   "    TransmittedFrameCount=%u\n"
+		   "    ReceivedFragmentCount=%u\n"
+		   "    FailedCount=%u\n"
+		   "    FCSErrorCount=%u\n",
+		rssi, signal, LinkSpeed, TransmittedFrameCount,
+		ReceivedFragmentCount, FailedCount, FCSErrorCount);
+
+	/* wake_up_interruptible_all(&priv->confirm_wait); */
+	complete(&priv->confirm_wait);
+}
+
+static
+void hostif_mic_failure_confirm(struct ks_wlan_private *priv)
+{
+	DPRINTK(3, "mic_failure=%u\n", priv->wpa.mic_failure.failure);
+	hostif_sme_enqueue(priv, SME_MIC_FAILURE_CONFIRM);
+}
+
+static
+void hostif_event_check(struct ks_wlan_private *priv)
+{
+	unsigned short event;
+
+	DPRINTK(4, "\n");
+	event = get_WORD(priv);	/* get event */
+	switch (event) {
+	case HIF_DATA_IND:
+		hostif_data_indication(priv);
+		break;
+	case HIF_MIB_GET_CONF:
+		hostif_mib_get_confirm(priv);
+		break;
+	case HIF_MIB_SET_CONF:
+		hostif_mib_set_confirm(priv);
+		break;
+	case HIF_POWER_MGMT_CONF:
+		hostif_power_mgmt_confirm(priv);
+		break;
+	case HIF_SLEEP_CONF:
+		hostif_sleep_confirm(priv);
+		break;
+	case HIF_START_CONF:
+		hostif_start_confirm(priv);
+		break;
+	case HIF_CONNECT_IND:
+		hostif_connect_indication(priv);
+		break;
+	case HIF_STOP_CONF:
+		hostif_stop_confirm(priv);
+		break;
+	case HIF_PS_ADH_SET_CONF:
+		hostif_ps_adhoc_set_confirm(priv);
+		break;
+	case HIF_INFRA_SET_CONF:
+	case HIF_INFRA_SET2_CONF:
+		hostif_infrastructure_set_confirm(priv);
+		break;
+	case HIF_ADH_SET_CONF:
+	case HIF_ADH_SET2_CONF:
+		hostif_adhoc_set_confirm(priv);
+		break;
+	case HIF_ASSOC_INFO_IND:
+		hostif_associate_indication(priv);
+		break;
+	case HIF_MIC_FAILURE_CONF:
+		hostif_mic_failure_confirm(priv);
+		break;
+	case HIF_SCAN_CONF:
+		hostif_bss_scan_confirm(priv);
+		break;
+	case HIF_PHY_INFO_CONF:
+	case HIF_PHY_INFO_IND:
+		hostif_phy_information_confirm(priv);
+		break;
+	case HIF_SCAN_IND:
+		hostif_scan_indication(priv);
+		break;
+	case HIF_AP_SET_CONF:
+	default:
+		//DPRINTK(1, "undefined event[%04X]\n", event);
+		netdev_err(priv->net_dev, "undefined event[%04X]\n", event);
+		/* wake_up_all(&priv->confirm_wait); */
+		complete(&priv->confirm_wait);
+		break;
+	}
+
+	/* add event to hostt buffer */
+	priv->hostt.buff[priv->hostt.qtail] = event;
+	priv->hostt.qtail = (priv->hostt.qtail + 1) % SME_EVENT_BUFF_SIZE;
+}
+
+/* allocate size bytes, set header size and event */
+static void *hostif_generic_request(size_t size, int event)
+{
+	struct hostif_hdr *p;
+
+	p = kzalloc(hif_align_size(size), KS_WLAN_MEM_FLAG);
+	if (!p)
+		return NULL;
+
+	p->size = cpu_to_le16((u16)(size - sizeof(p->size)));
+	p->event = cpu_to_le16(event);
+
+	return p;
+}
+
+int hostif_data_request(struct ks_wlan_private *priv, struct sk_buff *skb)
+{
+	unsigned int skb_len = 0;
+
+	unsigned char *buffer = NULL;
+	unsigned int length = 0;
+	struct hostif_data_request_t *pp;
+	unsigned char *p;
+	int result = 0;
+	unsigned short eth_proto;
+	struct ether_hdr *eth_hdr;
+	struct michael_mic_t michael_mic;
+	unsigned short keyinfo = 0;
+	struct ieee802_1x_hdr *aa1x_hdr;
+	struct wpa_eapol_key *eap_key;
+	struct ethhdr *eth;
+	size_t size;
+	int ret;
+
+	skb_len = skb->len;
+	if (skb_len > ETH_FRAME_LEN) {
+		DPRINTK(1, "bad length skb_len=%d\n", skb_len);
+		ret = -EOVERFLOW;
+		goto err_kfree_skb;
+	}
+
+	if (is_disconnect_status(priv->connect_status) ||
+	    (priv->connect_status & FORCE_DISCONNECT) ||
+	    priv->wpa.mic_failure.stop) {
+		DPRINTK(3, " DISCONNECT\n");
+		if (netif_queue_stopped(priv->net_dev))
+			netif_wake_queue(priv->net_dev);
+		if (skb)
+			dev_kfree_skb(skb);
+
+		return 0;
+	}
+
+	/* for PowerSave */
+	if (atomic_read(&priv->psstatus.status) == PS_SNOOZE) {	/* power save wakeup */
+		if (!netif_queue_stopped(priv->net_dev))
+			netif_stop_queue(priv->net_dev);
+	}
+
+	size = sizeof(*pp) + 6 + skb_len + 8;
+	pp = kmalloc(hif_align_size(size), KS_WLAN_MEM_FLAG);
+	if (!pp) {
+		ret = -ENOMEM;
+		goto err_kfree_skb;
+	}
+
+	p = (unsigned char *)pp->data;
+
+	buffer = skb->data;
+	length = skb->len;
+
+	/* skb check */
+	eth = (struct ethhdr *)skb->data;
+	if (memcmp(&priv->eth_addr[0], eth->h_source, ETH_ALEN) != 0) {
+		DPRINTK(1, "invalid mac address !!\n");
+		DPRINTK(1, "ethernet->h_source=%pM\n", eth->h_source);
+		ret = -ENXIO;
+		goto err_kfree;
+	}
+
+	/* dest and src MAC address copy */
+	size = ETH_ALEN * 2;
+	memcpy(p, buffer, size);
+	p += size;
+	buffer += size;
+	length -= size;
+
+	/* EtherType/Length check */
+	if (*(buffer + 1) + (*buffer << 8) > 1500) {
+		/* ProtocolEAP = *(buffer+1) + (*buffer << 8); */
+		/* DPRINTK(2, "Send [SNAP]Type %x\n",ProtocolEAP); */
+		/* SAP/CTL/OUI(6 byte) add */
+		*p++ = 0xAA;	/* DSAP */
+		*p++ = 0xAA;	/* SSAP */
+		*p++ = 0x03;	/* CTL */
+		*p++ = 0x00;	/* OUI ("000000") */
+		*p++ = 0x00;	/* OUI ("000000") */
+		*p++ = 0x00;	/* OUI ("000000") */
+		skb_len += 6;
+	} else {
+		DPRINTK(4, "DIX\n");
+		/* Length(2 byte) delete */
+		buffer += 2;
+		length -= 2;
+		skb_len -= 2;
+	}
+
+	/* pp->data copy */
+	memcpy(p, buffer, length);
+
+	p += length;
+
+	/* for WPA */
+	eth_hdr = (struct ether_hdr *)&pp->data[0];
+	eth_proto = ntohs(eth_hdr->h_proto);
+
+	/* for MIC FAILURE REPORT check */
+	if (eth_proto == ETHER_PROTOCOL_TYPE_EAP &&
+	    priv->wpa.mic_failure.failure > 0) {
+		aa1x_hdr = (struct ieee802_1x_hdr *)(eth_hdr + 1);
+		if (aa1x_hdr->type == IEEE802_1X_TYPE_EAPOL_KEY) {
+			eap_key = (struct wpa_eapol_key *)(aa1x_hdr + 1);
+			keyinfo = ntohs(eap_key->key_info);
+		}
+	}
+
+	if (priv->wpa.rsn_enabled && priv->wpa.key[0].key_len) {
+		if (eth_proto == ETHER_PROTOCOL_TYPE_EAP &&
+		    priv->wpa.key[1].key_len == 0 &&
+		    priv->wpa.key[2].key_len == 0 &&
+		    priv->wpa.key[3].key_len == 0) {
+			pp->auth_type = cpu_to_le16((uint16_t)TYPE_AUTH);	/* no encryption */
+		} else {
+			if (priv->wpa.pairwise_suite == IW_AUTH_CIPHER_TKIP) {
+				MichaelMICFunction(&michael_mic,
+						   (uint8_t *)priv->wpa.key[0].tx_mic_key,
+						   (uint8_t *)&pp->data[0],
+						   (int)skb_len,
+						   (uint8_t)0,	/* priority */
+						   (uint8_t *)michael_mic.Result);
+				memcpy(p, michael_mic.Result, 8);
+				length += 8;
+				skb_len += 8;
+				p += 8;
+				pp->auth_type =
+				    cpu_to_le16((uint16_t)TYPE_DATA);
+
+			} else if (priv->wpa.pairwise_suite ==
+				   IW_AUTH_CIPHER_CCMP) {
+				pp->auth_type =
+				    cpu_to_le16((uint16_t)TYPE_DATA);
+			}
+		}
+	} else {
+		if (eth_proto == ETHER_PROTOCOL_TYPE_EAP)
+			pp->auth_type = cpu_to_le16((uint16_t)TYPE_AUTH);
+		else
+			pp->auth_type = cpu_to_le16((uint16_t)TYPE_DATA);
+	}
+
+	/* header value set */
+	pp->header.size =
+	    cpu_to_le16((uint16_t)
+			(sizeof(*pp) - sizeof(pp->header.size) + skb_len));
+	pp->header.event = cpu_to_le16((uint16_t)HIF_DATA_REQ);
+
+	/* tx request */
+	result = ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp) + skb_len),
+			       send_packet_complete, skb);
+
+	/* MIC FAILURE REPORT check */
+	if (eth_proto == ETHER_PROTOCOL_TYPE_EAP &&
+	    priv->wpa.mic_failure.failure > 0) {
+		if (keyinfo & WPA_KEY_INFO_ERROR &&
+		    keyinfo & WPA_KEY_INFO_REQUEST) {
+			DPRINTK(3, " MIC ERROR Report SET : %04X\n", keyinfo);
+			hostif_sme_enqueue(priv, SME_MIC_FAILURE_REQUEST);
+		}
+		if (priv->wpa.mic_failure.failure == 2)
+			priv->wpa.mic_failure.stop = 1;
+	}
+
+	return result;
+
+err_kfree:
+	kfree(pp);
+err_kfree_skb:
+	dev_kfree_skb(skb);
+
+	return ret;
+}
+
+#define ps_confirm_wait_inc(priv)					 \
+	do {								 \
+		if (atomic_read(&priv->psstatus.status) > PS_ACTIVE_SET) \
+			atomic_inc(&priv->psstatus.confirm_wait);	 \
+	} while (0)
+
+static
+void hostif_mib_get_request(struct ks_wlan_private *priv,
+			    unsigned long mib_attribute)
+{
+	struct hostif_mib_get_request_t *pp;
+
+	DPRINTK(3, "\n");
+
+	pp = hostif_generic_request(sizeof(*pp), HIF_MIB_GET_REQ);
+	if (!pp)
+		return;
+
+	pp->mib_attribute = cpu_to_le32((uint32_t)mib_attribute);
+
+	/* send to device request */
+	ps_confirm_wait_inc(priv);
+	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
+}
+
+static
+void hostif_mib_set_request(struct ks_wlan_private *priv,
+			    unsigned long mib_attribute, unsigned short size,
+			    unsigned short type, void *vp)
+{
+	struct hostif_mib_set_request_t *pp;
+
+	DPRINTK(3, "\n");
+
+	if (priv->dev_state < DEVICE_STATE_BOOT) {
+		DPRINTK(3, "DeviceRemove\n");
+		return;
+	}
+
+	pp = hostif_generic_request(sizeof(*pp), HIF_MIB_SET_REQ);
+	if (!pp)
+		return;
+
+	pp->mib_attribute = cpu_to_le32((uint32_t)mib_attribute);
+	pp->mib_value.size = cpu_to_le16((uint16_t)size);
+	pp->mib_value.type = cpu_to_le16((uint16_t)type);
+	memcpy(&pp->mib_value.body, vp, size);
+
+	/* send to device request */
+	ps_confirm_wait_inc(priv);
+	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp) + size), NULL, NULL);
+}
+
+static
+void hostif_start_request(struct ks_wlan_private *priv, unsigned char mode)
+{
+	struct hostif_start_request_t *pp;
+
+	DPRINTK(3, "\n");
+
+	pp = hostif_generic_request(sizeof(*pp), HIF_START_REQ);
+	if (!pp)
+		return;
+
+	pp->mode = cpu_to_le16((uint16_t)mode);
+
+	/* send to device request */
+	ps_confirm_wait_inc(priv);
+	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
+
+	priv->aplist.size = 0;
+	priv->scan_ind_count = 0;
+}
+
+static
+void hostif_ps_adhoc_set_request(struct ks_wlan_private *priv)
+{
+	struct hostif_ps_adhoc_set_request_t *pp;
+	u16 capability;
+
+	DPRINTK(3, "\n");
+
+	pp = hostif_generic_request(sizeof(*pp), HIF_PS_ADH_SET_REQ);
+	if (!pp)
+		return;
+
+	pp->phy_type = cpu_to_le16((uint16_t)(priv->reg.phy_type));
+	pp->cts_mode = cpu_to_le16((uint16_t)(priv->reg.cts_mode));
+	pp->scan_type = cpu_to_le16((uint16_t)(priv->reg.scan_type));
+	pp->channel = cpu_to_le16((uint16_t)(priv->reg.channel));
+	pp->rate_set.size = priv->reg.rate_set.size;
+	memcpy(&pp->rate_set.body[0], &priv->reg.rate_set.body[0],
+	       priv->reg.rate_set.size);
+
+	capability = 0x0000;
+	if (priv->reg.preamble == SHORT_PREAMBLE) {
+		/* short preamble */
+		capability |= BSS_CAP_SHORT_PREAMBLE;
+	}
+	capability &= ~(BSS_CAP_PBCC);	/* pbcc not support */
+	if (priv->reg.phy_type != D_11B_ONLY_MODE) {
+		capability |= BSS_CAP_SHORT_SLOT_TIME;	/* ShortSlotTime support */
+		capability &= ~(BSS_CAP_DSSS_OFDM);	/* DSSS OFDM */
+	}
+	pp->capability = cpu_to_le16((uint16_t)capability);
+
+	/* send to device request */
+	ps_confirm_wait_inc(priv);
+	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
+}
+
+static
+void hostif_infrastructure_set_request(struct ks_wlan_private *priv)
+{
+	struct hostif_infrastructure_set_request_t *pp;
+	u16 capability;
+
+	DPRINTK(3, "ssid.size=%d\n", priv->reg.ssid.size);
+
+	pp = hostif_generic_request(sizeof(*pp), HIF_INFRA_SET_REQ);
+	if (!pp)
+		return;
+
+	pp->phy_type = cpu_to_le16((uint16_t)(priv->reg.phy_type));
+	pp->cts_mode = cpu_to_le16((uint16_t)(priv->reg.cts_mode));
+	pp->scan_type = cpu_to_le16((uint16_t)(priv->reg.scan_type));
+
+	pp->rate_set.size = priv->reg.rate_set.size;
+	memcpy(&pp->rate_set.body[0], &priv->reg.rate_set.body[0],
+	       priv->reg.rate_set.size);
+	pp->ssid.size = priv->reg.ssid.size;
+	memcpy(&pp->ssid.body[0], &priv->reg.ssid.body[0], priv->reg.ssid.size);
+
+	capability = 0x0000;
+	if (priv->reg.preamble == SHORT_PREAMBLE) {
+		/* short preamble */
+		capability |= BSS_CAP_SHORT_PREAMBLE;
+	}
+	capability &= ~(BSS_CAP_PBCC);	/* pbcc not support */
+	if (priv->reg.phy_type != D_11B_ONLY_MODE) {
+		capability |= BSS_CAP_SHORT_SLOT_TIME;	/* ShortSlotTime support */
+		capability &= ~(BSS_CAP_DSSS_OFDM);	/* DSSS OFDM not support */
+	}
+	pp->capability = cpu_to_le16((uint16_t)capability);
+	pp->beacon_lost_count =
+	    cpu_to_le16((uint16_t)(priv->reg.beacon_lost_count));
+	pp->auth_type = cpu_to_le16((uint16_t)(priv->reg.authenticate_type));
+
+	pp->channel_list.body[0] = 1;
+	pp->channel_list.body[1] = 8;
+	pp->channel_list.body[2] = 2;
+	pp->channel_list.body[3] = 9;
+	pp->channel_list.body[4] = 3;
+	pp->channel_list.body[5] = 10;
+	pp->channel_list.body[6] = 4;
+	pp->channel_list.body[7] = 11;
+	pp->channel_list.body[8] = 5;
+	pp->channel_list.body[9] = 12;
+	pp->channel_list.body[10] = 6;
+	pp->channel_list.body[11] = 13;
+	pp->channel_list.body[12] = 7;
+	if (priv->reg.phy_type == D_11G_ONLY_MODE) {
+		pp->channel_list.size = 13;
+	} else {
+		pp->channel_list.body[13] = 14;
+		pp->channel_list.size = 14;
+	}
+
+	/* send to device request */
+	ps_confirm_wait_inc(priv);
+	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
+}
+
+static void hostif_infrastructure_set2_request(struct ks_wlan_private *priv)
+{
+	struct hostif_infrastructure_set2_request_t *pp;
+	u16 capability;
+
+	DPRINTK(2, "ssid.size=%d\n", priv->reg.ssid.size);
+
+	pp = hostif_generic_request(sizeof(*pp), HIF_INFRA_SET2_REQ);
+	if (!pp)
+		return;
+
+	pp->phy_type = cpu_to_le16((uint16_t)(priv->reg.phy_type));
+	pp->cts_mode = cpu_to_le16((uint16_t)(priv->reg.cts_mode));
+	pp->scan_type = cpu_to_le16((uint16_t)(priv->reg.scan_type));
+
+	pp->rate_set.size = priv->reg.rate_set.size;
+	memcpy(&pp->rate_set.body[0], &priv->reg.rate_set.body[0],
+	       priv->reg.rate_set.size);
+	pp->ssid.size = priv->reg.ssid.size;
+	memcpy(&pp->ssid.body[0], &priv->reg.ssid.body[0], priv->reg.ssid.size);
+
+	capability = 0x0000;
+	if (priv->reg.preamble == SHORT_PREAMBLE) {
+		/* short preamble */
+		capability |= BSS_CAP_SHORT_PREAMBLE;
+	}
+	capability &= ~(BSS_CAP_PBCC);	/* pbcc not support */
+	if (priv->reg.phy_type != D_11B_ONLY_MODE) {
+		capability |= BSS_CAP_SHORT_SLOT_TIME;	/* ShortSlotTime support */
+		capability &= ~(BSS_CAP_DSSS_OFDM);	/* DSSS OFDM not support */
+	}
+	pp->capability = cpu_to_le16((uint16_t)capability);
+	pp->beacon_lost_count =
+	    cpu_to_le16((uint16_t)(priv->reg.beacon_lost_count));
+	pp->auth_type = cpu_to_le16((uint16_t)(priv->reg.authenticate_type));
+
+	pp->channel_list.body[0] = 1;
+	pp->channel_list.body[1] = 8;
+	pp->channel_list.body[2] = 2;
+	pp->channel_list.body[3] = 9;
+	pp->channel_list.body[4] = 3;
+	pp->channel_list.body[5] = 10;
+	pp->channel_list.body[6] = 4;
+	pp->channel_list.body[7] = 11;
+	pp->channel_list.body[8] = 5;
+	pp->channel_list.body[9] = 12;
+	pp->channel_list.body[10] = 6;
+	pp->channel_list.body[11] = 13;
+	pp->channel_list.body[12] = 7;
+	if (priv->reg.phy_type == D_11G_ONLY_MODE) {
+		pp->channel_list.size = 13;
+	} else {
+		pp->channel_list.body[13] = 14;
+		pp->channel_list.size = 14;
+	}
+
+	memcpy(pp->bssid, priv->reg.bssid, ETH_ALEN);
+
+	/* send to device request */
+	ps_confirm_wait_inc(priv);
+	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
+}
+
+static
+void hostif_adhoc_set_request(struct ks_wlan_private *priv)
+{
+	struct hostif_adhoc_set_request_t *pp;
+	u16 capability;
+
+	DPRINTK(3, "\n");
+
+	pp = hostif_generic_request(sizeof(*pp), HIF_ADH_SET_REQ);
+	if (!pp)
+		return;
+
+	pp->phy_type = cpu_to_le16((uint16_t)(priv->reg.phy_type));
+	pp->cts_mode = cpu_to_le16((uint16_t)(priv->reg.cts_mode));
+	pp->scan_type = cpu_to_le16((uint16_t)(priv->reg.scan_type));
+	pp->channel = cpu_to_le16((uint16_t)(priv->reg.channel));
+	pp->rate_set.size = priv->reg.rate_set.size;
+	memcpy(&pp->rate_set.body[0], &priv->reg.rate_set.body[0],
+	       priv->reg.rate_set.size);
+	pp->ssid.size = priv->reg.ssid.size;
+	memcpy(&pp->ssid.body[0], &priv->reg.ssid.body[0], priv->reg.ssid.size);
+
+	capability = 0x0000;
+	if (priv->reg.preamble == SHORT_PREAMBLE) {
+		/* short preamble */
+		capability |= BSS_CAP_SHORT_PREAMBLE;
+	}
+	capability &= ~(BSS_CAP_PBCC);	/* pbcc not support */
+	if (priv->reg.phy_type != D_11B_ONLY_MODE) {
+		capability |= BSS_CAP_SHORT_SLOT_TIME;	/* ShortSlotTime support */
+		capability &= ~(BSS_CAP_DSSS_OFDM);	/* DSSS OFDM not support */
+	}
+	pp->capability = cpu_to_le16((uint16_t)capability);
+
+	/* send to device request */
+	ps_confirm_wait_inc(priv);
+	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
+}
+
+static
+void hostif_adhoc_set2_request(struct ks_wlan_private *priv)
+{
+	struct hostif_adhoc_set2_request_t *pp;
+	u16 capability;
+
+	DPRINTK(3, "\n");
+
+	pp = hostif_generic_request(sizeof(*pp), HIF_ADH_SET_REQ);
+	if (!pp)
+		return;
+
+	pp->phy_type = cpu_to_le16((uint16_t)(priv->reg.phy_type));
+	pp->cts_mode = cpu_to_le16((uint16_t)(priv->reg.cts_mode));
+	pp->scan_type = cpu_to_le16((uint16_t)(priv->reg.scan_type));
+	pp->rate_set.size = priv->reg.rate_set.size;
+	memcpy(&pp->rate_set.body[0], &priv->reg.rate_set.body[0],
+	       priv->reg.rate_set.size);
+	pp->ssid.size = priv->reg.ssid.size;
+	memcpy(&pp->ssid.body[0], &priv->reg.ssid.body[0], priv->reg.ssid.size);
+
+	capability = 0x0000;
+	if (priv->reg.preamble == SHORT_PREAMBLE) {
+		/* short preamble */
+		capability |= BSS_CAP_SHORT_PREAMBLE;
+	}
+	capability &= ~(BSS_CAP_PBCC);	/* pbcc not support */
+	if (priv->reg.phy_type != D_11B_ONLY_MODE) {
+		capability |= BSS_CAP_SHORT_SLOT_TIME;	/* ShortSlotTime support */
+		capability &= ~(BSS_CAP_DSSS_OFDM);	/* DSSS OFDM not support */
+	}
+	pp->capability = cpu_to_le16((uint16_t)capability);
+
+	pp->channel_list.body[0] = priv->reg.channel;
+	pp->channel_list.size = 1;
+	memcpy(pp->bssid, priv->reg.bssid, ETH_ALEN);
+
+	/* send to device request */
+	ps_confirm_wait_inc(priv);
+	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
+}
+
+static
+void hostif_stop_request(struct ks_wlan_private *priv)
+{
+	struct hostif_stop_request_t *pp;
+
+	DPRINTK(3, "\n");
+
+	pp = hostif_generic_request(sizeof(*pp), HIF_STOP_REQ);
+	if (!pp)
+		return;
+
+	/* send to device request */
+	ps_confirm_wait_inc(priv);
+	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
+}
+
+static
+void hostif_phy_information_request(struct ks_wlan_private *priv)
+{
+	struct hostif_phy_information_request_t *pp;
+
+	DPRINTK(3, "\n");
+
+	pp = hostif_generic_request(sizeof(*pp), HIF_PHY_INFO_REQ);
+	if (!pp)
+		return;
+
+	if (priv->reg.phy_info_timer) {
+		pp->type = cpu_to_le16((uint16_t)TIME_TYPE);
+		pp->time = cpu_to_le16((uint16_t)(priv->reg.phy_info_timer));
+	} else {
+		pp->type = cpu_to_le16((uint16_t)NORMAL_TYPE);
+		pp->time = cpu_to_le16((uint16_t)0);
+	}
+
+	/* send to device request */
+	ps_confirm_wait_inc(priv);
+	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
+}
+
+static
+void hostif_power_mgmt_request(struct ks_wlan_private *priv,
+			       unsigned long mode, unsigned long wake_up,
+			       unsigned long receiveDTIMs)
+{
+	struct hostif_power_mgmt_request_t *pp;
+
+	DPRINTK(3, "mode=%lu wake_up=%lu receiveDTIMs=%lu\n", mode, wake_up,
+		receiveDTIMs);
+
+	pp = hostif_generic_request(sizeof(*pp), HIF_POWER_MGMT_REQ);
+	if (!pp)
+		return;
+
+	pp->mode = cpu_to_le32((uint32_t)mode);
+	pp->wake_up = cpu_to_le32((uint32_t)wake_up);
+	pp->receiveDTIMs = cpu_to_le32((uint32_t)receiveDTIMs);
+
+	/* send to device request */
+	ps_confirm_wait_inc(priv);
+	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
+}
+
+static
+void hostif_sleep_request(struct ks_wlan_private *priv,
+			  enum sleep_mode_type mode)
+{
+	struct hostif_sleep_request_t *pp;
+
+	DPRINTK(3, "mode=%lu\n", (long)mode);
+
+	if (mode == SLP_SLEEP) {
+		pp = hostif_generic_request(sizeof(*pp), HIF_SLEEP_REQ);
+		if (!pp)
+			return;
+
+		/* send to device request */
+		ps_confirm_wait_inc(priv);
+		ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL,
+			      NULL);
+	} else if (mode == SLP_ACTIVE) {
+		atomic_set(&priv->sleepstatus.wakeup_request, 1);
+		queue_delayed_work(priv->wq, &priv->rw_dwork, 1);
+	} else {
+		DPRINTK(3, "invalid mode %ld\n", (long)mode);
+		return;
+	}
+}
+
+static
+void hostif_bss_scan_request(struct ks_wlan_private *priv,
+			     unsigned long scan_type, uint8_t *scan_ssid,
+			     uint8_t scan_ssid_len)
+{
+	struct hostif_bss_scan_request_t *pp;
+
+	DPRINTK(2, "\n");
+
+	pp = hostif_generic_request(sizeof(*pp), HIF_SCAN_REQ);
+	if (!pp)
+		return;
+
+	pp->scan_type = scan_type;
+
+	pp->ch_time_min = cpu_to_le32((uint32_t)110);	/* default value */
+	pp->ch_time_max = cpu_to_le32((uint32_t)130);	/* default value */
+	pp->channel_list.body[0] = 1;
+	pp->channel_list.body[1] = 8;
+	pp->channel_list.body[2] = 2;
+	pp->channel_list.body[3] = 9;
+	pp->channel_list.body[4] = 3;
+	pp->channel_list.body[5] = 10;
+	pp->channel_list.body[6] = 4;
+	pp->channel_list.body[7] = 11;
+	pp->channel_list.body[8] = 5;
+	pp->channel_list.body[9] = 12;
+	pp->channel_list.body[10] = 6;
+	pp->channel_list.body[11] = 13;
+	pp->channel_list.body[12] = 7;
+	if (priv->reg.phy_type == D_11G_ONLY_MODE) {
+		pp->channel_list.size = 13;
+	} else {
+		pp->channel_list.body[13] = 14;
+		pp->channel_list.size = 14;
+	}
+	pp->ssid.size = 0;
+
+	/* specified SSID SCAN */
+	if (scan_ssid_len > 0 && scan_ssid_len <= 32) {
+		pp->ssid.size = scan_ssid_len;
+		memcpy(&pp->ssid.body[0], scan_ssid, scan_ssid_len);
+	}
+
+	/* send to device request */
+	ps_confirm_wait_inc(priv);
+	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
+
+	priv->aplist.size = 0;
+	priv->scan_ind_count = 0;
+}
+
+static
+void hostif_mic_failure_request(struct ks_wlan_private *priv,
+				unsigned short failure_count,
+				unsigned short timer)
+{
+	struct hostif_mic_failure_request_t *pp;
+
+	DPRINTK(3, "count=%d :: timer=%d\n", failure_count, timer);
+
+	pp = hostif_generic_request(sizeof(*pp), HIF_MIC_FAILURE_REQ);
+	if (!pp)
+		return;
+
+	pp->failure_count = cpu_to_le16((uint16_t)failure_count);
+	pp->timer = cpu_to_le16((uint16_t)timer);
+
+	/* send to device request */
+	ps_confirm_wait_inc(priv);
+	ks_wlan_hw_tx(priv, pp, hif_align_size(sizeof(*pp)), NULL, NULL);
+}
+
+/* Device I/O Receive indicate */
+static void devio_rec_ind(struct ks_wlan_private *priv, unsigned char *p,
+			  unsigned int size)
+{
+	if (priv->device_open_status) {
+		spin_lock(&priv->dev_read_lock);	/* request spin lock */
+		priv->dev_data[atomic_read(&priv->rec_count)] = p;
+		priv->dev_size[atomic_read(&priv->rec_count)] = size;
+
+		if (atomic_read(&priv->event_count) != DEVICE_STOCK_COUNT) {
+			/* rx event count inc */
+			atomic_inc(&priv->event_count);
+		}
+		atomic_inc(&priv->rec_count);
+		if (atomic_read(&priv->rec_count) == DEVICE_STOCK_COUNT)
+			atomic_set(&priv->rec_count, 0);
+
+		wake_up_interruptible_all(&priv->devread_wait);
+
+		/* release spin lock */
+		spin_unlock(&priv->dev_read_lock);
+	}
+}
+
+void hostif_receive(struct ks_wlan_private *priv, unsigned char *p,
+		    unsigned int size)
+{
+	DPRINTK(4, "\n");
+
+	devio_rec_ind(priv, p, size);
+
+	priv->rxp = p;
+	priv->rx_size = size;
+
+	if (get_WORD(priv) == priv->rx_size) {	/* length check !! */
+		hostif_event_check(priv);	/* event check */
+	}
+}
+
+static
+void hostif_sme_set_wep(struct ks_wlan_private *priv, int type)
+{
+	u32 val;
+
+	switch (type) {
+	case SME_WEP_INDEX_REQUEST:
+		val = cpu_to_le32((uint32_t)(priv->reg.wep_index));
+		hostif_mib_set_request(priv, DOT11_WEP_DEFAULT_KEY_ID,
+				       sizeof(val), MIB_VALUE_TYPE_INT, &val);
+		break;
+	case SME_WEP_KEY1_REQUEST:
+		if (!priv->wpa.wpa_enabled)
+			hostif_mib_set_request(priv,
+					       DOT11_WEP_DEFAULT_KEY_VALUE1,
+					       priv->reg.wep_key[0].size,
+					       MIB_VALUE_TYPE_OSTRING,
+					       &priv->reg.wep_key[0].val[0]);
+		break;
+	case SME_WEP_KEY2_REQUEST:
+		if (!priv->wpa.wpa_enabled)
+			hostif_mib_set_request(priv,
+					       DOT11_WEP_DEFAULT_KEY_VALUE2,
+					       priv->reg.wep_key[1].size,
+					       MIB_VALUE_TYPE_OSTRING,
+					       &priv->reg.wep_key[1].val[0]);
+		break;
+	case SME_WEP_KEY3_REQUEST:
+		if (!priv->wpa.wpa_enabled)
+			hostif_mib_set_request(priv,
+					       DOT11_WEP_DEFAULT_KEY_VALUE3,
+					       priv->reg.wep_key[2].size,
+					       MIB_VALUE_TYPE_OSTRING,
+					       &priv->reg.wep_key[2].val[0]);
+		break;
+	case SME_WEP_KEY4_REQUEST:
+		if (!priv->wpa.wpa_enabled)
+			hostif_mib_set_request(priv,
+					       DOT11_WEP_DEFAULT_KEY_VALUE4,
+					       priv->reg.wep_key[3].size,
+					       MIB_VALUE_TYPE_OSTRING,
+					       &priv->reg.wep_key[3].val[0]);
+		break;
+	case SME_WEP_FLAG_REQUEST:
+		val = cpu_to_le32((uint32_t)(priv->reg.privacy_invoked));
+		hostif_mib_set_request(priv, DOT11_PRIVACY_INVOKED,
+				       sizeof(val), MIB_VALUE_TYPE_BOOL, &val);
+		break;
+	}
+}
+
+struct wpa_suite_t {
+	unsigned short size;
+	unsigned char suite[4][CIPHER_ID_LEN];
+} __packed;
+
+struct rsn_mode_t {
+	u32 rsn_mode;
+	u16 rsn_capability;
+} __packed;
+
+static
+void hostif_sme_set_rsn(struct ks_wlan_private *priv, int type)
+{
+	struct wpa_suite_t wpa_suite;
+	struct rsn_mode_t rsn_mode;
+	u32 val;
+
+	memset(&wpa_suite, 0, sizeof(wpa_suite));
+
+	switch (type) {
+	case SME_RSN_UCAST_REQUEST:
+		wpa_suite.size = cpu_to_le16((uint16_t)1);
+		switch (priv->wpa.pairwise_suite) {
+		case IW_AUTH_CIPHER_NONE:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA2_NONE, CIPHER_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA_NONE, CIPHER_ID_LEN);
+			break;
+		case IW_AUTH_CIPHER_WEP40:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA2_WEP40, CIPHER_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA_WEP40, CIPHER_ID_LEN);
+			break;
+		case IW_AUTH_CIPHER_TKIP:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA2_TKIP, CIPHER_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA_TKIP, CIPHER_ID_LEN);
+			break;
+		case IW_AUTH_CIPHER_CCMP:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA2_CCMP, CIPHER_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA_CCMP, CIPHER_ID_LEN);
+			break;
+		case IW_AUTH_CIPHER_WEP104:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA2_WEP104, CIPHER_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA_WEP104, CIPHER_ID_LEN);
+			break;
+		}
+
+		hostif_mib_set_request(priv, DOT11_RSN_CONFIG_UNICAST_CIPHER,
+				       sizeof(wpa_suite.size) +
+				       CIPHER_ID_LEN * wpa_suite.size,
+				       MIB_VALUE_TYPE_OSTRING, &wpa_suite);
+		break;
+	case SME_RSN_MCAST_REQUEST:
+		switch (priv->wpa.group_suite) {
+		case IW_AUTH_CIPHER_NONE:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA2_NONE, CIPHER_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA_NONE, CIPHER_ID_LEN);
+			break;
+		case IW_AUTH_CIPHER_WEP40:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA2_WEP40, CIPHER_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA_WEP40, CIPHER_ID_LEN);
+			break;
+		case IW_AUTH_CIPHER_TKIP:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA2_TKIP, CIPHER_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA_TKIP, CIPHER_ID_LEN);
+			break;
+		case IW_AUTH_CIPHER_CCMP:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA2_CCMP, CIPHER_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA_CCMP, CIPHER_ID_LEN);
+			break;
+		case IW_AUTH_CIPHER_WEP104:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA2_WEP104, CIPHER_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       CIPHER_ID_WPA_WEP104, CIPHER_ID_LEN);
+			break;
+		}
+
+		hostif_mib_set_request(priv, DOT11_RSN_CONFIG_MULTICAST_CIPHER,
+				       CIPHER_ID_LEN, MIB_VALUE_TYPE_OSTRING,
+				       &wpa_suite.suite[0][0]);
+		break;
+	case SME_RSN_AUTH_REQUEST:
+		wpa_suite.size = cpu_to_le16((uint16_t)1);
+		switch (priv->wpa.key_mgmt_suite) {
+		case IW_AUTH_KEY_MGMT_802_1X:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       KEY_MGMT_ID_WPA2_1X, KEY_MGMT_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       KEY_MGMT_ID_WPA_1X, KEY_MGMT_ID_LEN);
+			break;
+		case IW_AUTH_KEY_MGMT_PSK:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       KEY_MGMT_ID_WPA2_PSK, KEY_MGMT_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       KEY_MGMT_ID_WPA_PSK, KEY_MGMT_ID_LEN);
+			break;
+		case 0:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       KEY_MGMT_ID_WPA2_NONE, KEY_MGMT_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       KEY_MGMT_ID_WPA_NONE, KEY_MGMT_ID_LEN);
+			break;
+		case 4:
+			if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2)
+				memcpy(&wpa_suite.suite[0][0],
+				       KEY_MGMT_ID_WPA2_WPANONE,
+				       KEY_MGMT_ID_LEN);
+			else
+				memcpy(&wpa_suite.suite[0][0],
+				       KEY_MGMT_ID_WPA_WPANONE,
+				       KEY_MGMT_ID_LEN);
+			break;
+		}
+
+		hostif_mib_set_request(priv, DOT11_RSN_CONFIG_AUTH_SUITE,
+				       sizeof(wpa_suite.size) +
+				       KEY_MGMT_ID_LEN * wpa_suite.size,
+				       MIB_VALUE_TYPE_OSTRING, &wpa_suite);
+		break;
+	case SME_RSN_ENABLED_REQUEST:
+		val = cpu_to_le32((uint32_t)(priv->wpa.rsn_enabled));
+		hostif_mib_set_request(priv, DOT11_RSN_ENABLED,
+				       sizeof(val), MIB_VALUE_TYPE_BOOL, &val);
+		break;
+	case SME_RSN_MODE_REQUEST:
+		if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA2) {
+			rsn_mode.rsn_mode =
+			    cpu_to_le32((uint32_t)RSN_MODE_WPA2);
+			rsn_mode.rsn_capability = cpu_to_le16((uint16_t)0);
+		} else if (priv->wpa.version == IW_AUTH_WPA_VERSION_WPA) {
+			rsn_mode.rsn_mode =
+			    cpu_to_le32((uint32_t)RSN_MODE_WPA);
+			rsn_mode.rsn_capability = cpu_to_le16((uint16_t)0);
+		} else {
+			rsn_mode.rsn_mode =
+			    cpu_to_le32((uint32_t)RSN_MODE_NONE);
+			rsn_mode.rsn_capability = cpu_to_le16((uint16_t)0);
+		}
+		hostif_mib_set_request(priv, LOCAL_RSN_MODE, sizeof(rsn_mode),
+				       MIB_VALUE_TYPE_OSTRING, &rsn_mode);
+		break;
+	}
+}
+
+static
+void hostif_sme_mode_setup(struct ks_wlan_private *priv)
+{
+	unsigned char rate_size;
+	unsigned char rate_octet[RATE_SET_MAX_SIZE];
+	int i = 0;
+
+	/* rate setting if rate segging is auto for changing phy_type (#94) */
+	if (priv->reg.tx_rate == TX_RATE_FULL_AUTO) {
+		if (priv->reg.phy_type == D_11B_ONLY_MODE) {
+			priv->reg.rate_set.body[3] = TX_RATE_11M;
+			priv->reg.rate_set.body[2] = TX_RATE_5M;
+			priv->reg.rate_set.body[1] = TX_RATE_2M | BASIC_RATE;
+			priv->reg.rate_set.body[0] = TX_RATE_1M | BASIC_RATE;
+			priv->reg.rate_set.size = 4;
+		} else {	/* D_11G_ONLY_MODE or D_11BG_COMPATIBLE_MODE */
+			priv->reg.rate_set.body[11] = TX_RATE_54M;
+			priv->reg.rate_set.body[10] = TX_RATE_48M;
+			priv->reg.rate_set.body[9] = TX_RATE_36M;
+			priv->reg.rate_set.body[8] = TX_RATE_18M;
+			priv->reg.rate_set.body[7] = TX_RATE_9M;
+			priv->reg.rate_set.body[6] = TX_RATE_24M | BASIC_RATE;
+			priv->reg.rate_set.body[5] = TX_RATE_12M | BASIC_RATE;
+			priv->reg.rate_set.body[4] = TX_RATE_6M | BASIC_RATE;
+			priv->reg.rate_set.body[3] = TX_RATE_11M | BASIC_RATE;
+			priv->reg.rate_set.body[2] = TX_RATE_5M | BASIC_RATE;
+			priv->reg.rate_set.body[1] = TX_RATE_2M | BASIC_RATE;
+			priv->reg.rate_set.body[0] = TX_RATE_1M | BASIC_RATE;
+			priv->reg.rate_set.size = 12;
+		}
+	}
+
+	/* rate mask by phy setting */
+	if (priv->reg.phy_type == D_11B_ONLY_MODE) {
+		for (i = 0; i < priv->reg.rate_set.size; i++) {
+			if (!IS_11B_RATE(priv->reg.rate_set.body[i]))
+				break;
+
+			if ((priv->reg.rate_set.body[i] & RATE_MASK) >= TX_RATE_5M) {
+				rate_octet[i] = priv->reg.rate_set.body[i] &
+						RATE_MASK;
+			} else {
+				rate_octet[i] = priv->reg.rate_set.body[i];
+			}
+		}
+
+	} else {	/* D_11G_ONLY_MODE or D_11BG_COMPATIBLE_MODE */
+		for (i = 0; i < priv->reg.rate_set.size; i++) {
+			if (!IS_11BG_RATE(priv->reg.rate_set.body[i]))
+				break;
+
+			if (IS_OFDM_EXT_RATE(priv->reg.rate_set.body[i])) {
+				rate_octet[i] = priv->reg.rate_set.body[i] &
+						RATE_MASK;
+			} else {
+				rate_octet[i] = priv->reg.rate_set.body[i];
+			}
+		}
+	}
+	rate_size = i;
+	if (rate_size == 0) {
+		if (priv->reg.phy_type == D_11G_ONLY_MODE)
+			rate_octet[0] = TX_RATE_6M | BASIC_RATE;
+		else
+			rate_octet[0] = TX_RATE_2M | BASIC_RATE;
+		rate_size = 1;
+	}
+
+	/* rate set update */
+	priv->reg.rate_set.size = rate_size;
+	memcpy(&priv->reg.rate_set.body[0], &rate_octet[0], rate_size);
+
+	switch (priv->reg.operation_mode) {
+	case MODE_PSEUDO_ADHOC:
+		/* Pseudo Ad-Hoc mode */
+		hostif_ps_adhoc_set_request(priv);
+		break;
+	case MODE_INFRASTRUCTURE:
+		/* Infrastructure mode */
+		if (!is_valid_ether_addr((u8 *)priv->reg.bssid)) {
+			hostif_infrastructure_set_request(priv);
+		} else {
+			hostif_infrastructure_set2_request(priv);
+			DPRINTK(2,
+				"Infra bssid = %pM\n", priv->reg.bssid);
+		}
+		break;
+	case MODE_ADHOC:
+		/* IEEE802.11 Ad-Hoc mode */
+		if (!is_valid_ether_addr((u8 *)priv->reg.bssid)) {
+			hostif_adhoc_set_request(priv);
+		} else {
+			hostif_adhoc_set2_request(priv);
+			DPRINTK(2,
+				"Adhoc bssid = %pM\n", priv->reg.bssid);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static
+void hostif_sme_multicast_set(struct ks_wlan_private *priv)
+{
+	struct net_device *dev = priv->net_dev;
+	int mc_count;
+	struct netdev_hw_addr *ha;
+	char set_address[NIC_MAX_MCAST_LIST * ETH_ALEN];
+	unsigned long filter_type;
+	int i = 0;
+
+	DPRINTK(3, "\n");
+
+	spin_lock(&priv->multicast_spin);
+
+	memset(set_address, 0, NIC_MAX_MCAST_LIST * ETH_ALEN);
+
+	if (dev->flags & IFF_PROMISC) {
+		filter_type = cpu_to_le32((uint32_t)MCAST_FILTER_PROMISC);
+		hostif_mib_set_request(priv, LOCAL_MULTICAST_FILTER,
+				       sizeof(filter_type), MIB_VALUE_TYPE_BOOL,
+				       &filter_type);
+		goto spin_unlock;
+	}
+
+	if ((netdev_mc_count(dev) > NIC_MAX_MCAST_LIST) ||
+	    (dev->flags & IFF_ALLMULTI)) {
+		filter_type = cpu_to_le32((uint32_t)MCAST_FILTER_MCASTALL);
+		hostif_mib_set_request(priv, LOCAL_MULTICAST_FILTER,
+				       sizeof(filter_type), MIB_VALUE_TYPE_BOOL,
+				       &filter_type);
+		goto spin_unlock;
+	}
+
+	if (priv->sme_i.sme_flag & SME_MULTICAST) {
+		mc_count = netdev_mc_count(dev);
+		netdev_for_each_mc_addr(ha, dev) {
+			memcpy(&set_address[i * ETH_ALEN], ha->addr, ETH_ALEN);
+			i++;
+		}
+		priv->sme_i.sme_flag &= ~SME_MULTICAST;
+		hostif_mib_set_request(priv, LOCAL_MULTICAST_ADDRESS,
+				       ETH_ALEN * mc_count,
+				       MIB_VALUE_TYPE_OSTRING,
+				       &set_address[0]);
+	} else {
+		filter_type = cpu_to_le32((uint32_t)MCAST_FILTER_MCAST);
+		priv->sme_i.sme_flag |= SME_MULTICAST;
+		hostif_mib_set_request(priv, LOCAL_MULTICAST_FILTER,
+				       sizeof(filter_type), MIB_VALUE_TYPE_BOOL,
+				       &filter_type);
+	}
+
+spin_unlock:
+	spin_unlock(&priv->multicast_spin);
+}
+
+static
+void hostif_sme_power_mgmt_set(struct ks_wlan_private *priv)
+{
+	unsigned long mode, wake_up, receiveDTIMs;
+
+	DPRINTK(3, "\n");
+	switch (priv->reg.power_mgmt) {
+	case POWER_MGMT_ACTIVE:
+		mode = POWER_ACTIVE;
+		wake_up = 0;
+		receiveDTIMs = 0;
+		break;
+	case POWER_MGMT_SAVE1:
+		if (priv->reg.operation_mode == MODE_INFRASTRUCTURE) {
+			mode = POWER_SAVE;
+			wake_up = 0;
+			receiveDTIMs = 0;
+		} else {
+			mode = POWER_ACTIVE;
+			wake_up = 0;
+			receiveDTIMs = 0;
+		}
+		break;
+	case POWER_MGMT_SAVE2:
+		if (priv->reg.operation_mode == MODE_INFRASTRUCTURE) {
+			mode = POWER_SAVE;
+			wake_up = 0;
+			receiveDTIMs = 1;
+		} else {
+			mode = POWER_ACTIVE;
+			wake_up = 0;
+			receiveDTIMs = 0;
+		}
+		break;
+	default:
+		mode = POWER_ACTIVE;
+		wake_up = 0;
+		receiveDTIMs = 0;
+		break;
+	}
+	hostif_power_mgmt_request(priv, mode, wake_up, receiveDTIMs);
+}
+
+static
+void hostif_sme_sleep_set(struct ks_wlan_private *priv)
+{
+	DPRINTK(3, "\n");
+	switch (priv->sleep_mode) {
+	case SLP_SLEEP:
+		hostif_sleep_request(priv, priv->sleep_mode);
+		break;
+	case SLP_ACTIVE:
+		hostif_sleep_request(priv, priv->sleep_mode);
+		break;
+	default:
+		break;
+	}
+}
+
+static
+void hostif_sme_set_key(struct ks_wlan_private *priv, int type)
+{
+	u32 val;
+
+	switch (type) {
+	case SME_SET_FLAG:
+		val = cpu_to_le32((uint32_t)(priv->reg.privacy_invoked));
+		hostif_mib_set_request(priv, DOT11_PRIVACY_INVOKED,
+				       sizeof(val), MIB_VALUE_TYPE_BOOL, &val);
+		break;
+	case SME_SET_TXKEY:
+		val = cpu_to_le32((uint32_t)(priv->wpa.txkey));
+		hostif_mib_set_request(priv, DOT11_WEP_DEFAULT_KEY_ID,
+				       sizeof(val), MIB_VALUE_TYPE_INT, &val);
+		break;
+	case SME_SET_KEY1:
+		hostif_mib_set_request(priv, DOT11_WEP_DEFAULT_KEY_VALUE1,
+				       priv->wpa.key[0].key_len,
+				       MIB_VALUE_TYPE_OSTRING,
+				       &priv->wpa.key[0].key_val[0]);
+		break;
+	case SME_SET_KEY2:
+		hostif_mib_set_request(priv, DOT11_WEP_DEFAULT_KEY_VALUE2,
+				       priv->wpa.key[1].key_len,
+				       MIB_VALUE_TYPE_OSTRING,
+				       &priv->wpa.key[1].key_val[0]);
+		break;
+	case SME_SET_KEY3:
+		hostif_mib_set_request(priv, DOT11_WEP_DEFAULT_KEY_VALUE3,
+				       priv->wpa.key[2].key_len,
+				       MIB_VALUE_TYPE_OSTRING,
+				       &priv->wpa.key[2].key_val[0]);
+		break;
+	case SME_SET_KEY4:
+		hostif_mib_set_request(priv, DOT11_WEP_DEFAULT_KEY_VALUE4,
+				       priv->wpa.key[3].key_len,
+				       MIB_VALUE_TYPE_OSTRING,
+				       &priv->wpa.key[3].key_val[0]);
+		break;
+	case SME_SET_PMK_TSC:
+		hostif_mib_set_request(priv, DOT11_PMK_TSC,
+				       WPA_RX_SEQ_LEN, MIB_VALUE_TYPE_OSTRING,
+				       &priv->wpa.key[0].rx_seq[0]);
+		break;
+	case SME_SET_GMK1_TSC:
+		hostif_mib_set_request(priv, DOT11_GMK1_TSC,
+				       WPA_RX_SEQ_LEN, MIB_VALUE_TYPE_OSTRING,
+				       &priv->wpa.key[1].rx_seq[0]);
+		break;
+	case SME_SET_GMK2_TSC:
+		hostif_mib_set_request(priv, DOT11_GMK2_TSC,
+				       WPA_RX_SEQ_LEN, MIB_VALUE_TYPE_OSTRING,
+				       &priv->wpa.key[2].rx_seq[0]);
+		break;
+	}
+}
+
+static
+void hostif_sme_set_pmksa(struct ks_wlan_private *priv)
+{
+	struct pmk_cache_t {
+		u16 size;
+		struct {
+			u8 bssid[ETH_ALEN];
+			u8 pmkid[IW_PMKID_LEN];
+		} __packed list[PMK_LIST_MAX];
+	} __packed pmkcache;
+	struct pmk_t *pmk;
+	int i;
+
+	DPRINTK(4, "pmklist.size=%d\n", priv->pmklist.size);
+	i = 0;
+	list_for_each_entry(pmk, &priv->pmklist.head, list) {
+		if (i < PMK_LIST_MAX) {
+			memcpy(pmkcache.list[i].bssid, pmk->bssid, ETH_ALEN);
+			memcpy(pmkcache.list[i].pmkid, pmk->pmkid,
+			       IW_PMKID_LEN);
+			i++;
+		}
+	}
+	pmkcache.size = cpu_to_le16((uint16_t)(priv->pmklist.size));
+	hostif_mib_set_request(priv, LOCAL_PMK,
+			       sizeof(priv->pmklist.size) + (ETH_ALEN +
+							     IW_PMKID_LEN) *
+			       (priv->pmklist.size), MIB_VALUE_TYPE_OSTRING,
+			       &pmkcache);
+}
+
+/* execute sme */
+static
+void hostif_sme_execute(struct ks_wlan_private *priv, int event)
+{
+	u32 val;
+
+	DPRINTK(3, "event=%d\n", event);
+	switch (event) {
+	case SME_START:
+		if (priv->dev_state == DEVICE_STATE_BOOT)
+			hostif_mib_get_request(priv, DOT11_MAC_ADDRESS);
+		break;
+	case SME_MULTICAST_REQUEST:
+		hostif_sme_multicast_set(priv);
+		break;
+	case SME_MACADDRESS_SET_REQUEST:
+		hostif_mib_set_request(priv, LOCAL_CURRENTADDRESS, ETH_ALEN,
+				       MIB_VALUE_TYPE_OSTRING,
+				       &priv->eth_addr[0]);
+		break;
+	case SME_BSS_SCAN_REQUEST:
+		hostif_bss_scan_request(priv, priv->reg.scan_type,
+					priv->scan_ssid, priv->scan_ssid_len);
+		break;
+	case SME_POW_MNGMT_REQUEST:
+		hostif_sme_power_mgmt_set(priv);
+		break;
+	case SME_PHY_INFO_REQUEST:
+		hostif_phy_information_request(priv);
+		break;
+	case SME_MIC_FAILURE_REQUEST:
+		if (priv->wpa.mic_failure.failure == 1) {
+			hostif_mic_failure_request(priv,
+						   priv->wpa.mic_failure.failure - 1,
+						   0);
+		} else if (priv->wpa.mic_failure.failure == 2) {
+			hostif_mic_failure_request(priv,
+						   priv->wpa.mic_failure.failure - 1,
+						   priv->wpa.mic_failure.counter);
+		} else {
+			DPRINTK(4, "SME_MIC_FAILURE_REQUEST: failure count=%u error?\n",
+				priv->wpa.mic_failure.failure);
+		}
+		break;
+	case SME_MIC_FAILURE_CONFIRM:
+		if (priv->wpa.mic_failure.failure == 2) {
+			if (priv->wpa.mic_failure.stop)
+				priv->wpa.mic_failure.stop = 0;
+			priv->wpa.mic_failure.failure = 0;
+			hostif_start_request(priv, priv->reg.operation_mode);
+		}
+		break;
+	case SME_GET_MAC_ADDRESS:
+		if (priv->dev_state == DEVICE_STATE_BOOT)
+			hostif_mib_get_request(priv, DOT11_PRODUCT_VERSION);
+		break;
+	case SME_GET_PRODUCT_VERSION:
+		if (priv->dev_state == DEVICE_STATE_BOOT)
+			priv->dev_state = DEVICE_STATE_PREINIT;
+		break;
+	case SME_STOP_REQUEST:
+		hostif_stop_request(priv);
+		break;
+	case SME_RTS_THRESHOLD_REQUEST:
+		val = cpu_to_le32((uint32_t)(priv->reg.rts));
+		hostif_mib_set_request(priv, DOT11_RTS_THRESHOLD,
+				       sizeof(val), MIB_VALUE_TYPE_INT, &val);
+		break;
+	case SME_FRAGMENTATION_THRESHOLD_REQUEST:
+		val = cpu_to_le32((uint32_t)(priv->reg.fragment));
+		hostif_mib_set_request(priv, DOT11_FRAGMENTATION_THRESHOLD,
+				       sizeof(val), MIB_VALUE_TYPE_INT, &val);
+		break;
+	case SME_WEP_INDEX_REQUEST:
+	case SME_WEP_KEY1_REQUEST:
+	case SME_WEP_KEY2_REQUEST:
+	case SME_WEP_KEY3_REQUEST:
+	case SME_WEP_KEY4_REQUEST:
+	case SME_WEP_FLAG_REQUEST:
+		hostif_sme_set_wep(priv, event);
+		break;
+	case SME_RSN_UCAST_REQUEST:
+	case SME_RSN_MCAST_REQUEST:
+	case SME_RSN_AUTH_REQUEST:
+	case SME_RSN_ENABLED_REQUEST:
+	case SME_RSN_MODE_REQUEST:
+		hostif_sme_set_rsn(priv, event);
+		break;
+	case SME_SET_FLAG:
+	case SME_SET_TXKEY:
+	case SME_SET_KEY1:
+	case SME_SET_KEY2:
+	case SME_SET_KEY3:
+	case SME_SET_KEY4:
+	case SME_SET_PMK_TSC:
+	case SME_SET_GMK1_TSC:
+	case SME_SET_GMK2_TSC:
+		hostif_sme_set_key(priv, event);
+		break;
+	case SME_SET_PMKSA:
+		hostif_sme_set_pmksa(priv);
+		break;
+#ifdef WPS
+	case SME_WPS_ENABLE_REQUEST:
+		hostif_mib_set_request(priv, LOCAL_WPS_ENABLE,
+				       sizeof(priv->wps.wps_enabled),
+				       MIB_VALUE_TYPE_INT,
+				       &priv->wps.wps_enabled);
+		break;
+	case SME_WPS_PROBE_REQUEST:
+		hostif_mib_set_request(priv, LOCAL_WPS_PROBE_REQ,
+				       priv->wps.ielen,
+				       MIB_VALUE_TYPE_OSTRING, priv->wps.ie);
+		break;
+#endif /* WPS */
+	case SME_MODE_SET_REQUEST:
+		hostif_sme_mode_setup(priv);
+		break;
+	case SME_SET_GAIN:
+		hostif_mib_set_request(priv, LOCAL_GAIN,
+				       sizeof(priv->gain),
+				       MIB_VALUE_TYPE_OSTRING, &priv->gain);
+		break;
+	case SME_GET_GAIN:
+		hostif_mib_get_request(priv, LOCAL_GAIN);
+		break;
+	case SME_GET_EEPROM_CKSUM:
+		priv->eeprom_checksum = EEPROM_FW_NOT_SUPPORT;	/* initialize */
+		hostif_mib_get_request(priv, LOCAL_EEPROM_SUM);
+		break;
+	case SME_START_REQUEST:
+		hostif_start_request(priv, priv->reg.operation_mode);
+		break;
+	case SME_START_CONFIRM:
+		/* for power save */
+		atomic_set(&priv->psstatus.snooze_guard, 0);
+		atomic_set(&priv->psstatus.confirm_wait, 0);
+		if (priv->dev_state == DEVICE_STATE_PREINIT)
+			priv->dev_state = DEVICE_STATE_INIT;
+		/* wake_up_interruptible_all(&priv->confirm_wait); */
+		complete(&priv->confirm_wait);
+		break;
+	case SME_SLEEP_REQUEST:
+		hostif_sme_sleep_set(priv);
+		break;
+	case SME_SET_REGION:
+		val = cpu_to_le32((uint32_t)(priv->region));
+		hostif_mib_set_request(priv, LOCAL_REGION,
+				       sizeof(val), MIB_VALUE_TYPE_INT, &val);
+		break;
+	case SME_MULTICAST_CONFIRM:
+	case SME_BSS_SCAN_CONFIRM:
+	case SME_POW_MNGMT_CONFIRM:
+	case SME_PHY_INFO_CONFIRM:
+	case SME_STOP_CONFIRM:
+	case SME_RTS_THRESHOLD_CONFIRM:
+	case SME_FRAGMENTATION_THRESHOLD_CONFIRM:
+	case SME_WEP_INDEX_CONFIRM:
+	case SME_WEP_KEY1_CONFIRM:
+	case SME_WEP_KEY2_CONFIRM:
+	case SME_WEP_KEY3_CONFIRM:
+	case SME_WEP_KEY4_CONFIRM:
+	case SME_WEP_FLAG_CONFIRM:
+	case SME_RSN_UCAST_CONFIRM:
+	case SME_RSN_MCAST_CONFIRM:
+	case SME_RSN_AUTH_CONFIRM:
+	case SME_RSN_ENABLED_CONFIRM:
+	case SME_RSN_MODE_CONFIRM:
+	case SME_MODE_SET_CONFIRM:
+		break;
+	case SME_TERMINATE:
+	default:
+		break;
+	}
+}
+
+static
+void hostif_sme_task(unsigned long dev)
+{
+	struct ks_wlan_private *priv = (struct ks_wlan_private *)dev;
+
+	DPRINTK(3, "\n");
+
+	if (priv->dev_state < DEVICE_STATE_BOOT)
+		return;
+
+	if (cnt_smeqbody(priv) <= 0)
+		return;
+
+	hostif_sme_execute(priv, priv->sme_i.event_buff[priv->sme_i.qhead]);
+	inc_smeqhead(priv);
+	if (cnt_smeqbody(priv) > 0)
+		tasklet_schedule(&priv->sme_task);
+}
+
+/* send to Station Management Entity module */
+void hostif_sme_enqueue(struct ks_wlan_private *priv, unsigned short event)
+{
+	DPRINTK(3, "\n");
+
+	/* enqueue sme event */
+	if (cnt_smeqbody(priv) < (SME_EVENT_BUFF_SIZE - 1)) {
+		priv->sme_i.event_buff[priv->sme_i.qtail] = event;
+		inc_smeqtail(priv);
+#ifdef KS_WLAN_DEBUG
+		if (priv->sme_i.max_event_count < cnt_smeqbody(priv))
+			priv->sme_i.max_event_count = cnt_smeqbody(priv);
+#endif /* KS_WLAN_DEBUG */
+	} else {
+		/* in case of buffer overflow */
+		netdev_err(priv->net_dev, "sme queue buffer overflow\n");
+	}
+
+	tasklet_schedule(&priv->sme_task);
+}
+
+int hostif_init(struct ks_wlan_private *priv)
+{
+	int i;
+
+	DPRINTK(3, "\n");
+
+	priv->aplist.size = 0;
+	for (i = 0; i < LOCAL_APLIST_MAX; i++)
+		memset(&priv->aplist.ap[i], 0, sizeof(struct local_ap_t));
+	priv->infra_status = 0;
+	priv->current_rate = 4;
+	priv->connect_status = DISCONNECT_STATUS;
+
+	spin_lock_init(&priv->multicast_spin);
+
+	spin_lock_init(&priv->dev_read_lock);
+	init_waitqueue_head(&priv->devread_wait);
+	priv->dev_count = 0;
+	atomic_set(&priv->event_count, 0);
+	atomic_set(&priv->rec_count, 0);
+
+	/* for power save */
+	atomic_set(&priv->psstatus.status, PS_NONE);
+	atomic_set(&priv->psstatus.confirm_wait, 0);
+	atomic_set(&priv->psstatus.snooze_guard, 0);
+	init_completion(&priv->psstatus.wakeup_wait);
+	INIT_WORK(&priv->wakeup_work, ks_wlan_hw_wakeup_task);
+
+	/* WPA */
+	memset(&priv->wpa, 0, sizeof(priv->wpa));
+	priv->wpa.rsn_enabled = 0;
+	priv->wpa.mic_failure.failure = 0;
+	priv->wpa.mic_failure.last_failure_time = 0;
+	priv->wpa.mic_failure.stop = 0;
+	memset(&priv->pmklist, 0, sizeof(priv->pmklist));
+	INIT_LIST_HEAD(&priv->pmklist.head);
+	for (i = 0; i < PMK_LIST_MAX; i++)
+		INIT_LIST_HEAD(&priv->pmklist.pmk[i].list);
+
+	priv->sme_i.sme_status = SME_IDLE;
+	priv->sme_i.qhead = 0;
+	priv->sme_i.qtail = 0;
+#ifdef KS_WLAN_DEBUG
+	priv->sme_i.max_event_count = 0;
+#endif
+	spin_lock_init(&priv->sme_i.sme_spin);
+	priv->sme_i.sme_flag = 0;
+
+	tasklet_init(&priv->sme_task, hostif_sme_task, (unsigned long)priv);
+
+	return 0;
+}
+
+void hostif_exit(struct ks_wlan_private *priv)
+{
+	tasklet_kill(&priv->sme_task);
+}
diff --git a/drivers/staging/ks7010/wext/ks_hostif.h b/drivers/staging/ks7010/wext/ks_hostif.h
new file mode 100644
index 0000000..d758076
--- /dev/null
+++ b/drivers/staging/ks7010/wext/ks_hostif.h
@@ -0,0 +1,685 @@
+/*
+ *   Driver for KeyStream wireless LAN
+ *
+ *   Copyright (c) 2005-2008 KeyStream Corp.
+ *   Copyright (C) 2009 Renesas Technology Corp.
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License version 2 as
+ *   published by the Free Software Foundation.
+ */
+
+#ifndef _KS_HOSTIF_H_
+#define _KS_HOSTIF_H_
+
+#include <linux/compiler.h>
+
+/*
+ * HOST-MAC I/F events
+ */
+#define HIF_DATA_REQ		0xE001
+#define HIF_DATA_IND		0xE801
+#define HIF_MIB_GET_REQ		0xE002
+#define HIF_MIB_GET_CONF	0xE802
+#define HIF_MIB_SET_REQ		0xE003
+#define HIF_MIB_SET_CONF	0xE803
+#define HIF_POWER_MGMT_REQ	0xE004
+#define HIF_POWER_MGMT_CONF	0xE804
+#define HIF_START_REQ		0xE005
+#define HIF_START_CONF		0xE805
+#define HIF_CONNECT_IND		0xE806
+#define HIF_STOP_REQ		0xE006
+#define HIF_STOP_CONF		0xE807
+#define HIF_PS_ADH_SET_REQ	0xE007
+#define HIF_PS_ADH_SET_CONF	0xE808
+#define HIF_INFRA_SET_REQ	0xE008
+#define HIF_INFRA_SET_CONF	0xE809
+#define HIF_ADH_SET_REQ		0xE009
+#define HIF_ADH_SET_CONF	0xE80A
+#define HIF_AP_SET_REQ		0xE00A
+#define HIF_AP_SET_CONF		0xE80B
+#define HIF_ASSOC_INFO_IND	0xE80C
+#define HIF_MIC_FAILURE_REQ	0xE00B
+#define HIF_MIC_FAILURE_CONF	0xE80D
+#define HIF_SCAN_REQ		0xE00C
+#define HIF_SCAN_CONF		0xE80E
+#define HIF_PHY_INFO_REQ	0xE00D
+#define HIF_PHY_INFO_CONF	0xE80F
+#define HIF_SLEEP_REQ		0xE00E
+#define HIF_SLEEP_CONF		0xE810
+#define HIF_PHY_INFO_IND	0xE811
+#define HIF_SCAN_IND		0xE812
+#define HIF_INFRA_SET2_REQ	0xE00F
+#define HIF_INFRA_SET2_CONF	0xE813
+#define HIF_ADH_SET2_REQ	0xE010
+#define HIF_ADH_SET2_CONF	0xE814
+
+#define HIF_REQ_MAX		0xE010
+
+/*
+ * HOST-MAC I/F data structure
+ * Byte alignmet Little Endian
+ */
+
+struct hostif_hdr {
+	u16 size;
+	u16 event;
+} __packed;
+
+struct hostif_data_request_t {
+	struct hostif_hdr header;
+	u16 auth_type;
+#define TYPE_DATA 0x0000
+#define TYPE_AUTH 0x0001
+	u16 reserved;
+	u8 data[0];
+} __packed;
+
+struct hostif_data_indication_t {
+	struct hostif_hdr header;
+	u16 auth_type;
+/* #define TYPE_DATA 0x0000 */
+#define TYPE_PMK1 0x0001
+#define TYPE_GMK1 0x0002
+#define TYPE_GMK2 0x0003
+	u16 reserved;
+	u8 data[0];
+} __packed;
+
+#define CHANNEL_LIST_MAX_SIZE 14
+struct channel_list_t {
+	u8 size;
+	u8 body[CHANNEL_LIST_MAX_SIZE];
+	u8 pad;
+} __packed;
+
+/* MIB Attribute */
+#define DOT11_MAC_ADDRESS                 0x21010100	/* MAC Address (R) */
+#define DOT11_PRODUCT_VERSION             0x31024100	/* FirmWare Version (R) */
+#define DOT11_RTS_THRESHOLD               0x21020100	/* RTS Threshold (R/W) */
+#define DOT11_FRAGMENTATION_THRESHOLD     0x21050100	/* Fragment Threshold (R/W) */
+#define DOT11_PRIVACY_INVOKED             0x15010100	/* WEP ON/OFF (W) */
+#define DOT11_WEP_DEFAULT_KEY_ID          0x15020100	/* WEP Index (W) */
+#define DOT11_WEP_DEFAULT_KEY_VALUE1      0x13020101	/* WEP Key#1(TKIP AES: PairwiseTemporalKey) (W) */
+#define DOT11_WEP_DEFAULT_KEY_VALUE2      0x13020102	/* WEP Key#2(TKIP AES: GroupKey1) (W) */
+#define DOT11_WEP_DEFAULT_KEY_VALUE3      0x13020103	/* WEP Key#3(TKIP AES: GroupKey2) (W) */
+#define DOT11_WEP_DEFAULT_KEY_VALUE4      0x13020104	/* WEP Key#4 (W) */
+#define DOT11_WEP_LIST                    0x13020100	/* WEP LIST */
+#define	DOT11_DESIRED_SSID		  0x11090100	/* SSID */
+#define	DOT11_CURRENT_CHANNEL		  0x45010100	/* channel set */
+#define	DOT11_OPERATION_RATE_SET	  0x11110100	/* rate set */
+
+#define LOCAL_AP_SEARCH_INTEAVAL          0xF1010100	/* AP search interval (R/W) */
+#define LOCAL_CURRENTADDRESS              0xF1050100	/* MAC Address change (W) */
+#define LOCAL_MULTICAST_ADDRESS           0xF1060100	/* Multicast Address (W) */
+#define LOCAL_MULTICAST_FILTER            0xF1060200	/* Multicast Address Filter enable/disable (W) */
+#define LOCAL_SEARCHED_AP_LIST            0xF1030100	/* AP list (R) */
+#define LOCAL_LINK_AP_STATUS              0xF1040100	/* Link AP status (R) */
+#define	LOCAL_PACKET_STATISTICS		  0xF1020100	/* tx,rx packets statistics */
+#define LOCAL_AP_SCAN_LIST_TYPE_SET	  0xF1030200	/* AP_SCAN_LIST_TYPE */
+
+#define DOT11_RSN_ENABLED                 0x15070100	/* WPA enable/disable (W) */
+#define LOCAL_RSN_MODE                    0x56010100	/* RSN mode WPA/WPA2 (W) */
+#define DOT11_RSN_CONFIG_MULTICAST_CIPHER 0x51040100	/* GroupKeyCipherSuite (W) */
+#define DOT11_RSN_CONFIG_UNICAST_CIPHER   0x52020100	/* PairwiseKeyCipherSuite (W) */
+#define DOT11_RSN_CONFIG_AUTH_SUITE       0x53020100	/* AuthenticationKeyManagementSuite (W) */
+#define DOT11_RSN_CONFIG_VERSION          0x51020100	/* RSN version (W) */
+#define LOCAL_RSN_CONFIG_ALL              0x5F010100	/* RSN CONFIG ALL (W) */
+#define DOT11_PMK_TSC                     0x55010100	/* PMK_TSC (W) */
+#define DOT11_GMK1_TSC                    0x55010101	/* GMK1_TSC (W) */
+#define DOT11_GMK2_TSC                    0x55010102	/* GMK2_TSC (W) */
+#define DOT11_GMK3_TSC                    0x55010103	/* GMK3_TSC */
+#define LOCAL_PMK                         0x58010100	/* Pairwise Master Key cache (W) */
+
+#define LOCAL_REGION                      0xF10A0100	/* Region setting */
+
+#ifdef WPS
+#define LOCAL_WPS_ENABLE                  0xF10B0100	/* WiFi Protected Setup */
+#define LOCAL_WPS_PROBE_REQ               0xF10C0100	/* WPS Probe Request */
+#endif /* WPS */
+
+#define LOCAL_GAIN                        0xF10D0100	/* Carrer sense threshold for demo ato show */
+#define LOCAL_EEPROM_SUM                  0xF10E0100	/* EEPROM checksum information */
+
+struct hostif_mib_get_request_t {
+	struct hostif_hdr header;
+	u32 mib_attribute;
+} __packed;
+
+struct hostif_mib_value_t {
+	u16 size;
+	u16 type;
+#define MIB_VALUE_TYPE_NULL     0
+#define MIB_VALUE_TYPE_INT      1
+#define MIB_VALUE_TYPE_BOOL     2
+#define MIB_VALUE_TYPE_COUNT32  3
+#define MIB_VALUE_TYPE_OSTRING  4
+	u8 body[0];
+} __packed;
+
+struct hostif_mib_get_confirm_t {
+	struct hostif_hdr header;
+	u32 mib_status;
+#define MIB_SUCCESS    0
+#define MIB_INVALID    1
+#define MIB_READ_ONLY  2
+#define MIB_WRITE_ONLY 3
+	u32 mib_attribute;
+	struct hostif_mib_value_t mib_value;
+} __packed;
+
+struct hostif_mib_set_request_t {
+	struct hostif_hdr header;
+	u32 mib_attribute;
+	struct hostif_mib_value_t mib_value;
+} __packed;
+
+struct hostif_mib_set_confirm_t {
+	struct hostif_hdr header;
+	u32 mib_status;
+	u32 mib_attribute;
+} __packed;
+
+struct hostif_power_mgmt_request_t {
+	struct hostif_hdr header;
+	u32 mode;
+#define POWER_ACTIVE  1
+#define POWER_SAVE    2
+	u32 wake_up;
+#define SLEEP_FALSE 0
+#define SLEEP_TRUE  1	/* not used */
+	u32 receiveDTIMs;
+#define DTIM_FALSE 0
+#define DTIM_TRUE  1
+} __packed;
+
+enum power_mgmt_mode_type {
+	POWER_MGMT_ACTIVE,
+	POWER_MGMT_SAVE1,
+	POWER_MGMT_SAVE2
+};
+
+#define	RESULT_SUCCESS            0
+#define	RESULT_INVALID_PARAMETERS 1
+#define	RESULT_NOT_SUPPORTED      2
+/* #define	RESULT_ALREADY_RUNNING    3 */
+#define	RESULT_ALREADY_RUNNING    7
+
+struct hostif_power_mgmt_confirm_t {
+	struct hostif_hdr header;
+	u16 result_code;
+} __packed;
+
+struct hostif_start_request_t {
+	struct hostif_hdr header;
+	u16 mode;
+#define MODE_PSEUDO_ADHOC   0
+#define MODE_INFRASTRUCTURE 1
+#define MODE_AP             2	/* not used */
+#define MODE_ADHOC          3
+} __packed;
+
+struct hostif_start_confirm_t {
+	struct hostif_hdr header;
+	u16 result_code;
+} __packed;
+
+#define SSID_MAX_SIZE 32
+struct ssid_t {
+	u8 size;
+	u8 body[SSID_MAX_SIZE];
+	u8 ssid_pad;
+} __packed;
+
+#define RATE_SET_MAX_SIZE 16
+struct rate_set8_t {
+	u8 size;
+	u8 body[8];
+	u8 rate_pad;
+} __packed;
+
+struct FhParms_t {
+	u16 dwellTime;
+	u8 hopSet;
+	u8 hopPattern;
+	u8 hopIndex;
+} __packed;
+
+struct DsParms_t {
+	u8 channel;
+} __packed;
+
+struct CfParms_t {
+	u8 count;
+	u8 period;
+	u16 maxDuration;
+	u16 durRemaining;
+} __packed;
+
+struct IbssParms_t {
+	u16 atimWindow;
+} __packed;
+
+struct rsn_t {
+	u8 size;
+#define RSN_BODY_SIZE 64
+	u8 body[RSN_BODY_SIZE];
+} __packed;
+
+struct ErpParams_t {
+	u8 erp_info;
+} __packed;
+
+struct rate_set16_t {
+	u8 size;
+	u8 body[16];
+	u8 rate_pad;
+} __packed;
+
+struct ap_info_t {
+	u8 bssid[6];	/* +00 */
+	u8 rssi;	/* +06 */
+	u8 sq;	/* +07 */
+	u8 noise;	/* +08 */
+	u8 pad0;	/* +09 */
+	u16 beacon_period;	/* +10 */
+	u16 capability;	/* +12 */
+#define BSS_CAP_ESS             BIT(0)
+#define BSS_CAP_IBSS            BIT(1)
+#define BSS_CAP_CF_POLABLE      BIT(2)
+#define BSS_CAP_CF_POLL_REQ     BIT(3)
+#define BSS_CAP_PRIVACY         BIT(4)
+#define BSS_CAP_SHORT_PREAMBLE  BIT(5)
+#define BSS_CAP_PBCC            BIT(6)
+#define BSS_CAP_CHANNEL_AGILITY BIT(7)
+#define BSS_CAP_SHORT_SLOT_TIME BIT(10)
+#define BSS_CAP_DSSS_OFDM       BIT(13)
+	u8 frame_type;	/* +14 */
+	u8 ch_info;	/* +15 */
+#define FRAME_TYPE_BEACON	0x80
+#define FRAME_TYPE_PROBE_RESP	0x50
+	u16 body_size;	/* +16 */
+	u8 body[1024];	/* +18 */
+	/* +1032 */
+} __packed;
+
+struct link_ap_info_t {
+	u8 bssid[6];	/* +00 */
+	u8 rssi;	/* +06 */
+	u8 sq;	/* +07 */
+	u8 noise;	/* +08 */
+	u8 pad0;	/* +09 */
+	u16 beacon_period;	/* +10 */
+	u16 capability;	/* +12 */
+	struct rate_set8_t rate_set;	/* +14 */
+	struct FhParms_t fh_parameter;	/* +24 */
+	struct DsParms_t ds_parameter;	/* +29 */
+	struct CfParms_t cf_parameter;	/* +30 */
+	struct IbssParms_t ibss_parameter;	/* +36 */
+	struct ErpParams_t erp_parameter;	/* +38 */
+	u8 pad1;	/* +39 */
+	struct rate_set8_t ext_rate_set;	/* +40 */
+	u8 DTIM_period;	/* +50 */
+	u8 rsn_mode;	/* +51 */
+#define RSN_MODE_NONE	0
+#define RSN_MODE_WPA	1
+#define RSN_MODE_WPA2	2
+	struct {
+		u8 size;	/* +52 */
+		u8 body[128];	/* +53 */
+	} __packed rsn;
+} __packed;
+
+struct hostif_connect_indication_t {
+	struct hostif_hdr header;
+	u16 connect_code;
+#define RESULT_CONNECT    0
+#define RESULT_DISCONNECT 1
+	struct link_ap_info_t link_ap_info;
+} __packed;
+
+struct hostif_stop_request_t {
+	struct hostif_hdr header;
+} __packed;
+
+struct hostif_stop_confirm_t {
+	struct hostif_hdr header;
+	u16 result_code;
+} __packed;
+
+/**
+ * struct hostif_ps_adhoc_set_request_t - pseudo adhoc mode
+ * @capability: bit5  : preamble
+ *              bit6  : pbcc - Not supported always 0
+ *              bit10 : ShortSlotTime
+ *              bit13 : DSSS-OFDM - Not supported always 0
+ */
+struct hostif_ps_adhoc_set_request_t {
+	struct hostif_hdr header;
+	u16 phy_type;
+#define D_11B_ONLY_MODE		0
+#define D_11G_ONLY_MODE		1
+#define D_11BG_COMPATIBLE_MODE	2
+#define D_11A_ONLY_MODE		3
+	u16 cts_mode;
+#define CTS_MODE_FALSE	0
+#define CTS_MODE_TRUE	1
+	u16 channel;
+	struct rate_set16_t rate_set;
+	u16 capability;
+	u16 scan_type;
+} __packed;
+
+struct hostif_ps_adhoc_set_confirm_t {
+	struct hostif_hdr header;
+	u16 result_code;
+} __packed;
+
+/**
+ * struct hostif_infrastructure_set_request_t
+ * @capability: bit5  : preamble
+ *              bit6  : pbcc - Not supported always 0
+ *              bit10 : ShortSlotTime
+ *              bit13 : DSSS-OFDM - Not supported always 0
+ */
+struct hostif_infrastructure_set_request_t {
+	struct hostif_hdr header;
+	u16 phy_type;
+	u16 cts_mode;
+	struct rate_set16_t rate_set;
+	struct ssid_t ssid;
+	u16 capability;
+	u16 beacon_lost_count;
+	u16 auth_type;
+#define AUTH_TYPE_OPEN_SYSTEM 0
+#define AUTH_TYPE_SHARED_KEY  1
+	struct channel_list_t channel_list;
+	u16 scan_type;
+} __packed;
+
+/**
+ * struct hostif_infrastructure_set2_request_t
+ * @capability: bit5  : preamble
+ *              bit6  : pbcc - Not supported always 0
+ *              bit10 : ShortSlotTime
+ *              bit13 : DSSS-OFDM - Not supported always 0
+ */
+struct hostif_infrastructure_set2_request_t {
+	struct hostif_hdr header;
+	u16 phy_type;
+	u16 cts_mode;
+	struct rate_set16_t rate_set;
+	struct ssid_t ssid;
+	u16 capability;
+	u16 beacon_lost_count;
+	u16 auth_type;
+#define AUTH_TYPE_OPEN_SYSTEM 0
+#define AUTH_TYPE_SHARED_KEY  1
+	struct channel_list_t channel_list;
+	u16 scan_type;
+	u8 bssid[ETH_ALEN];
+} __packed;
+
+struct hostif_infrastructure_set_confirm_t {
+	struct hostif_hdr header;
+	u16 result_code;
+} __packed;
+
+/**
+ * struct hostif_adhoc_set_request_t
+ * @capability: bit5  : preamble
+ *              bit6  : pbcc - Not supported always 0
+ *              bit10 : ShortSlotTime
+ *              bit13 : DSSS-OFDM - Not supported always 0
+ */
+struct hostif_adhoc_set_request_t {
+	struct hostif_hdr header;
+	u16 phy_type;
+	u16 cts_mode;
+	u16 channel;
+	struct rate_set16_t rate_set;
+	struct ssid_t ssid;
+	u16 capability;
+	u16 scan_type;
+} __packed;
+
+/**
+ * struct hostif_adhoc_set2_request_t
+ * @capability: bit5  : preamble
+ *              bit6  : pbcc - Not supported always 0
+ *              bit10 : ShortSlotTime
+ *              bit13 : DSSS-OFDM - Not supported always 0
+ */
+struct hostif_adhoc_set2_request_t {
+	struct hostif_hdr header;
+	u16 phy_type;
+	u16 cts_mode;
+	u16 reserved;
+	struct rate_set16_t rate_set;
+	struct ssid_t ssid;
+	u16 capability;
+	u16 scan_type;
+	struct channel_list_t channel_list;
+	u8 bssid[ETH_ALEN];
+} __packed;
+
+struct hostif_adhoc_set_confirm_t {
+	struct hostif_hdr header;
+	u16 result_code;
+} __packed;
+
+struct last_associate_t {
+	u8 type;
+	u8 status;
+} __packed;
+
+struct association_request_t {
+	u8 type;
+#define FRAME_TYPE_ASSOC_REQ	0x00
+#define FRAME_TYPE_REASSOC_REQ	0x20
+	u8 pad;
+	u16 capability;
+	u16 listen_interval;
+	u8 ap_address[6];
+	u16 reqIEs_size;
+} __packed;
+
+struct association_response_t {
+	u8 type;
+#define FRAME_TYPE_ASSOC_RESP	0x10
+#define FRAME_TYPE_REASSOC_RESP	0x30
+	u8 pad;
+	u16 capability;
+	u16 status;
+	u16 association_id;
+	u16 respIEs_size;
+} __packed;
+
+struct hostif_associate_indication_t {
+	struct hostif_hdr header;
+	struct association_request_t assoc_req;
+	struct association_response_t assoc_resp;
+	/* followed by (reqIEs_size + respIEs_size) octets of data */
+	/* reqIEs data *//* respIEs data */
+} __packed;
+
+struct hostif_bss_scan_request_t {
+	struct hostif_hdr header;
+	u8 scan_type;
+#define ACTIVE_SCAN  0
+#define PASSIVE_SCAN 1
+	u8 pad[3];
+	u32 ch_time_min;
+	u32 ch_time_max;
+	struct channel_list_t channel_list;
+	struct ssid_t ssid;
+} __packed;
+
+struct hostif_bss_scan_confirm_t {
+	struct hostif_hdr header;
+	u16 result_code;
+	u16 reserved;
+} __packed;
+
+struct hostif_phy_information_request_t {
+	struct hostif_hdr header;
+	u16 type;
+#define NORMAL_TYPE	0
+#define TIME_TYPE	1
+	u16 time;	/* unit 100ms */
+} __packed;
+
+struct hostif_phy_information_confirm_t {
+	struct hostif_hdr header;
+	u8 rssi;
+	u8 sq;
+	u8 noise;
+	u8 link_speed;
+	u32 tx_frame;
+	u32 rx_frame;
+	u32 tx_error;
+	u32 rx_error;
+} __packed;
+
+enum sleep_mode_type {
+	SLP_ACTIVE,
+	SLP_SLEEP
+};
+
+struct hostif_sleep_request_t {
+	struct hostif_hdr header;
+} __packed;
+
+struct hostif_sleep_confirm_t {
+	struct hostif_hdr header;
+	u16 result_code;
+} __packed;
+
+struct hostif_mic_failure_request_t {
+	struct hostif_hdr header;
+	u16 failure_count;
+	u16 timer;
+} __packed;
+
+struct hostif_mic_failure_confirm_t {
+	struct hostif_hdr header;
+	u16 result_code;
+} __packed;
+
+#define BASIC_RATE	0x80
+#define RATE_MASK	0x7F
+
+#define TX_RATE_AUTO      0xff
+#define TX_RATE_1M_FIXED  0
+#define TX_RATE_2M_FIXED  1
+#define TX_RATE_1_2M_AUTO 2
+#define TX_RATE_5M_FIXED  3
+#define TX_RATE_11M_FIXED 4
+
+#define TX_RATE_FULL_AUTO	0
+#define TX_RATE_11_AUTO		1
+#define TX_RATE_11B_AUTO	2
+#define TX_RATE_11BG_AUTO	3
+#define TX_RATE_MANUAL_AUTO	4
+#define TX_RATE_FIXED		5
+
+/* 11b rate */
+#define TX_RATE_1M	(uint8_t)(10 / 5)	/* 11b 11g basic rate */
+#define TX_RATE_2M	(uint8_t)(20 / 5)	/* 11b 11g basic rate */
+#define TX_RATE_5M	(uint8_t)(55 / 5)	/* 11g basic rate */
+#define TX_RATE_11M	(uint8_t)(110 / 5)	/* 11g basic rate */
+
+/* 11g rate */
+#define TX_RATE_6M	(uint8_t)(60 / 5)	/* 11g basic rate */
+#define TX_RATE_12M	(uint8_t)(120 / 5)	/* 11g basic rate */
+#define TX_RATE_24M	(uint8_t)(240 / 5)	/* 11g basic rate */
+#define TX_RATE_9M	(uint8_t)(90 / 5)
+#define TX_RATE_18M	(uint8_t)(180 / 5)
+#define TX_RATE_36M	(uint8_t)(360 / 5)
+#define TX_RATE_48M	(uint8_t)(480 / 5)
+#define TX_RATE_54M	(uint8_t)(540 / 5)
+
+#define IS_11B_RATE(A) (((A & RATE_MASK) == TX_RATE_1M) || ((A & RATE_MASK) == TX_RATE_2M) || \
+			((A & RATE_MASK) == TX_RATE_5M) || ((A & RATE_MASK) == TX_RATE_11M))
+
+#define IS_OFDM_RATE(A) (((A & RATE_MASK) == TX_RATE_6M) || ((A & RATE_MASK) == TX_RATE_12M) || \
+			 ((A & RATE_MASK) == TX_RATE_24M) || ((A & RATE_MASK) == TX_RATE_9M) || \
+			 ((A & RATE_MASK) == TX_RATE_18M) || ((A & RATE_MASK) == TX_RATE_36M) || \
+			 ((A & RATE_MASK) == TX_RATE_48M) || ((A & RATE_MASK) == TX_RATE_54M))
+
+#define IS_11BG_RATE(A) (IS_11B_RATE(A) || IS_OFDM_RATE(A))
+
+#define IS_OFDM_EXT_RATE(A) (((A & RATE_MASK) == TX_RATE_9M) || ((A & RATE_MASK) == TX_RATE_18M) || \
+			     ((A & RATE_MASK) == TX_RATE_36M) || ((A & RATE_MASK) == TX_RATE_48M) || \
+			     ((A & RATE_MASK) == TX_RATE_54M))
+
+enum connect_status_type {
+	CONNECT_STATUS,
+	DISCONNECT_STATUS
+};
+
+enum preamble_type {
+	LONG_PREAMBLE,
+	SHORT_PREAMBLE
+};
+
+enum multicast_filter_type {
+	MCAST_FILTER_MCAST,
+	MCAST_FILTER_MCASTALL,
+	MCAST_FILTER_PROMISC,
+};
+
+#define NIC_MAX_MCAST_LIST 32
+
+/* macro function */
+#define HIF_EVENT_MASK 0xE800
+#define IS_HIF_IND(_EVENT)  ((_EVENT & HIF_EVENT_MASK) == 0xE800  && \
+			     ((_EVENT & ~HIF_EVENT_MASK) == 0x0001 || \
+			     (_EVENT & ~HIF_EVENT_MASK) == 0x0006 || \
+			     (_EVENT & ~HIF_EVENT_MASK) == 0x000C || \
+			     (_EVENT & ~HIF_EVENT_MASK) == 0x0011 || \
+			     (_EVENT & ~HIF_EVENT_MASK) == 0x0012))
+
+#define IS_HIF_CONF(_EVENT) ((_EVENT & HIF_EVENT_MASK) == 0xE800  && \
+			     (_EVENT & ~HIF_EVENT_MASK) > 0x0000  && \
+			     (_EVENT & ~HIF_EVENT_MASK) < 0x0012  && \
+			     !IS_HIF_IND(_EVENT))
+
+#ifdef __KERNEL__
+
+#include "ks_wlan.h"
+
+/* function prototype */
+int hostif_data_request(struct ks_wlan_private *priv, struct sk_buff *skb);
+void hostif_receive(struct ks_wlan_private *priv, unsigned char *p,
+		    unsigned int size);
+void hostif_sme_enqueue(struct ks_wlan_private *priv, uint16_t event);
+int hostif_init(struct ks_wlan_private *priv);
+void hostif_exit(struct ks_wlan_private *priv);
+int ks_wlan_hw_tx(struct ks_wlan_private *priv, void *p, unsigned long size,
+		  void (*complete_handler)(struct ks_wlan_private *priv,
+					   struct sk_buff *skb),
+		  struct sk_buff *skb);
+void send_packet_complete(struct ks_wlan_private *priv, struct sk_buff *skb);
+
+void ks_wlan_hw_wakeup_request(struct ks_wlan_private *priv);
+int ks_wlan_hw_power_save(struct ks_wlan_private *priv);
+
+static
+inline int hif_align_size(int size)
+{
+#ifdef	KS_ATOM
+	if (size < 1024)
+		size = 1024;
+#endif
+#ifdef	DEVICE_ALIGNMENT
+	return (size % DEVICE_ALIGNMENT) ? size + DEVICE_ALIGNMENT -
+	    (size % DEVICE_ALIGNMENT) : size;
+#else
+	return size;
+#endif
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* _KS_HOSTIF_H_ */
diff --git a/drivers/staging/ks7010/wext/ks_wlan.h b/drivers/staging/ks7010/wext/ks_wlan.h
new file mode 100644
index 0000000..cd4f56d
--- /dev/null
+++ b/drivers/staging/ks7010/wext/ks_wlan.h
@@ -0,0 +1,514 @@
+/*
+ *   Driver for KeyStream IEEE802.11 b/g wireless LAN cards.
+ *
+ *   Copyright (C) 2006-2008 KeyStream Corp.
+ *   Copyright (C) 2009 Renesas Technology Corp.
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License version 2 as
+ *   published by the Free Software Foundation.
+ */
+
+#ifndef _KS_WLAN_H
+#define _KS_WLAN_H
+
+#define WPS
+
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <linux/spinlock.h>	/* spinlock_t */
+#include <linux/sched.h>	/* wait_queue_head_t */
+#include <linux/types.h>	/* pid_t */
+#include <linux/netdevice.h>	/* struct net_device_stats,  struct sk_buff */
+#include <linux/etherdevice.h>
+#include <linux/wireless.h>
+#include <linux/atomic.h>	/* struct atomic_t */
+#include <linux/timer.h>	/* struct timer_list */
+#include <linux/string.h>
+#include <linux/completion.h>	/* struct completion */
+#include <linux/workqueue.h>
+
+#include <linux/io.h>
+
+#include "ks7010_sdio.h"
+
+#ifdef KS_WLAN_DEBUG
+#define DPRINTK(n, fmt, args...) \
+	do { \
+		if (KS_WLAN_DEBUG > (n)) \
+			pr_notice("%s: "fmt, __func__, ## args); \
+	} while (0)
+#else
+#define DPRINTK(n, fmt, args...)
+#endif
+
+struct ks_wlan_parameter {
+	u8 operation_mode;	/* Operation Mode */
+	u8 channel;	/*  Channel */
+	u8 tx_rate;	/*  Transmit Rate */
+	struct {
+		u8 size;
+		u8 body[16];
+	} rate_set;
+	u8 bssid[ETH_ALEN];	/* BSSID */
+	struct {
+		u8 size;
+		u8 body[32 + 1];
+	} ssid;	/*  SSID */
+	u8 preamble;	/*  Preamble */
+	u8 power_mgmt;
+	u32 scan_type;	/*  AP List Scan Type */
+#define BEACON_LOST_COUNT_MIN 0
+#define BEACON_LOST_COUNT_MAX 65535
+	u32 beacon_lost_count;	/*  Beacon Lost Count */
+	u32 rts;	/*  RTS Threashold */
+	u32 fragment;	/*  Fragmentation Threashold */
+	u32 privacy_invoked;
+	u32 wep_index;
+	struct {
+		u8 size;
+		u8 val[13 * 2 + 1];
+	} wep_key[4];
+	u16 authenticate_type;
+	u16 phy_type;	/* 11b/11g/11bg mode type */
+	u16 cts_mode;	/* for 11g/11bg mode cts mode */
+	u16 phy_info_timer;	/* phy information timer */
+};
+
+enum {
+	DEVICE_STATE_OFF = 0,	/* this means hw_unavailable is != 0 */
+	DEVICE_STATE_PREBOOT,	/* we are in a pre-boot state (empty RAM) */
+	DEVICE_STATE_BOOT,	/* boot state (fw upload, run fw) */
+	DEVICE_STATE_PREINIT,	/* pre-init state */
+	DEVICE_STATE_INIT,	/* init state (restore MIB backup to device) */
+	DEVICE_STATE_READY,	/* driver&device are in operational state */
+	DEVICE_STATE_SLEEP	/* device in sleep mode */
+};
+
+/* SME flag */
+#define SME_MODE_SET	    BIT(0)
+#define SME_RTS             BIT(1)
+#define SME_FRAG            BIT(2)
+#define SME_WEP_FLAG        BIT(3)
+#define SME_WEP_INDEX       BIT(4)
+#define SME_WEP_VAL1        BIT(5)
+#define SME_WEP_VAL2        BIT(6)
+#define SME_WEP_VAL3        BIT(7)
+#define SME_WEP_VAL4        BIT(8)
+#define SME_WEP_VAL_MASK    (SME_WEP_VAL1 | SME_WEP_VAL2 | SME_WEP_VAL3 | SME_WEP_VAL4)
+#define SME_RSN             BIT(9)
+#define SME_RSN_MULTICAST   BIT(10)
+#define SME_RSN_UNICAST	    BIT(11)
+#define SME_RSN_AUTH	    BIT(12)
+
+#define SME_AP_SCAN         BIT(13)
+#define SME_MULTICAST       BIT(14)
+
+/* SME Event */
+enum {
+	SME_START,
+
+	SME_MULTICAST_REQUEST,
+	SME_MACADDRESS_SET_REQUEST,
+	SME_BSS_SCAN_REQUEST,
+	SME_SET_FLAG,
+	SME_SET_TXKEY,
+	SME_SET_KEY1,
+	SME_SET_KEY2,
+	SME_SET_KEY3,
+	SME_SET_KEY4,
+	SME_SET_PMK_TSC,
+	SME_SET_GMK1_TSC,
+	SME_SET_GMK2_TSC,
+	SME_SET_GMK3_TSC,
+	SME_SET_PMKSA,
+	SME_POW_MNGMT_REQUEST,
+	SME_PHY_INFO_REQUEST,
+	SME_MIC_FAILURE_REQUEST,
+	SME_GET_MAC_ADDRESS,
+	SME_GET_PRODUCT_VERSION,
+	SME_STOP_REQUEST,
+	SME_RTS_THRESHOLD_REQUEST,
+	SME_FRAGMENTATION_THRESHOLD_REQUEST,
+	SME_WEP_INDEX_REQUEST,
+	SME_WEP_KEY1_REQUEST,
+	SME_WEP_KEY2_REQUEST,
+	SME_WEP_KEY3_REQUEST,
+	SME_WEP_KEY4_REQUEST,
+	SME_WEP_FLAG_REQUEST,
+	SME_RSN_UCAST_REQUEST,
+	SME_RSN_MCAST_REQUEST,
+	SME_RSN_AUTH_REQUEST,
+	SME_RSN_ENABLED_REQUEST,
+	SME_RSN_MODE_REQUEST,
+#ifdef WPS
+	SME_WPS_ENABLE_REQUEST,
+	SME_WPS_PROBE_REQUEST,
+#endif
+	SME_SET_GAIN,
+	SME_GET_GAIN,
+	SME_SLEEP_REQUEST,
+	SME_SET_REGION,
+	SME_MODE_SET_REQUEST,
+	SME_START_REQUEST,
+	SME_GET_EEPROM_CKSUM,
+
+	SME_MIC_FAILURE_CONFIRM,
+	SME_START_CONFIRM,
+
+	SME_MULTICAST_CONFIRM,
+	SME_BSS_SCAN_CONFIRM,
+	SME_GET_CURRENT_AP,
+	SME_POW_MNGMT_CONFIRM,
+	SME_PHY_INFO_CONFIRM,
+	SME_STOP_CONFIRM,
+	SME_RTS_THRESHOLD_CONFIRM,
+	SME_FRAGMENTATION_THRESHOLD_CONFIRM,
+	SME_WEP_INDEX_CONFIRM,
+	SME_WEP_KEY1_CONFIRM,
+	SME_WEP_KEY2_CONFIRM,
+	SME_WEP_KEY3_CONFIRM,
+	SME_WEP_KEY4_CONFIRM,
+	SME_WEP_FLAG_CONFIRM,
+	SME_RSN_UCAST_CONFIRM,
+	SME_RSN_MCAST_CONFIRM,
+	SME_RSN_AUTH_CONFIRM,
+	SME_RSN_ENABLED_CONFIRM,
+	SME_RSN_MODE_CONFIRM,
+	SME_MODE_SET_CONFIRM,
+	SME_SLEEP_CONFIRM,
+
+	SME_RSN_SET_CONFIRM,
+	SME_WEP_SET_CONFIRM,
+	SME_TERMINATE,
+
+	SME_EVENT_SIZE	/* end */
+};
+
+/* SME Status */
+enum {
+	SME_IDLE,
+	SME_SETUP,
+	SME_DISCONNECT,
+	SME_CONNECT
+};
+
+#define	SME_EVENT_BUFF_SIZE	128
+
+struct sme_info {
+	int sme_status;
+	int event_buff[SME_EVENT_BUFF_SIZE];
+	unsigned int qhead;
+	unsigned int qtail;
+#ifdef KS_WLAN_DEBUG
+	/* for debug */
+	unsigned int max_event_count;
+#endif
+	spinlock_t sme_spin;
+	unsigned long sme_flag;
+};
+
+struct hostt_t {
+	int buff[SME_EVENT_BUFF_SIZE];
+	unsigned int qhead;
+	unsigned int qtail;
+};
+
+#define RSN_IE_BODY_MAX 64
+struct rsn_ie_t {
+	u8 id;	/* 0xdd = WPA or 0x30 = RSN */
+	u8 size;	/* max ? 255 ? */
+	u8 body[RSN_IE_BODY_MAX];
+} __packed;
+
+#ifdef WPS
+#define WPS_IE_BODY_MAX 255
+struct wps_ie_t {
+	u8 id;	/* 221 'dd <len> 00 50 F2 04' */
+	u8 size;	/* max ? 255 ? */
+	u8 body[WPS_IE_BODY_MAX];
+} __packed;
+#endif /* WPS */
+
+struct local_ap_t {
+	u8 bssid[6];
+	u8 rssi;
+	u8 sq;
+	struct {
+		u8 size;
+		u8 body[32];
+		u8 ssid_pad;
+	} ssid;
+	struct {
+		u8 size;
+		u8 body[16];
+		u8 rate_pad;
+	} rate_set;
+	u16 capability;
+	u8 channel;
+	u8 noise;
+	struct rsn_ie_t wpa_ie;
+	struct rsn_ie_t rsn_ie;
+#ifdef WPS
+	struct wps_ie_t wps_ie;
+#endif /* WPS */
+};
+
+#define LOCAL_APLIST_MAX 31
+#define LOCAL_CURRENT_AP LOCAL_APLIST_MAX
+struct local_aplist_t {
+	int size;
+	struct local_ap_t ap[LOCAL_APLIST_MAX + 1];
+};
+
+struct local_gain_t {
+	u8 TxMode;
+	u8 RxMode;
+	u8 TxGain;
+	u8 RxGain;
+};
+
+struct local_eeprom_sum_t {
+	u8 type;
+	u8 result;
+};
+
+enum {
+	EEPROM_OK,
+	EEPROM_CHECKSUM_NONE,
+	EEPROM_FW_NOT_SUPPORT,
+	EEPROM_NG,
+};
+
+/* Power Save Status */
+enum {
+	PS_NONE,
+	PS_ACTIVE_SET,
+	PS_SAVE_SET,
+	PS_CONF_WAIT,
+	PS_SNOOZE,
+	PS_WAKEUP
+};
+
+struct power_save_status_t {
+	atomic_t status;	/* initialvalue 0 */
+	struct completion wakeup_wait;
+	atomic_t confirm_wait;
+	atomic_t snooze_guard;
+};
+
+struct sleep_status_t {
+	atomic_t status;	/* initialvalue 0 */
+	atomic_t doze_request;
+	atomic_t wakeup_request;
+};
+
+/* WPA */
+struct scan_ext_t {
+	unsigned int flag;
+	char ssid[IW_ESSID_MAX_SIZE + 1];
+};
+
+enum {
+	CIPHER_NONE,
+	CIPHER_WEP40,
+	CIPHER_TKIP,
+	CIPHER_CCMP,
+	CIPHER_WEP104
+};
+
+#define CIPHER_ID_WPA_NONE    "\x00\x50\xf2\x00"
+#define CIPHER_ID_WPA_WEP40   "\x00\x50\xf2\x01"
+#define CIPHER_ID_WPA_TKIP    "\x00\x50\xf2\x02"
+#define CIPHER_ID_WPA_CCMP    "\x00\x50\xf2\x04"
+#define CIPHER_ID_WPA_WEP104  "\x00\x50\xf2\x05"
+
+#define CIPHER_ID_WPA2_NONE   "\x00\x0f\xac\x00"
+#define CIPHER_ID_WPA2_WEP40  "\x00\x0f\xac\x01"
+#define CIPHER_ID_WPA2_TKIP   "\x00\x0f\xac\x02"
+#define CIPHER_ID_WPA2_CCMP   "\x00\x0f\xac\x04"
+#define CIPHER_ID_WPA2_WEP104 "\x00\x0f\xac\x05"
+
+#define CIPHER_ID_LEN    4
+
+enum {
+	KEY_MGMT_802_1X,
+	KEY_MGMT_PSK,
+	KEY_MGMT_WPANONE,
+};
+
+#define KEY_MGMT_ID_WPA_NONE     "\x00\x50\xf2\x00"
+#define KEY_MGMT_ID_WPA_1X       "\x00\x50\xf2\x01"
+#define KEY_MGMT_ID_WPA_PSK      "\x00\x50\xf2\x02"
+#define KEY_MGMT_ID_WPA_WPANONE  "\x00\x50\xf2\xff"
+
+#define KEY_MGMT_ID_WPA2_NONE    "\x00\x0f\xac\x00"
+#define KEY_MGMT_ID_WPA2_1X      "\x00\x0f\xac\x01"
+#define KEY_MGMT_ID_WPA2_PSK     "\x00\x0f\xac\x02"
+#define KEY_MGMT_ID_WPA2_WPANONE "\x00\x0f\xac\xff"
+
+#define KEY_MGMT_ID_LEN  4
+
+#define MIC_KEY_SIZE 8
+
+struct wpa_key_t {
+	u32 ext_flags;	/* IW_ENCODE_EXT_xxx */
+	u8 tx_seq[IW_ENCODE_SEQ_MAX_SIZE];	/* LSB first */
+	u8 rx_seq[IW_ENCODE_SEQ_MAX_SIZE];	/* LSB first */
+	struct sockaddr addr;	/* ff:ff:ff:ff:ff:ff for broadcast/multicast
+				 * (group) keys or unicast address for
+				 * individual keys
+				 */
+	u16 alg;
+	u16 key_len;	/* WEP: 5 or 13, TKIP: 32, CCMP: 16 */
+	u8 key_val[IW_ENCODING_TOKEN_MAX];
+	u8 tx_mic_key[MIC_KEY_SIZE];
+	u8 rx_mic_key[MIC_KEY_SIZE];
+};
+
+#define WPA_KEY_INDEX_MAX 4
+#define WPA_RX_SEQ_LEN 6
+
+struct mic_failure_t {
+	u16 failure;	/* MIC Failure counter 0 or 1 or 2 */
+	u16 counter;	/* 1sec counter 0-60 */
+	u32 last_failure_time;
+	int stop;	/* stop flag */
+};
+
+struct wpa_status_t {
+	int wpa_enabled;
+	unsigned int rsn_enabled;
+	int version;
+	int pairwise_suite;	/* unicast cipher */
+	int group_suite;	/* multicast cipher */
+	int key_mgmt_suite;	/* authentication key management suite */
+	int auth_alg;
+	int txkey;
+	struct wpa_key_t key[WPA_KEY_INDEX_MAX];
+	struct scan_ext_t scan_ext;
+	struct mic_failure_t mic_failure;
+};
+
+#include <linux/list.h>
+#define PMK_LIST_MAX 8
+struct pmk_list_t {
+	u16 size;
+	struct list_head head;
+	struct pmk_t {
+		struct list_head list;
+		u8 bssid[ETH_ALEN];
+		u8 pmkid[IW_PMKID_LEN];
+	} pmk[PMK_LIST_MAX];
+};
+
+#ifdef WPS
+struct wps_status_t {
+	int wps_enabled;
+	int ielen;
+	u8 ie[255];
+};
+#endif /* WPS */
+
+struct ks_wlan_private {
+	/* hardware information */
+	struct ks_sdio_card *ks_sdio_card;
+	struct workqueue_struct *wq;
+	struct delayed_work rw_dwork;
+	struct tasklet_struct rx_bh_task;
+
+	struct net_device *net_dev;
+	int reg_net;	/* register_netdev */
+	struct net_device_stats nstats;
+	struct iw_statistics wstats;
+
+	struct completion confirm_wait;
+
+	/* trx device & sme */
+	struct tx_device tx_dev;
+	struct rx_device rx_dev;
+	struct sme_info sme_i;
+	u8 *rxp;
+	unsigned int rx_size;
+	struct tasklet_struct sme_task;
+	struct work_struct wakeup_work;
+	int scan_ind_count;
+
+	unsigned char eth_addr[ETH_ALEN];
+
+	struct local_aplist_t aplist;
+	struct local_ap_t current_ap;
+	struct power_save_status_t psstatus;
+	struct sleep_status_t sleepstatus;
+	struct wpa_status_t wpa;
+	struct pmk_list_t pmklist;
+	/* wireless parameter */
+	struct ks_wlan_parameter reg;
+	u8 current_rate;
+
+	char nick[IW_ESSID_MAX_SIZE + 1];
+
+	spinlock_t multicast_spin;
+
+	spinlock_t dev_read_lock;
+	wait_queue_head_t devread_wait;
+
+	unsigned int need_commit;	/* for ioctl */
+
+	/* DeviceIoControl */
+	int device_open_status;
+	atomic_t event_count;
+	atomic_t rec_count;
+	int dev_count;
+#define DEVICE_STOCK_COUNT 20
+	unsigned char *dev_data[DEVICE_STOCK_COUNT];
+	int dev_size[DEVICE_STOCK_COUNT];
+
+	/* ioctl : IOCTL_FIRMWARE_VERSION */
+	unsigned char firmware_version[128 + 1];
+	int version_size;
+
+	int mac_address_valid;	/* Mac Address Status */
+
+	int dev_state;
+
+	struct sk_buff *skb;
+	unsigned int cur_rx;	/* Index into the Rx buffer of next Rx pkt. */
+	/* spinlock_t lock; */
+#define FORCE_DISCONNECT    0x80000000
+#define CONNECT_STATUS_MASK 0x7FFFFFFF
+	u32 connect_status;	/* connect status */
+	int infra_status;	/* Infractructure status */
+
+	u8 data_buff[0x1000];
+
+	u8 scan_ssid_len;
+	u8 scan_ssid[IW_ESSID_MAX_SIZE + 1];
+	struct local_gain_t gain;
+#ifdef WPS
+	struct net_device *l2_dev;
+	int l2_fd;
+	struct wps_status_t wps;
+#endif /* WPS */
+	u8 sleep_mode;
+
+	u8 region;
+	struct local_eeprom_sum_t eeprom_sum;
+	u8 eeprom_checksum;
+
+	struct hostt_t hostt;
+
+	unsigned long last_doze;
+	unsigned long last_wakeup;
+
+	uint wakeup_count;	/* for detect wakeup loop */
+};
+
+int ks_wlan_net_start(struct net_device *dev);
+int ks_wlan_net_stop(struct net_device *dev);
+bool is_connect_status(u32 status);
+bool is_disconnect_status(u32 status);
+
+#endif /* _KS_WLAN_H */
diff --git a/drivers/staging/ks7010/wext/ks_wlan_ioctl.h b/drivers/staging/ks7010/wext/ks_wlan_ioctl.h
new file mode 100644
index 0000000..28b381c
--- /dev/null
+++ b/drivers/staging/ks7010/wext/ks_wlan_ioctl.h
@@ -0,0 +1,67 @@
+/*
+ *   Driver for KeyStream 11b/g wireless LAN
+ *
+ *   Copyright (c) 2005-2008 KeyStream Corp.
+ *   Copyright (C) 2009 Renesas Technology Corp.
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License version 2 as
+ *   published by the Free Software Foundation.
+ */
+
+#ifndef _KS_WLAN_IOCTL_H
+#define _KS_WLAN_IOCTL_H
+
+#include <linux/wireless.h>
+/* The low order bit identify a SET (0) or a GET (1) ioctl.  */
+
+/*					(SIOCIWFIRSTPRIV + 0) */
+/* former KS_WLAN_GET_DRIVER_VERSION	(SIOCIWFIRSTPRIV + 1) */
+/*					(SIOCIWFIRSTPRIV + 2) */
+#define KS_WLAN_GET_FIRM_VERSION	(SIOCIWFIRSTPRIV + 3)
+#ifdef WPS
+#define KS_WLAN_SET_WPS_ENABLE		(SIOCIWFIRSTPRIV + 4)
+#define KS_WLAN_GET_WPS_ENABLE		(SIOCIWFIRSTPRIV + 5)
+#define KS_WLAN_SET_WPS_PROBE_REQ	(SIOCIWFIRSTPRIV + 6)
+#endif
+#define KS_WLAN_GET_EEPROM_CKSUM	(SIOCIWFIRSTPRIV + 7)
+#define KS_WLAN_SET_PREAMBLE		(SIOCIWFIRSTPRIV + 8)
+#define KS_WLAN_GET_PREAMBLE		(SIOCIWFIRSTPRIV + 9)
+#define KS_WLAN_SET_POWER_SAVE		(SIOCIWFIRSTPRIV + 10)
+#define KS_WLAN_GET_POWER_SAVE		(SIOCIWFIRSTPRIV + 11)
+#define KS_WLAN_SET_SCAN_TYPE		(SIOCIWFIRSTPRIV + 12)
+#define KS_WLAN_GET_SCAN_TYPE		(SIOCIWFIRSTPRIV + 13)
+#define KS_WLAN_SET_RX_GAIN		(SIOCIWFIRSTPRIV + 14)
+#define KS_WLAN_GET_RX_GAIN		(SIOCIWFIRSTPRIV + 15)
+#define KS_WLAN_HOSTT			(SIOCIWFIRSTPRIV + 16)	/* unused */
+//#define KS_WLAN_SET_REGION            (SIOCIWFIRSTPRIV + 17)
+#define KS_WLAN_SET_BEACON_LOST		(SIOCIWFIRSTPRIV + 18)
+#define KS_WLAN_GET_BEACON_LOST		(SIOCIWFIRSTPRIV + 19)
+
+#define KS_WLAN_SET_TX_GAIN		(SIOCIWFIRSTPRIV + 20)
+#define KS_WLAN_GET_TX_GAIN		(SIOCIWFIRSTPRIV + 21)
+
+/* for KS7010 */
+#define KS_WLAN_SET_PHY_TYPE		(SIOCIWFIRSTPRIV + 22)
+#define KS_WLAN_GET_PHY_TYPE		(SIOCIWFIRSTPRIV + 23)
+#define KS_WLAN_SET_CTS_MODE		(SIOCIWFIRSTPRIV + 24)
+#define KS_WLAN_GET_CTS_MODE		(SIOCIWFIRSTPRIV + 25)
+/*					(SIOCIWFIRSTPRIV + 26) */
+/*					(SIOCIWFIRSTPRIV + 27) */
+#define KS_WLAN_SET_SLEEP_MODE		(SIOCIWFIRSTPRIV + 28)	/* sleep mode */
+#define KS_WLAN_GET_SLEEP_MODE		(SIOCIWFIRSTPRIV + 29)	/* sleep mode */
+/*					(SIOCIWFIRSTPRIV + 30) */
+/*					(SIOCIWFIRSTPRIV + 31) */
+
+#ifdef __KERNEL__
+
+#include "ks_wlan.h"
+#include <linux/netdevice.h>
+
+int ks_wlan_read_config_file(struct ks_wlan_private *priv);
+int ks_wlan_setup_parameter(struct ks_wlan_private *priv,
+			    unsigned int commit_flag);
+
+#endif /* __KERNEL__ */
+
+#endif /* _KS_WLAN_IOCTL_H */
diff --git a/drivers/staging/ks7010/wext/ks_wlan_net.c b/drivers/staging/ks7010/wext/ks_wlan_net.c
new file mode 100644
index 0000000..5a43f19
--- /dev/null
+++ b/drivers/staging/ks7010/wext/ks_wlan_net.c
@@ -0,0 +1,2999 @@
+/*
+ *   Driver for KeyStream 11b/g wireless LAN
+ *
+ *   Copyright (C) 2005-2008 KeyStream Corp.
+ *   Copyright (C) 2009 Renesas Technology Corp.
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License version 2 as
+ *   published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/compiler.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/if_arp.h>
+#include <linux/rtnetlink.h>
+#include <linux/delay.h>
+#include <linux/completion.h>
+#include <linux/mii.h>
+#include <linux/pci.h>
+#include <linux/ctype.h>
+#include <linux/timer.h>
+#include <linux/atomic.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+static int wep_on_off;
+#define	WEP_OFF		0
+#define	WEP_ON_64BIT	1
+#define	WEP_ON_128BIT	2
+
+#include "ks_wlan.h"
+#include "ks_hostif.h"
+#include "ks_wlan_ioctl.h"
+
+/* Include Wireless Extension definition and check version */
+#include <linux/wireless.h>
+#define WIRELESS_SPY	/* enable iwspy support */
+#include <net/iw_handler.h>	/* New driver API */
+
+/* Frequency list (map channels to frequencies) */
+static const long frequency_list[] = { 2412, 2417, 2422, 2427, 2432, 2437, 2442,
+	2447, 2452, 2457, 2462, 2467, 2472, 2484
+};
+
+/* A few details needed for WEP (Wireless Equivalent Privacy) */
+#define MAX_KEY_SIZE 13	/* 128 (?) bits */
+#define MIN_KEY_SIZE  5	/* 40 bits RC4 - WEP */
+struct wep_key {
+	u16 len;
+	u8 key[16];	/* 40-bit and 104-bit keys */
+};
+
+/* Backward compatibility */
+#ifndef IW_ENCODE_NOKEY
+#define IW_ENCODE_NOKEY 0x0800	/* Key is write only, so not present */
+#define IW_ENCODE_MODE  (IW_ENCODE_DISABLED | IW_ENCODE_RESTRICTED | IW_ENCODE_OPEN)
+#endif /* IW_ENCODE_NOKEY */
+
+/* List of Wireless Handlers (new API) */
+static const struct iw_handler_def ks_wlan_handler_def;
+
+#define KSC_OPNOTSUPP	/* Operation Not Support */
+
+/*
+ *	function prototypes
+ */
+static int ks_wlan_open(struct net_device *dev);
+static void ks_wlan_tx_timeout(struct net_device *dev);
+static int ks_wlan_start_xmit(struct sk_buff *skb, struct net_device *dev);
+static int ks_wlan_close(struct net_device *dev);
+static void ks_wlan_set_multicast_list(struct net_device *dev);
+static struct net_device_stats *ks_wlan_get_stats(struct net_device *dev);
+static int ks_wlan_set_mac_address(struct net_device *dev, void *addr);
+static int ks_wlan_netdev_ioctl(struct net_device *dev, struct ifreq *rq,
+				int cmd);
+
+static atomic_t update_phyinfo;
+static struct timer_list update_phyinfo_timer;
+static
+int ks_wlan_update_phy_information(struct ks_wlan_private *priv)
+{
+	struct iw_statistics *wstats = &priv->wstats;
+
+	DPRINTK(4, "in_interrupt = %ld\n", in_interrupt());
+
+	if (priv->dev_state < DEVICE_STATE_READY)
+		return -EBUSY;	/* not finished initialize */
+
+	if (atomic_read(&update_phyinfo))
+		return -EPERM;
+
+	/* The status */
+	wstats->status = priv->reg.operation_mode;	/* Operation mode */
+
+	/* Signal quality and co. But where is the noise level ??? */
+	hostif_sme_enqueue(priv, SME_PHY_INFO_REQUEST);
+
+	/* interruptible_sleep_on_timeout(&priv->confirm_wait, HZ/2); */
+	if (!wait_for_completion_interruptible_timeout
+	    (&priv->confirm_wait, HZ / 2)) {
+		DPRINTK(1, "wait time out!!\n");
+	}
+
+	atomic_inc(&update_phyinfo);
+	update_phyinfo_timer.expires = jiffies + HZ;	/* 1sec */
+	add_timer(&update_phyinfo_timer);
+
+	return 0;
+}
+
+static
+void ks_wlan_update_phyinfo_timeout(unsigned long ptr)
+{
+	DPRINTK(4, "in_interrupt = %ld\n", in_interrupt());
+	atomic_set(&update_phyinfo, 0);
+}
+
+int ks_wlan_setup_parameter(struct ks_wlan_private *priv,
+			    unsigned int commit_flag)
+{
+	DPRINTK(2, "\n");
+
+	hostif_sme_enqueue(priv, SME_STOP_REQUEST);
+
+	if (commit_flag & SME_RTS)
+		hostif_sme_enqueue(priv, SME_RTS_THRESHOLD_REQUEST);
+	if (commit_flag & SME_FRAG)
+		hostif_sme_enqueue(priv, SME_FRAGMENTATION_THRESHOLD_REQUEST);
+
+	if (commit_flag & SME_WEP_INDEX)
+		hostif_sme_enqueue(priv, SME_WEP_INDEX_REQUEST);
+	if (commit_flag & SME_WEP_VAL1)
+		hostif_sme_enqueue(priv, SME_WEP_KEY1_REQUEST);
+	if (commit_flag & SME_WEP_VAL2)
+		hostif_sme_enqueue(priv, SME_WEP_KEY2_REQUEST);
+	if (commit_flag & SME_WEP_VAL3)
+		hostif_sme_enqueue(priv, SME_WEP_KEY3_REQUEST);
+	if (commit_flag & SME_WEP_VAL4)
+		hostif_sme_enqueue(priv, SME_WEP_KEY4_REQUEST);
+	if (commit_flag & SME_WEP_FLAG)
+		hostif_sme_enqueue(priv, SME_WEP_FLAG_REQUEST);
+
+	if (commit_flag & SME_RSN) {
+		hostif_sme_enqueue(priv, SME_RSN_ENABLED_REQUEST);
+		hostif_sme_enqueue(priv, SME_RSN_MODE_REQUEST);
+	}
+	if (commit_flag & SME_RSN_MULTICAST)
+		hostif_sme_enqueue(priv, SME_RSN_MCAST_REQUEST);
+	if (commit_flag & SME_RSN_UNICAST)
+		hostif_sme_enqueue(priv, SME_RSN_UCAST_REQUEST);
+	if (commit_flag & SME_RSN_AUTH)
+		hostif_sme_enqueue(priv, SME_RSN_AUTH_REQUEST);
+
+	hostif_sme_enqueue(priv, SME_MODE_SET_REQUEST);
+
+	hostif_sme_enqueue(priv, SME_START_REQUEST);
+
+	return 0;
+}
+
+/*
+ * Initial Wireless Extension code for Ks_Wlannet driver by :
+ *	Jean Tourrilhes <jt@hpl.hp.com> - HPL - 17 November 00
+ * Conversion to new driver API by :
+ *	Jean Tourrilhes <jt@hpl.hp.com> - HPL - 26 March 02
+ * Javier also did a good amount of work here, adding some new extensions
+ * and fixing my code. Let's just say that without him this code just
+ * would not work at all... - Jean II
+ */
+
+static int ks_wlan_get_name(struct net_device *dev,
+			    struct iw_request_info *info, char *cwrq,
+			    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	if (priv->dev_state < DEVICE_STATE_READY)
+		strcpy(cwrq, "NOT READY!");
+	else if (priv->reg.phy_type == D_11B_ONLY_MODE)
+		strcpy(cwrq, "IEEE 802.11b");
+	else if (priv->reg.phy_type == D_11G_ONLY_MODE)
+		strcpy(cwrq, "IEEE 802.11g");
+	else
+		strcpy(cwrq, "IEEE 802.11b/g");
+
+	return 0;
+}
+
+static int ks_wlan_set_freq(struct net_device *dev,
+			    struct iw_request_info *info, struct iw_freq *fwrq,
+			    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	int channel;
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	/* If setting by frequency, convert to a channel */
+	if ((fwrq->e == 1) &&
+	    (fwrq->m >= (int)2.412e8) && (fwrq->m <= (int)2.487e8)) {
+		int f = fwrq->m / 100000;
+		int c = 0;
+
+		while ((c < 14) && (f != frequency_list[c]))
+			c++;
+		/* Hack to fall through... */
+		fwrq->e = 0;
+		fwrq->m = c + 1;
+	}
+	/* Setting by channel number */
+	if ((fwrq->m > 1000) || (fwrq->e > 0))
+		return -EOPNOTSUPP;
+
+	channel = fwrq->m;
+	/* We should do a better check than that,
+	 * based on the card capability !!!
+	 */
+	if ((channel < 1) || (channel > 14)) {
+		netdev_dbg(dev, "%s: New channel value of %d is invalid!\n",
+			   dev->name, fwrq->m);
+		return -EINVAL;
+	}
+
+	/* Yes ! We can set it !!! */
+	priv->reg.channel = (u8)(channel);
+	priv->need_commit |= SME_MODE_SET;
+
+	return -EINPROGRESS;	/* Call commit handler */
+}
+
+static int ks_wlan_get_freq(struct net_device *dev,
+			    struct iw_request_info *info, struct iw_freq *fwrq,
+			    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	int f;
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	if (is_connect_status(priv->connect_status))
+		f = (int)priv->current_ap.channel;
+	else
+		f = (int)priv->reg.channel;
+
+	fwrq->m = frequency_list[f - 1] * 100000;
+	fwrq->e = 1;
+
+	return 0;
+}
+
+static int ks_wlan_set_essid(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_point *dwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	size_t len;
+
+	DPRINTK(2, " %d\n", dwrq->flags);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	/* Check if we asked for `any' */
+	if (!dwrq->flags) {
+		/* Just send an empty SSID list */
+		memset(priv->reg.ssid.body, 0, sizeof(priv->reg.ssid.body));
+		priv->reg.ssid.size = 0;
+	} else {
+#if 1
+		len = dwrq->length;
+		/* iwconfig uses nul termination in SSID.. */
+		if (len > 0 && extra[len - 1] == '\0')
+			len--;
+
+		/* Check the size of the string */
+		if (len > IW_ESSID_MAX_SIZE)
+			return -EINVAL;
+
+#else
+		/* Check the size of the string */
+		if (dwrq->length > IW_ESSID_MAX_SIZE + 1)
+			return -E2BIG;
+
+#endif
+
+		/* Set the SSID */
+		memset(priv->reg.ssid.body, 0, sizeof(priv->reg.ssid.body));
+
+#if 1
+		memcpy(priv->reg.ssid.body, extra, len);
+		priv->reg.ssid.size = len;
+#else
+		memcpy(priv->reg.ssid.body, extra, dwrq->length);
+		priv->reg.ssid.size = dwrq->length;
+#endif
+	}
+	/* Write it to the card */
+	priv->need_commit |= SME_MODE_SET;
+
+//      return  -EINPROGRESS;   /* Call commit handler */
+	ks_wlan_setup_parameter(priv, priv->need_commit);
+	priv->need_commit = 0;
+	return 0;
+}
+
+static int ks_wlan_get_essid(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_point *dwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	/* Note : if dwrq->flags != 0, we should
+	 * get the relevant SSID from the SSID list...
+	 */
+	if (priv->reg.ssid.size != 0) {
+		/* Get the current SSID */
+		memcpy(extra, priv->reg.ssid.body, priv->reg.ssid.size);
+
+		/* If none, we may want to get the one that was set */
+
+		/* Push it out ! */
+		dwrq->length = priv->reg.ssid.size;
+		dwrq->flags = 1;	/* active */
+	} else {
+		dwrq->length = 0;
+		dwrq->flags = 0;	/* ANY */
+	}
+
+	return 0;
+}
+
+static int ks_wlan_set_wap(struct net_device *dev, struct iw_request_info *info,
+			   struct sockaddr *ap_addr, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	DPRINTK(2, "\n");
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	if (priv->reg.operation_mode == MODE_ADHOC ||
+	    priv->reg.operation_mode == MODE_INFRASTRUCTURE) {
+		memcpy(priv->reg.bssid, &ap_addr->sa_data, ETH_ALEN);
+
+		if (is_valid_ether_addr((u8 *)priv->reg.bssid))
+			priv->need_commit |= SME_MODE_SET;
+
+	} else {
+		eth_zero_addr(priv->reg.bssid);
+		return -EOPNOTSUPP;
+	}
+
+	DPRINTK(2, "bssid = %pM\n", priv->reg.bssid);
+
+	/* Write it to the card */
+	if (priv->need_commit) {
+		priv->need_commit |= SME_MODE_SET;
+		return -EINPROGRESS;	/* Call commit handler */
+	}
+	return 0;
+}
+
+static int ks_wlan_get_wap(struct net_device *dev, struct iw_request_info *info,
+			   struct sockaddr *awrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	if (is_connect_status(priv->connect_status))
+		memcpy(awrq->sa_data, priv->current_ap.bssid, ETH_ALEN);
+	else
+		eth_zero_addr(awrq->sa_data);
+
+	awrq->sa_family = ARPHRD_ETHER;
+
+	return 0;
+}
+
+static int ks_wlan_set_nick(struct net_device *dev,
+			    struct iw_request_info *info, struct iw_point *dwrq,
+			    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	/* Check the size of the string */
+	if (dwrq->length > 16 + 1)
+		return -E2BIG;
+
+	memset(priv->nick, 0, sizeof(priv->nick));
+	memcpy(priv->nick, extra, dwrq->length);
+
+	return -EINPROGRESS;	/* Call commit handler */
+}
+
+static int ks_wlan_get_nick(struct net_device *dev,
+			    struct iw_request_info *info, struct iw_point *dwrq,
+			    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	strncpy(extra, priv->nick, 16);
+	extra[16] = '\0';
+	dwrq->length = strlen(extra) + 1;
+
+	return 0;
+}
+
+static int ks_wlan_set_rate(struct net_device *dev,
+			    struct iw_request_info *info, struct iw_param *vwrq,
+			    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	int i = 0;
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	if (priv->reg.phy_type == D_11B_ONLY_MODE) {
+		if (vwrq->fixed == 1) {
+			switch (vwrq->value) {
+			case 11000000:
+			case 5500000:
+				priv->reg.rate_set.body[0] =
+				    (uint8_t)(vwrq->value / 500000);
+				break;
+			case 2000000:
+			case 1000000:
+				priv->reg.rate_set.body[0] =
+				    ((uint8_t)(vwrq->value / 500000)) |
+				    BASIC_RATE;
+				break;
+			default:
+				return -EINVAL;
+			}
+			priv->reg.tx_rate = TX_RATE_FIXED;
+			priv->reg.rate_set.size = 1;
+		} else {	/* vwrq->fixed == 0 */
+			if (vwrq->value > 0) {
+				switch (vwrq->value) {
+				case 11000000:
+					priv->reg.rate_set.body[3] =
+					    TX_RATE_11M;
+					i++;
+				case 5500000:
+					priv->reg.rate_set.body[2] = TX_RATE_5M;
+					i++;
+				case 2000000:
+					priv->reg.rate_set.body[1] =
+					    TX_RATE_2M | BASIC_RATE;
+					i++;
+				case 1000000:
+					priv->reg.rate_set.body[0] =
+					    TX_RATE_1M | BASIC_RATE;
+					i++;
+					break;
+				default:
+					return -EINVAL;
+				}
+				priv->reg.tx_rate = TX_RATE_MANUAL_AUTO;
+				priv->reg.rate_set.size = i;
+			} else {
+				priv->reg.rate_set.body[3] = TX_RATE_11M;
+				priv->reg.rate_set.body[2] = TX_RATE_5M;
+				priv->reg.rate_set.body[1] =
+				    TX_RATE_2M | BASIC_RATE;
+				priv->reg.rate_set.body[0] =
+				    TX_RATE_1M | BASIC_RATE;
+				priv->reg.tx_rate = TX_RATE_FULL_AUTO;
+				priv->reg.rate_set.size = 4;
+			}
+		}
+	} else {	/* D_11B_ONLY_MODE or  D_11BG_COMPATIBLE_MODE */
+		if (vwrq->fixed == 1) {
+			switch (vwrq->value) {
+			case 54000000:
+			case 48000000:
+			case 36000000:
+			case 18000000:
+			case 9000000:
+				priv->reg.rate_set.body[0] =
+				    (uint8_t)(vwrq->value / 500000);
+				break;
+			case 24000000:
+			case 12000000:
+			case 11000000:
+			case 6000000:
+			case 5500000:
+			case 2000000:
+			case 1000000:
+				priv->reg.rate_set.body[0] =
+				    ((uint8_t)(vwrq->value / 500000)) |
+				    BASIC_RATE;
+				break;
+			default:
+				return -EINVAL;
+			}
+			priv->reg.tx_rate = TX_RATE_FIXED;
+			priv->reg.rate_set.size = 1;
+		} else {	/* vwrq->fixed == 0 */
+			if (vwrq->value > 0) {
+				switch (vwrq->value) {
+				case 54000000:
+					priv->reg.rate_set.body[11] =
+					    TX_RATE_54M;
+					i++;
+				case 48000000:
+					priv->reg.rate_set.body[10] =
+					    TX_RATE_48M;
+					i++;
+				case 36000000:
+					priv->reg.rate_set.body[9] =
+					    TX_RATE_36M;
+					i++;
+				case 24000000:
+				case 18000000:
+				case 12000000:
+				case 11000000:
+				case 9000000:
+				case 6000000:
+					if (vwrq->value == 24000000) {
+						priv->reg.rate_set.body[8] =
+						    TX_RATE_18M;
+						i++;
+						priv->reg.rate_set.body[7] =
+						    TX_RATE_9M;
+						i++;
+						priv->reg.rate_set.body[6] =
+						    TX_RATE_24M | BASIC_RATE;
+						i++;
+						priv->reg.rate_set.body[5] =
+						    TX_RATE_12M | BASIC_RATE;
+						i++;
+						priv->reg.rate_set.body[4] =
+						    TX_RATE_6M | BASIC_RATE;
+						i++;
+						priv->reg.rate_set.body[3] =
+						    TX_RATE_11M | BASIC_RATE;
+						i++;
+					} else if (vwrq->value == 18000000) {
+						priv->reg.rate_set.body[7] =
+						    TX_RATE_18M;
+						i++;
+						priv->reg.rate_set.body[6] =
+						    TX_RATE_9M;
+						i++;
+						priv->reg.rate_set.body[5] =
+						    TX_RATE_12M | BASIC_RATE;
+						i++;
+						priv->reg.rate_set.body[4] =
+						    TX_RATE_6M | BASIC_RATE;
+						i++;
+						priv->reg.rate_set.body[3] =
+						    TX_RATE_11M | BASIC_RATE;
+						i++;
+					} else if (vwrq->value == 12000000) {
+						priv->reg.rate_set.body[6] =
+						    TX_RATE_9M;
+						i++;
+						priv->reg.rate_set.body[5] =
+						    TX_RATE_12M | BASIC_RATE;
+						i++;
+						priv->reg.rate_set.body[4] =
+						    TX_RATE_6M | BASIC_RATE;
+						i++;
+						priv->reg.rate_set.body[3] =
+						    TX_RATE_11M | BASIC_RATE;
+						i++;
+					} else if (vwrq->value == 11000000) {
+						priv->reg.rate_set.body[5] =
+						    TX_RATE_9M;
+						i++;
+						priv->reg.rate_set.body[4] =
+						    TX_RATE_6M | BASIC_RATE;
+						i++;
+						priv->reg.rate_set.body[3] =
+						    TX_RATE_11M | BASIC_RATE;
+						i++;
+					} else if (vwrq->value == 9000000) {
+						priv->reg.rate_set.body[4] =
+						    TX_RATE_9M;
+						i++;
+						priv->reg.rate_set.body[3] =
+						    TX_RATE_6M | BASIC_RATE;
+						i++;
+					} else {	/* vwrq->value == 6000000 */
+						priv->reg.rate_set.body[3] =
+						    TX_RATE_6M | BASIC_RATE;
+						i++;
+					}
+				case 5500000:
+					priv->reg.rate_set.body[2] =
+					    TX_RATE_5M | BASIC_RATE;
+					i++;
+				case 2000000:
+					priv->reg.rate_set.body[1] =
+					    TX_RATE_2M | BASIC_RATE;
+					i++;
+				case 1000000:
+					priv->reg.rate_set.body[0] =
+					    TX_RATE_1M | BASIC_RATE;
+					i++;
+					break;
+				default:
+					return -EINVAL;
+				}
+				priv->reg.tx_rate = TX_RATE_MANUAL_AUTO;
+				priv->reg.rate_set.size = i;
+			} else {
+				priv->reg.rate_set.body[11] = TX_RATE_54M;
+				priv->reg.rate_set.body[10] = TX_RATE_48M;
+				priv->reg.rate_set.body[9] = TX_RATE_36M;
+				priv->reg.rate_set.body[8] = TX_RATE_18M;
+				priv->reg.rate_set.body[7] = TX_RATE_9M;
+				priv->reg.rate_set.body[6] =
+				    TX_RATE_24M | BASIC_RATE;
+				priv->reg.rate_set.body[5] =
+				    TX_RATE_12M | BASIC_RATE;
+				priv->reg.rate_set.body[4] =
+				    TX_RATE_6M | BASIC_RATE;
+				priv->reg.rate_set.body[3] =
+				    TX_RATE_11M | BASIC_RATE;
+				priv->reg.rate_set.body[2] =
+				    TX_RATE_5M | BASIC_RATE;
+				priv->reg.rate_set.body[1] =
+				    TX_RATE_2M | BASIC_RATE;
+				priv->reg.rate_set.body[0] =
+				    TX_RATE_1M | BASIC_RATE;
+				priv->reg.tx_rate = TX_RATE_FULL_AUTO;
+				priv->reg.rate_set.size = 12;
+			}
+		}
+	}
+
+	priv->need_commit |= SME_MODE_SET;
+
+	return -EINPROGRESS;	/* Call commit handler */
+}
+
+static int ks_wlan_get_rate(struct net_device *dev,
+			    struct iw_request_info *info, struct iw_param *vwrq,
+			    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	DPRINTK(2, "in_interrupt = %ld update_phyinfo = %d\n",
+		in_interrupt(), atomic_read(&update_phyinfo));
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	if (!atomic_read(&update_phyinfo))
+		ks_wlan_update_phy_information(priv);
+
+	vwrq->value = ((priv->current_rate) & RATE_MASK) * 500000;
+	if (priv->reg.tx_rate == TX_RATE_FIXED)
+		vwrq->fixed = 1;
+	else
+		vwrq->fixed = 0;
+
+	return 0;
+}
+
+static int ks_wlan_set_rts(struct net_device *dev, struct iw_request_info *info,
+			   struct iw_param *vwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	int rthr = vwrq->value;
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	if (vwrq->disabled)
+		rthr = 2347;
+	if ((rthr < 0) || (rthr > 2347))
+		return -EINVAL;
+
+	priv->reg.rts = rthr;
+	priv->need_commit |= SME_RTS;
+
+	return -EINPROGRESS;	/* Call commit handler */
+}
+
+static int ks_wlan_get_rts(struct net_device *dev, struct iw_request_info *info,
+			   struct iw_param *vwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	vwrq->value = priv->reg.rts;
+	vwrq->disabled = (vwrq->value >= 2347);
+	vwrq->fixed = 1;
+
+	return 0;
+}
+
+static int ks_wlan_set_frag(struct net_device *dev,
+			    struct iw_request_info *info, struct iw_param *vwrq,
+			    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	int fthr = vwrq->value;
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	if (vwrq->disabled)
+		fthr = 2346;
+	if ((fthr < 256) || (fthr > 2346))
+		return -EINVAL;
+
+	fthr &= ~0x1;	/* Get an even value - is it really needed ??? */
+	priv->reg.fragment = fthr;
+	priv->need_commit |= SME_FRAG;
+
+	return -EINPROGRESS;	/* Call commit handler */
+}
+
+static int ks_wlan_get_frag(struct net_device *dev,
+			    struct iw_request_info *info, struct iw_param *vwrq,
+			    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	vwrq->value = priv->reg.fragment;
+	vwrq->disabled = (vwrq->value >= 2346);
+	vwrq->fixed = 1;
+
+	return 0;
+}
+
+static int ks_wlan_set_mode(struct net_device *dev,
+			    struct iw_request_info *info, __u32 *uwrq,
+			    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	DPRINTK(2, "mode=%d\n", *uwrq);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	switch (*uwrq) {
+	case IW_MODE_ADHOC:
+		priv->reg.operation_mode = MODE_ADHOC;
+		priv->need_commit |= SME_MODE_SET;
+		break;
+	case IW_MODE_INFRA:
+		priv->reg.operation_mode = MODE_INFRASTRUCTURE;
+		priv->need_commit |= SME_MODE_SET;
+		break;
+	case IW_MODE_AUTO:
+	case IW_MODE_MASTER:
+	case IW_MODE_REPEAT:
+	case IW_MODE_SECOND:
+	case IW_MODE_MONITOR:
+	default:
+		return -EINVAL;
+	}
+
+	return -EINPROGRESS;	/* Call commit handler */
+}
+
+static int ks_wlan_get_mode(struct net_device *dev,
+			    struct iw_request_info *info, __u32 *uwrq,
+			    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	/* If not managed, assume it's ad-hoc */
+	switch (priv->reg.operation_mode) {
+	case MODE_INFRASTRUCTURE:
+		*uwrq = IW_MODE_INFRA;
+		break;
+	case MODE_ADHOC:
+		*uwrq = IW_MODE_ADHOC;
+		break;
+	default:
+		*uwrq = IW_MODE_ADHOC;
+	}
+
+	return 0;
+}
+
+static int ks_wlan_set_encode(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_point *dwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	struct wep_key key;
+	int index = (dwrq->flags & IW_ENCODE_INDEX);
+	int current_index = priv->reg.wep_index;
+	int i;
+
+	DPRINTK(2, "flags=%04X\n", dwrq->flags);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	/* index check */
+	if ((index < 0) || (index > 4))
+		return -EINVAL;
+	else if (index == 0)
+		index = current_index;
+	else
+		index--;
+
+	/* Is WEP supported ? */
+	/* Basic checking: do we have a key to set ? */
+	if (dwrq->length > 0) {
+		if (dwrq->length > MAX_KEY_SIZE) {	/* Check the size of the key */
+			return -EINVAL;
+		}
+		if (dwrq->length > MIN_KEY_SIZE) {	/* Set the length */
+			key.len = MAX_KEY_SIZE;
+			priv->reg.privacy_invoked = 0x01;
+			priv->need_commit |= SME_WEP_FLAG;
+			wep_on_off = WEP_ON_128BIT;
+		} else {
+			if (dwrq->length > 0) {
+				key.len = MIN_KEY_SIZE;
+				priv->reg.privacy_invoked = 0x01;
+				priv->need_commit |= SME_WEP_FLAG;
+				wep_on_off = WEP_ON_64BIT;
+			} else {	/* Disable the key */
+				key.len = 0;
+			}
+		}
+		/* Check if the key is not marked as invalid */
+		if (!(dwrq->flags & IW_ENCODE_NOKEY)) {
+			/* Cleanup */
+			memset(key.key, 0, MAX_KEY_SIZE);
+			/* Copy the key in the driver */
+			if (copy_from_user
+			    (key.key, dwrq->pointer, dwrq->length)) {
+				key.len = 0;
+				return -EFAULT;
+			}
+			/* Send the key to the card */
+			priv->reg.wep_key[index].size = key.len;
+			for (i = 0; i < (priv->reg.wep_key[index].size); i++)
+				priv->reg.wep_key[index].val[i] = key.key[i];
+
+			priv->need_commit |= (SME_WEP_VAL1 << index);
+			priv->reg.wep_index = index;
+			priv->need_commit |= SME_WEP_INDEX;
+		}
+	} else {
+		if (dwrq->flags & IW_ENCODE_DISABLED) {
+			priv->reg.wep_key[0].size = 0;
+			priv->reg.wep_key[1].size = 0;
+			priv->reg.wep_key[2].size = 0;
+			priv->reg.wep_key[3].size = 0;
+			priv->reg.privacy_invoked = 0x00;
+			if (priv->reg.authenticate_type == AUTH_TYPE_SHARED_KEY)
+				priv->need_commit |= SME_MODE_SET;
+
+			priv->reg.authenticate_type = AUTH_TYPE_OPEN_SYSTEM;
+			wep_on_off = WEP_OFF;
+			priv->need_commit |= SME_WEP_FLAG;
+		} else {
+			/* Do we want to just set the transmit key index ? */
+			if ((index >= 0) && (index < 4)) {
+				/* set_wep_key(priv, index, 0, 0, 1);   xxx */
+				if (priv->reg.wep_key[index].size != 0) {
+					priv->reg.wep_index = index;
+					priv->need_commit |= SME_WEP_INDEX;
+				} else {
+					return -EINVAL;
+				}
+			}
+		}
+	}
+
+	/* Commit the changes if needed */
+	if (dwrq->flags & IW_ENCODE_MODE)
+		priv->need_commit |= SME_WEP_FLAG;
+
+	if (dwrq->flags & IW_ENCODE_OPEN) {
+		if (priv->reg.authenticate_type == AUTH_TYPE_SHARED_KEY)
+			priv->need_commit |= SME_MODE_SET;
+
+		priv->reg.authenticate_type = AUTH_TYPE_OPEN_SYSTEM;
+	} else if (dwrq->flags & IW_ENCODE_RESTRICTED) {
+		if (priv->reg.authenticate_type == AUTH_TYPE_OPEN_SYSTEM)
+			priv->need_commit |= SME_MODE_SET;
+
+		priv->reg.authenticate_type = AUTH_TYPE_SHARED_KEY;
+	}
+//      return -EINPROGRESS;            /* Call commit handler */
+	if (priv->need_commit) {
+		ks_wlan_setup_parameter(priv, priv->need_commit);
+		priv->need_commit = 0;
+	}
+	return 0;
+}
+
+static int ks_wlan_get_encode(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_point *dwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	char zeros[16];
+	int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	dwrq->flags = IW_ENCODE_DISABLED;
+
+	/* Check encryption mode */
+	switch (priv->reg.authenticate_type) {
+	case AUTH_TYPE_OPEN_SYSTEM:
+		dwrq->flags = IW_ENCODE_OPEN;
+		break;
+	case AUTH_TYPE_SHARED_KEY:
+		dwrq->flags = IW_ENCODE_RESTRICTED;
+		break;
+	}
+
+	memset(zeros, 0, sizeof(zeros));
+
+	/* Which key do we want ? -1 -> tx index */
+	if ((index < 0) || (index >= 4))
+		index = priv->reg.wep_index;
+	if (priv->reg.privacy_invoked) {
+		dwrq->flags &= ~IW_ENCODE_DISABLED;
+		/* dwrq->flags |= IW_ENCODE_NOKEY; */
+	}
+	dwrq->flags |= index + 1;
+	DPRINTK(2, "encoding flag = 0x%04X\n", dwrq->flags);
+	/* Copy the key to the user buffer */
+	if ((index >= 0) && (index < 4))
+		dwrq->length = priv->reg.wep_key[index].size;
+	if (dwrq->length > 16)
+		dwrq->length = 0;
+#if 1	/* IW_ENCODE_NOKEY; */
+	if (dwrq->length) {
+		if ((index >= 0) && (index < 4))
+			memcpy(extra, priv->reg.wep_key[index].val,
+			       dwrq->length);
+	} else {
+		memcpy(extra, zeros, dwrq->length);
+	}
+#endif
+	return 0;
+}
+
+#ifndef KSC_OPNOTSUPP
+static int ks_wlan_set_txpow(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_param *vwrq, char *extra)
+{
+	return -EOPNOTSUPP;	/* Not Support */
+}
+
+static int ks_wlan_get_txpow(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_param *vwrq, char *extra)
+{
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	/* Not Support */
+	vwrq->value = 0;
+	vwrq->disabled = (vwrq->value == 0);
+	vwrq->fixed = 1;
+	return 0;
+}
+
+static int ks_wlan_set_retry(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_param *vwrq, char *extra)
+{
+	return -EOPNOTSUPP;	/* Not Support */
+}
+
+static int ks_wlan_get_retry(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_param *vwrq, char *extra)
+{
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	/* Not Support */
+	vwrq->value = 0;
+	vwrq->disabled = (vwrq->value == 0);
+	vwrq->fixed = 1;
+	return 0;
+}
+#endif /* KSC_OPNOTSUPP */
+
+static int ks_wlan_get_range(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_point *dwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	struct iw_range *range = (struct iw_range *)extra;
+	int i, k;
+
+	DPRINTK(2, "\n");
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	dwrq->length = sizeof(struct iw_range);
+	memset(range, 0, sizeof(*range));
+	range->min_nwid = 0x0000;
+	range->max_nwid = 0x0000;
+	range->num_channels = 14;
+	/* Should be based on cap_rid.country to give only
+	 * what the current card support
+	 */
+	k = 0;
+	for (i = 0; i < 13; i++) {	/* channel 1 -- 13 */
+		range->freq[k].i = i + 1;	/* List index */
+		range->freq[k].m = frequency_list[i] * 100000;
+		range->freq[k++].e = 1;	/* Values in table in MHz -> * 10^5 * 10 */
+	}
+	range->num_frequency = k;
+	if (priv->reg.phy_type == D_11B_ONLY_MODE || priv->reg.phy_type == D_11BG_COMPATIBLE_MODE) {	/* channel 14 */
+		range->freq[13].i = 14;	/* List index */
+		range->freq[13].m = frequency_list[13] * 100000;
+		range->freq[13].e = 1;	/* Values in table in MHz -> * 10^5 * 10 */
+		range->num_frequency = 14;
+	}
+
+	/* Hum... Should put the right values there */
+	range->max_qual.qual = 100;
+	range->max_qual.level = 256 - 128;	/* 0 dBm? */
+	range->max_qual.noise = 256 - 128;
+	range->sensitivity = 1;
+
+	if (priv->reg.phy_type == D_11B_ONLY_MODE) {
+		range->bitrate[0] = 1e6;
+		range->bitrate[1] = 2e6;
+		range->bitrate[2] = 5.5e6;
+		range->bitrate[3] = 11e6;
+		range->num_bitrates = 4;
+	} else {	/* D_11G_ONLY_MODE or D_11BG_COMPATIBLE_MODE */
+		range->bitrate[0] = 1e6;
+		range->bitrate[1] = 2e6;
+		range->bitrate[2] = 5.5e6;
+		range->bitrate[3] = 11e6;
+
+		range->bitrate[4] = 6e6;
+		range->bitrate[5] = 9e6;
+		range->bitrate[6] = 12e6;
+		if (IW_MAX_BITRATES < 9) {
+			range->bitrate[7] = 54e6;
+			range->num_bitrates = 8;
+		} else {
+			range->bitrate[7] = 18e6;
+			range->bitrate[8] = 24e6;
+			range->bitrate[9] = 36e6;
+			range->bitrate[10] = 48e6;
+			range->bitrate[11] = 54e6;
+
+			range->num_bitrates = 12;
+		}
+	}
+
+	/* Set an indication of the max TCP throughput
+	 * in bit/s that we can expect using this interface.
+	 * May be use for QoS stuff... Jean II
+	 */
+	if (i > 2)
+		range->throughput = 5000 * 1000;
+	else
+		range->throughput = 1500 * 1000;
+
+	range->min_rts = 0;
+	range->max_rts = 2347;
+	range->min_frag = 256;
+	range->max_frag = 2346;
+
+	range->encoding_size[0] = 5;	/* WEP: RC4 40 bits */
+	range->encoding_size[1] = 13;	/* WEP: RC4 ~128 bits */
+	range->num_encoding_sizes = 2;
+	range->max_encoding_tokens = 4;
+
+	/* power management not support */
+	range->pmp_flags = IW_POWER_ON;
+	range->pmt_flags = IW_POWER_ON;
+	range->pm_capa = 0;
+
+	/* Transmit Power - values are in dBm( or mW) */
+	range->txpower[0] = -256;
+	range->num_txpower = 1;
+	range->txpower_capa = IW_TXPOW_DBM;
+	/* range->txpower_capa = IW_TXPOW_MWATT; */
+
+	range->we_version_source = 21;
+	range->we_version_compiled = WIRELESS_EXT;
+
+	range->retry_capa = IW_RETRY_ON;
+	range->retry_flags = IW_RETRY_ON;
+	range->r_time_flags = IW_RETRY_ON;
+
+	/* Experimental measurements - boundary 11/5.5 Mb/s
+	 *
+	 * Note : with or without the (local->rssi), results
+	 * are somewhat different. - Jean II
+	 */
+	range->avg_qual.qual = 50;
+	range->avg_qual.level = 186;	/* -70 dBm */
+	range->avg_qual.noise = 0;
+
+	/* Event capability (kernel + driver) */
+	range->event_capa[0] = (IW_EVENT_CAPA_K_0 |
+				IW_EVENT_CAPA_MASK(SIOCGIWAP) |
+				IW_EVENT_CAPA_MASK(SIOCGIWSCAN));
+	range->event_capa[1] = IW_EVENT_CAPA_K_1;
+	range->event_capa[4] = (IW_EVENT_CAPA_MASK(IWEVCUSTOM) |
+				IW_EVENT_CAPA_MASK(IWEVMICHAELMICFAILURE));
+
+	/* encode extension (WPA) capability */
+	range->enc_capa = (IW_ENC_CAPA_WPA |
+			   IW_ENC_CAPA_WPA2 |
+			   IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP);
+	return 0;
+}
+
+static int ks_wlan_set_power(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_param *vwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	if (vwrq->disabled) {
+		priv->reg.power_mgmt = POWER_MGMT_ACTIVE;
+	} else {
+		if (priv->reg.operation_mode == MODE_INFRASTRUCTURE)
+			priv->reg.power_mgmt = POWER_MGMT_SAVE1;
+		else
+			return -EINVAL;
+	}
+
+	hostif_sme_enqueue(priv, SME_POW_MNGMT_REQUEST);
+
+	return 0;
+}
+
+static int ks_wlan_get_power(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_param *vwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	if (priv->reg.power_mgmt > 0)
+		vwrq->disabled = 0;
+	else
+		vwrq->disabled = 1;
+
+	return 0;
+}
+
+static int ks_wlan_get_iwstats(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_quality *vwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	vwrq->qual = 0;	/* not supported */
+	vwrq->level = priv->wstats.qual.level;
+	vwrq->noise = 0;	/* not supported */
+	vwrq->updated = 0;
+
+	return 0;
+}
+
+#ifndef KSC_OPNOTSUPP
+
+static int ks_wlan_set_sens(struct net_device *dev,
+			    struct iw_request_info *info, struct iw_param *vwrq,
+			    char *extra)
+{
+	return -EOPNOTSUPP;	/* Not Support */
+}
+
+static int ks_wlan_get_sens(struct net_device *dev,
+			    struct iw_request_info *info, struct iw_param *vwrq,
+			    char *extra)
+{
+	/* Not Support */
+	vwrq->value = 0;
+	vwrq->disabled = (vwrq->value == 0);
+	vwrq->fixed = 1;
+	return 0;
+}
+#endif /* KSC_OPNOTSUPP */
+
+/* Note : this is deprecated in favor of IWSCAN */
+static int ks_wlan_get_aplist(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_point *dwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	struct sockaddr *address = (struct sockaddr *)extra;
+	struct iw_quality qual[LOCAL_APLIST_MAX];
+
+	int i;
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	for (i = 0; i < priv->aplist.size; i++) {
+		memcpy(address[i].sa_data, &(priv->aplist.ap[i].bssid[0]),
+		       ETH_ALEN);
+		address[i].sa_family = ARPHRD_ETHER;
+		qual[i].level = 256 - priv->aplist.ap[i].rssi;
+		qual[i].qual = priv->aplist.ap[i].sq;
+		qual[i].noise = 0;	/* invalid noise value */
+		qual[i].updated = 7;
+	}
+	if (i) {
+		dwrq->flags = 1;	/* Should be define'd */
+		memcpy(extra + sizeof(struct sockaddr) * i,
+		       &qual, sizeof(struct iw_quality) * i);
+	}
+	dwrq->length = i;
+
+	return 0;
+}
+
+static int ks_wlan_set_scan(struct net_device *dev,
+			    struct iw_request_info *info,
+			    union iwreq_data *wrqu, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	struct iw_scan_req *req = NULL;
+
+	DPRINTK(2, "\n");
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	/* specified SSID SCAN */
+	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
+	    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
+		req = (struct iw_scan_req *)extra;
+		priv->scan_ssid_len = req->essid_len;
+		memcpy(priv->scan_ssid, req->essid, priv->scan_ssid_len);
+	} else {
+		priv->scan_ssid_len = 0;
+	}
+
+	priv->sme_i.sme_flag |= SME_AP_SCAN;
+	hostif_sme_enqueue(priv, SME_BSS_SCAN_REQUEST);
+
+	/* At this point, just return to the user. */
+
+	return 0;
+}
+
+/*
+ * Translate scan data returned from the card to a card independent
+ * format that the Wireless Tools will understand - Jean II
+ */
+static inline char *ks_wlan_translate_scan(struct net_device *dev,
+					   struct iw_request_info *info,
+					   char *current_ev, char *end_buf,
+					   struct local_ap_t *ap)
+{
+	/* struct ks_wlan_private *priv = (struct ks_wlan_private *)dev->priv; */
+	struct iw_event iwe;	/* Temporary buffer */
+	u16 capabilities;
+	char *current_val;	/* For rates */
+	int i;
+	static const char rsn_leader[] = "rsn_ie=";
+	static const char wpa_leader[] = "wpa_ie=";
+	char buf0[RSN_IE_BODY_MAX * 2 + 30];
+	char buf1[RSN_IE_BODY_MAX * 2 + 30];
+	char *pbuf;
+	/* First entry *MUST* be the AP MAC address */
+	iwe.cmd = SIOCGIWAP;
+	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
+	memcpy(iwe.u.ap_addr.sa_data, ap->bssid, ETH_ALEN);
+	current_ev =
+	    iwe_stream_add_event(info, current_ev, end_buf, &iwe,
+				 IW_EV_ADDR_LEN);
+
+	/* Other entries will be displayed in the order we give them */
+
+	/* Add the ESSID */
+	iwe.u.data.length = ap->ssid.size;
+	if (iwe.u.data.length > 32)
+		iwe.u.data.length = 32;
+	iwe.cmd = SIOCGIWESSID;
+	iwe.u.data.flags = 1;
+	current_ev =
+	    iwe_stream_add_point(info, current_ev, end_buf, &iwe,
+				 ap->ssid.body);
+
+	/* Add mode */
+	iwe.cmd = SIOCGIWMODE;
+	capabilities = le16_to_cpu(ap->capability);
+	if (capabilities & (BSS_CAP_ESS | BSS_CAP_IBSS)) {
+		if (capabilities & BSS_CAP_ESS)
+			iwe.u.mode = IW_MODE_INFRA;
+		else
+			iwe.u.mode = IW_MODE_ADHOC;
+		current_ev =
+		    iwe_stream_add_event(info, current_ev, end_buf, &iwe,
+					 IW_EV_UINT_LEN);
+	}
+
+	/* Add frequency */
+	iwe.cmd = SIOCGIWFREQ;
+	iwe.u.freq.m = ap->channel;
+	iwe.u.freq.m = frequency_list[iwe.u.freq.m - 1] * 100000;
+	iwe.u.freq.e = 1;
+	current_ev =
+	    iwe_stream_add_event(info, current_ev, end_buf, &iwe,
+				 IW_EV_FREQ_LEN);
+
+	/* Add quality statistics */
+	iwe.cmd = IWEVQUAL;
+	iwe.u.qual.level = 256 - ap->rssi;
+	iwe.u.qual.qual = ap->sq;
+	iwe.u.qual.noise = 0;	/* invalid noise value */
+	current_ev =
+	    iwe_stream_add_event(info, current_ev, end_buf, &iwe,
+				 IW_EV_QUAL_LEN);
+
+	/* Add encryption capability */
+	iwe.cmd = SIOCGIWENCODE;
+	if (capabilities & BSS_CAP_PRIVACY)
+		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
+	else
+		iwe.u.data.flags = IW_ENCODE_DISABLED;
+	iwe.u.data.length = 0;
+	current_ev =
+	    iwe_stream_add_point(info, current_ev, end_buf, &iwe,
+				 ap->ssid.body);
+
+	/* Rate : stuffing multiple values in a single event require a bit
+	 * more of magic - Jean II
+	 */
+	current_val = current_ev + IW_EV_LCP_LEN;
+
+	iwe.cmd = SIOCGIWRATE;
+
+	/* These two flags are ignored... */
+	iwe.u.bitrate.fixed = 0;
+	iwe.u.bitrate.disabled = 0;
+
+	/* Max 16 values */
+	for (i = 0; i < 16; i++) {
+		/* NULL terminated */
+		if (i >= ap->rate_set.size)
+			break;
+		/* Bit rate given in 500 kb/s units (+ 0x80) */
+		iwe.u.bitrate.value = ((ap->rate_set.body[i] & 0x7f) * 500000);
+		/* Add new value to event */
+		current_val =
+		    iwe_stream_add_value(info, current_ev, current_val, end_buf,
+					 &iwe, IW_EV_PARAM_LEN);
+	}
+	/* Check if we added any event */
+	if ((current_val - current_ev) > IW_EV_LCP_LEN)
+		current_ev = current_val;
+
+#define GENERIC_INFO_ELEM_ID 0xdd
+#define RSN_INFO_ELEM_ID 0x30
+	if (ap->rsn_ie.id == RSN_INFO_ELEM_ID && ap->rsn_ie.size != 0) {
+		pbuf = &buf0[0];
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVCUSTOM;
+		memcpy(buf0, rsn_leader, sizeof(rsn_leader) - 1);
+		iwe.u.data.length += sizeof(rsn_leader) - 1;
+		pbuf += sizeof(rsn_leader) - 1;
+
+		pbuf += sprintf(pbuf, "%02x", ap->rsn_ie.id);
+		pbuf += sprintf(pbuf, "%02x", ap->rsn_ie.size);
+		iwe.u.data.length += 4;
+
+		for (i = 0; i < ap->rsn_ie.size; i++)
+			pbuf += sprintf(pbuf, "%02x", ap->rsn_ie.body[i]);
+		iwe.u.data.length += (ap->rsn_ie.size) * 2;
+
+		DPRINTK(4, "ap->rsn.size=%d\n", ap->rsn_ie.size);
+
+		current_ev =
+		    iwe_stream_add_point(info, current_ev, end_buf, &iwe,
+					 &buf0[0]);
+	}
+	if (ap->wpa_ie.id == GENERIC_INFO_ELEM_ID && ap->wpa_ie.size != 0) {
+		pbuf = &buf1[0];
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVCUSTOM;
+		memcpy(buf1, wpa_leader, sizeof(wpa_leader) - 1);
+		iwe.u.data.length += sizeof(wpa_leader) - 1;
+		pbuf += sizeof(wpa_leader) - 1;
+
+		pbuf += sprintf(pbuf, "%02x", ap->wpa_ie.id);
+		pbuf += sprintf(pbuf, "%02x", ap->wpa_ie.size);
+		iwe.u.data.length += 4;
+
+		for (i = 0; i < ap->wpa_ie.size; i++)
+			pbuf += sprintf(pbuf, "%02x", ap->wpa_ie.body[i]);
+		iwe.u.data.length += (ap->wpa_ie.size) * 2;
+
+		DPRINTK(4, "ap->rsn.size=%d\n", ap->wpa_ie.size);
+		DPRINTK(4, "iwe.u.data.length=%d\n", iwe.u.data.length);
+
+		current_ev =
+		    iwe_stream_add_point(info, current_ev, end_buf, &iwe,
+					 &buf1[0]);
+	}
+
+	/* The other data in the scan result are not really
+	 * interesting, so for now drop it - Jean II
+	 */
+	return current_ev;
+}
+
+static int ks_wlan_get_scan(struct net_device *dev,
+			    struct iw_request_info *info, struct iw_point *dwrq,
+			    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	int i;
+	char *current_ev = extra;
+
+	DPRINTK(2, "\n");
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	if (priv->sme_i.sme_flag & SME_AP_SCAN) {
+		DPRINTK(2, "flag AP_SCAN\n");
+		return -EAGAIN;
+	}
+
+	if (priv->aplist.size == 0) {
+		/* Client error, no scan results...
+		 * The caller need to restart the scan.
+		 */
+		DPRINTK(2, "aplist 0\n");
+		return -ENODATA;
+	}
+
+	/* Read and parse all entries */
+	for (i = 0; i < priv->aplist.size; i++) {
+		if ((extra + dwrq->length) - current_ev <= IW_EV_ADDR_LEN) {
+			dwrq->length = 0;
+			return -E2BIG;
+		}
+		/* Translate to WE format this entry */
+		current_ev = ks_wlan_translate_scan(dev, info, current_ev,
+						    extra + dwrq->length,
+						    &priv->aplist.ap[i]);
+	}
+	/* Length of data */
+	dwrq->length = (current_ev - extra);
+	dwrq->flags = 0;
+
+	return 0;
+}
+
+/* called after a bunch of SET operations */
+static int ks_wlan_config_commit(struct net_device *dev,
+				 struct iw_request_info *info, void *zwrq,
+				 char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (!priv->need_commit)
+		return 0;
+
+	ks_wlan_setup_parameter(priv, priv->need_commit);
+	priv->need_commit = 0;
+	return 0;
+}
+
+/* set association ie params */
+static int ks_wlan_set_genie(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_point *dwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	DPRINTK(2, "\n");
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	return 0;
+//      return -EOPNOTSUPP;
+}
+
+static int ks_wlan_set_auth_mode(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_param *vwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	int index = (vwrq->flags & IW_AUTH_INDEX);
+	int value = vwrq->value;
+
+	DPRINTK(2, "index=%d:value=%08X\n", index, value);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	switch (index) {
+	case IW_AUTH_WPA_VERSION:	/* 0 */
+		switch (value) {
+		case IW_AUTH_WPA_VERSION_DISABLED:
+			priv->wpa.version = value;
+			if (priv->wpa.rsn_enabled)
+				priv->wpa.rsn_enabled = 0;
+			priv->need_commit |= SME_RSN;
+			break;
+		case IW_AUTH_WPA_VERSION_WPA:
+		case IW_AUTH_WPA_VERSION_WPA2:
+			priv->wpa.version = value;
+			if (!(priv->wpa.rsn_enabled))
+				priv->wpa.rsn_enabled = 1;
+			priv->need_commit |= SME_RSN;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+		break;
+	case IW_AUTH_CIPHER_PAIRWISE:	/* 1 */
+		switch (value) {
+		case IW_AUTH_CIPHER_NONE:
+			if (priv->reg.privacy_invoked) {
+				priv->reg.privacy_invoked = 0x00;
+				priv->need_commit |= SME_WEP_FLAG;
+			}
+			break;
+		case IW_AUTH_CIPHER_WEP40:
+		case IW_AUTH_CIPHER_TKIP:
+		case IW_AUTH_CIPHER_CCMP:
+		case IW_AUTH_CIPHER_WEP104:
+			if (!priv->reg.privacy_invoked) {
+				priv->reg.privacy_invoked = 0x01;
+				priv->need_commit |= SME_WEP_FLAG;
+			}
+			priv->wpa.pairwise_suite = value;
+			priv->need_commit |= SME_RSN_UNICAST;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+		break;
+	case IW_AUTH_CIPHER_GROUP:	/* 2 */
+		switch (value) {
+		case IW_AUTH_CIPHER_NONE:
+			if (priv->reg.privacy_invoked) {
+				priv->reg.privacy_invoked = 0x00;
+				priv->need_commit |= SME_WEP_FLAG;
+			}
+			break;
+		case IW_AUTH_CIPHER_WEP40:
+		case IW_AUTH_CIPHER_TKIP:
+		case IW_AUTH_CIPHER_CCMP:
+		case IW_AUTH_CIPHER_WEP104:
+			if (!priv->reg.privacy_invoked) {
+				priv->reg.privacy_invoked = 0x01;
+				priv->need_commit |= SME_WEP_FLAG;
+			}
+			priv->wpa.group_suite = value;
+			priv->need_commit |= SME_RSN_MULTICAST;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+		break;
+	case IW_AUTH_KEY_MGMT:	/* 3 */
+		switch (value) {
+		case IW_AUTH_KEY_MGMT_802_1X:
+		case IW_AUTH_KEY_MGMT_PSK:
+		case 0:	/* NONE or 802_1X_NO_WPA */
+		case 4:	/* WPA_NONE */
+			priv->wpa.key_mgmt_suite = value;
+			priv->need_commit |= SME_RSN_AUTH;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+		break;
+	case IW_AUTH_80211_AUTH_ALG:	/* 6 */
+		switch (value) {
+		case IW_AUTH_ALG_OPEN_SYSTEM:
+			priv->wpa.auth_alg = value;
+			priv->reg.authenticate_type = AUTH_TYPE_OPEN_SYSTEM;
+			break;
+		case IW_AUTH_ALG_SHARED_KEY:
+			priv->wpa.auth_alg = value;
+			priv->reg.authenticate_type = AUTH_TYPE_SHARED_KEY;
+			break;
+		case IW_AUTH_ALG_LEAP:
+		default:
+			return -EOPNOTSUPP;
+		}
+		priv->need_commit |= SME_MODE_SET;
+		break;
+	case IW_AUTH_WPA_ENABLED:	/* 7 */
+		priv->wpa.wpa_enabled = value;
+		break;
+	case IW_AUTH_PRIVACY_INVOKED:	/* 10 */
+		if ((value && !priv->reg.privacy_invoked) ||
+		    (!value && priv->reg.privacy_invoked)) {
+			priv->reg.privacy_invoked = value ? 0x01 : 0x00;
+			priv->need_commit |= SME_WEP_FLAG;
+		}
+		break;
+	case IW_AUTH_RX_UNENCRYPTED_EAPOL:	/* 4 */
+	case IW_AUTH_TKIP_COUNTERMEASURES:	/* 5 */
+	case IW_AUTH_DROP_UNENCRYPTED:	/* 8 */
+	case IW_AUTH_ROAMING_CONTROL:	/* 9 */
+	default:
+		break;
+	}
+
+	/* return -EINPROGRESS; */
+	if (priv->need_commit) {
+		ks_wlan_setup_parameter(priv, priv->need_commit);
+		priv->need_commit = 0;
+	}
+	return 0;
+}
+
+static int ks_wlan_get_auth_mode(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_param *vwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	int index = (vwrq->flags & IW_AUTH_INDEX);
+
+	DPRINTK(2, "index=%d\n", index);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	/*  WPA (not used ?? wpa_supplicant) */
+	switch (index) {
+	case IW_AUTH_WPA_VERSION:
+		vwrq->value = priv->wpa.version;
+		break;
+	case IW_AUTH_CIPHER_PAIRWISE:
+		vwrq->value = priv->wpa.pairwise_suite;
+		break;
+	case IW_AUTH_CIPHER_GROUP:
+		vwrq->value = priv->wpa.group_suite;
+		break;
+	case IW_AUTH_KEY_MGMT:
+		vwrq->value = priv->wpa.key_mgmt_suite;
+		break;
+	case IW_AUTH_80211_AUTH_ALG:
+		vwrq->value = priv->wpa.auth_alg;
+		break;
+	case IW_AUTH_WPA_ENABLED:
+		vwrq->value = priv->wpa.rsn_enabled;
+		break;
+	case IW_AUTH_RX_UNENCRYPTED_EAPOL:	/* OK??? */
+	case IW_AUTH_TKIP_COUNTERMEASURES:
+	case IW_AUTH_DROP_UNENCRYPTED:
+	default:
+		/* return -EOPNOTSUPP; */
+		break;
+	}
+	return 0;
+}
+
+/* set encoding token & mode (WPA)*/
+static int ks_wlan_set_encode_ext(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_point *dwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	struct iw_encode_ext *enc;
+	int index = dwrq->flags & IW_ENCODE_INDEX;
+	unsigned int commit = 0;
+	struct wpa_key_t *key;
+
+	enc = (struct iw_encode_ext *)extra;
+	if (!enc)
+		return -EINVAL;
+
+	DPRINTK(2, "flags=%04X:: ext_flags=%08X\n", dwrq->flags,
+		enc->ext_flags);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	if (index < 1 || index > 4)
+		return -EINVAL;
+	index--;
+	key = &priv->wpa.key[index];
+
+	if (dwrq->flags & IW_ENCODE_DISABLED)
+		key->key_len = 0;
+
+	key->ext_flags = enc->ext_flags;
+	if (enc->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
+		priv->wpa.txkey = index;
+		commit |= SME_WEP_INDEX;
+	} else if (enc->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
+		memcpy(&key->rx_seq[0], &enc->rx_seq[0], IW_ENCODE_SEQ_MAX_SIZE);
+	}
+
+	memcpy(&key->addr.sa_data[0], &enc->addr.sa_data[0], ETH_ALEN);
+
+	switch (enc->alg) {
+	case IW_ENCODE_ALG_NONE:
+		if (priv->reg.privacy_invoked) {
+			priv->reg.privacy_invoked = 0x00;
+			commit |= SME_WEP_FLAG;
+		}
+		key->key_len = 0;
+
+		break;
+	case IW_ENCODE_ALG_WEP:
+	case IW_ENCODE_ALG_CCMP:
+		if (!priv->reg.privacy_invoked) {
+			priv->reg.privacy_invoked = 0x01;
+			commit |= SME_WEP_FLAG;
+		}
+		if (enc->key_len) {
+			memcpy(&key->key_val[0], &enc->key[0], enc->key_len);
+			key->key_len = enc->key_len;
+			commit |= (SME_WEP_VAL1 << index);
+		}
+		break;
+	case IW_ENCODE_ALG_TKIP:
+		if (!priv->reg.privacy_invoked) {
+			priv->reg.privacy_invoked = 0x01;
+			commit |= SME_WEP_FLAG;
+		}
+		if (enc->key_len == 32) {
+			memcpy(&key->key_val[0], &enc->key[0], enc->key_len - 16);
+			key->key_len = enc->key_len - 16;
+			if (priv->wpa.key_mgmt_suite == 4) {	/* WPA_NONE */
+				memcpy(&key->tx_mic_key[0], &enc->key[16], 8);
+				memcpy(&key->rx_mic_key[0], &enc->key[16], 8);
+			} else {
+				memcpy(&key->tx_mic_key[0], &enc->key[16], 8);
+				memcpy(&key->rx_mic_key[0], &enc->key[24], 8);
+			}
+			commit |= (SME_WEP_VAL1 << index);
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+	key->alg = enc->alg;
+
+	if (commit) {
+		if (commit & SME_WEP_INDEX)
+			hostif_sme_enqueue(priv, SME_SET_TXKEY);
+		if (commit & SME_WEP_VAL_MASK)
+			hostif_sme_enqueue(priv, SME_SET_KEY1 + index);
+		if (commit & SME_WEP_FLAG)
+			hostif_sme_enqueue(priv, SME_WEP_FLAG_REQUEST);
+	}
+
+	return 0;
+}
+
+/* get encoding token & mode (WPA)*/
+static int ks_wlan_get_encode_ext(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_point *dwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	/* WPA (not used ?? wpa_supplicant)
+	 * struct ks_wlan_private *priv = (struct ks_wlan_private *)dev->priv;
+	 * struct iw_encode_ext *enc;
+	 * enc = (struct iw_encode_ext *)extra;
+	 * int index = dwrq->flags & IW_ENCODE_INDEX;
+	 * WPA (not used ?? wpa_supplicant)
+	 */
+	return 0;
+}
+
+static int ks_wlan_set_pmksa(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_point *dwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	struct iw_pmksa *pmksa;
+	int i;
+	struct pmk_t *pmk;
+	struct list_head *ptr;
+
+	DPRINTK(2, "\n");
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	if (!extra)
+		return -EINVAL;
+
+	pmksa = (struct iw_pmksa *)extra;
+	DPRINTK(2, "cmd=%d\n", pmksa->cmd);
+
+	switch (pmksa->cmd) {
+	case IW_PMKSA_ADD:
+		if (list_empty(&priv->pmklist.head)) {	/* new list */
+			for (i = 0; i < PMK_LIST_MAX; i++) {
+				pmk = &priv->pmklist.pmk[i];
+				if (memcmp("\x00\x00\x00\x00\x00\x00",
+					   pmk->bssid, ETH_ALEN) == 0)
+					break; /* loop */
+			}
+			memcpy(pmk->bssid, pmksa->bssid.sa_data, ETH_ALEN);
+			memcpy(pmk->pmkid, pmksa->pmkid, IW_PMKID_LEN);
+			list_add(&pmk->list, &priv->pmklist.head);
+			priv->pmklist.size++;
+			break;	/* case */
+		}
+		/* search cache data */
+		list_for_each(ptr, &priv->pmklist.head) {
+			pmk = list_entry(ptr, struct pmk_t, list);
+			if (memcmp(pmksa->bssid.sa_data, pmk->bssid, ETH_ALEN) == 0) {
+				memcpy(pmk->pmkid, pmksa->pmkid, IW_PMKID_LEN);
+				list_move(&pmk->list, &priv->pmklist.head);
+				break; /* list_for_each */
+			}
+		}
+		if (ptr != &priv->pmklist.head)	/* not find address. */
+			break;	/* case */
+
+		if (priv->pmklist.size < PMK_LIST_MAX) {	/* new cache data */
+			for (i = 0; i < PMK_LIST_MAX; i++) {
+				pmk = &priv->pmklist.pmk[i];
+				if (memcmp("\x00\x00\x00\x00\x00\x00",
+					   pmk->bssid, ETH_ALEN) == 0)
+					break; /* loop */
+			}
+			memcpy(pmk->bssid, pmksa->bssid.sa_data, ETH_ALEN);
+			memcpy(pmk->pmkid, pmksa->pmkid, IW_PMKID_LEN);
+			list_add(&pmk->list, &priv->pmklist.head);
+			priv->pmklist.size++;
+		} else {	/* overwrite old cache data */
+			pmk = list_entry(priv->pmklist.head.prev, struct pmk_t,
+					 list);
+			memcpy(pmk->bssid, pmksa->bssid.sa_data, ETH_ALEN);
+			memcpy(pmk->pmkid, pmksa->pmkid, IW_PMKID_LEN);
+			list_move(&pmk->list, &priv->pmklist.head);
+		}
+		break;
+	case IW_PMKSA_REMOVE:
+		if (list_empty(&priv->pmklist.head)) {	/* list empty */
+			return -EINVAL;
+		}
+		/* search cache data */
+		list_for_each(ptr, &priv->pmklist.head) {
+			pmk = list_entry(ptr, struct pmk_t, list);
+			if (memcmp(pmksa->bssid.sa_data, pmk->bssid, ETH_ALEN) == 0) {
+				eth_zero_addr(pmk->bssid);
+				memset(pmk->pmkid, 0, IW_PMKID_LEN);
+				list_del_init(&pmk->list);
+				break;
+			}
+		}
+		if (ptr == &priv->pmklist.head) {	/* not find address. */
+			return 0;
+		}
+
+		break;
+	case IW_PMKSA_FLUSH:
+		memset(&priv->pmklist, 0, sizeof(priv->pmklist));
+		INIT_LIST_HEAD(&priv->pmklist.head);
+		for (i = 0; i < PMK_LIST_MAX; i++)
+			INIT_LIST_HEAD(&priv->pmklist.pmk[i].list);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	hostif_sme_enqueue(priv, SME_SET_PMKSA);
+	return 0;
+}
+
+static struct iw_statistics *ks_get_wireless_stats(struct net_device *dev)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	struct iw_statistics *wstats = &priv->wstats;
+
+	if (!atomic_read(&update_phyinfo)) {
+		if (priv->dev_state < DEVICE_STATE_READY)
+			return NULL;	/* not finished initialize */
+		else
+			return wstats;
+	}
+
+	/* Packets discarded in the wireless adapter due to wireless
+	 * specific problems
+	 */
+	wstats->discard.nwid = 0;	/* Rx invalid nwid      */
+	wstats->discard.code = 0;	/* Rx invalid crypt     */
+	wstats->discard.fragment = 0;	/* Rx invalid frag      */
+	wstats->discard.retries = 0;	/* Tx excessive retries */
+	wstats->discard.misc = 0;	/* Invalid misc         */
+	wstats->miss.beacon = 0;	/* Missed beacon        */
+
+	return wstats;
+}
+
+static int ks_wlan_set_stop_request(struct net_device *dev,
+				    struct iw_request_info *info, __u32 *uwrq,
+				    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	DPRINTK(2, "\n");
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	if (!(*uwrq))
+		return -EINVAL;
+
+	hostif_sme_enqueue(priv, SME_STOP_REQUEST);
+	return 0;
+}
+
+#include <linux/ieee80211.h>
+static int ks_wlan_set_mlme(struct net_device *dev,
+			    struct iw_request_info *info, struct iw_point *dwrq,
+			    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	struct iw_mlme *mlme = (struct iw_mlme *)extra;
+	__u32 mode;
+
+	DPRINTK(2, ":%d :%d\n", mlme->cmd, mlme->reason_code);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	switch (mlme->cmd) {
+	case IW_MLME_DEAUTH:
+		if (mlme->reason_code == WLAN_REASON_MIC_FAILURE)
+			return 0;
+	case IW_MLME_DISASSOC:
+		mode = 1;
+		return ks_wlan_set_stop_request(dev, NULL, &mode, NULL);
+	default:
+		return -EOPNOTSUPP;	/* Not Support */
+	}
+}
+
+static int ks_wlan_get_firmware_version(struct net_device *dev,
+					struct iw_request_info *info,
+					struct iw_point *dwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	strcpy(extra, priv->firmware_version);
+	dwrq->length = priv->version_size + 1;
+	return 0;
+}
+
+static int ks_wlan_set_preamble(struct net_device *dev,
+				struct iw_request_info *info, __u32 *uwrq,
+				char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	if (*uwrq == LONG_PREAMBLE) {	/* 0 */
+		priv->reg.preamble = LONG_PREAMBLE;
+	} else if (*uwrq == SHORT_PREAMBLE) {	/* 1 */
+		priv->reg.preamble = SHORT_PREAMBLE;
+	} else {
+		return -EINVAL;
+	}
+
+	priv->need_commit |= SME_MODE_SET;
+	return -EINPROGRESS;	/* Call commit handler */
+}
+
+static int ks_wlan_get_preamble(struct net_device *dev,
+				struct iw_request_info *info, __u32 *uwrq,
+				char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	*uwrq = priv->reg.preamble;
+	return 0;
+}
+
+static int ks_wlan_set_power_mgmt(struct net_device *dev,
+				  struct iw_request_info *info, __u32 *uwrq,
+				  char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	if (*uwrq == POWER_MGMT_ACTIVE) {	/* 0 */
+		priv->reg.power_mgmt = POWER_MGMT_ACTIVE;
+	} else if (*uwrq == POWER_MGMT_SAVE1) {	/* 1 */
+		if (priv->reg.operation_mode == MODE_INFRASTRUCTURE)
+			priv->reg.power_mgmt = POWER_MGMT_SAVE1;
+		else
+			return -EINVAL;
+	} else if (*uwrq == POWER_MGMT_SAVE2) {	/* 2 */
+		if (priv->reg.operation_mode == MODE_INFRASTRUCTURE)
+			priv->reg.power_mgmt = POWER_MGMT_SAVE2;
+		else
+			return -EINVAL;
+	} else {
+		return -EINVAL;
+	}
+
+	hostif_sme_enqueue(priv, SME_POW_MNGMT_REQUEST);
+
+	return 0;
+}
+
+static int ks_wlan_get_power_mgmt(struct net_device *dev,
+				  struct iw_request_info *info, __u32 *uwrq,
+				  char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+
+	/* for SLEEP MODE */
+	*uwrq = priv->reg.power_mgmt;
+	return 0;
+}
+
+static int ks_wlan_set_scan_type(struct net_device *dev,
+				 struct iw_request_info *info, __u32 *uwrq,
+				 char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	if (*uwrq == ACTIVE_SCAN) {	/* 0 */
+		priv->reg.scan_type = ACTIVE_SCAN;
+	} else if (*uwrq == PASSIVE_SCAN) {	/* 1 */
+		priv->reg.scan_type = PASSIVE_SCAN;
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ks_wlan_get_scan_type(struct net_device *dev,
+				 struct iw_request_info *info, __u32 *uwrq,
+				 char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	*uwrq = priv->reg.scan_type;
+	return 0;
+}
+
+static int ks_wlan_set_beacon_lost(struct net_device *dev,
+				   struct iw_request_info *info, __u32 *uwrq,
+				   char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	if (*uwrq >= BEACON_LOST_COUNT_MIN && *uwrq <= BEACON_LOST_COUNT_MAX)
+		priv->reg.beacon_lost_count = *uwrq;
+	else
+		return -EINVAL;
+
+	if (priv->reg.operation_mode == MODE_INFRASTRUCTURE) {
+		priv->need_commit |= SME_MODE_SET;
+		return -EINPROGRESS;	/* Call commit handler */
+	} else {
+		return 0;
+	}
+}
+
+static int ks_wlan_get_beacon_lost(struct net_device *dev,
+				   struct iw_request_info *info, __u32 *uwrq,
+				   char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	*uwrq = priv->reg.beacon_lost_count;
+	return 0;
+}
+
+static int ks_wlan_set_phy_type(struct net_device *dev,
+				struct iw_request_info *info, __u32 *uwrq,
+				char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	if (*uwrq == D_11B_ONLY_MODE) {	/* 0 */
+		priv->reg.phy_type = D_11B_ONLY_MODE;
+	} else if (*uwrq == D_11G_ONLY_MODE) {	/* 1 */
+		priv->reg.phy_type = D_11G_ONLY_MODE;
+	} else if (*uwrq == D_11BG_COMPATIBLE_MODE) {	/* 2 */
+		priv->reg.phy_type = D_11BG_COMPATIBLE_MODE;
+	} else {
+		return -EINVAL;
+	}
+
+	priv->need_commit |= SME_MODE_SET;
+	return -EINPROGRESS;	/* Call commit handler */
+}
+
+static int ks_wlan_get_phy_type(struct net_device *dev,
+				struct iw_request_info *info, __u32 *uwrq,
+				char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	*uwrq = priv->reg.phy_type;
+	return 0;
+}
+
+static int ks_wlan_set_cts_mode(struct net_device *dev,
+				struct iw_request_info *info, __u32 *uwrq,
+				char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	if (*uwrq == CTS_MODE_FALSE) {	/* 0 */
+		priv->reg.cts_mode = CTS_MODE_FALSE;
+	} else if (*uwrq == CTS_MODE_TRUE) {	/* 1 */
+		if (priv->reg.phy_type == D_11G_ONLY_MODE ||
+		    priv->reg.phy_type == D_11BG_COMPATIBLE_MODE) {
+			priv->reg.cts_mode = CTS_MODE_TRUE;
+		} else {
+			priv->reg.cts_mode = CTS_MODE_FALSE;
+		}
+	} else {
+		return -EINVAL;
+	}
+
+	priv->need_commit |= SME_MODE_SET;
+	return -EINPROGRESS;	/* Call commit handler */
+}
+
+static int ks_wlan_get_cts_mode(struct net_device *dev,
+				struct iw_request_info *info, __u32 *uwrq,
+				char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	*uwrq = priv->reg.cts_mode;
+	return 0;
+}
+
+static int ks_wlan_set_sleep_mode(struct net_device *dev,
+				  struct iw_request_info *info,
+				  __u32 *uwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	DPRINTK(2, "\n");
+
+	if (*uwrq == SLP_SLEEP) {
+		priv->sleep_mode = *uwrq;
+		netdev_info(dev, "SET_SLEEP_MODE %d\n", priv->sleep_mode);
+
+		hostif_sme_enqueue(priv, SME_STOP_REQUEST);
+		hostif_sme_enqueue(priv, SME_SLEEP_REQUEST);
+
+	} else if (*uwrq == SLP_ACTIVE) {
+		priv->sleep_mode = *uwrq;
+		netdev_info(dev, "SET_SLEEP_MODE %d\n", priv->sleep_mode);
+		hostif_sme_enqueue(priv, SME_SLEEP_REQUEST);
+	} else {
+		netdev_err(dev, "SET_SLEEP_MODE %d errror\n", *uwrq);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ks_wlan_get_sleep_mode(struct net_device *dev,
+				  struct iw_request_info *info,
+				  __u32 *uwrq, char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	DPRINTK(2, "GET_SLEEP_MODE %d\n", priv->sleep_mode);
+	*uwrq = priv->sleep_mode;
+
+	return 0;
+}
+
+#ifdef WPS
+
+static int ks_wlan_set_wps_enable(struct net_device *dev,
+				  struct iw_request_info *info, __u32 *uwrq,
+				  char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	DPRINTK(2, "\n");
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	if (*uwrq == 0 || *uwrq == 1)
+		priv->wps.wps_enabled = *uwrq;
+	else
+		return -EINVAL;
+
+	hostif_sme_enqueue(priv, SME_WPS_ENABLE_REQUEST);
+
+	return 0;
+}
+
+static int ks_wlan_get_wps_enable(struct net_device *dev,
+				  struct iw_request_info *info, __u32 *uwrq,
+				  char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	DPRINTK(2, "\n");
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	*uwrq = priv->wps.wps_enabled;
+	netdev_info(dev, "return=%d\n", *uwrq);
+
+	return 0;
+}
+
+static int ks_wlan_set_wps_probe_req(struct net_device *dev,
+				     struct iw_request_info *info,
+				     struct iw_point *dwrq, char *extra)
+{
+	u8 *p = extra;
+	unsigned char len;
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	DPRINTK(2, "\n");
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	DPRINTK(2, "dwrq->length=%d\n", dwrq->length);
+
+	/* length check */
+	if (p[1] + 2 != dwrq->length || dwrq->length > 256)
+		return -EINVAL;
+
+	priv->wps.ielen = p[1] + 2 + 1;	/* IE header + IE + sizeof(len) */
+	len = p[1] + 2;	/* IE header + IE */
+
+	memcpy(priv->wps.ie, &len, sizeof(len));
+	p = memcpy(priv->wps.ie + 1, p, len);
+
+	DPRINTK(2, "%d(%#x): %02X %02X %02X %02X ... %02X %02X %02X\n",
+		priv->wps.ielen, priv->wps.ielen, p[0], p[1], p[2], p[3],
+		p[priv->wps.ielen - 3], p[priv->wps.ielen - 2],
+		p[priv->wps.ielen - 1]);
+
+	hostif_sme_enqueue(priv, SME_WPS_PROBE_REQUEST);
+
+	return 0;
+}
+#endif /* WPS */
+
+static int ks_wlan_set_tx_gain(struct net_device *dev,
+			       struct iw_request_info *info, __u32 *uwrq,
+			       char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	if (*uwrq >= 0 && *uwrq <= 0xFF)	/* 0-255 */
+		priv->gain.TxGain = (uint8_t)*uwrq;
+	else
+		return -EINVAL;
+
+	if (priv->gain.TxGain < 0xFF)
+		priv->gain.TxMode = 1;
+	else
+		priv->gain.TxMode = 0;
+
+	hostif_sme_enqueue(priv, SME_SET_GAIN);
+	return 0;
+}
+
+static int ks_wlan_get_tx_gain(struct net_device *dev,
+			       struct iw_request_info *info, __u32 *uwrq,
+			       char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	*uwrq = priv->gain.TxGain;
+	hostif_sme_enqueue(priv, SME_GET_GAIN);
+	return 0;
+}
+
+static int ks_wlan_set_rx_gain(struct net_device *dev,
+			       struct iw_request_info *info, __u32 *uwrq,
+			       char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	if (*uwrq >= 0 && *uwrq <= 0xFF)	/* 0-255 */
+		priv->gain.RxGain = (uint8_t)*uwrq;
+	else
+		return -EINVAL;
+
+	if (priv->gain.RxGain < 0xFF)
+		priv->gain.RxMode = 1;
+	else
+		priv->gain.RxMode = 0;
+
+	hostif_sme_enqueue(priv, SME_SET_GAIN);
+	return 0;
+}
+
+static int ks_wlan_get_rx_gain(struct net_device *dev,
+			       struct iw_request_info *info, __u32 *uwrq,
+			       char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->sleep_mode == SLP_SLEEP)
+		return -EPERM;
+	/* for SLEEP MODE */
+	*uwrq = priv->gain.RxGain;
+	hostif_sme_enqueue(priv, SME_GET_GAIN);
+	return 0;
+}
+
+static int ks_wlan_get_eeprom_cksum(struct net_device *dev,
+				    struct iw_request_info *info, __u32 *uwrq,
+				    char *extra)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	*uwrq = priv->eeprom_checksum;
+	return 0;
+}
+
+static void print_hif_event(struct net_device *dev, int event)
+{
+	switch (event) {
+	case HIF_DATA_REQ:
+		netdev_info(dev, "HIF_DATA_REQ\n");
+		break;
+	case HIF_DATA_IND:
+		netdev_info(dev, "HIF_DATA_IND\n");
+		break;
+	case HIF_MIB_GET_REQ:
+		netdev_info(dev, "HIF_MIB_GET_REQ\n");
+		break;
+	case HIF_MIB_GET_CONF:
+		netdev_info(dev, "HIF_MIB_GET_CONF\n");
+		break;
+	case HIF_MIB_SET_REQ:
+		netdev_info(dev, "HIF_MIB_SET_REQ\n");
+		break;
+	case HIF_MIB_SET_CONF:
+		netdev_info(dev, "HIF_MIB_SET_CONF\n");
+		break;
+	case HIF_POWER_MGMT_REQ:
+		netdev_info(dev, "HIF_POWER_MGMT_REQ\n");
+		break;
+	case HIF_POWER_MGMT_CONF:
+		netdev_info(dev, "HIF_POWER_MGMT_CONF\n");
+		break;
+	case HIF_START_REQ:
+		netdev_info(dev, "HIF_START_REQ\n");
+		break;
+	case HIF_START_CONF:
+		netdev_info(dev, "HIF_START_CONF\n");
+		break;
+	case HIF_CONNECT_IND:
+		netdev_info(dev, "HIF_CONNECT_IND\n");
+		break;
+	case HIF_STOP_REQ:
+		netdev_info(dev, "HIF_STOP_REQ\n");
+		break;
+	case HIF_STOP_CONF:
+		netdev_info(dev, "HIF_STOP_CONF\n");
+		break;
+	case HIF_PS_ADH_SET_REQ:
+		netdev_info(dev, "HIF_PS_ADH_SET_REQ\n");
+		break;
+	case HIF_PS_ADH_SET_CONF:
+		netdev_info(dev, "HIF_PS_ADH_SET_CONF\n");
+		break;
+	case HIF_INFRA_SET_REQ:
+		netdev_info(dev, "HIF_INFRA_SET_REQ\n");
+		break;
+	case HIF_INFRA_SET_CONF:
+		netdev_info(dev, "HIF_INFRA_SET_CONF\n");
+		break;
+	case HIF_ADH_SET_REQ:
+		netdev_info(dev, "HIF_ADH_SET_REQ\n");
+		break;
+	case HIF_ADH_SET_CONF:
+		netdev_info(dev, "HIF_ADH_SET_CONF\n");
+		break;
+	case HIF_AP_SET_REQ:
+		netdev_info(dev, "HIF_AP_SET_REQ\n");
+		break;
+	case HIF_AP_SET_CONF:
+		netdev_info(dev, "HIF_AP_SET_CONF\n");
+		break;
+	case HIF_ASSOC_INFO_IND:
+		netdev_info(dev, "HIF_ASSOC_INFO_IND\n");
+		break;
+	case HIF_MIC_FAILURE_REQ:
+		netdev_info(dev, "HIF_MIC_FAILURE_REQ\n");
+		break;
+	case HIF_MIC_FAILURE_CONF:
+		netdev_info(dev, "HIF_MIC_FAILURE_CONF\n");
+		break;
+	case HIF_SCAN_REQ:
+		netdev_info(dev, "HIF_SCAN_REQ\n");
+		break;
+	case HIF_SCAN_CONF:
+		netdev_info(dev, "HIF_SCAN_CONF\n");
+		break;
+	case HIF_PHY_INFO_REQ:
+		netdev_info(dev, "HIF_PHY_INFO_REQ\n");
+		break;
+	case HIF_PHY_INFO_CONF:
+		netdev_info(dev, "HIF_PHY_INFO_CONF\n");
+		break;
+	case HIF_SLEEP_REQ:
+		netdev_info(dev, "HIF_SLEEP_REQ\n");
+		break;
+	case HIF_SLEEP_CONF:
+		netdev_info(dev, "HIF_SLEEP_CONF\n");
+		break;
+	case HIF_PHY_INFO_IND:
+		netdev_info(dev, "HIF_PHY_INFO_IND\n");
+		break;
+	case HIF_SCAN_IND:
+		netdev_info(dev, "HIF_SCAN_IND\n");
+		break;
+	case HIF_INFRA_SET2_REQ:
+		netdev_info(dev, "HIF_INFRA_SET2_REQ\n");
+		break;
+	case HIF_INFRA_SET2_CONF:
+		netdev_info(dev, "HIF_INFRA_SET2_CONF\n");
+		break;
+	case HIF_ADH_SET2_REQ:
+		netdev_info(dev, "HIF_ADH_SET2_REQ\n");
+		break;
+	case HIF_ADH_SET2_CONF:
+		netdev_info(dev, "HIF_ADH_SET2_CONF\n");
+	}
+}
+
+/* get host command history */
+static int ks_wlan_hostt(struct net_device *dev, struct iw_request_info *info,
+			 __u32 *uwrq, char *extra)
+{
+	int i, event;
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	for (i = 63; i >= 0; i--) {
+		event =
+		    priv->hostt.buff[(priv->hostt.qtail - 1 - i) %
+				     SME_EVENT_BUFF_SIZE];
+		print_hif_event(dev, event);
+	}
+	return 0;
+}
+
+/* Structures to export the Wireless Handlers */
+
+static const struct iw_priv_args ks_wlan_private_args[] = {
+/*{ cmd, set_args, get_args, name[16] } */
+	{KS_WLAN_GET_FIRM_VERSION, IW_PRIV_TYPE_NONE,
+	 IW_PRIV_TYPE_CHAR | (128 + 1), "GetFirmwareVer"},
+#ifdef WPS
+	{KS_WLAN_SET_WPS_ENABLE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
+	 IW_PRIV_TYPE_NONE, "SetWPSEnable"},
+	{KS_WLAN_GET_WPS_ENABLE, IW_PRIV_TYPE_NONE,
+	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetW"},
+	{KS_WLAN_SET_WPS_PROBE_REQ, IW_PRIV_TYPE_BYTE | 2047, IW_PRIV_TYPE_NONE,
+	 "SetWPSProbeReq"},
+#endif /* WPS */
+	{KS_WLAN_SET_PREAMBLE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
+	 IW_PRIV_TYPE_NONE, "SetPreamble"},
+	{KS_WLAN_GET_PREAMBLE, IW_PRIV_TYPE_NONE,
+	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetPreamble"},
+	{KS_WLAN_SET_POWER_SAVE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
+	 IW_PRIV_TYPE_NONE, "SetPowerSave"},
+	{KS_WLAN_GET_POWER_SAVE, IW_PRIV_TYPE_NONE,
+	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetPowerSave"},
+	{KS_WLAN_SET_SCAN_TYPE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
+	 IW_PRIV_TYPE_NONE, "SetScanType"},
+	{KS_WLAN_GET_SCAN_TYPE, IW_PRIV_TYPE_NONE,
+	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetScanType"},
+	{KS_WLAN_SET_RX_GAIN, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
+	 IW_PRIV_TYPE_NONE, "SetRxGain"},
+	{KS_WLAN_GET_RX_GAIN, IW_PRIV_TYPE_NONE,
+	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetRxGain"},
+	{KS_WLAN_HOSTT, IW_PRIV_TYPE_NONE, IW_PRIV_TYPE_CHAR | (128 + 1),
+	 "hostt"},
+	{KS_WLAN_SET_BEACON_LOST, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
+	 IW_PRIV_TYPE_NONE, "SetBeaconLost"},
+	{KS_WLAN_GET_BEACON_LOST, IW_PRIV_TYPE_NONE,
+	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetBeaconLost"},
+	{KS_WLAN_SET_SLEEP_MODE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
+	 IW_PRIV_TYPE_NONE, "SetSleepMode"},
+	{KS_WLAN_GET_SLEEP_MODE, IW_PRIV_TYPE_NONE,
+	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetSleepMode"},
+	{KS_WLAN_SET_TX_GAIN, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
+	 IW_PRIV_TYPE_NONE, "SetTxGain"},
+	{KS_WLAN_GET_TX_GAIN, IW_PRIV_TYPE_NONE,
+	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetTxGain"},
+	{KS_WLAN_SET_PHY_TYPE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
+	 IW_PRIV_TYPE_NONE, "SetPhyType"},
+	{KS_WLAN_GET_PHY_TYPE, IW_PRIV_TYPE_NONE,
+	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetPhyType"},
+	{KS_WLAN_SET_CTS_MODE, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
+	 IW_PRIV_TYPE_NONE, "SetCtsMode"},
+	{KS_WLAN_GET_CTS_MODE, IW_PRIV_TYPE_NONE,
+	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetCtsMode"},
+	{KS_WLAN_GET_EEPROM_CKSUM, IW_PRIV_TYPE_NONE,
+	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "GetChecksum"},
+};
+
+static const iw_handler ks_wlan_handler[] = {
+	(iw_handler)ks_wlan_config_commit,	/* SIOCSIWCOMMIT */
+	(iw_handler)ks_wlan_get_name,	/* SIOCGIWNAME */
+	(iw_handler)NULL,	/* SIOCSIWNWID */
+	(iw_handler)NULL,	/* SIOCGIWNWID */
+	(iw_handler)ks_wlan_set_freq,	/* SIOCSIWFREQ */
+	(iw_handler)ks_wlan_get_freq,	/* SIOCGIWFREQ */
+	(iw_handler)ks_wlan_set_mode,	/* SIOCSIWMODE */
+	(iw_handler)ks_wlan_get_mode,	/* SIOCGIWMODE */
+#ifndef KSC_OPNOTSUPP
+	(iw_handler)ks_wlan_set_sens,	/* SIOCSIWSENS */
+	(iw_handler)ks_wlan_get_sens,	/* SIOCGIWSENS */
+#else /* KSC_OPNOTSUPP */
+	(iw_handler)NULL,	/* SIOCSIWSENS */
+	(iw_handler)NULL,	/* SIOCGIWSENS */
+#endif /* KSC_OPNOTSUPP */
+	(iw_handler)NULL,	/* SIOCSIWRANGE */
+	(iw_handler)ks_wlan_get_range,	/* SIOCGIWRANGE */
+	(iw_handler)NULL,	/* SIOCSIWPRIV */
+	(iw_handler)NULL,	/* SIOCGIWPRIV */
+	(iw_handler)NULL,	/* SIOCSIWSTATS */
+	(iw_handler)ks_wlan_get_iwstats,	/* SIOCGIWSTATS */
+	(iw_handler)NULL,	/* SIOCSIWSPY */
+	(iw_handler)NULL,	/* SIOCGIWSPY */
+	(iw_handler)NULL,	/* SIOCSIWTHRSPY */
+	(iw_handler)NULL,	/* SIOCGIWTHRSPY */
+	(iw_handler)ks_wlan_set_wap,	/* SIOCSIWAP */
+	(iw_handler)ks_wlan_get_wap,	/* SIOCGIWAP */
+//      (iw_handler)NULL,                      /* SIOCSIWMLME */
+	(iw_handler)ks_wlan_set_mlme,	/* SIOCSIWMLME */
+	(iw_handler)ks_wlan_get_aplist,	/* SIOCGIWAPLIST */
+	(iw_handler)ks_wlan_set_scan,	/* SIOCSIWSCAN */
+	(iw_handler)ks_wlan_get_scan,	/* SIOCGIWSCAN */
+	(iw_handler)ks_wlan_set_essid,	/* SIOCSIWESSID */
+	(iw_handler)ks_wlan_get_essid,	/* SIOCGIWESSID */
+	(iw_handler)ks_wlan_set_nick,	/* SIOCSIWNICKN */
+	(iw_handler)ks_wlan_get_nick,	/* SIOCGIWNICKN */
+	(iw_handler)NULL,	/* -- hole -- */
+	(iw_handler)NULL,	/* -- hole -- */
+	(iw_handler)ks_wlan_set_rate,	/* SIOCSIWRATE */
+	(iw_handler)ks_wlan_get_rate,	/* SIOCGIWRATE */
+	(iw_handler)ks_wlan_set_rts,	/* SIOCSIWRTS */
+	(iw_handler)ks_wlan_get_rts,	/* SIOCGIWRTS */
+	(iw_handler)ks_wlan_set_frag,	/* SIOCSIWFRAG */
+	(iw_handler)ks_wlan_get_frag,	/* SIOCGIWFRAG */
+#ifndef KSC_OPNOTSUPP
+	(iw_handler)ks_wlan_set_txpow,	/* SIOCSIWTXPOW */
+	(iw_handler)ks_wlan_get_txpow,	/* SIOCGIWTXPOW */
+	(iw_handler)ks_wlan_set_retry,	/* SIOCSIWRETRY */
+	(iw_handler)ks_wlan_get_retry,	/* SIOCGIWRETRY */
+#else /* KSC_OPNOTSUPP */
+	(iw_handler)NULL,	/* SIOCSIWTXPOW */
+	(iw_handler)NULL,	/* SIOCGIWTXPOW */
+	(iw_handler)NULL,	/* SIOCSIWRETRY */
+	(iw_handler)NULL,	/* SIOCGIWRETRY */
+#endif /* KSC_OPNOTSUPP */
+	(iw_handler)ks_wlan_set_encode,	/* SIOCSIWENCODE */
+	(iw_handler)ks_wlan_get_encode,	/* SIOCGIWENCODE */
+	(iw_handler)ks_wlan_set_power,	/* SIOCSIWPOWER */
+	(iw_handler)ks_wlan_get_power,	/* SIOCGIWPOWER */
+	(iw_handler)NULL,	/* -- hole -- */
+	(iw_handler)NULL,	/* -- hole -- */
+//      (iw_handler)NULL,                      /* SIOCSIWGENIE */
+	(iw_handler)ks_wlan_set_genie,	/* SIOCSIWGENIE */
+	(iw_handler)NULL,	/* SIOCGIWGENIE */
+	(iw_handler)ks_wlan_set_auth_mode,	/* SIOCSIWAUTH */
+	(iw_handler)ks_wlan_get_auth_mode,	/* SIOCGIWAUTH */
+	(iw_handler)ks_wlan_set_encode_ext,	/* SIOCSIWENCODEEXT */
+	(iw_handler)ks_wlan_get_encode_ext,	/* SIOCGIWENCODEEXT */
+	(iw_handler)ks_wlan_set_pmksa,	/* SIOCSIWPMKSA */
+	(iw_handler)NULL,	/* -- hole -- */
+};
+
+/* private_handler */
+static const iw_handler ks_wlan_private_handler[] = {
+	(iw_handler)NULL,	/*  0 */
+	(iw_handler)NULL,	/*  1, used to be: KS_WLAN_GET_DRIVER_VERSION */
+	(iw_handler)NULL,	/*  2 */
+	(iw_handler)ks_wlan_get_firmware_version,	/*  3 KS_WLAN_GET_FIRM_VERSION */
+#ifdef WPS
+	(iw_handler)ks_wlan_set_wps_enable,	/*  4 KS_WLAN_SET_WPS_ENABLE  */
+	(iw_handler)ks_wlan_get_wps_enable,	/*  5 KS_WLAN_GET_WPS_ENABLE  */
+	(iw_handler)ks_wlan_set_wps_probe_req,	/*  6 KS_WLAN_SET_WPS_PROBE_REQ */
+#else
+	(iw_handler)NULL,	/*  4 */
+	(iw_handler)NULL,	/*  5 */
+	(iw_handler)NULL,	/*  6 */
+#endif /* WPS */
+
+	(iw_handler)ks_wlan_get_eeprom_cksum,	/*  7 KS_WLAN_GET_CONNECT */
+	(iw_handler)ks_wlan_set_preamble,	/*  8 KS_WLAN_SET_PREAMBLE */
+	(iw_handler)ks_wlan_get_preamble,	/*  9 KS_WLAN_GET_PREAMBLE */
+	(iw_handler)ks_wlan_set_power_mgmt,	/* 10 KS_WLAN_SET_POWER_SAVE */
+	(iw_handler)ks_wlan_get_power_mgmt,	/* 11 KS_WLAN_GET_POWER_SAVE */
+	(iw_handler)ks_wlan_set_scan_type,	/* 12 KS_WLAN_SET_SCAN_TYPE */
+	(iw_handler)ks_wlan_get_scan_type,	/* 13 KS_WLAN_GET_SCAN_TYPE */
+	(iw_handler)ks_wlan_set_rx_gain,	/* 14 KS_WLAN_SET_RX_GAIN */
+	(iw_handler)ks_wlan_get_rx_gain,	/* 15 KS_WLAN_GET_RX_GAIN */
+	(iw_handler)ks_wlan_hostt,	/* 16 KS_WLAN_HOSTT */
+	(iw_handler)NULL,	/* 17 */
+	(iw_handler)ks_wlan_set_beacon_lost,	/* 18 KS_WLAN_SET_BECAN_LOST */
+	(iw_handler)ks_wlan_get_beacon_lost,	/* 19 KS_WLAN_GET_BECAN_LOST */
+	(iw_handler)ks_wlan_set_tx_gain,	/* 20 KS_WLAN_SET_TX_GAIN */
+	(iw_handler)ks_wlan_get_tx_gain,	/* 21 KS_WLAN_GET_TX_GAIN */
+	(iw_handler)ks_wlan_set_phy_type,	/* 22 KS_WLAN_SET_PHY_TYPE */
+	(iw_handler)ks_wlan_get_phy_type,	/* 23 KS_WLAN_GET_PHY_TYPE */
+	(iw_handler)ks_wlan_set_cts_mode,	/* 24 KS_WLAN_SET_CTS_MODE */
+	(iw_handler)ks_wlan_get_cts_mode,	/* 25 KS_WLAN_GET_CTS_MODE */
+	(iw_handler)NULL,	/* 26 */
+	(iw_handler)NULL,	/* 27 */
+	(iw_handler)ks_wlan_set_sleep_mode,	/* 28 KS_WLAN_SET_SLEEP_MODE */
+	(iw_handler)ks_wlan_get_sleep_mode,	/* 29 KS_WLAN_GET_SLEEP_MODE */
+	(iw_handler)NULL,	/* 30 */
+	(iw_handler)NULL,	/* 31 */
+};
+
+static const struct iw_handler_def ks_wlan_handler_def = {
+	.num_standard = sizeof(ks_wlan_handler) / sizeof(iw_handler),
+	.num_private = sizeof(ks_wlan_private_handler) / sizeof(iw_handler),
+	.num_private_args =
+	    sizeof(ks_wlan_private_args) / sizeof(struct iw_priv_args),
+	.standard = (iw_handler *)ks_wlan_handler,
+	.private = (iw_handler *)ks_wlan_private_handler,
+	.private_args = (struct iw_priv_args *)ks_wlan_private_args,
+	.get_wireless_stats = ks_get_wireless_stats,
+};
+
+static int ks_wlan_netdev_ioctl(struct net_device *dev, struct ifreq *rq,
+				int cmd)
+{
+	int ret;
+	struct iwreq *wrq = (struct iwreq *)rq;
+
+	switch (cmd) {
+	case SIOCIWFIRSTPRIV + 20:	/* KS_WLAN_SET_STOP_REQ */
+		ret = ks_wlan_set_stop_request(dev, NULL, &wrq->u.mode, NULL);
+		break;
+		// All other calls are currently unsupported
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	DPRINTK(5, "return=%d\n", ret);
+	return ret;
+}
+
+static
+struct net_device_stats *ks_wlan_get_stats(struct net_device *dev)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	if (priv->dev_state < DEVICE_STATE_READY)
+		return NULL;	/* not finished initialize */
+
+	return &priv->nstats;
+}
+
+static
+int ks_wlan_set_mac_address(struct net_device *dev, void *addr)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	struct sockaddr *mac_addr = (struct sockaddr *)addr;
+
+	if (netif_running(dev))
+		return -EBUSY;
+	memcpy(dev->dev_addr, mac_addr->sa_data, dev->addr_len);
+	memcpy(priv->eth_addr, mac_addr->sa_data, ETH_ALEN);
+
+	priv->mac_address_valid = 0;
+	hostif_sme_enqueue(priv, SME_MACADDRESS_SET_REQUEST);
+	netdev_info(dev, "ks_wlan:  MAC ADDRESS = %pM\n", priv->eth_addr);
+	return 0;
+}
+
+static
+void ks_wlan_tx_timeout(struct net_device *dev)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	DPRINTK(1, "head(%d) tail(%d)!!\n", priv->tx_dev.qhead,
+		priv->tx_dev.qtail);
+	if (!netif_queue_stopped(dev))
+		netif_stop_queue(dev);
+	priv->nstats.tx_errors++;
+	netif_wake_queue(dev);
+}
+
+static
+int ks_wlan_start_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+	int ret;
+
+	DPRINTK(3, "in_interrupt()=%ld\n", in_interrupt());
+
+	if (!skb) {
+		netdev_err(dev, "ks_wlan:  skb == NULL!!!\n");
+		return 0;
+	}
+	if (priv->dev_state < DEVICE_STATE_READY) {
+		dev_kfree_skb(skb);
+		return 0;	/* not finished initialize */
+	}
+
+	if (netif_running(dev))
+		netif_stop_queue(dev);
+
+	ret = hostif_data_request(priv, skb);
+	netif_trans_update(dev);
+
+	if (ret)
+		DPRINTK(4, "hostif_data_request error: =%d\n", ret);
+
+	return 0;
+}
+
+void send_packet_complete(struct ks_wlan_private *priv, struct sk_buff *skb)
+{
+	DPRINTK(3, "\n");
+
+	priv->nstats.tx_packets++;
+
+	if (netif_queue_stopped(priv->net_dev))
+		netif_wake_queue(priv->net_dev);
+
+	if (skb) {
+		priv->nstats.tx_bytes += skb->len;
+		dev_kfree_skb(skb);
+	}
+}
+
+/*
+ * Set or clear the multicast filter for this adaptor.
+ * This routine is not state sensitive and need not be SMP locked.
+ */
+static
+void ks_wlan_set_multicast_list(struct net_device *dev)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	DPRINTK(4, "\n");
+	if (priv->dev_state < DEVICE_STATE_READY)
+		return;	/* not finished initialize */
+	hostif_sme_enqueue(priv, SME_MULTICAST_REQUEST);
+}
+
+static
+int ks_wlan_open(struct net_device *dev)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	priv->cur_rx = 0;
+
+	if (!priv->mac_address_valid) {
+		netdev_err(dev, "ks_wlan : %s Not READY !!\n", dev->name);
+		return -EBUSY;
+	}
+	netif_start_queue(dev);
+
+	return 0;
+}
+
+static
+int ks_wlan_close(struct net_device *dev)
+{
+	netif_stop_queue(dev);
+
+	DPRINTK(4, "%s: Shutting down ethercard, status was 0x%4.4x.\n",
+		dev->name, 0x00);
+
+	return 0;
+}
+
+/* Operational parameters that usually are not changed. */
+/* Time in jiffies before concluding the transmitter is hung. */
+#define TX_TIMEOUT  (3 * HZ)
+static const unsigned char dummy_addr[] = {
+	0x00, 0x0b, 0xe3, 0x00, 0x00, 0x00
+};
+
+static const struct net_device_ops ks_wlan_netdev_ops = {
+	.ndo_start_xmit = ks_wlan_start_xmit,
+	.ndo_open = ks_wlan_open,
+	.ndo_stop = ks_wlan_close,
+	.ndo_do_ioctl = ks_wlan_netdev_ioctl,
+	.ndo_set_mac_address = ks_wlan_set_mac_address,
+	.ndo_get_stats = ks_wlan_get_stats,
+	.ndo_tx_timeout = ks_wlan_tx_timeout,
+	.ndo_set_rx_mode = ks_wlan_set_multicast_list,
+};
+
+int ks_wlan_net_start(struct net_device *dev)
+{
+	struct ks_wlan_private *priv;
+	/* int rc; */
+
+	priv = netdev_priv(dev);
+	priv->mac_address_valid = 0;
+	priv->need_commit = 0;
+
+	priv->device_open_status = 1;
+
+	/* phy information update timer */
+	atomic_set(&update_phyinfo, 0);
+	setup_timer(&update_phyinfo_timer, ks_wlan_update_phyinfo_timeout,
+		    (unsigned long)priv);
+
+	/* dummy address set */
+	memcpy(priv->eth_addr, dummy_addr, ETH_ALEN);
+	dev->dev_addr[0] = priv->eth_addr[0];
+	dev->dev_addr[1] = priv->eth_addr[1];
+	dev->dev_addr[2] = priv->eth_addr[2];
+	dev->dev_addr[3] = priv->eth_addr[3];
+	dev->dev_addr[4] = priv->eth_addr[4];
+	dev->dev_addr[5] = priv->eth_addr[5];
+	dev->dev_addr[6] = 0x00;
+	dev->dev_addr[7] = 0x00;
+
+	/* The ks_wlan-specific entries in the device structure. */
+	dev->netdev_ops = &ks_wlan_netdev_ops;
+	dev->wireless_handlers = (struct iw_handler_def *)&ks_wlan_handler_def;
+	dev->watchdog_timeo = TX_TIMEOUT;
+
+	netif_carrier_off(dev);
+
+	return 0;
+}
+
+int ks_wlan_net_stop(struct net_device *dev)
+{
+	struct ks_wlan_private *priv = netdev_priv(dev);
+
+	priv->device_open_status = 0;
+	del_timer_sync(&update_phyinfo_timer);
+
+	if (netif_running(dev))
+		netif_stop_queue(dev);
+
+	return 0;
+}
+
+/**
+ * is_connect_status() - return true if status is 'connected'
+ * @status: high bit is used as FORCE_DISCONNECT, low bits used for
+ * 	connect status.
+ */
+bool is_connect_status(u32 status)
+{
+	return (status & CONNECT_STATUS_MASK) == CONNECT_STATUS;
+}
+
+/**
+ * is_disconnect_status() - return true if status is 'disconnected'
+ * @status: high bit is used as FORCE_DISCONNECT, low bits used for
+ * 	disconnect status.
+ */
+bool is_disconnect_status(u32 status)
+{
+	return (status & CONNECT_STATUS_MASK) == DISCONNECT_STATUS;
+}
diff --git a/drivers/staging/ks7010/wext/michael_mic.c b/drivers/staging/ks7010/wext/michael_mic.c
new file mode 100644
index 0000000..80497ef
--- /dev/null
+++ b/drivers/staging/ks7010/wext/michael_mic.c
@@ -0,0 +1,148 @@
+/*
+ *   Driver for KeyStream wireless LAN
+ *
+ *   Copyright (C) 2005-2008 KeyStream Corp.
+ *   Copyright (C) 2009 Renesas Technology Corp.
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License version 2 as
+ *   published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include "michael_mic.h"
+
+// Rotation functions on 32 bit values
+#define ROL32(A, n)	(((A) << (n)) | (((A) >> (32 - (n))) & ((1UL << (n)) - 1)))
+#define ROR32(A, n)	ROL32((A), 32 - (n))
+// Convert from Byte[] to UInt32 in a portable way
+#define getUInt32(A, B)	((uint32_t)(A[B + 0] << 0) \
+		+ (A[B + 1] << 8) + (A[B + 2] << 16) + (A[B + 3] << 24))
+
+// Convert from UInt32 to Byte[] in a portable way
+#define putUInt32(A, B, C)					\
+do {								\
+	A[B + 0] = (uint8_t)(C & 0xff);				\
+	A[B + 1] = (uint8_t)((C >> 8) & 0xff);			\
+	A[B + 2] = (uint8_t)((C >> 16) & 0xff);			\
+	A[B + 3] = (uint8_t)((C >> 24) & 0xff);			\
+} while (0)
+
+// Reset the state to the empty message.
+#define MichaelClear(A)			\
+do {					\
+	A->L = A->K0;			\
+	A->R = A->K1;			\
+	A->nBytesInM = 0;		\
+} while (0)
+
+static
+void MichaelInitializeFunction(struct michael_mic_t *Mic, uint8_t *key)
+{
+	// Set the key
+	Mic->K0 = getUInt32(key, 0);
+	Mic->K1 = getUInt32(key, 4);
+
+	//clear();
+	MichaelClear(Mic);
+}
+
+#define MichaelBlockFunction(L, R)				\
+do {								\
+	R ^= ROL32(L, 17);					\
+	L += R;							\
+	R ^= ((L & 0xff00ff00) >> 8) | ((L & 0x00ff00ff) << 8);	\
+	L += R;							\
+	R ^= ROL32(L, 3);					\
+	L += R;							\
+	R ^= ROR32(L, 2);					\
+	L += R;							\
+} while (0)
+
+static
+void MichaelAppend(struct michael_mic_t *Mic, uint8_t *src, int nBytes)
+{
+	int addlen;
+
+	if (Mic->nBytesInM) {
+		addlen = 4 - Mic->nBytesInM;
+		if (addlen > nBytes)
+			addlen = nBytes;
+		memcpy(&Mic->M[Mic->nBytesInM], src, addlen);
+		Mic->nBytesInM += addlen;
+		src += addlen;
+		nBytes -= addlen;
+
+		if (Mic->nBytesInM < 4)
+			return;
+
+		Mic->L ^= getUInt32(Mic->M, 0);
+		MichaelBlockFunction(Mic->L, Mic->R);
+		Mic->nBytesInM = 0;
+	}
+
+	while (nBytes >= 4) {
+		Mic->L ^= getUInt32(src, 0);
+		MichaelBlockFunction(Mic->L, Mic->R);
+		src += 4;
+		nBytes -= 4;
+	}
+
+	if (nBytes > 0) {
+		Mic->nBytesInM = nBytes;
+		memcpy(Mic->M, src, nBytes);
+	}
+}
+
+static
+void MichaelGetMIC(struct michael_mic_t *Mic, uint8_t *dst)
+{
+	u8 *data = Mic->M;
+
+	switch (Mic->nBytesInM) {
+	case 0:
+		Mic->L ^= 0x5a;
+		break;
+	case 1:
+		Mic->L ^= data[0] | 0x5a00;
+		break;
+	case 2:
+		Mic->L ^= data[0] | (data[1] << 8) | 0x5a0000;
+		break;
+	case 3:
+		Mic->L ^= data[0] | (data[1] << 8) | (data[2] << 16) |
+		    0x5a000000;
+		break;
+	}
+	MichaelBlockFunction(Mic->L, Mic->R);
+	MichaelBlockFunction(Mic->L, Mic->R);
+	// The appendByte function has already computed the result.
+	putUInt32(dst, 0, Mic->L);
+	putUInt32(dst, 4, Mic->R);
+
+	// Reset to the empty message.
+	MichaelClear(Mic);
+}
+
+void MichaelMICFunction(struct michael_mic_t *Mic, u8 *Key,
+			u8 *Data, int Len, u8 priority,
+			u8 *Result)
+{
+	u8 pad_data[4] = { priority, 0, 0, 0 };
+	// Compute the MIC value
+	/*
+	 * IEEE802.11i  page 47
+	 * Figure 43g TKIP MIC processing format
+	 * +--+--+--------+--+----+--+--+--+--+--+--+--+--+
+	 * |6 |6 |1       |3 |M   |1 |1 |1 |1 |1 |1 |1 |1 | Octet
+	 * +--+--+--------+--+----+--+--+--+--+--+--+--+--+
+	 * |DA|SA|Priority|0 |Data|M0|M1|M2|M3|M4|M5|M6|M7|
+	 * +--+--+--------+--+----+--+--+--+--+--+--+--+--+
+	 */
+	MichaelInitializeFunction(Mic, Key);
+	MichaelAppend(Mic, (uint8_t *)Data, 12);	/* |DA|SA| */
+	MichaelAppend(Mic, pad_data, 4);	/* |Priority|0|0|0| */
+	MichaelAppend(Mic, (uint8_t *)(Data + 12), Len - 12);	/* |Data| */
+	MichaelGetMIC(Mic, Result);
+}
diff --git a/drivers/staging/ks7010/wext/michael_mic.h b/drivers/staging/ks7010/wext/michael_mic.h
new file mode 100644
index 0000000..758e429
--- /dev/null
+++ b/drivers/staging/ks7010/wext/michael_mic.h
@@ -0,0 +1,25 @@
+/*
+ *   Driver for KeyStream wireless LAN
+ *
+ *   Copyright (C) 2005-2008 KeyStream Corp.
+ *   Copyright (C) 2009 Renesas Technology Corp.
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License version 2 as
+ *   published by the Free Software Foundation.
+ */
+
+/* MichaelMIC routine define */
+struct michael_mic_t {
+	u32 K0;	// Key
+	u32 K1;	// Key
+	u32 L;	// Current state
+	u32 R;	// Current state
+	u8 M[4];	// Message accumulator (single word)
+	int nBytesInM;	// # bytes in M
+	u8 Result[8];
+};
+
+void MichaelMICFunction(struct michael_mic_t *Mic, u8 *Key,
+			u8 *Data, int Len, u8 priority,
+			u8 *Result);
-- 
2.7.4
