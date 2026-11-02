Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793586793;
	b=1lA4QRI4WxcpEemGCRywXfQ3VMbPqXipdQ4tg2QlBnGQLLQw6zN7f6e5uJWvRTmfn50t
	 zOdY6+x8GonCyLKFsxJ65ZuiMwJEL77KRLsIVDsjhbzfNAaQEmQ/H6FFTTSPaW507IMgR
	 8/1lpguGrQtMm5kBs0T5mfPwlwJV9CgWSVWsOtiizPcac05weoZ4MKJ7BPVsQweJAshcl
	 ziIsLcEeLCnl/f2YodrUclnNrTjJBOwN+MWRTFbPsT5COAo+4u00UmEtyP/AhMWNjt8pQ
	 pL1igON+li3ibrMZudc7RJMqYZurVa2vo7zg/CMd++xLYMaj6mtS31Y/R++dsv3uMyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793586793;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=JQEhiDYXnyaZkyzZRllNcP35+mDZBgBqWQiuBIFIubY=;
	b=bpsXrs60TsISd9Yw2qVVevYtcCzXfOcsHNQLAXSw0I4+xwJVmtFCl255/tMFNtyKSskT
	 mIh6GwL1MOioB//ceu+MQ6ny8m/y/Nx5AFtUc7l/YDS8UolwSuVQHiQ4W2p1604NYheCB
	 Bn55O6hTDQ/wMJctdOXQxHtcx7Ex0u1CuYtTLIvg/YJXsjIQ3umps0J8Ig8Od6deAhViN
	 tNvdlV9iOwTSpClQ+erS1GrnML6t1xU0QonJYJl7T84nhriYT4RFFKBmwAvjHgOwtWb9t
	 YOx1xLk9V7Gm7bXQ8kMqoMO3aki5/mHjqhe6cILhG8Ct+LfJNceDJun5gVs89fqL8tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=eWjScNLx;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Mngszxvc;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB8D606A326
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 02:33:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5BB8D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=eWjScNLx;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Mngszxvc
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A20Kj3b1322650
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 02:33:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	JQEhiDYXnyaZkyzZRllNcP35+mDZBgBqWQiuBIFIubY=; b=eWjScNLxRzgwCn93
	rnkfCnr0a7Mftp1PZXQjKRDCJX58jShvA9jjV6HoQAc4k96oo+fHcdtx99CxxkEz
	1SWQtzVYNthWe66ydwUjXwZ//N+zaG8iOk6LQEOZsnpu0IF39oFmWUntRAK/EvIH
	hrY+I9MsowI4uFJhUttyP7e30Lz4UIc8VRQ7DdP2+MQX/QTgQu7BCYkHt76DGQdw
	mUhQ8cio8k6XdYu12Cexh9sIkj+okoVjb5L2KKzP5Jqj93vjiN1Aq05ztfTprPWV
	mzCBNVd5zgfP5pSdkF1ywdyFeVIbg0vEjqZpmGW7SR79DV5m1cp7KJGxE7Hd/I1/
	qZ2Cog==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn9m9cmsr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 02:33:12 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1af203073e0so2085648c88.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 18:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793586792; x=1794191592; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JQEhiDYXnyaZkyzZRllNcP35+mDZBgBqWQiuBIFIubY=;
        b=Mngszxvc9syu2xosbTypz1hOv3chPqAFeVHJUXdFYVRZENxQi52+/8vMDkHKrCUCnq
         ZDzgTAYz/UNCXjjhhkTu6znGoaFXUtFLfVA5ny4fd/4ilq4NmJx84HXQSR9FicQ/uc3Z
         VpGWeaQf+g7wrUxKFTTa76eHBFP3/r15f9vmRE/cpE3LSay4+2NpyMRZa6dPAUhYPUVn
         9coQVQ7jHNnCmUC85ozV/odQA4Kfdr0rVsifRYzPys6vy0S6jvYc5Fyrf4VP6Tw4PoQp
         aTBEP07y1gGLdhbyfnZsBqZTn5g+kUqX1ywOrHcKMhi0+FTJ39FiV6w2mtmJu2PkodnM
         ENGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793586792; x=1794191592;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JQEhiDYXnyaZkyzZRllNcP35+mDZBgBqWQiuBIFIubY=;
        b=0GV07rRb7UwOK5DF6uLwwR0OKALqyAANBiSZ+BWdv3UdoXue2+PvzeG7jrZvF3iVlu
         NNA35e4osFUkLg9gd3K0WzDo7zBM0K7J2P1UaqUCJ+kdBnWKkBNue57TUw7E0bHaZXzC
         offTuaN9YL0FGZ4Ial4SQPASVmreaaHtjDGPfD3CWgHlG7vkJC2+JZHcTyEboUuMXDLp
         tkgAaHLPpADnJVQIeLKtenmFHNsG1RfQlDH55p/y4v8Jdpju1R8xjrZL39v4UwuYs+W/
         n40vDKO9qs2ik7d0vEnh8LmBgFvV/X3gXZh/iiaC2pneoNAZQKp23W8cgiL7sUcQ4/qt
         hluA==
