Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417D53164BA
	for <linux-wireless@vger.kernel.org>; Sun,  7 Jun 2026 17:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780855197; cv=none; b=FFlLydEKTGjHRJt/gjXT8neKv2LrvgdxlAdMkM5bQlvS3YKCNDEdPYHwjhdyAWUpLtkt49UfS5JWBkZNbOT3qcge/z+b8Yz5ra7OIda4kUqpo2ZX7Tij/r3TUI/poSrnvvYxkFqJO3RaWuMZ2ibHenjQnu9zpnDi+P53pKQ/nvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780855197; c=relaxed/simple;
	bh=sl0svvqwD4lNvg+h+xg0eFI5Dd7WToR+UDxSO3xG6fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiVeupR0cqG58p7vwxn6J3ys5hmX2XNJ8JnMIc/AHL+Uabr8nEkcW8KTY1aN2DqFjxcL9dAwX4gl0avvuPK38CRG6gcNAsxys6eSO8baVZB1/Zh6/94KFodi9IgzYM5RRJRBmA/HbtLd3b0OTJMNs9zC7UNPrBYVsfgLS03wu00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mVzt1skX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JkbZuwpN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mVzt1skX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JkbZuwpN"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 657Ek2Zi440424
	for <linux-wireless@vger.kernel.org>; Sun, 7 Jun 2026 17:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=bjhxCgxuOJf
	a+7eTPwbzhwHIn9DJIuFJipxqJyxc4Ws=; b=mVzt1skXENxihZU2L4FBtuYEfPi
	c+tmE+AdAIQzSEJ4OG3IvVUaBnIY5EG/dn41wQi8J45iZ65KTGeYt9ReZsFXehJw
	HTEkUP7/3JRbFO1FATfYe/En3kxq77VMCaE5WNhSs5/GdZ2wP7DZ63kslcDQ47MN
	6S6fM+PHpJCzuWhFWjjPFKg33IS4lBu3dj360GjIK47wvl1+4WUmACq+/Nh/oEUz
	8b12Cj7sP1hBmO6U7LK9OW/ROIOm92YfExupM8jATVkg0iRmLCAgbS1UbPg0EqDu
	CiAj9Fp82JaQQYMz4y85ENOjx91CXCdCoXXtfWXXemggz7pzUI7r/uswCvA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4em98cvx6b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2026 17:59:52 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8422382178bso2396624b3a.2
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2026 10:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780855192; x=1781459992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bjhxCgxuOJfa+7eTPwbzhwHIn9DJIuFJipxqJyxc4Ws=;
        b=JkbZuwpN6PPRznTdI/uuedI965fiASnnZoIdNihNO+DOTHtKkRZYUGXpSRDbA8sctl
         gFVFDhWlyIiOQX61NuqKhDNvTG9EYeJ7t9Nb6ocuN0rTUxp1y/pktrCBNjJhUSJNuQta
         OPEFLPjIKNahTXMRH79ukRoxjLTX21RZSf0tQSjD0s9ZMzJcEQjgVMw+DJyjirGJNFyP
         3MRdsRAVWPcxzNiQNMe8/vLIbKq4mBx9F4Tlf8KSC1nmd0PysYVKiTnVzQEtlBqRE/rb
         bKNhvJIK8PU8OKfsmKmQdD0lYtFoAnvVloigq1NYMKLyQh9nkojQwxX98X4BIgCdUp+p
         mD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780855192; x=1781459992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bjhxCgxuOJfa+7eTPwbzhwHIn9DJIuFJipxqJyxc4Ws=;
        b=kYWPMkRehTyafCXf798wH0I6ebpW0lrHzFg9ivhQEk+P1ZtS1VM66n3CU6HlKhBlvf
         rsFljjMrDLVBrH5rLnKBdRv4xwzptZlpqmZPd+eQpiHWNwFHe+AVzMYe3K8w8N2fhmoy
         zf4hrIy2vA21dwb2wAdL7JxnOw3xFlBeZMccaQb/CYQ8mAW8ZC5gZMNex4g6iRXEYHGL
         z8W2+ygjd9oH24jTtWLVvR7E2kOr/G30jQlsDXlGh259/d428zcYKaqus4YCuy2q+HBE
         Umi7RLW9wPbd25UhHjRAL7zYDv5VgDZyDjEshZ9anH8er5dSCG7CvV9jWlihaHkfm7nv
         9+6w==
