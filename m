Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03B349CF25
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790340409; cv=pass; b=MiUjsYVsRmZpzBq8r02FxP32Xf0c7S9x8I/R/wKM8TxmYwDVas+U4Jb2raIqfZ0Xhz+fGokPE71P8SWqgBokAfbCyr1IfbSGBp35G16XcZmPvqa91UDUJ4seVL0xDHIh1VKyGAUtcUxVvEA7TV/QSyvGyAmqSOH/Qd3K7Lo0mpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790340409; c=relaxed/simple;
	bh=MPY/wBT5j35ozhTUGWxFnPpk8kim/mWPV8B3d7VqlCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AMBqbEZZuFJ9PFSPR6ptFCOorklhj63VVMq/I1OfSVxe2KVMaVSf8SFISxvqvMa8E9qa1BlgR717bLOtoDrfU1ENgzbYEcFrSppElmBqdn3w4RVTVXrIBQ5+I2PBrOka3LDznkFebnWlrIafa2aUnkK+XYRssXabTpqsD/h/+e0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AYRND37l; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IdAF6F8F; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AYRND37l";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IdAF6F8F"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PA48QX609035
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:46:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MPY/wBT5j35ozhTUGWxFnPpk8kim/mWPV8B3d7VqlCg=; b=AYRND37lW8jWqGFV
	EMTeyG+FZKnEy5vL3U+fYits/0aiDIdPkPQkN9x0BSY8KieqAxlqH+FKJz/ovMl1
	pi+PW955ABRDkDegByWGk5OQwdAm7J0lyDupnHk8r2q6Q0wEuetM6EPfDud8Vtg+
	lnvBgp+TZAEux1kE5J6RJ4GYEhE1WxoVknRktqa87lERES3NKZD6FEymRfNyrxut
	jiw+M63dUTkdK4yjXpqbpbg4dQUpBIYjYUrKRKHKzh4LnutRe03FEDwTlzS0ndoL
	1oaAr5u1jyp3H20NIW452jfWhlhC6tML+hYaMhSg8EPIGEdrRxJVTetuiJfXsDWt
	JYPOhQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwpvnrf7h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:46:46 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91430af782dso16089136d6.2
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:46:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790340406; cv=none;
        d=google.com; s=arc-20260327;
        b=mNTqIjZHRL15JMWmhulAMhTgw0LyzTSIEtipxyYYWMYNsJ5aeFcb9H3f7edVMBFRvC
         xmvI2aGFHJKWtIb6inz2htR/ZiFgnybgpM22Xp8WKvGth/uBcEngpfLWbC5/PdiPuBYQ
         p6+KZlmeuVMuzpUqHZ7mx6VAG3+gkcAumrdFybF2ycyI7yj8eEpYPP1aFTl2R8x0inhd
         1H37H/Ga5iLUD2uJ/s4xb71aNdHT9GiMOTnFuTe2geTgAzjwPB4B/AqFH+XPfsxjuqKy
         kSbk31n2iIhBE0TQC+zzBSPxDyc7ZrUvqbIuDW5TIqEM82XWqyNMo69JOgPrL7KO6Q3p
         YKeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MPY/wBT5j35ozhTUGWxFnPpk8kim/mWPV8B3d7VqlCg=;
        fh=GX1qDPzpqJ4CB9TSOUoL9X4iKfS8Et8NfaliX/aIKi4=;
        b=nGmm6oKY9jCJNLR7WctST0FBzLcKI/KVXzO2GsHZLpc6kDxqn7fL4LmmJbJ7BP7+cw
         8yS4At9jMjKaFky3z3oBKZ14NazB3/P67Ol/UOv/YbRai5dpgIHzhin1J9xPDOCMaX7Z
         DIAikSQpie3AYJbX3nsHxUB/kqox3MbbrSJyBV+2NFHU72tcK4Ye6JwrJYmkRbKBagKX
         bniK+fZxGQ09AJPpPFE5raFFPqivogIC5Uh6SErbt0J+0tiYaUTEjMd7I1a5Jh5dS03M
         pGyxBiUVK6vFoRIIbb9WuSywkd+U++GooTieEBQCZAEzofKBnYcELrnj31wNlRJ6Y1ym
         cdWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790340406; x=1790945206; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MPY/wBT5j35ozhTUGWxFnPpk8kim/mWPV8B3d7VqlCg=;
        b=IdAF6F8Fs86CVas5ZLLs8fXxrvk9axccj/nvQ2CeCHhgGi0P1PMg+NmFtLKpoayme1
         /8fzYOGqF4m8wVmwaeQegbAW4ffaxADss1/Mv8jbsY8l3Tt+CkxAY+vl/5+DZbOk3K3r
         rZabjgdO+xzQZcswOP4TY1Yr5u0gkwJZ2C11AM/TGXQkHuWmVKTcnFQB2ybR6xIy2uOR
         FdArF51qDV1y5kQGZPtmxmSExHeyLOWr9vuCmQwuI1gjYJdHWk3HKHnBQ0TO6jvffYYo
         3E35uMVRy15lwlyEPT+4zhmlLmF5ybqEbMmQtFQF+GFVGNTCQ/3GkwcEy1l4hiSjMtB+
         Ne2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790340406; x=1790945206;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MPY/wBT5j35ozhTUGWxFnPpk8kim/mWPV8B3d7VqlCg=;
        b=fbdRZpBtdfy61Y9nCMufGZO0xEt87gNdy9lpjnXalhEIDcTJ6ScZCwfPHtI+JJE2F9
         U9Oa5zDTcPKCmIsbc/ptut2WJAKqa8oIJ06bmb/Cg8BG1kbLEps9nuRBWbpefP2A7bbj
         85cBOVTZxA+UEZbfpf/xeD63r2f2FrB/55jcFa9lizSllFFnns5a/l3qv0qtfymyf+ij
         L8Qn+/PKuz6fQApbcFDDt0HOAp1sMITbr4Q+h3eOiIenQMdGVimawmd0wa/EwPCrVogH
         VXdEyaX0sXT+vBqljeCV2Xrvfk4hlRHnUxX9gjxrlje2Pv+STK3UpiWt1C+nMkbgE9xa
         0OCA==
