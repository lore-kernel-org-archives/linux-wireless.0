Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60569 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYIPVjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 17:39:53 -0400
Subject: Re: iw packaging
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221600232.17084.16.camel@dv>
References: <1221596962.9262.12.camel@johannes.berg>
	 <1221598208.17084.11.camel@dv>  <1221599460.9262.16.camel@johannes.berg>
	 (sfid-20080916_231152_167035_625A9793)  <1221599757.9262.19.camel@johannes.berg>
	 <1221600232.17084.16.camel@dv>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 23:38:56 +0200
Message-Id: <1221601136.9262.23.camel@johannes.berg> (sfid-20080916_233956_465379_218EFD2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-09-16 at 17:23 -0400, Pavel Roskin wrote:
> On Tue, 2008-09-16 at 23:15 +0200, Johannes Berg wrote:
> > On Tue, 2008-09-16 at 23:11 +0200, Johannes Berg wrote:
> > 
> > > > 83              for (cmd = &__start___cmd; cmd < &__stop___cmd; cmd++) {
> > > > (gdb) p __start___cmd
> > > > $1 = {section = 0x0, name = 0x403d02 "info", args = 0x0, cmd = NL80211_CMD_GET_WIPHY, 
> > > >   nl_msg_flags = 0, idby = CIB_PHY, handler = 0x402403 <handle_info>}
> > > > (gdb) p *(&__start___cmd + 1)
> > > > $2 = {section = 0x0, name = 0x0, args = 0x0, cmd = 4209927, nl_msg_flags = 0, idby = CIB_NONE, 
> > > >   handler = 0x30000000001}
> > > > (gdb)
> > > > 
> > > > That means, __start___cmd points to "info".  The next command has no
> > > > name (and appears to be a complete mess).  The clever section trick
> > > > doesn't seem to work properly.
> > 
> > Hmm. can you send the output of
> > 
> > nm iw | grep __cmd
> 
> I recompiled iw with optimization, so the addresses may be different.

Oh I'm on powerpc anyway :)

> 0000000000403d40 r __cmd_handle_infoNL80211_CMD_GET_WIPHYCIB_NONE
> 0000000000403d80 r __cmd_handle_infoNL80211_CMD_GET_WIPHYCIB_PHY

Ok that looks fine.

I think what may be happening is that alignment is somehow messing
things up. Can you please try the patch below?

johannes

diff --git a/iw.c b/iw.c
index 672c516..14bb2d1 100644
--- a/iw.c
+++ b/iw.c
@@ -74,13 +74,19 @@ static void nl80211_cleanup(struct nl80211_state *state)
 static void usage(const char *argv0)
 {
 	struct cmd *cmd;
+	int i = 0;
 
 	fprintf(stderr, "Usage:\t%s [options] command\n", argv0);
 	fprintf(stderr, "Options:\n");
 	fprintf(stderr, "\t--debug\t\tenable netlink debugging\n");
 	fprintf(stderr, "\t--version\tshow version\n");
 	fprintf(stderr, "Commands:\n");
-	for (cmd = &__start___cmd; cmd < &__stop___cmd; cmd++) {
+
+	do {
+		cmd = &__start___cmd[i];
+		i++;
+		if (cmd >= &__stop___cmd)
+			break;
 		switch (cmd->idby) {
 		case CIB_NONE:
 			fprintf(stderr, "\t");
@@ -100,7 +106,7 @@ static void usage(const char *argv0)
 			fprintf(stderr, "\n");
 			break;
 		}
-	}
+	} while (1);
 }
 
 static void version(void)
@@ -151,7 +157,7 @@ static int handle_cmd(struct nl80211_state *state,
 	struct nl_cb *cb = NULL;
 	struct nl_msg *msg;
 	int devidx = 0;
-	int err;
+	int err, i = 0;
 	const char *command, *section;
 
 	if (argc <= 1 && idby != CIB_NONE)
@@ -176,7 +182,11 @@ static int handle_cmd(struct nl80211_state *state,
 	argc--;
 	argv++;
 
-	for (cmd = &__start___cmd; cmd < &__stop___cmd; cmd++) {
+	do {
+		cmd = &__start___cmd[i];
+		i++;
+		if (cmd >= &__stop___cmd)
+			break;
 		if (cmd->idby != idby)
 			continue;
 		if (cmd->section) {
@@ -197,7 +207,7 @@ static int handle_cmd(struct nl80211_state *state,
 		if (argc && !cmd->args)
 			continue;
 		break;
-	}
+	} while (1);
 
 	if (cmd == &__stop___cmd)
 		return 1;
diff --git a/iw.h b/iw.h
index c9d9052..71db6b9 100644
--- a/iw.h
+++ b/iw.h
@@ -45,7 +45,7 @@ struct cmd {
 	__COMMAND(#section, #name, args, cmd, flags, idby, handler)
 #define TOPLEVEL(name, args, cmd, flags, idby, handler)		\
 	__COMMAND(NULL, #name, args, cmd, flags, idby, handler)
-extern struct cmd __start___cmd;
+extern struct cmd __start___cmd[];
 extern struct cmd __stop___cmd;
 
 int mac_addr_a2n(unsigned char *mac_addr, char *arg);


