Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B20CFC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 17:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76C0120700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 17:07:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kK2VBCDu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfBVRH4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:07:56 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43688 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbfBVRHz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 12:07:55 -0500
Received: by mail-lj1-f194.google.com with SMTP id z20so2243717ljj.10
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2019 09:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9X+hoCf/DrAGXjknfs/pC7GI0y5CEo4O4tRaYC18Q20=;
        b=kK2VBCDuflrhWaBoqw5jT0MSWyLxSJ6i7zh7Y6uXGdVrvF2mL91wlpgdMHEbdoOgpO
         yYgH4zr46DpR5gjSTYH7dPF0wpNj0N01AZ95nzwHqSsJVvxFRuVFbTX4emubOCf/OpcT
         9x1rujuKya9uq5lTmuQdGFH/zZM9RBd+KoCeGkMR0FMEZPlf8Lo34Qak+W1cfTg34mSP
         77Pw1bEhD5KtCrHgKc/81Q0G+2f3Gy+cE3qZN7rYTRO7yucg+sy2/4kAAW+LLnSvsaJS
         0LKg9yoyWFMrT8VX3PYv5cl7Nl2dzOg3BLYqQsznFD1VKWJ4D3np4l6LB5EfDnd+IXDL
         4xmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9X+hoCf/DrAGXjknfs/pC7GI0y5CEo4O4tRaYC18Q20=;
        b=HbT8cV9N0jTg1StRREKYxA8Z5/gmPrzTpJQsiU49e8i/hlu4QKYsQKHtVefoJlzpmH
         KBxXG/Pe+iKMyeFS/sSa9hSMmv/7RfMO5ttSuMcsVaryQ64KTHRgr4vlbTmoPYI+g0io
         FpttXxC8yLeuqNwmj2PRUc0jFzJGlWvwhPe/gcH+vGmg2oLclct0fmhIiwgfyjo9IRZZ
         of1j1Pnmy0wW+8hdXfaLGOq/RSMop7NH8cEfgw6IxUYp9xT1bQWv+vO7j4BoXUK7eN00
         KjMEkYgL4xH2PMOUnG0tu1+EcGbCkItHt8NzC0FP5xk2/c/5+z2+T/Ci2SWOzZHmq1hZ
         fAzA==
X-Gm-Message-State: AHQUAuZIvOnNspGOX0yg2YQ+uKAzbLdb9SD8l2Ite9luB2LspZyMJTGV
        /iz6O/hc32FEuS4J5CIbgcg=
X-Google-Smtp-Source: AHgI3IYJzBL+h208nWEtCwI1zIkyDOY/gzvBAfMXeABf+NbQVh0y5rrbqVfNL5O+ThBJD+EPxZAtZQ==
X-Received: by 2002:a2e:99c9:: with SMTP id l9mr2987258ljj.60.1550855272578;
        Fri, 22 Feb 2019 09:07:52 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id p15sm611946lfc.88.2019.02.22.09.07.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 09:07:51 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] brcmfmac: run firmware state watchdog on the host machine
Date:   Fri, 22 Feb 2019 18:07:39 +0100
Message-Id: <20190222170739.14266-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

FullMAC firmware may happen to crash due to some potential bugs exposed
by e.g. a specific traffic or host-requested setup. It usually results
in various timeouts & running our of resources (e.g. ring slots).

Monitoring firmware state allows handling such a situation more
gracefully. At this point the watchdog:
1) Prints a clear error message about a firmware crash
2) Tries to dump a crash info data

That should be helpful for users & should allow providing a valuable
reports for the Broadcom developers. It obviously doesn't really fix
anything.

This watchdog is important for USB & SDIO devices which don't have
anything alike implemented yet. It's also there to complement PCIe with
its FWHALT signal which does not work in all situations.

It has been successfully tested with the recently released
brcmfmac4366c-pcie.bin.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201853
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../broadcom/brcm80211/brcmfmac/core.c        | 28 +++++++++++++++++++
 .../broadcom/brcm80211/brcmfmac/core.h        |  2 ++
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 4fbe8791f674..ab7a54b2d831 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -40,6 +40,7 @@
 #include "common.h"
 
 #define MAX_WAIT_FOR_8021X_TX			msecs_to_jiffies(950)
+#define BRCMF_FW_WATCHDOG_POLL			msecs_to_jiffies(1000)
 
 #define BRCMF_BSSIDX_INVALID			-1
 
@@ -1084,6 +1085,28 @@ static int brcmf_revinfo_read(struct seq_file *s, void *data)
 	return 0;
 }
 
+static void brcmf_fw_watchdog(struct work_struct *work)
+{
+	struct brcmf_pub *drvr = container_of(work, struct brcmf_pub,
+					      fw_watchdog.work);
+
+	if (drvr->bus_if->state == BRCMF_BUS_UP) {
+		struct brcmf_if *ifp = drvr->iflist[0];
+		s32 ver;
+		int err;
+
+		err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION, &ver);
+		if (err) {
+			bphy_err(drvr, "Firmware has most likely crashed and didn't respond: %d\n",
+				 err);
+			brcmf_dev_coredump(drvr->bus_if->dev);
+			return;
+		}
+	}
+
+	schedule_delayed_work(&drvr->fw_watchdog, BRCMF_FW_WATCHDOG_POLL);
+}
+
 static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 {
 	int ret = -1;
@@ -1155,6 +1178,9 @@ static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 #endif
 #endif /* CONFIG_INET */
 
+	INIT_DELAYED_WORK(&drvr->fw_watchdog, brcmf_fw_watchdog);
+	schedule_delayed_work(&drvr->fw_watchdog, BRCMF_FW_WATCHDOG_POLL);
+
 	/* populate debugfs */
 	brcmf_debugfs_add_entry(drvr, "revinfo", brcmf_revinfo_read);
 	brcmf_feat_debugfs_create(drvr);
@@ -1284,6 +1310,8 @@ void brcmf_detach(struct device *dev)
 	if (drvr == NULL)
 		return;
 
+	cancel_delayed_work_sync(&drvr->fw_watchdog);
+
 #ifdef CONFIG_INET
 	unregister_inetaddr_notifier(&drvr->inetaddr_notifier);
 #endif
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index d8085ce579f4..1b44d243d05f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -143,6 +143,8 @@ struct brcmf_pub {
 	struct notifier_block inet6addr_notifier;
 	struct brcmf_mp_device *settings;
 
+	struct delayed_work fw_watchdog;
+
 	u8 clmver[BRCMF_DCMD_SMLEN];
 };
 
-- 
2.20.1

