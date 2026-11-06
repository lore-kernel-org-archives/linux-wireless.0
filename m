Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951981;
	b=FXpVvDtnVBu0fSAQXJaM9AwLTJciR3GTgqIF7hOG7cD0dPVhTe9q1EfTdVS4Lar+QKNO
	 reS9nCX/VkMAU0eLlMNVus6h3FUGVWiezEbOlNOO5AkLhfKC4jHTMwCkZtc+EFbs6ZzZK
	 QqD3a8ygFgwVhZ06RAsWuuCaVsbqzODMi2VZNlwE8p/MG6iNshEQHLqZRegl/SI20j4v/
	 4dbtKF1ZMv/tS08qVoLGmmCqyZ9GYoAvsPMBhd5hq30kUeZsuD5aA37AVaq9FoI/QRbA0
	 tB+K/hZZ6/Ud+y7jQzJwjlrUvzMZCvXhnlrKFUHISABxLrfn1zArub0MqP3iO2Z03Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951981;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=eOy3jglmQsb7BW/pRy/lGAKuPlj6QMj+Cu4GsxBWH2o=;
	b=aVDmds6Y0TyRq2FBK/6UJjJgsVxsOYa9jC7921/ounr2FKAiN+ZH8VUQO/CBs+apSTfD
	 bOsI5Albz1QUdgs1ENMYW19VP5styEEOXQ9XTWKqCYdTZYrr8gmx8htsQxQQGKIYCaRcd
	 FLfP8vk2scE56aIb/lj3AyrnY50gawE/eO3C9g5HIa3Oq7cjkLICroRlVjodx+Ru3m7Xq
	 l4TJCGl5jWHYUz7UGAnDmt516BhFxfhyAkeP923+0mKCVKU9yLlNNkEpFyUNAsDoIsju9
	 Xlibc6Bv97xdAXwFYwcloAlBlMQ4+oGziX+YDQU7Fdgj9TZ8Lj5NhtEnH9jS4sBdSOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OEDmOBGu;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kfatHlU9;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FDF606D80E
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 07:59:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18FDF606D80E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OEDmOBGu;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kfatHlU9
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A67RTCQ2730723
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 07:59:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eOy3jglmQsb7BW/pRy/lGAKuPlj6QMj+Cu4GsxBWH2o=; b=OEDmOBGuFc/Xshy9
	S/9qdLvWfpS8MDRvIEhvvEE0sNLHHBZ2aWq61QpnDFc3OHf1JvV22+KIdmZlf2i/
	kEhenzzO6vOxA5RMP8skkJqOck8u1UoEoo14MGr/jQTgcq9NzrpG6m13zCrFv3zd
	IpIeNzj3Vyn84HBnxGU5FmSDJ58rbBJlOjkH15HP74RoTY8U5/ImJ2twQMeODRSB
	jShimVQCxO0B7zrnYM3vr0gA8YiMwQWCYUox4WlXP1Jz5bITYdF1oJ00E8abGRuy
	kz1kOS0k4Ld2qzYGLix9shoit+FVs0WgeauqvKvQpPvaSOWH/BWh9sjASvGVSeaq
	3v+YZw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3p9hpja-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:59:40 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ada6ccd402so388930a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 23:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793951980; x=1794556780; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eOy3jglmQsb7BW/pRy/lGAKuPlj6QMj+Cu4GsxBWH2o=;
        b=kfatHlU9ieLRtiMOP11A+j8PlWH7g5VmG8AG43wAYiczMNBYtWgIugRH8p4eknLS0S
         R5/3WvRAR65IfsXkBFQd2b2xTY4Uh9BbxZWXd/sJPicXTDpgWHVHFuKubQeTchKaaYRo
         vWH7sKrOY2hMTdLJUORhZFddFOX0G5Bx9X6fskO2/Exda78PaE5Uw3erl3BD8sg2cm0E
         bDlo8E1pYBIfr53Fsa8Njqmf9XO9Q+BpRyobJ8+ocauQ6+jG1Bh0aOcZ1wwzrFd0EFau
         aIO1aXzh3i8FAAUuVM6Ukcbun0rTh/HnajTVaCgz2Z/uArUkLcQtfw2g0vJFeZcfJ6LG
         qngQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951980; x=1794556780;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eOy3jglmQsb7BW/pRy/lGAKuPlj6QMj+Cu4GsxBWH2o=;
        b=m7kxI2UJmzPbWxoo6OvKrEIhaoat4ipOHYqJ+lDz1XheqTfn1WaLEHoLtk5JqYd2FH
         fsyxWuPDP4w66iUcL3MaUeTOsM9JN+DdIhQS9OQ/G8bucTPj2+wNcLv03r4CDttvbwXx
         sYkBZ+lTTlTw5JhXLO5VrQ5Rg49aRglxVbuKrn8ygrBzckRCHhSsEpYTtR19AOYIWL29
         gVdJstpbA6mUBUCbC0aDo5p9YPxX9Xw0HeXvPTiWwbW2rN2ugL39yXFpquq7IzPoiYla
         hCKaHKFlz517+zxvJvUBPB9T9itbLXXmpUEMW1+PQwbRSkpMInSY9pyQ82gvAXyV5PaO
         IowQ==
