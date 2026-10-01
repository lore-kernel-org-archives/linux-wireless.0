Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3520489FD8
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 08:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790843990; cv=none; b=AmmRP2DeLpMMVzOCsf0veNtGzvldBHmXcqkhSe+MA9zdITXNdYOxtVdbbt01eQEV+DTKsjcEE0i7DMw1JNene6hdEUvnri8h2GW9jhYbwoia8VAml5PnVSUeLuv2nc4WNHwP34kRTW8axysSSW7/Bduc2Bz1cezraL4w8cNMdtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790843990; c=relaxed/simple;
	bh=SA/qGOFac7QuqaLiBROHlBxbmIF2tAj5dhULMm5dpTY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I3JTuqjRah6mNWCpxZAWj6LvVtCluu6IJJiY0KbVV40+xw5L0eWZKzQGo5Sr73cYgSaiu/PbtH/0GNsqw1CByW5zcv7MHJ9W6iS62PEcUbyjkXALWFE1GSlH5jyqUZJPF+CSXbiuOPfo53FkxIBzhmlFy0YE9E+jbtU6wynzdto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BB97+R5g; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EPiV3siB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BB97+R5g";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EPiV3siB"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6916xLUm1932317
	for <linux-wireless@vger.kernel.org>; Thu, 1 Oct 2026 08:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=bRQ3k+nW+Npo9QlflQkoUYD6pGHgSJoCtnk
	YceAyjUA=; b=BB97+R5gLiwDRhMLU0TBpaBkHH22mNtEY2LxEdk39j3AFI1uMUV
	fcmXEht7iQfTIIjfGdk7etjauCLeMtAVFZ58gTwcb2NMNyZ8CTFwFFAcgnwRo5sU
	3BoaMEh8n3O9oE2SDy0GU33/kRVko58x8WHmWqkWGgh9jM+slvylTs1ppxV2owd8
	obaSjWJ93O3GWN91jH1WOgdD3farD4Zm0SQca+yFcpeMeRCjHPu1/3knU3lqfQgU
	QUVzJDHYKJ0NZKGjcWnZBcOKJETiyVypVk+wdA8CuWVVK3UlvITGTrd5epz5BhqI
	nTjjTZeO/FEL1cZloZZnuZoPjgwun/i1RPg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h1bh59vxx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 08:39:47 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39512608fb1so10004907a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 01:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790843987; x=1791448787; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bRQ3k+nW+Npo9QlflQkoUYD6pGHgSJoCtnkYceAyjUA=;
        b=EPiV3siB2VoL3su4eZDxWnFCYiBYOIpE/eLR8CXFA9WYShpYOUDWDyj0jsB55eWeYd
         s2ijU03MX0PlnOgoiCRGJ2k8f3/C6zwNFDBKmEp37/pUo5gLZQFBeEvxdkgaz4BHq0tm
         X8278pYcXT2a4aozo6wF07gYs3UYISERP3H+1/bBppdido40UMu5hHHdVSkBbtPXBtUC
         RDNPpS0X7aHtw8ShCRpDEKb2BobJHmvTxJeRInwot8x6bdwMl9i52rCfgxlew+VjlvlD
         th0eQAni/3kSsro0Is/m+b7TeYfqTbeSyjpkR+JzFXPAWkYl//rv45cde99cdi0dLSgY
         FRwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790843987; x=1791448787;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bRQ3k+nW+Npo9QlflQkoUYD6pGHgSJoCtnkYceAyjUA=;
        b=CezQxOzPCjt9y+r1lzzmsH5jQNbGTBpmddx6mi6GZpzN06eW1pWf/o5YoD8V4kcPCx
         vI/VccztPREZ9IgdXZmAivNwC9ESCnibxbWb70+jvyRFqWre4pypc+uxtVuylge8JgyU
         gbsBgDXOldl1r/qZXnvgokER28qOYab7V3VCY6XJxzYrYHXK3tpcxbt/n6cSj3l10dKs
         YsgiXwBsbjLQiX/5k0fl3HA6vBV41NzTWWolj0TYYhF44mBVlzZ7JjT5/kDr3xEX8WLm
         XK2JirvugIhOz4fLNBHeUwGC2+q1IbIry3tlN4/29oXAvgoSJN8oL65+J9tn6AKmzpuP
         s12g==
