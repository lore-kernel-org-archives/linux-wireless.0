Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=205.220.180.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793713588;
	b=V9WlDiPHb5UQM9egahCj8JmyTMZN1W6W9Tcl/rN49whg/O6wMUazkJfT+uG8CpvuQQgU
	 ZBhYV8dSCsHAzfoszDsRHbulw044XTprFzJU6Zdans5e0b595vS/cZ/jpQ0xJGetu7Kd8
	 sp/OYhVug5DP75XE3oSD4VibX8e9Vz3xhbnGgJWXy4a/fdcRg3cXQ0KL3tJecWaCYj4pj
	 11BT09dLKA7fXFGxioauHLjas3gaTK1aJtdRx1N2WyFpoaW7ww/eDCNw4Yn8rc0lrbDkJ
	 xrENUy2iXIHPOIJE4/0ltYy4yP7Kp3yOX3/JXcdQYUU0D5Iru11QEJZEhaCAynB5gnw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713588;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Ayd/2eGfX8QHFtK5sKYYyWXFC5l+b5DtixNjCpkkylE=;
	b=NH4a5MhsJzePBsjUieoojL6dNobNK89Owl1MG9UmfQDqB8cb0lLXV7ld7EiL+44SbuVM
	 pWq9reS43eDMwkR7TwjoVJ/1sg5LYVkQ1EKl2jpG68iAVbKC28kNGe8iuJKRMWfWTwQy2
	 x73CnLsabkZzQXBxFb4h/me6IEiQIVELJm9AG9KiuJcWAyBAu3oixZTAPHjHLdPJpVNIc
	 /DPoNyZSaYHeUnYHsZ2bU+UonuBojAmpT97vv2ssfsaiDeLhYerfhophq50jrb7GwJ6gf
	 Bq6WJF9MWz2xxF4YMHo6kvENdJvo8YNfO0nnQk8KK/hkydzkG8RW0rn3HpvZ5PrruVA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=h1Jv4ui4;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="K/u/u/9T";
	arc=fail smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F72606A331
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:46:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8F72606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=h1Jv4ui4;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=K/u/u/9T
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A3DZGri3002351
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 13:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ayd/2eGfX8QHFtK5sKYYyWXFC5l+b5DtixNjCpkkylE=; b=h1Jv4ui4Ibpunnlu
	Xa6MRwMo+OyxB0XfHc79Qh0SzewPZqao2xoNac9BAALDZ4ZxhQnUiFj76Y8qQuNd
	BAtwg6nYytGrU+MCWkd36KO9NW0tJ44cLM6HsDn5h596ZYycAPyRx7sE1ryywO4m
	YRLrKirI+MMxky6AQJnR8iwDSG5SZOEIJ9WOUCixuM6O2vWc4Y8y8CdCIT59LZam
	j33VeRFWPYxZnN5OpA74vSxtvEtKDRxkVeV84nK66AJIfoSKC3TmMkRZAJXGljbB
	L8J6HZETo3mMn0a7ZqnlZdCfn/W6WYOGlNNLKom/Yc+YUhOFrIl9fc/3SkbuHBSa
	6QOwow==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq0873ybs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 13:46:26 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93f33438950so800470385a.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:46:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793713586; cv=none;
        d=google.com; s=arc-20260327;
        b=FMzSWOkV1IB4PS5TXiB3tlRfSDOR3vADUO6CTK1P5kfsm/rs/MkK4kPbdceZCUX13A
         L3Ig3KWkvJxj3nDjxXnsLYWVXzuQXQyNOu/mWYMRL91ByKRNoHVi+U/yJOWrKSxdg87L
         kdmYQ6BJD1QrrMDDIbaqMNem79Q8c7o7Fdpg91LtfaRIXzIRGRPnOC8JpGLKsk6SN+Oh
         +X6Tm9CqatgHkjxHzHJJkFP7SD/NdO7Py1CerE412gORyHm+EXgRB+bduxXlApkpVcJx
         tkwEOvbudT5xwUX3jcECNKS9/+GimD29V6bc96vFqUG7S26oioluMgXdHmXQYeeVy1pH
         w1eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ayd/2eGfX8QHFtK5sKYYyWXFC5l+b5DtixNjCpkkylE=;
        fh=SlzrqZy7AqV2XqTPUdnCB2NyI8s5OHLNmmaEwLfLZAQ=;
        b=jS5DU3kptAJ6nGeogxg6tlYTB2YSXyDC93u4R5U4ZU2KBjRm2N3J6Av5A9BH+Edg+I
         2r7XN3EIDs0IoL+eP2TFXN3twFH76rOHFBzZWueBIBPIn1ZFCTxDPQ4Z9l0JFMXc3IJt
         yM6MFNTcHTYYXSHlQPRvrnAuSHbjkvBoVzYQxNCCtEOyMp8ZgL/V/GHD4pzISSDQXnLC
         Cfg5YNGI3cS0n+Pel8uLTov4bXdZzUL8V66YiYaXgZ3MCoh7qbeHedvPf0SRAIFMXBOr
         8o20A5gkN1hTIa0r2bjra3lRnXCLoSSVLKoZeFcOhhYzuSPB3+WSCSiRxkLDz4RUVsOF
         Ho5g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793713586; x=1794318386; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ayd/2eGfX8QHFtK5sKYYyWXFC5l+b5DtixNjCpkkylE=;
        b=K/u/u/9Th9MvkAEp6ZaDrPaJZnINaRpboRBOVFa4IT3Fc7yhEwNx5lSrdKZxM1shAb
         fciy0ho/Tbb7ZudlSueVysGOIx8DunnD8RmwEF9ueKpeCRt/BEJlhLKwtqhnmVNsS7sv
         8QIV5DcgbpF01PObyLpk9yIMvbc1FS1X45ulXo7vQYy3ghEcHuKeNPEyreo05NfdUx9r
         hwj1uo4Qj0Y2IYSAMluciOQKTMOGj5qehYvXm7ARbtPKVLWp6Wn3Tntb1p7zRbib54aK
         51fZUeAw18hnvMU7tmjyVFj0VH6nb7k5DKVFZN/M7cyLZ//taMwHqPV+cN+WLBmBPLC9
         VPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713586; x=1794318386;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ayd/2eGfX8QHFtK5sKYYyWXFC5l+b5DtixNjCpkkylE=;
        b=n6/0qk6QwnoqnjijdwTbStPjGiHw1JyuVVrY5lLXN3tpEaRAhVvg/NT9EqB3p5OYEP
         AbBfdrVFS1hy73ozBwuWlR5Lg+lNWEeZnk8zENBcdWbRO+NGLFNcAJODrtTFIoPaYqFI
         CO1uVhR9RQyhrv1gAR/BWBUyUS863LRrXCa0Z2ShmVgK+9v8167Qgk5eiqG4T9oppgKw
         IosGOC4tKf11jCNrsw2mO2x67veiiOPEhpWKsD95JCacIgAirGNbS5/aaV15dNRuWJHM
         WtSgDIVPcV1qHvebkfzRAReuslxVQFVqWgujimgakQ98zGplh9NM3BCn3qOFjjKUJKAL
         RIvw==
