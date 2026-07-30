Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5453806C5
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785381037; cv=none; b=oALa05BFCYeAaJnKPCYzeIa45/Xqjh9ej0BXiZZI4eYyO4vWEtJoZL6hw0fJ240xANVO3HmEosFlRI4VCzPYgnRgZWJIlkkCG0fQ7DuyoFi5ioySh5QuQqVXLVL9jrjxlU0mvn7KmkZ0D7bAklVRrmq8nV2b1229r56sEjnXXEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785381037; c=relaxed/simple;
	bh=G26oBuLWBXTguVs1cjBDadH3KIV/Cq3VPwqIvFRppTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nnfnb6UDuISE58ScilqhnMen9HiPieydtjiUlCxA7nbRQbSnPD8xAJF+31KYNtliNR/JtYTBJ/htp6OPElmo+F510twrBK5fgANj+X0Lcg3XZNUdfH+mroeHvbGE/oKC/MLI2Vtsy6/EEVIdnjXt+zuy4K8vzAm/WWA8VHvG0qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=inlykNPb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IjgP/6qD; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="inlykNPb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IjgP/6qD"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U2i48s3941822
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:10:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Hru35mpumEb
	kOLf7h02q3Nl02jlJ/9pefcv0jtM38wk=; b=inlykNPbeu+ZWHbKW044qJZOKAr
	Vr0079Tvp4dzhVqybX9B0C18YX7Ek6O8U07W6nW29ia9IbpKNNtGUWCMffUHVbPE
	8fmKEwkcMaE18s6hamKc51Z5TBzyqCtqIOPrvF2+7RORnAzqs1ggDBF0l4/i/z1j
	NFZhs6pInncsnfIDld5CqOtapAdtbkDA+BN5Y20U8YmdTXryD23eX62oNqFE/Rvu
	kupg5SEA1wAtACLn5bmfoh9M/RoDm37QT9DzGiWZaZJjnLJU6sy+cG1K8FgGgQ2d
	RCUSoSco/4vbu8qpFYY8ddBMM+auhWNe5xGBiKkzyJj+hcwAHaKdx5WgDHA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqx3ag3bs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:10:35 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cf6acd760cso20025055ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 20:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785381034; x=1785985834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hru35mpumEbkOLf7h02q3Nl02jlJ/9pefcv0jtM38wk=;
        b=IjgP/6qDJJC0+ly/IdE2iSG1J1avc1sC7NtM97/NHdlfwTBd1d6FQFUd8RI9zyPQh9
         NkXlDYNVs6gkkEmtR8FvcPCKI+JYJbzFfEDVLLfnhnEIeENgK/Rc5wDeqVDY2pyVmDsr
         t7dPiZfkVrht/h7+fL5dRYroN+ugTFR2wGSkOtIcKMQb37SvQDL3Qoj4+gfMY+yLsH7M
         yW8mB0mCMp3AtTpDb3NY8VmKE/1ZCqWwZAj+mAn50fARY9zqRAjYpt9OGwHevUBse+mU
         WpW0ys7eMANQ5zluzF6ydS7O7ZYji7OMxnDmBRwZV3uD7n/VqQkRmMhIN9jgKOeaEZzm
         Fsug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785381034; x=1785985834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hru35mpumEbkOLf7h02q3Nl02jlJ/9pefcv0jtM38wk=;
        b=sL/Ph6Jfcn2qPiXHnOnPlRYvRz3shV2pM5rUQ3HJujW4NrGzTbYoOClE27ivfs9m84
         r7/Ieft5z/d/9sd2uYkxA4Nk/IqxX5CBfAumvn4qXq/pYX/vGE7nRZ1GurDhCqca089b
         UzCYV2tG3KJny+iLobKL+FOeadoVBN6rVKjTrYW/5lTHxKEhxelUCc21C3VllFtOK0UZ
         NxkDWIyGmczBr/2o3OxZX7HL8TIOIE3ICKSkmSpIHonKDFnJePXhi83xn+UfJWjBrXCh
         MLOLa8q6eUk1JyFCLTpbNJsUAaRwT38xK0WE8ulkkhLSv6IG1zaTmbeEn4Tan468AOOi
         EnlQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp0vDChcCv10HjLpm6I5jHJixG0wbDLYYilNfdlkOdHliAMepBH7Oy2Ky8unK+SQtHc9+3M5S0fmLFwkFMuaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyXQmzZdZyfiBajQepB89P6D5YK+LnhhLYfsxkxzANB0z0RVSIR
	IvHLuSmuSswpZ18hxiske65aeb5cr3AOiaD//mTOg7Jg/ERFhFIulwXDqXmvo2P4iuz9LEhDmS0
	Uy2jqmcQ+Crm2Aw+3xsyZsh/MupDjqqKRlyKFMRXW1C1TXQLPZyshbdea4/cWwg17o+HkpA==
