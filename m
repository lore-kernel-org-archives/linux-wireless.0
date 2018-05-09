Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58853 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935346AbeEIPgY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 11:36:24 -0400
Received: from mail-it0-f71.google.com ([209.85.214.71])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fGR8h-0007P3-QC
        for linux-wireless@vger.kernel.org; Wed, 09 May 2018 15:36:23 +0000
Received: by mail-it0-f71.google.com with SMTP id p12-v6so15167802itc.7
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2018 08:36:23 -0700 (PDT)
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iw: support reloading the regulatory database
Date: Wed,  9 May 2018 10:36:20 -0500
Message-Id: <20180509153620.23630-1-seth.forshee@canonical.com> (sfid-20180509_173628_460684_79EFEC18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a "iw reg reload" command, useful for testing new regulatory
databases.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 reg.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/reg.c b/reg.c
index cee0b5e8cedb..cadff3884c04 100644
--- a/reg.c
+++ b/reg.c
@@ -259,3 +259,13 @@ COMMAND(reg, get, NULL, NL80211_CMD_GET_REG, 0, CIB_PHY, handle_reg_get,
 	"Print out the devices' current regulatory domain information.");
 HIDDEN(reg, dump, NULL, NL80211_CMD_GET_REG, NLM_F_DUMP, CIB_NONE,
        handle_reg_dump);
+
+static int handle_reg_reload(struct nl80211_state *state,
+			     struct nl_msg *msg,
+			     int argc, char **argv,
+			     enum id_input id)
+{
+	return 0;
+}
+COMMAND(reg, reload, NULL, NL80211_CMD_RELOAD_REGDB, 0, CIB_NONE,
+	handle_reg_reload, "Reload the kernel's regulatory database.");
-- 
2.17.0
