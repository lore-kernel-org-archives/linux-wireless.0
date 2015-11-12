Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51213 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbbKLIsB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 03:48:01 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Michal Marek <mmarek@suse.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v4 6/8] kconfig: introduce "count"
Date: Thu, 12 Nov 2015 09:47:51 +0100
Message-Id: <1447318073-22669-7-git-send-email-johannes@sipsolutions.net> (sfid-20151112_094815_259259_E186BC17)
In-Reply-To: <1447318073-22669-1-git-send-email-johannes@sipsolutions.net>
References: <1447318073-22669-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

"count" works similar to "select"; take, for example, this snippet:

    config MY_COUNTER
            int

    config MY_DRIVER_1
            bool "my driver 1"
            count MY_COUNTER

    config MY_DRIVER_2
            bool "my driver 2"
            count MY_COUNTER

This will get MY_COUNTER to have a value of 0, 1 or 2, depending
on whether or not MY_DRIVER_1/MY_DRIVER_2 are not at all, one or
both selected respectively.

This can be useful for certain optimization purposes but I'm sure
people will come up with other creative usage.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/kbuild/kconfig-language.txt |  7 +++++++
 scripts/kconfig/expr.h                    |  1 +
 scripts/kconfig/menu.c                    | 28 +++++++++++++++++++++++++++-
 scripts/kconfig/symbol.c                  | 30 +++++++++++++++++++++++++++++-
 scripts/kconfig/zconf.gperf               |  1 +
 scripts/kconfig/zconf.y                   | 16 ++++++++++++++--
 6 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index 350f733bf2c7..cee587254d3b 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -113,6 +113,13 @@ applicable everywhere (see syntax).
 	That will limit the usefulness but on the other hand avoid
 	the illegal configurations all over.
 
+- counting: "count" <symbol> ["if" <expr>]
+  If, for some reason, it is desired to understand the number of times a
+  given symbol is selected, that can be achieved by using "count" instead
+  of select. The <symbol> must be an int, and the default value is added
+  to the count.
+  A lot of the caveats for "select" apply here since it's very similar.
+
 - limiting menu display: "visible if" <expr>
   This attribute is only applicable to menu blocks, if the condition is
   false, the menu block is not displayed to the user (the symbols
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 973b6f733368..c77c8c30dd52 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -139,6 +139,7 @@ enum prop_type {
 	P_RANGE,    /* range 7..100 (for a symbol) */
 	P_ENV,      /* value from environment variable */
 	P_SYMBOL,   /* where a symbol is defined */
+	P_COUNT,    /* count BAR - increments BAR counter */
 };
 
 struct property {
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index b05cc3d4a9be..0f7ef400741a 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -265,6 +265,18 @@ static void sym_check_prop(struct symbol *sym)
 				    "accept arguments of boolean and "
 				    "tristate type", sym2->name);
 			break;
+		case P_COUNT:
+			sym2 = prop_get_symbol(prop);
+			if (sym->type != S_BOOLEAN && sym->type != S_TRISTATE)
+				prop_warn(prop,
+				    "config symbol '%s' uses select, but is "
+				    "not boolean or tristate", sym->name);
+			else if (sym2->type != S_INT)
+				prop_warn(prop,
+				    "'%s' has wrong type. 'count' only "
+				    "accept arguments of int type",
+				    sym2->name);
+			break;
 		case P_RANGE:
 			if (sym->type != S_INT && sym->type != S_HEX)
 				prop_warn(prop, "range is only allowed "
@@ -333,6 +345,9 @@ void menu_finalize(struct menu *parent)
 					struct symbol *es = prop_get_symbol(prop);
 					es->rev_dep.expr = expr_alloc_or(es->rev_dep.expr,
 							expr_alloc_and(expr_alloc_symbol(menu->sym), expr_copy(dep)));
+				} else if (prop->type == P_COUNT) {
+					struct symbol *es = prop_get_symbol(prop);
+					es->rev_dep.expr = expr_alloc_or(es->rev_dep.expr, expr_alloc_symbol(menu->sym));
 				}
 			}
 		}
@@ -657,10 +672,21 @@ static void get_symbol_str(struct gstr *r, struct symbol *sym,
 			str_printf(r, " && ");
 		expr_gstr_print(prop->expr, r);
 	}
+	for_all_properties(sym, prop, P_COUNT) {
+		if (!hit) {
+			str_append(r, "  Counts: ");
+			hit = true;
+		} else
+			str_printf(r, " && ");
+		expr_gstr_print(prop->expr, r);
+	}
 	if (hit)
 		str_append(r, "\n");
 	if (sym->rev_dep.expr) {
-		str_append(r, _("  Selected by: "));
+		if (sym->type != S_INT)
+			str_append(r, _("  Selected by: "));
+		else
+			str_append(r, _("  Counted by: "));
 		expr_gstr_print(sym->rev_dep.expr, r);
 		str_append(r, "\n");
 	}
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 50878dc025a5..c50835f28243 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -310,6 +310,21 @@ static struct symbol *sym_calc_choice(struct symbol *sym)
 	return def_sym;
 }
 