X-Gm-Message-State: AOJu0YwGPGcVrG/bsYoZb5oMU1GabyeBzjN82q9KjP3OBgs21jSycggU
	MKCXqpyjdMBHq2OYcNXIPnSNJBPpX0PpCNGZVezo0YYDd3JxHjyaoFOY5lkkOeifBq68DNx1qtY
	oTlrpB0RcGBJwIQGBYTHnq0w1mBEPEyhCpbdcrQUjCftDL5ebOYh6do9mQWVsCMf6/lN292aPD5
	MhLw==
X-Gm-Gg: Acq92OFGXD8lj/q9HfTnWrC4xx/TwIaOk9NFRM+skTGN1zNOgA2JZhQ134fCHCfASmN
	1GYIO8hwx0IuF/FGSZBdwR7T3jYVYRzgs4hJwWSnQ9/HVr/8u37NPUBx9fQJTpQW07qEnHxrWl1
	dLMSazpzTU5IPyRq6vnHCilV/fwbBIaaxlKNs40KunPzDHf1kCICSdYGUxrOvdknel8dZwcL5Yr
	I5BbpVibiyZjNNwmJLfcnWmTFIG7zg7Jkk1cyKO3ALUptrYAY0/UzHIO/XLgXefkHCQpEYU38Kh
	alE0sP0dkbBNpeGM2N0USqrYmO+m7tsxto9h1G+f5AmbsHAaag2Yr4bMQEOIrABcKVd25RF1GhR
	czQRe5dy4S+5pxn2VTjXGK4tPjTbYuVtccfeCy/uiMV0W1HSXORfpioprdFsFiBaEQ1z6Gpyl5t
	Tfe/tghs2BKlrU45YW90Bhk0IGaP1h3+8qndVWcwZLmdeUBMmTAA==
X-Received: by 2002:a05:6a21:685:b0:3a8:7fb:ca0e with SMTP id adf61e73a8af0-3b4ccf91e30mr15401537637.23.1780855191639;
        Sun, 07 Jun 2026 10:59:51 -0700 (PDT)
X-Received: by 2002:a05:6a21:685:b0:3a8:7fb:ca0e with SMTP id adf61e73a8af0-3b4ccf91e30mr15401511637.23.1780855191186;
        Sun, 07 Jun 2026 10:59:51 -0700 (PDT)
Received: from hu-ppranees-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85df0a624fsm13078522a12.18.2026.06.07.10.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 10:59:50 -0700 (PDT)
From: P Praneesh <praneesh.p@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        praneesh.p@oss.qualcomm.com
Subject: [PATCH wireless-next 2/5] wifi: cfg80211: Add helper to pack station-level STA_INFO
Date: Sun,  7 Jun 2026 23:29:09 +0530
Message-ID: <20260607175912.2266215-3-praneesh.p@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260607175912.2266215-1-praneesh.p@oss.qualcomm.com>
References: <20260607175912.2266215-1-praneesh.p@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA3MDE4MCBTYWx0ZWRfXykEDzjYP/nx3
 J4x6VBq6WqOlc1RzqeqD3KfwwGezbDLwfRDSDLpjy6X1nH8kSnSvJHiDPSS35RjY4LA0p+YNa+G
 +uOoKwj17BZhwNjJC+1AQI185tVPDhzHBP59DjxmwnuT1ASGP5pNEIjdjkPzRt9dPj881SuSvgr
 uhxth4qpuPBVV93B9YAoie240cVtnx6OC+/HxrpzU6GwNaCXVwlPvLBjCupz8eh8ZPqE6R5+dRE
 3oYTd/W6/2GrgphOMgpHoWVxmez7Z0soAZPmNPmvJc2qVPf1kYN4oflNINHbd89HuJOLJ5vsz8m
 sSROhBn3OcoOcwkiLQCTY1Ok5LMrYrStFXWwcuGfjukg+xwwuJkLxu9yaPvs2nuG9DHuTHOolZE
 lj5WtIoZy98ps/X2y94c2Hn5MBfojLud2/zSuMg/RSd7N4w87i9QYqlupb2hxRxWFROwCZbV4yz
 WlildY6+SMrFdm/rfOQ==
