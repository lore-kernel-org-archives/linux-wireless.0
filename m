Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE307435A86
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 09:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784714326; cv=none; b=n+80WQeZIxgrq5NauEDZ/Sfc9o2nDC0rTFM+YlNAK5bjOhDDDKffHUwkiZfj//7CFokdyekJn+/bJOILRw6ef9Ufnphd/snJSKbinJmUEAgMLznSx7iIaZp3LS8+Pd1PZum20pSQlcJxi4F1FpgsPz559s/PjVT7W4r1VuZfNNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784714326; c=relaxed/simple;
	bh=2BGwanOIyMNjbsRycQDCVW6MBsaeJHjHli0BXyUTCWA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RKLimZFS5PRdUwMQAgDioSndNrYsfBXTN9Pe4v6WOqgZUeVgrRNVDYn0WuYhFMfjz0gBWXFzYuvUREX9fOtcp6m261bToUk+YfT/5fkza5duE0grXMIaLFXmLXVkgpO+Tb+Xj3zBzgXsSuyn957YsnyjhzZAKjWdeeANnjcNung=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hwrVs9NH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=h+q+9TUN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hwrVs9NH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="h+q+9TUN"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M8x5Ux1400169
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 09:58:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=WyHN62RuRdrRHFOMXTSlAjFQ2fpF50vbFaQ
	Boq5Mw/4=; b=hwrVs9NHmOUXRPR8x0bYCNuF7OhVIU9QQgE5vtyzEF5nzj/Yrt6
	NA6omqWw2un2ZESHu3XR2MlYhUADlhcCI2cjxXCeI7oV5LO8SKb364Y0tXqRHQa4
	85OkhU1rh1iFx1KTqwIifSpeN2tX75X2ZloKg0Rrpuch0fjtBZpgVouoB751V+fj
	JIeb05au98uCME3vXukJaOZdEVQ95NGnGoIIsivl+aIeK/bjBrxETJc2H+zVYBuO
	69P5esTqascxmVNHesivIIx/DzALwMaq9mjx41CxWgc/8wkhcG15nH9zD1cJWgWJ
	v8igVhdr4P17WFuqIEoDDBfYEbPvA7RNoZw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fjr83901d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 09:58:44 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-caf5fa127d4so13609653a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 02:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784714324; x=1785319124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WyHN62RuRdrRHFOMXTSlAjFQ2fpF50vbFaQBoq5Mw/4=;
        b=h+q+9TUNZdrWE5vf7WpOT7yzrD/5pWdSD6EFhNwqbzihz/3OzCcUItun/ijQ4OCe+6
         Ip38SRIhrO3Rzbobdzio77yH6SxY8QDRptBNjUHEG+xD6dfdzEVwqtHzHV7k8VoHQozV
         JMrCfzhlXAfMQHErkucmS/c9GSUHrEussvrfFiRtlJcoH/60uyC3+oE6e7DSVDFDfl8l
         j//pPIoT4SvNMr59jPyxXE/aPpVVLESr5Q+2rbb44glTHATLKLtErP8CJc63boolOSog
         edD5108JnjIsrvyH+dVO0kqhzRo8Gnp3QYCuKrDXp7HwhTfKwtW9PAFY91hZOKBiYmoh
         n/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784714324; x=1785319124;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WyHN62RuRdrRHFOMXTSlAjFQ2fpF50vbFaQBoq5Mw/4=;
        b=VnPYwxyRH44X1YumpKYlYFGBZg/Ltkz5zdI2Hkp+EId172G0NjQ3MTl+f/lWWzq0Lr
         OAgZHnw3H3hAi7/86MZBQTOhghVXlzhKI2F7A60X2NtysfsQSms3kCZi7o70KtuU9ZVz
         uKI9uHw4j9rnZsDahXOkP0jtL2+nmZ5SVRDDCVQA7+VTZv1t4QllSjiivab1bed1dqeE
         uo6/DlsDdA2F2oHjsL3p06iXDEP0XeDK6dKdeNDfpky8q0CWtOusIR5pX5o/JaZSKIus
         83fFeyJRO/TyR89I9u6xG3kfyD9+LCqkbepFuHDO5XWqGuma3z8Lt+SFSS8IuJakRBb7
         ZGNg==
