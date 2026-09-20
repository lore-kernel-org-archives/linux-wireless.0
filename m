Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDC64570D6
	for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 16:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789921377; cv=none; b=Jeb1XPjpQBFaSXtMVod+caL54tHoUz38x3osVjIZT1SUeTHJqS3IlC157vwU5QC9gmA9UCBrPxGEqWpe3fLte1K8CZK6xbrANMxShg1rcwJYTPgvSHZn5nKYaHjBu4NDeX1/7imts85ku9k5pqPJh1wvL9z4JJse/t2Ula9DaME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789921377; c=relaxed/simple;
	bh=ZMnGgqvU7CVChtiyItfVSDcmZxMCDYiemvPFOiU+k28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PBHXAdwiKeMjA4Ze6/vNaLq48oHHwOGovoTSaScGZ7pdHkH8L+JUpZ3SABIW+krzVMe4BRjKxEOd1dM93GD5vMWIg0jAFqBtuwQwGtHlXay2wcAynV0diMHUH8n7Fcq/UVwq56Cbocn6w7ItFdjKaiHEHB/aFFcKxE2rNhsA+tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KoRvx4I3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Td9V3Gdg; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KoRvx4I3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Td9V3Gdg"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68KFA2JN3846477
	for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 16:22:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lcesAFXJlUS5Xl52LOyz6lL2cEjrWb4xoqeOVHeUMP0=; b=KoRvx4I3eaQd+TZ1
	mQK3bp9BtsMwCz1bTVEiqJCVwVkA4piHCyuHwBq8j/Uccms7wwjQw/07BJF0m5Ji
	esZMsoJ/jeGMvdEy4BEGuYMveT4BQ6Plv8Qrw14ETSSKP1K2oo9ufWdA8kRdDC/q
	qb2t3JOG0WAzVhHDgo1/PlPJjNbTK8wVwWawU1HLncnv4bCfAMekeCx3BWV7ZtJq
	DbN5whVfpu1zX8Y2oiKMc74/+/vypWSBICjQwnqB0ENebqmiLTA/+oaKZ6oAUDN3
	ymY+3MYSUc1KDw0L6YE0yfVq7aMtaBr8M5xhEfVL3MzDmFzHw7YGE9f7TbmYgD1o
	PcWfkA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gsg3f3p2w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 16:22:54 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39deb05ef51so3598089a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 09:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789921374; x=1790526174; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lcesAFXJlUS5Xl52LOyz6lL2cEjrWb4xoqeOVHeUMP0=;
        b=Td9V3Gdgz5SUe1Lds8QDbMx3dZl/B+vqO7N07IWE7wZYbKZrbH0A5npTeEdBQeWQZQ
         3XRrn/aG8f1kJqfbjNTvhTjO3BNB1fop9NCt2ja1jZEYSY7fZVx5oOc3pCntvYOUrm1q
         c75L4S4pZYwPtKGNtbUYSfNqrZy44/vmbzV3InX6bt5O9+kOmf6nmgTFYSVQj02XI5wh
         Mz7tNlmWrwwtUUBCN2BlEoEJpK0OViHnVs/iuUJTYKNx/WhNuoD3S6w1w/d0iIKZzaJV
         Q6st0p+LQFoHj3QTUN/I8lFqs4GWScYHewCYAroxT2wgQifbBUu/7YoIY5+01VysjQAY
         Pw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789921374; x=1790526174;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lcesAFXJlUS5Xl52LOyz6lL2cEjrWb4xoqeOVHeUMP0=;
        b=04mzB/07MxN8dtE+rlUjdkDs9Nvqi6qkiZwnVvGiZGj83DpcnGZHXminaeczVbf37/
         PJQyLfPDZoJXhTVT7oGgwFcS2347jZNFgdQiKRbx2xclGF7+1LVijd+hPrVvO/+HLrnT
         2Z6+WiizC39bQjz3P0h0B4Jqb39CH8co2W7Pw4Vh85R/J7cV4XVbAleosM41avOSGFcR
         UnLw9Wug0Ize6d6T6U2E5r2GHhQFpVyOy2aqiVuPoge9WO4fK8j/JosGwPDu8JCgcxEA
         ucv+oteLJ8zTASb2tb5ZvL+htI6DV031P78y7T5TymcP0/s6VwlIDs1W8KRpEXgaW8ZQ
         ugFg==
