Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6252834CCE
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 09:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791539747; cv=none; b=Nfx7V/bAMtLapl188qW2znGTnzuMkiEH8r2N1RjL5h3Cc/roob/TVnkWCcygMC7JPP/P+cFM+m4oxvLV2FFMvvtKOCcb8uUJrY5mADF6uhXI7htgXu5DzJan4l67BPTABlV7b/YrrcMG/msEi78frSn7Ag+Pq3KH7V6i/kK57+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791539747; c=relaxed/simple;
	bh=KZOWtIpFPi6FWrU8qurzoqrM1XZGp+rZeOVzjsOm+ts=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d+wYQe8uMdvMNX9ogvS9iYAtBSrk8Ku/4aySzwH7e6njkOxTuefBuy5Vq54D381XaHUuqW5SCRqMPyxIGCP5gCRpumQqFzmO8685tprIuAPH6Kk+4oHn9EbucMI4R9gtC+SxHCnHGM6e7Hh/M1e/CicO64oeL/A7DmpqfPJ/yTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ikkLQRZV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QtTPw1Cu; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ikkLQRZV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QtTPw1Cu"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6998KNUU3977795
	for <linux-wireless@vger.kernel.org>; Fri, 9 Oct 2026 09:55:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=6kyBbhVI0aFnvZ+fhobKvUuLqPpG3VNsDxh
	Ng/2+xIc=; b=ikkLQRZVgvtnLWpgh+IOfNYp1bTk14EFVFvKStYQ7OUMoitBUOP
	/G7vspCJAGQgKHVt7PbkGKZU6dDhznQyZ1NzmnPWhjyN4eW474j9bodo2o1YdN/C
	MkMZAsgzedrZWvtAPKJO1nknAOae+1iAnzU1fosM9HFAjgssR6Yxo0zbj/RAARUA
	NqsSfLau5KDHmz3B5KOfkoOu6aXW0SLCvFxiDJ15pukjNzmNFcn0paAxRETmg76o
	/JDRO76c09YLKBEaqa6b7klvXvUkcEOliJt356hjXzPNN/EOCqSiqQGHNKaInFB4
	3TEx3XvE/A0KPwqtWLneMAAC37YNMa1DU+Q==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6ev5b994-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 09:55:45 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30bcb065bfdso11959315eec.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 02:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791539745; x=1792144545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6kyBbhVI0aFnvZ+fhobKvUuLqPpG3VNsDxhNg/2+xIc=;
        b=QtTPw1CuyuZg1oj/mFl6qsmB2Z6xsL/J2GyRsbYvMa3khHtpxPaZVwm5Kplcg1EGdH
         7SLoB995wJXCqDRVVxj3DxVDcteARkJU1XRz2z7ZqLKQRfBSl+bDiID1Iypha07YUeaH
         vTXkNscOYtVicNuB6awKLclKdPYrD6f7HQgza39rqS5v0WORNf/cXfgFaDCtmeg4uRvZ
         gX8B5+knj05d8wyKF7HbO4KJzA7CqJBfKl91D95nnfmImJ/SezrssPf4AplUJs9cmRLU
         8LBW1inroCzFmyCfV2kZrfK9oYOxNWngZO+t9zi0KnC0wENtFcb1Hx4wXpMbQuQCP+U4
         x6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791539745; x=1792144545;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6kyBbhVI0aFnvZ+fhobKvUuLqPpG3VNsDxhNg/2+xIc=;
        b=1wX6NkwAWjrKwMXFKCG3aLWk8Tsbkyvoc2AmH0chCl+kQ7Hz/G6XDEciogNu77Wi66
         hkDU9JuwG4VSiJRQytugmuze/w9w1TlNH4VuKb1cr+0/D7BvpFv99gXt4MWsBLgX8Y0T
         /pEefQbk5mJJrqjgBVKvqw3ZoBILDKBgm3pfqZ3l6NCCB4Gw88Ki6Y/9+cZ8heXHbww2
         mg8SRz2zK8yI6vvGJTwbiA8XrlpIz/UYrXQPJzlQlCot0sXhyIOAxq9Q/xCax8gAgUHX
         9b+s5tAyyEVdqt6bmmv4uZ97zHaRPi6f+C4VOkQWttZol5fKG/9RaaFOPDoAo9D0nVvA
         HhXg==
