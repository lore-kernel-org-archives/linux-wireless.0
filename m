Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910624C77A3;
	Thu, 15 Oct 2026 20:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097736; cv=none; b=Q9+gJOUHJHY21TG4FvE1ord1RC088ExU6hgblWNsV1BZpoF9HJzQ78Y0740DgvZ6djInJZFs6p77h96Wb3JElVQeaGcckHmE5qY+daYxM38Z8cSZ12HYS7YoZ7W5ktyaH4w9M60dNN8QO+k+4t5CcVHw0tpxroWluzcYPB3kLMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097736; c=relaxed/simple;
	bh=lG2NNP22M0NO5xUqgRPwcysilGcgfBhTWV4T7DMRn+E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BuF5ABqI0/Z14SdFg2IdxecSPGOO5+L/5eKMvqSTieeGfLRvZRqWjGbMNpZE3XpjIh8hrs8Gb2W70/o3rsMZT9Z3mjZ/TqPqk3Q+LphGYCkb6LEk2XyoFxN7/KLibj3w3+uaW3YcyP352jrt9kHUadqfolSxv6fU04OnubAk8Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJv0K+3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJv0K+3u"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FBB3C2BCFB;
	Thu, 15 Oct 2026 20:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792097736;
	bh=lG2NNP22M0NO5xUqgRPwcysilGcgfBhTWV4T7DMRn+E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iJv0K+3uIOqV8aw8+pi1+arXdtVj6wdiHxcBdvnLH3AyekmulQqUX+aHttGzyltgW
	 w5QHUs5xFPFtSw4j81198rkoNWeAqqAFYOLJjPblNGuLI5YEBD22o/SAXYZMuWh6c+
	 w94k3iGUj6QeiXyZeCp1197Iw5W0F5No0l7HKg4l7ZORmHWvX+xUh+I8ERnIQC6bqk
	 WaRCc2laaKakgDnU1QAIqPF6/KNqioVGvoSx+9SVFft7mX84BMzGT+4bBsihoFsQPq
	 rm5tnHh7GxJHPUkY+Q1sDwlLtVG6QvfFKg8m0Y1hnlQ4Dehs0kiiK9zNA+1U9SZtBU
	 UYV6CbKfJPFVw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA74CC6B38;
	Thu, 15 Oct 2026 20:55:36 +0000 (UTC)
From: John Macias via B4 Relay <devnull+dencity7.gmail.com@kernel.org>
Date: Thu, 15 Oct 2026 13:55:24 -0700
Subject: [PATCH RFC ath-next 1/2] wifi: ath11k: bound READY MAC address
 array reads
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-rdy-mac-array-bounds-v1-1-5de276b752a3@gmail.com>
References: <20261015-rdy-mac-array-bounds-v1-0-5de276b752a3@gmail.com>
In-Reply-To: <20261015-rdy-mac-array-bounds-v1-0-5de276b752a3@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, ath12k@lists.infradead.org, 
 John Macias <dencity7@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792097735; l=2116;
 i=dencity7@gmail.com; s=20261015; h=from:subject:message-id;
 bh=fx/C+ZFaq+eU125xkoBhgIoCgSqHcq5/anc3+g24XuQ=;
 b=4vqVZ2CrGMkKLPRnLWje+CN/yJso9u2G2OAOb/H0qKUP+o0Jr51aq56JU+MpqqHWlN9vAF4Y4
 zC5XP1WeTNhA+SSgWu3Kc8xUBCiDiIdYNk5fl8JfYPUr5jV0r5gBLOb
X-Developer-Key: i=dencity7@gmail.com; a=ed25519;
 pk=z7cMHA0B6NULvJzsST/bbOOegMB6xCo9+/ytQure7B8=
X-Endpoint-Received: by B4 Relay for dencity7@gmail.com/20261015 with
 auth_id=1198
X-Original-From: John Macias <dencity7@gmail.com>
Reply-To: dencity7@gmail.com

From: John Macias <dencity7@gmail.com>

The READY event carries a fixed record whose num_extra_mac_addr field
advertises how many per-radio MAC addresses follow, and a separate
WMI_TAG_ARRAY_FIXED_STRUCT TLV holding that array. The TLV iterator
only ensures that the array TLV fits inside the event;
ath11k_wmi_tlv_rdy_parse() then copies one address per radio without
checking that the array really holds num_radios entries.

If firmware advertises at least num_radios extra addresses but sends a
shorter array, for example two radios with an eight-byte array, the second
ether_addr_copy() reads past the end of the TLV value.

Check the array length against num_radios before copying. When it is too
short, warn and leave pdevs_macaddr_valid unset, so the driver falls back
to deriving the per-radio addresses as it does when no array is provided,
instead of failing READY processing.

Found by code review while bringing up a device with older firmware; a
userspace harness that includes the unmodified parser reports a 6-byte
heap-buffer-overflow read under AddressSanitizer for this input, and
the fixed parser passes. Compile tested only (ath-next, W=1).

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Assisted-by: LLM
Signed-off-by: John Macias <dencity7@gmail.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 08fd6795ed..6ae4e881f8 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -7330,6 +7330,12 @@ static int ath11k_wmi_tlv_rdy_parse(struct ath11k_base *ab, u16 tag, u16 len,
 		if (!(ab->num_radios > 1 && num_mac_addr >= ab->num_radios))
 			break;
 
+		if (len < ab->num_radios * sizeof(*addr_list)) {
+			ath11k_warn(ab, "ready event mac address array too short: %u bytes for %d radios\n",
+				    len, ab->num_radios);
+			break;
+		}
+
 		for (i = 0; i < ab->num_radios; i++) {
 			pdev = &ab->pdevs[i];
 			ether_addr_copy(pdev->mac_addr, addr_list[i].addr);

-- 
2.47.3


