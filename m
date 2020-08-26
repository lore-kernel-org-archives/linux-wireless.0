Return-Path: <SRS0=rnpS=CE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80F8C433DF
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Aug 2020 23:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7289D20639
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Aug 2020 23:20:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="rRlCEZFl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgHZXUv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Aug 2020 19:20:51 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:52040 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgHZXUu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Aug 2020 19:20:50 -0400
Received: from ben-dt4.candelatech.com (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        by mail3.candelatech.com (Postfix) with ESMTP id 718B613C2B0;
        Wed, 26 Aug 2020 16:20:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 718B613C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1598484046;
        bh=hlkOdEkpj5SSiVXE4RnPDRbOtL3tNfP1w1416ALnnxU=;
        h=From:To:Cc:Subject:Date:From;
        b=rRlCEZFlTqdjkguYmr2bzi0umYPmhQiFDARYqdcFOAr9zzPNH5WuuQ26g5YdHVZir
         z4iPYDPCnHQ4lP3n7VGOWZ18FLv1xxaQ28xCX4Jmd9RYQJa1UBbIRit3ZDYRtEeFm0
         nvG5sd3YcX+5KJU0iVx4X1r6lrx1ahYU06DAtDt8=
From:   greearb@candelatech.com
To:     ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath11k:  Support loading ELF board files.
Date:   Wed, 26 Aug 2020 16:20:44 -0700
Message-Id: <20200826232044.6799-1-greearb@candelatech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

The QCA6390 board I have, model 8291M-PR comes with an ELF board
file.  To get this to at least somewhat work, I renamed bdwlan.e04
to 'board.bin' and then added this patch to check for .ELF as
starting bytes of the board file.  If that is found, use type
ELF.  After this the driver loads.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This is on top of recent kvallo ath tree.

 drivers/net/wireless/ath/ath11k/qmi.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 91134510364c..f87f1d1564f4 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1992,6 +1992,7 @@ static int ath11k_qmi_load_bdf_qmi(struct ath11k_base *ab)
 	struct qmi_txn txn = {};
 	int ret;
 	const u8 *temp;
+	int bdf_type = ATH11K_QMI_BDF_TYPE_BIN;
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
@@ -2008,6 +2009,15 @@ static int ath11k_qmi_load_bdf_qmi(struct ath11k_base *ab)
 	temp = bd.data;
 	remaining = bd.len;
 
+	if (bd.len >= 4) {
+		char* edata = (char*)(temp);
+		if (edata[1] == 'E' &&
+		    edata[2] == 'L' &&
+		    edata[3] == 'F') {
+			bdf_type = ATH11K_QMI_BDF_TYPE_ELF;
+		}
+	}
+
 	while (remaining) {
 		req->valid = 1;
 		req->file_id_valid = 1;
@@ -2017,7 +2027,7 @@ static int ath11k_qmi_load_bdf_qmi(struct ath11k_base *ab)
 		req->seg_id_valid = 1;
 		req->data_valid = 1;
 		req->data_len = ATH11K_QMI_MAX_BDF_FILE_NAME_SIZE;
-		req->bdf_type = ATH11K_QMI_BDF_TYPE_BIN;
+		req->bdf_type = bdf_type;
 		req->bdf_type_valid = 1;
 		req->end_valid = 1;
 		req->end = 0;
-- 
2.26.2

