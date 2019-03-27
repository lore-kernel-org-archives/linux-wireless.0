Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B39C4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5669C205C9
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 18:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553712764;
	bh=5ZQViHz22hO0VmxgPARm9wubLwvoHo0bajPvIkxF/1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xayPEi93JHpEKmGGPCyjq83TiP/kPXcDtlI/RhdDGvknwrcYdr9TIesqO5r0FZ0V+
	 JxJlfxsTQEeuxdWcNiRh3TTxtNoP+6eb3phrAwyXC77Nhawss7bRWry4giCpbHOWor
	 msBBJzn/6rGFB+EfveXDWaeUMbnGS+b/kZD9ljLo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390336AbfC0SRj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390316AbfC0SRb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 14:17:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E15F221741;
        Wed, 27 Mar 2019 18:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710650;
        bh=5ZQViHz22hO0VmxgPARm9wubLwvoHo0bajPvIkxF/1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4Zvm5HR9FGi27ME+VGInSYV8wBoyDyJqYJKCN+6YcpVBBw4wvn/6QwJUcgdJq1YB
         y+aFr7ye8fvQIf59o1V30Bb05Ivnili/VkhnvqFXeoNXWkNjyd7ivgOxc5b6NRDGe2
         96XxU2XvCFiIwk3QAhJWjRgiWYDmQ82bFNDX2itk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 033/123] wil6210: check null pointer in _wil_cfg80211_merge_extra_ies
Date:   Wed, 27 Mar 2019 14:14:57 -0400
Message-Id: <20190327181628.15899-33-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181628.15899-1-sashal@kernel.org>
References: <20190327181628.15899-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

[ Upstream commit de77a53c2d1e8fb3621e63e8e1f0f0c9a1a99ff7 ]

ies1 or ies2 might be null when code inside
_wil_cfg80211_merge_extra_ies access them.
Add explicit check for null and make sure ies1/ies2 are not
accessed in such a case.

spos might be null and be accessed inside
_wil_cfg80211_merge_extra_ies.
Add explicit check for null in the while condition statement
and make sure spos is not accessed in such a case.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 85d5c04618eb..c374ed311520 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1224,6 +1224,12 @@ static int _wil_cfg80211_merge_extra_ies(const u8 *ies1, u16 ies1_len,
 	u8 *buf, *dpos;
 	const u8 *spos;
 
+	if (!ies1)
+		ies1_len = 0;
+
+	if (!ies2)
+		ies2_len = 0;
+
 	if (ies1_len == 0 && ies2_len == 0) {
 		*merged_ies = NULL;
 		*merged_len = 0;
@@ -1233,17 +1239,19 @@ static int _wil_cfg80211_merge_extra_ies(const u8 *ies1, u16 ies1_len,
 	buf = kmalloc(ies1_len + ies2_len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-	memcpy(buf, ies1, ies1_len);
+	if (ies1)
+		memcpy(buf, ies1, ies1_len);
 	dpos = buf + ies1_len;
 	spos = ies2;
-	while (spos + 1 < ies2 + ies2_len) {
+	while (spos && (spos + 1 < ies2 + ies2_len)) {
 		/* IE tag at offset 0, length at offset 1 */
 		u16 ielen = 2 + spos[1];
 
 		if (spos + ielen > ies2 + ies2_len)
 			break;
 		if (spos[0] == WLAN_EID_VENDOR_SPECIFIC &&
-		    !_wil_cfg80211_find_ie(ies1, ies1_len, spos, ielen)) {
+		    (!ies1 || !_wil_cfg80211_find_ie(ies1, ies1_len,
+						     spos, ielen))) {
 			memcpy(dpos, spos, ielen);
 			dpos += ielen;
 		}
-- 
2.19.1

