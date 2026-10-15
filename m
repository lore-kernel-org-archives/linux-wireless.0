Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDE71FF7C5
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043700; cv=none; b=g4eL53B1LC+Pwjd1jSQTExSUErzm5CaEpB6I6iEnCDt2dvyFdOLgCFKL51ev3VIYHh5C3ca1sRiVnJUM6qWPaRAHOJciVSyqL89CAbw/rFMSfTnQsu0FdLNKK6M9HUYOr+VMPCW/jSlJ7IaSAf8d0E8SSgstT5N1c+madyTs5jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043700; c=relaxed/simple;
	bh=Em8SGfrUXiJQcxzZniF0bJk/QwJ1W14QWojlhFFSNNU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q4JSOJIWndKzjyMcX8J4/joHXMenWLtVdRJjyspxi2OqPqmEYdeJ6+PXs85FiKTFbUeeOK5WVj138o/4XQ3z7lO4zxNLzKtgwCUbnapCJZqc5JOkncD1Piva7fGWvXRpxmusYt6ygWHi2FqYE1sPVECQM1paj+5/zG6OejppAoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HctEAXU+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XDSzBtm9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HctEAXU+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XDSzBtm9"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F5phVE500313
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:54:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=QBpv3t6ikNd
	+LnVjYPe5kHl+Iat49RGi90R+sOLuZX0=; b=HctEAXU+w809R/dx1e0EDK/E4po
	fm0FZZSt7FvoZ6qhKgdW5pFPveQ+hVM0tiA/pA/dUa72MvZ6rKFrqoLz6tUGwlTD
	fFR5TXfX1qJtvxKliQK+Dj3N7rZqOPrukLyIIw+dkZk3sE6gNq5y+RGpH9lys/pV
	D7nqVmJGUj78OC7Z9ybF7zCTBgnjOGzfUo7gned8MTTA7DQ9Al+nNzBJ+76998A5
	Ru0vlnPN75Luh3lJ7PxB9crkUIBAI5wZNr4L11ZUVs+Kkja/ram7S2Wg8voqRLQG
	97ctSi7FEp+Y278oZzT1oL9dCforB10Aea/R2A5OWaa/Q8H3B/SABKL+45A==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4haagf3dp3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 05:54:57 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d001671a54so69252185ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 22:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792043697; x=1792648497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QBpv3t6ikNd+LnVjYPe5kHl+Iat49RGi90R+sOLuZX0=;
        b=XDSzBtm99UO5Rv3c4MOSvtt17FIgCnsJHEC+XTdUe8f6SZycfrs38S/0QHT6F+qGCo
         PP/IW5dwY3q5vgB+6ld3Ow9/GQZRvNOlkRLXtKBnW0xRHT3wNJ08v3opGyb1ONCcT7Hj
         TQIVholseHt4jY7TGQj5joWCaTwNSd5DkEp7QyOt4iv3okbSTygBESKfCLlvd5kquq6N
         OUx10NVE8GZORClY1Rj1oePqZsXrrGtn6hebYWJL3rGg6cUKzWffCfCyrupeG7kgguAl
         5EQ+RilaEZs51RURXOVqrd0mla6JrLecedkM47W9c4gAB28dLe1AejMq8pT+w5CSstEA
         9iEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792043697; x=1792648497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QBpv3t6ikNd+LnVjYPe5kHl+Iat49RGi90R+sOLuZX0=;
        b=oBtiVN9isesU/MJg/ZJYtA1lBPKEGkIoVfsCjeTw6csCNmvxZ4DfPdJT5RFG0WTe0O
         ioSVW9cykyBuFZ5ZyIF/jMXDIm9glpj8Gq2HODmvr8S0QxBPWOiDmxu+R8eiqm4NXiUx
         2kn0kZ5AaJQQo563SdJA9ndCcCulqxy7d1Kg360kEbr4e6B/+1ss0m4L3u6FLHZAsZ0T
         HRoCYKTHI54AoGS2zvxG+c68/nU/2urzkAhKA92wbDwk3NIEezdcjHPv786O/H5fLJOa
         euVZrMuhagb4+q5h2baObiOkO6W8Makskp3SzIt2pe9zd9CrfgnRsdsY/hWt8xj4FwPM
         p/eA==
