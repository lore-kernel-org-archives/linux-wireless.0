Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A6639C63E
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784529812; cv=none; b=dCYMlzSl2KSowWpjPBDPEFacvq1R231urBCDdlEBrwoNwRBfWH2h1PISMWsFc0GZj+5Xu2K/HHBtBjMp5iOGw+N6HidfQUnHr6Kn5FzbJrCNum9PZ1FaoeYuvQU7MN9sVE/vzcxcfhWjFmhDGsxcziTfHzJ2dQ4GDgZMn/9+tps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784529812; c=relaxed/simple;
	bh=n5zU0NYtkRJrbr09HXeLgkUhcGy/B0y3NrSVUYYxUck=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=nPwLAKVqa3J5n/8ogmk37bOj98dKCKdTpcsw1KJEWyuWLoTRmlh5S7lFwKVzUalwWLXIriZnmu14i8iwRu9eZJUDBFYGegV6NLhYmEEv5pOd0t3ivX9UAN7uuJ0NugQOHWwkHVqL1/VKiArVsC5kGQqPLD/XOfeIGd6oR7bf0vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f22TzUhF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=X/keD4fX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f22TzUhF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="X/keD4fX"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K6RfKQ1774797
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=0pzM8t+0K34DA6jm23GFZM
	iCFUkdlUGll+5K1avMuKw=; b=f22TzUhFjc9J/1ykzJfvDyo5mOHxfk7moB8wb/
	SC/tTy7y9D8H3TlIweXQBm3Onbql8k8gkNbG4ImOeZOW5YfbcX7Y9cW7ad7EaTtX
	tbiQp+LhU7CXishWd61Kq2YU2m7buLFG53/hpgY7Vb/n/AGx0n7CxClzHZTCiX5V
	OTpf3cqCW6WMnPW8YA5wpuURWmlOXtbm2VTkJgrvchpZaE/g+k7k8ONyGAQgDSR8
	LCKE5sJEV1OEzVGMty3Wh2UHrOkdFsow/QSGnaQGvZWO3gQgmZ+3QY+Lo3xyGvM8
	cmsIsEdD2UkfHVSWgOvlahCWiemMz+g7O6egKyXaHhD/XuXg==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2af4s90-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:29 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-847a00bcbd0so12527918b3a.0
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 23:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784529808; x=1785134608; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0pzM8t+0K34DA6jm23GFZMiCFUkdlUGll+5K1avMuKw=;
        b=X/keD4fXcdq7KBX057fqOXPSJdAlkcg8rGflmQF961E4yCMHIpX+KUv0pmatsrqQtF
         ebK2vWAq9J6d1Dtp40YMSW0huGeaipqUG7S3Xt0zYXGR6zzsClmg+RY7OOAbZied4EQP
         SdSVtWxg7AAmLvcac5bDaQKXhnJj4HreuREISyXOOddQDC941xgzb6rhbhc9fANzDjp5
         OP2ZdXujQzhieoBrGZOVVqS43aZLdv4jh8hEFqhadx+2FdkeROKmw0JTfpUnYo+AI1Iu
         4e+1ve3t0xfm+d4JHO98DLpI+mShiRa2SswvsOEO2u1EutfhOji9hJIc/Adxl7RuJC/m
         Bm/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784529808; x=1785134608;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0pzM8t+0K34DA6jm23GFZMiCFUkdlUGll+5K1avMuKw=;
        b=aERNTpCPtiuaWyVZyIWu7QqWShnyPpDFIxfWYKr3M11lY0gkSh+xJcA25xNdKseFDv
         siYcwrQn8Mu5IJlwZ7c1VW9B+y9446lWUgNHn6xO1VgYfkQltSOFQr6wS+FhbC97fN8J
         rvc4q1/Y9/lOpoIfbGNOxBqX8XpPOdzVqdX+wmm9QxxY5z3IkLpRN5SwIZjBlfypWYGp
         ZJf5Qw7+mkpLEna+qGnDGf/2Nnd2cy2tXHl/xMVEGAdolnbVTMHp1G1a3xptcE+LeFBe
         lIwIVIuAIUcyEJ4aYStUyn/6NVWYlPqVxtZwTS/EKaRFCp5A0uLOMM+HBk6ewdhfNVgP
         Al/A==
X-Gm-Message-State: AOJu0YyESfg/BN1FN1ubp398m+SQmG1smutP0kGbnR5CzqzarTQ139HW
	e5PBqUeFCYGfIy3FWANyJ9BZjxKRLq0GeccWFRgRUd+4lSqlEetQdG5itYghKlF5WnBfzvNqfQU
	Xy3AirYs5EizBYrIMi1KDggss09+VbPFY3+PQLXNJjTXWqn50w481qtq23sSADbk5TyNE0w==
