Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9C5C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 13:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B717A20830
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 13:51:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wbt9jl9r";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aPpu4kwS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731953AbfDJNvT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 09:51:19 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59046 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728553AbfDJNvS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 09:51:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4F5056087A; Wed, 10 Apr 2019 13:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554904277;
        bh=OSgHXRS1FHXD8txvkkZK7fjNLNUg7ixRvBHi18+CzBQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Wbt9jl9rj46NGhVwheqJwhHhSNZtR12IwIe96VbF3VXiuwd/VMr7XE+mnOD0Gog9+
         i6mTmTLOJymMD9as9u+osWUHf+Sbg9oCIqaE/uRcmiY/R5o02i+orGo/SSUkFCRDyg
         LguMRO6VdkK1uT6VQejckF3Yul9Ubq7G38CEcFI4=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 801356032C;
        Wed, 10 Apr 2019 13:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554904276;
        bh=OSgHXRS1FHXD8txvkkZK7fjNLNUg7ixRvBHi18+CzBQ=;
        h=From:To:Cc:Subject:Date:From;
        b=aPpu4kwSiHFiC4Jx80UwCl7xhxL+DhWHt+i0sDPywhpz4IXkbSKpclyr8qzGSwBUj
         u/T9bQYL76QaMO/U6oQTk1hpt7UBnuTqxNdB7ihkvhTi502+/d7lSqybJAAZRdqnlb
         +pkqtznH7NqZehFG6o/Ek8kyJUOELSkCMDWHjerY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 801356032C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH] iw: Add new command to support tid specific configuration
Date:   Wed, 10 Apr 2019 19:20:44 +0530
Message-Id: <1554904244-28936-1-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add "set tid_config" command to support tid specific configurations.
This command accepts multiple tid configurations
like retry, ampdu, rtscts, noack and tx bitrate at a time.

Format:

iw dev <interface> set tid_config <configuration>

Example:

Noack configuration :

iw <interface> set tid_config tid <tid_number> peer <MAC_addr> noack enable|disable

Retry count :

iw <interface> set tid_config tid <tid_number> peer <MAC_addr> retry_count long <retry_value>

Aggregation :

iw <interface> set tid_config tid <tid_number> peer <MAC_addr> ampdu enable|disable

RTSCTS configuration :

iw <interface> set tid_config tid <tid_number> peer <MAC_addr> rtscts enable|disable

Bitrates configuration :

iw <interface> set tid_config tid <tid_number> peer <MAC_addr> bitrates <[auto] [fixed] [limit]> [legacy-<2.4|5> <legacy rate in Mbps>*] [ht-mcs-<2.4|5> <MCS index>] [vht-mcs-<2.4|5> <NSS:MCSx]]

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 Makefile     |   2 +-
 bitrate.c    |  40 +++++++++--
 iw.h         |   3 +
 tid_config.c | 230 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 267 insertions(+), 8 deletions(-)
 create mode 100644 tid_config.c

diff --git a/Makefile b/Makefile
index 33aaf6a..ecb5df8 100644
--- a/Makefile
+++ b/Makefile
@@ -24,7 +24,7 @@ OBJS = iw.o genl.o event.o info.o phy.o \
 	reason.o status.o connect.o link.o offch.o ps.o cqm.o \
 	bitrate.o wowlan.o coalesce.o roc.o p2p.o vendor.o mgmt.o \
 	ap.o sha256.o nan.o bloom.o \
-	measurements.o ftm.o
+	measurements.o ftm.o tid_config.o
 OBJS += sections.o
 
 OBJS-$(HWSIM) += hwsim.o
