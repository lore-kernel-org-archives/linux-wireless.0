Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BB73E5A2B
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789538664; cv=none; b=R2CMHUC6zujdUBUVjoVX8OlbgujdavAkjg+LfwsrFDAmLIPjJaO/VGMMEE0NtlEh1KwI9PvAZx2dE2EhbgXzVtmZ38EYTShJgJ8r5xrDR6N7XYeaUhR1IiVmBgfYm1pZAz6h/dW9RfezXX5kSfe5fVrbqO4fdabC+vwOwc0Wskk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789538664; c=relaxed/simple;
	bh=n0juoyzkK3uj1C8lR8JNt06JoGfD+P+rP71y6VutWbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgUL6EMtYk1EVPN0QKsKFkF6nqeHkvW10UH9uCX5KyTAvn/rgGpUjUEzTFTsUn+mkMCY5FqHYuzu/ejqtMlOIGxPG1MJjGEecrpIWrlKqdMPDTgY1u7UvCxOcskgmQMAq6mubV72OVEIUp1G185kwwU3x6tKXWp2IAwjYy24260=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=i8PJSOiP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NUWm1LFJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="i8PJSOiP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NUWm1LFJ"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68G2Tb7w1604836
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=mFosAaz6UPx
	9OA6FwJ3No1+Iy0gVjIHm51A34F9fnWc=; b=i8PJSOiPc03mNeRLLwe40gJdqJf
	NUA4K48K8z3xo0wPSs1rpZMnuiFQdaIL8wjm5QsuIK31O/Xz/a3sk0woB0UWizkE
	4YTHTgmv73YgI03drjRCeUTnjo6otvSR7cUVDLiX17/0hWmM8xgzREgJZ2zmr/Gs
	FmkrQBlq8VDrmqqktdqEEmE1/+6j0kZCYUCrBhYipmays1WwnT1Z9MVz8wZnVIJQ
	9/WS0il8OIlcFz+VOh3+yRmHQttKTGakgcPx/FUXMMDAuycrVCySd+fQXabcIl2E
	RWDD/3U+AZC+eZktF6aqnlXORWqKxGqoTCuL577CsFJlDlykr/8zIsl1Sig==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqjckrqc2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 06:04:21 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3965ba1ba3eso6598555a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 23:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789538660; x=1790143460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mFosAaz6UPx9OA6FwJ3No1+Iy0gVjIHm51A34F9fnWc=;
        b=NUWm1LFJV5YAEmrcL0k/8Xz/Ak2Qw3W1c/0yiEGeZFqBNibQY/f7E5a5l6VD/HzMMO
         7NrgsVIYScn2SYCExExkNmYarh4CIj32z9cKbrSSxFw80lEuWhyG/E57EqtBXaxXhhWB
         G4RN2NI61oqanLjh31gdQlJZ2zr7Fny+vkcu0sTsu2K9If7YhqZ2lOJ6QOXwMsL4MO4R
         tgLl4i9d8wF/Iq8Q39gb0SvvkJ9aCsyXCERp9JqnfphQ0zSqSFziL4WVEG7YlJAiXN4P
         SdFyDFR5YINQge30PtWJ4DV+zBDuLxidKyTvB53FHMLH892Ty2GY413ob3lFV/1LHU3e
         9JSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789538660; x=1790143460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mFosAaz6UPx9OA6FwJ3No1+Iy0gVjIHm51A34F9fnWc=;
        b=03PAIv+P11Fyis3UblkgxHSO0hJeoV5H1aT1twzhKGjMhqk13rhJtkD9qW2RdaahmO
         SZ0gMYHUj0sUMUBzHVxEw6J+ykULdPwuN7DOHdFswviK/QyV+QY0DJ5cJJELtDhfuMoX
         cGBgIIqqR6QjL4KSFbN1poFdBns51Gvk5YegeZxnuFDpfpT5O5tIyV+ceHNjCKPrKnYY
         GHaR6lCK6aDAAr974VyuICsaNlGvYc01sg3DmEP9JHxao+E7+RG66TQdSFKIisJzz7Rw
         vig4NmqQWaOhqHmIEBh9Dr82UZgWMRXxSpIpkbxcyPt4VSei/HnrVY4R4KESoZoWky9z
         4Jcg==
X-Gm-Message-State: AFuF++kkpEM8zPbYCyLVVW+AbsyiJGSTvCo+mVPNc8NedEcDOcdD5wVa
	9Pav4HD9JUhuDxzl2p48J2iHX5cTBuBB/pjLfUXkj9RTj7OK4tswU/zkj7D6K8/z/ACLDhwbrX2
	JlHAf8ecObp5QwFnu0A/phqKa6qbWKzq8D4DwrFvnd7X8e5IUUXUlwjbDb29GVDmlGetgEQ==