X-Forwarded-Encrypted: i=1; AKwUvBxvLU9b+Sa9HM0VCw8jwEnjkSEPTFC4l9ECqSHI7syjfbsbtt8PUjyBiU1BiwRFULM/w8NUUwY5ikji9gzuvA==@vger.kernel.org
X-Gm-Message-State: AFq9FYInSfh4L1C/49mvB1w7kK4mjf8kkQPhO7a8SKmWtW38eCOHcetN
	mWu7JlTcjOz6z0jvbBiwmJn0H38ggBuuNU7rVeSVsjEYubZPkUajnP/tppwWLEKwF+H2gbI3ELU
	xZhR+bndrXlAnE4s433sozPeLJ7WBe4s4rGrrP4TZaP8S02CAsDF+6py5g0FPtBk+2UV6FQ==
X-Gm-Gg: AYBFou08KmyDDFkS7uiqJZI+3sFtNKtrxqhK6e5+ruZ5OZNO7IIYG4nglDIbZ2fH8WV
	R4YtY4b/YPAQtSgIxzPDbXUW0NFaDy1ce1Lu3itPtn+fjRik8pYVvpOQdaXtNQcoixzddViw/+S
	OfRms+T7IW1uODgeug26nguTQg94jSL2piYqI5W0pBGdo18ANaB+7W45wug5RWNBNTfaofb8ipd
	rMl0v4sYLWwueqf7cDtb1Tigr8aWRh7g+inSprrqsDOyVPfc652Zrj87jN3AcuE7C8C7aZuqoEa
	ZreF0vcAPcZe2k74FgnMnELfW8b77LFJ6YY2eBApTpbVRwexvOWFkUWvLVI4/3kGJJZvlfKeJfM
	P2l6B6nTDi4MEE6+ug7XaF0AwuLfAcg3XXPPj4AQyt8b7dLp8xTAqmOqn
X-Received: by 2002:a17:90b:3cc5:b0:39e:21a7:5dff with SMTP id 98e67ed59e1d1-3a4d1526e57mr3371703a91.11.1790843986639;
        Thu, 01 Oct 2026 01:39:46 -0700 (PDT)
X-Received: by 2002:a17:90b:3cc5:b0:39e:21a7:5dff with SMTP id 98e67ed59e1d1-3a4d1526e57mr3371677a91.11.1790843985666;
        Thu, 01 Oct 2026 01:39:45 -0700 (PDT)
Received: from sdciot-sh03-lnx.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f478e750sm3423362a91.13.2026.10.01.01.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 01:39:45 -0700 (PDT)
From: Gaole Zhang <gaole.zhang@oss.qualcomm.com>
To: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        jeff.johnson@oss.qualcomm.com, baochen.qiang@oss.qualcomm.com,
        rameshkumar.sundaram@oss.qualcomm.com
Cc: gaole.zhang@oss.qualcomm.com, gaolez@qti.qualcomm.com,
        miaoqing.pan@oss.qualcomm.com, hangtian.zhu@oss.qualcomm.com
Subject: [PATCH v2 ath-next] wifi: ath12k: Add EHT capabilities to scan probe frame
Date: Thu,  1 Oct 2026 16:39:40 +0800
Message-Id: <20261001083940.3051840-1-gaole.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 0ogHFAqKfDWH08V7eIfeBv7E3ZZmciS6
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNCBTYWx0ZWRfX+iUM0JSUlHni
 7M5lLI+J6rpsDWF5/J6x6PRy5O9vRVBE+RHPo+dAwDcl/lCd1+nwigh3kJtDk7yGKR8wlf8jeh0
 suYjMYVgYKdY21If/0uN4MP1EgQNdew=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNCBTYWx0ZWRfX4dN2bo1u+tlv
 zEuKPGpvcOibKRrSAHq7wFWZTEo3Ey+W3q3o1e2AjDk+Y45j+IrOrdj5UIK/4sbTu9QHAuQWaYU
 FNt0WgyTMkEtjzu1AHx9o+vkUYuSHUyWotsLhmzJbYPsPYOt78Y9b3BztumI5cpgMX/gWVuzByP
 YPBmPpVaErr+042/WrsSUO+zSY9bLwTszUQrWozaP/Jy4uT8Cl8fBjoiv1O5WAuVes+KvtizSqt
 wIZUh6H7rkrRvEc/QD/yWu89zWhrGuWUTLhztIxesJG3+2oOicRrCKduhlEOXT06qJgC7Y+3W6V
 O0meqQjGw9lBRFBbkrbDeuATn83vNjCl7dizJdvgoBkVNzP2O4tzBb6f6VfWoPckyGFgRepHpMV
 SqpTiL1zj7M8NZW99n3ShOMTX2WwSYT7PRaN8Bm3g9IxUU5GF5zrGO8GmJaogg1f8mRDw3zfacz
 YkEl1tYQ/PBvEH/B1VQ==
