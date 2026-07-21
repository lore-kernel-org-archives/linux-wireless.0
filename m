Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E349547252D
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 20:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664149; cv=none; b=abazuFKH1KmukGvpxKxRoA7WlVk8s5KoXzQuzm9OQcKTd+U+fv8sbCfdZ7ML4QsBWgQP+3KlAmerGocNHsw4UN90V59/1JOhsa5Jx8kf8TVorEMScRFMY9ZuCuOHWuZMOtb/InEirjSrYvhb7OHDXLXFVRKD4y0h5tJJsK56yFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664149; c=relaxed/simple;
	bh=C5LUklAYcDfw5b+CR/zyilyGK6uujKoSgzLbSGSynr8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=k9EdXEUdI8u8DdyWqzKHWYxHBe1fUeBpkvRXixMfVwUjiwM3vqkB9TxyP03OUwdVZq00mEQpszDJpK6iGnr1zxWI0/7rNE4qoWov7eWdHuZNvhh1Xv6XZQxQJ4fdRKLEsk0vEEmGYl4V8xdeiVh5pw+f4X5conhc/L9dRwD+OfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Be/EUH4S; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TXsQdDSL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Be/EUH4S";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TXsQdDSL"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LHRALN2376115
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 20:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	M7HDa8lD442gBovq8r187WVDYGAUCBh/WDBaT8jv9G8=; b=Be/EUH4S4qWblnhv
	GjAF2JziCJuFE/iSFIhJEzXdfRQ1OJsVeE0WDcroUwXQlgnoeAlUTdPIm27IKFs1
	9PA26QKMzk3s7kTadNKf6oIzpYnCvoUlFfdUIPFm/bPtyJJo7B1E/+bzdKiXblbS
	GY09yP0nq0mjDZM7ham5QyOWMWlBQ5USwzJkqnEtiGLVruMr4OAE7YTCBD5CTQKC
	DC9CrEofxqZXl+4yc4diXVZvSC43XuinR6KbNTFA2igUvlYay6+6eHh/DxLVbaV2
	RdszfKFtsxTywv4FDLy0TcWA8ocQSANjxrXax9zDKaUudJY47qrwobB6kjNUpnZK
	qAmMUw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fjd6a8nt7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 20:02:26 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb6cf425e86so4001389a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 13:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784664146; x=1785268946; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M7HDa8lD442gBovq8r187WVDYGAUCBh/WDBaT8jv9G8=;
        b=TXsQdDSLe94BUlD1S0KZJfxQsDzwP3yYlTHD4Kwb2odvDZhoa+TYrUUn0YZcGK6vfz
         ikn5PBLEx+d+xgF+fnzuTnOyJU12SeijlmkGgc2THHC7P01/aU1U9TNlHx7JAfQlDN+N
         GIbjtEiAFeWUiEounRp74DLEOmsnDOvrgUhMhp8UC3lEyNRjkPz651dJmOCRvSr9zmLN
         ZTxcx2xqz1vBxxkJ6pxA/Gztp035g+yinKbxMHermvMIrcTjbQzq8mnvrD1HoA6goGZW
         8S8mj29PEx2U/Jtzj/YZPwYFQkcjWPQq7uwlz4Imth3uL6lrNfYdFFv+dvnmnwahmG1t
         6vgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784664146; x=1785268946;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M7HDa8lD442gBovq8r187WVDYGAUCBh/WDBaT8jv9G8=;
        b=iCj7ayDC8uzL+jZHZLi7RtTUAV7sKtUI2sOjKMPtl5We7RRW/02yT6ONWgZ+2jZFAw
         mhKto/RAMJYlzKoHhW38mvHRDUJ6prHyhfiNIIyYQ//7fw8THUzn1NzTWjh9j8xS8LHa
         kyKcxtiZy20yze0kcpPPvL2K6Ps9yC5U2JJrS6MAFmZ8/+h/SbM6PPg+ZZm+Z5bbEruT
         J0/DBoRfkZkvf/mc1eZRzA3OIFmHb4/uIR11eU3bwrzroIbDgll+jRTuCNDn4PCe+Z9I
         9hUCl+JRmprCBzXNmLvXxtUkeHr3464bSS/diU9LiB7DXFDSRuRAd0GLL1PzjSeDCFXt
         2PbQ==
X-Gm-Message-State: AOJu0Yw8+Bk/tHc5BHPY6MZ3IUqiONpkr+SxSO4ST8tiBoATemOa0b+f
	lPkA+F8DqX6jxaM3gMoecAoEZ/6ekf6to3+5GoqcsQFYjLdSvIOaV2jTGNxpP0XpU3/pmKi6SWM
	u7u7Epwz8+RStfWVNsr0S2WgzA9awS0ART8itMt69cR4HiqqB21kxGzkwM4CsahoQg+eJiQ==
