Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bb-87-81-255-5.ukonline.co.uk ([87.81.255.5]:48308 "EHLO
	pegasus." rhost-flags-OK-OK-FAIL-FAIL) by vger.kernel.org with ESMTP
	id S1753703AbYDLPs7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2008 11:48:59 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: [PATCH] rfkill: Fix device type check when toggling states
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ivdoorn@gmail.com
Date: Sat, 12 Apr 2008 16:39:47 +0100
Message-ID: <20080412153947.16498.12348.stgit@localhost> (sfid-20080412_164903_848873_92484066)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rfkill_switch_all() is supposed to only switch all the interfaces of a
given type, but does not actually do this; instead, it just switches
everything currently in the same state.

Add the necessary type check in.

(This fixes a bug I've been seeing while developing an rfkill laptop
driver, with both bluetooth and wireless simultaneously changing state
after only pressing either KEY_WLAN or KEY_BLUETOOTH).

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
---

 net/rfkill/rfkill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 140a0a8..4e10a95 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -92,7 +92,7 @@ void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
 	rfkill_states[type] = state;
 
 	list_for_each_entry(rfkill, &rfkill_list, node) {
-		if (!rfkill->user_claim)
+		if ((!rfkill->user_claim) && (rfkill->type == type))
 			rfkill_toggle_radio(rfkill, state);
 	}
 