X-Authority-Analysis: v=2.4 cv=NuxE4MdJ c=1 sm=1 tr=0 ts=6abe1c53 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=VPXuAqNVT2ewv9QJR4oA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: 0ogHFAqKfDWH08V7eIfeBv7E3ZZmciS6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 phishscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610010034

ath12k hardware scan Probe Request frames do not include the EHT
Capabilities element. Without this element, an AP cannot identify the
STA as EHT-capable during active scanning and may omit EHT-related
information from its Probe Response. This can result in incomplete scan
information and prevent userspace from correctly determining the AP's
EHT capabilities.

For firmware to include the EHT Capabilities element in scan Probe
Request frames, two conditions are required:

  - The scan channel must have WMI_CHAN_INFO_ALLOW_EHT set, which allows
    firmware to add the EHT Capabilities element to Probe Request frames.
  - The EHT Capabilities element must be configured on the vdev through
    WMI_VDEV_SET_IE_CMDID, so firmware can use it when building Probe
    Request frames.

Set WMI_CHAN_INFO_ALLOW_EHT for channels when 11be is supported by
firmware and not disabled by ACPI. Also configure the EHT Capabilities
element before each hardware scan when the element is present in the
mac80211 scan IE buffer.

Firmware retains the configured element in the vdev context until it is
replaced or the vdev is deleted. However, ath12k scans may either reuse
an already started vdev or create a temporary scan vdev that is cleaned
up after scan completion. Sending WMI_VDEV_SET_IE_CMDID for each scan
request ensures correct behavior in both cases.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Gaole Zhang <gaole.zhang@oss.qualcomm.com>
---
v2:
 - Clarify the firmware requirements for adding the EHT Capabilities
   element to scan Probe Request frames.
 - Explain why the EHT Capabilities element is configured before each
   hardware scan, covering both reused vdevs and temporary scan vdevs.
 - No code changes.

 drivers/net/wireless/ath/ath12k/core.h |  6 ++++
 drivers/net/wireless/ath/ath12k/mac.c  | 29 +++++++++++++--
 drivers/net/wireless/ath/ath12k/reg.c  |  4 +++
 drivers/net/wireless/ath/ath12k/wmi.c  | 50 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wmi.h  | 23 +++++++++++-
 5 files changed, 109 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index a98fc6e0699d..e7373a523dc3 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -1394,6 +1394,12 @@ static inline struct ath12k *ath12k_ah_to_ar(struct ath12k_hw *ah, u8 radio_idx)
 	return &ah->radio[radio_idx];
 }
 
+static inline bool ath12k_is_11be_enabled(struct ath12k_base *ab)
+{
+	return test_bit(WMI_TLV_SERVICE_11BE, ab->wmi_ab.svc_map) &&
+	       !ath12k_acpi_get_disable_11be(ab);
+}
+
 static inline struct ath12k_hw *ath12k_ar_to_ah(struct ath12k *ar)
 {
 	return ar->ah;
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index d4116ba0da08..f353af63c5eb 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -5602,6 +5602,25 @@ ath12k_mac_find_link_id_by_ar(struct ath12k_vif *ahvif, struct ath12k *ar)
 	return ATH12K_FIRST_SCAN_LINK;
 }
 
