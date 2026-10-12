Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C17738DC74
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 02:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791773550; cv=none; b=dn5SerXa02eukxVWRBVeNqMIDtd3cPJs9WFsaVSJ/z/mw3EmtIscATcepP3clhjIPsgxcTUlLl3+4m5Yp5nrqWBH+sOgN5tUFPLdHujcx5fHauNHalmyCZwp+gAnGzrHw9SZnvZcXjUE/L+OaKXyPmpfxwlFZ6L1p6qA/AjmDts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791773550; c=relaxed/simple;
	bh=c1bq/qqkjuRGWjHR9UcyqCsfWN6iu6XHZr6qBKD8ouA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hsoyHbjt0M/arq1fRSJVhY2UlLS/5YkoIccXX3+0BZyFhuEkJxzG7kKT1Y+h1Kjzi2+KjEWol4uLkBQr4uiexbw5xuJ9UM0ED+inQpMKlp0RE/uoCHwOqrks7i0Y0s+0nn8ZFxkVes9ll1Vakb6q8R4KiyL+e2wBgsEi6mx98LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=P6rqp6Yy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cXr3saiJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="P6rqp6Yy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cXr3saiJ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C1lVrt3646469
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 02:52:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QJbREqwsQUUO1NfreZZnhUkKL1+aQh3D5/8AoPrzCmg=; b=P6rqp6Yy2CKdpa4l
	yjj10dDeodgVAgks7h+nP+wEK1O3d65zjptYwzVk7WqBwuli3o82TnFd332GwR74
	B+k4R/frn0OZX8dI5I0jPm0IFDauk/ari4N97AUoQS7T6NADO+h2It/m7S+kZCkW
	9bBlrF72GpHYEdx3GxOxN2HPquKiye0r/8hU7fbVs0iwLdmLrxP/g8tkG3JOFlRE
	tIcdZw8N5vuJm5L4NexYjjIp3GhwR3BoqXvgT1upXwBFqEma1c1Iv9D03TUCcs09
	N0KSAs1Q+9rM55olerqkwuG7VOjYV4J7lhtkdr65ZhehGkXYNMVF2Q3u84S6om8H
	Z+siRw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7ehjmb22-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 02:52:22 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e8dd9b9743so2323535ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 19:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791773542; x=1792378342; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QJbREqwsQUUO1NfreZZnhUkKL1+aQh3D5/8AoPrzCmg=;
        b=cXr3saiJITZDuV3B96MyNR9Y6x+aG4Ci1E6VUJLkIHzwYBVwLKwYOk6159Ok0VeYyu
         j2xy7Pgtn31snd16jHacjWLZGZ+5BFfuazZBIxOP47P8P3YIDZErxvorK4n+IwrW0T2u
         D77EEBp+PTNPxOwR/wuEZLEjTxvn/AsT54E94zHjpvNpCFQpThxGzq4Voh2dzg/1ZYiO
         MdbySvB7theQOagkyajtLx7+Wzy94up0JD0dOvJtDk+45TiGMhxxgbFhjLllu2ypXfG6
         hHhaA3qw4fsEJ6Uusk7Iq26lPwkVhK0KLcL7uKMCHlTvXV3tt3/sMi7FKe2ql0XbheWk
         jENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791773542; x=1792378342;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QJbREqwsQUUO1NfreZZnhUkKL1+aQh3D5/8AoPrzCmg=;
        b=pPvOmi9qZj2hNHqay3pecAAI38jHrWasXNxbuVc6OKXVeQMuNtPKpXG3VSu9FGKtcz
         CDe12jzO6IiI8X7AkK24scgGE8FG4XyTuvuTHVRoxJK8xzt+Sj+pc/m6I01MLg8yCQxz
         NP2WdwY2Go0VQ1oUe331F/tLjCmlUq9sQMHWjm1RT4OnxKFXqnmoNAsyXFG5X+C3wsnY
         +9pRA6NBZXQVlTYioCgX7R8AvdEaTZGXyLDJA5GhoiNUPoY5jcOfWMyUwcL6T3y02Cxo
         TrZbyTeUDAhyYDRrCkDBsWzw9MSGOAwgdRh3DnCEmx9NXgMQxmKsxFAs7dvu4uShyNna
         kGCg==
X-Forwarded-Encrypted: i=1; AKwUvBwfBHiph4hEp7r8ACMhJcnplONE5RnvT5b0MtCAyx6yqkwiozl/9uBrj9RjmQVrUhshvyE/xxarsoDPWmt6EQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLq5EhghouutaPYpopgDNf5nOjRQ67vHaXA64m0YxxP3BCgVU0T
	7RUbBMJFMPtfgpdm4as56O9nCXUg7F6R+igzrNRtaorFitgMW2574YJR0LFs4yXpRZH0/WX217J
	STEkjUDmxYru8YgnDGLJ+aO0YEk6J79inxHNNA+CemJPzkalfUPScVqyZIFnTpvTnya96kw==
