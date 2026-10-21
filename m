Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792588806;
	b=lpBdyqgs/p1UV6D3JX5ESedqz54UGcpud6DZ0wjxF4OvNELQ16xT+HGeou/GtSjOX8bV
	 7frzytIqg1Z0cdEgTjOWka6irlU/vIohuUZfG6CwJJekupjo/PgYt6PBilgwaQDGYyL58
	 3EeFyd4j0VM4RuEwrNNYqSMfozjHhxM3pdVeowF0jVn6vmy8F1/zs+SAUTNxHRuvu5R+O
	 tRgWn9scVzO1qFM17z0ulEMM6bwF+/wd2Es6mmh/a+ALJnF411cVq0iMeoxmqIt4h/GCp
	 77CGjBMkapFU9kArwdXqY76Qh+KWtVN+kZdpCurL5JBB6qJjAXeXLro/F5Z+8/jhxlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792588806;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=aSnzuw64QaL2ODuF7dIoTHdiPuBaqdsaTTJECpYAR54=;
	b=BvLVm76mYeMSK7Cft3ttP1e2NUAFh6bcd9TVCCASL3PPfcmCQasrqj+lW5+ImW5Tgrbq
	 cZQJY876Rx2wYopeWdhOZle9mW3X5ZPES1sgThIcgP7/3lcpoSM2FCqV7QUGLKQL723D/
	 BQxkn3LsT6iLjNivxqY1T+0zuYfJWh3WYezKH91PFfN+730EjS9wHh5vpZVv/bMQpTO/P
	 n6/fdZ9jcW1pLuU5Fy4NVaw7l3WeXxocUk6QxsZne3cAiNBabq4zhvZOw4KICXS9UQPUp
	 HIixCTuquXrhzaOwhrip+M4ntaPF0IdGwL/9Zf+vSNN/ISl2TvUpPTgB5tjcn7ixRLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=EIv8tbx6;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=J+DoKJEa;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92AB606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:20:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C92AB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=EIv8tbx6;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=J+DoKJEa
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LBg8WJ3225075
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:20:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=aSnzuw64QaL2ODuF7dIoTHdi
	PuBaqdsaTTJECpYAR54=; b=EIv8tbx6tXPAcGXLwoHMp83UmNhsZWHR/l9I8HDi
	4/NrazfTe4cn1dw9qZPNikqZsw4VVrGPrY4VtSEFy9B6EJYk1yQ+z1v03RCikitv
	K2YIJ0XBiKWbLJwtOzXCYY+SYkCcsRUwgYQ8nuVJdN1UTbWR3t6Lsyk4iRLagU9X
	iwGJ0sXwcyFwUH+4ANIereXBcz7d8bV63FMhwxx9w5IKcrZbrbm0x8MD1BoQOd1M
	Wv/u6WWzBsPnrYV5W0cH9JesZmgnCCTV8T3s+GVT+4io2QwEiMSn4FEkY+DU2lS4
	e2QI7TEEg5n0OPk7FoWS5Dm/se8LLP2qSKvoCQXVATJTVg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hesy796t7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:20:05 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f26dd2165so238201985a.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 06:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792588804; x=1793193604; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aSnzuw64QaL2ODuF7dIoTHdiPuBaqdsaTTJECpYAR54=;
        b=J+DoKJEaJGV1exCt6hQsecBbBX2Iem8uDn4CQKHRRp3gFRfaHXPScwY5CH/t2I9ioU
         hWTU6Xitm4StBQO7km1Yj9QKlv9c+XPYDK1KUBBQU5CtGDuugAdNIogOg4ICYs9nMlF4
         1iL24hvmLL4+bLTrxXrI1dCLmOJxRHDe3GaTemPB9cWLaYzOuhcRyASAgiJwoiozf5fY
         XQdw7Obkmoc4AtWLsygd6WgoTA+QMqofxNkitjxWfYxKHDFvfXBDEOw7ySFsEcjVfcN0
         UFO7VvXPycMrzld6Tq5VKNBA7JL+GyJNDTqvejvitz4ISnQSXposFbgPBzdjokeAhCjd
         X+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792588804; x=1793193604;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aSnzuw64QaL2ODuF7dIoTHdiPuBaqdsaTTJECpYAR54=;
        b=rMRRxiWUpMqgbmfBm7rLv8O+gFv+Tt5PpUoK4Rl2+E0miCRYsoIaGhHWVLXDQGyQld
         B/pVFQStXT21z8Hz4+zgIl0f6fGJgNH7ZlstsUvcXDqOnkrGfM2rpM+s7CahyXJswjXL
         Gl5Mxy8WUIRPFhT+5RpgeV/imJTLk3/6pIUDABtN/RQEn1xqTEjgaloAVPI9b4n0+wei
         uaxoozzvyq/TwMxnQ012xATkbD154qZf8fg3TQULOuOlzPZld1Ajb4dZuMETIu3iCTgG
         lLf2yp3TNC5zkuH3HA/cJLtypqgePd3zTRwzWEFC18Zn0ZY6UXoyRV6uz5esJx33CDH9
         Oyyg==