+static int ath12k_mac_set_scan_eht_cap_ie(struct ath12k *ar,
+					  struct ath12k_link_vif *arvif,
+					  const u8 *ies, size_t ies_len)
+{
+	const struct element *eht_cap;
+
+	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
+
+	eht_cap = cfg80211_find_ext_elem(WLAN_EID_EXT_EHT_CAPABILITY, ies,
+					 ies_len);
+	if (!eht_cap || eht_cap->datalen <= 1)
+		return 0;
+
+	return ath12k_wmi_vdev_set_ie(ar, arvif->vdev_id,
+				      WLAN_EID_EXTENSION,
+				      eht_cap->data, eht_cap->datalen,
+				      WMI_SET_VDEV_IE_BAND_ALL);
+}
+
 static int ath12k_mac_initiate_hw_scan(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_scan_request *hw_req,
@@ -5718,6 +5737,13 @@ static int ath12k_mac_initiate_hw_scan(struct ieee80211_hw *hw,
 			goto exit;
 		}
 		arg->extraie.len = req->ie_len;
+		ret = ath12k_mac_set_scan_eht_cap_ie(ar, arvif, req->ie,
+						     req->ie_len);
+		if (ret) {
+			ath12k_dbg(ar->ab, ATH12K_DBG_MAC,
+				   "failed to set eht cap ie, ret %d\n", ret);
+			goto exit;
+		}
 	}
 
 	if (req->n_ssids) {
@@ -8983,8 +9009,7 @@ static void ath12k_mac_copy_eht_cap(struct ath12k *ar,
 
 	memset(eht_cap, 0, sizeof(struct ieee80211_sta_eht_cap));
 
-	if (!(test_bit(WMI_TLV_SERVICE_11BE, ar->ab->wmi_ab.svc_map)) ||
-	    ath12k_acpi_get_disable_11be(ar->ab))
+	if (!ath12k_is_11be_enabled(ar->ab))
 		return;
 
 	eht_cap->has_eht = true;
diff --git a/drivers/net/wireless/ath/ath12k/reg.c b/drivers/net/wireless/ath/ath12k/reg.c
index 89abf2e87ad1..0aba1e74a3e9 100644
--- a/drivers/net/wireless/ath/ath12k/reg.c
+++ b/drivers/net/wireless/ath/ath12k/reg.c
@@ -140,6 +140,7 @@ int ath12k_reg_update_chan_list(struct ath12k *ar, bool wait)
 	enum nl80211_band band;
 	int num_channels = 0;
 	int i, ret = 0;
+	bool has_eht;
 
 	if (ar->ah->state == ATH12K_HW_STATE_RESTARTING)
 		return 0;
@@ -180,6 +181,8 @@ int ath12k_reg_update_chan_list(struct ath12k *ar, bool wait)
 
 	ch = arg->channel;
 
+	has_eht = ath12k_is_11be_enabled(ar->ab);
+
 	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		if (!(ar->mac.sbands[band].channels && bands[band]))
 			continue;
@@ -201,6 +204,7 @@ int ath12k_reg_update_chan_list(struct ath12k *ar, bool wait)
 			ch->allow_ht = true;
 			ch->allow_vht = true;
 			ch->allow_he = true;
+			ch->allow_eht = has_eht;
 
 			ch->dfs_set =
 				!!(channel->flags & IEEE80211_CHAN_RADAR);
diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index a63bbda0219c..5fe7af731a4e 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -2005,6 +2005,54 @@ int ath12k_wmi_p2p_go_bcn_ie(struct ath12k *ar, u32 vdev_id,
 	return ret;
 }
 
+int ath12k_wmi_vdev_set_ie(struct ath12k *ar, u32 vdev_id, u32 ie_id,
+			   const u8 *ie, size_t ie_len, u32 band)
+{
+	struct ath12k_wmi_pdev *wmi = ar->wmi;
+	struct wmi_vdev_set_ie_cmd *cmd;
+	struct sk_buff *skb;
+	struct wmi_tlv *tlv;
+	size_t aligned_len;
+	int ret, len;
+	void *ptr;
+
+	aligned_len = roundup(ie_len, sizeof(u32));
+	len = sizeof(*cmd) + TLV_HDR_SIZE + aligned_len;
+
+	skb = ath12k_wmi_alloc_skb(wmi->wmi_ab, len);
+	if (!skb)
+		return -ENOMEM;
+
+	ptr = skb->data;
+	cmd = ptr;
+	cmd->tlv_header = ath12k_wmi_tlv_cmd_hdr(WMI_TAG_VDEV_SET_IE_CMD,
+						 sizeof(*cmd));
+	cmd->vdev_id = cpu_to_le32(vdev_id);
+	cmd->ie_id = cpu_to_le32(ie_id);
+	cmd->ie_len = cpu_to_le32(ie_len);
+	cmd->ie_source = cpu_to_le32(WMI_SET_VDEV_IE_SOURCE_HOST);
+	cmd->band = cpu_to_le32(band);
+
+	ath12k_dbg(ar->ab, ATH12K_DBG_WMI,
+		   "WMI set ie vdev_id %u ie_id %u ie_len %zu band %u\n",
+		   vdev_id, ie_id, ie_len, band);
+
+	ptr += sizeof(*cmd);
+	tlv = ptr;
+	tlv->header = ath12k_wmi_tlv_hdr(WMI_TAG_ARRAY_BYTE, aligned_len);
+	memcpy(tlv->value, ie, ie_len);
+
+	ret = ath12k_wmi_cmd_send(wmi, skb, WMI_VDEV_SET_IE_CMDID);
+	if (ret) {
+		ath12k_warn(ar->ab,
+			    "failed to send WMI_VDEV_SET_IE_CMDID for vdev %u ie %u: %d\n",
+			    vdev_id, ie_id, ret);
+		dev_kfree_skb(skb);
+	}
+
+	return ret;
+}
+
 int ath12k_wmi_bcn_tmpl(struct ath12k_link_vif *arvif,
 			struct ieee80211_mutable_offsets *offs,
 			struct sk_buff *bcn,
@@ -2946,6 +2994,8 @@ int ath12k_wmi_send_scan_chan_list_cmd(struct ath12k *ar,
 				chan_info->info |= cpu_to_le32(WMI_CHAN_INFO_ALLOW_VHT);
 			else if (channel_arg->allow_ht)
 				chan_info->info |= cpu_to_le32(WMI_CHAN_INFO_ALLOW_HT);
+			if (channel_arg->allow_eht)
+				chan_info->info |= cpu_to_le32(WMI_CHAN_INFO_ALLOW_EHT);
 			if (channel_arg->half_rate)
 				chan_info->info |= cpu_to_le32(WMI_CHAN_INFO_HALF_RATE);
 			if (channel_arg->quarter_rate)
diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index b508aa759bd8..e51b3bdab77b 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -3075,7 +3075,8 @@ struct ath12k_wmi_channel_arg {
 	    allow_vht:1,
 	    allow_he:1,
 	    set_agile:1,
-	    psc_channel:1;
+	    psc_channel:1,
+	    allow_eht:1;
 	u32 phy_mode;
 	u32 cfreq1;
 	u32 cfreq2;
@@ -3694,6 +3695,7 @@ struct ath12k_wmi_scan_cancel_arg {
 #define WMI_CHAN_INFO_DFS_FREQ2		BIT(16)
 #define WMI_CHAN_INFO_ALLOW_HE		BIT(17)
 #define WMI_CHAN_INFO_PSC		BIT(18)
+#define WMI_CHAN_INFO_ALLOW_EHT		BIT(21)
 
 #define WMI_CHAN_REG_INFO1_MIN_PWR	GENMASK(7, 0)
 #define WMI_CHAN_REG_INFO1_MAX_PWR	GENMASK(15, 8)
@@ -3845,6 +3847,23 @@ struct wmi_p2p_go_set_beacon_ie_cmd {
 	__le32 ie_buf_len;
 } __packed;
 
+#define WMI_SET_VDEV_IE_SOURCE_HOST	0
+
+enum wmi_set_vdev_ie_band {
+	WMI_SET_VDEV_IE_BAND_ALL,
+	WMI_SET_VDEV_IE_BAND_2_4GHZ,
+	WMI_SET_VDEV_IE_BAND_5GHZ,
+};
+
+struct wmi_vdev_set_ie_cmd {
+	__le32 tlv_header;
+	__le32 vdev_id;
+	__le32 ie_id;
+	__le32 ie_len;
+	__le32 ie_source;
+	__le32 band;
+} __packed;
+
 struct wmi_vdev_install_key_cmd {
 	__le32 tlv_header;
 	__le32 vdev_id;
@@ -6583,6 +6602,8 @@ int ath12k_wmi_pdev_resume(struct ath12k *ar, u32 pdev_id);
 
 int ath12k_wmi_send_peer_assoc_cmd(struct ath12k *ar,
 				   struct ath12k_wmi_peer_assoc_arg *arg);
+int ath12k_wmi_vdev_set_ie(struct ath12k *ar, u32 vdev_id, u32 ie_id,
+			   const u8 *ie, size_t ie_len, u32 band);
 int ath12k_wmi_vdev_install_key(struct ath12k *ar,
 				struct wmi_vdev_install_key_arg *arg);
 int ath12k_wmi_pdev_bss_chan_info_request(struct ath12k *ar,

base-commit: c3bace8584ca707e34ba837f65c2e9d566af4c2c
-- 
2.34.1

