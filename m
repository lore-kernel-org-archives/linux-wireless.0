Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090E6519E14
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175835; cv=pass; b=OrknL56E/0of0dGVeMfHLFSQSEPSbF/Dh55gZBO8CvAPtz3I6QMw1/n+PdsUxE9HRaN7hZw8WEfIqr9vK322XnKLoXzutm1hOrelQLFZquhVKvD5hbJXoIXXtyVK3clukr5aC+Afj2As42UYUn4pubnRUNF1B6xiypZHD91A7Ns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175835; c=relaxed/simple;
	bh=QI54wB1ZRIPwwHHM35cUuk4h5p328r5xKjYJPlaPtMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q4WpXZ6+PWtvEN9tHez+TGtQweyGe7IYHY5v3iGbPsQhAOfGY9XB6p/THYUMp634VdIYKRRb55ELlHLZ+0lH8D7kN9KhhbjEWG9dK1Ep/eJXxnjcR4NKjBHDrs5WiUsuc00vpr1/pG3aQOwTQnL7ZeJpPQkr1L0GvP2gh9Zofzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DEl3D4b/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YBF7HmFL; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DEl3D4b/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YBF7HmFL"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68NBbUOo2443305
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:03:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/PeU2gEC3LoYHxgoHpBg+aDS+BEleaPfi9f+JiK36Js=; b=DEl3D4b/MaQwai3J
	Rc+Ru+AqBDlYi16WsBv2QLOrZss1Lb1ZCPQaal+Sle+OwKskQ+snUYVyT+yNJ01A
	F0EN9a3fIwy+dh6RNxn0j0O97M3Ghajsv9xbNbmZIefIpu6tVOh518WaktBrsTao
	6oeuHsh2TUYpTtNu8TvZJ06p0huj0qVwZHVOIFqNXV2mYmroJ2YVyYD+mNDEY2PI
	WEpk+pNxxufNYo7Oc+PmbtPBI5IaQRShwKSfQVexsbeZpIm5nyFeain6juIhH9OA
	hY3neNnzwcAqrav+o2rbpDeQqiwC+IhDhfPEydTnYmOV0kgpTGZ/E/Bxmx4bY0uz
	XWNVLg==
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com [209.85.222.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvbx7hf0a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:03:51 +0000 (GMT)
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-98087b0c5deso801064241.2
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:03:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790175830; cv=none;
        d=google.com; s=arc-20260327;
        b=SizdZS8lOEVRSaNYcb0cQNaUH+Q0bMcAH7kqkxxbcbEJEqYpmd1Q5lkvQ7CB64l71r
         zJIvQm8sGngHweU44VFnBiACrpt246Q23mVokUUpFHexWf5Ei6b1ZqLdKIo0CY21FyDQ
         I5LVA1mpItLbLtm/oNBlNt8Z2EEHIkokx6OrMNKL5tlYMXmsF/mNbV6YpDc8FxynwHD9
         8fKgMYS6AvHuQYVVVG4mGpoHm3vCIkzO5Qf2Gv+NvWMWiK2m6H2HHj+P2o5PxzLihG5F
         gjFeB/pbiL33Gx/wtrml3GUsGH6NFG4M+ljWGZ4YarH9tz8s/4zLj20LzbTfrdWF3oMs
         omyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/PeU2gEC3LoYHxgoHpBg+aDS+BEleaPfi9f+JiK36Js=;
        fh=Q+3mvHLM5daPzobnd7TPhrDmNF+EhyDxLdnRtt3Fgdc=;
        b=pVxG3WCuMyviOlB4P7LDPmOUXxXzAFVnQKtibYNmSxgmCPax1AKnBUqe7hDoefI0P/
         +8jJrFlLtqJEvSPuI1NNsLRZPPsmgMLgoZFRXSkQUpn5kVkTSLZmurp+AyMh5YN0VV/v
         7u0D+gxfEBa6PWyOVE7hILXI/TqkID66RCfcDW0aamL5Nc6u45oqHYNrWRPb5VsnP9Ii
         YyalVx6K9PPwDcowUDYUG9EqSpFCEM2Ev+4obuN1NEDxlbHO+UIDWWoYUfAyVkTdaV+e
         UGt0SbZqNAkMtQJ8QfvLBNz66CzDPCLspFHSVl3dptslTR7BU23Hxo374Xg+lQzAefSw
         4uKQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790175830; x=1790780630; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/PeU2gEC3LoYHxgoHpBg+aDS+BEleaPfi9f+JiK36Js=;
        b=YBF7HmFLoLt9wb9ovBAKGcbCe1sK6Inl2TvkMT4HFvH0FlMwe2g1WS9m1uwoJNUQpb
         BBobsGcKl1RF/WfZ34wdXzeIeE6pRDuzRXDaR2+dlGLbCzRCw2DO3ZycN547W59IrJ9I
         qknpHmnruLWrbs940qIT5sdcwnBywQ03JcoC28s0+j55ExG748/KhMBQ6QwetK6pZK/a
         TAt3JIS2u99z1vhqh9yZrPyFz+j5oHU9qilf5BqI0A+IFbeh0iz8oSjf/SwT/BEBmkJS
         RTHvcu4xLf+B9TSp0/MYSlgnXsI/VtI2ZaLSY9ZRpbR8CnEYuttp9oC1oj/hfCC8q7Kk
         z64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790175830; x=1790780630;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/PeU2gEC3LoYHxgoHpBg+aDS+BEleaPfi9f+JiK36Js=;
        b=eex/SnAKn/2K9I+5j65nKePaeMKi0ZLgcar7yylrhmOH7GTE7i7uylh2hp7Ij2En4D
         x/Bd2NiAhHpBFhBo1xN7kRQcoa+VNeuzL2eRSjvKzc+1vNKIIh9wtVW8X6bSzDTk219f
         433vY11LVNFRO6AY0eN9AKdvxq+ie4++FMNsLjcm0C7DHsuXCmNlnyRR2KJt4BvKm2t9
         8H+VtOIshrIrp9804Jgt9eODph8qrkcYS/u4I8NRMC5evb8NgWPmCbjhGQVxG4kW1yJD
         OGbQZgjMAO8xNm2uwBYTWNtH1SWXkyWE0hjUfkP1lGnfn9tXH/4DkHgm0P0I4NAZQCMF
         XDWA==
X-Forwarded-Encrypted: i=1; AKwUvBw2SWX3fBW4mdanhoLlIrNgNxsY8V7K4dlH2DjfpZcRwgctaDxdOEOEuO3PtERBBkKAfysLFGFZr9JqewL7Mg==@vger.kernel.org
X-Gm-Message-State: AFuF++m855jcRpghji7gDsTjv9gbxn2BzAaS4N6ipAwXaFytGoST0MGv
	nq7kWUxZOwBqPVEUBWm+HtA5vDIwcO2RbxLLmLdA8dWqbYGVC8uu8108GfWxCNeb22vLEU1VUgY
	HwlGGAg12OznhlBoCjcZZ6cr1qpr3Mgw2Flcy7q8mE82/mZAs3Laa9vBO9NUZdPaCreo26NhQug
	Q+nIfnCAoW7d6soaPkphJ2ZNr/pmH1sC2yNQUesWPOSzNq
X-Gm-Gg: AYBFou0vb3vZTkiuaVVuSQHFSRHdpbDccQ7AwFpO+HT7MP6vapD98zdtZdfaZDki7LT
	QSE+pOmz5LC7YoMb9fCuZxgsp3jeCHXubqvEyrfhcTnWzboxt8ZGBrZzIaP8D0HkZW4jMb1HHjr
	4qkuQSWxApGyoEiKKq3FPHWhx4oy9Mn7yrHAXPB5P3f9BpjmCmNZg7FLijcQ==
X-Received: by 2002:a05:6102:5488:b0:7a5:e455:182f with SMTP id ada2fe7eead31-7ac1cfb78f8mr2788538137.26.1790175830197;
        Wed, 23 Sep 2026 08:03:50 -0700 (PDT)
X-Received: by 2002:a05:6102:5488:b0:7a5:e455:182f with SMTP id
 ada2fe7eead31-7ac1cfb78f8mr2788466137.26.1790175829576; Wed, 23 Sep 2026
 08:03:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
 <20260921-qrtr-multi-ep-v2-2-27dd80d841a0@oss.qualcomm.com>
 <a16d507e-17f7-4074-8817-4b8da3a71c3b@oss.qualcomm.com> <8ed398ba-2ebe-488a-a213-8ca7ecbe861d@app.fastmail.com>
In-Reply-To: <8ed398ba-2ebe-488a-a213-8ca7ecbe861d@app.fastmail.com>
From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Date: Wed, 23 Sep 2026 16:03:38 +0100
X-Gm-Features: AcwNN1Ug9EBugFkjb8PX3BJuksaN57IKAVy35yQBrKwT5dMg_Iz0UHaPN9Wobrw
Message-ID: <CANyhwx0hZJC6xXaSC2g4GFgUOp5n_KN4tdXksW+s8Mk_+7xEAA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] net: qrtr: Assign unique node id for MHI endpoints
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, Bjorn Andersson <andersson@kernel.org>,
        Chris Lew <christopher.lew@oss.qualcomm.com>,
        Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
        Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
        Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: pcUwiQF9ykRBnE9yfqmpozU09yHgU8_e
