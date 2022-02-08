Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C191C4321E
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Feb 2022 01:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240328AbiBHBsC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Feb 2022 20:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343611AbiBHBbL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Feb 2022 20:31:11 -0500
Received: from web.adapt-ip.com (mail.adapt-ip.com [107.194.246.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BA4C061A73
        for <linux-wireless@vger.kernel.org>; Mon,  7 Feb 2022 17:31:10 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by web.adapt-ip.com (Postfix) with ESMTP id 218316A457B;
        Tue,  8 Feb 2022 01:24:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at web.adapt-ip.com
Received: from web.adapt-ip.com ([127.0.0.1])
        by localhost (web.adapt-ip.com [127.0.0.1]) (amavisd-new, port 10026)
        with LMTP id vQzK_EAtJTdF; Tue,  8 Feb 2022 01:24:51 +0000 (UTC)
Received: from atlas.campbell.adapt-ip.com (c-67-188-101-182.hsd1.ca.comcast.net [67.188.101.182])
        (Authenticated sender: thomas@adapt-ip.com)
        by web.adapt-ip.com (Postfix) with ESMTPSA id 81BC96A4543;
        Tue,  8 Feb 2022 01:24:51 +0000 (UTC)
From:   Thomas Pedersen <thomas@adapt-ip.com>
To:     sforshee@kernel.org
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Thomas Pedersen <thomas@adapt-ip.com>
Subject: [PATCH 2/2] wireless-regdb: add 802.11ah bands to world regulatory domain
Date:   Mon,  7 Feb 2022 17:24:50 -0800
Message-Id: <20220208012450.190982-2-thomas@adapt-ip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220208012450.190982-1-thomas@adapt-ip.com>
References: <20220208012450.190982-1-thomas@adapt-ip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

802.11ah does not have a band which intersects global
regulatory domains, so just add the possible range as
NO-IR to at least allow passive scan.

Signed-off-by: Thomas Pedersen <thomas@adapt-ip.com>
---
 db.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/db.txt b/db.txt
index b6732070f6d7..228b9bacb9ec 100644
--- a/db.txt
+++ b/db.txt
@@ -10,6 +10,9 @@ wmmrule ETSI:
 
 # This is the world regulatory domain
 country 00:
+	# There is no global intersection for 802.11ah, so just mark the entire
+	# possible band as NO-IR
+	(755 - 928 @ 2), (20), NO-IR
 	(2402 - 2472 @ 40), (20)
 	# Channel 12 - 13.
 	(2457 - 2482 @ 20), (20), NO-IR, AUTO-BW
-- 
2.30.2

