Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5554C3E0092
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785309524; cv=none; b=f+QEiJLIQn+3DUtnn/aq09EQY2uPgCm1qBDlFvt+v4DjJaOMi7rltgwABrc5MKutMf6nksuYSWxDhqihOGa4JBFYQw9FQtIBmx/zeo/V2NcD+EvD9vx4ytatyknF47ie+fmRpb7p6dC7Ze4a8wJsSja6QoTwJiRLtgOH9HKFYkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785309524; c=relaxed/simple;
	bh=jUT7pYzwzncTOj36a+trjX6+tLTg5gZK2HL3xzDaZrc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UiKC5D6gLmtM/BoMuPms+orH0B+DvejcZsQvuJl+DLuLjp+ydGKHzfvv4945NrOq6p9Nha/a+ooc5RM17TfvpNtmeoJizhF8X9cl2AA4lSYAMceW0ITkn5hKTpjJAYgFaNuPKYwcU2KigI5igzDRJe79lSZJgf65nRzpUchzp/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gC7TQB7G; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MmR7Myri; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gC7TQB7G";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MmR7Myri"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T5goJf2055521
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	n3X7sjZrsiUmJKo1zr6UpG6RzjyU/w/4kRvDouCMrB4=; b=gC7TQB7GNe3/y7uK
	6d8uM/ehne9tkvEXWZeDO8oGax3HIwVBPrmHwiqJ0u5G03QiMWyjFE82+bYE5CZ9
	jzLv4gB/3aYlZYTCgIEpHeohPB6LtyaCz0cQmczhQ9wbnD4ZTqtl0HihwBM2RzOO
	ENnvkIq8fatkQNydJggqGv+0PRcsoJOcK7ph8AgNNGZ1EFwN6yxyrZtwLSmbd5c8
	yc95noExarQvkgeyGKaIcWZ8eVluE0u5lg6qVY0kyxWZmXdC8Xz41NwR6421sGMZ
	8XAlGcS75e+exLiue30zyhiWrIlxJku5z0lbpJU2RYJbXVFanUA5aX4TRBoTAbpP
	9cmztA==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqbm1gbxq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:38 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c9fe4c5eb39so408216a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 00:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785309518; x=1785914318; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n3X7sjZrsiUmJKo1zr6UpG6RzjyU/w/4kRvDouCMrB4=;
        b=MmR7MyriEqdvtl8RDzb42yjXuyxmI4pFnKfE9nRdM1iVTmR20EVlr16wATJnOKRHx9
         wj09AmWDToQCJErKNOMg5CnBCaUfX65LurnkjA9rthaNSO+wQrEIBE5DNO8vP/xZSzh7
         B4QE9fSJtHxetcXRqTj2b1sYbiOxu0Hs/aUg55/k213oaXm38j0n+cDhqQLv2+cNWWWW
         ZoeutUeMn+a0RXoPCxcTwrhDXrbzeXXFIor4vjkTU+a+EapwzbeBxOP5CXL5tXg10P6U
         NMQCFfChPg9sI2NlfvgZErRtQcodDvvf3a447UVlOdmN8nVYErw8RM9nyi8XRtHHmUPz
         8Sug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785309518; x=1785914318;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n3X7sjZrsiUmJKo1zr6UpG6RzjyU/w/4kRvDouCMrB4=;
        b=L/s7OD149lyQqsx44YesTaNYDMf4uPLOlle87fr2Jg+mNXugRHGT1z9WbESg3Y6Tnv
         9G1CNGeVqSCcuXDw0+ytV8U+IQoUJyzsFcJsUUyVFU1raklg5ugyyRDq5QwVbv57tbK3
         WMuo5h3qSJgb1ay0K2AHknu9VSTjmVG93IYR/Q6VFln1dJqfSlw5Ilyx60EIQrDJSGfJ
         cLx4llE2fSExA5SKngYPDksqs/IpMHdY4OMw9kPCmuQsAsv7jxzefdjU9b630n/vaBrF
         DIAFlm2HpewWAYDbAYMbVM4Pvd8uW/fjrcjFVZGdKub2zGeqmt5WWQ9WWY/zyJLgDEfx
         iyyg==
X-Gm-Message-State: AOJu0YwTU238oA9xpzmTawz/Tk4Mec7emNx28IsJslfpATyht/RFBv7Z
	aGTT732nK61niqrBogsnNAXfvtOMdGBbCYZzvDoQksio5iSao+ScSaKQEytI51fkC1ymdjMgicE
	GOjG42/niZqpBLTmFJMWNKMjKq6+pT08A1y8zYTzGyebsodhdz2rQrm2szeBjYzzLsBME4pNwhs
	V3hA==
X-Gm-Gg: AR+sD124w3JOcnMIv4K65qs9S/tCWXXjY02LQwwc/c7865yEGNDYZjDqGY1vpZkvokY
	tFJxSIbRhd8PbsQ5HT2Zj1zmbm6+1xDKfdLU/3Wi8kpuE+cKtdCSAbctwK1FZEEZyaGAw6k6SM1
	puv8jM5rikn13Nk8cRoSyPzI6PE1jJLJo/D6pDL2zYQjO0QYcWcsO/M1/8fKQYAZsFGFpxO6Le1
	uDAVT6mnyP6O11Ryn/A6osf0ghRmZCcdsmnqKdK6xdDoyeXnNyGdTVbqfGBnwdF+2V9R8BGVm3y
	q1NWJuUTB9qqjatUuk7loJjycfORvH1kiKePFzlTM2jjZAsEOQD+Yd7TRiwBmKf5jC4eQtz6eON
	xsifI+opmKDaeLVM9pSciX0OPq8+kSihNOl9tu3/DRnVuhH9hZddT7w==
