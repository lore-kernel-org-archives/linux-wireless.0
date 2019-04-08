Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A547AC10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 23:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 708E320855
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 23:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mkLv+hs0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mkLv+hs0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbfDHX3a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 19:29:30 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbfDHX3a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 19:29:30 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4DE7B60E5F; Mon,  8 Apr 2019 23:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554766169;
        bh=2nQcZpFw+WKev/bV3tN0agldOWy4f7uoEzBlfpPsppM=;
        h=From:To:Cc:Subject:Date:From;
        b=mkLv+hs0fMP+F6D4vKKL9tnS51fi77zmLyRsB1+b/npxDtVB8BDFyLErCIhOVVjxq
         hS/ET40kQDsCT3cf+8Sgc6NIC8iaBGBr9pqzr7IuuVrQgzViVcnC1r01wFL22Q/qvw
         nZrw0fhq9jMgTPZu2O+zV+89JAmK0VX3cxoaBoTY=
Received: from pradeepc-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pradeepc@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AFCCF60E57;
        Mon,  8 Apr 2019 23:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554766169;
        bh=2nQcZpFw+WKev/bV3tN0agldOWy4f7uoEzBlfpPsppM=;
        h=From:To:Cc:Subject:Date:From;
        b=mkLv+hs0fMP+F6D4vKKL9tnS51fi77zmLyRsB1+b/npxDtVB8BDFyLErCIhOVVjxq
         hS/ET40kQDsCT3cf+8Sgc6NIC8iaBGBr9pqzr7IuuVrQgzViVcnC1r01wFL22Q/qvw
         nZrw0fhq9jMgTPZu2O+zV+89JAmK0VX3cxoaBoTY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AFCCF60E57
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pradeepc@codeaurora.org
From:   Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH] iw: add command to inject a frame via direct mesh link to mesh peer
Date:   Tue,  9 Apr 2019 04:59:23 +0530
Message-Id: <1554766163-12649-1-git-send-email-pradeepc@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mpath command to inject ethernet frame over direct mesh link to
given peer, bypassing the mpath table lookup. This helps to send data
frames over unexcersized direct mesh path, which is not selected as
next_hop node. This can be helpful in measuring link metrics.

Format:
$ iw dev <devname> mpath probe <Peer MAC> frame <pattern>

Example:
$ iw wlan0 mpath probe aa:bb:cc:dd:ee:ff frame aa:bb:cc:dd:ee:ff:kk:ll:mm:nn:oo:pp:yy:zz

Frame pattern is supplied as hex pattern of the form aa:bb:cc without
leading 0x. Frame type and length are expected to be of ethernet frame
type.

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---

 mpath.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/mpath.c b/mpath.c
index ff0b7419fd2b..e39c24ba4403 100644
--- a/mpath.c
+++ b/mpath.c
@@ -90,6 +90,45 @@ static int print_mpath_handler(struct nl_msg *msg, void *arg)
 	return NL_SKIP;
 }
 
+static int handle_mpath_probe(struct nl80211_state *state,
+			      struct nl_msg *msg,
+			      int argc, char **argv,
+			      enum id_input id)
+{
+	unsigned char dst[ETH_ALEN];
+	unsigned char *frame;
+	size_t frame_len;
+
+	if (argc < 3)
+		return 1;
+
+	if (mac_addr_a2n(dst, argv[0])) {
+		fprintf(stderr, "invalid mac address\n");
+		return 2;
+	}
+
+	if (strcmp("frame", argv[1]) != 0)
+		return 1;
+
+	frame = parse_hex(argv[2], &frame_len);
+	if (!frame) {
+		fprintf(stderr, "invalid frame pattern: %p\n", frame);
+		return 2;
+	}
+
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, dst);
+	NLA_PUT(msg, NL80211_ATTR_FRAME, frame_len, frame);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(mpath, probe, "<destination MAC address> frame <frame>",
+	NL80211_CMD_PROBE_MESH_LINK, 0, CIB_NETDEV, handle_mpath_probe,
+	"Inject ethernet frame to given peer overriding the next hop\n"
+	"lookup from mpath table.\n."
+	"Example: iw dev wlan0 mpath probe xx:xx:xx:xx:xx:xx frame 01:xx:xx:00\n");
+
 static int handle_mpath_get(struct nl80211_state *state,
 			    struct nl_msg *msg,
 			    int argc, char **argv,
-- 
1.9.1

