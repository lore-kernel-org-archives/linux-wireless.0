Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A9E45FFA2
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 08:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788249959; cv=none; b=XCQ+siFHzty/pk5zxUgmdNt23rOL8TqS484k7dzcCU+pSSRGXOLmmNgSVZPmcQHQaYd9pKwbD+Hft4oDg5QVRHYvM9bM7I5hAwukWhkl0moAqvnqoBgz5I1tIddW0GFxi1/SePb0EX28bKWCsv3IlmKHMcaTZPJxpIbv5xxmhU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788249959; c=relaxed/simple;
	bh=/fXyNC1SCrVVh1dlZ7cd+p57PMSaOXahAXDGkXDuVMo=;
	h=Content-Type:To:From:Date:Mime-Version:Cc:Subject:Message-Id; b=ZK/hoAD+BHq9hThWVTZ8pchW6L2iJFaod5/S0FTHopMAkzdh+OYt4znOLv2gJbCesp5Sl94mAixX8PC1FIOIQZrC8/iWCBgmM8OebzCSGyyMaDXWP7HdaDiN+/pI7RnbK/4ZCJBGZIva+8n0/W4i0GBiOelsecMSt//bSDwmh8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonshot.ai; spf=pass smtp.mailfrom=moonshot.ai; dkim=pass (2048-bit key) header.d=moonshot.ai header.i=@moonshot.ai header.b=i/NvTp+C; arc=none smtp.client-ip=209.127.231.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonshot.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=moonshot.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=moonshot.ai header.i=@moonshot.ai header.b="i/NvTp+C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2510091218; d=moonshot.ai; t=1788249945; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=olD/KwTfA6Mw6pBOtKDza7C0xrnqoRE53Nj2OT+WgiA=;
 b=i/NvTp+C48190yZkH53H/TWbop5Po3JxSUmEmrrTnO+xxgm4EWtQR6HgF60HkK9BlZik+3
 rSmQ+nKvNBE5fk/5IAnLwLL+g2Yxk/M0cgdJqXDNdz4V3eCyuCKIznf8n9mhUAzxP44XSV
 vzcSR0S4qSYI/7cY7dJlw0CvfD9aaaIs7mTR/k/Ox+ICWNWvNEiotlVpcLxs3TOYjVAaDl
 THDP6xn8iuSPJyHRk6P5lmD94YqPD4BDmbO53yXZIexfckRb8uUb+btBM8e0N7b7LdOD3s
 +JubZrUZFp6xkBXK39F9xoOOxmOjNt7PMZvaf0X7I4Dhfp9LqDqoG6P1oMB+1w==
Received: from dev.msh-dev.svc.cluster.local ([117.157.206.135]) by smtp.feishu.cn with ESMTPS; Tue, 01 Sep 2026 16:05:42 +0800
Content-Type: text/plain; charset=UTF-8
To: "Johannes Berg" <johannes@sipsolutions.net>
X-Lms-Return-Path: <lba+26a968757+9cdf54+vger.kernel.org+yilinzhang@moonshot.ai>
Content-Transfer-Encoding: 7bit
From: "Yilin Zhang" <yilinzhang@moonshot.ai>
Date: Tue,  1 Sep 2026 16:04:27 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Yilin Zhang <yilinzhang@moonshot.ai>
Cc: "Yilin Zhang" <yilinzhang@moonshot.ai>, <linux-wireless@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, 
	"Sergey Matyukevich" <sergey.matyukevich.os@quantenna.com>, 
	"Dmitry Antipov" <dmantipov@yandex.ru>, 
	"Kimi Security Team" <bug-report@moonshot.ai>
Subject: [PATCH] cfg80211: fix double-free of shared hidden-group beacon IEs
Message-Id: <20260901080427.1983015-1-yilinzhang@moonshot.ai>
X-Mailer: git-send-email 2.34.1

cfg80211_update_known_bss() adopts new->pub.beacon_ies without
checking whether new is a hidden group member.

cfg80211_update_assoc_bss_entry() can pass such a member as new on a
CSA channel switch, so the same IEs get two owners and are freed
twice.

Same issue as commit 26e84445f02c ("wifi: cfg80211: fix
use-after-free in cmp_bss()"), which fixed only the drop path.

Reported-by: Kimi Security Team <bug-report@moonshot.ai>
Fixes: 0afd425b1b64 ("cfg80211: fix duplicated scan entries after channel switch")
Signed-off-by: Yilin Zhang <yilinzhang@moonshot.ai>
---
 net/wireless/scan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 071083c..1fbbcda 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1937,6 +1937,9 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 			return false;
 		}
 
+		if (new->pub.hidden_beacon_bss)
+			return true;
+
 		old = rcu_access_pointer(known->pub.beacon_ies);
 
 		rcu_assign_pointer(known->pub.beacon_ies, new->pub.beacon_ies);
-- 
2.34.1