X-Gm-Message-State: AOJu0YyTk4CuTOteHLTNc6URwO6y1G8y4Jfy7Jbsi5oN/ur4n5Zur7Hu
	DnJAoryPbCORkstcpMwB56z/X2CGwJCBp5q/eyb8J+DYbuvG/3qhXowGbIW0weyaXpx4oyxaWz1
	P4RMbMjce7ZuyuKZXtkch79VU0kqPylJOXsNNTraV3sGqZlgehoD0t6WC/6A12OG82MvJUDNVnO
	1pdw==
X-Gm-Gg: AR+sD13ZLYc9i2XwCZNmYmJOIeP0UxMsIZe9nUMjZLQcDAj7iev5lK9iYSpwnURYv9M
	ENFiM0lgAV5YwhXIGUhz1AgZlWn8KNDf+Z18Y5cvqAtMwz0eryhw1PNhEBOWVIpu09awlYZx32G
	kkP68T2cSEqE5vxDhkipNYhlIPiF4TXHfY1WBnuYP0H/fTDQ4tkXbXizOyPHGapfqVSf+xZMABL
	gQLeNJYCmhgNzQN/VwxGTiDM6AUmMjkd5/piwsfFWjCE7Q6tDRiT5SA5TAa04AeRYmrCpWjrGE4
	dOBR1l5qoB0C68YJsfAOl9TzajnxLGeZQQEx+kgn2h6nDzZiiHoEw5eTtC6wLRcL6tNASZDgEJc
	etCkO+w35ZGJC/JnmVsGFkT3Zf0XPaFiSf1iI+aUppDyyJuQ/TCY/YG9qips+DKTokit4i3PmMp
	lE1n8DLhpbg/7fMXg=
X-Received: by 2002:a05:6a21:4d92:b0:3af:6704:18ca with SMTP id adf61e73a8af0-3c3ad8e8573mr24016147637.35.1784714323915;
        Wed, 22 Jul 2026 02:58:43 -0700 (PDT)
X-Received: by 2002:a05:6a21:4d92:b0:3af:6704:18ca with SMTP id adf61e73a8af0-3c3ad8e8573mr24016126637.35.1784714323447;
        Wed, 22 Jul 2026 02:58:43 -0700 (PDT)
Received: from hu-hbijlani-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147dc1b99esm7816711eec.3.2026.07.22.02.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 02:58:43 -0700 (PDT)
From: Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
X-Google-Original-From: Harsh Kumar Bijlani <hbijlani@qti.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-next] wifi: ath12k: Guard dp_peer dereference in ath12k_mac_peer_cleanup_all()
Date: Wed, 22 Jul 2026 15:28:28 +0530
Message-Id: <20260722095828.2930377-1-hbijlani@qti.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: E5n-Rt7660DNofgM5LmlzSWpcatwq4kQ
X-Authority-Analysis: v=2.4 cv=VfrH+lp9 c=1 sm=1 tr=0 ts=6a609454 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=pHrGrg7HEta1e1VtBTQA:9 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: E5n-Rt7660DNofgM5LmlzSWpcatwq4kQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA5NSBTYWx0ZWRfX10UwmSpjN14h
 66AxaWBF2rx2hkyRsHR3RiSsnwAfK+tU2qwEE6bek1KWY0YjsLBu0WWRNVE5+mF8O4/LX+VCCxN
 fA0XCT8Xfj1Kw5QFk9LKEHfFKOUQa9lapz4FyeKm9eeQZUdpmi74UQUIrteorfMWCspYdvqxjS9
 +a1AtYi2yDiMxjjpfVgY+JMhfTHbGSlt2SQ4riW1MwqWLpsWo1v7tCPHIjfZ2wNDe9IXOrPQbRM
 WdKhWBJnoamV+4OW/nQ6dp7+IhpuJknIAROxnaZ9dvwwVJNKJNWZHMnGaBTwbqEX1mr+pkwmO72
 asBHG6pvqVO2bEc7YeEq9hZIbEcREtXP7ghfC8TYlqRgtKBrgmLkQiFrnqdVvuYvmI1LTJePsDN
 n164SdqPJKgbZZrcSOJ99LTS21hx2G6/kqPASvPpfDHtlcQiWvBzGvCnf61zgxJCfewBWDqk79l
 NxctbrDKYIIyN0ZtOCw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA5NSBTYWx0ZWRfXxbUu7KSK1XaI
 OYooP7ejSfw74qqkYq7Y7pFpQVx/QqpvZYHoz6M7BCUFsS9gab8pwlsX6Fq7tzM0VJVbARk7gOc
 qnoJ/uSPrsCDD8JHqOiWUisD5/4xc1Q=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1011
 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220095

