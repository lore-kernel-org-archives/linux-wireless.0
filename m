Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD6A50AC1C
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 13:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650727; cv=pass; b=loyYE5urmv5dIBKNXCE3LFhguwEXLDdpNKV/tWFQT2STMwIi+TKzAyks9wq/3WSfa1GHTNGMEd47SizgA4xkupXuYp2OXQRQ48z/L7rsf1Sw8z+hHdWWUDaeqt1fPkokm0NoXq4inmSqjZ46tcAGZoogPOYF41ZeZq1ABv599Zg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650727; c=relaxed/simple;
	bh=KcU0NhCjCM0mTgG0KIsg4O4+gBDvImg9fuTZ2t1JmwA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eH7v53fB01w5KW/kB7cArhQ4N6XLTfrY5tiWDh8zAPk8Bie2pYuHYDFKJhGA56nnKa+jw+bn1KhoDrLR5K5KqS76t8tpQssuM09ccRX6A7VL3gyd7Wnxn7/76QLMhEZvpicRgvH9sxq0G94V5/Dmo1KeYw3eiPMcpqaGOwUbuj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mGe2dJxP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VKeReIff; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mGe2dJxP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VKeReIff"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H9ZdDH1150241
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 13:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZFT0Sm/+O+Qr/46avyREHDePIozflXgT+OQM6AD0D9w=; b=mGe2dJxP1fub/WPy
	LkjkjsAgh31AM75u4LElgySZX8+GcqUQtc69khI06zA24WpuMwPEy5AIbiLbdGNR
	Vh0ujUMvlDI5cJaCfsk0WF+BalNcSzZH+zP9AHDj0gXupUxd76kJtz/b0Im5rjQh
	6d36r+QG3iVlUtDqVaqeuwGu2uYWdrSqDp8G0jzkaEVbO1h25xPVQSqa15lRrxSY
	TkGNgvy+OAid2HSGYfcHH3MdwP62yi74iZMAb44iHWcTLjpxsttqHBB/PQrqATol
	8ZeNnMNEYogGZPKbJJMObrk0jFC8GkN1vGEZu+HZF+Tr5fUHQNqSJmrcsH9EG79A
	vEefXQ==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4grc9w9704-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 13:12:00 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4be498aca30so904498b6e.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 06:12:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789650719; cv=none;
        d=google.com; s=arc-20260327;
        b=GQu3Fci1n7s25GMymJ7WYaC7AUMsrLaZkFxwKUpU927yo8FehTKZ0jhaPsa0kN1m/w
         O921WA7QydcmqmzSq+/CiIBoZg7vSdRhJDDrFmZI1vIU5OQdcQw5ix+scy8CJSuKMIi6
         nBQsxlr8VjbmCGdBcuWzsev6lYdyTWufj38mukG4WblXxOYORDsYC6P73yEgl4XhohXi
         17Cu6Yxd9QrjFuuIoY2QPL3syMd5vWBi6pnUkA6i44hhTILW0daiB4/oQFi6xmuGa12R
         4qKuZ/wIZTT9AysRFQVopjuNsXpxREk0/olK25CsBxpu9LQDndVZn12bO0xNIrvPmnvc
         t16w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZFT0Sm/+O+Qr/46avyREHDePIozflXgT+OQM6AD0D9w=;
        fh=/FmOVc1uho8rf2r0mBbl7C2Rs+BCPcYlm4M0pXo33fA=;
        b=dHUi7r0nl2Svp5j8OwwC72tbSCjTCfXKBDC7diYxV2mfbJHpVy9sQChzPGKlRLIbrL
         tVdQGO7VJYBkdgFKc8xw7+yYi72+PZtAcF0oeawzWSDylAEDj0qdkh4dWTcHADMZ8rNQ
         Eo/YLZTpU+Fnz62riwYzGPIUpfRlDGD5Fy5mnmo0rKLUa8+8vCJYaMoB7DecGEi6HcGL
         sAP2V3oEtVz2XxCorWkGv26BJgiim7OWPV8NAM9f6eB+AImLloNkn+3DQhoZbc+ua62T
         rIh/cgWUou9kLa/DCJHaxi4L4en4ffmQL5Ku5sz0dbPDbfbg0/w6q/Muajh6zcom/zpP
         9WVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789650719; x=1790255519; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZFT0Sm/+O+Qr/46avyREHDePIozflXgT+OQM6AD0D9w=;
        b=VKeReIffWG4Qt1Hx7zwn+Laxx5flc2s8LeEDKlhtmG74nq6+45dOapVWyPsgPTofBZ
         eA6jJjA01aemdSsvKPK3QEKBAcq9NRXHBjjoRjGThp+IXiuq44JnDdCWbZe57Arbl1S6
         KKCpImb8ERrMsWPe9oAzDl1TEjkVX9/2C7EAqDWphhVZOMn7AHKOVATiZwunUQTKIJ43
         EjXOQLBOqWjNi+loLSfHUVRlkHxj/Rps5+ALEIUzEp51X/ki20+kv3HV/TDBxczDR1+Y
         ovv7Ue9Eoso49DeQV5v5pwxAd4RUulk62wqj71454FUFgJ8cHH6/mhfvxO/182aeW4b+
         kRTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789650719; x=1790255519;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZFT0Sm/+O+Qr/46avyREHDePIozflXgT+OQM6AD0D9w=;
        b=qQ83YNk/ffvYQjMADaHQi71PrRmswpwi2z1D3Nlcn/mrOn2T32bb734JKikPmfQmFW
         G6m/a6G+z3OhMIieMeP/KwrK1qV+pxqo4eONopdl1Xlo6L0y3REX5Ny6faNaLTyxoQyA
         7L9oYCJaH2573lZRcVDZ2u4yNSd87G6W/dl1UM9ZkznI8k8LXdkTMfp52clfk84xwVmD
         BdjR084nl+TTL0d1Q2YPfmOrgOcrMS6WvUAht3HJHlin+mlShq1boQX256FoBF7vok9F
         VTf8mJF8S2tOSr2DZ6MWolHhKwz0GeMJO40Xg27TdXpYvWWOC8J7hNDd8tNc0gUXonIs
         78hQ==
