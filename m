Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B13363083
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2026 06:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783923735; cv=none; b=czccKEm93PozSOk8XykkuDz2LPrqQWDJVm2RW0/AibF7iwzeu5jWREOwTU+1ltL8tGz+JkDV+28YW2CJjPGBl5tfdQIqT3BvjBWLfsuGPC5t8RGdI5/OXJizbuzoMfLlO86b2TNADuw6z+kEOT6d00+nn7pjZq1tsdFeF5H9QRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783923735; c=relaxed/simple;
	bh=Fv4ra6CCUhtFAgCRJRWPLitFognj+61O3R5ahS5OODo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HLa5CHIRnTPzE+91lnBSLZNz38QSYAomdHPd73OemjQVEJN0wjWiAj/QOxH1yLPUoMYu42Zd5iChkFjuoGQRJCYRrE56JtRkRRGQrCo/HqtKQZLeitDQUu8IICLtxEqddFdnyZ++OPQu1kryEqvaPRX7YKFvUqE/YWJjC0L/wmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WK6aCM5V; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HsIIey3f; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WK6aCM5V";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HsIIey3f"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66D608Qd453792
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2026 06:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hKmY/uOXImK51f4X9cubEpPbPNQzK2Zc4IKfTxxi/cI=; b=WK6aCM5VGNlkRX8s
	pwBKRzyo45ij9jJmOJ/HYD/vMWTECmV8tu6qM2i8AoFGaKMhdZ7PDU7yXeLToCWz
	oKvlWqC1LQ20pzwKoOvY/M/rc7MwrEDd7rDmLWLzAS9wxvZV1vgWqeYR8sblej2L
	HvsOZ6OvtBqOJ2mYmrpBrpCQ33fHOBBzB03uMC6IA7raMEk7maCRX+XnndovsRNJ
	rOUryuAStVMfjH7Ux6eReOP9XuhRFPLT94EtK6o1Px3kUBPA8zqTyieEsRzixm7U
	foInm+EIZQyrZKcbF5JTvksnvyidjQ6qzVxC7+gA78r8bASWemWkGLv0/WbGQMnc
	TWumGA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fctc8g2af-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2026 06:22:12 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38def480cbaso875392a91.2
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 23:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783923731; x=1784528531; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hKmY/uOXImK51f4X9cubEpPbPNQzK2Zc4IKfTxxi/cI=;
        b=HsIIey3fgOFeM5UnlOY2GAnjCCdzbRKIwSSgmGI51muRYtE+9jJZydBFOkuywTiLRw
         trz8EOpusq4+d2sT3LdxnTmGPBUZVJdQi/KkRUISOcQP12ib27Q1UsRGH6i2vLflQ/x4
         rEXF7RnGXU2uSHpfzAItj+0drj2pxCJlaFFizgXgQYpBoJWlJKWgC/Rh7MDOIOkyRoJM
         385HcSNn59ywa3msj9A8ypXc4ejijvN86j5NJVhDzk/lqRbsLqnJu/aT71dtptZZXkzh
         Q4MjkygfturKNIXAHY6ujGsPLaOL1lQza1E+AVfC0KsaPyURoNMUSQSq6AlSr8eE6G15
         CNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783923731; x=1784528531;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hKmY/uOXImK51f4X9cubEpPbPNQzK2Zc4IKfTxxi/cI=;
        b=C8PNhKPUZ+1Wa8TwqN/71ShEpPiVYWGt+Fej0wEf0mZuVhvTsP5v5VhRFycN+uB5BK
         fWxCBfDEzhsruhEU4N7fjkI1zJmuww/5dpltmiEhxe2tB9NJpvuwqZ12dKgXcQwI+Zk3
         2310LUXoVqQd9I7GAqG+FyH8HuDqo2/AZQppX1L4f0Q4xapvY/O1vy83yKTPlYgUXDoi
         e4U/plWLv6f6ETj/DRCtkFarop/3KotA4D+Old6X6D2rRKEAYsv3loLHLoPEFkA+dF6S
         IuvDObmQwvHwz7nhtHVMDDJaHxBx5wGFXBn3zR0rLr6Q7EhCEpA5Arrt5QleQfsgkmxM
         uQiQ==
X-Gm-Message-State: AOJu0YzciPmaAcAapBAI9x22/vC7SXv/01QD4zS+/x14e40m6s88d+Ft
	fMpNxknHZbhif9A7kKgEHX0sxrMQJdN2mm4865z1cwpPqZ+vcVAyaTiRwLUVk8qZVxBsETbvA1t
	3A4au9FtDQxKUW99AshMRgmSxDGXG6FwBx2bPS/lLb8pqCV3sdGVI6BLdAwyIRXTJdlg4k/GsQD
	+MJLHb