X-Proofpoint-ORIG-GUID: WYk5vcsgAHCTxj6-Auki-Um6Q1NEC6p9
X-Proofpoint-GUID: WYk5vcsgAHCTxj6-Auki-Um6Q1NEC6p9
X-Authority-Analysis: v=2.4 cv=A/pc+aWG c=1 sm=1 tr=0 ts=6a25b198 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=NF4BABWMmOogFjTiQ1IA:9 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-07_04,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606070180

Add a helper function nl80211_put_sta_info_common() to pack the
station-level (aggregated) STA information into a netlink message.
This prepares the code for future enhancements such as supporting
fragmented link statistics in nl80211_dump_station.

Signed-off-by: P Praneesh <praneesh.p@oss.qualcomm.com>
---
 net/wireless/nl80211.c | 59 ++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 33609a065423..88232c323d9c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7841,32 +7841,15 @@ static bool nl80211_put_signal(struct sk_buff *msg, u8 mask, s8 *signal,
 	return true;
 }
 
-static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
-				u32 seq, int flags,
-				struct cfg80211_registered_device *rdev,
-				struct wireless_dev *wdev,
-				const u8 *mac_addr, struct station_info *sinfo)
+static int nl80211_put_sta_info_common(struct sk_buff *msg,
+				       struct cfg80211_registered_device *rdev,
+				       struct station_info *sinfo)
 {
-	void *hdr;
 	struct nlattr *sinfoattr, *bss_param;
 
-	hdr = nl80211hdr_put(msg, portid, seq, flags, cmd);
-	if (!hdr) {
-		cfg80211_sinfo_release_content(sinfo);
-		return -1;
-	}
-
-	if ((wdev->netdev &&
-	     nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex)) ||
-	    nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
-			      NL80211_ATTR_PAD) ||
-	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr) ||
-	    nla_put_u32(msg, NL80211_ATTR_GENERATION, sinfo->generation))
-		goto nla_put_failure;
-
 	sinfoattr = nla_nest_start_noflag(msg, NL80211_ATTR_STA_INFO);
 	if (!sinfoattr)
-		goto nla_put_failure;
+		return -EMSGSIZE;
 
 #define PUT_SINFO(attr, memb, type) do {				\
 	BUILD_BUG_ON(sizeof(type) == sizeof(u64));			\
@@ -8044,6 +8027,38 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	}
 
 	nla_nest_end(msg, sinfoattr);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, sinfoattr);
+	return -EMSGSIZE;
+}
+
+static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
+				u32 seq, int flags,
+				struct cfg80211_registered_device *rdev,
+				struct wireless_dev *wdev,
+				const u8 *mac_addr, struct station_info *sinfo)
+{
+	void *hdr;
+
+	hdr = nl80211hdr_put(msg, portid, seq, flags, cmd);
+	if (!hdr) {
+		cfg80211_sinfo_release_content(sinfo);
+		return -1;
+	}
+
+	if ((wdev->netdev &&
+	     nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex)) ||
+	    nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
+			      NL80211_ATTR_PAD) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr) ||
+	    nla_put_u32(msg, NL80211_ATTR_GENERATION, sinfo->generation))
+		goto nla_put_failure;
+
+	/* Use common helper for aggregated STA_INFO */
+	if (nl80211_put_sta_info_common(msg, rdev, sinfo))
+		goto nla_put_failure;
 
 	if (sinfo->assoc_req_ies_len &&
 	    nla_put(msg, NL80211_ATTR_IE, sinfo->assoc_req_ies_len,
@@ -8070,7 +8085,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	genlmsg_end(msg, hdr);
 	return 0;
 
- nla_put_failure:
+nla_put_failure:
 	cfg80211_sinfo_release_content(sinfo);
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
-- 
2.43.0

