Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B1529898B
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897300; cv=none; b=TbRal0eqn6Pg3Fxvy28xE8b4bUfMP+zl1c9vky7bUgCX9yXDiG9HWqxxBu27maDkSy0LbE0GiVTbEQc9+2wTZxxawlIpMlZ15cwG6p32kHqLjYRUN//oZf4G0gQCC2Y1qCbHufUXPYOpdpdZynILZWVtYE8/Gm9nhUKM0gpMPJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897300; c=relaxed/simple;
	bh=keGalj5Ie75KIHHPK5AEn6bIrttRVCUsSp7OkmSv/PI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxv1KGLsbhOsi0AI4n7Ez4NLXTebv0MbgGoLCcBNnqfEWhlT7yivtmV2eh5Sp5IALR06cyTSp5m0qLocpdiXRl4mYdEhCpVb9KciPx7CRzpeb/d+4nfjhdLSGv7k4w3m1Ki7YA9Dd+KNBJaVkCde5xyuUNAsl8cwIYDKpUwQH1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=LuHGRlWn; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="LuHGRlWn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nSkuKqYbqMlVe8BcrvkcsYSdwcrUR8+JGVRdYlQqbCE=; b=LuHGRlWnTfyS0EPOPlUs5qS22F
	7ofPec1zhH/HEsSaM2ltEek6CmXxocQ5w6LcIEaS7LiBx2pmsrx1f42D19uqaUtHt8SnBIwastQDR
	6wCm0PysJScZx2PlAKzs+Oe7CW0RFy3ZCmPQk1UX1mksvNWmRnnpV/eRQru3iEZdjBqA=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK4-006LeO-2t
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:16 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 08/29] wifi: mt76: mt7996: reserve space for the CSA-abort countdown TLV
Date: Fri, 24 Jul 2026 12:47:52 +0000
Message-ID: <20260724124813.3961474-8-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724124813.3961474-1-nbd@nbd.name>
References: <20260724124813.3961474-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a CSA countdown is active, mt7996_mcu_beacon_cntdwn() emits two
bss_bcn_cntdwn_tlv entries (the CSA countdown and the CCA-abort BCC), but
MT7996_BEACON_UPDATE_SIZE only reserved one. With MBSSID enabled and a
near-maximum beacon template the extra 8 bytes could push the offload
command past MT7996_MAX_BSS_OFFLOAD_SIZE and trigger skb_over_panic().
Reserve room for both countdown TLVs.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index 8902e16508b7..c673e986ecb5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -917,7 +917,7 @@ enum {
 #define MT7996_BEACON_UPDATE_SIZE	(sizeof(struct bss_req_hdr) +		\
 					 sizeof(struct bss_bcn_content_tlv) +	\
 					 4 + MT_TXD_SIZE +			\
-					 sizeof(struct bss_bcn_cntdwn_tlv) +	\
+					 sizeof(struct bss_bcn_cntdwn_tlv) * 2 +	\
 					 sizeof(struct bss_bcn_mbss_tlv))
 #define MT7996_MAX_BSS_OFFLOAD_SIZE	2048
 #define MT7996_MAX_BEACON_SIZE		(MT7996_MAX_BSS_OFFLOAD_SIZE - \
-- 
2.53.0

