Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A33D48C3E5;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790343824; cv=none; b=qFEu2uAXKEyr7QCkn9D0lbPoxUKYtV1hLwT2d8GCCQ+op08VkNmoGRcmtvEPG7xizdNeIGspO6ItRVKYGoL04VfRk5btYBk93MgPaGuMib+sdA96fsHU7SLZTFijYeHu4CYqfI4I1lP/4vJhN9Gb5SboJyvsQB/OmPivKFh9fKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790343824; c=relaxed/simple;
	bh=lTx1f7dQ9UW6Pu0scxy3eU35tnquTIdut/HPXxDGK/U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j8kaLMUHOF+w0xZifFJeSRfWikF7Fuu9LnqpP89omzxvyOccPIAACsWKN97+1rCZOvQnMlq8OFVDr//4hxx7wz02m90qIL0aOgyF+snHuwqbnty6MFSeCwarSZQwqwFyMjdiJ8Xe47ztH/6n6sXFSBj/eEfEAknSstcPOSTjQos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f7761zbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f7761zbP"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2EAFEC2BCFA;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790343824;
	bh=lTx1f7dQ9UW6Pu0scxy3eU35tnquTIdut/HPXxDGK/U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=f7761zbPpIuTPQj6h+VK45uMLWz+gmSzTd2wMEd/qZH4hNas+fiklie6qXM7KoHZ+
	 MwoCQ6M+dcqPuGK2GvGsBubEtNRb30qwys8tDaHcJBbPHfjz0g/ZI5b06+kP13/4Kh
	 20qHonW9Hdd/Fexa/m0WHupw8EtFBdxSvDnLXzbtZiHNtl5kvJPuUovr0Mpqgsr+Wj
	 +9f9iN0SGfM0Zn16lbUR1VllVeWybi5H/kq9yIETbNHuquMGnH25BiyrGy0001Vzrh
	 VIWimxXfBkW/bDgQ/KZvcmJ4eTpO8OpI4iF/+tUhzB15JJNsnDOvHAo3rUVEFeGv4o
	 cWFswHYtz/Mkw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08284C9830D;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Date: Fri, 25 Sep 2026 23:43:37 +1000
Subject: [PATCH 02/13] wifi: brcmfmac: Match complete firmware capability
 names
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-brcm4388-submit-v1-2-b5cbc2cde2fb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790343821; l=2691;
 i=michael.reeves077@gmail.com; s=fedora-20260918;
 h=from:subject:message-id;
 bh=ojaYvXnNYenVOK36eQmvCXQ5ydFrksNHV7R9HDG7B0Q=;
 b=9FD4dwS6T4jrXBt5RpuCtKAEU2ez77wgnSNVXr/7nn33KNrnBNQZrCCQuyRNbXKbGiOh9UWsK
 orYkFDfXn1mBH1C1qJak2a522yrhAL6RV6C0QAFFhl5GbZ1I81wPnuy
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=VJ0TvyQ9TvfzYZa908YSE9kpkjFLLD5luv0bERu+boc=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/fedora-20260918 with auth_id=1035
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com

From: Michael Reeves <michael.reeves077@gmail.com>

BCM4388 firmware advertises "hp2p" without advertising "p2p". Substring
matching incorrectly treats "hp2p" as P2P support, causing userspace to
attempt Wi-Fi Direct interface creation that the firmware rejects.

Match complete whitespace-separated capability names instead. Remove the
trailing-space workarounds for SAE and FBT and reserve a terminating
byte outside the firmware response buffer.

Fixes: ec64241c9fd2 ("brcmfmac: obtain feature info using 'cap' firmware command")
Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c   | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index cc19e5e7eb..a3c221117d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -42,10 +42,10 @@ static const struct brcmf_feat_fwcap brcmf_fwcap_map[] = {
 	{ BRCMF_FEAT_MONITOR_FLAG, "rtap" },
 	{ BRCMF_FEAT_MONITOR_FMT_RADIOTAP, "rtap" },
 	{ BRCMF_FEAT_DOT11H, "802.11h" },
-	{ BRCMF_FEAT_SAE, "sae " },
+	{ BRCMF_FEAT_SAE, "sae" },
 	{ BRCMF_FEAT_FWAUTH, "idauth" },
 	{ BRCMF_FEAT_SAE_EXT, "sae_ext" },
-	{ BRCMF_FEAT_FBT, "fbt " },
+	{ BRCMF_FEAT_FBT, "fbt" },
 	{ BRCMF_FEAT_OKC, "okc" },
 };
 
@@ -230,11 +230,12 @@ static void brcmf_feat_iovar_data_set(struct brcmf_if *ifp,
 static void brcmf_feat_firmware_capabilities(struct brcmf_if *ifp)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
-	char caps[MAX_CAPS_BUFFER_SIZE];
+	char caps[MAX_CAPS_BUFFER_SIZE + 1] = {};
+	char *cap, *next = caps;
 	enum brcmf_feat_id id;
 	int i, err;
 
-	err = brcmf_fil_iovar_data_get(ifp, "cap", caps, sizeof(caps));
+	err = brcmf_fil_iovar_data_get(ifp, "cap", caps, sizeof(caps) - 1);
 	if (err) {
 		bphy_err(drvr, "could not get firmware cap (%d)\n", err);
 		return;
@@ -242,12 +243,17 @@ static void brcmf_feat_firmware_capabilities(struct brcmf_if *ifp)
 
 	brcmf_dbg(INFO, "[ %s]\n", caps);
 
-	for (i = 0; i < ARRAY_SIZE(brcmf_fwcap_map); i++) {
-		if (strnstr(caps, brcmf_fwcap_map[i].fwcap_id, sizeof(caps))) {
+	while ((cap = strsep(&next, " \t\r\n")) != NULL) {
+		if (!*cap)
+			continue;
+
+		for (i = 0; i < ARRAY_SIZE(brcmf_fwcap_map); i++) {
+			if (strcmp(cap, brcmf_fwcap_map[i].fwcap_id))
+				continue;
 			id = brcmf_fwcap_map[i].feature;
 			brcmf_dbg(INFO, "enabling feature: %s\n",
 				  brcmf_feat_names[id]);
-			ifp->drvr->feat_flags |= BIT(id);
+			drvr->feat_flags |= BIT(id);
 		}
 	}
 }

-- 
2.55.0