X-Gm-Gg: AfdE7cmBhST3VNYQzOhYsVBhONPPX6/11k2OrcH55libpx7A618zksF0OESDwgUiF1F
	pH+ltJNEIwbeROcMpODoKhygeL4mofuNHnBKkCCfSPhk2IjoJnvENu5wHXR1w9z1Ri+VNOuMSu7
	/yTWxCGz6u9+nas1CpbGcu3REglR5HQu5qY/kq/sLrCliCwuRf1ASHfEnzKm7MjFUU8/Y3L20S2
	hCEQo3pl+UQslkB9NY+l+A03ASTvsNxnUSNB08NM39I/eKeBGoyhPCnM7nmuqODIGoD/JYk6V8c
	ckW4jtEhGIKC1be1znaApqbEU8knqjzhbVqw1OPlxii5lua7krX7hAU0nHl1Ar4HpK7MH2L0Ja3
	Ijd5WbvoSamClnrJtZxmhJ+avsGd5N27c5eoX2rB1yJxeOaI+8greTg==
X-Received: by 2002:a05:6a00:26d6:b0:84c:3900:95d4 with SMTP id d2e1a72fcca58-84c39009a0dmr6149818b3a.11.1784529808292;
        Sun, 19 Jul 2026 23:43:28 -0700 (PDT)
X-Received: by 2002:a05:6a00:26d6:b0:84c:3900:95d4 with SMTP id d2e1a72fcca58-84c39009a0dmr6149805b3a.11.1784529807810;
        Sun, 19 Jul 2026 23:43:27 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c3793ec61sm3812097b3a.42.2026.07.19.23.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 23:43:26 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Subject: [PATCH ath-current v2 0/8] wifi: ath12k: support
 firmware-allocated MLD peer ID
Date: Mon, 20 Jul 2026 14:43:21 +0800
Message-Id: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAInDXWoC/5XR207EIBAG4FfZcC0bGE7FK9/DeEHpYIk9rLRbN
 Zu+u7Qx2U206XpDMmH4/slwIQOmiAN5PFxIwikOse9yAQ8H4mvXvSKNVa4JMNBMgaFurDm80fB
 BXdP03o1Y0bahJ8SUWymUUunCcq5MIBk5JQzxcw14Jvkt9eeUsBvJS76s4zD26WsNn/ja8pNT7
 OVMnDJqjGRCFJVDlE/9MBzfz67xfdse87Gkr5rh4i6tYg4cd4pbLH9ry7wTXGfUzO6qkFWQxmv
 rhAYTNlTxP1VkFaX2pVeMC9iaVd6ofH+fMqtWGxaqCiDDG6q6UQF2VbWowTE00jBwdkPVV/We3
 9LLXlnQATig5OIPdZ7nb3iM6wvcAgAA
X-Change-ID: 20260527-ath12k-fw-allocated-ml-peer-id-2b456891157f
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX6VB5tUHRAR7N
 fnoF17TtMHhOlTN3A1Y4+HXL8hft5FqeLbKn3izbnRIf1q4/+ldoR5bUFgCeo1KSGtlpYPyKL1X
 m6mm1NCsEu2RqYotBwPRlVoUVaxFwl4=
X-Proofpoint-GUID: 0XMw5yjNac7x5CZ1lEB_oJ-1ohSP2-6m
X-Proofpoint-ORIG-GUID: 0XMw5yjNac7x5CZ1lEB_oJ-1ohSP2-6m
X-Authority-Analysis: v=2.4 cv=a+sAM0SF c=1 sm=1 tr=0 ts=6a5dc391 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Iq4hiD-WU0-YEpfp37cA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX9bStAEAsWCMQ
 tclR+TSgCJrbEgPXyP6A0d3V2OkwlA0CAhQjy7rcQdUcZB4F1H8YAPxc1b9iqE0yUsyyylVR7hD
 rrUz8Dohwxd4JnyyiwG5CGjeEOqbiikYHuI8j+8TyEdrCUVNSihlSyk3av40bcgxkqE+lg4RApb
 RGaBhWMvZKDYt2tWl8spfTFNbTutq7nAkBTSg76Er/dBOqXwsjW2Re7lGhKK8smVzTXep7MOahd
 PCJREzhTYkrEWGd1wYNT7vnd4x/0LfnweaJBOk/JVLWRzgbMPJ0Lbwu3e9JHID2zm4zB66AYs5t
 NTzfkFCIXzayKDqswwFBY1Z76P5kz965yZPXes2m0WAdJDTVtGcYV7z3r7jplwXSR2taJdCGVo+
 ucVqnc7EQQK1TymMkfESOr1X5mP30FygqgFpiIxypYH6ZW+CyvYFXxpHkucqli7csSGrkQlpax0
 CQHEVl1UYrKj+FDOgPA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200072

