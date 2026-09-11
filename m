Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8AB43F4DD
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 19:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789154116; cv=none; b=eSMCmPH5EuQ+U4oefwE0OtpGDVR5XiC+C3F/qXJ9EQSV7DiNtq6shIwZ1q/c8x4kKXrarnfQlHMxDQ7B8PFzhOpBU/OHKUJaWkIPs1v5OkSr0DHHAIMei9mOxNWe7/mml1KX1/0iG3P/0eRW4GuzjFVQBvI88AjW9NJoWN6WbWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789154116; c=relaxed/simple;
	bh=suCLjVjlPtCVTRxt/yyl4+CfCD3zfr9c7UniXKBFnzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kdYITOrsfBpF6UC2SVt9nHVdgHVPcc26rv1/ETy5XsTl5dgz+A0bOxBXlLWnBCzGsdO3RAHB8LRdEqyquVebg260NPcLLIwNc8piFcNke6aLuO4Jz5FZrFsIqLzx9E+QNdEPHURPB8pKyvU929CPcKsWTDlNn9NvJkfAJYSL23E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Mq2Eaaca; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=g2GBpCWe; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Mq2Eaaca";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="g2GBpCWe"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BHWp3X589800
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 19:15:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XA4Kl0KLnzcJOt9vayKyZzMGbRlqf8uEKgvEQ7zEOY4=; b=Mq2EaacaVAgjVX0e
	3N8B2iHucKabcLOOEc02aUGBnNV1A7FsZjlojV+zwiV62S0nJB50RHkgs4H7Mouf
	jxR1Kdr0rE8AaO3AmU0CgCnGFzgNpJkUL/ugujL2vccMZ00PuHYh3c7IqldvdpAP
	ynDMWe3JmtbC/oxvCR+MN2m7uHqKznVzdB/RsXqbBo6CJKmBPUd1noI5I51K3TmK
	ShkkAr06YPlO0GE3JaY4A58G2ThIv6fSyyQDv7e5v2d5Uip9sUFZdM1JoOWPo146
	UPVT5a6IA2VpVthw8tSq+HpaT0FP6OLuvdgRBUXbxIoBEAdSEq5sOxVqMNr9JvgX
	P+IDRQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmbdrba6q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 19:15:06 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so1211028a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 12:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789154105; x=1789758905; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XA4Kl0KLnzcJOt9vayKyZzMGbRlqf8uEKgvEQ7zEOY4=;
        b=g2GBpCWeXdmZUUIXR1Xihyq//HSB7A70Fub/P898+M1nG67CKaa/mA06sYfOt3fH+N
         7uhR0QlK0pfQkRZvf4rGRBCfudnRcaF0hB/JFuEU59VR3RWTu3hXqBf1TCGlUkAPGZbM
         /uZSaZyPAzHyaQ7Ec7oKht6FuHMqdisr80SH4zuJQ0Anlhjs98RyD2sI54gXy7dAImNv
         dnHqDHxn0ALO0HO0BZ8ag+4ryv4ysekd2o7f3H63w0pntRONtdA91Ywa6Y4zmT4BuYFf
         JeTPZxmb9BkRsuB56if4TPk9HsG1EWnuHD8vDpSSzjUB6ukIRrGth/iVaFKsVPuHjeoB
         10Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789154105; x=1789758905;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XA4Kl0KLnzcJOt9vayKyZzMGbRlqf8uEKgvEQ7zEOY4=;
        b=KfrdjRa7gnYPWBruEW/PpDHqUiV4gEmy56ksXEbEGvg0VaIymvunFhcHLePikp5fsk
         zgcSehRXve9SGtStj4D3L96qvc+4kSn2haczg3uhGs5/iedI8ZRGT9PovztxxbBzsuHb
         9ssCH3Qlu2+lRvE/7fWEYuvnU/7ZGiHbDUWl0zw6IKLF6G7afY+zBKyA9AzrjsEiUPh/
         +EaIeVFOYwKuQqgjI4Fw3lppesZm/eA6UDOwADIqRZys8t71mQBjd0yliF25RJDRwXhI
         0V5ttY2zidRG/dyB6gCTEEYErXAcR4w/A3YRgWN8izbzkACp0qB+jAO6kL5H7HlRta2J
         p57A==