X-Forwarded-Encrypted: i=1; AKwUvBx1tfZNTJshL2zRW4xENyPR4LfW3ts1mVNZx8zS1ZZqDXZ/Ppb1izu18qxOLqH67quhcSaMMlfw9BIJ+2nw6w==@vger.kernel.org
X-Gm-Message-State: AFq9FYL1eUz38Hcf+J2N1S799J4B01A/+qQGtGMmYr8zoW9CKDM6r3H0
	9KaqvRwIARHgJTJqei6Yz5bD/5AWu9ml0q3VDb80GOULR4+OwI/fIhwsyezSfx5lNAPbylbfErH
	twdTfJCNbW1rsVtiFTn/PeDF51rnE4ZuxFqRKmLYlCMaJ/DE0PJv1pgFl+/JeAklrGG8yhg==
X-Gm-Gg: AYBFou08/hNhQl+sZTjD4+FsZ2Gl+F0GphHyzcOTxwtYANrknq36MfcLp5GsOqgVmJy
	shpy2nYXTIwkTIYg0rixqJrTJmvsGWZe2hu9fBlk5StX+27M/VN0ogC6RieYLVtBqs7RwQU+ad3
	R3p6WYhl0bAD2OvSYwLx21k8zGGjEYwVJqu0ShcTglD3Z/UU2qt+uMiom2SbxMnNuaVNOK/71o1
	Xf/+4vCkE6rOxIq3LWUkCToj7nceDPo3mi1iZ2a94200HLNRA9m2lmG6oQ0xm1SiSwAA2EOw7Rn
	Ra7K0d1G8YBBJHPL0c+A+Om0fMqgn8htS8oWyzCUH5Lo4XRaV93n8aG5o1DFHBWaO4leQKzWO+C
	VNl5cOcQOMhVeHVUptZrM8QFcfynIPNsxZdZAorb4c99Mj1Szih0f39vpzSj6WybFujoTuAldQM
	a/14VAIUzCBeemQ5Inwg+jRzsBuDuQOZ4I5IPvxf5cUnPKi55odblZf6ymrqueAL7GxwQ=
X-Received: by 2002:a05:7022:b887:b0:143:2719:f800 with SMTP id a92af1059eb24-1ac5f742576mr11890323c88.40.1793586791399;
        Sun, 01 Nov 2026 18:33:11 -0800 (PST)
X-Received: by 2002:a05:7022:b887:b0:143:2719:f800 with SMTP id a92af1059eb24-1ac5f742576mr11890288c88.40.1793586790624;
        Sun, 01 Nov 2026 18:33:10 -0800 (PST)
Received: from [10.79.123.162] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1854da78sm38432908c88.6.2026.11.01.18.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 18:33:10 -0800 (PST)
Message-ID: <82b5eecc-49c0-4132-936a-f333ec2b87b0@oss.qualcomm.com>
Date: Mon, 2 Nov 2026 08:03:06 +0530
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/15] wifi: SCS and MSCS
To: Felix Fietkau <nbd@nbd.name>, Vivek Chettri <vchettri@qti.qualcomm.com>,
        Bhagavathi Perumal S <bhagavathi.pillai@oss.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ripan.deuri@oss.qualcomm.com" <ripan.deuri@oss.qualcomm.com>
References: <cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name>
 <4c3aee64-d289-4648-9520-edb6518b3d13@oss.qualcomm.com>
 <6ed64b95-57a3-42a2-9280-c98978382fa6@nbd.name>
 <CH0PR02MB8168357184D7A6354A24A338F1BC2@CH0PR02MB8168.namprd02.prod.outlook.com>
 <43012c2f-3623-4211-b2de-de53e39df2e9@nbd.name>
 <d5cd9c2b-a37a-40be-8916-162d9250adce@oss.qualcomm.com>
 <3132508e-3b02-41bb-8d93-28f30ef3a864@nbd.name>
 <5cd8adcf-2c52-49b0-802c-d995eaf8960f@oss.qualcomm.com>
 <085bd870-0ec1-4b92-bc99-dfbfe3c7132e@nbd.name>
 <eedb870e-16ce-4f43-af9b-764fa81ae04b@oss.qualcomm.com>
 <ec490ae3-e37a-418a-b1a5-b5b76bafaa9e@nbd.name>
