Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaI3NXA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 09:23:00 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/2] iw: allow to configure dynamic power save timeout
Date: Tue, 30 Sep 2014 15:20:35 +0200
Message-Id: <1412083235-8560-2-git-send-email-sgruszka@redhat.com> (sfid-20140930_152304_087453_00D3CA0D)
In-Reply-To: <1412083235-8560-1-git-send-email-sgruszka@redhat.com>
References: <1412083235-8560-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 ps.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/ps.c b/ps.c
index 4c8e2d1..83ee9d5 100644
--- a/ps.c
+++ b/ps.c
@@ -15,19 +15,29 @@ static int set_power_save(struct nl80211_state *state,
 			  enum id_input id)
 {
 	enum nl80211_ps_state ps_state;
+	int timeout;
+	char *endp;
 
-	if (argc != 1) {
-		printf("Invalid parameters!\n");
-		return 2;
-	}
+	if (argc != 1 && argc != 3)
+		goto invalid_parameters;
 
 	if (strcmp(argv[0], "on") == 0)
 		ps_state = NL80211_PS_ENABLED;
 	else if (strcmp(argv[0], "off") == 0)
 		ps_state = NL80211_PS_DISABLED;
-	else {
-		printf("Invalid parameter: %s\n", argv[0]);
-		return 2;
+	else
+		goto invalid_parameters;
+
+	if (argc == 3) {
+		if (ps_state != NL80211_PS_ENABLED)
+			goto invalid_parameters;
+		if (strcmp(argv[1], "timeout") != 0)
+			goto invalid_parameters;
+		timeout = (int) strtol(argv[2], &endp, 10);
+		if (endp == argv[2] || (timeout <= 0 && timeout != -1))
+			goto invalid_parameters;
+
+		NLA_PUT_U32(msg, NL80211_ATTR_PS_TIMEOUT, timeout);
 	}
 
 	NLA_PUT_U32(msg, NL80211_ATTR_PS_STATE, ps_state);
@@ -36,9 +46,13 @@ static int set_power_save(struct nl80211_state *state,
 
  nla_put_failure:
 	return -ENOBUFS;
+
+ invalid_parameters:
+	printf("Invalid parameters!\n");
+	return 2;
 }
 
-COMMAND(set, power_save, "<on|off>",
+COMMAND(set, power_save, "<on [timeout <value>] | off>",
 	NL80211_CMD_SET_POWER_SAVE, 0, CIB_NETDEV, set_power_save,
 	"Set power save state to on or off.");
 
@@ -47,6 +61,7 @@ static int print_power_save_handler(struct nl_msg *msg, void *arg)
 	struct nlattr *attrs[NL80211_ATTR_MAX + 1];
 	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
 	const char *s;
+	int timeout = -1;
 
 	nla_parse(attrs, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
@@ -57,6 +72,8 @@ static int print_power_save_handler(struct nl_msg *msg, void *arg)
 	switch (nla_get_u32(attrs[NL80211_ATTR_PS_STATE])) {
 	case NL80211_PS_ENABLED:
 		s = "on";
+		if (attrs[NL80211_ATTR_PS_TIMEOUT])
+			timeout = nla_get_u32(attrs[NL80211_ATTR_PS_TIMEOUT]);
 		break;
 	case NL80211_PS_DISABLED:
 	default:
@@ -64,7 +81,10 @@ static int print_power_save_handler(struct nl_msg *msg, void *arg)
 		break;
 	}
 
-	printf("Power save: %s\n", s);
+	if (timeout > 0)
+		printf("Power save: on, timeout %d ms\n", timeout);
+	else
+		printf("Power save: %s\n", s);
 
 	return NL_SKIP;
 }
-- 
1.8.3.1