X-Forwarded-Encrypted: i=1; AKwUvBw6JLjtQ0tCo3Q3RSvRP3oe0DOMS3b0AQuaXicOvcrDdhwsysC4vgJyWG0dCRAL/H5IGAHrBWSaIap3DYgG7g==@vger.kernel.org
X-Gm-Message-State: AFuF++kZSdvEEhJOCyllTNlnPdaS3RE6nNiODsm2njSdUWCIr1fSsAwL
	fxH+xHXHgx26qToci3RKv3pPLcIu+pKtr16pyxY+JnbX2tzKA4OEbkWnJjA6VqXUEy+XMN/nBbS
	E8t/llLqOVebbVkai7feXiO1VFdPbUD2WItFyC03K8JljTjo5dj0P8b7S3/dFDJ0kmCYG9Q==
X-Gm-Gg: AYBFou2bUuJZ5VPEfEHhwetaO9T/VNQK0mcorFO0jxHQBkWXxRmRvb3JMjN+K6EeHOi
	zRYRWVzL8xZt++4+INDXLue+ZKosJsa4It/GCm/BJlAFVfDuOhx//cMY4WrZeI/vKFfHCAwxj8M
	8XlbLE9i+gSRvY+lrRug0bx3B924fJUjtbI+mdc8IdVOu9PvFU2RxTVKJ6YSqZi/vgmr5Jo8tdZ
	Z+0Agi0DPwS+S7w+wbnpwKoaSNhUjVPCap+cU0WRUbqY28+cPSVSJNPecG3w6qzezfcc3hBLOrr
	fJb9MS4rm6P7RSNpjrhiNHanZRo5LlFBoBYTY4fMJDT/dDN/8DQEGct4flG2/9cUUTJ7rm+vxXP
	qmupX180cw82mFTJAGtA8BUQfu1fFwdPOBuymjchp9nbEBAgi8WwT1esX29Gq
X-Received: by 2002:a05:6a21:6b10:b0:3d3:ad3c:49a8 with SMTP id adf61e73a8af0-3daed3b9745mr10795676637.22.1789154105065;
        Fri, 11 Sep 2026 12:15:05 -0700 (PDT)
X-Received: by 2002:a05:6a21:6b10:b0:3d3:ad3c:49a8 with SMTP id adf61e73a8af0-3daed3b9745mr10795608637.22.1789154104461;
        Fri, 11 Sep 2026 12:15:04 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143659a9a06sm8271959c88.0.2026.09.11.12.15.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 12:15:03 -0700 (PDT)
Message-ID: <d91ce2be-6489-4399-b035-23f6aec0371f@oss.qualcomm.com>
Date: Fri, 11 Sep 2026 12:15:00 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/12] ath1{1,2}k: support multiple PCI devices in one
 system
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, Kalle Valo <kvalo@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Mihai Moldovan <ionic@ionic.de>, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260908093145.2492666-1-juha-matti.tilli@iki.fi>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260908093145.2492666-1-juha-matti.tilli@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: RBgtPeV3HitnpxIbWo59Aq7PiVf2hK_e
X-Authority-Analysis: v=2.4 cv=PLmaavqC c=1 sm=1 tr=0 ts=6aa4533a cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=bC-a23v3AAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=COk6AnOGAAAA:8 a=nuVjNcMAjKUeO9L8OkEA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22 a=FO4_E8m0qiDe52t0p3_H:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: RBgtPeV3HitnpxIbWo59Aq7PiVf2hK_e
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDI3MCBTYWx0ZWRfX30WBw9gfvLcZ
 RBASM6VO/EZylEzea7uT8cmE/TMm4sJd0hZezZ8qa3gv48mI0xDIxZjR65HGfXDRH34V3yeAn+7
 IOocsgnCmmfpt/X0cXZ4oHD8V5MtVUQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDI3MCBTYWx0ZWRfX84i/o40Se/00
 h/UK2x+/tHGe86Zs615+8OorXrjuXYkYOypUOxNkxYhKRPO9SSLpM8BOXdWK4WS76NsG5biadre
 hHh/pYEkvFnxaRVlH0DWKD1qoWLYbboEa6aJBv5cKVOUsOri+Ii+jSB2YpCxGnq0vtDy78SW7xz
 hc/q2jNPCS1WDqmzB/ndnIrjEzFry/A4ob+I5rWeZfu6paL9V2tJP5teCV1uyae6p+G4qybKVu3
 2U/MbJoc0ScbNaUlxyXVJIoNwl7Ed6b2xsJ71bAsOicRpxp/2DikCpM4+e1vEzles1jNUszTLGO
 ZIRnl0DLd/ZtiWBHQaT4ay1rjh/3ptbLU0PmCyiX9HqWZBNTjhAhyxZegTe+lIYAo/JF9Lkq2gY
 1BsBkiwNGdKTVZL48wm+XZ8DLCbQksBJvLVHybiuNPSKm2HEgs7xZQbTXUgWYGZVdNLnkFpiETi
 KxOzXh7RLxWX2TOpsqA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_06,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 spamscore=0 phishscore=0 adultscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609110270