From: Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>

In ath12k_mac_peer_cleanup_all(), the code iterates over all
ath12k_dp_link_peer entries in the dp->peers list and performs
datapath peer cleanup. For each peer, it accesses peer->dp_peer
to clear the link_peers[] and dp_peers[] RCU pointers.

However, peer->dp_peer can legitimately be NULL. The
ath12k_dp_link_peer structure is allocated and added to dp->peers
during peer creation (ath12k_peer_create()), but the dp_peer
assignment happens later via ath12k_dp_link_peer_assign(), which
is called only when a valid dp_peer is found or created. If the
peer creation sequence is interrupted, for example, due to a
firmware crash, a race during interface teardown, or a failure
in the HTT peer-map event processing, then a link peer entry can
exist in dp->peers with dp_peer still NULL.

Accessing peer->dp_peer without a NULL check in this path leads
to a NULL pointer dereference kernel crash during the mac cleanup
path, which is invoked on radio stop or firmware recovery.

This is consistent with how the rest of the driver handles this
field: ath12k_dp_link_peer_unassign(), ath12k_dp_peer_cleanup(),
and several other paths all guard access to peer->dp_peer with
an explicit NULL check before dereferencing it.

Fix this by wrapping the dp_peer dereference block inside a
NULL check, mirroring the pattern already used in the same
function for the Rx TID cleanup:

    if (peer->sta && peer->dp_peer)
        ath12k_dp_rx_peer_tid_cleanup(ar, peer);

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Signed-off-by: Harsh Kumar Bijlani <harsh.bijlani@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 956414b953ec..18c1c809ae4d 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1237,10 +1237,12 @@ void ath12k_mac_peer_cleanup_all(struct ath12k *ar)
 
 		/* cleanup dp peer */
 		spin_lock_bh(&dp_hw->peer_lock);
-		dp_peer = peer->dp_peer;
-		peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
-		rcu_assign_pointer(dp_peer->link_peers[peer->link_id], NULL);
-		rcu_assign_pointer(dp_hw->dp_peers[peerid_index], NULL);
+		if (peer->dp_peer) {
+			dp_peer = peer->dp_peer;
+			peerid_index = ath12k_dp_peer_get_peerid_index(dp, peer->peer_id);
+			rcu_assign_pointer(dp_peer->link_peers[peer->link_id], NULL);
+			rcu_assign_pointer(dp_hw->dp_peers[peerid_index], NULL);
+		}
 		spin_unlock_bh(&dp_hw->peer_lock);
 
 		ath12k_dp_link_peer_rhash_delete(dp, peer);

base-commit: ca27e3c2284a7a43ba390ed5ce0d68b3c869c0ce
-- 
2.34.1

