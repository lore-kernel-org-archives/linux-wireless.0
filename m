Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42927 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbaFJH0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 03:26:23 -0400
Received: by mail-wi0-f174.google.com with SMTP id r20so5528723wiv.13
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 00:26:21 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: wireless-regdb@lists.infradead.org
Cc: mcgrof@do-not-panic.com, linville@tuxdriver.com,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 2/2] crda: add crda_tiny implementation
Date: Tue, 10 Jun 2014 09:25:53 +0200
Message-Id: <1402385153-5056-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140610_092646_912551_C7CF15B9)
In-Reply-To: <1402385153-5056-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1402385153-5056-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add crda_tiny and crda.sh implementation.
This implementation base on db.txt file
signed via PGP. Next crda.sh do db.txt veryfication.
crda_tiny as a input get regulatory domain
in text format, parse this and send using
nl80211 to the kernel.
This implementation skip regulatory.bin file and
works directly on signed db.txt file.

Added gpg directory with db_signed.txt file and public key
required for veryfication.

crda.sh require installed gpg.

To test just run:
- make && make install
- sh gpg/install.sh
- cp /sbin/crda.sh /sbin/crda (or change udev rule)

All logs will be available in /tmp/crda.err file

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 Makefile              |   14 +-
 README                |   20 ++
 crda.sh               |   41 +++
 crda_tiny.c           |  272 ++++++++++++++++
 gpg/db_signed.txt     |  859 +++++++++++++++++++++++++++++++++++++++++++++++++
 gpg/install.sh        |    6 +
 gpg/regdb_pubring.gpg |  Bin 0 -> 1193 bytes
 reglib.h              |    1 +
 8 files changed, 1211 insertions(+), 2 deletions(-)
 create mode 100755 crda.sh
 create mode 100644 crda_tiny.c
 create mode 100644 gpg/db_signed.txt
 create mode 100755 gpg/install.sh
 create mode 100644 gpg/regdb_pubring.gpg

diff --git a/Makefile b/Makefile
index 1f25509..2e65d78 100644
--- a/Makefile
+++ b/Makefile
@@ -36,7 +36,7 @@ LDFLAGS += -L ./
 
 all: all_noverify verify
 
-all_noverify: $(LIBREG) crda intersect regdbdump db2rd optimize
+all_noverify: $(LIBREG) crda intersect regdbdump db2rd optimize crda_tiny
 
 ifeq ($(USE_OPENSSL),1)
 CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\" `pkg-config --cflags openssl`
@@ -153,6 +153,10 @@ optimize: optimize.o
 	$(NQ) '  LD  ' $@
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
 
+crda_tiny: crda_tiny.o
+	$(NQ) '  LD  ' $@
+	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS) $(NLLIBS)
+
 verify: $(REG_BIN) regdbdump
 	$(NQ) '  CHK  $(REG_BIN)'
 	$(Q)\
@@ -163,10 +167,16 @@ verify: $(REG_BIN) regdbdump
 	@$(NQ) ' GZIP' $<
 	$(Q)gzip < $< > $@
 
-install: install-libreg install-libreg-headers crda crda.8.gz regdbdump.8.gz
+install: install-libreg install-libreg-headers crda crda_tiny crda.8.gz regdbdump.8.gz
 	$(NQ) '  INSTALL  crda'
 	$(Q)$(MKDIR) $(DESTDIR)/$(SBINDIR)
 	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)/$(SBINDIR) crda
+	$(NQ) '  INSTALL  crda.sh'
+	$(Q)$(MKDIR) $(DESTDIR)/$(SBINDIR)
+	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)/$(SBINDIR) crda.sh
+	$(NQ) '  INSTALL  crda_tiny'
+	$(Q)$(MKDIR) $(DESTDIR)/$(SBINDIR)
+	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)/$(SBINDIR) crda_tiny
 	$(NQ) '  INSTALL  regdbdump'
 	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)/$(SBINDIR) regdbdump
 	$(NQ) '  INSTALL  $(UDEV_LEVEL)regulatory.rules'