X-Gm-Message-State: APuU4Z+oVxy3MGFaW6d19rO/rULDkxsaefIxcvGatEnbI9ySUgw2ktCi
	CChDwt30q2/Jh+NfOAuSZpop8erxvovcJNi6m6MsBDlejoENR9mIefs+kDDC0BLVSHN8nfJD6bh
	toOYFKAUUGqcmSh7NHU30DEKLByFZr/kOCStTiR9612AS7vLehT0WlhOGJ4AH/1KXiAvx
X-Gm-Gg: AYBFou30s9JVrA6bFPdjboX3Y0yGi4cdP2lsBIx03Kk9kRXOrfRA3n7vfuTCzB/ro13
	/9nyqGt22PImuTqofxsiHrxLxnOOJ9K+ZxtZ4TG2VjqNxC3DPqNaOTVebHmIU3pHEYv7LN/5Mtd
	DI3b6VC0FRnShcrGG27yqDzW0Fa6dxbNZMlwTvwZ1CzljmX2k5v4UiIv/OPsXyktvHbNL63p9iL
	I7tz3b80qQ1kXy5VLn0R55VYv5+8HwgLX9ojVdZMPwV/JnUY9B1qiG1BB7fp0/v35u+fEx7tiQU
	xsdvFxnjVqLFFbtWzCSMw480I4+FBWu/3mY+rPbeJmQNa8uw+nRVJtSAHakXhQSIpd1GzzUL8TF
	vYW3j5ABjnGUcCaBfBw7ydhra/jDBHG7GhRnPv0J6FP/PmttNecr/NwGAoEbk1i0TYn7BwlL1Is
	bLIqOZ83YsnxEizTjhu5n3ZHaRMWodTkquFrsmHPNIKXp/hxMnXSxVgEsiV7+6Gm6OtWo6F/Y=
X-Received: by 2002:a17:90b:5587:b0:3aa:6b5d:9fe4 with SMTP id 98e67ed59e1d1-3b0db6d7b20mr1572062a91.12.1793951979543;
        Thu, 05 Nov 2026 23:59:39 -0800 (PST)
X-Received: by 2002:a17:90b:5587:b0:3aa:6b5d:9fe4 with SMTP id 98e67ed59e1d1-3b0db6d7b20mr1572047a91.12.1793951979074;
        Thu, 05 Nov 2026 23:59:39 -0800 (PST)
Received: from hu-pooventh-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0e4b3cf54sm321685a91.2.2026.11.05.23.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:59:38 -0800 (PST)
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Date: Fri, 06 Nov 2026 13:28:43 +0530
Subject: [PATCH wireless-next v4 06/21] wifi: ieee80211: define APIs for
 UHR Link Reconfiguration frame checks
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
Message-Id: <20261106-smd-v4-6-62e39487f51a@oss.qualcomm.com>
References: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
In-Reply-To: <20261106-smd-v4-0-62e39487f51a@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pooventhiran.g@oss.qualcomm.com
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: wzM4Paebx2zEyp68mQyGvpRzPu3RQzRR
X-Proofpoint-GUID: wzM4Paebx2zEyp68mQyGvpRzPu3RQzRR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfX78B6yZGHPvKh
 W7u+YtPSho4TXeJFET/zP2I6SiZmKAqrah5ywAoL+5mO8NR4Eba8yqEQDCgFoz4QHg6KMuqmPJ0
 JKId+1o1U7k+bRHV4fF/n2sDFNPzyRI=
X-Authority-Analysis: v=2.4 cv=XvNvqlF9 c=1 sm=1 tr=0 ts=6aed88ec cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=oDYSrMgdSjg_aXkkWaUA:9 a=bFRUnEHUPHmmGGYb:21
 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDAzMSBTYWx0ZWRfXx3TiqmqLkrUP
 BW+HwRyLOh4lIdJNx/x/sY5fWS/2deMmX44JWkTsPiET0zLI2hYbFT3m8y1rOWulpPHBN/K/DOH
 17XJxvYyZxZN+rcu1VWJz1sa1cm7jsi+gDKA7aNKGBB+6ViiiGDj+VeQqRYPC3ekWwoTEa9FMS3
 53N2UE9grl92Ec1XgqgL7jfjoaV7imoBapWhGUNc/3tMomppVkmS4lYktgTcBULkHmT1Trjq8Xn
 xDwiYsj8ZW+ZO/J3iACVy7fS7UioDtUurNLc4KALEQDdK2wE0CnZHY7gt2FTi5O0xRdSeL20rn1
 asBKJOJt9rlUkf95tbyBA8JjNHfANaDh872zGtsmE/2Hki7EcdoVpgehXamcMPF05y+5hINa9AE
 m2g7ZRkjMHQChElkggVOMRrE4a5IeVIL7leolMYgMVwRkrBJrgHIQyZ3Hue5Fc5FgQY0BkImJpH
 neromqiFhBOZxRQ+0tA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060031

