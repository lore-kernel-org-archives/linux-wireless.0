Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D7D395AF2
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 05:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790399267; cv=none; b=aHk1Cl3dag47LsBQl9C95OcgTwsdSnzp5YciWrEiun2NC6OFpkq86HGgDL9N8i5ELVfHKjYf3yckii5JajXmpYiuvuCp/PZsemLXc31wFDdXJy2Z+LQOJB1VR6vB8pLkdRzgmb6rIsLsv7l8RODg++timHaa/AclqksSngTwYKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790399267; c=relaxed/simple;
	bh=m+VuTrHMrrBGOVfXVa93HS8KecMsREwNWkWavKr7VA4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=NGHMCHF3EJXYk2UeaRBvGKWmRV2997yva256v4j3R14yrs0gFMJTi6hDGN8qIbrMV1BaUpvOu/KR4v9J8HZldpzyA5I/D/XexDG+OUmZAzhg6UCr/HWCEWnXb875hxhmXH4L9dBd1VN8Ez1krgzbq1KqSk+fwsG4T4iLMnof8jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ID++FdgD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ijLJGi/C; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ID++FdgD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ijLJGi/C"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68Q3JPWF3934516
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 05:07:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GmKA+HdH3N9Yd3BChkP4IT8gYw2zXsT5JM4bBMbv1qQ=; b=ID++FdgDheDr1dYw
	mOLtOXlQIJENy/L1CjtH894HycFYr807TZ460DE/xQ7w3qWtjcJ7Borh2+qZpuGZ
	InE0HOucJ8KbXYkoFXsXn0111D4odweEe8hvwirMECKqbip/CvnYADNeDyOqDC6H
	0It/YnHVkTh+kPYdSB8tGCK+CIFQojTjNj3TPJAS5Yp9/LOWoFPWfIbGUo95b59z
	gReg9cpfufNs+MU7VTjAsiCSEBzYIqOPlR1C5YvV1vlB/HR3773d3dVf+IIJ9V6R
	ILrZ/y3zQLw5SkBOyWIerwxi5yB03bNrFDdqqQ43M+9Le6+EsZREdsCyU9AvwFcA
	VwMBOw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gx50s8a7e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 05:07:44 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30bcb065bfdso2576003eec.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 22:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790399264; x=1791004064; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GmKA+HdH3N9Yd3BChkP4IT8gYw2zXsT5JM4bBMbv1qQ=;
        b=ijLJGi/CkQkpXuL0PtrVXJRchUWPUh6wGWWtQ2cnmAbNbEenyzjr7qIZqmG0BN9A3E
         T2h+ggzf0wYBwqndWEq08gHaX8yGRSOxYcwKmvUYKkMSi/SGD++IW1KDFY/i/GIlPe/K
         53vU6xf8tfFjaWPYzb+0Msj3/fVHQCKnReM9BDOePIkDY4VJ8kdXW851aCUlZ1Y8FzON
         lIkqMqjVkbD5h1TuqCJUOIZuv1vBPQUxEzRHe96zS9hSI02ccqyexrDnJOjlGFpIdnaP
         5F9zeA9ST2Ds0n6ogGhWzpibkRevv11Cy0Ixv8RbgCr34aFPuXfC39EapNBbPYGQCnWw
         TEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790399264; x=1791004064;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GmKA+HdH3N9Yd3BChkP4IT8gYw2zXsT5JM4bBMbv1qQ=;
        b=A6taKbLl7BC2XBN6PQdWVhQ1whnNYx+aSFGrmY+k9cHR+S/NkdJ6SoHjZShpVRm48t
         DzsFtJCdmgyFVTQ7vUQzgrrr3cUYGsv7/upZh0uHqyUT1Wyc810yBgmg83SlJr252q2D
         EyyMGH/NV8Jtir3akg83918IlK50Znqymy15NRqyazLQDEr/1/tO2finrBohHWSUw1sy
         7F7U6ElHWku2rggfC/O6DOsQyi5cpIllB+QsA9cTgb5ANV+pYZCH2IrE95TeVL2NbKe+
         0lobsXKqPbQaIdRor3dgL8H8efQQrjx8bikRXs/O6ui2mUKPEJ7Y0kbmGfXzroMXR92S
         aC7w==
