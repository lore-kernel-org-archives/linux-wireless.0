Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A82B3064A9
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300768; cv=none; b=Z6shNThWSzisHQjrbcSIafGPX4zLwx6BOn2q+qrgLxitj5amQ0u0JNK4aULU7HeSp8qscDG6NHOldiiRdwlJGA8YWIdWgwkFIz5Dpoq7IHlp2o/8OAZqyi/dxbr6QYvyx38b+InZ0tw6WIQ3eb9EItRpzkoFraa1Z0YFKknVbIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300768; c=relaxed/simple;
	bh=eM9yCd1ReLiaaku3ppHqOohpClnexCIfb/5pJduufiw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JzzTwjv7LbfsMcaUGuQSS+AwqDOxGd+ipmxCcaKH2B/WcSnixaJOhvh8ow3xMr990/kk8f3RX4gWf87fkTSXipClk9dypzh/jcBAnRmWYnJ1KmqTnK1x7l2oEIsz8UStTry0DbsfQYJmchtYChmGVu/tdganB+O7/J1f4ZJY1Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SflrSQlZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jydehySI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SflrSQlZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jydehySI"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7ixm2186819
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1nCywQWS6dZxbdmHFPkFz283Nd96b30DE91wyblDKLY=; b=SflrSQlZKWEcCAGH
	d1Zss4ELEOd+lVP3v6L8EzMVjdJD+TWyXn+BlBShN39bPu/qsi2RTskPqvMh5s8l
	kYMJfqqnevwywPo9kEQjSxymzJoyFu0o7zl56KPL45sI5nF7gXVUGDTpFAk8TjSR
	pLRtbJTIknh+MqSmAGRoXlYxfGNUeDU/WehZkOoFgcXyPL9kqiH8fe17Zd4V3JmR
	qIRqedHqL7EKCKIF/OpvG8YKYpNjF8xgVw3GqScZPXpdW7VzZV6SUG2SsdLc97gp
	fjmcU1QFdRmTD/fWTO62biE6uF9KBw4BtxmJeRXSnkENpe4ZbArQqlzflYHdkc81
	vhJBLg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffd3atd29-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:06 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3811279d51aso8304103a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 08:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784300766; x=1784905566; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1nCywQWS6dZxbdmHFPkFz283Nd96b30DE91wyblDKLY=;
        b=jydehySIw7QPNWZWWli1qKQWRynFB5GzYBPj7T/6JECqK0HOf4O65+bi9aIMV/4Ows
         ESuR8qgyynbe5GwsmZI22134mGv4n5ElGcs1LD5j/hAY4W++792a33XMuHzONz4UTFvN
         G9JAO5mhLZtwAZ0RdRF7/z7adzbI+eAGWhr4b9UJPyWpaGGJC7mDWL0IxXKzpjC+vWO5
         sdGC05bMF+9f2QFPxT3b8yRB6pFVUThxchgDqftrUok5g7RYQqxFgwoRWf2rbkZfl5t4
         uFPp0tOfgxECzyPdMIGRwL1whFyYMWrXEp6lUcZLHaycCvQ3NdXlnb8xNMWahjAxJbGI
         yYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784300766; x=1784905566;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1nCywQWS6dZxbdmHFPkFz283Nd96b30DE91wyblDKLY=;
        b=p2S7cSCvYsjSYGsCB1A/nbTZfSqatXkF6U0ma2JWMkbke7bBhi8YF03HqWuHyv1hyE
         NnJNbiUsNI5GPoEH2sODgYGCA00D9Ebui0GGe4J43uJbuyU2godVhHFylPkCo7eyY+BT
         RoEWYNfnK+Plq1oXOzK/7oa3defwFM5HmDqLHW/KDqr56xrZfbXgAE9w+hl4+zDdx9dB
         tUneh16YAByNwmgR6iy+Orqm/sQ/6renF3/w2yYQpb98OBX51LE1PN0UeeDKa/WizStq
         JOx67JBKumDBfpAj6VPnjd3m+Me8w0Fz6ClfyKCoLoEMX91DOIDAH/L13jfn4lFUVO74
         s2Yg==
X-Gm-Message-State: AOJu0Yzh5EodceSRIOryFQn4g2s/c902bgUd6O1YydnrP4RycONjzGK3
	iMM0QrgjLS8iK9eWt2ZMA1i8nTiioOBaBBVbZqbPtnmMvFqTxNFxdxMlrSZL+jroFKCW9+jtndC
	d4ur+avBlApaPlkMjHXVCEex888mBg6w2o9OCd+DDOLp3eEQfOLVRvhtVa++XfvUQffSG3A==