X-Forwarded-Encrypted: i=1; AKwUvBy+jmHO32eGQlRWTfZOl7xfS2dn9CFWF2WY9ORttQldStwCRSTIQyYyCGK8hM/HvDrJE2yMQln7eZM815Bgfw==@vger.kernel.org
X-Gm-Message-State: AFuF++nX15FrpIok03bhlhhkAhkPPjkMFRiM1DgshQlby0e7Gf2XuK1n
	uSgsEas9qF7N+KHT8rmCtI1wG0bfOkhmJbqg5ZXKsGvvdDCcHehgYmtjUYVrzUqUXeLbU0A+HwM
	jUz71hszwjs8Eyjs8rTYkxmWA7vNryPHPkfLAOLS7pc9y1qWPGJbkXWo3Veh1Y4/ZGYSG5uQCFn
	cdvC1vEuLWfNne450b/b92+U/hNxxC4/3vVbjCbs68Opxi
X-Gm-Gg: AYBFou3FxjCgBeA3EGvBZ20uthyZawr1Vmd4DaOYterHMyIWbuPI7cS9M6iaz9XZ2BH
	Gt2QWVKy6tx6Mr4lNls71Jr39bQRypVa6Y8t6TdDrnb8HcSv3EvPRd48kwiKhP+SOvrw6SvyCVG
	pZo04P7wmVF7JnQBvDiBtRFkWzCPujxxBOh6+g7vOfigB2GIRSQyD6GexsRw==
X-Received: by 2002:a05:6214:2462:b0:90e:9408:2fc5 with SMTP id 6a1803df08f44-9142f63ee23mr38807606d6.5.1790340405761;
        Fri, 25 Sep 2026 05:46:45 -0700 (PDT)
X-Received: by 2002:a05:6214:2462:b0:90e:9408:2fc5 with SMTP id
 6a1803df08f44-9142f63ee23mr38807116d6.5.1790340405276; Fri, 25 Sep 2026
 05:46:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
 <20260921-qrtr-multi-ep-v2-2-27dd80d841a0@oss.qualcomm.com>
 <a16d507e-17f7-4074-8817-4b8da3a71c3b@oss.qualcomm.com> <8ed398ba-2ebe-488a-a213-8ca7ecbe861d@app.fastmail.com>
 <CANyhwx0hZJC6xXaSC2g4GFgUOp5n_KN4tdXksW+s8Mk_+7xEAA@mail.gmail.com> <ayyrvpxnxonroz6kafehepplhltnzgopgt6pn5fnpdmft6rbxm@a5sps2dnso47>