X-Forwarded-Encrypted: i=1; AKwUvBynZmKrbRjfysfqDl6mnwkHj/TsRBegUhQgVIoZYC1WKxgzwt6geJatEWGrhsCKQwHVGN907J1q/LY4VN8gNQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kmFmXEh0ElHUtBS5ZWhT1SF17gStjRCvqfQUoYb66S8Pyf/ZYO
	irGqCAtKPTx/S410m/XznEIP8PM15Ez1Sh+gTREG9jvVrHEumiCyJgWfDHZpDO8LGuIzHWN69WA
	HPvcypWE5r+8H7yXHel9deQ+x7zLaL9PwCqOXc7/PiAT2uFHWkKi/ORWIYeb5Af2+SWLM+Ds7Oz
	cVJg==
X-Gm-Gg: AYBFou065w3bDfS8cTvqk53BYaIgD48oLpE1Wu5MXwrHDeNNPmzOCSz0lXoNuI1qLgY
	oFgNdvzmdjyYOQPuv/BpriF34MN4A3yheV74RQYeDdf2li4wA5f6UwguiDY+Yn6X9X9QYnuPgpO
	Wsly0xijn2K2ARXtveypTPiC2cKm9c4MsFZkCfmeN6uMlvyavBvN/+0Ywba94d7xgEooqeW49xw
	aHmi0mRiAwY5WL1Ou4Sv3DEArsQnCz7rcgLl+cBJ3ruvHISMHzMIcJKrY3iWUxHtJ/IKiAs2C+M
	vB2lOfDnU7eewM+wnUORMtSFo/bEucOk9yW9XfTfQdFUxNO28Vg/zD7upJwadKQD0rmIY/ELGZx
	2arcpxhEOV/EBGbG3ogSeYnrSVjuH
X-Received: by 2002:a05:7300:cc1b:b0:327:e68e:3230 with SMTP id 5a478bee46e88-342702c203bmr2639100eec.10.1790399263081;
        Fri, 25 Sep 2026 22:07:43 -0700 (PDT)
X-Received: by 2002:a05:7300:cc1b:b0:327:e68e:3230 with SMTP id 5a478bee46e88-342702c203bmr2639045eec.10.1790399262158;
        Fri, 25 Sep 2026 22:07:42 -0700 (PDT)
Received: from [192.168.1.7] ([171.76.85.101])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm3240723eec.11.2026.09.25.22.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 22:07:41 -0700 (PDT)
Message-ID: <5cd8adcf-2c52-49b0-802c-d995eaf8960f@oss.qualcomm.com>
Date: Sat, 26 Sep 2026 10:37:38 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vivek Chettri <vivek.chettri@oss.qualcomm.com>
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
Content-Language: en-US
In-Reply-To: <3132508e-3b02-41bb-8d93-28f30ef3a864@nbd.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI2MDAyMCBTYWx0ZWRfXzR5qja1gZGav
 odB7LmS5Ak68iWWo6Na2Uy5NGJRifv0PII6Ic1jbd8sK4QPDTzU4JExTDvP/IgjqeYO0QlpyF2s
 p0HxHo/d89lxWKugViRLesEl0I43CLQ=
X-Proofpoint-ORIG-GUID: VTIzjfLF6GCGfL0-irSuNybl-ZkvOtz3
X-Authority-Analysis: v=2.4 cv=WuK+otfv c=1 sm=1 tr=0 ts=6ab75320 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=AZx8ELLklg8SqXq0CceY2g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=07d9gI8wAAAA:8 a=sYm4Oq7ig5eKH2BNKuMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=e2CUPOnPG4QKp8I52DXD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI2MDAyMCBTYWx0ZWRfXwUfJXATMyy/0
 e+SWAoIxpVdgOAvL21zbCg61a2WdBTIQJC59XBvC/hs01H0jnH2W1VRonrc6NRvvabX68H+G5ki
 Vf3Roy3LelIQck954tJkKRqnGt06TaZf9PJ0/Yg7xGGRTUn5OayheXpgbSKG/0m89fCijjBqmVh
 BnjLm+WLLMwcjz6Z9iUzEd4NkdKKhBQW00KsgSgv693JlROjCN8KZ9INVJGXX9JVdXmn3grcuRE
 QgQfIJSzlgDsbasHJiCc2k2jbCAy5f6wWRF+jNVgqfl229sbLgqY3pggtUfgX8n06/jYw0iCCKf
 Q2BBtZxuhDIHji0Bh8y+4jZZKRKRbJlvqCbcMU9t6BRGOlk3OmyqNvbdz+UTlotUZi43vQ3jktd
 nf9v6pRDhN6GpYeBRxKDaGGfIrVmRMFJg0j0Pr5TAGZFRlKb/4+UjKoo24OSFngRuwL2c0vKTFc
 X41rgll0X7v7IeWtgOg==
