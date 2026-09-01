Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C0847B42F;
	Tue,  1 Sep 2026 09:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788255246; cv=none; b=Rgnw5SpIF9k1OC/GABPj0nAanwNATaituLej42F/n8kEM1+uTAdedF1z+okM/xHC9u8Q7q3Uz2n02mGQEELyH4vH35AgVKeIFNAFE6vvNo3IKlJh6Gn4xjv7G6RMwLS7PhiT7RM1A7dTtw1PDO+4ULsclkr205FYrNYeCzjjhQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788255246; c=relaxed/simple;
	bh=yAarwhC65bRtl93giLS4adl7GvmbWlUWmZMvKt6AUOA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U0Otlt/X9FKQU6z5hwqXGH7sPgzq7ER00V+Ws8hgVzM39B+o3O85a5PjMGvBXhxLhJviyLSXIb7sQI2GcVStv9UzNOW6ZxRDYEOIRa6pqWGe8lxfzvH4gWmtr+Y5iZFNotHXFQky5CSnM0uiklEsZvrKi6aO0P93Oh4HY5a9RAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=PPMZvbmE; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="PPMZvbmE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=yT
	ZckLkW8YBc7vASN2tUGiSNOlOsyecF5Ji42NfmAxU=; b=PPMZvbmEiWPQ7w5sgw
	lKXSPVEHqfbA7e6dRPG99QQjQ5AcSiKMtnDGp9JomABx7wkJCeOWHByU9YqgGhl5
	OskzqZhTUCJy6kC/4vS1TGJVKhWUKo13ANdgyqvo/PpTct89QBblRfjqAd3m9as4
	2iW0r046uPdb6kfV/kq53Gnbg=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgD3Pyrzm5Zql_oSPQ--.53813S2;
	Tue, 01 Sep 2026 17:33:40 +0800 (CST)
From: Gongwei Li <13875017792@163.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Chin-Yen Lee <timlee@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Gongwei Li <ligongwei@kylinos.cn>
Subject: [PATCH] wifi: rtw89: fw: propagate real error code in rtw89_fw_h2c_add_general_pkt()
Date: Tue,  1 Sep 2026 17:33:31 +0800
Message-Id: <20260901093331.3441469-1-13875017792@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgD3Pyrzm5Zql_oSPQ--.53813S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cw1xuFWxCF17JF4UuFy7trb_yoW8WFyrpF
	WrCa47CFn8Jr1xWa48Ja43WF1rX3ZrtFWjkrZ0k3s5Z3yrXw1rKFyrKFyjvF909rWDXayj
	vrWvvFnrC3ZYv3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jYHq7UUUUU=
X-CM-SenderInfo: rprtmlyvqrllizs6il2tof0z/xtbC4RRkH2qWm-TLAAAA3W

From: Gongwei Li <ligongwei@kylinos.cn>

The error path of rtw89_fw_h2c_add_general_pkt() returns -ENOMEM
unconditionally, which masks the real reason of a failure. In
particular:

* rtw89_fw_h2c_add_pkt_offload() can fail with -ENOSPC when no more
  packet offload slot is available, or with the error of H2C TX, but
  the callers only see -ENOMEM and get misled when debugging.

* For an unsupported type, the switch default case returns -ENOMEM,
  which is misleading and should be -EINVAL.

Return a real error code instead of -ENOMEM, and use -EINVAL for
unsupported types.

Fixes: 5c12bb66b79d ("wifi: rtw89: refine packet offload flow")
Signed-off-by: Gongwei Li <ligongwei@kylinos.cn>
---
  drivers/net/wireless/realtek/rtw89/fw.c | 7 +++++--
  1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index d6a594b75ab2..ab2d0b0cb1e5 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -3013,11 +3013,14 @@ static int rtw89_fw_h2c_add_general_pkt(struct rtw89_dev *rtwdev,
 		skb = rtw89_arp_response_get(rtwdev, rtwvif_link);
 		break;
 	default:
+		ret = -EINVAL;
 		goto err;
 	}
 
-	if (!skb)
+	if (!skb) {
+		ret = -ENOMEM;
 		goto err;
+	}
 
 	ret = rtw89_fw_h2c_add_pkt_offload(rtwdev, &info->id, skb);
 	kfree_skb(skb);
@@ -3031,7 +3034,7 @@ static int rtw89_fw_h2c_add_general_pkt(struct rtw89_dev *rtwdev,
 
 err:
 	kfree(info);
-	return -ENOMEM;
+	return ret;
 }
 
 void rtw89_fw_release_general_pkt_list_vif(struct rtw89_dev *rtwdev,

-- 

2.25.1