X-Forwarded-Encrypted: i=1; AKwUvBwgtbRPGc4AExvWLGLEoyrEHNVhVaOY10lOUqr3lzlDl9j6on0XdNIDBUTIlguj9q6m7oRbyTXXbDEBrZr04Q==@vger.kernel.org
X-Gm-Message-State: AFuF++n7/Wd533JVIWU+l90OG4gs76rEyxnSxuBdFw6jInvDXvwIzIzc
	Q/RZi40WbjEiEkwqU4dtVs1M+XeOZZnKHa9/irzFl7fyuIaQuXnViSCtxI9djxtkm7fO/6riYFj
	hKzy9dh8Me3h9edZlbapATkba5joI3jVgqLnjYBDsgpmlSuAIka8MGe8Ymjc5+kbqp2xn2G8qxj
	es1KYevfg45oL+JmCMpip76kI+HBfaN6/wSD8P5AMb+eM/
X-Gm-Gg: AYBFou3KijzcMvji6p2h01bi2zPr8qU1sAiANcUNBuo2QfeKYUFE4gzir1XzJZ8S7ka
	Ttk1txPcsZDau13qX2PWPC58chhm6iGbtr6bjVZJ0QM31Z+HysWKiAFlG1zHKt24jyMTLbGI5CJ
	oGcOyp1HeW0Td59mxrGmpuMNXAs5k9drs+ZMnlLCd2OH6jpaw3c4+DkwhRYWle57zIQt4FkCY5x
	RnM7eyFsRBSYem2T2K0nbFRblK12aTkaUrcaw9I8SRknBeW6YtzwBNfT/tPRUnnX2Y+ke5BKQ==
X-Received: by 2002:a05:6808:16a6:b0:4cb:f21c:a79a with SMTP id 5614622812f47-4cbf21ce30cmr1379125b6e.34.1789650719571;
        Thu, 17 Sep 2026 06:11:59 -0700 (PDT)
X-Received: by 2002:a05:6808:16a6:b0:4cb:f21c:a79a with SMTP id
 5614622812f47-4cbf21ce30cmr1379100b6e.34.1789650719177; Thu, 17 Sep 2026
 06:11:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917120810.2150534-1-vulab@iscas.ac.cn>