X-Forwarded-Encrypted: i=1; AKwUvBz+OzZXIxFkbvzo6osHeNxiZEbhXXxXpNV36mr/FSEr/J1KP+H23ShYOSopUMHa2QS/jHBIHk2WK4cfLKh+vA==@vger.kernel.org
X-Gm-Message-State: AFuF++mvJgux77sd3KZ0p1KYz6waJHtDTVUq4ypbaASAhdAxOirYybRa
	6N6Kz8PvXKbUlGegfhvJyrJJcddS8gsjwsnx4U0zDthUZMnZfgd4XfWlKbLhfU4oxeqa1J2nQ/T
	DtuP1LmY+1nNAg1D5TNFL8s/97xC5heveGas5iYoUdbtlcTlJN/ow6tUbboaU3/D5b2SquUmufc
	5p+w==
X-Gm-Gg: AYBFou2Dorn49sD31rDEF9Oq80JhfXDQg22FPyiRIIAhdolk+kVSCdaBiJdXj/kG10E
	Gkbb2YZcEDLvpTQvlSdvDoH831w9KuMmJeEhJ0iU/KjUplH4rTBz3rpP/4kaSA7ZcLteL4pqAQR
	k5MPPfFnVqUTFXHlQqgkjDWzJ2/93iVXHyjfK4TEBlm7VVSIPPCS9XLCz3QpU4dXtT5kIs/gFrR
	qZOqPN/Tuuq6uEY28Ov/Yg6W3Xnn8oZgbSitA8usedFcRlVXTxXMGuwr2gffJqnRzAKaPKOsWmY
	YbTCntGdBaAW6tsNjI5WJNny0HE4A5YXexyRM15aUwkgXzLjB5a0eL6EatspmpFYbaIq+TWG4oV
	hatSMVckPrUbZH+tmQmVdYPuZKXsU
X-Received: by 2002:a17:90b:3c52:b0:39e:6a81:c91f with SMTP id 98e67ed59e1d1-39e6a81c9a2mr8995926a91.18.1789921373809;
        Sun, 20 Sep 2026 09:22:53 -0700 (PDT)
X-Received: by 2002:a17:90b:3c52:b0:39e:6a81:c91f with SMTP id 98e67ed59e1d1-39e6a81c9a2mr8995910a91.18.1789921373234;
        Sun, 20 Sep 2026 09:22:53 -0700 (PDT)