Add APIs necessary to check whether the frame is a UHR Link
Reconfiguration Request/Response/Notify frame and subtypes to invoke
necessary SMD BSS Transition handling on the AP MLD.

Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
---
 include/linux/ieee80211-uhr.h | 125 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index c6c89e4562f4..9274fa146f01 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -699,6 +699,131 @@ ieee80211_uhr_mode_change_tuple_next(const struct ieee80211_uhr_mode_change_tupl
 	return (const void *)((const u8 *)tuple + needed);
 }
 
+/**
+ * ieee80211_is_uhr_link_reconf_req - check if frame is UHR Link Reconf Request
+ * @skb: the SKB to check
+ * Return: whether or not the frame is a UHR Link Reconf Request frame
+ */
+static inline bool ieee80211_is_uhr_link_reconf_req(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 category, action;
+
+	if (!ieee80211_is_action(mgmt->frame_control))
+		return false;
+
+	if (skb->len < IEEE80211_MIN_ACTION_SIZE(uhr_link_reconf_req))
+		return false;
+
+	category = mgmt->u.action.category;
+	action = mgmt->u.action.action_code;
+
+	return category == WLAN_CATEGORY_PROTECTED_UHR &&
+	       action == IEEE80211_PROTECTED_UHR_ACTION_LINK_RECONFIG_REQUEST;
+}
+
+/**
+ * ieee80211_is_uhr_link_reconf_resp - check if frame is UHR Link Reconf
+ *	Response
+ * @skb: the SKB to check
+ * Return: whether or not the frame is a UHR Link Reconf Response frame
+ */
+static inline bool ieee80211_is_uhr_link_reconf_resp(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 category, action;
+
+	if (!ieee80211_is_action(mgmt->frame_control))
+		return false;
+
+	if (skb->len < IEEE80211_MIN_ACTION_SIZE(uhr_link_reconf_resp))
+		return false;
+
+	category = mgmt->u.action.category;
+	action = mgmt->u.action.action_code;
+
+	return category == WLAN_CATEGORY_PROTECTED_UHR &&
+	       action == IEEE80211_PROTECTED_UHR_ACTION_LINK_RECONFIG_RESPONSE;
+}
+
+/**
+ * ieee80211_is_st_prep_req - check if frame is ST Preparation Request
+ * @skb: the SKB to check
+ * Return: whether or not the frame is an ST Prep request frame
+ */
+static inline bool ieee80211_is_st_prep_req(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 type;
+
+	if (!ieee80211_is_uhr_link_reconf_req(skb))
+		return false;
+
+	type = mgmt->u.action.uhr_link_reconf_req.type;
+
+	return type == IEEE80211_UHR_LINK_RECONFIG_REQUEST_ST_PREP;
+}
+
+/**
+ * ieee80211_is_st_exec_req - check if frame is ST Execution Request
+ * @skb: the SKB to check
+ * Return: whether or not the frame is an ST Exec request frame
+ */
+static inline bool ieee80211_is_st_exec_req(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 type;
+
+	if (!ieee80211_is_uhr_link_reconf_req(skb))
+		return false;
+
+	type = mgmt->u.action.uhr_link_reconf_req.type;
+
+	return type == IEEE80211_UHR_LINK_RECONFIG_REQUEST_ST_EXEC;
+}
+
+/**
+ * ieee80211_is_st_exec_resp - check if frame is ST Execution Response
+ * @skb: the SKB to check
+ * Return: whether or not the frame is an ST Exec response frame
+ */
+static inline bool ieee80211_is_st_exec_resp(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 type;
+
+	if (!ieee80211_is_uhr_link_reconf_resp(skb))
+		return false;
+
+	type = mgmt->u.action.uhr_link_reconf_resp.type;
+
+	return type == IEEE80211_UHR_LINK_RECONFIG_REQUEST_ST_EXEC;
+}
+
+/**
+ * ieee80211_is_uhr_link_reconf_notify - check if frame is UHR Link Reconf
+ *	Notify
+ * @skb: the SKB to check
+ * Return: whether or not the frame is a UHR Link Reconf Notify frame
+ */
+static inline bool ieee80211_is_uhr_link_reconf_notify(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	u8 category, action;
+
+	if (!ieee80211_is_action(mgmt->frame_control))
+		return false;
+
+	if (skb->len < IEEE80211_MIN_ACTION_SIZE(uhr_link_reconf_notif))
+		return false;
+
+	category = mgmt->u.action.category;
+	action = mgmt->u.action.action_code;
+
+	return category == WLAN_CATEGORY_PROTECTED_UHR &&
+	       action == IEEE80211_PROTECTED_UHR_ACTION_LINK_RECONFIG_NOTIFY;
+}
+
 #define for_each_uhr_mode_change_tuple(data, len, tuple)		\
 	for (tuple = (const void *)(data);				\
 	     ieee80211_uhr_mode_change_tuple_next(			\

-- 
2.34.1