In-Reply-To: <20260917120810.2150534-1-vulab@iscas.ac.cn>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 17 Sep 2026 15:11:46 +0200
X-Gm-Features: AcwNN1Vv-ei9g1d-xezvG0sj8-CUlz2SjT2lgneKNLOHWe_wBi9qStJQdwrc8YY
Message-ID: <CAFEp6-1sjie=psDi+uzfN14GXiRPOg1FTTbEdkSgejCg8qNweg@mail.gmail.com>
Subject: Re: [PATCH] wifi: wcn36xx: Fix tx-rings-empty state leak in platform_get_resources()
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: andersson@kernel.org, kvalo@qca.qualcomm.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDE4NSBTYWx0ZWRfXz06vK4gv92LY
 ccsrqj/YWc6b71MVWAMdmDhjcr3WpN38gG//pZGjIY3WngG4DIfvWrrx+gRejleP39UD2oWzLVP
 YWmmoj/hcnqBMcH3XD4pCe1GmyLFuf5GXhBOP7YY5URjNmDuOTVPeKXdY0/oFqqtbEiNiHnz5Vi
 SHDV/mtGIXM/bfJo6uPfaWv7I64NuPJZbSSXJlv1fDYE4oRuin4BMnpHjyNEW3177AYqr9FlUrO
 lUt19Kqih2HyFe5/31nL+JM9rXnBQd7Z4fBy7fDn2S7fFI8WARY3xXjOrhtVAfad2v8aaNOZJPz
 FskCmNZwXPfNnyKU7JM1xszen1fZ/QMEKRL22bKnk7k8NakFY8A8b+xRnhfa3kvVHJQEBsZBT5C
 TICOYdxsAOGzgjSS9K/k9vYG3zVpLJ/IofQyva9wh5LFr5k0JH+fGX3gmqIRT/gPnCZK5eCcAyL
 DgNvw6q8QjOY7Hr0SMg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDE4NSBTYWx0ZWRfX1jPH3PLmXNsH
 5dac9/3cSBWK6kCxGrPC7qYSYtLu38yXms34UIvc+pr+H3TF8zqhtSTnVCsAYLl0B7f88WvYy88
 NrtFxD5Rpl6O4haUEBh0uCKGlp7fNyw=
X-Proofpoint-GUID: kfe4dChb5xKEk3QMk6L1jT1eWeObwXUF
X-Proofpoint-ORIG-GUID: kfe4dChb5xKEk3QMk6L1jT1eWeObwXUF
X-Authority-Analysis: v=2.4 cv=EsZHPicA c=1 sm=1 tr=0 ts=6aabe720 cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=ZpdpYltYx_vBUK5n70dp:22 a=VwQbUJbxAAAA:8 a=WtPzXf8rR9-QfVEoJm0A:9
 a=QEXdDO2ut3YA:10 a=efpaJB4zofY2dbm2aIRb:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_02,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609170185

On Thu, Sep 17, 2026 at 2:08=E2=80=AFPM Wentao Liang <vulab@iscas.ac.cn> wr=
ote:
>
> wcn36xx_platform_get_resources() gets the "tx-rings-empty" smem state,
> which holds a reference, but only the wcn36xx_remove() path releases it.
> The reference is leaked on all the error paths taken when the mmio node
> cannot be parsed or the CCU or DXE memory cannot be mapped. Release it in
> the common cleanup label.
>
> Fixes: f303a9311065 ("wcn36xx: Transition driver to SMD client")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/net/wireless/ath/wcn36xx/main.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wirele=
ss/ath/wcn36xx/main.c
> index f34d64464f64..a55861e65481 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -1555,6 +1555,7 @@ static int wcn36xx_platform_get_resources(struct wc=
n36xx *wcn,
>  put_mmio_node:
>         of_node_put(mmio_node);
>         qcom_smem_state_put(wcn->tx_enable_state);
> +       qcom_smem_state_put(wcn->tx_rings_empty_state);

Look like you depend on another patch you submitted separately? Please
keep them in the same series.

>         return ret;
>  }
>
> --
> 2.34.1
>