X-Gm-Gg: AfdE7clxtrGjscCruBn/T9aJgh5EPGdGmtuLQ0UJmJ9hiBhXJ1LW6v9LhglKWw1/0wF
	MOI+uQRaYkNSJEr5ReYY91gTFoXh55RFjqGOEszRjiZcN+lM/eQ9nr1inUWiw8A0uV0d7Yev2kw
	De8P7FLTLwydcI3ahsTlRs4WiwxGLNZ9I/DM/UGD8aYn3rSMtbz73XIeRZ1zKTSkNPyQb6a/V94
	cQLv0Arcge5ZtTU71KXZa6DeDJMd/4FzohULPOErNTi3HzKdXrSyYXl95MSH8j1PODm220O5i3U
	jAawoIAphQv/V2ZN/EgBOZMjZTXceFZ/01rv3OgyqfeXkiv45QzMmO6iYmus1BD3XkjsXVeoDB+
	JNVeMclU3k7r+UDCg+zbuC8/cjs9eTLdhDpoKxFSGz13jyvbcHFk9Q+YsT8Uav4q7hRImbxHWKs
	vtAjaynVg=
X-Received: by 2002:a17:90b:1fc8:b0:37e:2005:6507 with SMTP id 98e67ed59e1d1-38dc75f4cf5mr7627848a91.15.1783923731276;
        Sun, 12 Jul 2026 23:22:11 -0700 (PDT)
X-Received: by 2002:a17:90b:1fc8:b0:37e:2005:6507 with SMTP id 98e67ed59e1d1-38dc75f4cf5mr7627830a91.15.1783923730824;
        Sun, 12 Jul 2026 23:22:10 -0700 (PDT)
Received: from [10.133.33.33] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38decd9a90esm1516249a91.4.2026.07.12.23.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2026 23:22:10 -0700 (PDT)
Message-ID: <6e36d6c1-9a07-4354-943e-d72d6b6af5ac@oss.qualcomm.com>
Date: Mon, 13 Jul 2026 14:22:06 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath11k: validate regulatory capability phy_id
To: Pengpeng Hou <pengpeng@iscas.ac.cn>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260704011040.26233-1-pengpeng@iscas.ac.cn>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260704011040.26233-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: of7JJqdv5-lOt_IGdwV4uAVHuUMQUNEi
X-Proofpoint-ORIG-GUID: of7JJqdv5-lOt_IGdwV4uAVHuUMQUNEi
X-Authority-Analysis: v=2.4 cv=UtRT8ewB c=1 sm=1 tr=0 ts=6a548414 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=TIgdfdpnsFF7rSLKS_gA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDA2MyBTYWx0ZWRfX2Ywj8BF8ZIDy
 kIwmbrSr+yPzEj7TtEP3h8i1a2JmSxCJ9MUZ54zHE2VFQ+fsIOITzM0xLVJ7rcn8t0KoJJ0J/LH
 A3V56R52QnrnapMrMluo3wN4y9/w/ww=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDA2MyBTYWx0ZWRfX6qN3XQ4K2u9n
 jtrigxohMLpwC/gkG7LS8Pcx29KRczcVQvCqKQsBnyEazdbQKEDzODQuepZG8fvY+pbbWhxc1zu
 XKmizOMJCJsM29vNN6khRxrveApIw0AIFhdSSOtkHv6ZgBvZAppj7Dhmnsdw2/6km+W11doQ1MH
 mdyY9G4zemQljnieF+KePPc31fpWfUxbxb02GA9g9wcTUbv6LEhxwZWEGZftEUQ4ZEzQjXS2yn+
 neDtCAP4EbdsPflziBGItezXDNN+bylUVzApdZpQU+C44BZgE3OyIovkQU5/blKMg8N4J4Hyryh
 5QVYw7wBCA6ykccStMpjdGlxBS/spaCf/vJ/uFf8C1uX/32ZiuZJGsJGPzsRijFfF1AUmD+Ckld
 S4WRjmySyWMoFZLngJ8xB3UKW4zhlpufDNTsv037envhI5pKCUIX5q5W42/mqlbhZe7Bmziu8XU
 HEmy27cx+QWXkcXnXjw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_01,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130063



On 7/4/2026 9:10 AM, Pengpeng Hou wrote:
> ath11k_wmi_tlv_ext_hal_reg_caps() copies firmware regulatory
> capability records into soc->hal_reg_cap[] using reg_cap.phy_id as
> the destination index.  The loop count is bounded by num_phy, but the
> phy_id embedded in each record is not checked against the fixed
> MAX_RADIOS-sized destination array.
> 
> Reject firmware records whose phy_id does not fit soc->hal_reg_cap[]
> before copying the parsed capability.
> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
