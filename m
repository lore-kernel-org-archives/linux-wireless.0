Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbbGQQSY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:18:24 -0400
Subject: [PATCH 17/27] ASN.1: Add an ASN.1 compiler option to dump the
 element tree
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:18:18 +0100
Message-ID: <20150717161818.2578.76526.stgit@warthog.procyon.org.uk> (sfid-20150717_182215_928593_D5D75226)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add an ASN.1 compiler option to dump the element tree to stdout.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-By: David Woodhouse <David.Woodhouse@intel.com>
---

 scripts/asn1_compiler.c |   86 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 74 insertions(+), 12 deletions(-)

diff --git a/scripts/asn1_compiler.c b/scripts/asn1_compiler.c
index 7750e9c31483..866f85e5fdd2 100644
--- a/scripts/asn1_compiler.c
+++ b/scripts/asn1_compiler.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdint.h>
+#include <stdbool.h>
 #include <string.h>
 #include <ctype.h>
 #include <unistd.h>
@@ -311,9 +312,11 @@ struct token {
 
 static struct token *token_list;
 static unsigned nr_tokens;
-static _Bool verbose;
+static bool verbose_opt;
+static bool debug_opt;
 
-#define debug(fmt, ...) do { if (verbose) printf(fmt, ## __VA_ARGS__); } while (0)
+#define verbose(fmt, ...) do { if (verbose_opt) printf(fmt, ## __VA_ARGS__); } while (0)
+#define debug(fmt, ...) do { if (debug_opt) printf(fmt, ## __VA_ARGS__); } while (0)
 
 static int directive_compare(const void *_key, const void *_pdir)
 {
@@ -518,7 +521,7 @@ static void tokenise(char *buffer, char *end)
 	}
 
 	nr_tokens = tix;
-	debug("Extracted %u tokens\n", nr_tokens);
+	verbose("Extracted %u tokens\n", nr_tokens);
 
 #if 0
 	{
@@ -534,6 +537,7 @@ static void tokenise(char *buffer, char *end)
 
 static void build_type_list(void);
 static void parse(void);
+static void dump_elements(void);
 static void render(FILE *out, FILE *hdr);
 
 /*
@@ -548,16 +552,27 @@ int main(int argc, char **argv)
 	char *kbuild_verbose;
 	int fd;
 
+	kbuild_verbose = getenv("KBUILD_VERBOSE");
+	if (kbuild_verbose)
+		verbose_opt = atoi(kbuild_verbose);
+
+	while (argc > 4) {
+		if (strcmp(argv[1], "-v") == 0)
+			verbose_opt = true;
+		else if (strcmp(argv[1], "-d") == 0)
+			debug_opt = true;
+		else
+			break;
+		memmove(&argv[1], &argv[2], (argc - 2) * sizeof(char *));
+		argc--;
+	}
+
 	if (argc != 4) {
-		fprintf(stderr, "Format: %s <grammar-file> <c-file> <hdr-file>\n",
+		fprintf(stderr, "Format: %s [-v] [-d] <grammar-file> <c-file> <hdr-file>\n",
 			argv[0]);
 		exit(2);
 	}
 
-	kbuild_verbose = getenv("KBUILD_VERBOSE");
-	if (kbuild_verbose)
-		verbose = atoi(kbuild_verbose);
-
 	filename = argv[1];
 	outputname = argv[2];
 	headername = argv[3];
@@ -608,6 +623,7 @@ int main(int argc, char **argv)
 	tokenise(buffer, buffer + readlen);
 	build_type_list();
 	parse();
+	dump_elements();
 
 	out = fopen(outputname, "w");
 	if (!out) {
@@ -756,7 +772,7 @@ static void build_type_list(void)
 
 	qsort(type_index, nr, sizeof(type_index[0]), type_index_compare);
 
-	debug("Extracted %u types\n", nr_types);
+	verbose("Extracted %u types\n", nr_types);
 #if 0
 	for (n = 0; n < nr_types; n++) {
 		struct type *type = type_index[n];
@@ -801,7 +817,7 @@ static void parse(void)
 
 	} while (type++, !(type->flags & TYPE_STOP_MARKER));
 
-	debug("Extracted %u actions\n", nr_actions);
+	verbose("Extracted %u actions\n", nr_actions);
 }
 
 static struct element *element_list;
@@ -1191,6 +1207,52 @@ overrun_error:
 	exit(1);
 }
 
+static void dump_element(const struct element *e, int level)
+{
+	const struct element *c;
+	const struct type *t = e->type_def;
+	const char *name = e->name ? e->name->value : ".";
+	int nsize = e->name ? e->name->size : 1;
+	const char *tname = t && t->name ? t->name->value : ".";
+	int tnsize = t && t->name ? t->name->size : 1;
+	char tag[32];
+
+	if (e->class == 0 && e->method == 0 && e->tag == 0)
+		strcpy(tag, "<...>");
+	else if (e->class == ASN1_UNIV)
+		sprintf(tag, "%s %s %s",
+			asn1_classes[e->class],
+			asn1_methods[e->method],
+			asn1_universal_tags[e->tag]);
+	else
+		sprintf(tag, "%s %s %u",
+			asn1_classes[e->class],
+			asn1_methods[e->method],
+			e->tag);
+
+	printf("%c%c%c%c %c %*s[*] \e[33m%s\e[m %*.*s %*.*s\n",
+	       e->flags & ELEMENT_IMPLICIT ? 'I' : '-',
+	       e->flags & ELEMENT_EXPLICIT ? 'E' : '-',
+	       e->flags & ELEMENT_SKIPPABLE ? 'S' : '-',
+	       e->flags & ELEMENT_CONDITIONAL ? 'C' : '-',
+	       "-tTqQcato"[e->compound],
+	       level, "",
+	       tag,
+	       tnsize, tnsize, tname,
+	       nsize, nsize, name);
+	if (e->compound == TYPE_REF)
+		dump_element(e->type->type->element, level + 3);
+	else
+		for (c = e->children; c; c = c->next)
+			dump_element(c, level + 3);
+}
+
+static void dump_elements(void)
+{
+	if (debug_opt)
+		dump_element(type_list[0].element, 0);
+}
+
 static void render_element(FILE *out, struct element *e, struct element *tag);
 static void render_out_of_line_list(FILE *out);
 
@@ -1292,7 +1354,7 @@ static void render(FILE *out, FILE *hdr)
 	}
 
 	/* We do two passes - the first one calculates all the offsets */
-	debug("Pass 1\n");
+	verbose("Pass 1\n");
 	nr_entries = 0;
 	root = &type_list[0];
 	render_element(NULL, root->element, NULL);
@@ -1303,7 +1365,7 @@ static void render(FILE *out, FILE *hdr)
 		e->flags &= ~ELEMENT_RENDERED;
 
 	/* And then we actually render */
-	debug("Pass 2\n");
+	verbose("Pass 2\n");
 	fprintf(out, "\n");
 	fprintf(out, "static const unsigned char %s_machine[] = {\n",
 		grammar_name);