X-Forwarded-Encrypted: i=1; AKwUvBzHQgti9KkCaGN+MKmppDy6esk1miXXsda7aZihns6DrkNMKnEYmpF4BWyleu7abpZmXXPq9gqSFEQqGCv0Kg==@vger.kernel.org
X-Gm-Message-State: AFq9FYL3jb0svq+vCqeKx24zMKYpI81ZcWhAwPfDAGdimoL0GyscPlq2
	yD5CCrxcWynqxEjNoDnAiEnhDdB7vNzsgUncWzOsh6Lbo158WoIw1RXJjYQ20HsCtzbV4b8dXKz
	uza6V5eH0+gf+PBJG/5RKsGY2dhyKpeWGESRhEgrliEQgjyCWvUvgmN3a8Zo/+iUJkRYI9Q==
X-Gm-Gg: AYBFou2xaweRwzf4PTZBRUg9h1Hpux+u6AH/i+DhUkpPp4vxZTTmv4s5EWZXkqZljwc
	LW9qMned+3BuxBmjkIhG1OvigjcsxiaqZDi5aBmYjL0UL+w6KzsRXpmiu7tZ1q6mDWH3etPmb9R
	sQUYexKBhF59Z+qnsNb9CZXd0qWaLqkW5f4O6tHQF4kgwFrowauPA3HojelNzNPfHRJITOCVVyG
	rJG48LIdsXGtulI4OoEl404MKkAbwnOG7Z9gkqxkvNo7d9pK69JH0wBzjud/5jeukcQSTdE6EoI
	eMh8Ztt/x+ETzwafz+R9852XT5f6FJJiBqM3sxKKZLLFVvzrYoX/tmiQA4CtVWkqAqImor2xNjC
	83uInpi9w41fw4I+gjQr78mLdZNOovm6/hbQW6jAcJ9DRotT50C65ge3e9Ue3svkPJ0dNl4znfB
	PrlIJgA/aNIjyW
X-Received: by 2002:a05:620a:40d2:b0:93f:571b:c72c with SMTP id af79cd13be357-93f57f66116mr409628185a.46.1792588803948;
        Wed, 21 Oct 2026 06:20:03 -0700 (PDT)
X-Received: by 2002:a05:620a:40d2:b0:93f:571b:c72c with SMTP id af79cd13be357-93f57f66116mr409621585a.46.1792588803368;
        Wed, 21 Oct 2026 06:20:03 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfa1224fafsm512832e87.63.2026.10.21.06.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 06:20:01 -0700 (PDT)
Date: Wed, 21 Oct 2026 16:19:59 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Rob Clark <robin.clark@oss.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>, David Airlie <airlied@gmail.com>,
        Simona Vetter <simona@ffwll.ch>,
        Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
        Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
        Bryan O'Donoghue <bod@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alex Elder <elder@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jeff Johnson <jjohnson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Abel Vesa <abelvesa@kernel.org>, Sean Paul <sean@poorly.run>,
        Akhil P Oommen <akhilpo@oss.qualcomm.com>,
        Abhinav Kumar <abhinav.kumar@linux.dev>,
        Jessica Zhang <jesszhan0024@gmail.com>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-remoteproc@vger.kernel.org
Subject: Re: [PATCH 0/8] Migrate PAS clients to qcom_mdt_pas_load() and
 qcom_pas_prepare_and_auth_reset()
Message-ID: <zqu4sweaftstbt26v2u3ajzv7snnqswuyrktm7t7k5gh4zi77e@d6t2fpsinvxc>
References: <20260925155737.4161358-1-mukesh.ojha@oss.qualcomm.com>
 <ce3f58f7-f500-49f8-89cd-611d8e1ac6ac@oss.qualcomm.com>
 <20261021130735.h7t2c7txqdfohrs6@hu-mojha-hyd.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021130735.h7t2c7txqdfohrs6@hu-mojha-hyd.qualcomm.com>
