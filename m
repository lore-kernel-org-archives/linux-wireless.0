Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907627;
	b=vw6Avi9wgaWQ8BGpLxtWthhSuF5gbwcWr39V7fHgPfkusPyPbmeEe7HxE+e5rAs+JliY
	 +43I3RlGMx9kqPlfyudnBT4Cxz4Pjt+pL+774MJ1ySJGG7o8FEUSv6gabMik63SWgDJdH
	 kBcq4HdTYvlg650BqYJgMIDe41KsXPKqagudgg8hYlrt+9EoDmv7LtPDZmtymJtiq1ryE
	 AdygRQ0GeXj1YQC5LCelevBTYQUa5wW94R/DHPFaZgtL2P/fhybo56R3uU7goRaO++fw0
	 wZ8bD6fYl/5nMEzE7bt/tErF1xdWKjxQi5X/2eKfcOD5/nrHu7ULFiZlyLtyrSrRBzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907627;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=XOOBmwb2awLC5YZHeWolkoldTxdZw54DrdIDJ8KDPFc=;
	b=mJPkyxmZLi6DJTb6LSJXKXBqBGEbh9flUIC53Mrd8pud1UaNz3iUC/fLvtJNR6YmZzfs
	 Iugpw402EJitaXYVrp6kNy2BtMudf6XZKBUw7CXC//XiSrs23sNIkmAp9FrOVsj/UGgZP
	 /YLYvf2Fytf/v0skaNspBIHegJuYMd/mw8KNTo6iDPj3W/dZPJRg6werUBphbjyS9We6T
	 boM6CsPK9YlQSoh6zYA6dEE9QfwRMutiQnG7w9O/SZ9tVtyVGJE5Y63YLKJAzEdo5Byil
	 iYc8UEwBb/6UsArMKF5iQvWWE7csznHjVIXegUtFF2F0+fjxP5EttShi98K8nTZoWSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TNffLFtf;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KgTPdqG8;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592D660741D3
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 19:40:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 592D660741D3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TNffLFtf;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KgTPdqG8
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5HeL3V2091030
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 19:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XOOBmwb2awLC5YZHeWolkoldTxdZw54DrdIDJ8KDPFc=; b=TNffLFtfFqtm7+bD
	mvI5Zi1WarPw+MG6PoyZbWf5/r1X2K6nvq6idQofGySSaXEBA15+HoNiidr92TDM
	Xsll8jzUyOE4puSpq7nxqLuH9Dm7CtiW7HCLJgmEXG038jXfBUOXzbs0hZnztVJe
	Scib48+71MBOYGYgovYCPdfx2JdsUfOcCIUi6G9G3MPu8NZTtcQPxK3yQeZF821v
	TQjCGdR16N90lZtzc9pEN/pY14cycoMbtfRKWpehGR8FL0QGz8Y6yTV3RosAsWgR
	BHwwc38Sewb6zGRwEatYsyXPnRiDyjCJMLZtYMXguHGDlkQ+9punn78YrVuDzc+o
	nm4JxQ==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrq9fakx7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 19:40:25 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36a3451ea93so3101848eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 11:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793907624; x=1794512424; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XOOBmwb2awLC5YZHeWolkoldTxdZw54DrdIDJ8KDPFc=;
        b=KgTPdqG8TtxP5IZKoMvi8+jNKyMYanrALMccxABHxNl40VEKQhc+r+7NaLooRcCR24
         gVPclqhz8LxWQf8PG6zakedWBaQYT13gQ8Ac5XLDJwRa9QwFa47qywk3ZxsG/mTXRPbo
         //KfLP+kiXm1X6YeZmWjd6BPSivqkXS+dzP5Fz2rC4rdfDN87LbzVeVajLcpRrWElYyX
         AgkTC9VPRWR72u00o1BX46PHdeJs+uUhOaa0R4zoj+96ldQ+rfrlSzTDHB/jgy/o+t89
         aFMgLX2jA4LkUSXVIkmlrvdx1FNTnYW6H21CSaGLsRoQHHHj5WdylE+peYV/GVkMRCah
         94hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907624; x=1794512424;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XOOBmwb2awLC5YZHeWolkoldTxdZw54DrdIDJ8KDPFc=;
        b=Dvu1Xjt1zhBgXhnppk3FuVy1VCGtovMQHSAPSVIR5Auly/pHCjVmse86JKkVOZN2AI
         UG4Xh68G65F/NsQfXKsYBtNI0xNEEyUrtB7OMC5mbPSG3kVC8FGqOzDWWRD8cv85FDSh
         nNgjAZYncoG0RZVcJHW/Q1V9uc1uLGys0eq6yBbYjq9oVnzrMYFN7AlPwaQUHDjETv2c
         VJYsnquTyAZKJPlqmSRWMeo2r49Ga/7CjDP+YkqzAjw5Ddff++LZ6dFOKsBvcP3RIJdd
         MrY8EondsFLf3/bky8ponLvcpLu3e7DH2C3R2HI1a/pjoXa+N8UIBTNYgxYCwm/E/3Cu
         J7Jg==
