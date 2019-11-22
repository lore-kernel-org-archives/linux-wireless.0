Return-Path: <SRS0=Y0IC=ZO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67AEDC432C0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 06:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 336742068E
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 06:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574403005;
	bh=3QMdufV80+4d+hL2KT7BVZFNM0dt7I/JcvPcovucgcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Qt4/7VRvpX1zkt4CmGaSpSspV4ElLQgATGnuDvl0l/gL0EHVnVf0lthO2OErFbGLX
	 N33AAUXJpj/04jLIqDkvnfPoSEJ2pSh9ENm9B0b61IXIiNwMObPzxPJWyN8XaU7vzG
	 FoGm5/xvjjs52mgR+NTdYbXQwVVwFBwFAlknttKw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfKVGKA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Nov 2019 01:10:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729257AbfKVF4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDF0920717;
        Fri, 22 Nov 2019 05:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402214;
        bh=3QMdufV80+4d+hL2KT7BVZFNM0dt7I/JcvPcovucgcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubZjjBjgKP3dlFzSrD2NOL9u3kJPiZpJLDhJ6+fV5tEBlGOSj3WNBJzL61XzUXq0h
         w+Uqujd8TzOwqDIqrXy/FoAjoJF8h4e+g2mBMI0DxXqwIYbms8qzKlVtZA3SiyMHAY
         BQBIVotGiDhbS/wpZOIYHEwy7ehbly1vf1ijPVjQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kyle Roeschley <kyle.roeschley@ni.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 062/127] ath6kl: Only use match sets when firmware supports it
Date:   Fri, 22 Nov 2019 00:54:40 -0500
Message-Id: <20191122055544.3299-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kyle Roeschley <kyle.roeschley@ni.com>

[ Upstream commit fb376a495fbdb886f38cfaf5a3805401b9e46f13 ]

Commit dd45b7598f1c ("ath6kl: Include match ssid list in scheduled scan")
merged the probed and matched SSID lists before sending them to the
firmware. In the process, it assumed match set support is always available
in ath6kl_set_probed_ssids, which breaks scans for hidden SSIDs. Now, check
that the firmware supports matching SSIDs in scheduled scans before setting
MATCH_SSID_FLAG.

Fixes: dd45b7598f1c ("ath6kl: Include match ssid list in scheduled scan")
Signed-off-by: Kyle Roeschley <kyle.roeschley@ni.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 414b5b596efcd..f790d8021fa17 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -939,7 +939,7 @@ static int ath6kl_set_probed_ssids(struct ath6kl *ar,
 		else
 			ssid_list[i].flag = ANY_SSID_FLAG;
 
-		if (n_match_ssid == 0)
+		if (ar->wiphy->max_match_sets != 0 && n_match_ssid == 0)
 			ssid_list[i].flag |= MATCH_SSID_FLAG;
 	}
 
-- 
2.20.1