X-Proofpoint-GUID: VTIzjfLF6GCGfL0-irSuNybl-ZkvOtz3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-26_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609260020

Hi Felix,


On 9/22/2026 3:35 PM, Felix Fietkau wrote:
> Hi Vivek,
> 
> On 20.09.26 18:22, Vivek Chettri wrote:
> 
>> The proposal is not to implement a full policy framework in hostapd.
>>
>> Following is the functionality split:
>>
>> Hostapd:
>>     Primarily responsible for SCS/MSCS protocol handling.
>>     Processing of the protocol descriptors ie TCLAS and QoS elements.
>>     Programming an existing kernel policy framework such as nftable.
>>
>> Nftables:
>>     Policy storage.
>>     Classification.
>>     Packet marking along with offload enablement.
> 
> I'm not sure that nftables is a good policy storage for SCS/MSCS.
> In my proposal, all accepted SCS descriptors sent to mac80211 are enforced without direct policy override. That is by design, because it is expected by the standard.
> If system policy contradicts SCS descriptors requested by the stations, that's fundamentally an admission problem that needs to be dealt with in user space before descriptors ever reach mac80211, so that the station is told what is accepted and what isn't.
> 

We believe admission control can still be handled through a centralized policy database.
Instead of always giving SCS/MSCS requests higher priority,
administrators could choose whether SCS/MSCS policies or existing system policies take precedence.
This provides flexibility for different deployments.
When policy conflicts occur, the centralized policy layer can make an admission decision before enforcement,
rather than automatically prioritizing SCS/MSCS requests.

Consider a deployment where a station successfully negotiates an SCS stream
for a video application and the corresponding QoS policy is accepted and programmed.
Later, an administrator updates the network policy to de prioritize or block that traffic class,
for example due to congestion, bandwidth quotas, or enterprise policy requirements.

In a centralized policy model, the new administrative policy can be viewed and compared
against the previously accepted SCS policy, the conflict can be detected.
With the SCS policy in mac80211, the admin is not even aware of the policies.
The SCS session can be re-evaluated or torn down as appropriate.
This ensures that policy changes made after SCS admission can still be enforced consistently across the system.