Content-Language: en-US
From: Vivek Chettri <vivek.chettri@oss.qualcomm.com>
In-Reply-To: <ec490ae3-e37a-418a-b1a5-b5b76bafaa9e@nbd.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: cvfY7Kl_C2rJyxwOAo81OzoFvHV19Eca
X-Proofpoint-GUID: cvfY7Kl_C2rJyxwOAo81OzoFvHV19Eca
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAwOSBTYWx0ZWRfX7RXbQ/b5aS/Y
 i2DNoBcfcK9DyStN5RF5htZsfx+zgf/jXJPIH881G/YvgQte9eQ941yblqMnLpQcjcTSkXVuQkK
 bCLOlfKUWNeCdnGejKISgqZd5KBas3zZJq+ayQZyWnxe/aeWeoE4TR2U25+/J26nadnSV+W1X1Z
 TnNrf6W00HNw3VKhyN4Qce1cCp/oVRaWQqdlVLB95WfgeBhd3tGM0qE4VUfpjHFeG1a5+z4SUJT
 yi+aoUZdllQ5MwEIAGU42z8i1qlV6xsLRuUvt1ghhu9JJTP8BoL4rQtX7zJ3dV/JAd8hsR2icP9
 BpqVrlIat41iKpNe4PBbZ67IXoaVd+E+sWUL3Q6K9cAyyi7Dq2oQHQpb0SrY+hFqYWJG1tu71J8
 mzGxqFlig4DOlwrp+MCy7isoMyT29vcuzc76HrFgylXXDxQDWMgfBKcAqvdAC+5oGmIvJQ7878H
 0yh1P6ha1Yf9qNEo87g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAwOSBTYWx0ZWRfX0OMN6DGb6Sd4
 iV7FrLTyAndvtOc7Qxomc6HbaD6wGWvNiNH0yvuRD9bfUQiVq5a1tLmolYxXnywoN+N/KArCR8U
 MPGIsqnlyTaYJe7pkMeNYyLtCtYBr7s=
X-Authority-Analysis: v=2.4 cv=cfVHPXDM c=1 sm=1 tr=0 ts=6ae7f668 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=3HDBlxybAAAA:8 a=kmBd6WBEA9ofdZpRpdUA:9 a=QEXdDO2ut3YA:10
 a=vr4QvYf-bLy2KjpDp97w:22 a=laEoCiVfU_Unz3mSdgXN:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020009

Hi Felix,