X-Authority-Analysis: v=2.4 cv=J4s/fwnS c=1 sm=1 tr=0 ts=6ab3ea57 cx=c_pps
 a=UbhLPJ621ZpgOD2l3yZY1w==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=astPFzNtX3-rckHXrNEA:9 a=QEXdDO2ut3YA:10
 a=TOPH6uDL9cOC6tEoww4z:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDA1OSBTYWx0ZWRfX67QrcraPd6CC
 ZUCDvVSsLPW89+aVb3HsrdjFN6fLzwjS4x7W2NVpGvVu44y+cFGvwSUT+55KT9qBbALCDRYSYe0
 TjAHdCaBFGYtavjzNzhUp8JYWUOcC0jCrwwFHQxgyVQEYL5m4t4qaPJCQZRsuLnJSZfSHHSltXg
 t/0EGShtQdKAqMLRRXrUm1hFhnHol6laT6AKtJFfHXOC75358/mvGxYhT6Cny1zFmOAJ+8hWdnF
 Y/WfOKS2W9nHnbQ4VrFCzNGBfZOIaKBgE423MCS010cmihmZzRspFkbpf4bPqdpF/ClOi9BqcJa
 g3kjdmGDS5v2laXniANMD4d0TrIAyIRF42b2UNIQFfkS6PProq7YpUcPrpbJalTLsqwvOJqUfIc
 o2VFQJAOo1aG0AlygJ2tPB2ueUzR/61MwU+dStkjI1esd1Zuac0KhlxXUNGuovLsCEbiJfMIY5Y
 k9Xl+kUNm0nRO6WvWeQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDA1OSBTYWx0ZWRfXwCjKlSSEMY9n
 ZGjz6FFXZmCpbNHOpL+KaHJ8c7qIpX8YWokaeIAkGetzxISx9zqRVH/V0qrdx/6LHkVb4MfY0Si
 M3a5Aue3jdMqfgSgu0Il7PdN+6skewE=