X-Gm-Gg: AfdE7cnUEBqv+1iB1nyIKjg0vw+bJfBzA5vAmYbyTIZ2O/lZ8vBZVJRBDNPJNS3PSPN
	TpMzHWyE3YDGhVgFcHNwIYMiqpdc4EyMiSqeOHMhkEvWRlJHOoGlalx3C8i9u8sO7B0em3ANjLg
	RNQ4dGXkMYKSBzCFQv4rS/KcSm+jgPHCQcC38wIIE9NjvrQ4kb4Dz18lC659BbpPWDSjTBHKzUZ
	yw8OP2jhstyPih1Ot6D/HGIMXFUNPFlYSErpknVfnP9MXnB+7SJxIsGGd0nYqCNqM70GQtiOCt7
	XnijJtXv2uqPF+DhHB5Q68JAiCi4AgEUoATRvti/c3J4eZ2bVr7MHayW1d8K+xhHhBGyGfrhUzP
	aS1nrgq1A1h0KAleFfzxFnChG8g3iJKOv83EI+ZJ0VXqUhn8W/jUSS88=
X-Received: by 2002:a17:90b:3c86:b0:381:20b:a9ee with SMTP id 98e67ed59e1d1-38e4b4578ddmr3351563a91.14.1784300765814;
        Fri, 17 Jul 2026 08:06:05 -0700 (PDT)
X-Received: by 2002:a17:90b:3c86:b0:381:20b:a9ee with SMTP id 98e67ed59e1d1-38e4b4578ddmr3351503a91.14.1784300765266;
        Fri, 17 Jul 2026 08:06:05 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm15681190eec.21.2026.07.17.08.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:06:04 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260630062048.1615178-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260630062048.1615178-1-aaradhana.sahu@oss.qualcomm.com>
Subject: Re: [PATCH ath-next v2 0/3] wifi: ath12k: Fix memory allocation
 and improve reserved memory handling
Message-Id: <178430076400.128359.5468109327642827422.b4-ty@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 08:06:04 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX+w/tckgkw8Ih
 SwxsCi/Ed4dFFvXJ4LuWBfAGikgcRCqz5xKx/cOi8Lb4b42btOGEo2KL7k98+5FMtNnkQKqV4mO
 raZGssWSVcUpFtjetqydArZ8Di69Is0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX5TlTygJOrl/k
 z90tmfxqq7StE0H4L34OW3NGnKP4HxsysL1TZ09JS9sCd+jesGCTnRuj5S41b5ILR8mRg0tLwkx
 BTWnQDaE3pbKGAGazxYxKb4V/0W5e3BxzFUkpX8BKfOQKjS7fG2ZkSjuKUR3eUuq0M0H2ISRnUL
 t6XMQ5zIsOpg6kFVV44jEfTbzKysA1lnefIZ1ClrB2vKwIMipxM1um6vY2C5fwocIXp44dh5/oh
 pcAmULoTQCbVOn2rQ31Mb8fhuAhomXlY6+VzAmilDvcYOIWwuQ2NQis1gNdeo4uH9HTehrLvuYr
 +32ZaEUHrk3SAzMdbfyXFBXuH+MBvXlvXW1rekPleKnxcM1c3nWghNtNTo/Rr9f51H3JzJmEPZs
 PDQ2maesWIoSREACP3jAhW6F3XX0Q3Uzkb9iX6Y0+8ctoHJkb9dT/Udqk4PJy9WpEmDg4gEthhR
 vYHXGolr6xvzn3pArog==
X-Proofpoint-GUID: 8IWpkrrfE3C1ju1Ef-BWLaWEYt_M7puU
X-Proofpoint-ORIG-GUID: 8IWpkrrfE3C1ju1Ef-BWLaWEYt_M7puU
X-Authority-Analysis: v=2.4 cv=e/M2j6p/ c=1 sm=1 tr=0 ts=6a5a44de cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=iHmrIn8OyF-cjVc_3aIA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170154


On Tue, 30 Jun 2026 11:50:45 +0530, Aaradhana Sahu wrote:
> The current implementation relies on index-based device tree reserved
> memory lookup. Different platform variants define reserved memory
> regions in different orders and combinations, making the index-based
> lookup fragile across platforms.
> 
> Currently, the driver allocates the HOST_DDR_REGION_TYPE
> starting from the base of the Q6 region, which overlaps the Q6 read-only
> firmware section. This causes firmware assertions during QMI memory
> allocation, as the firmware expects writable regions to be placed after the
> read-only section.
> 
> [...]

Applied, thanks!

[1/3] wifi: ath12k: switch to name-based reserved memory lookup
      commit: 2a1ac0368e1a891b1d1fa91192a2eaf865495f08
[2/3] wifi: ath12k: refactor QMI memory assignment
      commit: db4e4af6e8261d83c5658fc9a84fce37a9ae692a
[3/3] wifi: ath12k: allocate HOST_DDR and BDF regions after Q6 RO region
      commit: 3ed52d62f47de46dc1113671c057ff376d0fec27

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