X-Proofpoint-GUID: ZMUZSb2Ronw-ICS3R09FNSV0LdmFoUqB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA1MyBTYWx0ZWRfX3jiVisYJvPGr
 rtRFmSU1N/6T9jW+bOwdE6bucquPwULuhtOYArm+jqPrs+zKQaAnNQi9ICmJAtEJ+XrL2QE9i9t
 x+5b44MPPLC0sankxVxhv+RuiNrbGw+870omA/3zWts5tNt2od0EOpIhcChl75wRyB/5wTvW3uq
 qqAiupEdWva5l3ylgHzTPhThEFvSsTIpMo2F4F5Zt3D/BlG/xbXHcbog2ZeibYygHtV/kmMuiUy
 UOKsBkcvi5gsKKkoE1KTOC+BMVsw0uRbi/e9RvLguopZPTRqHxoOnldtZscJbB94613X/IVFa3V
 4b0gGPZRSO7TFmU+9SLffUAVzZW9ztA7DN+ga9Nr2QTzVuFhNKRjMaDkhLO4eseUkjzwtXARcfA
 f4friTWwpH+wp1MPBiFS3MRxkmpMTFpl1h6+t2yrkULf9roq+9nz4tDPSam79Dd9l00nOk8Cu5g
 eYs7/CWuVYW7nWoQXsw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA1MyBTYWx0ZWRfX5l1AJVo8rtqA
 WDVmSaaB2pM2ECeMlU24KgiJC6VlJlQNWlhxtdaJhZEs+qR6UW3GOeFrqS5xvTeNbe6OokQAhDB
 4CsYiUX1eCRCS72a3geeig99kYewjpA=
X-Proofpoint-ORIG-GUID: ZMUZSb2Ronw-ICS3R09FNSV0LdmFoUqB
X-Authority-Analysis: v=2.4 cv=IPaXmQvG c=1 sm=1 tr=0 ts=6ad8bc05 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=LTSqVt2n0stEVfQD8AYA:9
 a=CjuIK1q_8ugA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210053

On Wed, Oct 21, 2026 at 06:37:35PM +0530, Mukesh Ojha wrote:
> On Wed, Oct 21, 2026 at 01:32:13PM +0200, Konrad Dybcio wrote:
> > On 9/25/26 5:57 PM, Mukesh Ojha wrote:
> > > In preparation to remove qcom_mdt_load() and qcom_pas_auth_and_reset()
> > > public function, migrate every user to the new PAS context-aware API
> > > qcom_mdt_pas_load() and qcom_pas_prepare_and_auth_reset().
> > > 
> > > This series migrates every remaining caller of the deprecated APIs
> > > (qcom_wcnss, adreno zap shader, iris, venus, IPA, ath12k) and then
> > > removes qcom_mdt_load() and qcom_pas_auth_and_reset() entirely.
> > > 
> > > This series is based on top of although no dependency as such.
> > >   firmware: qcom: pas: Make MDT buffer retention explicit
> > 
> > LLM has the following comments:
> > 
> >  1. Metadata buffer (ctx->ptr) is leaked, and overwritten on
> > reload, because qcom_pas_metadata_release() is never called
> > (patches 1-6)
> >  2. devm_qcom_pas_context_alloc() is called from repeatable runtime
> > paths, so contexts accumulate until unbind (patches 2, 3, 4, 6)
> >  3. use_tzmem is never set, so the shmbridge prepare step never
> > runs on SCM and the commit messages are inaccurate; TEE gets
> > a real mem_phys/mem_size change
> >  4. Not bisectable: patch 4 relies on the NULL mem_region
> > handling that only arrives in patch 7
> >  5. Patches 3 and 4 don't apply to this tree; iris
> > iris_detect_firmware() still needs mem_virt after the load;
> > the base of the series is not stated
> >  6. Patch 7: NULL mem_region now means "map internally", which
> > weakens the -EINVAL sanity check
> >  7. Patch 6: redundant second ioremap_wc() on top of ath12k's
> > persistent memremap()
> >  8. Patch 6: ctx is set under one scm_auth_enabled check and
> > used under another, which is fragile
> >  9. Patch 2: the context now carries the full region size instead of
> > the MDT size, which matters if use_tzmem gets enabled
> > 10. Patch 3: stale qcom_mdt_load() comments remain in
> > iris_firmware.c
> > 11. Patch 8: no issues found
> 
> Thanks.  Will address them along with Sasiko's one.

Just to check. Did you verify your commits with the lockdep and atomic
sleep debugging on?

-- 
With best wishes
Dmitry