X-Gm-Message-State: APuU4Z8Z8C/oSGzDRmc4tukHdh6Nsj6rEsdm5GRILCu8+T3wfGExkOFg
	LQnhr7Yd7gcted+waaN4hQHb9l8wJhddO284tvCSD0oPTTP5moHcEdozJ2TDU8yjVnN8eF2Pr96
	GBlWfUhtHLc6/w11SA+4eTIg403RJpmngJfX0jv6IqWh9mPgLhuSKN+SqXzj2R/83c8Cm
X-Gm-Gg: AYBFou0bD4Ideaklw6QBROT79aZcUzeTosXoCUBUuN6LoKQDy4gobvNrkbJVa3aQnMz
	n/U+B6ZoUOMxuzirw+PnEiGKpSBd/zPpVRV/K7zc9rsUV8DLOWyVQ3T6Htl8nDMNVglaTsIow5t
	hnHseH+ZwrzglgU85NbguOObJsqnohGaiWqIGJav3azkfMwAmHqa2ffCJxuBD8XmMN4QkK9U7N3
	0nGAbvryI3IjJ7lTKxh21mGEKHmGakUhJ8/1kGhh6CygP1SC2ojNaQIZB0IfKNAR3JVaqyy52ii
	PnZ7FXHMy4+mzD1dmXv7YCk7uixUtrBWpP+Lod8SnILvt0WR9VQItq4H3CTcML4BsXos6wnndPk
	Hcm2490orRv8dYZCzRVK7C1uaz6hWe6fNJwItAXR9qyycKmuxtpHrfFvS/On+t6cC2FEBi1dqYZ
	3zvt2sRe1O4ozCGBvqhNohfmXG31sepomMgQbNw+u6ywv4GsaFzL8gB/3ks05Kmol1XxZ8Ug==
X-Received: by 2002:a05:693c:62d1:b0:36d:3c0f:cc85 with SMTP id 5a478bee46e88-36f723e9d36mr196345eec.5.1793907624035;
        Thu, 05 Nov 2026 11:40:24 -0800 (PST)
X-Received: by 2002:a05:693c:62d1:b0:36d:3c0f:cc85 with SMTP id 5a478bee46e88-36f723e9d36mr196299eec.5.1793907623387;
        Thu, 05 Nov 2026 11:40:23 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72cc9b88sm357284eec.14.2026.11.05.11.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:40:21 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 01:08:38 +0530
Subject: [PATCH wireless-next v3 03/21] wifi: nl80211: add SMD BSS
 Transition sub-state STA flags
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-smd-v3-3-1723950e3cf8@oss.qualcomm.com>
References: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v3-0-1723950e3cf8@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfX2ouf8S5rhyJf
 /mZdxYmpzmBk64Dogd9ZY20jnj9r+2fTp7A5iE4US1ciiZyr2RvvZy8JGBEMEeaUtC00NlyI7FZ
 2XWP5jSgXwHCNeXhSyVEZXPoeuNX0dQirDOtrXPVc6p8MTAdA67/VAJlM5OYcHFNqW16nAU9oRV
 xBEwBylDEV3xJcJb86cS/K5phbwZYv7twTux0eFTpfDfmbFKQQjYhqq8b0D8mz+0ztt0RwaCCbO
 63a+Y57i3N6iYppzs1tXdANgJxc0iD1/1XoD5ROh8em97+i6HoIoLdN4V1Zf3llauKYAa2xUTFd
 A1nR15gVsQlbWVM/wXgiJVZFgNS4J3pgbJLXEsGPuFUB8mLGADWYhOmdAdDJILXVy3DqEDKzofZ
 A300osV5gGHR7Eln4PrLaLBEzVzHZPwACETo1xzB/v1oHj3n/tNq89MozIz7KFzof3IF7XYAqMu
 mFjsAQoCs1Fx1KHYCsw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA3OCBTYWx0ZWRfXwbHnACV3vyMj
 nKMyHS4l13ihjvcNUOXidh1lg1hrzNv+4zrfEoKSUnchldL3FamYEHXKrE8mQDG0crLpQFZq+hl
 lxfLPWvqovP4FZ1B9btHGS1xh7nsyJQ=
X-Authority-Analysis: v=2.4 cv=Vdhir1p9 c=1 sm=1 tr=0 ts=6aecdba9 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=b90yJLNE8BgtmlcRjg0A:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: EXL27y9XbCy4pULM-kJvprs7XBn7EPvx
X-Proofpoint-GUID: EXL27y9XbCy4pULM-kJvprs7XBn7EPvx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050078

IEEE P802.11bn/D2.0, Aug 2026, subclause 11.3.1, defines three new MLD
state sub-states (4a, 4b, 4c) that apply when a non-AP MLD and its
associated SMD-ME are in state 4 and an SMD BSS Transition is
in progress.

