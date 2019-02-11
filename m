Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ACAAC282CE
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 17:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82A46218A4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 17:04:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="vBQJmP41"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbfBKREh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:04:37 -0500
Received: from mail.toke.dk ([52.28.52.200]:39217 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728106AbfBKREg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 12:04:36 -0500
Subject: [PATCH 1/3] iw: Add command to set airtime weight
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1549904674; bh=sxwTZCTFZvn0qpe9FpwDc9n7OJoBbdRCnW+i3x5MFZA=;
        h=Subject:From:To:Date:From;
        b=vBQJmP41guX2YDAOmZp35IvMM70ewKq71FXIf9lhCsAZGoHz83EezSBqzh8EqFKB+
         a4oOZNoPc/fGS9OmIWA4ZA0miE3P+eyr9SOmHC6nT3FocCbMuShT3ro//VnHae5uiq
         ULROwtCiZ/TWSXPN9+6MaGtp6cqYIx/8b4MytrqK0BWAXFXcLjLwrPT9cZKx28OkEG
         l4Ihw0/+vxRhSBaflqBoCyOlTQAsF5dWYW2t5gr5zpIVmveTRYxr2OfnooMyv/1t2o
         bR5ZReBI1GkstcFE4BXTwYUlNbw+uvo9sOaAXaY5Dw4YzQjP2g0zm9JpXSpu9um2W5
         J3x7iB+37nWfw==
From:   Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To:     linux-wireless@vger.kernel.org
Date:   Mon, 11 Feb 2019 18:04:34 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <154990467406.6770.8841156470323507480.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds a new iw command to set the airtime weight for a station, support
for which was recently introduced into mac80211.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 station.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/station.c b/station.c
index e1477ef..536120c 100644
--- a/station.c
+++ b/station.c
@@ -651,6 +651,7 @@ COMMAND(station, del, "<MAC address> [subtype <subtype>] [reason-code <code>]",
 static const struct cmd *station_set_plink;
 static const struct cmd *station_set_vlan;
 static const struct cmd *station_set_mesh_power_mode;
+static const struct cmd *station_set_airtime_weight;
 
 static const struct cmd *select_station_cmd(int argc, char **argv)
 {
@@ -662,6 +663,8 @@ static const struct cmd *select_station_cmd(int argc, char **argv)
 		return station_set_vlan;
 	if (strcmp(argv[1], "mesh_power_mode") == 0)
 		return station_set_mesh_power_mode;
+	if (strcmp(argv[1], "airtime_weight") == 0)
+		return station_set_airtime_weight;
 	return NULL;
 }
 
@@ -813,6 +816,54 @@ COMMAND_ALIAS(station, set, "<MAC address> mesh_power_mode "
 	"Set link-specific mesh power mode for this station",
 	select_station_cmd, station_set_mesh_power_mode);
 
+static int handle_station_set_airtime_weight(struct nl80211_state *state,
+					     struct nl_msg *msg,
+					     int argc, char **argv,
+					     enum id_input id)
+{
+	unsigned char mac_addr[ETH_ALEN];
+	unsigned long airtime_weight = 0;
+	char *err = NULL;
+
+	if (argc < 3)
+		return 1;
+
+	if (mac_addr_a2n(mac_addr, argv[0])) {
+		fprintf(stderr, "invalid mac address\n");
+		return 2;
+	}
+	argc--;
+	argv++;
+
+	if (strcmp("airtime_weight", argv[0]) != 0)
+		return 1;
+	argc--;
+	argv++;
+
+	airtime_weight = strtoul(argv[0], &err, 0);
+	if (err && *err) {
+		fprintf(stderr, "invalid airtime weight\n");
+		return 2;
+	}
+	argc--;
+	argv++;
+
+	if (argc)
+		return 1;
+
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
+	NLA_PUT_U16(msg, NL80211_ATTR_AIRTIME_WEIGHT, airtime_weight);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+
+}
+COMMAND_ALIAS(station, set, "<MAC address> airtime_weight <weight>",
+	NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_set_airtime_weight,
+	"Set airtime weight for this station.",
+	select_station_cmd, station_set_airtime_weight);
+
 static int handle_station_dump(struct nl80211_state *state,
 			       struct nl_msg *msg,
 			       int argc, char **argv,

