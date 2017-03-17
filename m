Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:57346 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbdCQQCF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 12:02:05 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: ath10k@lists.infradead.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>,
        Julian Calaby <julian.calaby@gmail.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Subject: [PATCHv2 1/3] ath9k: Support channels in licensed bands
Date: Fri, 17 Mar 2017 17:00:20 +0100
Message-Id: <20170317160020.30991-1-sw@simonwunderlich.de> (sfid-20170317_170220_637387_859429C5)
In-Reply-To: <096bcee2-a991-eac1-8f4f-d7cf7c34730d@neratec.com>
References: <096bcee2-a991-eac1-8f4f-d7cf7c34730d@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Many chips support channels in licensed bands. Add support for those,
along with a corresponding kernel config option to disable them by
default. Note that these channels are not selectable even if the
option has been compiled unless the user modifies the regulatory
database to explicitly enable the corresponding channels.

NOTE:  These channels must not be used in most regulatory
domains unless you have a license from the FCC or similar!

Signed-off-by: Ben Greear <greearb@candelatech.com>
[Hide this support behind a Kconfig option]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
[only use the 20 mhz channels, add 5 ghz, change to 4.9ghz to licensed bands, simplify]
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
---
Changes to PATCHv1:
 * fix bug reported by Zefir, and simplify patch more
---
 drivers/net/wireless/ath/ath9k/Kconfig       | 20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-init.c | 15 +++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h          |  4 ++++
 3 files changed, 39 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 783a38f1a626..23b8abf4449a 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -116,6 +116,26 @@ config ATH9K_DFS_CERTIFIED
 	  developed. At this point enabling this option won't do anything
 	  except increase code size.
 
+config ATH9K_LICENSED_CHAN
+	bool "Support channels in licensed bands"
+	depends on ATH9K && CFG80211_CERTIFICATION_ONUS
+	default n
+	---help---
+	  This option enables support for licensed channels on such as
+          4.9 GHz (public safety).
+
+	  These are PUBLIC SAFETY CHANNELS and MUST NOT BE USED in most
+	  regulatory domains UNLESS YOU HAVE A FULL LICENSE for their use from
+	  your local radio regulator, e.g. the FCC or equivalent. Using these
+	  channels without proper authorisation may result in serious legal
+	  consequences.
+
+	  You will also have to build a regulatory database with these channels
+	  enabled to actually use them.
+
+	  If you are a distro kernel builder or have any doubt whatsoever about
+	  your legal ability to use these channels, say N.
+
 config ATH9K_DYNACK
 	bool "Atheros ath9k ACK timeout estimation algorithm (EXPERIMENTAL)"
 	depends on ATH9K
diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
index 8b4f7fdabf58..3d65dce13048 100644
--- a/drivers/net/wireless/ath/ath9k/common-init.c
+++ b/drivers/net/wireless/ath/ath9k/common-init.c
@@ -86,6 +86,21 @@ static const struct ieee80211_channel ath9k_5ghz_chantable[] = {
 	CHAN5G(5785, 35), /* Channel 157 */
 	CHAN5G(5805, 36), /* Channel 161 */
 	CHAN5G(5825, 37), /* Channel 165 */
+
+#ifdef CONFIG_ATH9K_LICENSED_CHAN
+	/* 4.9Ghz channels, public safety channels, license is required in US
+	 * and most other regulatory domains!
+	 */
+	/* 802.11j 4.9 GHz (20 MHz) */
+	CHAN5G(4920, 38), /* channel 184 */
+	CHAN5G(4940, 39), /* channel 188 */
+	CHAN5G(4960, 40), /* channel 192 */
+	CHAN5G(4980, 41), /* channel 196 */
+	/* 802.11j 5.030 - 5.080 GHz (20 MHz) */
+	CHAN5G(5040, 42), /* channel 8 */
+	CHAN5G(5060, 43), /* channel 12 */
+	CHAN5G(5080, 44), /* channel 16 */
+#endif
 };
 
 /* Atheros hardware rate code addition for short premble */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9cbca1229bac..2166f644599d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -73,7 +73,11 @@
 
 #define ATH9K_RSSI_BAD			-128
 
+#ifdef CONFIG_ATH9K_LICENSED_CHAN
+#define ATH9K_NUM_CHANNELS	45
+#else
 #define ATH9K_NUM_CHANNELS	38
+#endif
 
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) \
-- 
2.11.0
