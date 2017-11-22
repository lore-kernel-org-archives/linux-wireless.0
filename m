Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:38375 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751379AbdKVB1D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 20:27:03 -0500
Received: by mail-qk0-f193.google.com with SMTP id a142so14740796qkb.5
        for <linux-wireless@vger.kernel.org>; Tue, 21 Nov 2017 17:27:03 -0800 (PST)
From: Li Jin <li.jin@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, Jason Uy <jason.uy@broadcom.com>,
        Li Jin <li.jin@broadcom.com>
Subject: [PATCH INTERNAL V2 1/1] brcmfmac: add console log support with configurable read size
Date: Tue, 21 Nov 2017 17:26:30 -0800
Message-Id: <1511313990-19334-1-git-send-email-li.jin@broadcom.com> (sfid-20171122_022736_042775_E761C997)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jason Uy <jason.uy@broadcom.com>

Add support for configurable read size so that older wifi
chips that have size restrictions can be supported.

Signed-off-by: Jason Uy <jason.uy@broadcom.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Li Jin <li.jin@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  5 +++
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |  2 ++
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 39 ++++++++++++++++++++--
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 7a2b495..e1bfcaa 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -52,6 +52,10 @@ int brcmf_msg_level;
 module_param_named(debug, brcmf_msg_level, int, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(debug, "Level of debug output");
 
+static unsigned int brcmf_log_size;
+module_param_named(logsize, brcmf_log_size, int, 0000);
+MODULE_PARM_DESC(logsize, "Size of log output to read each time");
+
 static int brcmf_p2p_enable;
 module_param_named(p2pon, brcmf_p2p_enable, int, 0);
 MODULE_PARM_DESC(p2pon, "Enable legacy p2p management functionality");
@@ -287,6 +291,7 @@ struct brcmf_mp_device *brcmf_get_module_param(struct device *dev,
 	settings->feature_disable = brcmf_feature_disable;
 	settings->fcmode = brcmf_fcmode;
 	settings->roamoff = !!brcmf_roamoff;
+	settings->log_size = brcmf_log_size;
 #ifdef DEBUG
 	settings->ignore_probe_fail = !!brcmf_ignore_probe_fail;
 #endif
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index a62f8e7..f3eab04 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -51,6 +51,7 @@ extern struct brcmf_mp_global_t brcmf_mp_global;
  * @roamoff: Firmware roaming off?
  * @ignore_probe_fail: Ignore probe failure.
  * @country_codes: If available, pointer to struct for translating country codes
+ * @log_size: limit the read size when accessing log from wifi chip
  * @bus: Bus specific platform data. Only SDIO at the mmoment.
  */
 struct brcmf_mp_device {
@@ -60,6 +61,7 @@ struct brcmf_mp_device {
 	bool		roamoff;
 	bool		ignore_probe_fail;
 	struct brcmfmac_pd_cc *country_codes;
+	unsigned int	log_size;
 	union {
 		struct brcmfmac_sdio_pd sdio;
 	} bus;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 613caca..71ba680 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2790,6 +2790,10 @@ static int brcmf_sdio_readconsole(struct brcmf_sdio *bus)
 	u8 line[CONSOLE_LINE_MAX], ch;
 	u32 n, idx, addr;
 	int rv;
+	unsigned int left_to_read;
+	unsigned int offset;
+	unsigned int cur_read_size;
+	unsigned int log_size = bus->sdiodev->settings->log_size;
 
 	/* Don't do anything until FWREADY updates console address */
 	if (bus->console_addr == 0)
@@ -2823,9 +2827,38 @@ static int brcmf_sdio_readconsole(struct brcmf_sdio *bus)
 
 	/* Read the console buffer */
 	addr = le32_to_cpu(c->log_le.buf);
-	rv = brcmf_sdiod_ramrw(bus->sdiodev, false, addr, c->buf, c->bufsize);
-	if (rv < 0)
-		return rv;
+
+	if (log_size > 0) {
+		/* limit the amount of data to read in case wifi chip has
+		 * restrictions
+		 */
+		left_to_read = c->bufsize;
+		offset = 0;
+		while (left_to_read) {
+			cur_read_size = (left_to_read > log_size) ?
+					 log_size :
+					 left_to_read;
+
+			rv = brcmf_sdiod_ramrw(bus->sdiodev,
+					       false,
+					       addr + offset,
+					       c->buf + offset,
+					       cur_read_size);
+			if (rv < 0)
+				return rv;
+
+			left_to_read -= cur_read_size;
+			offset += cur_read_size;
+		}
+	} else {
+		rv = brcmf_sdiod_ramrw(bus->sdiodev,
+				       false,
+				       addr,
+				       c->buf,
+				       c->bufsize);
+		if (rv < 0)
+			return rv;
+	}
 
 	while (c->last != idx) {
 		for (n = 0; n < CONSOLE_LINE_MAX - 2; n++) {
-- 
2.7.4
