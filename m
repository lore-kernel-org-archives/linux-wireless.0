Return-Path: <SRS0=IiY2=SA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A62AC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Mar 2019 11:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C90C20811
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Mar 2019 11:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iPLlOdtP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iPLlOdtP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbfC2LXY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Mar 2019 07:23:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58566 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbfC2LXY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Mar 2019 07:23:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E2FB3604BE; Fri, 29 Mar 2019 11:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553858602;
        bh=zUrrSWfxaUOJfFO3vzCEhjn6IT6vFdfDMgejN5N3vsE=;
        h=From:To:Cc:Subject:Date:From;
        b=iPLlOdtPJ6bReT9jH0I43rX74lSAtdPW6EXiy2sZkt8cRlJ3QZijOQG9RwqnawDZf
         E+GsWu1Zf4OeuxynoR0G3eS7xidSW5p/wtvFR5oJi0ljSpeOBilXXD+rG26H9pCsLV
         N3G+ca/E2J38l7zKibMksn8i2o12g5h5pz4ZIbT8=
Received: from checstex0244823-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bpothuno@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E5A860735;
        Fri, 29 Mar 2019 11:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553858602;
        bh=zUrrSWfxaUOJfFO3vzCEhjn6IT6vFdfDMgejN5N3vsE=;
        h=From:To:Cc:Subject:Date:From;
        b=iPLlOdtPJ6bReT9jH0I43rX74lSAtdPW6EXiy2sZkt8cRlJ3QZijOQG9RwqnawDZf
         E+GsWu1Zf4OeuxynoR0G3eS7xidSW5p/wtvFR5oJi0ljSpeOBilXXD+rG26H9pCsLV
         N3G+ca/E2J38l7zKibMksn8i2o12g5h5pz4ZIbT8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5E5A860735
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bpothuno@codeaurora.org
From:   Balaji Pothunoori <bpothuno@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc:     Ashok Raj Nagarajan <arnagara@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v4] iw: Add support for controlling tx power for per station
Date:   Fri, 29 Mar 2019 16:53:15 +0530
Message-Id: <1553858595-21819-1-git-send-email-bpothuno@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ashok Raj Nagarajan <arnagara@codeaurora.org>

This patch allows userspace to set transmit power,
in dBm units, to a station associated to the AP.

To set a limit tx power of 20 dBm:
iw wlan0 station set <mac-addr> txpwr limit 20

To revert the user defined tx power for a station:
iw wlan0 station set <mac-addr> txpwr auto

Co-developed-by: Balaji Pothunoori <bpothuno@codeaurora.org>
Signed-off-by: Ashok Raj Nagarajan <arnagara@codeaurora.org>
Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
v2: modified user configured units to dBm from mBm
v3: no changes, rebased
v4: rebased and removed check for sta_txpwr
    in order to configure tx power '0'

 station.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/station.c b/station.c
index 25cbbc3..0454f87 100644
--- a/station.c
+++ b/station.c
@@ -661,6 +661,7 @@ static const struct cmd *station_set_plink;
 static const struct cmd *station_set_vlan;
 static const struct cmd *station_set_mesh_power_mode;
 static const struct cmd *station_set_airtime_weight;
+static const struct cmd *station_set_txpwr;
 
 static const struct cmd *select_station_cmd(int argc, char **argv)
 {
@@ -674,6 +675,8 @@ static const struct cmd *select_station_cmd(int argc, char **argv)
 		return station_set_mesh_power_mode;
 	if (strcmp(argv[1], "airtime_weight") == 0)
 		return station_set_airtime_weight;
+	if (strcmp(argv[1], "txpwr") == 0)
+		return station_set_txpwr;
 	return NULL;
 }
 
@@ -873,6 +876,72 @@ COMMAND_ALIAS(station, set, "<MAC address> airtime_weight <weight>",
 	"Set airtime weight for this station.",
 	select_station_cmd, station_set_airtime_weight);
 
+static int handle_station_set_txpwr(struct nl80211_state *state,
+				    struct nl_msg *msg,
+				    int argc, char **argv,
+				    enum id_input id)
+{
+	enum nl80211_tx_power_setting type;
+	unsigned char mac_addr[ETH_ALEN];
+	int sta_txpwr = 0;
+	char *err = NULL;
+
+	if (argc != 3 && argc != 4)
+		return 1;
+
+	if (mac_addr_a2n(mac_addr, argv[0])) {
+		fprintf(stderr, "invalid mac address\n");
+		return 2;
+	}
+
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
+	argc--;
+	argv++;
+
+	if (strcmp("txpwr", argv[0]) != 0)
+		return 1;
+	argc--;
+	argv++;
+
+	if (!strcmp(argv[0], "auto"))
+		type = NL80211_TX_POWER_AUTOMATIC;
+	else if (!strcmp(argv[0], "limit"))
+		type = NL80211_TX_POWER_LIMITED;
+	else {
+		printf("Invalid parameter: %s\n", argv[0]);
+		return 2;
+	}
+
+	NLA_PUT_U8(msg, NL80211_ATTR_STA_TX_POWER_SETTING, type);
+
+	if (type != NL80211_TX_POWER_AUTOMATIC) {
+		if (argc != 2) {
+			printf("Missing TX power level argument.\n");
+			return 2;
+		}
+
+		argc--;
+		argv++;
+
+		sta_txpwr = strtoul(argv[0], &err, 0);
+		NLA_PUT_U16(msg, NL80211_ATTR_STA_TX_POWER, sta_txpwr);
+	}
+
+	argc--;
+	argv++;
+
+	if (argc)
+		return 1;
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND_ALIAS(station, set, "<MAC address> txpwr <auto|limit> [<tx power dBm>]",
+	NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_set_txpwr,
+	"Set Tx power for this station.",
+	select_station_cmd, station_set_txpwr);
+
 static int handle_station_dump(struct nl80211_state *state,
 			       struct nl_msg *msg,
 			       int argc, char **argv,
-- 
2.7.4

