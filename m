Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979613;
	b=279km+U5fmRzBJxCxkgVk5u3xFvcT1Bt7gOTHWfBVYZdR4SX8VFNgth+6JncRoxoLtAT
	 KKG9DTaMYfM4of92kVPU9JwirY2pu8ayOOtx6YBLU1HTmLaTrCmc/Lcp4FGkP5tJBYAa2
	 Gks61UHpLrS9j4R/vDLsbMZUw/AWzd+VzpJAaIw/LRCI3/GiYSiSLLR5HXq/JzuB3wtC8
	 tjgzkLJo8yDgmhfLkIWGcz271Ndsp0SgusG2SMPmk0gY1l15VZ9uLxWX7bAMvdUYJnQ+P
	 E6eTBtd5ZBMigTxqOSGhwb48IL83pWywU/93MvZQDxMb6u2wAxktwrzV+IdotDfpgig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979613;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:
	 In-Reply-To:References:Subject:Message-Id:Date:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Mailer:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=Atjmq9rxdzHFbWBN1PM5pyNQLuI2w6lEpnu8PnoiDPs=;
	b=Igkx5/8BUID5VSofpicxhfSFrER4t5tiL041r0NqYz4Wkm4lmHyL8w/QyA+OZp6wfI73
	 tW/yJb1FL/T9KQYFSYBVYgauVQm2gKq55UrlPqiinVDfCmexYeKv5Iu6ja38vuClFePbc
	 oxsH2gqXCRfBXo7fC5TTCF58vHJxtmQ9iuHWUAB/XJhOLjdQWN+K9wDK3/44/cTQacvoH
	 /l1vPsS2qzKlRVB10xoIwcUlgn1PBH8lJGEBTDzKdYh3c3yJcQfO3rhUafdN2XoaAB/7c
	 odZttM17mnaU6/NgThdszRDG0hXKdLj9EY4llovrPIHvL5n7cr/u9DlxBJr5v3yC32g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=W8d6mgj9;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ZSeMddYy;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2252606A331
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 15:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2252606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=W8d6mgj9;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ZSeMddYy
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6F03Rl2671673
	for <linux-wireless@vger.kernel.org>; Fri, 6 Nov 2026 15:40:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Atjmq9rxdzHFbWBN1PM5pyNQLuI2w6lEpnu8PnoiDPs=; b=W8d6mgj9Xkbvou5B
	6zbyfM/9FG1ErD3c9jAku8uNrC6wEFv+bHfvgA4d5+9vKUFJIBS96tuHZ+oy+V4o
	f2o4R5MEtmhWyh6FFgOTGBjpLyYjnX4geVw+il2sKKbBqUwxmzsl0zgPFokayAp+
	JS0nUzYOrHdsuGszqCLJ2N7uoCwgBp9X070z7bvn5ZFT4VZCmAYJnICAKrA39mTz
	8rCmqeC8WeDgCPHPN0oPs7omo94oiBMHetrJmAoB0JncSuI4H3txlAtgmH5Or1Bf
	aHWDGjcrvr8IEQ+vyGOMmpRvYOXvnhjojK569ggLkIDwV6kfvMwcBHOwU5/ppKwn
	0pYfOQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hs3pcbdxp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 15:40:12 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-351788121cfso848686eec.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 07:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793979611; x=1794584411; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Atjmq9rxdzHFbWBN1PM5pyNQLuI2w6lEpnu8PnoiDPs=;
        b=ZSeMddYyGcMoKKvl31Hq1PCCR3JKKpQrYGD28E8nTEm+3dLnkxcOnsS0WcNlAVpLth
         Q6OhY1mxkrQ92SV2nqYf9qudtCjEUBlOUGAqiNINwnAUai1kzMPkdrbu5+TdLZWp1WOt
         +9biB0k+rHumkfsR/l6+zeggzmUDBoViMzI09WtBt2/nrEI/GEhS54W6wJA3x2eaprDd
         Zyrl/JziblZFW85cC9+8fVwEZgaDJcOyguO82gSCKXVqPX00/wmHNG2tXVmV8f9/l3pp
         danFqHvcaFIQHLkZNt+J+hSFE/MydXViGhiGrUZhil6CIOFa9mFLdc5kn5ZDVcAs9JSt
         TaHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793979611; x=1794584411;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Atjmq9rxdzHFbWBN1PM5pyNQLuI2w6lEpnu8PnoiDPs=;
        b=M9q2p90v9pTt4p7BvID0PpW0RDLiPcNtZ4tIw4siQDfj/xK8E+rNnBRAhl5bA9QvS+
         l6QscpAlYQw49hRz48yPVAgUkJYdWRs6uuIeO2SDuTrjX1+cnFlUgbeBxyn4Zk3PFgyF
         FBL9g8QDNFGW5cA24s3ymvaOLGpstZk2UI9sjroxUm1ksya/juwdlso6ylNbaVqKeAz0
         lnIAaUk/ckrpfUMKUmRGza0lwfygKhdyxVDuWNnc3TkcvZMZaOSOn3/B1YwshE04Q4V9
         nmhu91jW98swACXQxuAwHeQFi7PSpFASggtHo60OhyMjpXnhOtguo1/ByFX3I5mxzFwS
         v+Rw==
