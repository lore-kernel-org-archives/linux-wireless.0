Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60E84A4852;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790343824; cv=none; b=NNfTMfX+gACWWCNGCYvJ85fWBKdIMwemoDC+0AV8YYIck8Cr4+rMeli8FFpCwjhHrAftTpr4XBMXQBlb6FxVQsR1K9rXzp0AWrkfJ7+4WNIkdmoSmCDziZ9SNtijKzUANe4zM9nTCdqKIGpK9OUZEKcpw3LXVTLy3ZhqYVz3ogI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790343824; c=relaxed/simple;
	bh=YAliB6yiRhdFuFa2qcrpPlG9FntTlMUY/Ng0JWgZkIM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qfxmF1B/Lzb2Po3HYzW4ttHey9/um+MFsTv9crSGrQmc8HsAPmhMiPrzLELDDrtv6IKRtOlv7pwVcQNJNAaDVeKxMxZolrBdZ23QsnI/GEaHcuW9R8ygJCvXiIlH/v0IoBtlbvj7CozZAfFA36/H+cH51mmrLb9IZtRIhLenWG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTOhU1/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTOhU1/n"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9B35C2BCB8;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790343824;
	bh=YAliB6yiRhdFuFa2qcrpPlG9FntTlMUY/Ng0JWgZkIM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RTOhU1/nSTsHXuW2yFTaPmDscE2tpEQt1lEqCHCQiqJdnUnukk8HwHbnBqV0pL8Qa
	 7Lz1P0J7Fn/qJLefunNRTxvUvrsQGnSEaKfYVzO/Hn4du00UFU6/2CsbEY3cP1vsil
	 2HteDCdgoEWU+y/yPjX9cGTvuS9D9fwE+lIwzufh5yeTiEmkkah03qRoqLT4AFF90D
	 SHcgVInzPYi856Cmk/5uBt+fp56VNo/OBcc2cIZsnINENjl4CpgI1kYsXjnW8+/HG1
	 Nl0/UQ7YHSpN38O437WryssUlw8WdDY/0EIi3ziiL2t5b3SaClgwb7k13UInp9dAJ0
	 qOPs6QukqliOw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A05C98328;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Date: Fri, 25 Sep 2026 23:43:44 +1000
Subject: [PATCH 09/13] wifi: brcmfmac: Accept newer BSS information
 versions
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-brcm4388-submit-v1-9-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
In-Reply-To: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>, 
 Pieter-Paul Giesberts <pieterpg@broadcom.com>, 
 "Franky Lin (Zhenhui)" <frankyl@broadcom.com>, 
 Mathy Vanhoef <vanhoefm@gmail.com>, Kalle Valo <kvalo@kernel.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
 brcm80211-dev-list.pdl@broadcom.com, asahi@lists.linux.dev, 
 Hector Martin <marcan@marcan.st>, Daniel Berlin <dberlin@dberlin.org>, 
 Janne Grunau <j@jannau.net>, linux-kernel@vger.kernel.org, 
 Hante Meuleman <meuleman@broadcom.com>, linux-hardening@vger.kernel.org, 
 Michael Reeves <michael.reeves077@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790343821; l=2112;
 i=michael.reeves077@gmail.com; s=fedora-20260918;
 h=from:subject:message-id;
 bh=8kqW4IsiAZD50rAfacLlp9/XbfRe0/TGm5y0e1tN9dQ=;
 b=H8igOmyL5UUB1TH17yWYjV21xuzli872/7XgS5NYtw2Cor9W2YERquEW3/lrUHgwHjWclwz1O
 q6cgtn/WPstBz1zsjG6FHu4dZRFj6rgDjl9j8WqUMNHGyOjaMj+A74e
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=VJ0TvyQ9TvfzYZa908YSE9kpkjFLLD5luv0bERu+boc=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/fedora-20260918 with auth_id=1035
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com

From: Hector Martin <marcan@marcan.st>

The driver accepts only BSS information version 109, rejecting scan
results with newer versions even though the common fields used for
reporting remain compatible.

Accept versions 109 through 112 when reporting scan results.

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c   | 5 +++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 5d99708007..4f1768c8bb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3484,8 +3484,9 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 
 	bss_list = (struct brcmf_scan_results *)cfg->escan_info.escan_buf;
 	if (bss_list->count != 0 &&
-	    bss_list->version != BRCMF_BSS_INFO_VERSION) {
-		bphy_err(drvr, "Version %d != WL_BSS_INFO_VERSION\n",
+	    (bss_list->version < BRCMF_BSS_INFO_MIN_VERSION ||
+	     bss_list->version > BRCMF_BSS_INFO_MAX_VERSION)) {
+		bphy_err(drvr, "BSS info version %d unsupported\n",
 			 bss_list->version);
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index d591f17960..c786da4336 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -18,7 +18,8 @@
 #define BRCMF_ARP_OL_HOST_AUTO_REPLY	0x00000004
 #define BRCMF_ARP_OL_PEER_AUTO_REPLY	0x00000008
 
-#define	BRCMF_BSS_INFO_VERSION	109 /* curr ver of brcmf_bss_info_le struct */
+#define BRCMF_BSS_INFO_MIN_VERSION	109
+#define BRCMF_BSS_INFO_MAX_VERSION	112
 #define BRCMF_BSS_RSSI_ON_CHANNEL	0x0004
 
 #define BRCMF_STA_BRCM			0x00000001	/* Running a Broadcom driver */

-- 
2.55.0


