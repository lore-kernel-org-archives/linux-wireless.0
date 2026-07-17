Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F9342DA34
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300774; cv=none; b=ZeFwbUN70wt6GSDe5Lcsgvk5uOcYN/ZKspfhvHcAhfHUG2ktv3Bp5byQjkcgNpsJtWDiQYHeruIyI3BZiRrG0CSvUK6kSFIdW33caJs7zZV9jH2t3CSd3arP0henyzjCX42foXd7J8aNv020jofqfnPRf0dAWEA+AG2xB8iN1BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300774; c=relaxed/simple;
	bh=PxutWW6URUosvvxkWCecw0QmQw0ucEzURk+CVfDgAig=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=eadcvSok5/AcjkWDANboMPwSesaLMLWv/FX+PMv1lvDU+4cAcIPTdVgpk8Kifb+TUXi2X66IUnMIDINepW8HYMwHqsNn3ODOGNOA01TrNvfo7Y4wpc7DgzC+NukZm1cevo2/ltnWgL2CqJA1/lfG0HtihLPBs5CyAUI9ks5wkBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZQMGjd8x; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JCGyGRYe; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZQMGjd8x";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JCGyGRYe"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7nlG2187159
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jhBIZMccLVYKoKLPzahq9/F+DN1p863eyhmEtFKOKYc=; b=ZQMGjd8xo1pzgrK3
	Vc0RynA2lzXPgHdo14YmdjVZJUMWIW4KN+55LNb2zwxoXs2jcKNXkuT9AuJTpyQ5
	w8/1Pcn0N05rpXdYmtrwhmTYXCpdpjEA10vdtDt9BtwMO5Geys7c2mECRj9n0/vv
	IA63t74usSx0eY0fqqCpPMeanUQaqKPoZNxkgCR3/chDZrphhkCEFaBla4jhYAr1
	Vo2RkrQc3OkCQ6UWFNg4X7c2kzkn+9RAMYVofuljGw1Kb2t30AUClD6GWVl7FbA5
	ZIQYUj1dpZqLPkoSurIK4s6hvslwawrWcWMbS6s5HQWlF22GO+u+S765MXXyFpJp
	J5U0uQ==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffd3atd2y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:06:12 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c88da04b719so4128410a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 08:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784300772; x=1784905572; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jhBIZMccLVYKoKLPzahq9/F+DN1p863eyhmEtFKOKYc=;
        b=JCGyGRYegyfPVIQdEw6Mzx8pbosDuX7LabLZGqu/oSNP8YZL4xqh2PqwIU2Dc93GEl
         knqnLHcv6lk271P5GyREnG4PG5LXgiRE1uO/+Eo+/dH47/Z9n79KJPPTw87AkfIZyMxO
         x7HSusxM2B1qzlGS//YFAhwtF8YOEE4ETIvIykwj+1oAOKtAGJ6cHZgxbB6orGVjLJqN
         /V9wT0j9d44Bp5x2oBpQXMVet+bxZBdBXpmwsCEBTsJWCj/cCkh60CbrBvbFKQ4tZa4a
         St7ZQnaYgO6a5coFjBtHFSj58r2FbtnNunrGJVnHn8Mr+Euaaj6b5vVJDEJ4d/rd/a1p
         1PaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784300772; x=1784905572;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jhBIZMccLVYKoKLPzahq9/F+DN1p863eyhmEtFKOKYc=;
        b=r8xxslSpbgLNgHVMN0EcIyFlGTRPutq677NgLQqZUbsXAR2CWT6+8HE4HIfBWKtIhj
         2yJ5m8i71zXNhgqzmQGKaMVPYlwGG8uO1tTQCkS1z034tNCqaIztmggNQO4Indv/0au2
         VvNOb0P7YrWKXWCXN8q00+JGInct4de9TuzPAo6BoJWYW66xsaZvdGrK9bxA8ct8AeRA
         fHzMLeL6m90G9DG1lXfHT0fDhUErEY71vzRJyYweCtfLW0Ai7KUV/Ryi7i/n/jOF++H1
         UFjyJ25ptG//i/yDtMINWd001wXH6Gc+yPKLuaA57K9Sk0kWPa9Uh0CMctblDEft9cU3
         4Y6w==
X-Gm-Message-State: AOJu0YxDy2I+jwBOHc/aVZq+D8ifYBMZM6m9mAS6dTmYddaKsvgqmcN9
	V1ynYICRvTnH+lXtxBr7b4QLdauBir+OR0PGDvPsRFnE3siAqB1+QCfUdL6ipnvxBGiobxttKTE
	dnxZsjoRYdptfTrbxbygu8SpZ5FCnkPcWmdtUvqwukvkYwfouFK0v1Dz4kmc5aiadeO4qYg==