Received: from [192.168.1.6] ([171.76.84.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144d55d2269sm12494187c88.11.2026.09.20.09.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2026 09:22:52 -0700 (PDT)
Message-ID: <d5cd9c2b-a37a-40be-8916-162d9250adce@oss.qualcomm.com>
Date: Sun, 20 Sep 2026 21:52:48 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
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
Content-Language: en-US
From: Vivek Chettri <vivek.chettri@oss.qualcomm.com>
In-Reply-To: <43012c2f-3623-4211-b2de-de53e39df2e9@nbd.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIwMDIzOSBTYWx0ZWRfX9S3XFc8vtYPG
 npE68f0nxNJVJot4WpF/UmkuFaZMDmgVgCMqrIY/tDl1rasJuFoocmxwAo6xxomydUx+x4eDnmE
 RHqtAkGf4vI+pg2cF3mxDhHkItRltuE=
X-Proofpoint-ORIG-GUID: O1P44Vi0vW-6Md0IApOjCHEWQLo554Mc
X-Proofpoint-GUID: O1P44Vi0vW-6Md0IApOjCHEWQLo554Mc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDIzOSBTYWx0ZWRfX62ib9XPos713
 YxUjsnY25ixAGT1ccY+tFRGB2Arfbuj+vEbdZfGZ9qhDTS2jlZTtqQR1eSpI9hNmC8vDS5t08BR
 E9mgLtEuhoUWUlRF5Nj0oVTzg4HX9msLnyn5YbMUfsIbPRcfkiKGEWwXMvxrWQqJrUGmABub/kg
 AA/tN+3OcRqB1g/EBVSycLRMmkjcoddmdvukEhA7O17YTigWQQ8bVm/FaPtXUQdOQKKQsfGPkeq
 GPvieE4MnfNUWj7N2mrSZlQESayvXtEkB4wzdRcBSrQvX16SXSYgisvJ81rpUQq45k2C3SNx6jN
 kRGQmB13xkitEV2vHb2Ruk+NUr+ZrDtJHb6k8y43JwOlDXs9SfOhtci8/T84VqJBIxExjxvXX/G
 +cBb4GLEGTNXiDD/kZoj/Ed4E87ogLsChL5IHZXw/QyBw29GSVAV3ba7XhjKg7lTwsda+1xOvbc
 Ntk1ZqhU7KK9TQ1JniA==
X-Authority-Analysis: v=2.4 cv=N6S8hG9B c=1 sm=1 tr=0 ts=6ab0085e cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=9Lzk0VLn9KdRuJTV/0+ytA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=07d9gI8wAAAA:8 a=X-kl0NPSs1swFSN-qHAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22 a=e2CUPOnPG4QKp8I52DXD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-20_05,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609200239


Hi Felix,


On 9/14/2026 2:49 AM, Felix Fietkau wrote:
> Hi Vivek,
> 
> On 13.09.26 21:23, Vivek Chettri wrote:
> 
>> The preference for reusing existing packet-classification infrastructure is
>> driven by the need to have a centralized policy management and policy framework
>> that operates across both software and hardware-offloaded forwarding
>> paths, rather than introducing a separate classifier within the WLAN stack.
>> 
>> 1. Centralized QoS and Policy Management
>> 
>> A centralized policy management framework provides the following advantages:
>> 
>> • A centralized policy database enables end-to-end QoS policy enforcement
>> across different forwarding paths, improving manageability and policy
>> visibility throughout the system.
>> 
>> • SCS/MSCS policies represent only one source of policy management. 
>> Administrators may also configure firewall, QoS, or other policies that
>> must coexist with negotiated WLAN policies.
>> 
>> • Centralized policy management provides clear visibility into the interaction
>> between administrator-defined policies and dynamically negotiated SCS/ MSCS
>> policies, making conflicts easier to detect and manage.
>> 
>> • Implementing packet prioritization independently within mac80211 can introduce
>> policy conflicts or ambiguous precedence when administrator-defined QoS policies
>> overlap with SCS/MSCS-derived priorities.
>> 
>> • A common policy framework helps ensure consistent behavior across software
>> forwarding, bridging, routing, and hardware-offloaded data paths.
> 
> I don't think any of this really conflicts with my proposal. A full end-to-
> end policy framework seems out of scope for direct implementation in
> hostapd anyway, so it should be an external component.

The proposal is not to implement a full policy framework in hostapd.

Following is the functionality split:

Hostapd:
	Primarily responsible for SCS/MSCS protocol handling.
	Processing of the protocol descriptors ie TCLAS and QoS elements.
	Programming an existing kernel policy framework such as nftable.

Nftables:
	Policy storage.
	Classification.
	Packet marking along with offload enablement.

> hostapd should allow deferring management and policy decisions of client- 
> requested SCS/MSCS exchanges to external components anyway to support things
> like EasyMesh well.
> 
> Having this separation would help if you intend to push flow classification 
> for things like wired upstream links, which hostapd should not worry about
> at all.
> 
> In such a scenario, a custom implementation could choose to omit passing
> full classifiers to mac80211. That said, for most common use cases,
> including standalone APs and simpler EasyMesh implementations, I believe
> that using the mac80211 support that I added is the right choice due to the
> lower complexity and overhead.
> 

I agree that policy decisions can be delegated to external components for Easy
Mesh use cases, and I don't see a fundamental conflict there.

While the mac80211-centric approach is looking attractive for simpler
deployments, we should consider an approach that scales across varied use cases.

In deployments where SCS/MSCS, administrator-defined QoS policies (DSCP), and
hardware offload mechanisms coexist,having a central source for classification
can help as follows
	1. Avoid duplication of policy framework
	2. Simplify policy interaction, conflict resolution
	3. Consistent enforcement across different forwarding paths.

>> 2. Policy Framework: Considerations and Challenges
>> 
>> A policy framework should help ensure consistent behavior across software 
>> forwarding, bridging, routing, and hardware-offloaded data paths.
>> 
>> The policy framework can be realized using either nftables or tc-flower. Both
>> approaches provide a persistent and centralized repository for traffic 
>> classification and policy enforcement, but differ in integration complexity,
>> feature scope, and deployment model.
>> 
>> Common Capabilities: nftables and tc-flower
>> 
>> • Both nftables and tc-flower maintain centralized rule databases for traffic
>> classification and policy enforcement.
>> 
>> • For software-forwarded traffic, both solutions require flow lookups against
>> installed rules and therefore have broadly comparable classification overhead.
>> 
>> • Both mechanisms can serve as the policy enforcement layer for SCS/MSCS-
>> derived traffic policies.
>> 
>> Advantages of nftables
>> 
>> • nftables provides a unified framework for firewalling, traffic classification,
>> and QoS policy marking.
>> 
>> • nftables can support both software and hardware-accelerated forwarding paths
>> and can be extended to additional offload scenarios with minimal architectural
>> changes.
>> 
>> • Existing support for nftables-based policy handling in hostapd reduces 
>> integration effort and leverages infrastructure that is already available and
>> upstream-ready.
>> 
>> The implementation is done using libmnl, which avoids licensing incompatibility
>> between hostapd (BSD-3-Clause) and libnftnl (GPLv2). This approach was
>> also reviewed with Jouni.
>> 
>> • Using nftables allows SCS/MSCS policies to be integrated into a broader, 
>> system-wide policy framework rather than introducing a WLAN-specific policy
>> engine.
>> 
>> • Using nftables can also facilitate scalability by allowing these rules to
>> be applied at software acceleration decision-making stages. For example, the
>> NFT rule can be cleanly integrated into NFT flow tables as well.
>> 
>> Challenges with a tc-flower-based Approach
>> 
>> • A tc-flower solution would require substantial additional implementation 
>> for rule programming from hostapd.
>> 
>> • tc-flower typically requires qdisc configuration (at a minimum, a clsact 
>> pseudo qdisc) before classification rules can be installed and enforced.
> 
> Most of these points are very abstract and in my opinion gloss over a lot of
> implementation complexity. I'd argue that just because nftables is used to enable
> offloading in some setups doesn't mean that it handles the different policy
> aspects of SCS and especially MSCS well, or provides good ways to deal with
> runtime changes to existing flows.
> 

I agree that implementation complexity and runtime updates are important
considerations. For SCS/MSCS cases, nftables address the highlighted concerns
in following ways

Complexity: not a concern
  - Linux Kernel NFT Infra provides well defined APIs to program policies
which satisfies present use cases and does not add much implementation
complexity or overhead.

Runtime: supported
 - These APIs indeed having support for runtime modifications as per SCS/MSCS
protocol requirements.

Offload cases: supported seamlessly
 - nftables is already used as a general policy and classification framework
for both software-forwarded and software/hardware-offloaded traffic.

Protocol classifiers: all mandatory variations supported
 - The classifiers required mandatorily by SCS/MSCS, including cases such as
TCLAS Type 10 (ESP/SPI Based rules), are supported with nftables.

> I get the impression that your proposal is designed to handle the needs of a
> single Qualcomm implementation of an out-of-tree policy framework service well,
> while neglecting in-tree kernel offload mechanisms, as well as standalone
> AP implementations by pushing extra complexity there.
> 

The nft based proposal is neither Qualcomm-specific nor based on out-of-tree
policy framework.

Qualcomm's approach using nftables works for systems with no offload, software
offload, or hardware offload by leveraging existing upstream infrastructure as
follows.

	1. SCS policies programmed by hostapd are part of the net filter egress hook
which maintains classifier info along with QoS identifier (nfttable rule->mark).

	2. Mark field part of the nftable gets populated into connmark of the ct
during connection establishment.

	3. The connmark information that is populated at the egress hook can be used
for HW offload programming by the vendor driver

	4. As the SCS policies are added at egress hook this would seamlessly work
even when software offload(nft flow table) is enabled

SCS/MSCS would simply act as a policy producer, while classification and
enforcement remain within common in-tree mechanisms.

The goal was not to push Qualcomm out-of tree implementation, but to have a
solution using existing in-tree kernel mechanisms
	1. Avoids Duplication of the same coming at mac80211
	2. Reduces system complexity with centralization.

Qualcomm offload mechanism can work with policy data base built at mac80211
also; however what we wanted to explore was avoiding non 802.11 network-wide
policy and classification decisions within mac80211. This helps prevent the
creation of a parallel policy framework and keeps mac80211 focused on Wi-Fi-
specific functionality and concepts.

> Let me give you a specific example. On OpenWrt, Ethernet -> WLAN bridge hw flow
> acceleration works by having a user space daemon that replicates the bridge
> state, measures L2 flows via eBPF and programs no-sw tc-flower offload rules
> for L2 flows. On the MTK driver side, the offload core uses the programmed
> L2 rules to trigger actual hw forwarding. Only for routing/NAT flow offload
> does nftables get used. The kernel side is fully implemented in upstream
> kernels without any out-of- tree subsystems.
> 
> The forwarding from Ethernet to WLAN works because the kernel code can
> resolve the hardware path via dev_fill_forward_path and query the relevant
> metadata (which happens by calling into the WLAN driver through mac80211).
> 

Thanks for the example.

If both traffic types (bridged and routed) ultimately require policy
classification and offload decisions, having a common framework could provide
a single policy repository and a consistent programming model across all
forwarding paths.

Referring to the following article, can nftables be considered for bridge
offload as well?

https://lwn.net/Articles/1082320/

> In the series that I've built on top of this one (but not yet posted), the 
> offload core driver can additionally query the classifier result for a flow
> at the point where it enables actual offloading (the trigger is PPS
> threshold exceeded). This works because mac80211 has the active
> classifiers, allowing the WLAN driver to provide them to the offload core
> driver.
> 

If possible, could you share the patches (or a draft branch) for the series
you mentioned?

We would be interested in reviewing the end-to-end architecture and
understanding how it integrates with the existing tc and nftables offload
paths separately.

> This design allows transparently respecting the SCS/MSCS classifier for hw 
> offloaded flows regardless of which API was used to trigger offload (tc or 
> nftables). Additionally, the user space components handling the offload for
> both approches do not have to worry about SCS/MSCS in any way.
> 
> I don't see how your hostapd programmed nftables rules approach would handle
> the same properly.
> 
>> 3. Summary
>> 
>> • The primary role of SCS/MSCS handling within the WLAN subsystem should be
>> to negotiate and manage QoS policies between the AP and STA.
>> 
>> • Packet classification and policy enforcement should be delegated to a 
>> centralized policy framework such as nftables, which is already designed to
>> manage system-wide traffic policies.
>> 
>> • The WLAN driver remains responsible for mapping classified traffic to the
>> appropriate transmission priorities and ensuring the negotiated QoS behavior
>> is achieved across the data path.
>> 
>> Also, what is the plan for supporting repeaters and backend devices?
> 
> Not sure what you mean by backend devices. For repeaters I would use a software
> component (preferably outside of hostapd/wpa_supplicant but interacting
> with both), which acts as a repeater for SCS policies requested by local
> clients (pushing them to the upstream AP) and tells hostapd to install local
> descriptors where local classification is needed. If you have concerns
> about specific scenarios, please describe them to me.
> 
> Thanks,
> 
> - Felix

Thanks!
Vivek.