diff --git a/README b/README
index f3ead48..3463638 100644
--- a/README
+++ b/README
@@ -94,3 +94,23 @@ database files:
 0	belong		0x52474442	CRDA regulatory database file
 >4	belong		19		(Version 1)
 ---- >% ----
+
+
+ SKIPING BINARY FORMAT, TEXT VERSION
+=====================================
+In case you will decide to use crda.sh and crda_tiny regulatory.bin
+file is not required. In such case signed db.txt (text) file will
+be used, and gpg tool to sign/verfiy db.txt.
+
+To generate key ring:
+	gpg --gen-key
+
+To sign db.txt file:
+	cat db.txt |gpg --clearsign --no-default-keyring --secret-keyring /path/to/regdb_secring.gpg > db_signed.txt
+
+To verify db.txt file:
+	gpg --no-default-keyring --keyring /path/to/regdb_pubring.gpg --verify db_signed.txt
+
+You will need to change udev rule to call crda.sh instead of crda.
+Check crda.sh script to get more details.
+Logs goes to /tmp/crda.err file.
diff --git a/crda.sh b/crda.sh
new file mode 100755
index 0000000..56fc091
--- /dev/null
+++ b/crda.sh
@@ -0,0 +1,41 @@
+#!/bin/sh
+PUBKEY=/usr/lib/crda/regdb_pubring.gpg
+REGDB=/usr/lib/crda/db_signed.txt
+CRDA_BIN=/sbin/crda_tiny
+LOG=/tmp/crda.err
+
+gpg_verify() {
+	PUBKEY=$1
+	REGDB=$2
+	gpg --no-default-keyring --keyring $PUBKEY --verify $REGDB
+}
+
+show_country() {
+	REGDB=$1
+	COUNTRY=$2
+
+	cat $REGDB \
+	| sed '
+		s/#.*//
+		s/^[ \t]*$//
+	' \
+	| awk \
+		-v ctry=$COUNTRY '
+
+		/country/{show=0}
+		/BEGIN PGP SIGNATURE/{show=0}
+		/country / && $2 == ctry ":" {show=1}
+		show && !/^$/
+	'
+}
+
+(
+	/bin/date
+	echo "$0 called with params:"
+	echo "COUNTRY: $COUNTRY"
+	echo "DB: $REGDB"
+	echo "PUBKEY: $PUBKEY"
+	echo "CRDA: $CRDA_BIN"
+
+	gpg_verify "$PUBKEY" "$REGDB" && show_country "$REGDB" "$COUNTRY" | "$CRDA_BIN"
+) >>$LOG 2>&1
diff --git a/crda_tiny.c b/crda_tiny.c
new file mode 100644
index 0000000..94c578e
--- /dev/null
+++ b/crda_tiny.c
@@ -0,0 +1,272 @@
+/*
+ * Central Regulatory Domain Agent for Linux
+ *
+ * Userspace helper which sends regulatory domains to Linux via nl80211
+ */
+
+#include <errno.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <arpa/inet.h>
+#include <unistd.h>
+
+#include <netlink/genl/genl.h>
+#include <netlink/genl/family.h>
+#include <netlink/genl/ctrl.h>
+#include <netlink/msg.h>
+#include <netlink/attr.h>
+#include "nl80211.h"
+
+#include "reglib.h"
+
+#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30) && !defined(CONFIG_LIBNL32)
+/* libnl 2.0 compatibility code */
+static inline struct nl_handle *nl_socket_alloc(void)
+{
+       return nl_handle_alloc();
+}
+
+static inline void nl_socket_free(struct nl_handle *h)
+{
+       nl_handle_destroy(h);
+}
+
+static inline int __genl_ctrl_alloc_cache(struct nl_handle *h, struct nl_cache **cache)
+{
+       struct nl_cache *tmp = genl_ctrl_alloc_cache(h);
+       if (!tmp)
+               return -ENOMEM;
+       *cache = tmp;
+       return 0;
+}
+
+#define genl_ctrl_alloc_cache __genl_ctrl_alloc_cache
+#define nl_sock nl_handle
+#endif /* CONFIG_LIBNL20 && CONFIG_LIBNL30 && CONFIG_LIBNL32 */
+
+struct nl80211_state {
+	struct nl_sock *nl_sock;
+	struct nl_cache *nl_cache;
+	struct genl_family *nl80211;
+};
+
+static int nl80211_init(struct nl80211_state *state)
+{
+	int err;
+
+	state->nl_sock = nl_socket_alloc();
+	if (!state->nl_sock) {
+		fprintf(stderr, "Failed to allocate netlink sock.\n");
+		return -ENOMEM;
+	}
+
+	if (genl_connect(state->nl_sock)) {
+		fprintf(stderr, "Failed to connect to generic netlink.\n");
+		err = -ENOLINK;
+		goto out_sock_destroy;
+	}
+
+	if (genl_ctrl_alloc_cache(state->nl_sock, &state->nl_cache)) {
+		fprintf(stderr, "Failed to allocate generic netlink cache.\n");
+		err = -ENOMEM;
+		goto out_sock_destroy;
+	}
+
+	state->nl80211 = genl_ctrl_search_by_name(state->nl_cache, "nl80211");
+	if (!state->nl80211) {
+		fprintf(stderr, "nl80211 not found.\n");
+		err = -ENOENT;
+		goto out_cache_free;
+	}
+
+	return 0;
+
+ out_cache_free:
+	nl_cache_free(state->nl_cache);
+ out_sock_destroy:
+	nl_socket_free(state->nl_sock);
+	return err;
+}
+
+static void nl80211_cleanup(struct nl80211_state *state)
+{
+	genl_family_put(state->nl80211);
+	nl_cache_free(state->nl_cache);
+	nl_socket_free(state->nl_sock);
+}
+
+static int reg_handler(struct nl_msg __attribute__((unused)) *msg,
+			void __attribute__((unused)) *arg)
+{
+	return NL_SKIP;
+}
+
+static int wait_handler(struct nl_msg __attribute__((unused)) *msg, void *arg)
+{
+	int *finished = arg;
+	*finished = 1;
+	return NL_STOP;
+}
+
+static int error_handler(struct sockaddr_nl __attribute__((unused)) *nla,
+			    struct nlmsgerr *err,
+			    void __attribute__((unused)) *arg)
+{
+	fprintf(stderr, "nl80211 error %d\n", err->error);
+	exit(err->error);
+}
+
+static int put_reg_rule(const struct ieee80211_reg_rule *rule, struct nl_msg *msg)
+{
+	const struct ieee80211_freq_range *freq_range;
+	const struct ieee80211_power_rule *power_rule;
+
+	freq_range = &rule->freq_range;
+	power_rule = &rule->power_rule;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_REG_RULE_FLAGS,		rule->flags);
+	NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_START,		freq_range->start_freq_khz);
+	NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_END,		freq_range->end_freq_khz);
+	NLA_PUT_U32(msg, NL80211_ATTR_FREQ_RANGE_MAX_BW,	freq_range->max_bandwidth_khz);
+	NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN,	power_rule->max_antenna_gain);
+	NLA_PUT_U32(msg, NL80211_ATTR_POWER_RULE_MAX_EIRP,	power_rule->max_eirp);
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+
+int
+main(int argc, char *argv[])
+{
+	int i = 0, j, r;
+	char alpha2[3];
+	char *env_country;
+	struct nl80211_state nlstate;
+	struct nl_cb *cb = NULL;
+	struct nl_msg *msg;
+	int finished = 0;
+	FILE *fp;
+
+	memset(alpha2, 0, 3);
+
+	struct nlattr *nl_reg_rules;
+	struct ieee80211_regdomain *rd;
+
+	env_country = getenv("COUNTRY");
+	if (!env_country) {
+		fprintf(stderr, "COUNTRY environment variable not set.\n");
+		return -EINVAL;
+	}
+
+	if (!reglib_is_valid_regdom(env_country)) {
+		fprintf(stderr, "COUNTRY environment variable must be an "
+			"ISO ISO 3166-1-alpha-2 (uppercase) or 00\n");
+		return -EINVAL;
+	}
+
+	fp = reglib_create_parse_stream(stdin);
+	if (!fp) {
+		fprintf(stderr, "parse stream failed\n");
+		return -EINVAL;
+	}
+
+	rd = __reglib_parse_country(fp);
+	if( !rd) {
+		fprintf(stderr, "__parse failed\n");
+		fclose(fp);
+		return -EINVAL;
+	}
+
+	fclose(fp);
+	memcpy(alpha2, env_country, 2);
+
+	/* Print regdom we get */
+	reglib_print_regdom(rd);
+
+	if (!reglib_is_valid_rd(rd)) {
+		fprintf(stderr, "WARNING - invalid regulatory\n");
+		/* Uncomment this after world regdb rules will be
+		 * fixed - best using AUTO-BW
+		 * For now just print warning.
+		 */
+	//	return -EINVAL;
+	}
+
+	/* Init nl80211 and pass regdom */
+	r = nl80211_init(&nlstate);
+	if (r) {
+		free(rd);
+		return -EIO;
+	}
+
+	msg = nlmsg_alloc();
+	if (!msg) {
+		fprintf(stderr, "Failed to allocate netlink message.\n");
+		r = -1;
+		goto out;
+	}
+
+	genlmsg_put(msg, 0, 0, genl_family_get_id(nlstate.nl80211), 0,
+		0, NL80211_CMD_SET_REG, 0);
+
+	NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2, alpha2);
+	NLA_PUT_U8(msg, NL80211_ATTR_DFS_REGION, rd->dfs_region);
+
+	nl_reg_rules = nla_nest_start(msg, NL80211_ATTR_REG_RULES);
+	if (!nl_reg_rules) {
+		r = -1;
+		goto nla_put_failure;
+	}
+
+	for (j = 0; j < rd->n_reg_rules; j++) {
+		struct nlattr *nl_reg_rule;
+		nl_reg_rule = nla_nest_start(msg, i);
+		if (!nl_reg_rule)
+			goto nla_put_failure;
+
+		r = put_reg_rule(&rd->reg_rules[j], msg);
+		if (r)
+			goto nla_put_failure;
+
+		nla_nest_end(msg, nl_reg_rule);
+	}
+
+	nla_nest_end(msg, nl_reg_rules);
+
+	cb = nl_cb_alloc(NL_CB_CUSTOM);
+	if (!cb)
+		goto cb_out;
+
+	r = nl_send_auto_complete(nlstate.nl_sock, msg);
+
+	if (r < 0) {
+		fprintf(stderr, "Failed to send regulatory request: %d\n", r);
+		goto cb_out;
+	}
+
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, reg_handler, NULL);
+	nl_cb_set(cb, NL_CB_ACK, NL_CB_CUSTOM, wait_handler, &finished);
+	nl_cb_err(cb, NL_CB_CUSTOM, error_handler, NULL);
+
+	if (!finished) {
+		r = nl_wait_for_ack(nlstate.nl_sock);
+		if (r < 0) {
+			fprintf(stderr, "Failed to set regulatory domain: "
+				"%d\n", r);
+			goto cb_out;
+		}
+	}
+
+cb_out:
+	nl_cb_put(cb);
+nla_put_failure:
+	nlmsg_free(msg);
+out:
+	nl80211_cleanup(&nlstate);
+	free(rd);
+
+	return r;
+}
diff --git a/gpg/db_signed.txt b/gpg/db_signed.txt
new file mode 100644
index 0000000..c0cda61
--- /dev/null
+++ b/gpg/db_signed.txt
@@ -0,0 +1,859 @@
+-----BEGIN PGP SIGNED MESSAGE-----
+Hash: SHA1
+
+# This is the world regulatory domain
+country 00:
+	(2402 - 2472 @ 40), (20)
+	# Channel 12 - 13.
+	(2457 - 2482 @ 40), (20), NO-IR
+	# Channel 14. Only JP enables this and for 802.11b only
+	(2474 - 2494 @ 20), (20), NO-IR
+	# Channel 36 - 48
+	(5170 - 5250 @ 80), (20), NO-IR
+	# NB: 5260 MHz - 5700 MHz requies DFS
+	# Channel 149 - 165
+	(5735 - 5835 @ 80), (20), NO-IR
+	# IEEE 802.11ad (60GHz), channels 1..3
+	(57240 - 63720 @ 2160), (0)
+
+
+country AD:
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country AE: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country AL: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20.00)
+	(5250 - 5330 @ 80), (20.00), DFS
+	(5490 - 5710 @ 80), (27.00), DFS
+
+country AM: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (18)
+	(5250 - 5330 @ 80), (18), DFS
+
+country AN: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+country AR: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country AT: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country AU:
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5710 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country AW: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+country AZ: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (18)
+	(5250 - 5330 @ 80), (18), DFS
+
+country BA: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country BB: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (23)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
+
+country BD: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5735 - 5835 @ 80), (30)
+
+country BE: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country BG: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country BH: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5735 - 5835 @ 80), (20)
+
+country BL:
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 40), (18)
+	(5250 - 5330 @ 40), (18), DFS
+
+country BN: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5735 - 5835 @ 80), (20)
+
+country BO: DFS-JP
+	(2402 - 2482 @ 40), (30)
+	(5735 - 5835 @ 80), (30)
+
+country BR: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country BY: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+country BZ: DFS-JP
+	(2402 - 2482 @ 40), (30)
+	(5735 - 5835 @ 80), (30)
+
+country CA: DFS-FCC
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country CH: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country CL: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5735 - 5835 @ 80), (20)
+
+country CN: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (23)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
+	# 60 gHz band channels 1,4: 28dBm, channels 2,3: 44dBm
+	# ref: http://www.miit.gov.cn/n11293472/n11505629/n11506593/n11960250/n11960606/n11960700/n12330791.files/n12330790.pdf
+	(57240 - 59400 @ 2160), (28)
+	(59400 - 63720 @ 2160), (44)
+	(63720 - 65880 @ 2160), (28)
+
+country CO: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country CR: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country CY: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+# Data from http://www.ctu.eu/164/download/VOR/VOR-12-08-2005-34.pdf
+# and http://www.ctu.eu/164/download/VOR/VOR-12-05-2007-6-AN.pdf
+# Power at 5250 - 5350 MHz and 5470 - 5725 MHz can be doubled if TPC is
+# implemented.
+country CZ: DFS-ETSI
+	(2400 - 2483.5 @ 40), (100 mW)
+	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR
+	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR
+	(5470 - 5725 @ 80), (500 mW), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+# Data from "Frequenznutzungsplan" (as published in April 2008), downloaded from
+# http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publicationFile/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
+# For the 5GHz range also see
+# http://www.bundesnetzagentur.de/cae/servlet/contentblob/38216/publicationFile/6579/WLAN5GHzVfg7_2010_28042010pdf.pdf
+# The values have been reduced by a factor of 2 (3db) for non TPC devices
+# (in other words: devices with TPC can use twice the tx power of this table).
+# Note that the docs do not require TPC for 5150--5250; the reduction to
+# 100mW thus is not strictly required -- however the conservative 100mW
+# limit is used here as the non-interference with radar and satellite
+# apps relies on the attenuation by the building walls only in the
+# absence of DFS; the neighbour countries have 100mW limit here as well.
+
+country DE: DFS-ETSI
+	# entries 279004 and 280006
+	(2400 - 2483.5 @ 40), (100 mW)
+	# entry 303005, 304002 and 305002
+	(5150 - 5350 @ 80), (100 mW), NO-OUTDOOR
+	# entries 308002, 309001 and 310003
+	(5470 - 5725 @ 80), (500 mW), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country DK: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country DO: DFS-FCC
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
+
+country DZ: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5170.000 - 5250.000 @ 80.000), (23.00)
+	(5250.000 - 5330.000 @ 80.000), (23.00), DFS
+	(5490.000 - 5670.000 @ 80.000), (23.00), DFS
+
+country EC: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country EE: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country EG: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+
+country ES: DFS-ETSI
+	(2400 - 2483.5 @ 40), (100 mW)
+	(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR
+	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR
+	(5470 - 5725 @ 80), (500 mW), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country FI: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country FR: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country GE: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (18)
+	(5250 - 5330 @ 80), (18), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country GB: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country GD: DFS-FCC
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country GR: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country GL: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+country GT: DFS-FCC
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
+
+country GU: DFS-FCC
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country HN: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country HK:
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5710 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country HR: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country HT: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+country HU: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country ID: DFS-JP
+	# ref: http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf
+	(2402 - 2482 @ 40), (20)
+	(5735 - 5815 @ 80), (23)
+
+country IE: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country IL: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5150 - 5350 @ 80), (200 mW), NO-OUTDOOR
+
+country IN: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5735 - 5835 @ 80), (20)
+
+country IS: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country IR: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5735 - 5835 @ 80), (30)
+
+country IT: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country JM: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country JP: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(2474 - 2494 @ 20), (20), NO-OFDM
+	(4910 - 4990 @ 40), (23)
+	(5030 - 5090 @ 40), (23)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 160), (23), DFS
+
+country JO: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (23)
+	(5735 - 5835 @ 80), (23)
+
+country KE: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (23)
+	(5490 - 5570 @ 80), (30), DFS
+	(5735 - 5775 @ 40), (23)
+
+country KH: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+country KP: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5630 @ 80), (30), DFS
+	(5735 - 5815 @ 80), (30)
+
+country KR: DFS-JP
+	(2402 - 2482 @ 20), (20)
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (30), DFS
+	(5735 - 5815 @ 80), (30)
+
+country KW: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+
+country KZ:
+	(2402 - 2482 @ 40), (20)
+
+country LB: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country LI: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+country LK: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country LT: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country LU: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country LV: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country MC: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+country MA: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+
+country MO:
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 40), (23)
+	(5250 - 5330 @ 40), (23), DFS
+	(5735 - 5835 @ 40), (30)
+
+country MK: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country MT: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country MY: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
+
+country MX: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country NL: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5330 @ 80), (20), NO-OUTDOOR
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country NO: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country NP: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5735 - 5835 @ 80), (20)
+
+country NZ: DFS-FCC
+	(2402 - 2482 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country OM: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+country PA: DFS-FCC
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
+
+country PE: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country PG: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country PH: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country PK: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5735 - 5835 @ 80), (30)
+
+country PL: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country PT: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country PR: DFS-FCC
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country QA: DFS-JP
+	(2402 - 2482 @ 40), (20)
+	(5735 - 5835 @ 80), (30)
+
+country RO: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+
+# Source:
+# http://www.ratel.rs/upload/documents/Plan_namene/Plan_namene-sl_glasnik.pdf
+country RS: DFS-ETSI
+	(2400 - 2483.5 @ 40), (100 mW)
+	(5150 - 5350 @ 40), (200 mW), NO-OUTDOOR
+	(5470 - 5725 @ 20), (1000 mW), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country RU: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5650 - 5730 @ 80), (30), DFS
+	(5735 - 5835 @ 80), (30)
+
+country RW: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country SA: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+country SE: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country SG: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country SI: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country SK: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country SV: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
+
+country SY:
+	(2402 - 2482 @ 40), (20)
+
+country TW: DFS-JP
+	(2402 - 2472 @ 40), (30)
+	(5270 - 5330 @ 40), (17), DFS
+	(5490 - 5590 @ 80), (30), DFS
+	(5650 - 5710 @ 40), (30), DFS
+	(5735 - 5835 @ 80), (30)
+
+country TH: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country TT: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country TN: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+
+country TR: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+ 
+# Source:
+# #914 / 06 Sep 2007: http://www.ucrf.gov.ua/uk/doc/nkrz/1196068874
+# #1174 / 23 Oct 2008: http://www.nkrz.gov.ua/uk/activities/ruling/1225269361
+# (appendix 8)
+# Listed 5GHz range is a lowest common denominator for all related
+# rules in the referenced laws. Such a range is used because of
+# disputable definitions there.
+country UA: DFS-ETSI
+	(2400 - 2483.5 @ 40), (20), NO-OUTDOOR
+	(5150 - 5350 @ 40), (20), NO-OUTDOOR
+	(5490 - 5670 @ 80), (20), DFS
+	(5735 - 5835 @ 80), (20)
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
+
+country US: DFS-FCC
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
+	# 60g band
+	# reference: http://cfr.regstoday.com/47cfr15.aspx#47_CFR_15p255
+	# channels 1,2,3, EIRP=40dBm(43dBm peak)
+	(57240 - 63720 @ 2160), (40)
+
+country UY: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country UZ: DFS-FCC
+	(2402 - 2472 @ 40), (30)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country VE: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (23), DFS
+	(5735 - 5835 @ 80), (30)
+
+country VN: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
+country YE:
+	(2402 - 2482 @ 40), (20)
+
+country ZA: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+country ZW: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+-----BEGIN PGP SIGNATURE-----
+Version: GnuPG v1.4.11 (GNU/Linux)
+
+iQEcBAEBAgAGBQJTlquPAAoJEJMu885bZibyXjAH/1AJpp/g5vRu1ylvrERkGM1v
+tl3PG3dd1qJtZI9jqFkMIC0YP+QwU1ywQ3nMmDguKeC4QMiNGPoaalMtuIkOeAB8
+kBoeuALJGsLc2mDYFmPrkOhuFEIXZKZZK6wLQBqd4mPenZPS+G4DsAxsTk+ul/OS
+tf0n4r9zOF/JXPmORp2dn2gfwe5CjnqjbM4W5lKHC8uUS4QCN4ff0lr00K5UGgCX
+Eu72O7rdsBxsq1AXYJ5oQpORNu+h/AcM9UxcJDJ0NlNlGTLyeRyIlxDX49/OjfEf
+Q7ZU9rq7yyxr4JXFAxai8a86sOMDDlHcMS8J47HA+1f7U5qKuOI09w0VOF9Oy4Q=
+=M7Wr
+-----END PGP SIGNATURE-----
diff --git a/gpg/install.sh b/gpg/install.sh
new file mode 100755
index 0000000..cf20f37
--- /dev/null
+++ b/gpg/install.sh
@@ -0,0 +1,6 @@
+#!/bin/sh
+GPGDIR=/usr/lib/crda
+
+mkdir -p $GPGDIR
+cp db_signed.txt $GPGDIR/
+cp regdb_pubring.gpg $GPGDIR/
diff --git a/gpg/regdb_pubring.gpg b/gpg/regdb_pubring.gpg
new file mode 100644
index 0000000000000000000000000000000000000000..09a02588fa9d0ab289c17a303944000b4e679ae7
GIT binary patch
literal 1193
zcmV;a1XlZ*0SyFGj^d;N2mr8{!rH<(ddaTSbDTR5P(Ks~buH}3)3RDV1Q<{dIKH+E
zZX;D!a*Jb+5co|#BN$~8oL<iUB<=5Y#FZ8T3y;&t;|x&h=YR_6K{x`MBPFubv`(Av
z3zXqzwHFlUTg3+LR@e}Fu74|eLfG0iZw(KOPliNe^EBD3O;`0SgkuH~9xxq%(5s+L
z>RNRDBh>m$9P6t&pCl0c(J%wtV4NhwAxR*16mzHz(FDetVu_v6q&VW$r?H~iRFo;f
z@z66n!1Ac9P_OsB|F9`5pDOqC!#1m?vd8y>j%#B88V33I`uYeD;B4f7o`53n29Euk
zn*D&(@b*KIG90yo7~cR90RRECB5Gl7b#r<kJZfQXb#r<yWO`|3WO`|1Ky+zkbZ;(W
zZ*4w_0XPH`0RjLb1p-r!;-mr_0|pBT2nPcK1{DYb2?`4Y76JnS0v-VZ7k~f?2@sPm
z^UhmlCi2Z!2mf7V;sJ}sevB;CP<*`~eAjlC3-uox$5o{v;66nJ5(%CAI85T4*tOI#
zd1!l~h<emv$?u&aRI1;L?y*|XplIl0y|g?-iOK}mOHVE$y5}67ltafX{Ek)o#pn0C
zeCM+4LTzEJ$nnCqB{saCf|OS0<W`L~PES)wch0DT-#anaoZG8|7JfLEE=64JoqKOu
zQWD>SXtQzupmq%G%+OA-E^XK~{s0^n=fO{<Y$B(!Qu%9YP&cuTFQLtl?drf}(??X+
zZbdIiQ@mQ^d0H;V%a_x>ZLZ6--(28#wD!Ewo=Lh5y@dRWKUw8mGe)AiYGWJ&8&`-R
z$3b}^MY*s700X%J4Fpq;;-mox0JZ$w*xbT%V3#&o|Lf8iTAR{d7d!ut$p>ez<7+w3
z^oiMR&9GAN%DiD;u0^!Ji-+@6SLDUpPlEtQQ18^caWSve-a=Jzr(wx5lze4Z4Ja&G
zl2xE4;D026KD@7E4n!!Y@z#pc21cR<@ZZ{zp@~HHqRzW#zq-a~`G&*q5SNE1J&W19
z+<|^f<Jqi@JpT2PyRBFWFc4LM(lB}=FVjdjLq_(U5PcQat1q=TQN}pDJmqpk2?wLS
z`G9?<#$C|0NwD|lMZZ>8V?(9U_F!h0X^cD5FyOvueZumU71&~BTSKD5x8H4gj#fxl
zDX}8{1C~m=_+kO#qzRt&5daYZ00D^s9|RZy0ssjG0#lCSqyifZ0162ZlP>elTV^Km
zze5N9GW^%NdiPn|GH7ktKRr78>@Num?%s&!NGnTln=+G83#6Zv@Y|6P(|JNE(o&&@
z;xNeiuDOvhsgY6qUc8q<82O<r`>j7@c=U;d%k@G3hz?8+Gp!cde3tdQP|;^@7(w}(
zpLnyX=EKcOWsl{c2?gk1boslnUv3N{vbJTCQaq6rswY$E3c;#Kz6}Gve&7B#&IEm;
zuh+R!7#vbZ6G=wR{IXjmt(s~O&w&seT7m&h6pr)4hH0TDip!@rM2m`@wGkm*Y`11s
z&^A0=)lw(zzA=}AV=yWMHB<yA3n5aCAc;xJO^q<E=}~|P+r%f35t+$D=UJ3tRfE@6
HumS)Bdjm9>

literal 0
HcmV?d00001

diff --git a/reglib.h b/reglib.h
index d570c36..43e45ad 100644
--- a/reglib.h
+++ b/reglib.h
@@ -240,4 +240,5 @@ reglib_optimize_regdom(struct ieee80211_regdomain *rd);
 	     __rd != NULL;					\
 	     __rd = reglib_parse_country(__fp))			\
 
+struct ieee80211_regdomain *__reglib_parse_country(FILE *fp);
 #endif
-- 
1.7.9.5

