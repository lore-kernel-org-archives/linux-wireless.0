Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39054 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753AbYHZO6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 10:58:07 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 1/5] rfkill: use strict_strtoul (v2)
Date: Tue, 26 Aug 2008 11:57:57 -0300
Message-Id: <1219762681-26911-2-git-send-email-hmh@hmh.eng.br> (sfid-20080826_165815_868887_6229B640)
In-Reply-To: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br>
References: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Switch sysfs parsing to something that actually works properly.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 47e0b2d..173d039 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -402,12 +402,16 @@ static ssize_t rfkill_state_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct rfkill *rfkill = to_rfkill(dev);
-	unsigned int state = simple_strtoul(buf, NULL, 0);
+	unsigned long state;
 	int error;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
+	error = strict_strtoul(buf, 0, &state);
+	if (error)
+		return error;
+
 	/* RFKILL_STATE_HARD_BLOCKED is illegal here... */
 	if (state != RFKILL_STATE_UNBLOCKED &&
 	    state != RFKILL_STATE_SOFT_BLOCKED)
@@ -435,7 +439,8 @@ static ssize_t rfkill_claim_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct rfkill *rfkill = to_rfkill(dev);
-	bool claim = !!simple_strtoul(buf, NULL, 0);
+	unsigned long claim_tmp;
+	bool claim;
 	int error;
 
 	if (!capable(CAP_NET_ADMIN))
@@ -444,6 +449,11 @@ static ssize_t rfkill_claim_store(struct device *dev,
 	if (rfkill->user_claim_unsupported)
 		return -EOPNOTSUPP;
 
+	error = strict_strtoul(buf, 0, &claim_tmp);
+	if (error)
+		return error;
+	claim = !!claim_tmp;
+
 	/*
 	 * Take the global lock to make sure the kernel is not in
 	 * the middle of rfkill_switch_all
-- 
1.5.6.3