X-Gm-Gg: AYBFou3qiF4SiT+o/fYILwy9HrP4tpMrs9rQexrWU3Wjd+t1QlEh6nH+eZpW//IiPmx
	SE/JKK/dNEropQiwYXgbnBMsm+Onjpp6lP1DjUrcaOJDHGWgMlzDnWxY3wagqw61qsDRnfPDr0p
	V8cVXw2dBS/0ul81I1YkT8CJtIE2RL+09CtfS/wUUoLzQkGuPi7Xa7OTW5dTqGb19jZ2eb9Hpgc
	PBGWAxUgLUkKE0hFwf+FfhBXJSH9piwsTCws0ktKlGoAMHeYqigqquIQpoVleIzkhgFhPKE17Ki
	MCXKOM55FtH88DOc4bQPONNN5OOp7I1D5G5+rap1uXrDSVRi4oQ2654IMTaGOy+xrtWrw4Qogmo
	klPf3FOaKNCoMiyXyt+CB5/k8SPkDgGg=
X-Received: by 2002:a17:902:e847:b0:2e5:e1e2:21fb with SMTP id d9443c01a7336-2e842ac8aa0mr79892065ad.37.1791773542124;
        Sun, 11 Oct 2026 19:52:22 -0700 (PDT)
X-Received: by 2002:a17:902:e847:b0:2e5:e1e2:21fb with SMTP id d9443c01a7336-2e842ac8aa0mr79891925ad.37.1791773541669;
        Sun, 11 Oct 2026 19:52:21 -0700 (PDT)
Received: from [10.231.194.200] ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422b8202sm35146905ad.51.2026.10.11.19.52.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 19:52:20 -0700 (PDT)
Message-ID: <c6c45288-1eff-420e-82a0-db9d92286db5@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 10:52:15 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: ath12k: skip hardware rfkill setup on Microsoft
 Surface devices
To: =?UTF-8?Q?Fran=C3=A7ois_Roux?= <franzelfranzel@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio
 <konradybcio@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        =?UTF-8?Q?J=C3=A9r=C3=B4me_de_Bretagne?= <jerome.debretagne@gmail.com>,
        Dale Whinham <daleyo@gmail.com>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20261006062728.45007-1-franzelfranzel@gmail.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261006062728.45007-1-franzelfranzel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAxMSBTYWx0ZWRfX5dmI9Cosg+gJ
 xe4NZJhpvbkcFtWnb6rS6uo/g4YQ8TY61hWxvAQqlVfwippwlANq29WCCOXHA+ISp1zSiP5Vzi7
 jYQKb/y4G6mkTKP8jlEiq0aozybslAOcQJe5tWqcwYR7KA32cfJkNtCbyjguZffG5yR8sQlwyVt
 m+sCKEpEXyTRLsPYHvGNViq1ShlhCtZWzRRt0n3R8Ggc+6iXNb2BjsJSHyVOTeW5wG7efwOkzmb
 Hqw9k5LEQNVQ50kvObW4eb48p3NsqSt16hI5l9SP2rKmP/pgQanAO0pZJrNom8E2CHXVrqULUzj
 IPoKDK4+f7dCNLHvRDljS1Jm/I4RlktKmHUJBROQt3mMABXD1ierHuGjcZ+QvO3ZMlxRbdIoGMt
 Kue0zts2bebkAhdpei6OVw8vGxt0Wn47PDqgVm6Cs9+V4kgESIGQ54ycYh5gIcw4JRZfYKFj229
 OWHuD5SnGEUostEBaCA==
X-Proofpoint-ORIG-GUID: Y6xCowICK-8suJITw4soTkZR5HVUMuoX
X-Authority-Analysis: v=2.4 cv=MpTHeGae c=1 sm=1 tr=0 ts=6acc4b66 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=4vkvQpwsUkj-1mQPOeIA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: Y6xCowICK-8suJITw4soTkZR5HVUMuoX
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAxMSBTYWx0ZWRfX271GN8T1U2Zb
 fiO5gQMo76ltUgIo8pInmJhmwQgG/aC5f6/AclrjuTx2wL9BhNFyQ+b/RzIDMYYjyrQ85yaZzN7
 OWqVoeAJODuQnRlusBhS/Gt1Zgu6du8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120011



On 10/6/2026 2:27 PM, François Roux wrote:
> On the Microsoft Surface Pro 11 and Surface Laptop 7 (X1E80100), the
> WCN7850 hardware rfkill input reads as "radio off" and the OS has no
> way to control it. ath12k enables hardware rfkill handling, so Wi-Fi
> stays hard-blocked:
> 
>   iwd: Error bringing interface 4 up: Operation not possible due to RF-kill
> 
> ACPI platforms can opt out through ath12k_acpi_get_disable_rfkill(),
> but DT platforms cannot. A DT property was proposed for this and
> rejected, because it describes what the OS should do rather than the
> hardware. The suggested alternative was to handle these machines in
> the driver until a connector binding can describe a broken rfkill line.
> 
> Add a table of board compatibles and hardware revisions on which
> hardware rfkill is known to be unusable, and skip the rfkill setup
> there. Other affected machines then only need a new table entry.
> 
> Tested on a Surface Pro 11 (microsoft,denali) with next-20260929,
> booted with the unmodified mainline DTB: the interface is no longer
> blocked and connects. The Surface Laptop 7 entries (microsoft,romulus13
> and microsoft,romulus15) are based on reports from Jérôme de Bretagne
> and Dale Whinham. I have not tested them.
> 
> Link: https://lore.kernel.org/all/2ixwny6hzumlqmok5cjwutvtk7nzmx4t3dhxc44ao4l2u755pj@n6m7jyxf2o62/
> Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
> Assisted-by: LLM
> Signed-off-by: François Roux <franzelfranzel@gmail.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