X-Gm-Gg: AYBFou36vmDXumedSFDC42MwWKwnwQm6f2FDIamtdrasZkXai9N+n5d4n2iKrkWmoi/
	xwP7A4qRcyeCqY8vtMdUCBSLe/WiLDyQtH6/t4HETkw3YbW8VoLHHuqqYQtUckCi+KswUYz55mW
	yE65VtIzrRcTORUGmpElfNWoKqL3MHIWSF3oSRDrxqZO3vyMxNsz0D6JBBYIGTCuQaco79VpXUx
	4k/yBfSVECm6lJQSktctx3ISKPzsCkgSdUjjNNcTS58SO3ilpcsrxTSWXmQ3J2HjzgmgYv5CxDF
	Pb+Fddy6+wOVpsM1mS3mDX3jfNdJZc69jFxxWhW0J/NlM/00QahbSGQt7UrSpSe2jpDxvkgWcxX
	0ToxZuiFBdXAjk6SHGV/YE1cTvRyw/9AhTpYiWqk67Bq+1//dSxySo0/e1DO3PiC/pIweD5J6om
	B8YtZhFVQRzCvRyw==
X-Received: by 2002:a17:90a:d407:b0:39e:b7:cbe8 with SMTP id 98e67ed59e1d1-39e1e55f7b0mr3519802a91.5.1789538660506;
        Tue, 15 Sep 2026 23:04:20 -0700 (PDT)
X-Received: by 2002:a17:90a:d407:b0:39e:b7:cbe8 with SMTP id 98e67ed59e1d1-39e1e55f7b0mr3519746a91.5.1789538660030;
        Tue, 15 Sep 2026 23:04:20 -0700 (PDT)
Received: from QCOM-kZLYnuwaz1.na.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1b7a7a1csm2661491a91.15.2026.09.15.23.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:04:19 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
To: ath12k@lists.infradead.org, kang.yang@oss.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-next 6/6] wifi: ath12k: avoid double DMA unmap of held monitor RX buffers
Date: Wed, 16 Sep 2026 14:03:25 +0800
Message-ID: <20260916060325.854-7-kang.yang@oss.qualcomm.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
References: <20260916060325.854-1-kang.yang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfX2FCi1xXNyYIg
 xs9JwER2zScieE6zSmufQfFImkDQwu7nsUc3qgDJ9audHmAZganjDa0xjvXnF+nMvAt94JSEtgY
 h0N2AAMlv4JCT065uvuGeW8uGFmGqLM=
X-Authority-Analysis: v=2.4 cv=PsIG/AM3 c=1 sm=1 tr=0 ts=6aaa3165 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=ylsU60PWf4TVeRcojBcA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: xCZ32jc4Z3C0Rjh-FAMA-oAU2E8SJ95p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDA3NiBTYWx0ZWRfX4OZxE+pnigBP
 D7dOGRmuOPB7PM3fto1BiUYvmYmbTDbeuQW9XR/fQtmsMDxyGQPy6CkvIXFpgLqPr4XlXohzIjb
 gw0dKq6rE+DzjpI158dC6Ohebk7GVjfSd8AIjCLeu2jAD87E9CYHm7jv4r8bNGAGxp0AJ+LlM5H
 OVq+G59nlObEbRSUQcgI/QSxB3jnmzwzeVlt5OejF2/qNgaz+PQPp5/QTyGW7lD037SvdUdc7yg
 7NM+0fcRcgGB1DYiItZXYt7GcQtL+204IlCGxe85sf1cX0nOXEvm/zsDtVU8Yxze5zhzKvdb8X0
 n8e3h9dPHroJ6itIa3SSa7Np3y1twP92p1C9MlcsD4VD0FMaYVFfgCac43vGPtfIVV4Zk3Ngq5g
 pt+gXQ4cUW7Mow/h+7gy0ZiBQcpT4s2G90gdvCdQ3/Zcy5mIbVaJPBznfXwTD+5+uf/uMnDpf7i
 aquul10T9nUJa+iNgEw==
X-Proofpoint-GUID: xCZ32jc4Z3C0Rjh-FAMA-oAU2E8SJ95p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 phishscore=0 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160076

ath12k_dp_cc_cleanup() assumes that every rx_desc_info entry with a
non-NULL skb still has an active DMA mapping and therefore always
calls dma_unmap_single() before freeing the skb.

This assumption is not true for the monitor RX path.
ath12k_wifi7_dp_rx_mon_mpdu_pop() may DMA-unmap a buffer and mark
rxcb->unmapped before returning early to hold the MSDU for later
reprocessing. In that state desc_info->skb remains populated, so
module removal can trigger a second dma_unmap_single() from
ath12k_dp_cc_cleanup().

IOMMU reports the issue as:
  dma_unmap_phys()
  dma_unmap_page_attrs()
  ath12k_dp_cc_cleanup()
  ath12k_dp_cmn_device_deinit()
  ath12k_core_stop()

Skip dma_unmap_single() when rxcb->unmapped is already set and free
the skb directly.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index ef9601152f81..92278ac8f633 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -998,10 +998,11 @@ static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 				if (!skb)
 					continue;
 
-				dma_unmap_single(ab->dev,
-						 ATH12K_SKB_RXCB(skb)->paddr,
-						 skb->len + skb_tailroom(skb),
-						 DMA_FROM_DEVICE);
+				if (!ATH12K_SKB_RXCB(skb)->unmapped)
+					dma_unmap_single(ab->dev,
+							 ATH12K_SKB_RXCB(skb)->paddr,
+							 skb->len + skb_tailroom(skb),
+							 DMA_FROM_DEVICE);
 				dev_kfree_skb_any(skb);
 			}
 
-- 
2.34.1