+static unsigned long long count_or_symbols(struct expr *e)
+{
+	switch (e->type) {
+	case E_SYMBOL:
+		sym_calc_value(e->left.sym);
+		return e->left.sym->curr.tri != no;
+	case E_OR:
+		return count_or_symbols(e->left.expr) +
+		       count_or_symbols(e->right.expr);
+	default:
+		fprintf(stderr, "warning: unexpected expression in count");
+		return 0;
+	}
+}
+
 void sym_calc_value(struct symbol *sym)
 {
 	struct symbol_value newval, oldval;
@@ -421,6 +436,15 @@ void sym_calc_value(struct symbol *sym)
 				newval.val = ds->curr.val;
 			}
 		}
+		if (sym->rev_dep.expr) {
+			long long val = strtoll(newval.val, NULL, 0);
+			char *buf = xmalloc(22);
+
+			val += count_or_symbols(sym->rev_dep.expr);
+			sprintf(buf, "%lld", val);
+			newval.val = buf;
+			sym->flags |= SYMBOL_WRITE;
+		}
 		break;
 	default:
 		;
@@ -1197,7 +1221,9 @@ static struct symbol *sym_check_sym_deps(struct symbol *sym)
 		goto out;
 
 	for (prop = sym->prop; prop; prop = prop->next) {
-		if (prop->type == P_CHOICE || prop->type == P_SELECT)
+		if (prop->type == P_CHOICE ||
+		    prop->type == P_SELECT ||
+		    prop->type == P_COUNT)
 			continue;
 		stack.prop = prop;
 		sym2 = sym_check_expr_deps(prop->visible.expr);
@@ -1336,6 +1362,8 @@ const char *prop_get_type_name(enum prop_type type)
 		return "choice";
 	case P_SELECT:
 		return "select";
+	case P_COUNT:
+		return "count";
 	case P_RANGE:
 		return "range";
 	case P_SYMBOL:
diff --git a/scripts/kconfig/zconf.gperf b/scripts/kconfig/zconf.gperf
index ac498f01b449..46ce5833887e 100644
--- a/scripts/kconfig/zconf.gperf
+++ b/scripts/kconfig/zconf.gperf
@@ -46,4 +46,5 @@ modules,	T_OPT_MODULES,	TF_OPTION
 defconfig_list,	T_OPT_DEFCONFIG_LIST,TF_OPTION
 env,		T_OPT_ENV,	TF_OPTION
 allnoconfig_y,	T_OPT_ALLNOCONFIG_Y,TF_OPTION
+count,		T_COUNT,	TF_COMMAND
 %%
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index 71bf8bff696a..18c43561860b 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -31,7 +31,7 @@ struct symbol *symbol_hash[SYMBOL_HASHSIZE];
 static struct menu *current_menu, *current_entry;
 
 %}
-%expect 30
+%expect 32
 
 %union
 {
@@ -76,6 +76,7 @@ static struct menu *current_menu, *current_entry;
 %token T_CLOSE_PAREN
 %token T_OPEN_PAREN
 %token T_EOL
+%token <id>T_COUNT
 
 %left T_OR
 %left T_AND
@@ -124,7 +125,7 @@ stmt_list:
 ;
 
 option_name:
-	T_DEPENDS | T_PROMPT | T_TYPE | T_SELECT | T_OPTIONAL | T_RANGE | T_DEFAULT | T_VISIBLE
+	T_DEPENDS | T_PROMPT | T_TYPE | T_SELECT | T_COUNT | T_OPTIONAL | T_RANGE | T_DEFAULT | T_VISIBLE
 ;
 
 common_stmt:
@@ -216,6 +217,12 @@ config_option: T_SELECT T_WORD if_expr T_EOL
 	printd(DEBUG_PARSE, "%s:%d:select\n", zconf_curname(), zconf_lineno());
 };
 
+config_option: T_COUNT T_WORD if_expr T_EOL
+{
+	menu_add_symbol(P_COUNT, sym_lookup($2, 0), $3);
+	printd(DEBUG_PARSE, "%s:%d:count\n", zconf_curname(), zconf_lineno());
+};
+
 config_option: T_RANGE symbol symbol if_expr T_EOL
 {
 	menu_add_expr(P_RANGE, expr_alloc_comp(E_RANGE,$2, $3), $4);
@@ -664,6 +671,11 @@ static void print_symbol(FILE *out, struct menu *menu)
 			expr_fprint(prop->expr, out);
 			fputc('\n', out);
 			break;
+		case P_COUNT:
+			fputs( "  count ", out);
+			expr_fprint(prop->expr, out);
+			fputc('\n', out);
+			break;
 		case P_RANGE:
 			fputs( "  range ", out);
 			expr_fprint(prop->expr, out);
-- 
2.6.2