On 10/14/2026 1:26 AM, Felix Fietkau wrote:
> Hi Vivek,
> 
> On 13.10.26 21:04, Vivek Chettri wrote:
>> We agree that any policy conflict must be handled in a protocol-compliant manner
>> and should not result in a silent or partial removal of established state.
>>
>> In the proposed model, policy conflicts are detected by the centralized policy layer in
>> user space. When an administrative policy update conflicts with an active SCS session,
>> user space is expected to re-evaluate the affected session and initiate the appropriate
>> tear down procedure through the SCS control path.
>>
>> If the negotiated SCS policy can no longer be honored, user space would issue an
>> unsolicited SCS response with TCLAS_PROCESSING_TERMINATED_POLICY_CONFLICT to
>> notify the STA that the previously accepted SCS session is being terminated due
>> to a policy conflict. As part of the same operation, any classification state and
>> QoS characteristics associated with the affected SCS descriptor would also be removed.
>>
>> The intent is therefore not to unilaterally drop classification policies, but to ensure
>> coordinated tear down of the SCS session and all related enforcement state,
>> keeping SCS state, policy state, and QoS enforcement synchronized throughout the session
>> lifecycle.
>>
>> One area where a centralized policy model may also provide value is conflict detection
>> and policy prioritization. Since both administratively configured policies and
>> SCS/MSCS-derived policies are visible within the same policy repository, conflicts can
>> be detected and resolved according to deployment-specific policy precedence rules before
>> enforcement occurs.
>>
>> In the context of the proposed mac80211-centric approach, it is not entirely clear to us
>> how conflicts between existing system policies and previously accepted SCS policies
>> are detected, how policy precedence is determined, and which component is responsible
>> initiating the required SCS session tear down when such conflicts arise.
>> Additional clarification on this aspect would be helpful.
> 
> All of this needs to be done in user space anyway and is completely orthogonal to where the classifier is executed. If you have a system policy framework that provides constraints for what SCS policy can be accepted, it needs to run in a different layer than where the SCS classifier lives anyway.
> 
> Ideally it should be completely unconstrained by whatever intermediate format is chosen for the classifier ruleset (nftables rules or mac80211 tracked SCS descriptors).
> 
> Such a policy framework should (in my opinion) also not be forced onto deployments that don't need it.
> 
> From my perspective, there should be two modes:
> 
> a) no policy framework is present
> In this case, hostapd accepts SCS descriptors from clients, validates them and pushes the accepted ones to mac80211 as-is. SCS state is tied to client state and cleaned up as such.
> 
> b) system wide policy framework is present
> In this case, hostapd parses SCS descriptors and communicates with a policy manager process through a defined IPC API, installs only descriptors into mac80211 that are accepted by the policy manager, and later removes those that the policy manager indicates as conflicting with system policy. In that case, the policy manager has full control, can consider the non-wireless side as well. At the same time, its implementation is not baked into hostapd, there can be multiple different implementations that serve different needs, and they are not forced onto simple single-AP setups that wish to use SCS/MSCS.
> 
>>> That makes it completely independent of nft vs tc-flower created flows, or even L2 vs L4 offload rules.
>>>
>>> I don't see anything in your approach that could support this without forcing users to create flow offload rules through nft instead of tc.
>>> If you do, please let me know and describe the exact chain of events.
>>>
>>> - Felix
>>
>> For the L2 bridge flow hw offload case, there is an active upstream series gaining traction:
>>
>> https://lore.kernel.org/netfilter-devel/20260708093250.1187068-1-pablo@netfilter.org/T/#mb9581ceac031c8222db29af384f9fbbdfa9cc2a8
>>
>> This series adds native L2 bridge offload to nf_flowtable using nf_conntrack_bridge.
>> The kernel community appears to be converging on native bridge offload through nf_flowtable and nf_conntrack_bridge
>> as the standard mechanism.
>>
>> Our nftables/connmark-based classification approach aligns naturally with this direction.
>>
>> For offload designs that do not rely on kernel connection tracking
>> (e.g., MediaTek eth-to-WLAN flows via bridger), the connmark can still be retrieved
>> through the standard netfilter API using the 5-tuple from the flow.
> 
> That again assumes that the user is forced change the configuration to push bridged traffic through netfilter. This adds visible extra CPU overhead (through netfilter table processing and conntrack) in cases where you have a mix of offloaded and non-offloaded traffic.
> Currently hw offload can work with upstream kernels without netfilter by using the tc API with L2 offload entries.

The nf_flowtable infrastructure operates at two levels:
1. Software fastpath, where established flows bypass netfilter
   processing without requiring any hardware support
2. Hardware offload path, where capable hardware takes over packet forwarding entirely.

The netdev community is actively extending this same fastpath to bridge traffic
via the nf_conntrack_bridge RFC, building on infrastructure already proven for routed traffic today.
https://lore.kernel.org/netfilter-devel/20260708093250.1187068-1-pablo@netfilter.org/T/#mb9581ceac0%E2%80%A6

As a result, the conntrack overhead does not apply to all packets,
when flows are accelerated via the software flowtable fastpath,
netfilter hook traversal is bypassed entirely for established flows,
making the overhead concern not applicable in that path.

From a hardware offload perspective, the proposed approach remains compatible
with existing acceleration frameworks. Since SCS rules at the NFT egress hook
populate connmark info into conntrack, custom hardware accelerators can refer
to the conntrack entry at the required points in the forwarding pipeline,
benefiting from both flowtable-based acceleration and conntrack-derived state
without changes to the existing hardware offload architecture.

>> Regarding your ethernet patches: we notice that a non-WLAN module calls
>> ieee80211_sta_flow_prio() directly to perform policy matching.
>> This introduces a direct cross-subsystem dependency where offload drivers
>> outside mac80211 must call into mac80211 APIs.
> No, the call to ieee80211_sta_flow_prio comes from mt76.
> 
> To give you some more context: there is a mt76 part which attaches to the WED (wireless ethernet dispatch) device. WED is the hardware glue that handles forwarding between the WLAN device and the ethernet subsystem.
> 
> When transitioning a flow from unbind to bind (= enabling offload), the ethernet subsystem already gets the index of the WED device from ndo_fill_forward_path. Using that to look up the struct (which it already has a pointer to), it can call into callbacks provided by the WLAN driver.
> Indirect calls from ethernet to wireless are already required for offload anyway, since wireless specific metadata is needed in the hw offload entry.
> 
> Thanks,
> 
> - Felix

Thanks!
Vivek.