X-Gm-Message-State: AFq9FYLZr3fGgdjB9TCUf7mJ478vIuBOE+p4S7pXkm2v/OsF685Wh6O/
	AXUbUI91iWulo5m2Gw0ys886Sju32czKPBMCT7E79D1MW+iWRNdr+0QkhAVgLlv2pzvf+sTQkqY
	ku3B3KSyuKFywdtM087whOgSiG4sGJwCvbeP+KlhnZHeKa4vxo45i/5BiFc8e6/ZmjrYcBQ==
X-Gm-Gg: AYBFou2qeezF43yw6uDkx8do2dYT5+n3FqSYw2aUj+5ZLfkATUty1HiRr225wAzBCc9
	bMlzpRwOgPn5HgQLVIUykgu468VYBYDZPWOB93FgeevJTi4sUV1d9Jva1KYJOwkGaimCqP6tYrh
	1SPUInmXRb7QOAFXy5/R8lqN9CbTcJJTLss6ICmafhzlhR+1UizYLxyOiO5qObp29bWFyEu+JFW
	3LLt4TppDv62eTEu2NMnxGr16sa0zaZd3Bmn8/oSSRypwOPAPi7qW/ESMnnWUvt1jXe9notIcId
	LB502c96orhWl9jR70B2bL1lhe2Ikyl9MMAsOo1KVMILQMF2o2RPDBrm8Uq65IaW1ad37+4/ON3
	Z1nMLCMiGbTV194nbJgp0SBrwqWq/X+Rx5HrVxdOcrilFCcUvUoMxAyh0qDcGIqgwX4/FLJTnzI
	QeZdzVtEAfZ61x
X-Received: by 2002:a17:90b:1645:b0:3ac:9a5e:9ce7 with SMTP id 98e67ed59e1d1-3ac9a5e9febmr1298565a91.49.1792043696694;
        Wed, 14 Oct 2026 22:54:56 -0700 (PDT)
X-Received: by 2002:a17:90b:1645:b0:3ac:9a5e:9ce7 with SMTP id 98e67ed59e1d1-3ac9a5e9febmr1298543a91.49.1792043695941;
        Wed, 14 Oct 2026 22:54:55 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac944af2f1sm2629054a91.15.2026.10.14.22.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 22:54:55 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Aishwarya R <aishwarya.r@oss.qualcomm.com>,
        Arun Vikas T <arun.t@oss.qualcomm.com>
Subject: [PATCH RFC wireless-next 2/7] wifi: cfg80211: add QoS Management data structures
Date: Thu, 15 Oct 2026 11:24:36 +0530
Message-Id: <20261015055441.680588-3-aishwarya.r@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261015055441.680588-1-aishwarya.r@oss.qualcomm.com>
References: <20261015055441.680588-1-aishwarya.r@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX+8GQs49Cs+wC
 SUg8Tb4fRZOszesls0Z2Nx9C0t870KDQMYX81G+Z/V7qivrHDsELC7nK2CN923SR8wddRcy49cJ
 +qMKJt8DSI62iueqvNxOIoHuxEu68xfb/tsH4CLSB+HFquZA5Xm6GqVYpYxf4fQ9CrJKc5GKUG0
 /LogfiUA0x1xHO7tbhqYTSgcHV/UUBgZt+VSSyqaMRiJ5kA3+KkPukb9wQb96beq6BJHQpia1qz
 EL8UDdx++0w928LJLMYdv3O5xWBg42HZnjFLTTIBA+GiSe1RNEEOmAQaH2/HdstOm7DA9cCNI5m
 huAaUtMuZGGjGW4W4BKcGgi42OGhQWTasTYog90f3nPxHEf3of1T2YdsIEaVgcwlyyt/MZMqvdi
 kpLCA5NTgCikKUm1+ueyj3sSy6zQfwQw6RlwhBx+xJfIfniaGcYMM/skBjQACz0Im7KswnGBaND
 YIYtEj1GJh1eP3y7YjA==