X-Forwarded-Encrypted: i=1; AKwUvBxZwO+o/KlQd1Qy39t9AFsNlzFx6cAZfW/v7jGmQ2N/NFy2RTC7cJNw+DgBz24+g+QFgeQaEbCQ33DuSpVQBg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9mBwa01fUtVHZW3k0KcIdwTChk0JHa4p56hTI/Ld0Nq5N39OKE
	z70FARVB2UBj7iQ3pdUDZtVSlnL7pwWAo5Cs285mp18RKj8XCBa7eYzHH0dBminB3osI4ZwegtP
	SZPEcHdDWD0rHNyWEUPr17Q1rUf6pJl4N7jxJXo8q48VDpjCMm9MO7OdO8iGnY1UzNOrp0P9511
	RWPMM522x8EUcj5cQZ2zpql3E8hX8suSw++JSCQv+9fR9+
X-Gm-Gg: AYBFou1dRKxvHOKq6rzf9brB3Y8LUiV8GjlCOF9kBy23po+S34Id/7kl0UoEj1EZWuC
	0Pnbfx3+hJPzSHmQLAA+nitMCRHqjR6Ka6RTTvBRPRAHmceRcAJAtqifZZMRio/wFtgDZdZ3wOp
	17RhqzyrJZVhT1Si5J+xLpEdLDUtTaeH5stAL3/QHcjH8aIOODf9jn9O2flq+accjidX44z7GGh
	SUHISp67JQP/F0eT1no1PJoxtwVeRGLJjexjgXzGT0dKlr/l3gqWrF5+yDIW+Iw6b/9D4rnGSX5
	wreXveI1LvhDhmDV9jEAE4h4NKNl
X-Received: by 2002:a05:620a:2603:b0:944:941:c060 with SMTP id af79cd13be357-9442171b0c0mr1946384185a.15.1793713585606;
        Tue, 03 Nov 2026 05:46:25 -0800 (PST)
X-Received: by 2002:a05:620a:2603:b0:944:941:c060 with SMTP id
 af79cd13be357-9442171b0c0mr1946378985a.15.1793713585046; Tue, 03 Nov 2026
 05:46:25 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
 <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma>
 <CAFEp6-2xY_gM=FRUp3R30TZ-NgT=-eYnyz_BPE0vxEenv+202w@mail.gmail.com>
 <CACB3TCKq--tdL6j+uGR_dxGdy-gHxQhY8p0h6xxqi_4Fd3VEOQ@mail.gmail.com>
 <c45bdcae-63da-4552-9e35-59ec6a71621a@gmail.com> <CAFEp6-36Fc15uDWSR=v+xCMhERbkhggZOBoEFTF7pAcRLz_vFw@mail.gmail.com>
 <CACB3TC+NVYPbNKeOu9aAnRaCUTTon4PAO+kp_QbLqL6qd37aeA@mail.gmail.com>