X-Proofpoint-GUID: pcUwiQF9ykRBnE9yfqmpozU09yHgU8_e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 spamscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230059

On Tue, Sep 22, 2026 at 6:24=E2=80=AFPM Juha-Matti Tilli
<juha-matti.tilli@iki.fi> wrote:
>
> On Tue, Sep 22, 2026, at 20:14, Youssef Samir wrote:
> > On 9/21/2026 12:23 PM, Manivannan Sadhasivam via B4 Relay wrote:
> > > +
> > > +/* The offset is chosen carefully to not collide with the node ids a=
llocated by
> > > + * the remote nodes. All the remote nodes use node ids in range 0 to=
 0xffff.
> > This assumption does not hold up for QRTR V1 headers where the node ids=
 are 32bit.
> > QAIC devices use BHI_SERIALNUM as the node ID, and it is definitely lar=
ger than
> > 0xFFFF.> + */
>
> Does that mean we have to go back to my endpoint id patchset?  It's an
> option, but a quite complex one.
I'm not sure. Last time I tested the endpoint ID series was its v5 and it w=
as
functionally acceptable, and other than switching to sendmsg(2) instead of
send(2) and sendto(2), it did not require much changing on the user-space
side. But as you mentioned, it was/is complex compared to this one.
>
> However, what is the likelihood that serial number would clash with
> these host node id values? Maybe just adjusting the comment could be
> acceptable.
The chance of collision is slim, but still not impossible.
I think a solution would be to treat qrtr_host_node_id(idx) as the
preferred id, not
the one that will actually be assigned to the node. And before
assigning the nid,
we check it against the radix tree, and if it exists, we try to probe
the next available
id (so an IDA). This will also require exposing the nid to the user in
sysfs (i.e. /sys/bus/mhi/devices/mhix/mhix_IPCR/nid).

Thanks,
Youssef