X-Received: by 2002:a05:6a21:4516:b0:3c4:42d9:58e3 with SMTP id adf61e73a8af0-3c8aafa0605mr6894539637.13.1785309517575;
        Wed, 29 Jul 2026 00:18:37 -0700 (PDT)
X-Received: by 2002:a05:6a21:4516:b0:3c4:42d9:58e3 with SMTP id adf61e73a8af0-3c8aafa0605mr6894515637.13.1785309517083;
        Wed, 29 Jul 2026 00:18:37 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdb78ae98asm474793a12.1.2026.07.29.00.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 00:18:36 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 15:18:12 +0800
Subject: [PATCH ath-next 2/4] wifi: ath12k: use per-radio ab in
 ath12k_mac_hw_register()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-ath12k-regd-wait-timeout-v1-2-504aa6e7e93c@oss.qualcomm.com>
References: <20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com>
In-Reply-To: <20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA1OCBTYWx0ZWRfX1Dz/8hnPDGbD
 wNm3VjODaoxAR+CHn6O5bUQd9uRiY+xvfc7O7+FYHymYCwK2ch5sP1OaZsDKjCq9rYrL6v4oV88
 wlHV6QkjNeCzn5U+RNJZZoIvoH0YeeLfpQLVWIJlNZIDvCrY//1V5XpIP1nkXVO3g8daKhpC+Id
 tJ7yJL2LDOmaCF9n2CThZEFoX1qKj6tOmi13kIhgWMJBp2DaWTCjHpDIEE3v0wce9KY4seeiiPk
 QTJPAxXHre+WZxvJ+UwTvDPQYtyvQoYERxLdkSHpG5Eo4kDshLeM7JZx6qv6Z9+IEq3G7AS7yUX
 /fMotBkmxGo2M+CjQyw3OEHisW7qwdT/sawRHj+vC2JDtANMQh/30PErk4+makhukXL0UdDyjMP
 FIbBaFse0Si5Ti7cZNEDO64BrT/7wVOGGmFWry5mbtrVVFTxgOX10wgQ3NyC2SW+mmF4OijBrhy
 UE9ils+q36d+74gxA+A==
X-Proofpoint-GUID: C8hgXw-AgkEWl1tB0GR2mbEugTuSWLcs
X-Authority-Analysis: v=2.4 cv=R7Az39RX c=1 sm=1 tr=0 ts=6a69a94e cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=zhjQ6ZcactBYWx6wB3IA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-ORIG-GUID: C8hgXw-AgkEWl1tB0GR2mbEugTuSWLcs
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA1OCBTYWx0ZWRfX3PwDsbm+7Nr1
 i3wPoLQ7xs53Txk8M8hd3EjtHlRVXYTDt8TwNxG+X0AzreQO4qBrwfO+jZSvypWhzhdDJ4pZ5tU
 c7+5vZvAmrknLwbcYhnbwCrvw7WDXvc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_02,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 phishscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290058

In ath12k_mac_hw_register() the local 'ab' is fetched once from the first
radio, i.e. ath12k_ah_to_ar(ah, 0)->ab. When an ath12k_hw spans more than
one ath12k_base, the radios walked by for_each_ar() may belong to
different ath12k_base instances. Using the function-scope 'ab' inside
that loop then refers to the first radio's device, which is stale with
respect to the ar being processed.

This is not a functional problem currently: the loop only dereferences the
stale 'ab' under hw_params->current_cc_support, which is set only for
WCN7850 and QCC2072. Both devices expose a single radio per ath12k_hw, so
'ab' and ar->ab always point to the same ath12k_base.

Still, relying on that is fragile. Cache ar->ab into a per-iteration
'this_ab' and use it for the country code programming and the log messages
so that each radio is handled against its own ath12k_base regardless of how
many radios an ath12k_hw spans.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 54056dd37409..82cbb5b9cd11 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -15043,24 +15043,26 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 		wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MONITOR);
 
 	for_each_ar(ah, ar, i) {
+		struct ath12k_base *this_ab = ar->ab;
+
 		/* Apply the regd received during initialization */
 		ret = ath12k_regd_update(ar, true);
 		if (ret) {
-			ath12k_err(ar->ab, "ath12k regd update failed: %d\n", ret);
+			ath12k_err(this_ab, "ath12k regd update failed: %d\n", ret);
 			goto err_unregister_hw;
 		}
 
-		if (ar->ab->hw_params->current_cc_support && ab->new_alpha2[0]) {
+		if (this_ab->hw_params->current_cc_support && this_ab->new_alpha2[0]) {
 			struct wmi_set_current_country_arg current_cc = {};
 
-			memcpy(&current_cc.alpha2, ab->new_alpha2, 2);
-			memcpy(&ar->alpha2, ab->new_alpha2, 2);
+			memcpy(&current_cc.alpha2, this_ab->new_alpha2, 2);
+			memcpy(&ar->alpha2, this_ab->new_alpha2, 2);
 
 			reinit_completion(&ar->regd_update_completed);
 
 			ret = ath12k_wmi_send_set_current_country_cmd(ar, &current_cc);
 			if (ret)
-				ath12k_warn(ar->ab,
+				ath12k_warn(this_ab,
 					    "failed set cc code for mac register: %d\n",
 					    ret);
 		}

-- 
2.25.1

