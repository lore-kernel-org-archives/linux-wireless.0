Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54799C46475
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 19:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F31002082E
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 19:49:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bobcopeland-com.20150623.gappssmtp.com header.i=@bobcopeland-com.20150623.gappssmtp.com header.b="NcI4+W2A"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F31002082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bobcopeland.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbeJZEXT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 00:23:19 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35190 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbeJZEXT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 00:23:19 -0400
Received: by mail-io1-f66.google.com with SMTP id 79-v6so6268765iou.2
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2018 12:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobcopeland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ZWQk8+9SYxnIn8VMm2J+GtO0Wffa5LczGepiGJlwmt4=;
        b=NcI4+W2A+Rl5ncDOEWIWpusFy+ZBihGjAtbMZyzVW4peuHxI+XOJ3GCARWWWWjLYoN
         yBg80ybJ6KdOdqxBaEZ0y8DkLpY9t/3yRg/zYWw1MQMIw0zusYDAJ/XqrcYmXChtp1Te
         WoqwEMdCB9QbCo9y618reXdNVzV26PlHYAor3nrOqklEmJvY78d5G9jICS4pQYy3qWMd
         F7BUZ2pTNXvKD0AFsJymSelgaINUk6FoEf0cxJlBaluELfnVFp+p1ZxvE+ztMVuhMJbO
         oTjQi5+P4iAKIozFJOTbvXxX+OcMnKgmquGQpcW33fPLZHrLqK78NvP3ytE/6tv5cOHx
         54IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZWQk8+9SYxnIn8VMm2J+GtO0Wffa5LczGepiGJlwmt4=;
        b=ZM7raoC9U+hKA83WWpIH6cxKaYcXc4CEig1lgk6vS3D2WFA7wUwe2sP9L8xzRWlia1
         C4k0GJpEjfjMt96AwDKnlQS9tZjUJN1Sa1DcrT1PP4zzIoh31HyocM6rEvqCUoMlBaBh
         SgWrdiPYj2rnzsHlZRX1IfZ1rJFAuAtEvSNHW270ba6nNsYqBaa39pEhHAoGWsz14cFz
         RgCDA60EMOHF8gYgcs+dKvjzR8zzQfsMvSrkZdLobFCd5ebE5LO0pwA79hT3uMilyb7m
         KSMpYrxVVsrzA/PwF59wN2eNpMbUUo5/fGrw07XxJX52RiqSeP1tTNCU2MJYNeSCRRjG
         bHww==
X-Gm-Message-State: AGRZ1gKLyGxGp5TexXRvcR8opQOS+zmhreGD91NUcNtcx0fkE+CHzwDq
        JhWfAMMG98koLuxakKiMXF8sLA==
X-Google-Smtp-Source: AJdET5erQ9Y2H3fdnqf1mJ1mDTZOFCXEgIDaeuEKoEVhNQjpNGIJe5OkCi3dJ3rm5D4CO2LJ26Wj3A==
X-Received: by 2002:a6b:7b4c:: with SMTP id m12-v6mr397235iop.9.1540496951494;
        Thu, 25 Oct 2018 12:49:11 -0700 (PDT)
Received: from hash (CPE30b5c2fb365b-CM18593342f28f.cpe.net.cable.rogers.com. [99.232.51.173])
        by smtp.gmail.com with ESMTPSA id 125-v6sm3490159iov.28.2018.10.25.12.49.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Oct 2018 12:49:10 -0700 (PDT)
Received: from bob by hash with local (Exim 4.89)
        (envelope-from <me@bobcopeland.com>)
        id 1gFlcz-00034A-ET; Thu, 25 Oct 2018 15:49:09 -0400
From:   Bob Copeland <me@bobcopeland.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, kernel-team@fb.com,
        Bob Copeland <me@bobcopeland.com>,
        Bob Copeland <bobcopeland@fb.com>
Subject: [PATCH 1/3] mac80211: mesh: advertise gates in mesh formation
Date:   Thu, 25 Oct 2018 15:48:52 -0400
Message-Id: <20181025194854.11676-1-me@bobcopeland.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The Connected to Mesh Gate subfield (802.11-2016 9.4.2.98.7) in the Mesh
Formation Info field is currently unset.  This field may be useful in
determining which MBSSes to join or which mesh STAs to peer with.

If this mesh STA is a gate, by having turned on mesh gate announcements,
or if we have a path to one (e.g. by having received RANNs) then set this
bit to 1.

Signed-off-by: Bob Copeland <bobcopeland@fb.com>
---
 net/mac80211/mesh.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 8bad414c52ad..19205c821dee 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -254,6 +254,8 @@ int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u8 *pos, neighbors;
 	u8 meshconf_len = sizeof(struct ieee80211_meshconf_ie);
+	bool is_connected_to_gate = ifmsh->num_gates > 0 ||
+		ifmsh->mshcfg.dot11MeshGateAnnouncementProtocol;
 
 	if (skb_tailroom(skb) < 2 + meshconf_len)
 		return -ENOMEM;
@@ -278,7 +280,7 @@ int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
 	/* Mesh Formation Info - number of neighbors */
 	neighbors = atomic_read(&ifmsh->estab_plinks);
 	neighbors = min_t(int, neighbors, IEEE80211_MAX_MESH_PEERINGS);
-	*pos++ = neighbors << 1;
+	*pos++ = (neighbors << 1) | is_connected_to_gate;
 	/* Mesh capability */
 	*pos = 0x00;
 	*pos |= ifmsh->mshcfg.dot11MeshForwarding ?
-- 
2.11.0