X-Gm-Gg: AR+sD11/uoZy9uKalB/eaQGA4ox3VJFSPgUF13ZcxV6Nz3mH53JkovkXa/M2BqpOrcj
	ZDgG2TIrQXXmrPJvjpL0IGuDv8uUvHVBjRwWQWi2FNg8oP2Hw/gf/uR8M2cxkbMIEi3ADUVQzPX
	lJ/hDPVScuqw6X0Y889fmPnaie4m1ajwdSWEGEa82A1KFB3b2kvUtsgPQ4gi1mDZ2ti7YjU9csj
	3J0w6C6YcONdWpLYQzS4z8SXOK8TDKAoivJqi6eqszGV5abnUeXfXynF5OyDXK3sDU09NYOC8um
	1fg1I5SgNALsACHMMcOfiZ8J3a0OYBHDoYbBQKPqrAIJQS0ZI4iV2Sxm9x8wqdikfMaz/wCU+Ok
	ffVhE3xtUn9rzjgqam79Fg3+4E2gQ5XscHhefL5DNMSEVHE6b7K3TEYPCqoI=
X-Received: by 2002:a17:903:f8d:b0:2ca:c68:c554 with SMTP id d9443c01a7336-2d035e66a85mr9174835ad.38.1785381034453;
        Wed, 29 Jul 2026 20:10:34 -0700 (PDT)
X-Received: by 2002:a17:903:f8d:b0:2ca:c68:c554 with SMTP id d9443c01a7336-2d035e66a85mr9174545ad.38.1785381034046;
        Wed, 29 Jul 2026 20:10:34 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c2e5b2sm18928035ad.74.2026.07.29.20.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 20:10:33 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [RESEND PATCH ath-current 3/3] wifi: ath11k: unregister PM notifier on QMI init failure path
Date: Thu, 30 Jul 2026 11:09:48 +0800
Message-Id: <20260730030948.147892-4-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260730030948.147892-1-miaoqing.pan@oss.qualcomm.com>
References: <20260730030948.147892-1-miaoqing.pan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Lvv9pSyCtActccEtgHOsfSmHnYpK96Ay
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAxOCBTYWx0ZWRfXxXwtKxZzBuwu
 8AZuExYMpcJwiRjw2xCv7tcOTkKNnWQYE6H8asKosZq8RfETLHkZrlJpXPi0uz4bWJFcMG/8ePK
 aB+JWS1oYQ+Si9I12b3c/IgUs+82TBE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAxOCBTYWx0ZWRfXwCEmpPkWE1lU
 Rit9BAXWSPo78gVsPrskWNGVKWdmMtvNFXdxSH2/F97BMLyiNSR8wa5iux1Pa58Rprznj+gYA01
 UBYd7LPoMv5d1kXeyp7hOZqv4Z1sAxIWztn0RaK0YtUpEBakjHPbRzqE49keXq9cp+Fv+iGHNtl
 2F2GGPx7WiH07BMngHL7JEsXYlGLdI1+nkOP6jHph/3dsNtPwGAw60NfT+JMOZxFmNCnpQdVaez
 45H/s9Ge8spjHgURtna6uFhlEoxSmhhyLWEgAf8gchQxr7CTRApFYm4iKXa/Pl1B9IZ+tKb8Hju
 rpJVTuxveISTV8ArTkO9hOrC0+8DaGtdblAkNnCGyXWvYh7nScfrl03k4XmCEzF8ZuHHZ+9QCmv
 IKPI2Qhy6zXxz8ht1eFnLPsPA+vHdR+bamzrRmRmRPuyTb2k7FUMSTR9KoWiqpiwh2TU9E1Oscn
 iGaAgPpJG53rvEoSt0w==
X-Proofpoint-GUID: Lvv9pSyCtActccEtgHOsfSmHnYpK96Ay
X-Authority-Analysis: v=2.4 cv=S+7pBosP c=1 sm=1 tr=0 ts=6a6ac0ab cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=FJAr2BPrIL5JYYbaf3kA:9 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300018

ath11k_core_init() registers a PM notifier before the QMI server
becomes available. If the QMI server never arrives, the device remove()
path can take the early-exit path introduced for QMI initialization
failures, skipping ath11k_core_deinit().

As a result, the PM notifier remains registered after the ath11k base
object has been freed. A subsequent suspend or resume event may invoke
the stale notifier and trigger a use-after-free.

Fix this by explicitly unregistering the PM notifier in the QMI failure
cleanup path before releasing ath11k resources.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1

Fixes: 32d93b51bc7e ("wifi: ath11k: choose default PM policy for hibernation")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 7f5f5c8d7c56..bdb8c99f10fa 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1272,6 +1272,7 @@ static void ath11k_ahb_remove(struct platform_device *pdev)
 		ath11k_ahb_power_down(ab, false);
 		ath11k_debugfs_soc_destroy(ab);
 		ath11k_qmi_deinit_service(ab);
+		ath11k_core_pm_notifier_unregister(ab);
 		goto qmi_fail;
 	}
 
-- 
2.34.1

