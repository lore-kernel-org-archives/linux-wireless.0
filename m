Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DD34A5C44;
	Fri, 25 Sep 2026 13:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790343825; cv=none; b=iFH/WebcYl/6c7mLBMYzfuzPNLl5ZJHY7HL2pLgTCByvbc7HrfQi3nXLVnlgYC7hlJLuptSYw9QLEjBJ4KEOdPZECiVgy7qcEPVEDUTCF3EdV6RaRMLFeQFki4tA9vMYi4y3kEqdeWYY8tvC6/9W1EDxcRl0D+0/t1sz5Si/7TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790343825; c=relaxed/simple;
	bh=LG8d3j9KLsAwk2JGh5vXVUC6pIYqvPNVK7hCBA2Rz3A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fhpbUyENcgRdkZXJUytubbQeS1A0k9kAiFT85lyBSayxSE0v10RVfqWLWserGkKoXxXkZ2193k0ParDz9a6ncUym58XM6LKSc4gneDtE/JGtsOVSSqqFxQw647VrgVnlPakV1s8BTRCpC1AhsSJ6ijqXFfBJGfXDWEzoBunPiao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuKNlp3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuKNlp3B"
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED7E9C2BCFF;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790343825;
	bh=LG8d3j9KLsAwk2JGh5vXVUC6pIYqvPNVK7hCBA2Rz3A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UuKNlp3B0QjpotZpMwp7RxBzM2WYVGnnRqSR0RfjBS8/p17KcgTz9oEc7/D5zVMOq
	 3E8gFeyqnLCWCxR2wNyqX56+zuqXQEF9G6EQrnxszcJlKM4b7ursmN/JiqMgHP9q2T
	 5eQUmW5SyhjFnG8FQqfenCva8dEaHVGUNwMkN4uRjH6th++dF7FOXi+9RTjWzkRYG0
	 yhulrvuzEEhaPiRoOyUKb8IWN25nDCllO64S9MfjfwdcSkNSP38pgWND5JpF0iB+3i
	 wAp8LIao/bzKKaymMwYaWYO+Ck8gf275sPrmeiInApXbxI7q9W1ThoxFkUmzbzMwOR
	 rOvrXFrkNXugQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEFEC9830D;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Date: Fri, 25 Sep 2026 23:43:47 +1000
Subject: [PATCH 12/13] wifi: brcmfmac: Handle extended PMK command payloads
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-brcm4388-submit-v1-12-b5cbc2cde2fb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790343821; l=3793;
 i=michael.reeves077@gmail.com; s=fedora-20260918;
 h=from:subject:message-id;
 bh=21CTJ1cSuNsOBHHOhHZPHR3ABfniMlmWG0c7gN9QAGE=;
 b=e+uuYW//sDzL0yIRy08EQa9gPMjdoNz7dUKwMR4kGX7ylSI9mFDzOeqN/J8V7vLaxDU43LSVo
 zkrYgYZ09qtBBqS5B7r4QegIL4Niv8x3FySnZ2f3GlR1LO6B2H7Jq34
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=VJ0TvyQ9TvfzYZa908YSE9kpkjFLLD5luv0bERu+boc=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/fedora-20260918 with auth_id=1035
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com

From: Michael Reeves <michael.reeves077@gmail.com>

Some firmware rejects the legacy BRCMF_C_SET_WSEC_PMK payload despite
advertising firmware supplicant support.

Add the extended PMK layout. Try the legacy payload first when the key
fits, and retry with the extended layout only after -EBADE. Use the
extended layout directly for larger keys and reject keys that exceed its
capacity.

Co-developed-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 39 ++++++++++++++++------
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 18 ++++++++++
 2 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 2a742ae8cc..c9cc6e0ccd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1584,28 +1584,45 @@ int brcmf_set_wsec(struct brcmf_if *ifp, const u8 *key, u16 key_len, u16 flags)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_wsec_pmk_le pmk;
+	struct brcmf_wsec_pmk_ext_le pmk_ext;
 	int err;
 
-	if (key_len > sizeof(pmk.key)) {
+	if (key_len > sizeof(pmk_ext.key)) {
 		bphy_err(drvr, "key must be less than %zu bytes\n",
-			 sizeof(pmk.key));
+			 sizeof(pmk_ext.key));
 		return -EINVAL;
 	}
 
-	memset(&pmk, 0, sizeof(pmk));
+	if (key_len <= sizeof(pmk.key)) {
+		memset(&pmk, 0, sizeof(pmk));
 
-	/* pass key material directly */
-	pmk.key_len = cpu_to_le16(key_len);
-	pmk.flags = cpu_to_le16(flags);
-	memcpy(pmk.key, key, key_len);
+		pmk.key_len = cpu_to_le16(key_len);
+		pmk.flags = cpu_to_le16(flags);
+		memcpy(pmk.key, key, key_len);
+
+		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_WSEC_PMK,
+					     &pmk, sizeof(pmk));
+		if (!err)
+			return 0;
+		if (err != -EBADE)
+			goto fail;
+	}
+
+	memset(&pmk_ext, 0, sizeof(pmk_ext));
+	pmk_ext.key_len = cpu_to_le16(key_len);
+	pmk_ext.flags = cpu_to_le16(flags);
+	memcpy(pmk_ext.key, key, key_len);
 
-	/* store key material in firmware */
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_WSEC_PMK,
-				     &pmk, sizeof(pmk));
+				     &pmk_ext, sizeof(pmk_ext));
 	if (err < 0)
-		bphy_err(drvr, "failed to change PSK in firmware (len=%u)\n",
-			 key_len);
+		goto fail;
+
+	return 0;
 
+fail:
+	bphy_err(drvr, "failed to change PSK in firmware (len=%u, err=%d)\n",
+		 key_len, err);
 	return err;
 }
 BRCMF_EXPORT_SYMBOL_GPL(brcmf_set_wsec);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 917966ad70..37d9414546 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -75,6 +75,7 @@
 #define BRCMF_WSEC_MAX_PSK_LEN		32
 #define	BRCMF_WSEC_PASSPHRASE		BIT(0)
 
+#define BRCMF_WSEC_MAX_PMK_LEN		256
 #define BRCMF_WSEC_MAX_SAE_PASSWORD_LEN 128
 
 /* primary (ie tx) key */
@@ -667,6 +668,23 @@ struct brcmf_wsec_pmk_le {
 	u8 key[BRCMF_WSEC_MAX_SAE_PASSWORD_LEN];
 };
 
+/**
+ * struct brcmf_wsec_pmk_ext_le - extended firmware pmk material.
+ *
+ * @key_len: number of octets in key material.
+ * @flags: key handling qualifiers.
+ * @key: PMK key material.
+ * @opt_len: optional field length.
+ * @opt_tlvs: optional fields in TLV format.
+ */
+struct brcmf_wsec_pmk_ext_le {
+	__le16  key_len;
+	__le16  flags;
+	u8 key[BRCMF_WSEC_MAX_PMK_LEN];
+	__le16  opt_len;
+	u8 opt_tlvs[];
+};
+
 /**
  * struct brcmf_wsec_sae_pwd_le - firmware SAE password material.
  *

-- 
2.55.0