X-Forwarded-Encrypted: i=1; AKwUvBwZTH6crGGKX9vzzYu3YghIYpa5pgUbumwNAUrlTwYJQtpI0/jhhxx8yhZzkkAVUT/IZIk/QLqd7eBFDkoVcg==@vger.kernel.org
X-Gm-Message-State: AFuF++myi2/06JeRm7cwR7JNbHhV5EW++w0hgq7ktQ3miVr6rYtCiti1
	sSnKrqDdeLGqkb2nhSLHQ93jG8Sfi8t6M3mi6QfRNXiTeBCmqdJSUcl+8v9VmU9AmFFcZXZ0Wba
	3BKlRYiWoVXAu7gUl2a4mlpBkuxjjs7kEmRyqh6J+LxhVWJpmQoZG3OjinUNumK6Wre5eLA==
X-Gm-Gg: AYBFou2wdfxUK6qRZqNe9IPPQpiW4IB1S5enYNCiQRs3nNvixiBSRz256mtAv8jlULe
	362HgmOohh4348Or6DCYPE6aXVlBjynb0tiGZ2HmxhYcMt14oC4EsT2H51Zku49XLNremWqNUXI
	lvRB4eD/zmPg0P9y0NP41kIN30soiHZ7SNBOda3jjgJzk0Gvb0cT5a2x6cqqQQsL10JYptSFBzs
	xvhNkdqW8x7xmSokXgrwg+gJvlmgnuIxYOqgdAjq/Ayq9PnBvZjkV0H4BmLTKoFUul6/vZaT/DJ
	MhXJg+GSAgpucIsjcZriIfml+BzHrgzjxf5InxYmDVgERHju8/irQKgIhG8CJkqCTIznS4eMqfp
	RQTbWzZ+1vGZs9CjJTxf0bR9bU2aLOs17qGo0P6Kb/MiYjJ/rHl4G46ZC
X-Received: by 2002:a05:7022:1581:b0:14a:583a:8ddb with SMTP id a92af1059eb24-16a6043cbf1mr2238661c88.31.1791539744557;
        Fri, 09 Oct 2026 02:55:44 -0700 (PDT)
X-Received: by 2002:a05:7022:1581:b0:14a:583a:8ddb with SMTP id a92af1059eb24-16a6043cbf1mr2238612c88.31.1791539743734;
        Fri, 09 Oct 2026 02:55:43 -0700 (PDT)
Received: from sdciot-sh03-lnx.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a32eb7ebsm6479076c88.12.2026.10.09.02.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 02:55:43 -0700 (PDT)
From: Gaole Zhang <gaole.zhang@oss.qualcomm.com>
To: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        jeff.johnson@oss.qualcomm.com, baochen.qiang@oss.qualcomm.com,
        rameshkumar.sundaram@oss.qualcomm.com
Cc: gaole.zhang@oss.qualcomm.com, gaolez@qti.qualcomm.com,
        miaoqing.pan@oss.qualcomm.com, hangtian.zhu@oss.qualcomm.com
Subject: [PATCH v3 ath-next] wifi: ath12k: Add EHT capabilities to scan probe frame
Date: Fri,  9 Oct 2026 17:55:38 +0800
Message-Id: <20261009095538.2718979-1-gaole.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDAzOSBTYWx0ZWRfX5YWZfpg5GXcV
 QiRse+yk+5MxclUSYtvZ7Av52D7tTUcGrEquoGQhM7Xdsv4sd4d4ST8Mqo9mhouXYdI12An8GSK
 gHpk7wQoXyyxk5w1YRaGdR3v5SjAbZU=
