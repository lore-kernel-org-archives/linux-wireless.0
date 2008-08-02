Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44183 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997AbYHBR4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 13:56:34 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 2/2] rfkill: use strict_strtoul
Date: Sat,  2 Aug 2008 14:56:26 -0300
Message-Id: <1217699786-20672-3-git-send-email-hmh@hmh.eng.br> (sfid-20080802_195636_889813_04094C6C)
In-Reply-To: <1217699786-20672-1-git-send-email-hmh@hmh.eng.br>
References: <1217699786-20672-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Switch sysfs parsing to something that actually works properly.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 35a9994..2ec6312 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -352,12 +352,16 @@ static ssize_t rfkill_state_store(struct device *dev,
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
@@ -385,7 +389,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct rfkill *rfkill = to_rfkill(dev);
-	bool claim = !!simple_strtoul(buf, NULL, 0);
+	unsigned long claim;
 	int error;
 
 	if (!capable(CAP_NET_ADMIN))
@@ -394,6 +398,10 @@ static ssize_t rfkill_claim_store(struct device *dev,
 	if (rfkill->user_claim_unsupported)
 		return -EOPNOTSUPP;
 
+	error = strict_strtoul(buf, 0, &claim);
+	if (error)
+		return error;
+
 	/*
 	 * Take the global lock to make sure the kernel is not in
 	 * the middle of rfkill_switch_all
@@ -402,7 +410,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
 	if (error)
 		return error;
 
-	if (rfkill->user_claim != claim) {
+	if (!!rfkill->user_claim != !!claim) {
 		if (!claim) {
 			mutex_lock(&rfkill->mutex);
 			rfkill_toggle_radio(rfkill,
@@ -410,7 +418,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
 					    0);
 			mutex_unlock(&rfkill->mutex);
 		}
-		rfkill->user_claim = claim;
+		rfkill->user_claim = !!claim;
 	}
 
 	mutex_unlock(&rfkill_mutex);
-- 
1.5.6.3