X-Proofpoint-GUID: tf57V7XNDOXOdwlzdCSqXEblAj1EpSdZ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAyMyBTYWx0ZWRfX0DDEnRzfA/es
 NGCBCVRrz3+Px14jeDyQa/CUmL0C4E+NYqHjBiFNRIPn1MpsarQnCA977Wk45O/Mx6fUaWWyXyR
 BtGiZ1WzOa1LdSIXfD7Ue7DqgvAZ+do=
X-Proofpoint-ORIG-GUID: tf57V7XNDOXOdwlzdCSqXEblAj1EpSdZ
X-Authority-Analysis: v=2.4 cv=V/noQuni c=1 sm=1 tr=0 ts=6ad06ab1 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=mZ3xVG7Sy6TkxvAkkpAA:9 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150023

Introduce cfg80211 data structures to support QoS Management (QM) requests
from userspace and the corresponding driver responses.

A QM request contains the peer address, protocol type and a dynamically
sized descriptor list. Each descriptor carries the requested operation and
SCS-specific priority, TCLAS type 4 or type 10 classification elements, and
QoS characteristics, and protocol-specific fields for SCS or MSCS.

Add the set_qos_mgmt_cfg() cfg80211_ops callback to deliver a parsed QM
request to the driver. The driver returns the processing result through a
cfg80211_qm_resp_data container populated with one response descriptor per
request descriptor. Each response descriptor carries the corresponding
qm_id together with an IEEE 802.11 QM status code indicating whether the
request was accepted or declined.

Co-developed-by: Arun Vikas T <arun.t@oss.qualcomm.com>
Signed-off-by: Arun Vikas T <arun.t@oss.qualcomm.com>
Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
---
 include/net/cfg80211.h | 220 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 220 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f773856c1818..74abe25bb107 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4860,6 +4860,216 @@ struct cfg80211_update_owe_info {
 	u8 peer_mld_addr[ETH_ALEN] __aligned(2);
 };
 