X-Gm-Gg: AR+sD11qOT7flidV6xJCywDgepCcG6P14QpRfS+UAErIK4AyAb+BF70sJomnP5oCtCc
	BaTOm9AbsoBSkOQnaObPlPvqa8EZ4krtBIhUyd7z7+UDNe/cFciJUh9zJA7txf8ZxZ8U7za5wGx
	4q0IxUsKJPtwlQnEbzClDdfQHeej8J9hF6J3RQc+SC7g+8TVxw5ogjBNNAyLPTzVB9jA9GKkVUU
	EEhsGnjJcVjG/Szs5y0qH0y/HaeKH+rXpXNocT7H2pouEAHdYrw3cpxwpp4uZXtCG/wmWXKldF1
	WUyOB9t08Jz/FKU/h3E5XRFutijGs0SfwglGgStkSZgxJVR8KA9hJdO9UzMzvRpLQqt4bUZXHBm
	aaymUpjhYD88dP1j8P7eMR7Z+BCt/8kPvTpsIPDlR6etOSZi/QbF/ARc=
X-Received: by 2002:a05:6a21:d8c:b0:3c3:91f5:82cf with SMTP id adf61e73a8af0-3c3ad94bb70mr22036493637.46.1784664145652;
        Tue, 21 Jul 2026 13:02:25 -0700 (PDT)
X-Received: by 2002:a05:6a21:d8c:b0:3c3:91f5:82cf with SMTP id adf61e73a8af0-3c3ad94bb70mr22036455637.46.1784664145232;
        Tue, 21 Jul 2026 13:02:25 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147dc1b99esm1574958eec.3.2026.07.21.13.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 13:02:22 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260716-ath11k_wmi_tlv_op_rx-overread-v1-1-0b972b3f1368@oss.qualcomm.com>
References: <20260716-ath11k_wmi_tlv_op_rx-overread-v1-1-0b972b3f1368@oss.qualcomm.com>
Subject: Re: [PATCH ath-next] wifi: ath11k: Avoid buffer overread in
 ath11k_wmi_tlv_op_rx()
Message-Id: <178466414265.1747165.16576801380148077440.b4-ty@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 13:02:22 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDIwOCBTYWx0ZWRfXxp3P7fefU168
 +flnqZ/hn5bBLFeikBMaQc7r4YjC/mNJcakP7LnRHd1ydqeg7PLB2Gu3/VwXaEqnfvnJKWeGJfX
 K73AAEd97y6N0q9dynficTOJ52B0JTrfwATiC55+GCkwy1zFkF7cl6IX3aMCtwZFqcUdqxRTf+f
 LjfFh4tJcvEXBtJWKdM1aKgxl8WBp59axxggnIq1FaBW0z0wlsuXMSp3GGj1LQvMLacYWLfj5FK
 /S4fsz/dBN+qUqaJjwClUFLrpvEk7KAEcNjcMojCcT12ddYg+4rIk9bFMJTvPGvMyTAuoiyRikB
 2iuqb1JSESX1dZe+UOfbkIm1ziA29DeiFwev2KsfuhErvxN94e5qojhH4EyDuEmb6rUWyIunW8k
 mOqLtxm9GtB88+v2zT4baFeEVoW2TfAZ2DeqEnbkgCtgO6dScV4dCnVOhiSsI24pEtyhxaB11DU
 +tFudhDvx3dYkY5IUag==
X-Proofpoint-GUID: m58Ji0-q1BDXPY8HFo48n40arzPlnTbk
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDIwOCBTYWx0ZWRfX8QdSFfAqn4gx
 DGUV1/2YdACpkYDTFHxKf8X/gJXwFdj2Yz4S/BODI9nOVlBkmnzx2n/i+1TuWhfjYqXsBHH3FVW
 e4hM3RPclDjXciDBJL8sq3FNqysdUWg=
X-Authority-Analysis: v=2.4 cv=HvJG3UTS c=1 sm=1 tr=0 ts=6a5fd052 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=Lj7BFKMBFr4BX5uBSNYA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: m58Ji0-q1BDXPY8HFo48n40arzPlnTbk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 impostorscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210208


On Thu, 16 Jul 2026 13:01:31 -0700, Jeff Johnson wrote:
> Currently, in ath11k_wmi_tlv_op_rx(), the firmware buffer is read
> without first verifying that the buffer has enough data to hold a
> header. This could result in a buffer overread.
> 
> Add an upfront length check before dereferencing skb->data as a
> wmi_cmd_hdr. The check is placed before the trace_ath11k_wmi_event()
> call to preserve the existing trace semantics (tracing the full raw
> WMI event including the header), unlike the analogous ath12k fix which
> could use skb_pull_data() directly.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath11k: Avoid buffer overread in ath11k_wmi_tlv_op_rx()
      commit: 2ab768b2a3c0a31a6270d3c7fdd25912fc341533

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