>>>> 2. Policy Framework: Considerations and Challenges
>>>>
>>>> A policy framework should help ensure consistent behavior across software forwarding, bridging, routing, and hardware-offloaded data paths.
>>>>
>>>> The policy framework can be realized using either nftables or tc-flower. Both
>>>> approaches provide a persistent and centralized repository for traffic classification and policy enforcement, but differ in integration complexity,
>>>> feature scope, and deployment model.
>>>>
>>>> Common Capabilities: nftables and tc-flower
>>>>
>>>> • Both nftables and tc-flower maintain centralized rule databases for traffic
>>>> classification and policy enforcement.
>>>>
>>>> • For software-forwarded traffic, both solutions require flow lookups against
>>>> installed rules and therefore have broadly comparable classification overhead.
>>>>
>>>> • Both mechanisms can serve as the policy enforcement layer for SCS/MSCS-
>>>> derived traffic policies.
>>>>
>>>> Advantages of nftables
>>>>
>>>> • nftables provides a unified framework for firewalling, traffic classification,
>>>> and QoS policy marking.
>>>>
>>>> • nftables can support both software and hardware-accelerated forwarding paths
>>>> and can be extended to additional offload scenarios with minimal architectural
>>>> changes.
>>>>
>>>> • Existing support for nftables-based policy handling in hostapd reduces integration effort and leverages infrastructure that is already available and
>>>> upstream-ready.
>>>>
>>>> The implementation is done using libmnl, which avoids licensing incompatibility
>>>> between hostapd (BSD-3-Clause) and libnftnl (GPLv2). This approach was
>>>> also reviewed with Jouni.
>>>>
>>>> • Using nftables allows SCS/MSCS policies to be integrated into a broader, system-wide policy framework rather than introducing a WLAN-specific policy
>>>> engine.
>>>>
>>>> • Using nftables can also facilitate scalability by allowing these rules to
>>>> be applied at software acceleration decision-making stages. For example, the
>>>> NFT rule can be cleanly integrated into NFT flow tables as well.
>>>>
>>>> Challenges with a tc-flower-based Approach
>>>>
>>>> • A tc-flower solution would require substantial additional implementation for rule programming from hostapd.
>>>>
>>>> • tc-flower typically requires qdisc configuration (at a minimum, a clsact pseudo qdisc) before classification rules can be installed and enforced.
>>>
>>> Most of these points are very abstract and in my opinion gloss over a lot of
>>> implementation complexity. I'd argue that just because nftables is used to enable
>>> offloading in some setups doesn't mean that it handles the different policy
>>> aspects of SCS and especially MSCS well, or provides good ways to deal with
>>> runtime changes to existing flows.
>>>
>>
>> I agree that implementation complexity and runtime updates are important
>> considerations. For SCS/MSCS cases, nftables address the highlighted concerns
>> in following ways
>>
>> Complexity: not a concern
>>    - Linux Kernel NFT Infra provides well defined APIs to program policies
>> which satisfies present use cases and does not add much implementation
>> complexity or overhead.
> 
> You can claim that, but reading the QSDK implementation of the hostapd/nft integration code gives me the opposite impression.
> 

While the implementation is not particularly complex,
its size is largely driven by the need to implement wrapper APIs
for programming nftables rules via Netlink messages.

Due to licensing constraints, libnftnl cannot be used directly with hostapd,
requiring the use of libmnl and direct construction of Netfilter Netlink messages.

Much of the code therefore consists of standard message encoding and communication
with existing nftables kernel interfaces rather than complex policy or algorithmic logic.

>> Runtime: supported
>>   - These APIs indeed having support for runtime modifications as per SCS/MSCS
>> protocol requirements.
>>
>> Offload cases: supported seamlessly
>>   - nftables is already used as a general policy and classification framework
>> for both software-forwarded and software/hardware-offloaded traffic.
>>
>> Protocol classifiers: all mandatory variations supported
>>   - The classifiers required mandatorily by SCS/MSCS, including cases such as
>> TCLAS Type 10 (ESP/SPI Based rules), are supported with nftables.
> 
> One aspect this ignores is intra-AP forwarding handled by mac80211.
> 

This should not be a major concern.
In such scenarios, traffic can be forwarded via the bridge using hairpin mode,

In addition, upcoming peer-isolation support introduces per-peer controls for intra-AP forwarding,
either at the mac80211 or bridge layer.
This would allow SCS/MSCS clients to be configured to use bridge-based hairpin forwarding
and for other clients we can still do forwarding from mac80211.

As a result, intra-AP forwarding does not fundamentally alter the architectural considerations discussed here.

The same policy classification, storage, and forwarding mechanisms
can continue to be applied through the common policy framework,
while keeping network-wide policy decisions outside of mac80211.

>>> I get the impression that your proposal is designed to handle the needs of a
>>> single Qualcomm implementation of an out-of-tree policy framework service well,
>>> while neglecting in-tree kernel offload mechanisms, as well as standalone
>>> AP implementations by pushing extra complexity there.
>>>
>>
>> The nft based proposal is neither Qualcomm-specific nor based on out-of-tree
>> policy framework.
>>
>> Qualcomm's approach using nftables works for systems with no offload, software
>> offload, or hardware offload by leveraging existing upstream infrastructure as
>> follows.
>>
>>     1. SCS policies programmed by hostapd are part of the net filter egress hook
>> which maintains classifier info along with QoS identifier (nfttable rule->mark).
>>
>>     2. Mark field part of the nftable gets populated into connmark of the ct
>> during connection establishment.
>>
>>     3. The connmark information that is populated at the egress hook can be used
>> for HW offload programming by the vendor driver
> 
> Having the driver make DSCP tagging decisions based on connmark seems like a band-aid hack to me. connmark can be used by the user for multiple purposes, including policy related decisions.
> Relying on it in the driver for a specific purpose seems like a bad idea to me.