X-Forwarded-Encrypted: i=1; AL+hErFlHNWTtxPQxrouZH+MeZ+t0UoXtCiQSHuPAS49Y8mNuUkYblHy4jLPOl4ITxbBIwpgEHk3EueUigBRfmEHFg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+OtuQHq+5Op5coRRyy7eOYOpzvMAtSEw0ByqqNPzNmbsIsBnw/
	igtBRIr5ulPOmgpX0Zu1B/igavZUlvc5oSkpHIMHOZ3mgtKm3KG/elScEitUr4Y6xv5vUJOAL1K
	Vg9LixlNdDG7d9ZnX8r3zDtw5+alY0PKOvh/yu20gkzsCsNLOAcygTllTs5g+sWtvfWkl3g==
X-Gm-Gg: AYBFou12A4OOUZ+a+g6ZxLGCugm9sMVw9D4J6XEnzqKLSgo1HxUquC+VEdZua986TfQ
	8TjfUGGrev+372/hPGC1S18FZ5fentybQX2icaoPQR3MaLwuupbqu14DVyDbWwp8zN9u4gHYWha
	yQ8WL7/UWfUhxmnNUagjhAJ4l5aptT5dGNhiYWH3rDk6F7KecvrEL1CaKa+3yQXr1evboMDXoKI
	xNxJWnlqkxNrmr7UB+QSRuPHrqo9+yTkBfW8yEneQNmkT+CrFKFByUOPBjO4sm4lw7mJ+h2e7rP
	eIzvLmu5OjsvxnFvaGVbaWYwBf8XSivygnPF1HtGHFJciyOzTMEKZMuCYZF1/1CnnXL+eZudSSK
	FtYiSVGLsGiJ93HeqID0fsCX+EXa5ejKhhbAYkuVGdbYrop8JnzIUsStBbYe61n34jeaO4z8gDO
	ZqFrDD0vehydaHKmAzDzNLNpPRP4A=
X-Received: by 2002:a05:693c:68c3:b0:36e:2626:4ace with SMTP id 5a478bee46e88-36f7398b906mr3825471eec.5.1793979611085;
        Fri, 06 Nov 2026 07:40:11 -0800 (PST)
X-Received: by 2002:a05:693c:68c3:b0:36e:2626:4ace with SMTP id 5a478bee46e88-36f7398b906mr3825418eec.5.1793979610314;
        Fri, 06 Nov 2026 07:40:10 -0800 (PST)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa97fbb54sm9851246eec.13.2026.11.06.07.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 07:40:09 -0800 (PST)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
In-Reply-To: <20261030071912.107577-2-krzysztof.kozlowski@oss.qualcomm.com>
References: <20261030071912.107577-2-krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH] wifi: ath10k: Drop unused qmi_elem_info arrays
Message-Id: <179397960950.1195422.2420449019221399402.b4-ty@b4>
Date: Fri, 06 Nov 2026 07:40:09 -0800
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
X-Mailer: b4 0.16.0
X-Proofpoint-ORIG-GUID: DMlpNOjS7ztO4doUmzaq0ozNJZPS8Ic3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA2MiBTYWx0ZWRfXzFElQg8J/BHR
 6yxsK8crhLgcZZdAHbXCyvTVMlPFZX6NbXDExItwc7bAqGKK+h/agrv8VFMl1PiShyJxqxQzHdV
 XqbbjlPyuu+Zh7/kowJVBz7p3Ku0OLmxGPDCxvw5Msd3LpQIcutIU5aQXjY+RgNWruNHTU0WevO
 1tJmLLk6FlFY8RgQQA0xJ8xMLB0eH8C5/OqXinuxD7z0Z+qDmHeUUrq3eXJ9Fh9CHQrv6+7FkzR
 4/EGjDhokavUjud2ESkIDvnBt4NFQXeM8DmlV8gPT/dJ1EsCravCUtVXB3fTSv1mA4B/8fvKGaw
 nVxbDroufKIPy7gp/6/iCEhd8A7ByqOK6qOF2AnAT2kOxf7XxpnOoiDX4eobyq2vT4Xa6fhjWoB
 L+1Cc9fTIJz3gS0q4ukxSqc2gzZHenESxO76dv8OeAq7BHZWZ8vWbn7O/3erk6r6jsyWfjrYHF7
 0nuqZDtU+kCmkrBojsg==
X-Proofpoint-GUID: DMlpNOjS7ztO4doUmzaq0ozNJZPS8Ic3
X-Authority-Analysis: v=2.4 cv=TI3Q2Fla c=1 sm=1 tr=0 ts=6aedf4dc cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=ZoQ-0plOPn13Fw6eG44A:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA2MiBTYWx0ZWRfX5loHbheBRPKJ
 IzB0E911HZl0mEPFuoH1OW57++dc5Se1kXc24jHtBVaC5q4pYxTZVIMttpYpOpK/v6KaYRAoRtP
 ReObWOe9w26rvw55ljH1hfOWH7M1XIk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 phishscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060062


On Fri, 30 Oct 2026 08:19:13 +0100, Krzysztof Kozlowski wrote:
> 'wlfw_pin_connect_result_ind_msg_v01_ei' and
> 'wlfw_initiate_cal_download_ind_msg_v01_ei' are not used anywhere.
> Dropping them allows to remove bunch of other code referenced purely by
> these ararys.

Applied, thanks!

[1/1] wifi: ath10k: Drop unused qmi_elem_info arrays
      commit: d866eeb11be24c7bd6fabfd7da158ca8c16bbbab

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