In-Reply-To: <ayyrvpxnxonroz6kafehepplhltnzgopgt6pn5fnpdmft6rbxm@a5sps2dnso47>
From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 13:46:34 +0100
X-Gm-Features: AclHuK9M9IbbCEpkXjmHN3eWA-5m3q_sE1ucHvnsGGxug-EHSGOK9v70zRPAC84
Message-ID: <CANyhwx1EG=2FyBm150wrKpj=kQ1066iwZWndx=ZL3BKNoZUhVA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] net: qrtr: Assign unique node id for MHI endpoints
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
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
X-Proofpoint-ORIG-GUID: SLQJahmw9db3AaqCl2bBQQUbmKuSYUpQ
X-Proofpoint-GUID: SLQJahmw9db3AaqCl2bBQQUbmKuSYUpQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA1MCBTYWx0ZWRfX8MgD1V3xfx2l
 vZeYdHawr19OJck0QRdIe8nPGkOogjw6ELntCmxEFA8rLDTIi5Z7XaXwtgwHdehjy366vnuNX4Y
 pYtmZFO6CTPVuOiBwSdotgvsnqEvb1Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA1MCBTYWx0ZWRfXyX67G/uxi2CG
 4qkAOuEPJLr8Wm/yFyJvNegVxjjSJCUwJmVVWfcbAwV0W9sMuJ6S9QHIdvaXnLJ1VXgc56cfGhw
 2g8a6KJysK87CtB+AHse1RKelp75eTJWEI2C2VC69k/PRRxQ+ClpzBeM7sqOona9K8Gd/vzyjGP
 MCCOJhfkAttMym2ejo+tHMByuwbUzJTH010XQfXLpiShMOreipjg2e3QkrPrhhCDqAhy+vU/Wmo
 dYWfJhIYr5b05quAKe7BSGzz81ArVzhMCIsk20HGWA+/8ZEWHATLQgAqqEn285JhHNrt4BpuGbm
 uxFP3NohWQt9Tya5N9+ADIJGXN271I0HpecqdC7mUEdhpb0MLaWrtqWXxKk+nxzaYKjimA/ZwpZ
 v+jGQV+IlUKKySwxdYhHxL8KQELV3QNesmi9JH75xQPIotWSI3PhMZGR7s5v6EdPllXtUItW7qJ
 C7CuvdqVB8DM2rQMJLg==
X-Authority-Analysis: v=2.4 cv=eNmGH3p1 c=1 sm=1 tr=0 ts=6ab66d36 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=ZpdpYltYx_vBUK5n70dp:22 a=VwQbUJbxAAAA:8 a=nOLRoRm-sisVCJmKiMYA:9
 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609250050

On Thu, Sep 24, 2026 at 4:58=E2=80=AFPM Manivannan Sadhasivam <mani@kernel.=
org> wrote:
>
> On Wed, Sep 23, 2026 at 04:03:38PM +0100, Youssef Samir wrote:
> > On Tue, Sep 22, 2026 at 6:24=E2=80=AFPM Juha-Matti Tilli
> > <juha-matti.tilli@iki.fi> wrote:
> > >
> > > On Tue, Sep 22, 2026, at 20:14, Youssef Samir wrote:
> > > > On 9/21/2026 12:23 PM, Manivannan Sadhasivam via B4 Relay wrote:
> > > > > +
> > The chance of collision is slim, but still not impossible.
>
> When you mean collision, do you mean node id collision due to bridged nod=
es?
> Because, even if the directly connected QAIC devices use 32bit node ids, =
the
> collision won't affect the functionality.
As in ep_nid of one device matching the nid of another device. In MHI,
that shouldn't
really matter since this patch moves away from using QRTR_EP_NID_AUTO in no=
de
assignment, but as you mentioned below, it could clash with TUN and SMD EPs=
 that
are already registered with their ep_nid.
>
> Also, there is a collision with SMD and TUN endpoints, but that's out of =
scope
> for this series.
I have not worked on a system that simultaneously uses different types of E=
Ps;
only MHI EPs. But if there is a real case of that, we can move to
global ID assignment
that includes SMD and TUN.

Thanks,
Youssef