In-Reply-To: <CACB3TC+NVYPbNKeOu9aAnRaCUTTon4PAO+kp_QbLqL6qd37aeA@mail.gmail.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Tue, 3 Nov 2026 14:46:12 +0100
X-Gm-Features: AclHuK_Qok4zfLvdDBhNRvQdZHg66IXQjOtvRHYqHIttkcHvB_4seu749GvrFIY
Message-ID: <CAFEp6-0AJ3uGn0pR7y7+PLhjf6AMYb2aBvPpq9J3QFRk9XJv1Q@mail.gmail.com>
Subject: Re: [PATCH ath-next 1/3] wifi: ath10k: set the PMF peer flag on WCN3990
To: "Nagashima, Shunsuke" <shunsuke@nagashi.ma>
Cc: "Conn O'Griofa" <connogriofa@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Heidelberg <david@ixit.cz>,
        Fabricio Akio <fabricioakio@gmail.com>,
        Aleksei Kharlamov <aleksei.kharlamov@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDA1NCBTYWx0ZWRfXw7PFpbWFUuHt
 3Gd0pH/qCK3UMMDMjhV6KU4oWGxbGaNpN0xThnH731CRC2sWdGM1Adj9zdlBJ1b3k8VAmmqBkX+
 m9qc+vEue9F79leB/kWIylMQb7bTMn0=
X-Authority-Analysis: v=2.4 cv=K9m3jCWI c=1 sm=1 tr=0 ts=6ae9e5b2 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=VwQbUJbxAAAA:8 a=ogAJat6By1jEvbFUSnIA:9
 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDA1NCBTYWx0ZWRfXy0IYS+5kAdJ2
 /ekd3SHDseyBB3ENHFVn7ObQyM2pMTJz+785SCzsDrVxdH46IopmCBfAPXWsPR/yu7h6Me54SFK
 4Sz45/veMWx5sJDrCAEFlgNnSU3y+WxrUBKNvde22ir9SH6Uv86O1JApnBFU27MroI+KfRpkJ9K
 sTkUGHk9Dj74HPjR5azT2yRx34trX7ad4+lLmpfdnQaVMDtk9Z7KxumyAQKrOR2T4Pa5Lal98mk
 pJkmeYt0Iayk3g9kXBxXr5z9m02bKX4kSrU0XMwJ18zyfC8Y+pA7cSo+qYAW37VkdNoER4mXpa3
 8a2O+58fLvi39DQnnoK2jIalPIKwYy3sOfkWX8RkhRl/0Oqq/LoShKAHTAbR5+/T/DkTQQEJK0T
 Paq3IkTkHk6FLd6aOGfVODy+XMYQmBJk53elKkYqolNi/4+0riW1sHxJkcP0d5bzMrs0E0qXXnB
 0rvW5dhRZgPp3YVdEVw==
X-Proofpoint-ORIG-GUID: V0EVpTiBC5up1QQVwaSwSpGWOWwswaC0
X-Proofpoint-GUID: V0EVpTiBC5up1QQVwaSwSpGWOWwswaC0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_02,2026-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611030054

Hi Shunsuke,

On Tue, Nov 3, 2026 at 12:08=E2=80=AFPM Nagashima, Shunsuke <shunsuke@nagas=
hi.ma> wrote:
>
> Hi Loic,
>
> On Tue, Nov 3, 2026 at 10:20 AM Loic Poulain wrote:
> > For change request I think the best for this is probably to follow
> > board like change:
> > https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath10k/boar=
dfiles.html
> >
> > Please, keep me in CC.
>
> Thanks. I'll send it to the ath10k list in that format, with you in CC.
>
> One question first, about which file to change. In linux-firmware, the
> shared WCN3990/hw1.0/firmware-5.bin goes with wlanmdsp.mbn
> WLAN.HL.2.0-01387 (sdm845 boards such as db845c and SHIFT axolotl).
> qcm2290 and shikra have their own firmware-5.bin, picked through the
> firmware-name DT property.
>
> My comma four runs WLAN.HL.2.0.c10-00459, which comma ships itself. It
> is not in linux-firmware, and the comma four device tree is not
> upstream, so a per-board file would not help anyone else. But I have
> only tested the bit with c10-00459, not with 01387, and I don't have a
> db845c.
>
> Is that enough to change the shared file, or should someone test 01387
> first?

If Linux-firmware ships 01387, someone will need to confirm that the
MFP capability addition works with that specific firmware version. For
QCM2290, I can probably test it myself and provide a Tested-by tag if
you can describe the expected testing procedure.

> Also, the page says Kalle adds the files. Should I address the mail to
> Jeff now?

Yes, to Jeff.