We understand the concern that connmark is a generic field and may be used for other policy decisions.
However, using conntrack marks for QoS-related state is already an established pattern in the kernel networking stack.

The NET_ACT_CTINFO documentation explicitly states:

▎ "Current actions transfer connmark stored DSCP into ipv4/v6 diffserv and/or to transfer connmark to packet mark.
Both are useful for restoring egress based marks back onto ingress connections for qdisc priority mapping purposes."

This is further reinforced by the upstream commit introducing act_ctinfo (Kevin Darbyshire-Bryant, 2019),
which explains the motivation directly:

▎ "Ingress classification is traditionally a challenging task since iptables rules haven't yet run
and tc filter/eBPF programs are pre-NAT lookups...
Thus marking the connection in some manner on egress for later restoration of classification on ingress is easier to implement."

This indicates that carrying QoS classification information in conntrack state,
and consuming it later for QoS-related decisions, is already an intended and documented use case within the kernel.
Importantly, our proposal does not have the driver read connmark directly.
The connmark → skb->mark translation is performed by an explicit, nftables rule. The driver only consumes skb->mark.
Therefore, the proposal is not introducing a new semantic for connmark,
but leveraging a mechanism that is already used for QoS-related classification and priority handling.

>>     4. As the SCS policies are added at egress hook this would seamlessly work
>> even when software offload(nft flow table) is enabled
>>
>> SCS/MSCS would simply act as a policy producer, while classification and
>> enforcement remain within common in-tree mechanisms.
> 
> I also don't see how nft handles MSCS well. It learns per flow from the TID of received uplink frames, with a per station classifier mask, UP bitmap, UP limit, entry timeout and entry limit. How does a dynamic nft set expresses "record the UP of this uplink flow under this station's mask, expire it after this station's timeout, cap it at this station's limit".

Our proposal for MSCS is that mac80211 parses the uplink priority for a client with active
MSCS session, it updates the skb->mark which then updates the conmark in the ingress hook.

Since the mirror flow is part of the same ct,
we can extract the meta data and update for the down link flow as well.

>> The goal was not to push Qualcomm out-of tree implementation, but to have a
>> solution using existing in-tree kernel mechanisms
>>     1. Avoids Duplication of the same coming at mac80211
>>     2. Reduces system complexity with centralization.
>>
>> Qualcomm offload mechanism can work with policy data base built at mac80211
>> also; however what we wanted to explore was avoiding non 802.11 network-wide
>> policy and classification decisions within mac80211. This helps prevent the
>> creation of a parallel policy framework and keeps mac80211 focused on Wi-Fi-
>> specific functionality and concepts.
> 
> While I do agree that avoiding duplication is useful, I believe in this case it comes at a cost that makes it seem like a bad trade-off to me.
> The main reason for that is the unhandled gaps and the extra overhead it introduces.
> 
> Gaps:
>  - mac80211 intra-AP forwarding not handled
>  - TC offload API not handled
>  - hw offload depends on abusing existing fields
> 
> Costs:
>  - mandatory conntrack
>  - mandatory extra packet filter table
>  - complexity of translating standard mandated behavior into nft rulesets, which do not always align well.
>  - extra subsystem dependency
> 
>>> Let me give you a specific example. On OpenWrt, Ethernet -> WLAN bridge hw flow
>>> acceleration works by having a user space daemon that replicates the bridge
>>> state, measures L2 flows via eBPF and programs no-sw tc-flower offload rules
>>> for L2 flows. On the MTK driver side, the offload core uses the programmed
>>> L2 rules to trigger actual hw forwarding. Only for routing/NAT flow offload
>>> does nftables get used. The kernel side is fully implemented in upstream
>>> kernels without any out-of- tree subsystems.
>>>
>>> The forwarding from Ethernet to WLAN works because the kernel code can
>>> resolve the hardware path via dev_fill_forward_path and query the relevant
>>> metadata (which happens by calling into the WLAN driver through mac80211).
>>>
>>
>> Thanks for the example.
>>
>> If both traffic types (bridged and routed) ultimately require policy
>> classification and offload decisions, having a common framework could provide
>> a single policy repository and a consistent programming model across all
>> forwarding paths.
>>
>> Referring to the following article, can nftables be considered for bridge
>> offload as well?
>>
>> https://lwn.net/Articles/1082320/
> 
> So you're saying we should force user space away from existing actively used offload APIs because they don't fit into your design?
> 

