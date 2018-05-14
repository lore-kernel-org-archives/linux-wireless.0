Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:37929 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751953AbeENGtc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 02:49:32 -0400
Received: by mail-lf0-f65.google.com with SMTP id z142-v6so16223875lff.5
        for <linux-wireless@vger.kernel.org>; Sun, 13 May 2018 23:49:32 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2] brcmfmac: add debugfs entry for reading firmware capabilities
Date: Mon, 14 May 2018 08:48:20 +0200
Message-Id: <20180514064820.24305-1-zajec5@gmail.com> (sfid-20180514_084936_495874_1E737E65)
In-Reply-To: <20180511101526.10734-1-zajec5@gmail.com>
References: <20180511101526.10734-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This allows reading all capabilities as reported by a firmware. They are
printed using native (raw) names, just like developers like it the most.
It's how firmware reports support for various features, e.g. supported
modes, supported standards, power saving details, max BSS-es.

Access to all that info is useful for trying new firmwares, comparing
them and debugging features AKA bugs.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
V2: Use "fwcap" as debugfs entry
    Rename function to the brcmf_feat_fwcap_debugfs_read()
---
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 36 ++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 876731c57bf5..800a423c7bc2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -165,6 +165,41 @@ static void brcmf_feat_firmware_capabilities(struct brcmf_if *ifp)
 	}
 }
 
+/**
+ * brcmf_feat_fwcap_debugfs_read() - expose firmware capabilities to debugfs.
+ *
+ * @seq: sequence for debugfs entry.
+ * @data: raw data pointer.
+ */
+static int brcmf_feat_fwcap_debugfs_read(struct seq_file *seq, void *data)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(seq->private);
+	struct brcmf_if *ifp = brcmf_get_ifp(bus_if->drvr, 0);
+	char caps[MAX_CAPS_BUFFER_SIZE + 1] = { };
+	char *tmp;
+	int err;
+
+	err = brcmf_fil_iovar_data_get(ifp, "cap", caps, sizeof(caps));
+	if (err) {
+		brcmf_err("could not get firmware cap (%d)\n", err);
+		return err;
+	}
+
+	/* Put every capability in a new line */
+	for (tmp = caps; *tmp; tmp++) {
+		if (*tmp == ' ')
+			*tmp = '\n';
+	}
+
+	/* Usually there is a space at the end of capabilities string */
+	seq_printf(seq, "%s", caps);
+	/* So make sure we don't print two line breaks */
+	if (tmp > caps && *(tmp - 1) != '\n')
+		seq_printf(seq, "\n");
+
+	return 0;
+}
+
 void brcmf_feat_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
@@ -233,6 +268,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 void brcmf_feat_debugfs_create(struct brcmf_pub *drvr)
 {
 	brcmf_debugfs_add_entry(drvr, "features", brcmf_feat_debugfs_read);
+	brcmf_debugfs_add_entry(drvr, "fwcap", brcmf_feat_fwcap_debugfs_read);
 }
 
 bool brcmf_feat_is_enabled(struct brcmf_if *ifp, enum brcmf_feat_id id)
-- 
2.13.6