ath12k currently assumes the host allocates the MLD peer ID and passes
it down to firmware via WMI_PEER_ASSOC_CMDID. This works on QCN9274
but breaks WCN7850/QCC2072, whose firmware always picks the ID itself
and reports it back through HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP. As a
result dp_hw->dp_peers[] is never populated for MLO peers and the data
path lookup fails. On QCC2072 the firmware additionally crashes on MLO
disconnect when ATH12K_WMI_FLAG_MLO_PEER_ID_VALID was set in the peer
assoc command.

Add a host_alloc_ml_id hw_param to branch behavior, defer the
dp_peers[] publish to the HTT event for firmware-allocated chips, and
propagate the firmware-assigned ID through the existing host
bookkeeping when it arrives.

Patch summary:

1: fix for an out-of-bounds clear_bit() in
     ath12k_mac_dp_peer_cleanup().
  2: group peer assoc send-and-wait into a helper
  3: refactor, keep ATH12K_PEER_ML_ID_VALID set in ahsta->ml_peer_id
     so later patches do not have to OR or mask it at every call site;
  4: parse the HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP message;
  5: introduce hw_param host_alloc_ml_id, set true on QCN9274 family
     and false on WCN7850/QCC2072;
  6: on host_alloc_ml_id == false, leave peer_id_valid unset and send
     ml_peer_id == 0 in WMI_PEER_ASSOC_CMDID;
  7: on host_alloc_ml_id == false, mark ahsta->ml_peer_id and
     dp_peer->peer_id as ATH12K_MLO_PEER_ID_PENDING and skip the
     dp_hw->dp_peers[] publish until the firmware reports the ID;
  8: in the MLO_RX_PEER_MAP handler, propagate the firmware-assigned
     ID into dp_peer->peer_id, every dp_link_peer in
     dp_peer->link_peers[], and ahsta->ml_peer_id, all under
     dp_hw->peer_lock.

---
Changes in v2:
- patch 5/8: initialize ret before goto err handling in ath12k_mac_allocate()
- Link to v1: https://lore.kernel.org/r/20260713-ath12k-fw-allocated-ml-peer-id-v1-0-d0a2a1a519eb@oss.qualcomm.com

---
Baochen Qiang (8):
      wifi: ath12k: fix out-of-bounds clear_bit in ath12k_mac_dp_peer_cleanup()
      wifi: ath12k: factor out peer assoc send-and-wait into a helper
      wifi: ath12k: keep ATH12K_PEER_ML_ID_VALID set in ath12k_sta::ml_peer_id
      wifi: ath12k: add support for HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP
      wifi: ath12k: introduce host_alloc_ml_id hardware parameter
      wifi: ath12k: do not advertise MLD peer ID for firmware-allocate devices
      wifi: ath12k: defer dp_peer registration when firmware allocates MLD peer ID
      wifi: ath12k: resolve PENDING ML peer ID from MLO_PEER_MAP HTT event

 drivers/net/wireless/ath/ath12k/core.c     |   2 +
 drivers/net/wireless/ath/ath12k/core.h     |   3 +
 drivers/net/wireless/ath/ath12k/dp_htt.c   |  49 +++++++++
 drivers/net/wireless/ath/ath12k/dp_htt.h   |  12 +++
 drivers/net/wireless/ath/ath12k/dp_peer.c  |  75 +++++++++++--
 drivers/net/wireless/ath/ath12k/dp_peer.h  |   2 +
 drivers/net/wireless/ath/ath12k/hw.h       |   2 +
 drivers/net/wireless/ath/ath12k/mac.c      | 165 ++++++++++++++++++++---------
 drivers/net/wireless/ath/ath12k/peer.c     |  31 +++++-
 drivers/net/wireless/ath/ath12k/peer.h     |   1 +
 drivers/net/wireless/ath/ath12k/wifi7/hw.c |  12 +++
 11 files changed, 293 insertions(+), 61 deletions(-)
---
base-commit: 951dc0a744e4dc8490935316d3b76e23990bde3c
change-id: 20260527-ath12k-fw-allocated-ml-peer-id-2b456891157f

Best regards,
-- 
Baochen Qiang <baochen.qiang@oss.qualcomm.com>

