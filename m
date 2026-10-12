Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6983E51F5
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 14:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=165.173.180.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814080; cv=pass; b=hd/or19kvSXSVTstnB064khfaBGVnJsjhjwSmzQrbUX75abcBMeMaT8y1vC5aIjZ2JOf87t7o0RIaxUL3w46Bue6A2yB0cKMqvWQkQWyihpVtMQ+6AqUPbTH49WHmeqgC7EMqvKrhuAy70O9XTApC10dj4Y6xKSuCTBkl9dbIGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814080; c=relaxed/simple;
	bh=p+ZbkJZ0d5jKyTUirunS/zZvbMGFe7MZLiB1alMg6Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acxHqWpzI0CHmuB4bbTICyF/fnMqVcQndkCRupfboh29hdUdfLTNw7pIpuTNdyZbnp/FYH12nQe4B0y4nRo2x639X2oTuaXtxRQlySwv1MWb7bu8aJEbA+AwsoXCITIv/O/30hUFM+96fYS1I8gVtjHshCw3Cw8mRS4SIWkNyWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xv97.com; spf=pass smtp.mailfrom=xv97.com; dkim=pass (1024-bit key) header.d=xv97.com header.i=m@xv97.com header.b=TayIoL9G; arc=pass smtp.client-ip=165.173.180.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xv97.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xv97.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xv97.com header.i=m@xv97.com header.b="TayIoL9G"
ARC-Seal: i=1; a=rsa-sha256; t=1791814070; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Y7tc5ZRTdPXwVPx5oI52HP3CFYKeQq6OlqGF4/MSuCV54l9OUb3Xjl3D1FGyz2sqqlvY8FdhwZyiumZBgoufWImbMi42iQwIbLadlsOVS3ufrb523MYwX2aPEJo3p0uYfVToQx/Wy8WYXBzroLG7kyDT3bGov1lMOtfb02on7kk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791814070; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=wDoqH8VROH56vOYr2HHdJlbUrLDloOj6CqePqi16oZs=; 
	b=ZqKDaqVfBOzGOKMF+QbwbyaViyosOwoyWpwCNGVZQ5BJdVPTXUdTIwKTCp6FEoeEgatrCmtVLb/qLYf0pfwuPAJT1Py7foqmyckpK50abgndE0dZpcGuEM1Cwb6kyUWJ21PKzcKKHSK2CqYZbghoTpQyJXBrHdCtikBflKjN3Ng=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=xv97.com;
	spf=pass  smtp.mailfrom=m@xv97.com;
	dmarc=pass header.from=<m@xv97.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791814070;
	s=zmail; d=xv97.com; i=m@xv97.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=wDoqH8VROH56vOYr2HHdJlbUrLDloOj6CqePqi16oZs=;
	b=TayIoL9GicFYPiWel6X06dD1Kj/kb6gRVf+X1CIZOcm5D4zInyrUHQEvY2DXE5Fi
	vVKWAEgl3I0a4XEd9SqqD1z4LH7PoKMDcvrTIztJ5jYIlAQtpR/eaCNcGydeO6oUfsL
	LIjIWJYCU/m/QK1JZlpo/gcBuSdy9c/d6swklrNU=
Received: by smtp.zohomail.com with SMTPS id 1791814068850782.3775226844612;
	Mon, 12 Oct 2026 07:07:48 -0700 (PDT)
From: Chien Wong <m@xv97.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	jouni.malinen@oss.qualcomm.com
Subject: [PATCH v2 1/2] wifi: mac80211: fix encryption tailroom
Date: Mon, 12 Oct 2026 22:07:36 +0800
Message-ID: <20261012140738.70178-2-m@xv97.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261012140738.70178-1-m@xv97.com>
References: <20261012140738.70178-1-m@xv97.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

BIP-CMAC-256 and BIP-GMAC append a 26-byte MME but mac80211
currently reserves only 18 bytes of encryption tailroom.

Generating 26-byte MME may happen to work because the actual skb
tailroom can exceed the requested amount. For example, dev_alloc_skb()
rounds the allocation to kmalloc size buckets or alignment boundaries,
and the extra space may cover the 8-byte shortfall.

Reserve enough tailroom for the 26-byte MME.

Fixes: 56c52da2d554 ("mac80111: Add BIP-CMAC-256 cipher")
Signed-off-by: Chien Wong <m@xv97.com>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9374c2942489..e3e66d05519e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -52,7 +52,7 @@ struct ieee80211_mesh_fast_tx;
 
 /* Required encryption head and tailroom */
 #define IEEE80211_ENCRYPT_HEADROOM 8
-#define IEEE80211_ENCRYPT_TAILROOM 18
+#define IEEE80211_ENCRYPT_TAILROOM 26 /* current max: GMAC/CMAC-256 MME */
 
 /* power level hasn't been configured (or set to automatic) */
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
-- 
2.56.0

