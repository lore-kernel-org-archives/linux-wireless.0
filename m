Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044623CF670
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 23:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785195586; cv=none; b=Y0Kf+ScTV6Cd56VA0xfZSa2VuEexSoT7poNCgAf2s9hf+KV0DAVeJV7u6l3he0rLM/th6MtdlCstsmIE+IKpJzzBRNFGOqIGBMvFum9gLrv7q2kgduuIQhvTaKKLJota/8GntxYxzWbn4UXriEoblM8Gz++ywUB8I1ljj7RQVi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785195586; c=relaxed/simple;
	bh=XdNVRyUNPkCJ0MEo8xHjm2EIN+ibD10018Xwsx997Mg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=d891xeJL5vK64huhzZcAKCPB8EVeAFJyQvN+k/2SiwsBhoP6VO1bhVw+ph1k/bui7s8jzRXMwU8zUTXXlbc9YHB85e736Hwj/+812XQi3VovLm5vfVUyacVLu2PkpDcLLA75Z9AxEjUFiVotFQTj6GgPqMjpfsgZMAxo71LavWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EBdB74Na; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dXh/eOyA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EBdB74Na";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dXh/eOyA"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RLbgUO281964
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 23:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Lz5WfjU5lvnz3MSjE+QYvK
	7315ShwTnlbjTJZ3IztlM=; b=EBdB74NavVCbBjG5ccRCjvPoAU+8mCUm+zsNhP
	r2oi8QVwO4ngm8+Zq8JpbGy6JZA5D+gqNTlmq1BeGS3+G8HwaEbDcpwc0+phJdYb
	UaSSN9+uO6Dvm/8k4BjpMHYikp22AeEERD20U/vTMFdEwasfSd9yBsCC2MwgEIvD
	aAUdLTkffxbGE2/eccBQNn9HLRCmGs3BaizeRxJ07KlWjB63ve9eITdHDoOnl6f7
	jfyBU6vKQ0j2GDXHC9B+v0uTzbOk+OA+hcs4YBs4JMzXxvRkcc3SqCYPGz5owKWt
	ldGxY1tzQ9CSQvEVP5+mk0S1Ce2bBILLiYmq3K25IRhVic0g==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fp4v6bgx7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 23:39:44 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb7049fa552so2090152a12.2
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 16:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785195583; x=1785800383; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Lz5WfjU5lvnz3MSjE+QYvK7315ShwTnlbjTJZ3IztlM=;
        b=dXh/eOyAf430VCuazUQi4vcgkvWaZy6lXuxa/ADtOKOQncK72puk06hho8EJm/fUux
         yPJ3UMsD9HqFmvu0APEHxlR2ZdnPqQy4fiivFimwHCHr4ZM2c30rvaFu9WSK+jcOiNqW
         6dR+VkczeBbAVmtd6ozZbsPv2/3jD3thBFfVAZyGodhoP+paDLFtx185flA8ORT3cf8k
         1w0JsML5fIp8ixyipWvM964WBIYGV2mtu9AuMZQMtQ6tTVkI422YhNg+Nhdnv0jCt3tS
         wVvD6fTB/14s0HJAuJ4Y+XQWikXfIzTJBuzygLt9VU4VAkbTcT9gfnXRKOEVl/H2tydR
         J7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785195583; x=1785800383;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Lz5WfjU5lvnz3MSjE+QYvK7315ShwTnlbjTJZ3IztlM=;
        b=gto8awPIwwd944YlrvTyyStK25/mHlMmT6lpLS80z6kvd5Ddi8Kyk0Diogp1fyWjA9
         qS6rVPF3Z+5GYEFZ7e9LBA/thge4JtiN4CUGC/IbnHxRHzuTPIAr76n3Ey2B7By438I9
         MA9GGyJl95xGv2rFeFXbBrNB1SShAHT98RhNV/AwB6kHn//Fkvzs+o7FhCCAN+Meawdh
         9NElB0XRgcRfiJfi+Z3eeK1oo73E+tj2mu0jbmrwCJ1QUhimqLaz4lsqmy084kHueat5
         6ZXmWz9gcZQR1fFN3F4zie3G7Ubq513FeQAf6C2f/6w0/5Ak25qxtUGYMi5Z/xJgnaMs
         UXkQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqf3AvmYSg84B26401GKg45AKIv3UbWlH0Xo97Mp1044iSGvlZmq5r1SHZGA4Y1JWnv2dCI8kGQ+ycwh0DdqA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGFMiWc5v19RFy8ImCI6GO/1jC83bkJ+M6IBGxWhUXevqzTDR+
	Kx+kRPspFZ9LN0IS1/OBs30HuA5xpfTYd/32raTW9d+9Il0VcAJcPVGhdEYTjogJR3sL39cGGP1
	iXf+BqslLFMDj38a7yQ9/dWPkv9T/u6TwbSRViU+puJeDEw5b/AfXlNwb+oGTAZ9yVCWEpQ==