Add the corresponding nl80211 STA flags to track the state changes:
 - NL80211_STA_FLAG_SMD_PREP_TARGET - State 4a: non-AP MLD is prepared
   with target AP MLD
 - NL80211_STA_FLAG_SMD_EXEC_CURRENT - State 4b: ST execution active on
   current AP MLD
 - NL80211_STA_FLAG_SMD_DL_DRAIN - State 4c: DL draining period

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 18 ++++++++++++++++++
 net/wireless/nl80211.c       | 18 ++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index cfc1bcad13f0..81c16ea2fd34 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -366,6 +366,15 @@
  *	the AP MLD. %NL80211_ATTR_SMD_ROAM_STA is also set on the target AP MLD
  *	to indicate that it is part of ST Preparation; drivers must keep these
  *	links in powersave at this point until successful ST Execution.
+ *
+ * When a non-AP MLD undergoes ST, userspace can indicate the current state of
+ * ST at the current AP MLD and target AP MLD using the STA flags
+ * %NL80211_STA_FLAG_SMD_PREP_TARGET, %NL80211_STA_FLAG_SMD_EXEC_CURRENT, and
+ * %NL80211_STA_FLAG_SMD_DL_DRAIN.
+ *	%NL80211_STA_FLAG_SMD_PREP_TARGET can be set in %NL80211_CMD_NEW_STATION
+ *	on the target AP MLD while creating the station entry.
+ *	%NL80211_STA_FLAG_SMD_{EXEC_CURRENT,DL_DRAIN}, on the other hand, can be
+ *	set using %NL80211_CMD_SET_STATION on the current AP MLD.
  */
 
 /**
@@ -4035,6 +4044,12 @@ enum nl80211_iftype {
  * @NL80211_STA_FLAG_SPP_AMSDU: station supports SPP A-MSDUs
  * @NL80211_STA_FLAG_CIP: station has Control Integrity Protocol (CIP) enabled
  * @NL80211_STA_FLAG_SMD: station has negotiated SMD.
+ * @NL80211_STA_FLAG_SMD_PREP_TARGET: station is prepared at SMD target AP MLD
+ *	(State 4a).
+ * @NL80211_STA_FLAG_SMD_EXEC_CURRENT: current AP MLD is executing SMD BSS
+ *	Transition (State 4b).
+ * @NL80211_STA_FLAG_SMD_DL_DRAIN: current AP MLD is in DL draining period
+ *	(State 4c).
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -4050,6 +4065,9 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_SPP_AMSDU,
 	NL80211_STA_FLAG_CIP,
 	NL80211_STA_FLAG_SMD,
+	NL80211_STA_FLAG_SMD_PREP_TARGET,
+	NL80211_STA_FLAG_SMD_EXEC_CURRENT,
+	NL80211_STA_FLAG_SMD_DL_DRAIN,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b06772ec8ac5..5df145ab4ab1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8025,6 +8025,9 @@ static const struct nla_policy sta_flags_policy[NL80211_STA_FLAG_MAX + 1] = {
 	[NL80211_STA_FLAG_AUTHENTICATED] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_TDLS_PEER] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_SMD] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_SMD_PREP_TARGET] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_SMD_EXEC_CURRENT] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_SMD_DL_DRAIN] = { .type = NLA_FLAG },
 };
 
 static int parse_station_flags(struct genl_info *info,
@@ -8091,7 +8094,11 @@ static int parse_station_flags(struct genl_info *info,
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
-		params->sta_flags_mask = BIT(NL80211_STA_FLAG_SMD);
+		params->sta_flags_mask =
+			BIT(NL80211_STA_FLAG_SMD) |
+			BIT(NL80211_STA_FLAG_SMD_PREP_TARGET) |
+			BIT(NL80211_STA_FLAG_SMD_EXEC_CURRENT) |
+			BIT(NL80211_STA_FLAG_SMD_DL_DRAIN);
 		fallthrough;
 	case NL80211_IFTYPE_P2P_GO:
 		params->sta_flags_mask |= BIT(NL80211_STA_FLAG_AUTHORIZED) |
@@ -9308,7 +9315,7 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 10);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 13);
 
 	switch (statype) {
 	case CFG80211_STA_MESH_PEER_KERNEL:
@@ -9404,7 +9411,10 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 				  BIT(NL80211_STA_FLAG_MFP) |
 				  BIT(NL80211_STA_FLAG_SPP_AMSDU) |
 				  BIT(NL80211_STA_FLAG_CIP) |
-				  BIT(NL80211_STA_FLAG_SMD)))
+				  BIT(NL80211_STA_FLAG_SMD) |
+				  BIT(NL80211_STA_FLAG_SMD_PREP_TARGET) |
+				  BIT(NL80211_STA_FLAG_SMD_EXEC_CURRENT) |
+				  BIT(NL80211_STA_FLAG_SMD_DL_DRAIN)))
 			return -EINVAL;
 
 		/* but authenticated/associated only if driver handles it */
@@ -10128,7 +10138,7 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 10);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 13);
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:

-- 
2.34.1