The goal is not to replace or discourage existing offload APIs.
The bridge offload solutions based on tc flower that you mentioned
can continue to be used where they already fit the deployment needs.
The point is that, for SCS/MSCS policy enforcement and offload,
using a common framework such as nftables across both bridged and routed traffic
may provide a single policy store and a consistent programming model.

This is not a requirement. Vendors can choose the approach that best fits their architecture and offload capabilities.
Some may continue using separate bridge and routing mechanisms, while others may prefer a unified framework.
Our proposed approach remains compatible with existing offload mechanisms for two reasons:
1. The egress path is already part of the transmit flow, where SCS policy matching can be performed
   and the resulting QoS state encoded in conntrack metadata.
2. Hardware offload continues to use the standard ndo offload APIs,
   allowing drivers to extract the required QoS information without introducing new offload interfaces.

Following are the high level view of the flows for pure SW, nft flowtable offload(Bridging/Routing/NAT)

1. Software Flow


                                                │
                                                │
                                                │
                                                │1. Packets of flow
                                                │
      ┌────────────┐  ┌────────────┐   ┌────────▼────────┐  2. Initial packet, set conmark
      │  ingress   │  │  forward   │   │     egress      │  Subsequent packets, skb->mark = conmark
      └────────────┘  └────────────┘   └────┬────────────┘
                                            │
                                            │                       netfilter
  ──────────────────────────────────────────┼────────────────────────────────────
                                            │                       mac80211
                                   ┌────────▼──────────┐                +
                                   │      mac80211     │          vendor driver
                                   └────────┬──────────┘
                                            │
                                   ┌────────▼──────────┐
                                   │   vendor driver   │
                                   └───────────────────┘
                                   3. Use skb mark data,
                                      program the HW descriptors



2. nft flowtable offload flow


                    │  1. flowtable rules created
                    │      (Bridged/Routed Flows)
                    │
              ┌─────▼──────┐
              │    nft     │
              └─────┬──────┘
       userspace    │
       ─────────────┼──────────────────────────────────────────────────────────────────────────────
       kernel       │
                    │                             │                            │
                    │                             │                            │
                    │                             │                            │
                    │                             │ 5. Flow state              │3. Inital packets of flow
  2. ndo_tc_setup   │                             │    CT ESTABLISHED          │
                    │       ┌────────────┐ ┌──────▼─────┐             ┌────────▼────────┐
                    │       │  ingress   │ │  forward   │             │   egress        │  4. Initial packet, set conmark
                    │       └────────────┘ └──────┬─────┘             └─────────────────┘
                    │                             │ 6. flow_block_cb
                    │                             │    (flow data)
                    │                             │
                    │                             │
                    │                             │
                    │                             │                                               netfilter
                  ──┼─────────────────────────────┼────────────────────────────────────────────────────────────
                    │                             │                                               mac80211
           ┌────────▼───────────┐       ┌─────────▼─────────┐                                         +
           │      mac80211      │       │   vendor driver   │                                   vendor driver
           └────────────────────┘       └───────────────────┘
                                         7. Use con mark QoS data
                                            program the HW


>>> In the series that I've built on top of this one (but not yet posted), the offload core driver can additionally query the classifier result for a flow
>>> at the point where it enables actual offloading (the trigger is PPS
>>> threshold exceeded). This works because mac80211 has the active
>>> classifiers, allowing the WLAN driver to provide them to the offload core
>>> driver.
>>>
>>
>> If possible, could you share the patches (or a draft branch) for the series
>> you mentioned?
>>
>> We would be interested in reviewing the end-to-end architecture and
>> understanding how it integrates with the existing tc and nftables offload
>> paths separately.
> 
> Will do. I need to post RFC v2 of this series first though.
> 
> Thanks,
> 
> - Felix