+/* QoS Management IP address lengths */
+#define QM_IPV4_LEN	4
+#define QM_IPV6_LEN	16
+
+/**
+ * enum cfg80211_qm_ip_version - IP protocol version identifiers used in
+ *	QoS Management traffic classification
+ * @QM_IP_VERSION_4: Internet Protocol version 4 (IPv4)
+ * @QM_IP_VERSION_6: Internet Protocol version 6 (IPv6)
+ */
+enum cfg80211_qm_ip_version {
+	QM_IP_VERSION_4 = 4,
+	QM_IP_VERSION_6 = 6,
+};
+
+/**
+ * struct cfg80211_qm_tclas4_params - TCLAS classifier type 4 parameters
+ * @classifier_mask: bitmask indicating which fields are used for
+ *	classification; the version bit is mandatory and the remaining bits
+ *	identify fields used for classification, as defined by
+ *	&enum nl80211_qm_tclas_type4_mask
+ * @ip_ver: IP version of @src_ip / @dst_ip
+ * @src_ip: source IP address (IPv4 or IPv6)
+ * @dst_ip: destination IP address (IPv4 or IPv6)
+ * @src_port: source port number
+ * @dst_port: destination port number
+ * @dscp: Differentiated Services Code Point
+ * @protocol: IP protocol number, valid for IPv4 only
+ * @next_header: next header field, valid for IPv6 only
+ * @flow_label: flow label, valid for IPv6 only
+ */
+struct cfg80211_qm_tclas4_params {
+	u8 classifier_mask;
+	enum cfg80211_qm_ip_version ip_ver;
+	union {
+		u8 ipv4[QM_IPV4_LEN];
+		u8 ipv6[QM_IPV6_LEN];
+	} src_ip;
+	union {
+		u8 ipv4[QM_IPV4_LEN];
+		u8 ipv6[QM_IPV6_LEN];
+	} dst_ip;
+	u16 src_port;
+	u16 dst_port;
+	u8 dscp;
+	u8 protocol;
+	u8 next_header;
+	u8 flow_label[NL80211_QM_TCLAS_TYPE4_FLOW_LABEL_LEN];
+};
+
+/**
+ * struct cfg80211_qm_tclas10_params - TCLAS classifier type 10 parameters
+ * @protocol_instance: protocol instance identifier
+ * @protocol_number: protocol number
+ * @filter_value: filter value bytes
+ * @filter_mask: filter mask bytes
+ * @filter_len: length of @filter_value / @filter_mask
+ */
+struct cfg80211_qm_tclas10_params {
+	u8 protocol_instance;
+	u8 protocol_number;
+	u8 filter_value[NL80211_QM_TCLAS_TYPE10_MAX_FILTER_LEN];
+	u8 filter_mask[NL80211_QM_TCLAS_TYPE10_MAX_FILTER_LEN];
+	u8 filter_len;
+};
+
+/**
+ * struct cfg80211_qm_tclas_elements - a single TCLAS element
+ * @up: user priority
+ * @classifier_type: classifier type, see
+ *	&enum nl80211_qm_tclas_classifier_type
+ * @tclas_elem: classifier-specific parameters
+ */
+struct cfg80211_qm_tclas_elements {
+	u8 up;
+	enum nl80211_qm_tclas_classifier_type classifier_type;
+	union {
+		struct cfg80211_qm_tclas4_params type4_params;
+		struct cfg80211_qm_tclas10_params type10_params;
+	} tclas_elem;
+};
+
+/**
+ * struct cfg80211_qm_qos_attributes - QoS attributes of a QoS Management
+ *	request
+ * @direction: traffic direction, see &enum nl80211_qm_direction
+ * @tid: traffic identifier
+ * @up: user priority
+ * @bitmap: TID/UP bitmap
+ * @link_id: link identifier
+ * @min_service_interval: minimum service interval, in microseconds
+ * @max_service_interval: maximum service interval, in microseconds
+ * @min_data_rate: minimum data rate, in kbps
+ * @delay_bound: delay bound, in microseconds
+ * @max_msdu_size: maximum MSDU size, in bytes
+ * @service_start_time: service start time, in microseconds
+ * @service_start_time_link_id: link ID for @service_start_time
+ * @mean_data_rate: mean data rate, in kbps
+ * @burst_size: burst size, in bytes
+ * @msdu_lifetime: MSDU lifetime, in milliseconds
+ * @msdu_delivery_ratio: MSDU delivery ratio
+ * @msdu_count_exponent: MSDU count exponent
+ * @medium_time: medium time, in units of 32 microseconds
+ */
+struct cfg80211_qm_qos_attributes {
+	enum nl80211_qm_direction direction;
+	u8 tid;
+	u8 up;
+	u16 bitmap;
+	u8 link_id;
+	u32 min_service_interval;
+	u32 max_service_interval;
+	u32 min_data_rate;
+	u32 delay_bound;
+	u16 max_msdu_size;
+	u32 service_start_time;
+	u8 service_start_time_link_id;
+	u32 mean_data_rate;
+	u32 burst_size;
+	u16 msdu_lifetime;
+	u8 msdu_delivery_ratio;
+	u8 msdu_count_exponent;
+	u16 medium_time;
+};
+
+/**
+ * struct cfg80211_qm_req_desc_data - a single QoS Management request
+ *	descriptor
+ * @qm_id: identifier for this descriptor within the request
+ * @request_type: request type, see &enum nl80211_qm_req_type
+ * @priority: SCS descriptor priority
+ * @num_tclas_elements: number of entries in @tclas
+ * @tclas: SCS TCLAS elements used for traffic classification
+ * @tclas_processing: SCS TCLAS processing rule, see
+ *	&enum nl80211_qm_tclas_processing
+ * @is_qos_present: whether @qos_attr is populated
+ * @qos_attr: SCS QoS attributes associated with this descriptor
+ * @user_priority_bitmap: user priority bitmap of TID values sent by the
+ *	non-AP STA in an MSCS request
+ * @user_priority_limit: user priority limit sent by the non-AP STA in an
+ *	MSCS request
+ * @tclas_mask: traffic classifier mask with a bitmap of parameters to
+ *	match in an uplink flow for downlink prioritization
+ */
+struct cfg80211_qm_req_desc_data {
+	u8 qm_id;
+	enum nl80211_qm_req_type request_type;
+	u8 priority;
+	unsigned int num_tclas_elements;
+	struct cfg80211_qm_tclas_elements *tclas;
+	enum nl80211_qm_tclas_processing tclas_processing;
+	bool is_qos_present;
+	struct cfg80211_qm_qos_attributes qos_attr;
+	u8 user_priority_bitmap;
+	u8 user_priority_limit;
+	u8 tclas_mask;
+};
+
+/**
+ * struct cfg80211_qm_req_data - a complete QoS Management request for a
+ *	peer
+ * @peer_mac: MAC address of the peer
+ * @qm_type: QoS Management protocol, see &enum nl80211_qm_type
+ * @num_qm_desc: number of entries in @qm_req_desc
+ * @qm_req_desc: QoS Management request descriptors
+ *
+ * This is the parsed representation passed to the driver by the
+ * &struct cfg80211_ops.set_qos_mgmt_cfg callback. The descriptor and TCLAS
+ * arrays are owned by cfg80211 and are valid only for the duration of the
+ * callback. The driver must not retain these pointers after the callback
+ * returns.
+ */
+struct cfg80211_qm_req_data {
+	u8 peer_mac[ETH_ALEN];
+	enum nl80211_qm_type qm_type;
+	unsigned int num_qm_desc;
+	struct cfg80211_qm_req_desc_data *qm_req_desc;
+};
+
+/**
+ * struct cfg80211_qm_resp_desc_data - result of processing a single QoS
+ *	Management request descriptor
+ * @qm_id: identifier matching the corresponding request descriptor
+ * @status: response status, see &enum nl80211_qm_status
+ */
+struct cfg80211_qm_resp_desc_data {
+	u8 qm_id;
+	enum nl80211_qm_status status;
+};
+
+/**
+ * struct cfg80211_qm_resp_data - a complete QoS Management response
+ * @qm_resp_desc: response descriptors corresponding to the request
+ *
+ * cfg80211 allocates and initializes one response descriptor for each
+ * request descriptor with the corresponding
+ * &struct cfg80211_qm_req_desc_data.qm_id and a declined status.
+ * The driver updates the status for each descriptor it processes. The
+ * response array is parallel to the request descriptor array: entry @i
+ * corresponds to request descriptor @i, and the driver must update entries
+ * in place without reordering them. The initialized @qm_id values must be
+ * left unchanged. The response array is valid only for the duration of the
+ * callback and must not be retained by the driver.
+ * cfg80211/nl80211 supplies the peer address and protocol type from the
+ * request when it builds the reply.
+ */
+struct cfg80211_qm_resp_data {
+	struct cfg80211_qm_resp_desc_data *qm_resp_desc;
+};
+
 /**
  * struct mgmt_frame_regs - management frame registrations data
  * @global_stypes: bitmap of management frame subtypes registered
@@ -5332,6 +5542,13 @@ struct mgmt_frame_regs {
  *
  * @start_pd: Start the PD interface.
  * @stop_pd: Stop the PD interface.
+ *
+ * @set_qos_mgmt_cfg: Configure QoS Management (QM) parameters such as
+ *	traffic classification (TCLAS) and QoS attributes for a station. The
+ *	request has already been parsed from the nested nl80211 attributes.
+ *	The driver or firmware applies the protocol-specific configuration and
+ *	populates the response structure with a status for each descriptor.
+ *	This callback provides the control-path interface for the driver.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -5730,6 +5947,9 @@ struct cfg80211_ops {
 			    bool val);
 	int	(*start_pd)(struct wiphy *wiphy, struct wireless_dev *wdev);
 	void	(*stop_pd)(struct wiphy *wiphy, struct wireless_dev *wdev);
+	int	(*set_qos_mgmt_cfg)(struct wiphy *wiphy, struct net_device *dev,
+				    struct cfg80211_qm_req_data *qm_req,
+				    struct cfg80211_qm_resp_data *qm_resp);
 };
 
 /*
-- 
2.34.1