X-Gm-Gg: AfdE7cnGVWHJSv91hBrvdNjL7/RVcNlL2+XgSwyA4CzQhsopz5xUuyn1xf8/FbXW5HU
	GKzx3Jh0VAvtdngxFMAXPBVhptbN7GZkd9ste7ljfG4sOY17uXXg8gq9SQ6i/slkm+9sz/AtS0G
	af2AY+mjP1Ek//cBXswcHeIINUlMaW2VV9TYn/mhCT1QnaZxlFa4tSSlj27jtfUtzaDQMAr6OCQ
	GnXSki7At5yUbDq6iNY0twpGksl60BqjXT8aJUzChi6tlLuLIWHpvLEnKB5w2wbxfLo4cF49v5y
	A2oO46eN5CS5kvpNPQX6PpXRdiWFPRkbidbJ3eO2cuPau8nOckfQYBRj4ma7ixpMKRAonqS7/OU
	Zwxwa2f+Tk+qqroHQs1FFe5qtI3tBINvBrkJIzrhcy3Mv8uTerx8A3MQ=
X-Received: by 2002:a17:90b:2785:b0:380:15fa:c5b2 with SMTP id 98e67ed59e1d1-38e4b42dafemr3169556a91.18.1784300771702;
        Fri, 17 Jul 2026 08:06:11 -0700 (PDT)
X-Received: by 2002:a17:90b:2785:b0:380:15fa:c5b2 with SMTP id 98e67ed59e1d1-38e4b42dafemr3169500a91.18.1784300771170;
        Fri, 17 Jul 2026 08:06:11 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm15681190eec.21.2026.07.17.08.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:06:09 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
        Masi Osmani <mas-i@hotmail.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AM7PPF5613FA0B67FB95CB5305CEF9DAA209441A@AM7PPF5613FA0B6.EURP251.PROD.OUTLOOK.COM>
References: <20260317110634.70347-1-mas-i@hotmail.de>
 <AM7PPF5613FA0B67FB95CB5305CEF9DAA209441A@AM7PPF5613FA0B6.EURP251.PROD.OUTLOOK.COM>
Subject: Re: [PATCH 16/16] carl9170: cmd: downgrade transient register I/O
 errors to wiphy_dbg
Message-Id: <178430076977.128359.15326896412981805661.b4-ty@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 08:06:09 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX7TrjX0YGqTUF
 3mkjXoj0EL771xR3ncFoNwwdSDiuRjDx6HkcoQuhBLFFOZdkl6PjSOPa1Qxa2GVX7pzWKWy4eg/
 oM/zMbfo1staawuv7ZmBhnNvJ9+ONgY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1NCBTYWx0ZWRfX5cx2K/U3Wz4d
 HYVVXwCJHj1w35RW3GQ4TEp5yZZBmwi71Vu12R3TNw46j2Y7jmvl5edC7Euo+6Km24z5FGff8bq
 tYPuztgoUmpMIAYdirJqLzRkKNkgi9CTFgdAoJEG8Opxv7hkh4HDscoA3MVJ7j4alM2hUW/sSHt
 3tWZM8OzfpMbAh7z5WtGqpGb6eqbR7Co9CejdvTsW2YHJTIkFpnlWsu1Kbosp9CKz+MXBhirdqY
 HWTHdgwUPemzP5kVmdMTK5sIHShaX2piZz0A8S8qxjHPCqmNwzwSroJSzak5agFg8sBj/S1gSSm
 vjXmn41m6egJZSYraQju13wmnN5A8CdczFYKj6qwdZrBQMotF7ODpLrF4YZZ1OPSfqKRn7GUVAQ
 yV+Q+mjg7XH2czxNoPDHc8qbxaJbZ/Vg9unBiYX87TO8+0iBQfj06Ct+mvk3kdAt4opPAq/c1bV
 uUBPSQRXj24/cCcaJmQ==
X-Proofpoint-GUID: ZFzkqw8VFUc4-0lFL7arOzaM-s5nQt97
X-Proofpoint-ORIG-GUID: ZFzkqw8VFUc4-0lFL7arOzaM-s5nQt97
X-Authority-Analysis: v=2.4 cv=e/M2j6p/ c=1 sm=1 tr=0 ts=6a5a44e4 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=DXH-aSZ5xags5pjaKL0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170154


On Tue, 17 Mar 2026 12:06:34 +0100, Masi Osmani wrote:
> Register read/write failures during deauth/teardown transitions are
> harmless — mac80211 tries to read survey stats or write slot_time
> while the firmware is in a transitional state.  The command times
> out with -EIO but the adapter recovers and re-authenticates normally.
> 
> Downgrade both "writing reg ... failed" and "reading regs failed"
> from wiphy_err to wiphy_dbg to reduce dmesg noise.  The errors are
> still visible with dynamic debug enabled for investigation.
> 
> [...]

Applied, thanks!

[16/16] carl9170: cmd: downgrade transient register I/O errors to wiphy_dbg
        commit: 14941957d2825f62228a7db1fa6dc9cfba9fca60

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

