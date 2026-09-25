Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3F849DB89;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790343824; cv=none; b=aFoodxOYlLyhIE1ygACUN+su3NuJWDpsEYXOj3UALw26QkjbnBXK4QZ5Bc+qrz9fOkEgJ+a2g4kwzyYNifxtAHE0JJGBEOAF79DsqBn0UL2m7SCD5Kdo/DN/+MxzLJ1xlONc/2xEGKBG/ySeCjYsUAj9tCEt9xx8bAog3PQUMYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790343824; c=relaxed/simple;
	bh=QmWeHOUj1xwSmPBlqnJMpEKB8ZmpIUeoECUf3813j6Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jGweHLYeyGLOl2NDHNxc+UrcNToIARA0z2Hqp4AWZCeYKyD1I9hrXHFNyosRXS67EMUyxgjhZFFF22V4di7crIa6NL0uebD3MqMOe+0kC2Ddr2S+p5p/qe/on0A/lQfCLKTVwK9Fk79qansNhfvq2xhkCD0YRlE/ZB8tE/Aj8Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q7H94SN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q7H94SN3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35F22C2BCFB;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790343824;
	bh=QmWeHOUj1xwSmPBlqnJMpEKB8ZmpIUeoECUf3813j6Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=q7H94SN3BUvHUvZmxUlN0wJxuGzDTMPk7lTUNQ90UA/Zi1t/Rb2jhXNIM5sdRnHV8
	 HUF10ZsGGDPtfBkPhsFkK2YFPwf9lpVhbdUgcxUs148KediGq/Ls1EeMGl87WwBRVI
	 n4M/r6DSqTX5BYE7MK5h+vIxyBsbCMJ18Duww4vo7S1R9k/U7GJFHydJA6KWgZNGgp
	 8JdLR4WQyhP+5H5joYCxG/u9O9J4A7lEUkYQOnZjxwWJ0+ugqV9n1NbzNNdQn6Lf3W
	 0zazVyM5Xb8OvVlAhPsi5oLEnP4CGEftFQcbvsI21OlBh+Oa0hf8QOLe1TVpDzPyK0
	 P2JaGwf4JHshQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE81C98328;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Date: Fri, 25 Sep 2026 23:43:38 +1000
Subject: [PATCH 03/13] wifi: brcmfmac: Fall back to RSSI-only default join
 preferences
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-brcm4388-submit-v1-3-b5cbc2cde2fb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790343821; l=1156;
 i=michael.reeves077@gmail.com; s=fedora-20260918;
 h=from:subject:message-id;
 bh=D6m7eaWnIp+UcQ2goCb0mybb908iS4h2gNzgalFLqPY=;
 b=DGEOlG/yM1NwWG2g1L6tHmSsi/MvzotCKiTqj88S5M3lfn0lx1NlJ8AoYMooqcoLzULwpaf3X
 BWOOZ5+l6SqCisJrlwJk8oeeNDQtDB2yBfMnj9dlMoQikmKyyRVsG33
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=VJ0TvyQ9TvfzYZa908YSE9kpkjFLLD5luv0bERu+boc=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/fedora-20260918 with auth_id=1035
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com

From: Michael Reeves <michael.reeves077@gmail.com>

BCM4388 firmware rejects the default join preference containing a 5 GHz
RSSI boost with -EBADE, but accepts an RSSI-only preference.

Retry with RSSI-only selection only after -EBADE. Log other errors
without retrying.

Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index b6027d83e6..2a37b42ca9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -95,6 +95,10 @@ void brcmf_c_set_joinpref_default(struct brcmf_if *ifp)
 	join_pref_params[1].band = 0;
 	err = brcmf_fil_iovar_data_set(ifp, "join_pref", join_pref_params,
 				       sizeof(join_pref_params));
+	if (err == -EBADE)
+		err = brcmf_fil_iovar_data_set(ifp, "join_pref",
+					       &join_pref_params[1],
+					       sizeof(join_pref_params[1]));
 	if (err)
 		bphy_err(drvr, "Set join_pref error (%d)\n", err);
 }

-- 
2.55.0