X-Authority-Analysis: v=2.4 cv=MMT1C8Zl c=1 sm=1 tr=0 ts=6ac8ba21 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=VPXuAqNVT2ewv9QJR4oA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: qIQc9RuRCiNfiR1fiGAoEyXx7rNj7xhh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDAzOSBTYWx0ZWRfXxPImOwllo5HM
 tyKOPrxvkUU9421himQzopDmWP5GLhm7z5vXXZ3J2F8jMwh6EDYd8hxzja4jHZT8vOZNA8swzNL
 Uo7Vx9jzCgvFi/Wy0uHawFSwv2MliJdU0EkVB0Q7suFuNvMHQpbcRcre3BkVtVf7+9M6QiYnClo
 D0sCjafLgpCAv0Nz0CfM+taKpfVULq6I/O/62eC4C0ru14Y8OdlxaLF0+EmJe6VVPMzaY4pvUl8
 2EupbEN7WNSVP712r3U7Wv7hA/i/nVHESAoZLSupTjraUKc8xvQgXs56WDnnF0WruQ/pPh/LP41
 1GGGp0XDkFJj06oJ7aFFX2QVvyihr4cAe0HQj2RGKHAdgvgTM0jL3/m30KhCX1LLVzIpulhhLJ8
 8v5GwvY7RAN+9LZ8vXjC/Qo5/6hWoGT97+sorqk1bpQZB2oY3xj+r1gEfjfXZxFfoC2G9ljYJ9N
 knoIRlNHZ1xR2RhN7Ug==
X-Proofpoint-ORIG-GUID: qIQc9RuRCiNfiR1fiGAoEyXx7rNj7xhh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_03,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090039

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
v3:
 - Make EHT Capabilities IE programming best-effort during hardware scan
   setup. Log WMI_VDEV_SET_IE_CMDID failures and continue the scan instead
   of aborting it.
 - Move allow_eht next to the other allow_* channel capability flags in
   struct ath12k_wmi_channel_arg.

v2:
 - Clarify the firmware requirements for adding the EHT Capabilities
   element to scan Probe Request frames.
 - Explain why the EHT Capabilities element is configured before each
   hardware scan, covering both reused vdevs and temporary scan vdevs.
 - No code changes.

 drivers/net/wireless/ath/ath12k/core.h |  6 ++++
 drivers/net/wireless/ath/ath12k/mac.c  | 27 ++++++++++++--
 drivers/net/wireless/ath/ath12k/reg.c  |  4 +++
 drivers/net/wireless/ath/ath12k/wmi.c  | 50 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wmi.h  | 21 +++++++++++
 5 files changed, 106 insertions(+), 2 deletions(-)

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
index d4116ba0da08..37293083babe 100644
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
@@ -5718,6 +5737,11 @@ static int ath12k_mac_initiate_hw_scan(struct ieee80211_hw *hw,
 			goto exit;
 		}
 		arg->extraie.len = req->ie_len;
+		ret = ath12k_mac_set_scan_eht_cap_ie(ar, arvif, req->ie,
+						     req->ie_len);
+		if (ret)
+			ath12k_dbg(ar->ab, ATH12K_DBG_MAC,
+				   "failed to set eht cap ie, ret %d\n", ret);
 	}
 
 	if (req->n_ssids) {
@@ -8983,8 +9007,7 @@ static void ath12k_mac_copy_eht_cap(struct ath12k *ar,
 
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
index b508aa759bd8..5d0afbf0bd0c 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -3074,6 +3074,7 @@ struct ath12k_wmi_channel_arg {
 	    allow_ht:1,
 	    allow_vht:1,
 	    allow_he:1,
+	    allow_eht:1,
 	    set_agile:1,
 	    psc_channel:1;
 	u32 phy_mode;
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
