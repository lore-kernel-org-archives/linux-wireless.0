Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42196 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbYFDDKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 23:10:21 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 04/12] rfkill: add parameter to disable radios by default
Date: Wed,  4 Jun 2008 00:10:09 -0300
Message-Id: <1212549017-30144-5-git-send-email-hmh@hmh.eng.br> (sfid-20080604_051032_046910_6E1503FF)
In-Reply-To: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, radios are always enabled when their rfkill interface is
registered.  This is not optimal, the safest state for a radio is to be
offline unless the user turns it on.

Add a module parameter that causes all radios to be disabled when their
rfkill interface is registered.  The module default is not changed so
unless the parameter is used, radios will still be forced to their enabled
state when they are registered.

The new rfkill module parameter is called "default_state".

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index f95081a..3edc585 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -39,6 +39,11 @@ MODULE_LICENSE("GPL");
 static LIST_HEAD(rfkill_list);	/* list of registered rf switches */
 static DEFINE_MUTEX(rfkill_mutex);
 
+static unsigned int rfkill_default_state = RFKILL_STATE_ON;
+module_param_named(default_state, rfkill_default_state, uint, 0444);
+MODULE_PARM_DESC(default_state,
+		 "Default initial state for all radio types, 0 = radio off");
+
 static enum rfkill_state rfkill_states[RFKILL_TYPE_MAX];
 
 
@@ -436,8 +441,12 @@ static int __init rfkill_init(void)
 	int error;
 	int i;
 
+	if (rfkill_default_state != RFKILL_STATE_OFF &&
+	    rfkill_default_state != RFKILL_STATE_ON)
+		return -EINVAL;
+
 	for (i = 0; i < ARRAY_SIZE(rfkill_states); i++)
-		rfkill_states[i] = RFKILL_STATE_ON;
+		rfkill_states[i] = rfkill_default_state;
 
 	error = class_register(&rfkill_class);
 	if (error) {
-- 
1.5.5.3

