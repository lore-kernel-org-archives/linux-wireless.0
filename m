Received: from outbound.qs.icloud.com (qs-2006i-snip4-11.eps.apple.com [57.103.85.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861A23321DC
	for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2026 18:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.85.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774204198; cv=none; b=Mjwh6bdqe/JA/JGyA7A1JEX6LgB5YlJD//yTp31j1NnmHz9PvOGP/QM21UrzxIQDeS4pndjVWfkUs2/A4WYXePv9eZwltJQeegWZGkPlF8QyyZpS49qaebAzh5Pqkf2lmgXA84nXUgN344N3Ye5z1w/4WmhztMxJrwkQGVhdAQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774204198; c=relaxed/simple;
	bh=X8Lew4GjcIp5oo8OTKz7rPaWjyNo187KJ463gcFNIWU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nQp6iikP+ldiFUPO0KQPM7/QsGeNNefG2/1DxOsf7ByUsvW1Hl3gtKlIen89AGVRXPIvkQZEjWNbXJGZp0oL/vskQU3yFrRRvVHQ+v25+AOEvHlCFXoVoj3n2PBPJWdFtC20bhVlxMP1ksM5B1qvPpKz1bKtOeClTSJ311v1Was=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=V/k36Ml3; arc=none smtp.client-ip=57.103.85.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="V/k36Ml3"
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-8 (Postfix) with ESMTPS id 63CD01800109;
	Sun, 22 Mar 2026 18:29:54 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1774204196; x=1776796196; bh=twXhlK/h8Ab18z0e8lFhdWtxTfN1A1j02Ip52ArXzbs=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=V/k36Ml3t57VaMEIxkdQ22/JhQSuK21yMKCdYBzgs0JJvZF5dl7xZhimnCBJ9GfUC9X7iHQGBwlOSV4qSmK1bwgvpqu5WKZBQVE9A/xuPu+QJJpoAK6C7ioMy1HETnMEZ/ThIGaQQUudFxL9WF0zVHkRX5F2f0f/kzcNAaO80t76qU7cQxQNV8ex5rH01pF/0fkFe2dYq6qZ8stk2WgU3s0UX+7f6OWv0YJ5FbW8F7DL0wyM8HQ4hiLauStyK+DDrS1Hg6cgYJeSFy8fVmkWX0zb062xN/TyfmDSsVJYFr8Uu9VbCkgltpNaWJOk/dduPonJzCI0TxL8gTlJC7+T0A==
Received: from arrendajo.lan (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-8 (Postfix) with ESMTPSA id 39E111800099;
	Sun, 22 Mar 2026 18:29:53 +0000 (UTC)
From: Alex Gavin <a_gavin@icloud.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Alex Gavin <a_gavin@icloud.com>
Subject: [PATCH] iw: fix station dump beacon RX indent
Date: Sun, 22 Mar 2026 11:29:48 -0700
Message-ID: <20260322182948.13604-1-a_gavin@icloud.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 0D-VcoNwqYBtgHqlDbA-3qsMTpugk_28
X-Proofpoint-ORIG-GUID: 0D-VcoNwqYBtgHqlDbA-3qsMTpugk_28
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIyMDE2MSBTYWx0ZWRfX2GR8I5kLDtEN
 IC8eV84MUftsiyrfS6Evsjt1KCtwRJeuOWRZDOa3WjGAwlmsmfcspAapm+HiDTo6Bi2944b1+VL
 HinQ2R0BUYZgIuJZdvHi70LdIZIeI6FiNSH46Cyhrfk9jtxQmFf5wF9PvTUy3cqoXCtrGWzJfN3
 KM3zQ03CtCCIsbyRwEnO5Xxvg5VmJM50pW+2iIdFJYgmLOzCriZxFNMtQ+l1sDA4vcPdnLJQ+Xk
 2XaxfQ4hynDH1MEJRmqEm5FRmV9OQj+u3TXKzwrQGJrlX8QMGi3yNR1V/Wyo15PYf0t737Pr4Vb
 wEJzCNQcj5hspuIOXi2EVVXpr9MN/Ka2XdM42JoEr7tZlQSucFt4dqCXpRruvg=
X-Authority-Info-Out: v=2.4 cv=ZMTaWH7b c=1 sm=1 tr=0 ts=69c03522
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=Yq5XynenixoA:10 a=x7bEGLp0ZPQA:10
 a=h3XwevFeXowA:10 a=VkNPw1HP01LnGYTKEx00:22 a=v3ZZPjhaAAAA:8
 a=I57DmmJRBRbeKvPDISgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-22_05,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015
 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2603220161

Signed-off-by: Alex Gavin <a_gavin@icloud.com>
---
 station.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/station.c b/station.c
index 5adf6bf..0f992d5 100644
--- a/station.c
+++ b/station.c
@@ -354,7 +354,7 @@ static void print_nested_sta_handler(struct nlattr *link_sinfo[NL80211_STA_INFO_
 		printf("%sbeacon loss:\t%u", indent,
 		       nla_get_u32(link_sinfo[NL80211_STA_INFO_BEACON_LOSS]));
 	if (link_sinfo[NL80211_STA_INFO_BEACON_RX])
-		printf("\n\t\tbeacon rx:\t%llu",
+		printf("%sbeacon rx:\t%llu", indent,
 		       (unsigned long long)nla_get_u64(link_sinfo[NL80211_STA_INFO_BEACON_RX]));
 	if (link_sinfo[NL80211_STA_INFO_RX_DROP_MISC])
 		printf("%srx drop misc:\t%llu", indent,
-- 
2.51.2

