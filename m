Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYIPWPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 18:15:08 -0400
Subject: Re: iw packaging
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221602164.9262.28.camel@johannes.berg> (sfid-20080916_235712_566446_6F909BE5)
References: <1221596962.9262.12.camel@johannes.berg>
	 <1221598208.17084.11.camel@dv>  <1221599460.9262.16.camel@johannes.berg>
	 (sfid-20080916_231152_167035_625A9793)  <1221599757.9262.19.camel@johannes.berg>
	 <1221600232.17084.16.camel@dv>  <1221601136.9262.23.camel@johannes.berg>
	 <1221601739.17084.22.camel@dv>  <1221602164.9262.28.camel@johannes.berg>
	 (sfid-20080916_235712_566446_6F909BE5)
Content-Type: text/plain
Date: Wed, 17 Sep 2008 00:14:18 +0200
Message-Id: <1221603258.9262.30.camel@johannes.berg> (sfid-20080917_001513_373757_C735D46A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-09-16 at 23:56 +0200, Johannes Berg wrote:
> On Tue, 2008-09-16 at 17:48 -0400, Pavel Roskin wrote:
> 
> > $ nm iw | grep __cmd |sort
> > 0000000000403d20 A __start___cmd
> > 0000000000403d20 r __cmd_handle_infoNL80211_CMD_GET_WIPHYCIB_NONE
> > 0000000000403d60 r __cmd_handle_infoNL80211_CMD_GET_WIPHYCIB_PHY
> > 0000000000403da0 r __cmd_handle_nameNL80211_CMD_SET_WIPHYCIB_PHY
> > ...
> > 
> > The next command is at 0x403d60, but the code expects it at 0x403d50.
> 
> I suspected as much, but right now I don't know how to fix that. I'd
> have thought the rules here would be just like in an array but clearly I
> was wrong.

My brother suggested this workaround, can you try? Works here.

diff --git a/iw.c b/iw.c
index 672c516..bba3e6f 100644
--- a/iw.c
+++ b/iw.c
@@ -71,6 +71,11 @@ static void nl80211_cleanup(struct nl80211_state *state)
 	nl_handle_destroy(state->nl_handle);
 }
 
+__COMMAND(NULL, NULL, NULL, 0, 0, CIB_NONE, NULL);
+__COMMAND(NULL, NULL, NULL, 1, 0, CIB_NONE, NULL);
+
+static int cmd_size;
+
 static void usage(const char *argv0)
 {
 	struct cmd *cmd;
@@ -80,7 +85,10 @@ static void usage(const char *argv0)
 	fprintf(stderr, "\t--debug\t\tenable netlink debugging\n");
 	fprintf(stderr, "\t--version\tshow version\n");
 	fprintf(stderr, "Commands:\n");
-	for (cmd = &__start___cmd; cmd < &__stop___cmd; cmd++) {
+	for (cmd = &__start___cmd; cmd < &__stop___cmd;
+	     cmd = (struct cmd *)((char *)cmd + cmd_size)) {
+		if (!cmd->handler)
+			continue;
 		switch (cmd->idby) {
 		case CIB_NONE:
 			fprintf(stderr, "\t");
@@ -176,7 +184,10 @@ static int handle_cmd(struct nl80211_state *state,
 	argc--;
 	argv++;
 
-	for (cmd = &__start___cmd; cmd < &__stop___cmd; cmd++) {
+	for (cmd = &__start___cmd; cmd < &__stop___cmd;
+	     cmd = (struct cmd *)((char *)cmd + cmd_size)) {
+		if (!cmd->handler)
+			continue;
 		if (cmd->idby != idby)
 			continue;
 		if (cmd->section) {
@@ -258,6 +269,7 @@ int main(int argc, char **argv)
 	int err;
 	const char *argv0;
 
+	cmd_size = abs((long)&__cmd_NULL1CIB_NONE - (long)&__cmd_NULL0CIB_NONE);
 	/* strip off self */
 	argc--;
 	argv0 = *argv++;