X-Gm-Gg: AR+sD13YPW4ni4nsPfe5rGQ/UkJ2rx3XPu4nYhUWq63QlThpnKuyTsVQilQnb1Vs+jf
	SPeJBMQJrEI+BjaoEqmMIc1IAOi4aTM38dAftLoLloxRVEoES0DG9rxvSNDvkiKLsgQWxkMZYFd
	pUq0P1CbVc59A2G6EjdN+bQ+3qMhXZ1vlgv7YmpjSk1lZ0x+pIo8UI8N2hgAcF3IPWYZsqZWeEG
	AK9JufWQaopGHNaPOVebL58NECa3PNq0eP/hadMi3K2FJFwR0+x8rgmuCCMzGG3x/szODTHUDRU
	WIXEfSrriNkrP5OmSOXiz0THXfGNbfsQcCnipfdulmvabT5qZUqj/h5DdMHNyhpmMoYkl9Bln5y
	P3BP716mWq7iFHuPEJb/xmSI2UIXEt2jexzg2EU/2KF5QPwDLEWnDozs=
X-Received: by 2002:a05:6a21:e0a2:b0:3c0:9c19:b27e with SMTP id adf61e73a8af0-3c8ba6afc33mr21405637.76.1785195583540;
        Mon, 27 Jul 2026 16:39:43 -0700 (PDT)
X-Received: by 2002:a05:6a21:e0a2:b0:3c0:9c19:b27e with SMTP id adf61e73a8af0-3c8ba6afc33mr21385637.76.1785195583070;
        Mon, 27 Jul 2026 16:39:43 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc413766sm37543072eec.8.2026.07.27.16.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 16:39:42 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 16:39:41 -0700
Subject: [PATCH ath-next] wifi: ath11k: fix leak in
 ath11k_service_ready_ext_event()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-ath11k_service_ready_ext_event-memleak-v1-1-e8373d27bdd1@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIADzsZ2oC/52OzQqDMBCEX0VybsTEn9Ke+h6lhBjHGqzaJmlQx
 Hfv4rmXloWFYZhvZmUezsKzc7Iyh2i9nUYS4pAw0+nxDm4b0kxmssqOMuM6dEL0imLRGigH3Sw
 Kc1CIGAMfMDyge97WbaFryDxrc0awp0Nr573oyojBR8qwGzmd9WFyy74git3/tSwKTgcUFUx5Q
 lFeJu/T11s/zDQMKb29Kcr/6JLoeQ2hc0Nwo7/Qt237ALkGVWNLAQAA
X-Change-ID: 20260720-ath11k_service_ready_ext_event-memleak-fbf4abe230f3
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDIxMyBTYWx0ZWRfX0HqwZscoBPQv
 W2jHa9j4EMcAtbxUFGgGLT2v2sbV4yIviMa8ZyPKsFeM2OkJDOzbhXeSkufB2AOnZwkERX5sXmY
 N6kUXh8GtDCQk/IN72O1WFy61DZR4hc=
X-Proofpoint-GUID: GhjtWiXkBk1q2xHh1vhmzLGureqS_pVR
X-Authority-Analysis: v=2.4 cv=ev3vCIpX c=1 sm=1 tr=0 ts=6a67ec40 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=ix1dB9U_WECUcgnmRBMA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: GhjtWiXkBk1q2xHh1vhmzLGureqS_pVR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDIxMyBTYWx0ZWRfXxJHl63B3ekm9
 qkyS9nl0LZhc+48O+EKeSJ48ljtoAyZqFo3b1iZw8mgIxlI953EE3JmLFLmJq/ol0DK/WqxCPEm
 LsLtZh0lEhWm/tYv6GVvcOOQncmeU//yRXiQBEYn2g4FyYFgz80DhQEfYqw9U5Qiy9PS0xQjbie
 hag/Oozeo2W+0uikMXLcBpRSYHX3Z1xFxvL6VX5JUWn+rmWckoKfiTDEwldfPiKg/h9m5cAb4P9
 UmibKxEWs1qeAmdjtHjRGjDdsUGO4AkKSo10kMt+gTgZmqMTrRLQ2VeMXOW7t1hwD/2sg8l8/xr
 QtsM9QkzkVs1rWhiS/jtu/McWMtSVMHYtBY6JFPnKOebw8szoW1AvKN5EGJGnOjZ3kV1nSv2VOX
 uyGFw0SG7ImrK8EnrGLDN4qn8MzSY9SnKKfhgSu+hae9a3PVGmKIJTOiJ3gy+5RmdfPBqQzRswr
 kozxqtftqHLbZf5jqOw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_06,2026-07-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607270213

Currently, during ath11k_service_ready_ext_event() processing,
svc_rdy_ext.mac_phy_caps can be allocated during TLV parsing. This is a
temporary allocation that is freed on the success path, but not on the
error path. If parsing succeeds far enough to allocate mac_phy_caps and
then fails on a later TLV, the allocation leaks. So free the allocation
on the error path.

Compile tested only.

Fixes: 5b90fc760db5 ("ath11k: fix wmi service ready ext tlv parsing")
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 2d2c6d7a4a3b..b2861c879618 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5124,6 +5124,7 @@ static int ath11k_service_ready_ext_event(struct ath11k_base *ab,
 	return 0;
 
 err:
+	kfree(svc_rdy_ext.mac_phy_caps);
 	ath11k_wmi_free_dbring_caps(ab);
 	return ret;
 }

---
base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af
change-id: 20260720-ath11k_service_ready_ext_event-memleak-fbf4abe230f3

