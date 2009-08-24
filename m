Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:49369 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbZHXJR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 05:17:59 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [IW] don't emit usage to stderr
Date: Mon, 24 Aug 2009 11:17:19 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200908241117.19840.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only write error output to stderr, not help und usage information.
This allows now

  ./iw | less


Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: iw/iw.c
===================================================================
--- iw.orig/iw.c	2009-08-24 10:00:08.000000000 +0200
+++ iw/iw.c	2009-08-24 10:01:08.000000000 +0200
@@ -103,24 +103,24 @@ static void __usage_cmd(struct cmd *cmd,
 {
 	const char *start, *lend, *end;
 
-	fprintf(stderr, "%s", indent);
+	printf("%s", indent);
 
 	switch (cmd->idby) {
 	case CIB_NONE:
 		break;
 	case CIB_PHY:
-		fprintf(stderr, "phy <phyname> ");
+		printf("phy <phyname> ");
 		break;
 	case CIB_NETDEV:
-		fprintf(stderr, "dev <devname> ");
+		printf("dev <devname> ");
 		break;
 	}
 	if (cmd->section)
-		fprintf(stderr, "%s ", cmd->section);
-	fprintf(stderr, "%s", cmd->name);
+		printf("%s ", cmd->section);
+	printf("%s", cmd->name);
 	if (cmd->args)
-		fprintf(stderr, " %s", cmd->args);
-	fprintf(stderr, "\n");
+		printf(" %s", cmd->args);
+	printf("\n");
 
 	if (!full || !cmd->help)
 		return;
@@ -129,7 +129,7 @@ static void __usage_cmd(struct cmd *cmd,
 	if (strlen(indent))
 		indent = "\t\t";
 	else
-		fprintf(stderr, "\n");
+		printf("\n");
 
 	/* print line by line */
 	start = cmd->help;
@@ -138,18 +138,18 @@ static void __usage_cmd(struct cmd *cmd,
 		lend = strchr(start, '\n');
 		if (!lend)
 			lend = end;
-		fprintf(stderr, "%s", indent);
-		fprintf(stderr, "%.*s\n", (int)(lend - start), start);
+		printf("%s", indent);
+		printf("%.*s\n", (int)(lend - start), start);
 		start = lend + 1;
 	} while (end != lend);
 
-	fprintf(stderr, "\n");
+	printf("\n");
 }
 
 static void usage_options(void)
 {
-	fprintf(stderr, "Options:\n");
-	fprintf(stderr, "\t--debug\t\tenable netlink debugging\n");
+	printf("Options:\n");
+	printf("\t--debug\t\tenable netlink debugging\n");
 }
 
 static const char *argv0;
@@ -158,17 +158,17 @@ static void usage(bool full)
 {
 	struct cmd *cmd;
 
-	fprintf(stderr, "Usage:\t%s [options] command\n", argv0);
+	printf("Usage:\t%s [options] command\n", argv0);
 	usage_options();
-	fprintf(stderr, "\t--version\tshow version (%s)\n", iw_version);
-	fprintf(stderr, "Commands:\n");
+	printf("\t--version\tshow version (%s)\n", iw_version);
+	printf("Commands:\n");
 	for (cmd = &__start___cmd; cmd < &__stop___cmd;
 	     cmd = (struct cmd *)((char *)cmd + cmd_size)) {
 		if (!cmd->handler || cmd->hidden)
 			continue;
 		__usage_cmd(cmd, "\t", full);
 	}
-	fprintf(stderr, "\nYou can omit the 'phy' or 'dev' if "
+	printf("\nYou can omit the 'phy' or 'dev' if "
 			"the identification is unique,\n"
 			"e.g. \"iw wlan0 info\" or \"iw phy0 info\". "
 			"(Don't when scripting.)\n\n"
@@ -188,7 +188,7 @@ TOPLEVEL(help, NULL, 0, 0, CIB_NONE, pri
 
 static void usage_cmd(struct cmd *cmd)
 {
-	fprintf(stderr, "Usage:\t%s [options] ", argv0);
+	printf("Usage:\t%s [options] ", argv0);
 	__usage_cmd(cmd, "", true);
 	usage_options();
 }

-- 
http://www.holgerschurig.de
