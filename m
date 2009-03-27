Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46806 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409AbZC0PoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:44:17 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 1/4] rfkill: minor locking fix
Date: Fri, 27 Mar 2009 12:44:08 -0300
Message-Id: <1238168651-28891-2-git-send-email-hmh@hmh.eng.br> (sfid-20090327_164422_843547_82544339)
In-Reply-To: <1238168651-28891-1-git-send-email-hmh@hmh.eng.br>
References: <1238168651-28891-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The API requires that we lock rfkill->mutex before we call
rfkill_toggle_radio().  We weren't doing it in rfkill_add_switch(),
which is part of the rfkill_register() code flow.

It is higly unlikely that something would access the rfkill struct
while it is not even registered yet, so this is not a bug I would ever
expect to see triggered.

Still, there is no reason to not fix anyway and thus always enforce
the API.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 3eaa394..f00df8c 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -629,9 +629,11 @@ static int rfkill_add_switch(struct rfkill *rfkill)
 			rfkill_global_states[rfkill->type].default_state;
 	}
 
+	mutex_lock(&rfkill->mutex);
 	rfkill_toggle_radio(rfkill,
 			    rfkill_global_states[rfkill->type].current_state,
 			    0);
+	mutex_unlock(&rfkill->mutex);
 
 	list_add_tail(&rfkill->node, &rfkill_list);
 
-- 
1.6.2.1