diff --git a/bitrate.c b/bitrate.c
index 4a026a4..e287b13 100644
--- a/bitrate.c
+++ b/bitrate.c
@@ -76,10 +76,9 @@ static int setup_vht(struct nl80211_txrate_vht *txrate_vht,
 
 #define VHT_ARGC_MAX	100
 
-static int handle_bitrates(struct nl80211_state *state,
-			   struct nl_msg *msg,
-			   int argc, char **argv,
-			   enum id_input id)
+int set_bitrates(struct nl_msg *msg,
+		 int argc, char **argv,
+		 int arg_idx, enum nl80211_attrs attr)
 {
 	struct nlattr *nl_rates, *nl_band;
 	int i;
@@ -110,7 +109,7 @@ static int handle_bitrates(struct nl80211_state *state,
 		S_GI,
 	} parser_state = S_NONE;
 
-	for (i = 0; i < argc; i++) {
+	for (i = arg_idx; i < argc; i++) {
 		char *end;
 		double tmpd;
 		long tmpl;
@@ -195,10 +194,14 @@ static int handle_bitrates(struct nl80211_state *state,
 		case S_GI:
 			break;
 		default:
+			if (attr != NL80211_ATTR_TX_RATES)
+				goto next;
+
 			return 1;
 		}
 	}
 
+next:
 	if (have_vht_mcs_24)
 		if(!setup_vht(&txrate_vht_24, vht_argc_24, vht_argv_24))
 			return -EINVAL;
@@ -213,7 +216,7 @@ static int handle_bitrates(struct nl80211_state *state,
 	if (sgi_24 && lgi_24)
 		return 1;
 
-	nl_rates = nla_nest_start(msg, NL80211_ATTR_TX_RATES);
+	nl_rates = nla_nest_start(msg, attr);
 	if (!nl_rates)
 		goto nla_put_failure;
 
@@ -253,11 +256,34 @@ static int handle_bitrates(struct nl80211_state *state,
 
 	nla_nest_end(msg, nl_rates);
 
-	return 0;
+	return i;
  nla_put_failure:
 	return -ENOBUFS;
 }
 
+static int handle_bitrates(struct nl80211_state *state,
+			   struct nl_msg *msg,
+			   int argc, char **argv,
+			   enum id_input id)
+{
+	int ret;
+	struct nl_msg *rate;
+
+	rate = nlmsg_alloc();
+	if (!rate) {
+		ret = -ENOMEM;
+		goto nla_put_failure;
+	}
+
+	ret = set_bitrates(rate, argc, argv, 0, NL80211_ATTR_TX_RATES);
+	if (ret < argc)
+		return 1;
+
+	return 0;
+nla_put_failure:
+	return -ENOBUFS;
+}
+
 #define DESCR_LEGACY "[legacy-<2.4|5> <legacy rate in Mbps>*]"
 #define DESCR DESCR_LEGACY " [ht-mcs-<2.4|5> <MCS index>*] [vht-mcs-<2.4|5> <NSS:MCSx,MCSy... | NSS:MCSx-MCSy>*] [sgi-2.4|lgi-2.4] [sgi-5|lgi-5]"
 
diff --git a/iw.h b/iw.h
index 16ff076..274f02c 100644
--- a/iw.h
+++ b/iw.h
@@ -242,4 +242,7 @@ void nan_bf(uint8_t idx, uint8_t *bf, uint16_t bf_len, const uint8_t *buf,
 
 char *hex2bin(const char *hex, char *buf);
 
+int set_bitrates(struct nl_msg *msg, int argc, char **argv, int arg_idx,
+		 enum nl80211_attrs attr);
+
 #endif /* __IW_H */
diff --git a/tid_config.c b/tid_config.c
new file mode 100644
index 0000000..4b225c6
--- /dev/null
+++ b/tid_config.c
@@ -0,0 +1,230 @@
+#include <errno.h>
+#include <string.h>
+#include <stdbool.h>
+
+#include <netlink/genl/genl.h>
+#include <netlink/genl/family.h>
+#include <netlink/genl/ctrl.h>
+#include <netlink/msg.h>
+#include <netlink/attr.h>
+
+#include "nl80211.h"
+#include "iw.h"
+
+static int handle_tid_config(struct nl80211_state *state,
+			     struct nl_msg *msg,
+			     int argc, char **argv,
+			     enum id_input id)
+{
+	struct nl_msg *tid;
+	struct nlattr *nl_tid;
+	unsigned char mac_addr[ETH_ALEN];
+	bool have_retry = false, have_ampdu = false;
+	bool have_noack = false, have_rtscts = false, have_bitrate = false;
+	int retry_short = -1, retry_long = -1;
+	bool nest_start = true;
+	uint8_t ampdu = 0, rtscts = 0, noack = 0;
+	enum nl80211_tx_rate_setting type = 0;
+	int tid_no = -1, i = 0;
+	char *end;
+	int ret = -ENOSPC;
+
+	if (argc < 4)
+		return 1;
+
+	tid = nlmsg_alloc();
+	if (!tid)
+		return -ENOMEM;
+
+	while (argc) {
+		if (strcmp(argv[0], "tid") == 0) {
+			if (argc < 2)
+				return 1;
+
+			tid_no = strtoul(argv[1], &end, 16);
+			if (*end)
+				return 1;
+
+			goto next;
+		} else if (strcmp(argv[0], "peer") == 0) {
+			if (argc < 2)
+				return 1;
+
+			if (mac_addr_a2n(mac_addr, argv[1])) {
+				fprintf(stderr, "invalid mac address\n");
+				return 2;
+			}
+
+			NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
+			goto next;
+		} else if (strcmp(argv[0], "retry_count") == 0) {
+			have_retry = true;
+			argv++;
+			argc--;
+			if (argc) {
+				if (strcmp(argv[0], "short") == 0) {
+					if (argc < 2)
+						return 1;
+
+					retry_short = strtoul(argv[1], &end, 0);
+					if (*end)
+						return 1;
+					argv += 2;
+					argc -= 2;
+				}
+				if (argc && strcmp(argv[0], "long") == 0) {
+					if (argc < 2)
+						return 1;
+					retry_long = strtoul(argv[1], &end, 0);
+					if (*end)
+						return 1;
+				}
+			}
+		} else if (strcmp(argv[0], "rtscts") == 0) {
+			have_rtscts = true;
+			if (argc < 2) {
+				argc--;
+				argv++;
+				rtscts = NL80211_TID_CONFIG_DEFAULT;
+			} else {
+				if (strcmp(argv[1], "enable") == 0)
+					rtscts = NL80211_TID_CONFIG_ENABLE;
+				else if (strcmp(argv[1], "disable") == 0)
+					rtscts = NL80211_TID_CONFIG_DISABLE;
+				else
+					rtscts = NL80211_TID_CONFIG_DEFAULT;
+			}
+		} else if (strcmp(argv[0], "ampdu") == 0) {
+			have_ampdu = true;
+			if (argc < 2) {
+				argc--;
+				argv++;
+				ampdu = NL80211_TID_CONFIG_DEFAULT;
+			} else {
+				if (strcmp(argv[1], "enable") == 0)
+					ampdu = NL80211_TID_CONFIG_ENABLE;
+				else if (strcmp(argv[1], "disable") == 0)
+					ampdu = NL80211_TID_CONFIG_DISABLE;
+				else
+					ampdu = NL80211_TID_CONFIG_DEFAULT;
+			}
+		} else if (strcmp(argv[0], "noack") == 0) {
+			have_noack = true;
+			if (argc < 2) {
+				argc--;
+				argv++;
+				noack = NL80211_TID_CONFIG_DEFAULT;
+			} else {
+				if (strcmp(argv[1], "enable") == 0)
+					noack = NL80211_TID_CONFIG_ENABLE;
+				else if (strcmp(argv[1], "disable") == 0)
+					noack = NL80211_TID_CONFIG_DISABLE;
+				else
+					noack = NL80211_TID_CONFIG_DEFAULT;
+			}
+		} else if (strcmp(argv[0], "bitrates") == 0) {
+			have_bitrate = true;
+			if (argc < 2)
+				return 1;
+			if (!strcmp(argv[1], "auto"))
+				type = NL80211_TX_RATE_AUTOMATIC;
+			else if (!strcmp(argv[1], "fixed"))
+				type = NL80211_TX_RATE_FIXED;
+			else if (!strcmp(argv[1], "limit"))
+				type = NL80211_TX_RATE_LIMITED;
+			else {
+				printf("Invalid parameter: %s\n", argv[i]);
+				return 2;
+			}
+			argc -= 2;
+			argv += 2;
+		} else {
+			return 1;
+		}
+
+		if (tid_no == -1)
+			return 1;
+		if (have_retry || have_rtscts || have_bitrate || have_ampdu ||
+		    have_noack) {
+			nl_tid = nla_nest_start(tid, i);
+			if (!nl_tid) {
+				ret = -ENOBUFS;
+				goto nla_put_failure;
+			}
+			nest_start = true;
+			NLA_PUT_U8(tid, NL80211_ATTR_TID_CONFIG_TID, tid_no);
+		} else {
+			goto next;
+		}
+
+		if (have_retry) {
+			NLA_PUT_FLAG(tid, NL80211_ATTR_TID_CONFIG_RETRY);
+			if (retry_short != -1) {
+				NLA_PUT_U8(tid, NL80211_ATTR_TID_CONFIG_RETRY_SHORT,
+					   retry_short);
+			}
+			if (retry_long != -1) {
+				NLA_PUT_U8(tid, NL80211_ATTR_TID_CONFIG_RETRY_LONG,
+					   retry_long);
+			}
+
+			retry_short = retry_long = -1;
+			have_retry = false;
+		}
+
+		if (have_rtscts) {
+			NLA_PUT_U8(tid, NL80211_ATTR_TID_CONFIG_RTSCTS_CTRL,
+				   rtscts);
+			rtscts = 0;
+			have_rtscts = false;
+		}
+
+		if (have_ampdu) {
+			NLA_PUT_U8(tid, NL80211_ATTR_TID_CONFIG_AMPDU_CTRL,
+				   ampdu);
+			ampdu = 0;
+			have_ampdu = false;
+		}
+
+		if (have_noack) {
+			NLA_PUT_U8(tid, NL80211_ATTR_TID_CONFIG_NOACK, noack);
+			noack = 0;
+			have_noack = false;
+		}
+
+		if (have_bitrate) {
+			NLA_PUT_U8(tid, NL80211_ATTR_TID_CONFIG_TX_RATES_TYPE, type);
+			if (type != NL80211_TX_RATE_AUTOMATIC) {
+				ret = set_bitrates(tid, argc, argv, 0,
+						   NL80211_ATTR_TID_CONFIG_TX_RATES);
+				if (ret < 2)
+					return 1;
+
+				argc -= (ret - 2);
+				argv += (ret - 2);
+			}
+			have_bitrate = false;
+			type = 0;
+		}
+
+		if (nest_start) {
+			nla_nest_end(tid, nl_tid);
+			nest_start = false;
+		}
+next:
+		if (argc) {
+			argc -= 2;
+			argv += 2;
+		}
+	}
+
+	nla_put_nested(msg, NL80211_ATTR_TID_CONFIG, tid);
+
+	ret = 0;
+
+nla_put_failure:
+	return ret;
+}
+COMMAND(set, tid_config, "tid <tid> [peer <MAC address>] [<retry_count> short <limit> long <limit>] [rtscts enable|disable] [ampdu enable|disable] [noack enable|disable] bitrates <[auto] [fixed] [limited]> [peer <addr>] [legacy-<2.4|5> <legacy rate in Mbps>*] [ht-mcs-<2.4|5> <MCS index>] [vht-mcs-<2.4|5> <NSS:MCSx]",
+	NL80211_CMD_SET_TID_CONFIG, 0, CIB_NETDEV, handle_tid_config,
+	"Set the retry count for the TIDs ");
-- 
1.9.1

