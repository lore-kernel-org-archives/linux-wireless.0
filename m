Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911044CE699;
	Thu, 15 Oct 2026 20:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097736; cv=none; b=t8dMGvb2uO1MIeF5IJVtWhqKY+MRrQco2qVepasXYNozQWCH5lCHJxbM21R1aiKnkNhlRiMDtoi7ozx9cwwfj1wN10aAEVa021IlACpCMmto/IWKI3jLJA5v2YjhsBHyRgLjVf5jFsRss3P4n/jvDScj8c7VnVZu7qc1XBUq+6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097736; c=relaxed/simple;
	bh=ReHuuM+HjdzYLwEJhUbU5VO8Ceo+V/a93dpA2WxkIYk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=HNYEcHOf3+rJzisZ8zSUxYtNxYg4Hrj3jGPWfDX619gxDRp2N33xuNAEoXKy5mhwREFS2QmSlZThlB0peW8y9wAUEqwe+BbG7MES0FXQAWYuCpw0aN5L3vHZ9sgJQHuBvPlStvmtVtCj0XdIfTL2r1ISDUWm7hZ5vOZJJPXBIXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aKFNWcvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aKFNWcvU"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30B21C2BCF4;
	Thu, 15 Oct 2026 20:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792097736;
	bh=ReHuuM+HjdzYLwEJhUbU5VO8Ceo+V/a93dpA2WxkIYk=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=aKFNWcvUaIbXq+pUX+qEceSb/hpvsleNUZIiSmKDP0Te5mlNc73LAE071uFuLhC/n
	 ocawNDkpOFMMmo5L9o9WcdZW3Uj8eBGeNungeC25edBEUof1M4e+//2ODvz4ItR4GW
	 O0BIinddUg+k9R2jBoh6pl/KAx9yyGKS5aRtSbuKLHfJlYH/V1bYQ96tYWAtWZHEBD
	 0iolVIPID+Wa08vWMizwfSLo/dNuYplrots9Dz6T6yLky3VpjQvbC0KvZ1HA8l+X/h
	 t2gumeN0J1xD//2N0wjHfVgJlVuOrf5sJ2EH1Kf8P6YbGUGD8MrBRc5SCTHOqoGEUt
	 s/YIdjfp4NrqQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF84CCA465;
	Thu, 15 Oct 2026 20:55:36 +0000 (UTC)
From: John Macias via B4 Relay <devnull+dencity7.gmail.com@kernel.org>
Subject: [PATCH RFC ath-next 0/2] wifi: ath11k/ath12k: bound READY MAC
 address array reads
Date: Thu, 15 Oct 2026 13:55:23 -0700
Message-Id: <20261015-rdy-mac-array-bounds-v1-0-5de276b752a3@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALs90WoC/yWMQQrCMBBFr1Jm7UASqAG3ggdwK11Mk9FGMJWZV
 FpK726qy/f5762gLIkVTs0Kwp+kacwV7KGBMFB+MKZYGZxxR2tsixIXfFFAEqEF+3HKUTGyN8H
 71jjroapv4Xuaf9kbXC/nfaMyYOa5QPc/6NQ/OZQ9Dtv2BdKfhwGJAAAA
X-Change-ID: 20261015-rdy-mac-array-bounds-de70c7750217
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, ath12k@lists.infradead.org, 
 John Macias <dencity7@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792097735; l=1380;
 i=dencity7@gmail.com; s=20261015; h=from:subject:message-id;
 bh=ReHuuM+HjdzYLwEJhUbU5VO8Ceo+V/a93dpA2WxkIYk=;
 b=qk3rH7i82oGLnWB/24kgq4kwfhaT5xl9p5uCpzh6HOY2aLvfidVKg+nmL1kF468n9NZkjKcaJ
 61byeB9jHX9C2be+01FH/DZMPfXf3byB1D3ZQvanz3y2pBmiD+WZvhM
X-Developer-Key: i=dencity7@gmail.com; a=ed25519;
 pk=z7cMHA0B6NULvJzsST/bbOOegMB6xCo9+/ytQure7B8=
X-Endpoint-Received: by B4 Relay for dencity7@gmail.com/20261015 with
 auth_id=1198
X-Original-From: John Macias <dencity7@gmail.com>
Reply-To: dencity7@gmail.com

ath11k_wmi_tlv_rdy_parse() and ath12k_wmi_rdy_parse() copy one MAC
address per radio from the READY event's fixed-struct array after
checking only the count advertised in the fixed record, not the array
TLV length. A firmware READY event with a short array makes the copy
read past the end of the TLV value.

These patches check the array length first and fall back to the
driver's default per-radio addresses when it is too short.

Found while bringing up an IPQ8074 v1 device with older firmware; the
issue is not specific to that hardware. Verified with a userspace harness
around the unmodified parsers under AddressSanitizer. Compile tested
only (ath-next, W=1); not tested on hardware with a malformed event.

Jeff, following your pointers on my earlier ath12k RX-ring RFC, these
carry a full-name sign-off, an Assisted-by tag, and state the testing
explicitly. This work was developed with AI assistance.

---
John Macias (2):
      wifi: ath11k: bound READY MAC address array reads
      wifi: ath12k: bound READY MAC address array reads

 drivers/net/wireless/ath/ath11k/wmi.c | 6 ++++++
 drivers/net/wireless/ath/ath12k/wmi.c | 6 ++++++
 2 files changed, 12 insertions(+)
---
base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
change-id: 20261015-rdy-mac-array-bounds-de70c7750217

Best regards,
--  
John Macias <dencity7@gmail.com>