On 9/8/2026 2:31 AM, Juha-Matti Tilli wrote:
> Hello,
> 
> As you may well know, multiple identical ath11k and ath12k devices are
> not supported in a single Linux host because they use conflicting QRTR
> node IDs. Fortunately, Denis Kenzior created a patchset to support
> multiple QRTR endpoints with identical node IDs, and Mihai Moldovan
> refined it, after which I took over the patchset and refined it more.
> 
> Mihai Moldovan also created a patchset for actually adding the support
> for this QRTR multi-endpoint feature to ath11k and ath12k drivers.
> Unfortunately, the code of Mihai was not merge-quality, since it leaked
> memory if you ran rmmod and modprobe inside a loop. Mihai mentioned this
> drawback, without providing an API for deleting endpoints or usage of
> such API in code that's responsible for freeing resources. Also Mihai's
> patchset had a race condition.
> 
> Since Mihai has been busy recently and the previous iteration of this
> patchset is nearly 2 years old, I decided to "steal" the patchset from
> him since he said he doesn't care who eventually implements this, as
> long as it "just works". I am willing to give the responsibility of this
> patchset back to Mihai if he so wants.
> 
> I reverted back to the approach where MHI knows the QRTR endpoint id.
> This is somewhat ugly, but really the only way resources can be freed
> (unless you resort to some kind of reference counting which would be
> doable in kernel, or garbage-collection which wouldn't be doable). It
> does create some extra memory usage in the mhi_controller data
> structure, but a large fraction of the time, the data there is useful,
> since a large fraction of MHI devices actually use QRTR. So this is not
> as bad as making every PCI device know its QRTR endpoint ID (which a
> vast majority don't have), even though MHI can be compiled in without
> QRTR so we have to do the freeing via a function pointer.
> 
> I think the code is mostly merge-quality now. It does require the QRTR
> multi-endpoint support, such as this v6 (I'm soon going to post v7 --
> note that in v6 one intermediate commit doesn't compile on 32-bit
> although the tip of the branch does compile):
> 
> https://msgid.link/all/20260901131934.225991-1-juha-matti.tilli@iki.fi
> 
> I tested it on dual ath11k setup, but more testers would be good. If you
> only have a single ath11k card, your testing is useful too ("given
> enough races, all race conditions are shallow").
> 
> Link to Github if you don't want to apply patches manually from mails:
> 
> https://github.com/jmtilli/linux/tree/athnext_multi_qrtr_v7_multi_ath11k_ath12k_v3
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218480
> 
> Mihai mentioned in Bugzilla in comment 21 that there was a hardware
> crash he couldn't reproduce and he believed it's a race condition. I
> could reproduce it in older Mihai's patchset version by treating -EEXIST
> as an error, which indeed points to it being a race condition. I believe
> the source was qrtr_endpoint_id_get_or_assign that tried to get an ID
> and then assign an ID if it couldn't get one, while not holding a
> spinlock. In my newest patchset, my belief is this race condition is
> gone (the entire offending function is gone), but any kind of review
> about thread-safety of my code would be good input.
> 
> Original description:
> 
> ath11k and ath12k suffer from a long-standing issue that is partly
> caused by the QRTR implementation, which only supports one device per
> node/port combination and partly caused by the fact that the
> QMI instance ID of the devices are statically set to 1.
> 
> P Praneesh <quic_ppranees at quicinc.com> submitted a patch[0] that fixes
> this issue generating a unique QMI instance ID based on the PCI bus data
> for the device and passing that information to the QMI subsystem and the
> device's firmware via a special PCI register.
> 
> However, it quickly turned out that this approach works for the hardware
> he tested, but fails for other ath11k-based devices, including the
> popular QCA6930, since its firmware just ignores the special register
> being used.
> 
> Since we need QMI (and, for matter, QRTR) to work for the initial
> firmware upload, this approach will not work generically.
> 
> Fortunately, Denis Kenzior <denkenz at gmail.com> cooked up a patch set for
> QRTR[1] that introduces the concept of endpoint IDs, which are
> dynamically allocated and can be used to distinguish different devices
> even though they use the same node/port combination. Using this patch
> set, endpoint IDs can be reported as part of auxiliary data in the QRTR
> socket and bound to for client sockets, which will automatically filter
> messages from other endpoints and also make sure that client messages
> are routed to the correct endpoint.
> 
> This looked promising, and with that functionality, the only challenge
> is to find out the correct endpoint IDs and bind to them in drivers to
> finally support multiple devices in a generic way.
> 
> This patch set implements exactly that, and it WORKSFORME, but
> unfortunately it turns out that "the only challenge" is very difficult
> to overcome due to the socket-based architecture.
> 
> ath1{1,2}k and QRTR are at opposite sides of the socket, with QRTR
> assigning endpoint IDs and ath1{1,2}k needing a way to fetch and operate
> on them.
> 
> The endpoint reporting feature in QRTR is not helpful in this case,
> because drivers do not generally know which endpoint belongs to the
> device they currently handle (i.e., there is no central registry) and
> even if we were to snoop on the socket and take the first endpoint ID we
> are unaware of, this might not be the correct one, because it might be
> in use by a different driver for instance, or correspond to a different
> device.
> 
> The first iteration of this patch set[2] extended struct mhi_device with
> a qrtr_endpoint_id field that was initialized to zero and populated by
> the QRTR MHI driver as soon as it was loaded. Drivers could then query
> this field through an mhi_device->mhi_cntrl->mhi_device chain (if they
> also use the MHI bus, of course). This, however, was an incredibly ugly
> hack because QRTR data should not be part of MHI device structures in
> the first place, timing is critical (drivers querying the endpoint ID
> must do so after the QRTR MHI module initialized, which is typically
> only the case after QRTR socket was created) and it was not possible to
> query or pre-assign an endpoint ID before creating a socket and directly
> bind to it (which might lead to races such as seeing messages over the
> socket that are not meant for the endpoint ID drivers are actually
> interested in).
> 
> Since that was not elegant at all, and due to the other mentioned
> issues, this iteration uses a different approach: endpoint IDs can now
> be associated with (private) backend endpoint-specific data, which
> allows us to identify which endpoint ID is being used with what backend,
> and additionally new API is introduced so that other parts in the kernel
> can either get an endpoint ID for given endpoint-specific data or even
> attach endpoint-specific data to a new endpoint ID generated by the QRTR
> driver. The QRTR system will try to use endpoint-specific data if
> possible, but falls back to generating endpoint IDs without
> endpoint-specific data (as in, NULL pointer) if that did not work.
> 
> Crucially, the endpoint-specific data pointer is used as an opaque void
> pointer and at most compared with data stored in the endpoints XArray.
> 
> In the QRTR MHI backend, we use the MHI controller's structure pointer
> as endpoint-specific data, and since the MHI controller is also the bus
> master and responsible for the physical link, clients (drivers) can
> pre-register an endpoint ID for their MHI controllers and directly tell
> QMI to bind to the endpoint ID at socket creation time.
> 
> The QRTR SMD backend uses its rpmsg_device pointer and the TUN backend
> uses the inode pointer as their respective endpoint-specific data
> pointers.
> 
> This approach is cleaner and works better, because it is not prone to
> races (although it requires coordination between QRTR backends and
> clients/drivers because both must use the same endpoint-specific data
> for the scheme to work).
> 
> There are, however, also issues with this approach:
>   - Any kernel part can generate an unlimited number of endpoint IDs
>     with arbitrary pointers. The amount of endpoint IDs that can be
>     tracked is limited, though, so there is potential for exhaustion of ID
>     space.
>   - Since previously endpoint IDs were only generated by the QRTR
>     subsystem, there was no need to use any kind of life cycle management
>     for the endpoint IDs: they were created at node creation time and
>     also deleted at node deletion time. Since other subsystems can now
>     create endpoint IDs, it would probably be good to have a way to
>     reclaim created but unused endpoint IDs. No such implementation is
>     provided here.
>   - Multiple PCI/MHI devices will work, but no AHB + PCI/MHI interaction
>     has been tested. Since PCI/MHI devices bind to their endpoint ID,
>     these will likely work, but the AHB devices might still see messages
>     for all endpoints and fail to work correctly. AHB devices seem to be
>     using QMI and thus also QRTR, but without a specific QRTR backend
>     driver (going through REMOTEPROC instead?), so this approach might
>     not be viable for AHB devices.
> 
> I am much more comfortable with this patch set, even if it has some
> rough edges and might not fix the situation for AHB devices.
> 
> [0] https://patch.msgid.link/20230111170033.32454-1-kvalo@kernel.org
> [1] https://patch.msgid.link/20241018181842.1368394-1-denkenz@gmail.com
> [2] https://msgid.link/cover.1730790058.git.ionic@ionic.de
> 
> v3:
>   - rebase against current ath-next
>   - solved a major memory leak
>   - replaced O(N) algorithm by O(1) where N is the leaked memory
>   - solved all known race condition issues
>   - Link to v2: https://msgid.link/cover.1732506261.git.ionic@ionic.de
> 
> v2: code and metadata cleanup (checkpatch.pl), no functional changes
> 
> BR, Juha-Matti
> 
> Juha-Matti Tilli (5):
>   net: qrtr: support getting new endpoint ids externally
>   bus: mhi: allow mhi to know about its qrtr endpoint id and free it
>   net: qrtr: mhi: register new qrtr endpoint id for mhi
>   wifi: ath11k: implement QRTR endpoint ID fetching for PCI
>   wifi: ath12k: implement QRTR endpoint ID fetching for PCI
> 
> Mihai Moldovan (7):
>   soc: qcom: qmi_helpers: add QRTR endpoint ID to qmi_handle
>   soc: qcom: qmi_helpers: optionally bind to QRTR endpoint ID in
>     qmi_sock_create
>   wifi: ath11k: add QRTR endpoint ID hif feature
>   wifi: ath11k: stub QRTR endpoint ID fetching
>   wifi: ath11k: bind to QRTR endpoint ID in ath11k_qmi_init_service
>   wifi: ath12k: add QRTR endpoint ID hif feature
>   wifi: ath12k: bind to QRTR endpoint ID in ath12k_qmi_init_service
> 
>  MAINTAINERS                           |  1 +
>  drivers/bus/mhi/host/init.c           |  8 +++++
>  drivers/net/wireless/ath/ath11k/ahb.c |  7 ++++
>  drivers/net/wireless/ath/ath11k/hif.h |  9 ++++++
>  drivers/net/wireless/ath/ath11k/mhi.c | 46 +++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath11k/mhi.h |  1 +
>  drivers/net/wireless/ath/ath11k/pci.c |  1 +
>  drivers/net/wireless/ath/ath11k/qmi.c |  8 +++++
>  drivers/net/wireless/ath/ath12k/hif.h | 10 ++++++
>  drivers/net/wireless/ath/ath12k/mhi.c | 46 +++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath12k/mhi.h |  3 ++
>  drivers/net/wireless/ath/ath12k/pci.c |  1 +
>  drivers/net/wireless/ath/ath12k/qmi.c |  9 ++++++
>  drivers/soc/qcom/qmi_interface.c      | 28 ++++++++++++++++
>  include/linux/mhi.h                   |  5 +++
>  include/linux/soc/qcom/qmi.h          |  3 ++
>  include/net/qrtr.h                    | 10 ++++++
>  net/qrtr/af_qrtr.c                    | 42 ++++++++++++++++++++----
>  net/qrtr/mhi.c                        | 31 ++++++++++++++++++
>  net/qrtr/qrtr.h                       |  5 +++
>  20 files changed, 268 insertions(+), 6 deletions(-)
>  create mode 100644 include/net/qrtr.h
> 

How are you populating the list of recipients for your e-mail?

You are including folks no longer involved in kernel development, but more
importantly, you are using an obsolete e-mail address for the MHI maintainer
(Mani). I've replaced his address in my reply.

Please make sure to use scripts/get_maintainer.pl to get an accurate list of
recipients.


