Return-Path: <SRS0=wUyo=XD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBFAC433EF
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Sep 2019 08:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 034C620863
	for <linux-wireless@archiver.kernel.org>; Sun,  8 Sep 2019 08:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfIHIjX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 8 Sep 2019 04:39:23 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:7970 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727423AbfIHIjT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Sep 2019 04:39:19 -0400
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 08 Sep 2019 10:33:06 +0200
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 08 Sep 2019 10:33:05 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Subject: [PATCH 11/11] wil6210: ignore reset errors for FW during probe
Date:   Sun,  8 Sep 2019 11:32:55 +0300
Message-Id: <1567931575-27984-12-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1567931575-27984-1-git-send-email-merez@codeaurora.org>
References: <1567931575-27984-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lior David <liord@codeaurora.org>

There are special kinds of FW such as WMI only which
are used for testing, diagnostics and other specific
scenario.
Such FW is loaded during driver probe and the driver
disallows enabling any network interface, to avoid
operational issues.
In many cases it is used to debug early versions
of FW with new features, which sometimes fail
on startup.
Currently when such FW fails to load (for example,
because of init failure), the driver probe would fail
and shutdown the device making it difficult to debug
the early failure.
To fix this, ignore load failures in WMI only FW and
allow driver probe to succeed, making it possible to
continue and debug the FW load failure.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index cd417fa..904dcfa 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -537,7 +537,7 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		mutex_unlock(&wil->mutex);
 		if (rc) {
 			wil_err(wil, "failed to load WMI only FW\n");
-			goto if_remove;
+			/* ignore the error to allow debugging */
 		}
 	}
 
@@ -557,8 +557,6 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
-if_remove:
-	wil_if_remove(wil);
 bus_disable:
 	wil_if_pcie_disable(wil);
 err_iounmap:
-- 
1.9.1

