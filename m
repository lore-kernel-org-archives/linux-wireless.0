Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC793B47F3
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 10:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784629419; cv=pass; b=LIWf9vSIWSUlX9DiKi+QgM40S+8mWwqDXDNoDt8aVOX4Ckhf0iiSjLOXah4SicTNJIrhz6T4fcZWCBld8THqEej27U/nyX/FCLHTRw9/FtwjM8tzelpEGO2MgXn1Pcn+wvktb+axoRR/FuSVNdt3R6x3Lv9oUhFGxv+82SdsWCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784629419; c=relaxed/simple;
	bh=dAg65rfGUktkEyRGS6LHi1HlhBVqv2aq5WVTQI9cBnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R+9ZV3s5r84QLLBPaTrhDQdRJB14YtBYzWUACsexxebVMAi+4d4121mtSR22bzY3YWB28za5O+auE+e7ZX/XTeUaeXRdybo8LwyE4XvgoJYZpQo0HnbbX3dl5NlP9JYuk/mUV3G9ImV5EXEiZh0V3BHJinc2crKjvRs9XgMgtqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YkZU9qx6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=a+9NFGkQ; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YkZU9qx6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="a+9NFGkQ"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66L7vZ47043236
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 10:23:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FNVZLfwCsaGZu+dN7KdgMrqhUKre/8+4rzOhShj+rOc=; b=YkZU9qx6lnMX4N5K
	Do0b62EpRlotw+/e8mEbhWDllZ3QfTEvVcxyBwNAymMa+RQMcZQyFEuQy7fXxd9Z
	rWH4cWFfbPEGE74FlVO+pJA4iZDM+btPk9jltI5eWsv1UAL6mEo05qZHc0IR+y0z
	RJsUEtKoGNdiMaoLigiqBrxnJsAIW/jkcyEcEb2/Ff2hxrfXhIsfC3c5NR0SSa5G
	7y0HXEdC1VzjBR0o4gRORznyxuibrXiiQ2YD0U1oyc1mN4nSgSvfjlan7Iy2q5or
	tQ7kd/Y3Ni1XNudl9Rhgf4CDLVN9VCLP+AO3YviOI66wsozf3nEO/8J4yKJpE4ju
	0TPZmQ==
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com [74.125.224.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj0as22dm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 10:23:37 +0000 (GMT)
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-667c40cd608so3884059d50.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 03:23:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784629416; cv=none;
        d=google.com; s=arc-20260327;
        b=ZSgoPPwIPU8UhGk1Xl3oCxqRZB4De2Dmp2pUFtUcR6cCdrZtmmsi2zPFFND36hZCGs
         B3Y0xFIyy3i1dPm7tKzFcm+Xb1OfcFNkEeWyHPDaeNt++GLH8z0hzjsG+VY2XcJ6ULCL
         k5G55dOwm+zssuiY2aiodwgyLgcSh4sa1/4sBlmOn3cqZD6szOevedP2Oid7B8FmE3J9
         Gc0NOwyXiZrQzvHeDYt5Or5HWY2NoutSFETtfB8//fohqBTogcg1RbZ1ONsvRwpEO/o2
         2lc74gs02d7dS5qcE12avLG2jzhDfFZHZ1iwdyxaSFVaoQ48kjNpX6p9ZBu/DbARJcTo
         B7Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FNVZLfwCsaGZu+dN7KdgMrqhUKre/8+4rzOhShj+rOc=;
        fh=W+/0P+xxUmn0ABDCgH2w85SYxyzQJO75ftqi1GmMadY=;
        b=Mga8QeYfQQsfW+m5NJCA80x1ZFB4v1CEycYHeUSMY+Ba2M9fG9blovLMxh5KpyvR70
         JtZwUfAd8mYnAwlA1qtwj3OxiKG97+17afBGiVc2Dgjt9Aqm7Qu7XiFW2eBXpcayoOLE
         fK/boH8/HCMYUiBh8eAHgZls9PISIgJm2iMTLMtorJN71iB1Bu2fY++xX28EMZiKYUn+
         lOEfHoExDREAcc+lI/3QKxVCGdhmg1OKWbBQHINsfmtRhXCxlUsANNHJokLcsgWTW6Xw
         ADvb2jsi/c1YJSakcALR1ITOHSMUA2XghzVW3nHnDn85Q4BY5qpwkOZVPS/ININJuw5B
         tEng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784629416; x=1785234216; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FNVZLfwCsaGZu+dN7KdgMrqhUKre/8+4rzOhShj+rOc=;
        b=a+9NFGkQzqDbR4UJTTXL2nX41AQ2LKh+fb3qfJ7xzTcCnZBzuEjZKlsriGLROVw9pm
         02K8x1LR1Kg/31neA5TeGFddMhUCGGESNaKaTpwEYcNIZUqb8WV7R768NJmbeatVgpyX
         A36Dv5177kb3gGouuGkOGq9ztgb016vjqB6ihO+sd1TpinEOrexUaBQOBAUJmmfryxgT
         DsA5d9MmKIsZ2TbkM8/rY5Ugmn6dJm7rauTie/S618CWKYy5dZRCVgo8ITUA63G0dnZg
         CA7OnLAzpDL6Q4zGNcEaRacNRhQef73krPY+Djj3ta8RRnfdWv0UCqxMZY2395o2lRjA
         VLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784629416; x=1785234216;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FNVZLfwCsaGZu+dN7KdgMrqhUKre/8+4rzOhShj+rOc=;
        b=eZE/jClbTYEL65yIRmLFRuKDADYP5ahM3oJhU6NDWgbO4mKNRFCyOgdZeappfyqZmn
         fkCK/jM0kvsWXB0jMYkncuhhDrkl0WDLEJ/l4O6NPOhcVjbaDziC0ZcQ0hZekPa0JV36
         v3uovrk7OcgnJ+71bMd/R72bw2z3uEVP5kkXFLqt4BxlLn/AuGIgPsTQDCJJYynsowSp
         7tuLJeViEWZkC9gjsgdz257x5Y9olB6MpCiNWPF2Pe06A8ZP49hw3g/4lFLfSZiVQjGP
         3jy51+ICwn0I3RmYp8zR257Rtcexix/R7rTe76RMYXDaCd5unLLHMI0ktauisiK8GLNJ
         5Ktw==
X-Forwarded-Encrypted: i=1; AHgh+RpowU/4+kDKOJm8qn2WWlgFS6pR0f02eVdn0tggvdf274F7EZfzo33zo3tsEQaK8UM5zxv9Ad8xReM+SH1Ytw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwpvhU59s6t0W86Y1AtzANzhtD3UX7xRTy06bX9IvkEs89lKsr2
	fAaqlVtB3nqSPD16DU6Pc7hdEGa72tjRbSRRoTOPUWsFOy+LTZT65YdDDXiSb4w/Hhlbm5kRHEv
	nsi8HTShhFkOexSqGdI1J321u56SqYtSu0xhU8T4Z6AVcuRauYuHN9Mrs5uC4VU5+Ju7gId1XUu
	hJFgDkbO+bkBZLaFdCIANd9t2lD/3UDg+g8xxaGoOWFalc
X-Gm-Gg: AR+sD113xfZJWaXpN4o1/asKQOJh9NzlYCbtMG7wO+4nmMjOTv3tc/LC7bkJ3QtgTxV
	yf+whN8PFUQiLCnMzSYRl/XbME1vdSD4luMZDt3sH1BmgloA18ABF2JgkQvBLhLLz/jKBeoN3/f
	+lOviAwc/bYjO0xmA0xScJaHvAG+UBs5QwT3knkYfMuT5fPKiWRbLh9BTnKw==
X-Received: by 2002:a05:690e:148e:b0:668:85e8:7cb with SMTP id 956f58d0204a3-66885e80a8fmr310943d50.38.1784629416521;
        Tue, 21 Jul 2026 03:23:36 -0700 (PDT)
X-Received: by 2002:a05:690e:148e:b0:668:85e8:7cb with SMTP id
 956f58d0204a3-66885e80a8fmr310932d50.38.1784629416151; Tue, 21 Jul 2026
 03:23:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702115835.167602-1-sumit.garg@kernel.org>
 <20260702115835.167602-10-sumit.garg@kernel.org> <alJpc3nFX9D7_8i1@baldur>
In-Reply-To: <alJpc3nFX9D7_8i1@baldur>
From: Sumit Garg <sumit.garg@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 15:53:25 +0530
X-Gm-Features: AUfX_my8FmFS_RPsD9P_wAO_xi3w3rSS9J18xqmBVD6VnuXnMyKuUdz39cXSwBQ
Message-ID: <CAGptzHP8EQyvx3tn-ZVWZPN6TwFec-ADvAuxEQhwQBE00Sg=Kw@mail.gmail.com>
Subject: Re: [PATCH v9 09/14] media: qcom: Switch to generic PAS TZ APIs
To: bod@kernel.org, mchehab@kernel.org
Cc: Bjorn Andersson <andersson@kernel.org>, Sumit Garg <sumit.garg@kernel.org>,
        konradybcio@kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-remoteproc@vger.kernel.org,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        robin.clark@oss.qualcomm.com, sean@poorly.run,
        akhilpo@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
        jesszhan0024@gmail.com, marijn.suijten@somainline.org,
        airlied@gmail.com, simona@ffwll.ch, vikash.garodia@oss.qualcomm.com,
        elder@kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jjohnson@kernel.org, mathieu.poirier@linaro.org,
        trilokkumar.soni@oss.qualcomm.com, mukesh.ojha@oss.qualcomm.com,
        pavan.kondeti@oss.qualcomm.com, jorge.ramirez@oss.qualcomm.com,
        tonyh@qti.qualcomm.com, vignesh.viswanathan@oss.qualcomm.com,
        srinivas.kandagatla@oss.qualcomm.com,
        amirreza.zarrabi@oss.qualcomm.com, jenswi@kernel.org,
        op-tee@lists.trustedfirmware.org, apurupa@qti.qualcomm.com,
        skare@qti.qualcomm.com, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDExMCBTYWx0ZWRfXza1VxBYp7GaB
 3grIUaCZ/NkkEEY7w+E9hftY2PDvYdYn3dv+Cezml5gHr3lwf3+kw+upkjYzGA5205GhaNjmcVK
 HchQu51i9MBD/mKujZAkPFy2A+tvTcVVG8e66Ga09B6Jm1/B08ObAm4YP3K8BIJx1S+8ByHQlkg
 VDKxmLgShC7vaewRA3M1EQR3Dthxgg+eccW4s8GfGClyDa0MnhA1wKyKVyqKYgNYgJ5YRVLE7M6
 BQLQcRg4LjJT/PspV18D890TylCdh8UclnGm9ORdpvKhfm+IlHzynFV73MuQG2vj/sS/bDYT8mN
 uenrJ9q2Jfb98XnKG0CeUAKWycnZIeLfzNvmsoBCj49mW/tgabMBuD5SWhlY/iB6tauDxU0pD0P
 IfAfBa9URP6Dfrpeazmt7i5TEfiKze/Nkb3te/4GNFZAMpjlUEpD2MTRTAFBR9XAvhSfWUm9x88
 GzhtiFxRulew3i7wq1g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDExMCBTYWx0ZWRfX0fhHBDJfaDjT
 17NE0sr4eSBCsDahKMye8krBo2lzRohbWm8tDsfB4iaQ5Pot5MsFrRm67iX/tNtUaOMCyLfl6oz
 OkxDVZhr69/V6o/OPqUg6yxTjSwYm+0=
X-Authority-Analysis: v=2.4 cv=DoFmPm/+ c=1 sm=1 tr=0 ts=6a5f48a9 cx=c_pps
 a=J+5FMm3BkXb42VdG8aMU9w==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=lt5aTsHmsBbDyw7JONsA:9 a=QEXdDO2ut3YA:10 a=Epx66wHExT0cjJnnR-oj:22
X-Proofpoint-GUID: VJT50pJfJg7jIU7DZq7vgfn-J0iiLuU2
X-Proofpoint-ORIG-GUID: VJT50pJfJg7jIU7DZq7vgfn-J0iiLuU2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_06,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1011 phishscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210110

Hi Bryan, Mauro,

On Sat, Jul 11, 2026 at 9:36=E2=80=AFPM Bjorn Andersson <andersson@kernel.o=
rg> wrote:
>
> On Thu, Jul 02, 2026 at 05:28:25PM +0530, Sumit Garg wrote:
> > From: Sumit Garg <sumit.garg@oss.qualcomm.com>
> >
> > Switch qcom media client drivers over to generic PAS TZ APIs. Generic P=
AS
> > TZ service allows to support multiple TZ implementation backends like Q=
TEE
> > based SCM PAS service, OP-TEE based PAS service and any further future =
TZ
> > backend service.
> >
>
> Please find an immutable branch with the dependencies for this patch at:
>   https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git 20260702=
115835.167602-2-sumit.garg@kernel.org
>
> Alternatively, if you think there will be no conflicting patches in the
> time leading up to next merge window provide an Ack and I can pick this
> through the qcom tree.

Just a gentle reminder for this patch to be picked up as only the Qcom
media client is left in the next branch for migration to the generic
PAS layer.

If there aren't any conflicts then please allow Bjorn to pick this
patch since the cleanup patch dropping the old SCM APIs is blocked on
this.

-Sumit

>
> Thanks,
> Bjorn
>
> > Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> > Tested-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com> # Lemans
> > Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> > Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> > ---
