Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E680D503BC4
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071551; cv=none; b=u0dH2KKtjOKYrgZ5Ie1ZSszynxIxzVAag7B/GEEVapaE31wBXF7MVLYTLs+a6g3apVm48/xy77IJdsSlK4wE+XanULeigHU0eygi+EpCL2PaYaDE7QbC3COtOfkzdp2MtwI6gV4hFXKHMs7PSg2Pc6eS2IOZD6D9DV2ZTzmJHY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071551; c=relaxed/simple;
	bh=lfYXlOjspeUsVo/fiWL7xluekV/cyPZrJ3E8ZlwwFdg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A5ZAtmtJVlumGBlnFGpPvzv58MsqVUg7PCaAG6Dyez8J1SD/ZSbx0Fa+kgzJXyMwa/myrR5FIIjiNuIsxMTGpaw2Bpy+bU/1dq42uMlPsGcrL+IeX9+FLjQSI+lemKIpe8E9D2xYzBcMCJbxCJ1CjvVa7JcwW2cWKyNwyZLH77Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=f7SDDLKu; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="f7SDDLKu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=V8h/iRRACCxS7zqP93bwH9XY4S6Sul46FEPJsyx8xWE=; b=f7SDDLKu60N6lxBWibZz5UudDg
	pcXbWqNN859f0qCJlxqT7bTWnqS0tjmiIL2qP4L6WMDsgkNrj5D947ctntv+gI90Z7VjhXTRtE6AZ
	Fo0uGo7ngQfvyOQo/htYRjj/AJpnw7FLQlWPWuGq5+5Tz+u8rM31RbjZ0iYsI+Qc4mNg=;
Received: from p54a434bb.dip0.t-ipconnect.de ([84.164.52.187] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xNY-007zqa-1Z;
	Tue, 22 Sep 2026 12:05:36 +0200
Message-ID: <3132508e-3b02-41bb-8d93-28f30ef3a864@nbd.name>
Date: Tue, 22 Sep 2026 12:05:35 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/15] wifi: SCS and MSCS
To: Vivek Chettri <vivek.chettri@oss.qualcomm.com>,
 Vivek Chettri <vchettri@qti.qualcomm.com>,
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
Content-Language: en-US
From: Felix Fietkau <nbd@nbd.name>
Autocrypt: addr=nbd@nbd.name; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCeMncXpbbWNT2AtoAYICrKyX5R3iMAoMhw
 cL98efvrjdstUfTCP2pfetyN
In-Reply-To: <d5cd9c2b-a37a-40be-8916-162d9250adce@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Vivek,

On 20.09.26 18:22, Vivek Chettri wrote:

> The proposal is not to implement a full policy framework in hostapd.
> 
> Following is the functionality split:
> 
> Hostapd:
> 	Primarily responsible for SCS/MSCS protocol handling.
> 	Processing of the protocol descriptors ie TCLAS and QoS elements.
> 	Programming an existing kernel policy framework such as nftable.
> 
> Nftables:
> 	Policy storage.
> 	Classification.
> 	Packet marking along with offload enablement.

I'm not sure that nftables is a good policy storage for SCS/MSCS.
In my proposal, all accepted SCS descriptors sent to mac80211 are 
enforced without direct policy override. That is by design, because it 
is expected by the standard.
If system policy contradicts SCS descriptors requested by the stations, 
that's fundamentally an admission problem that needs to be dealt with in 
user space before descriptors ever reach mac80211, so that the station 
is told what is accepted and what isn't.

>>> 2. Policy Framework: Considerations and Challenges
>>> 
>>> A policy framework should help ensure consistent behavior across software 
>>> forwarding, bridging, routing, and hardware-offloaded data paths.
>>> 
>>> The policy framework can be realized using either nftables or tc-flower. Both
>>> approaches provide a persistent and centralized repository for traffic 
>>> classification and policy enforcement, but differ in integration complexity,
>>> feature scope, and deployment model.
>>> 
>>> Common Capabilities: nftables and tc-flower
>>> 
>>> • Both nftables and tc-flower maintain centralized rule databases for traffic
>>> classification and policy enforcement.
>>> 
>>> • For software-forwarded traffic, both solutions require flow lookups against
>>> installed rules and therefore have broadly comparable classification overhead.
>>> 
>>> • Both mechanisms can serve as the policy enforcement layer for SCS/MSCS-
>>> derived traffic policies.
>>> 
>>> Advantages of nftables
>>> 
>>> • nftables provides a unified framework for firewalling, traffic classification,
>>> and QoS policy marking.
>>> 
>>> • nftables can support both software and hardware-accelerated forwarding paths
>>> and can be extended to additional offload scenarios with minimal architectural
>>> changes.
>>> 
>>> • Existing support for nftables-based policy handling in hostapd reduces 
>>> integration effort and leverages infrastructure that is already available and
>>> upstream-ready.
>>> 
>>> The implementation is done using libmnl, which avoids licensing incompatibility
>>> between hostapd (BSD-3-Clause) and libnftnl (GPLv2). This approach was
>>> also reviewed with Jouni.
>>> 
>>> • Using nftables allows SCS/MSCS policies to be integrated into a broader, 
>>> system-wide policy framework rather than introducing a WLAN-specific policy
>>> engine.
>>> 
>>> • Using nftables can also facilitate scalability by allowing these rules to
>>> be applied at software acceleration decision-making stages. For example, the
>>> NFT rule can be cleanly integrated into NFT flow tables as well.
>>> 
>>> Challenges with a tc-flower-based Approach
>>> 
>>> • A tc-flower solution would require substantial additional implementation 
>>> for rule programming from hostapd.
>>> 
>>> • tc-flower typically requires qdisc configuration (at a minimum, a clsact 
>>> pseudo qdisc) before classification rules can be installed and enforced.
>> 
>> Most of these points are very abstract and in my opinion gloss over a lot of
>> implementation complexity. I'd argue that just because nftables is used to enable
>> offloading in some setups doesn't mean that it handles the different policy
>> aspects of SCS and especially MSCS well, or provides good ways to deal with
>> runtime changes to existing flows.
>> 
> 
> I agree that implementation complexity and runtime updates are important
> considerations. For SCS/MSCS cases, nftables address the highlighted concerns
> in following ways
> 
> Complexity: not a concern
>    - Linux Kernel NFT Infra provides well defined APIs to program policies
> which satisfies present use cases and does not add much implementation
> complexity or overhead.

You can claim that, but reading the QSDK implementation of the 
hostapd/nft integration code gives me the opposite impression.

> Runtime: supported
>   - These APIs indeed having support for runtime modifications as per SCS/MSCS
> protocol requirements.
> 
> Offload cases: supported seamlessly
>   - nftables is already used as a general policy and classification framework
> for both software-forwarded and software/hardware-offloaded traffic.
> 
> Protocol classifiers: all mandatory variations supported
>   - The classifiers required mandatorily by SCS/MSCS, including cases such as
> TCLAS Type 10 (ESP/SPI Based rules), are supported with nftables.

One aspect this ignores is intra-AP forwarding handled by mac80211.

>> I get the impression that your proposal is designed to handle the needs of a
>> single Qualcomm implementation of an out-of-tree policy framework service well,
>> while neglecting in-tree kernel offload mechanisms, as well as standalone
>> AP implementations by pushing extra complexity there.
>> 
> 
> The nft based proposal is neither Qualcomm-specific nor based on out-of-tree
> policy framework.
> 
> Qualcomm's approach using nftables works for systems with no offload, software
> offload, or hardware offload by leveraging existing upstream infrastructure as
> follows.
> 
> 	1. SCS policies programmed by hostapd are part of the net filter egress hook
> which maintains classifier info along with QoS identifier (nfttable rule->mark).
> 
> 	2. Mark field part of the nftable gets populated into connmark of the ct
> during connection establishment.
> 
> 	3. The connmark information that is populated at the egress hook can be used
> for HW offload programming by the vendor driver

Having the driver make DSCP tagging decisions based on connmark seems 
like a band-aid hack to me. connmark can be used by the user for 
multiple purposes, including policy related decisions.
Relying on it in the driver for a specific purpose seems like a bad idea 
to me.
> 	4. As the SCS policies are added at egress hook this would seamlessly work
> even when software offload(nft flow table) is enabled
> 
> SCS/MSCS would simply act as a policy producer, while classification and
> enforcement remain within common in-tree mechanisms.

I also don't see how nft handles MSCS well. It learns per flow from the 
TID of received uplink frames, with a per station classifier mask, UP 
bitmap, UP limit, entry timeout and entry limit. How does a dynamic nft 
set expresses "record the UP of this uplink flow under this station's 
mask, expire it after this station's timeout, cap it at this station's 
limit".
> The goal was not to push Qualcomm out-of tree implementation, but to have a
> solution using existing in-tree kernel mechanisms
> 	1. Avoids Duplication of the same coming at mac80211
> 	2. Reduces system complexity with centralization.
> 
> Qualcomm offload mechanism can work with policy data base built at mac80211
> also; however what we wanted to explore was avoiding non 802.11 network-wide
> policy and classification decisions within mac80211. This helps prevent the
> creation of a parallel policy framework and keeps mac80211 focused on Wi-Fi-
> specific functionality and concepts.

While I do agree that avoiding duplication is useful, I believe in this 
case it comes at a cost that makes it seem like a bad trade-off to me.
The main reason for that is the unhandled gaps and the extra overhead it 
introduces.

Gaps:
  - mac80211 intra-AP forwarding not handled
  - TC offload API not handled
  - hw offload depends on abusing existing fields

Costs:
  - mandatory conntrack
  - mandatory extra packet filter table
  - complexity of translating standard mandated behavior into nft 
rulesets, which do not always align well.
  - extra subsystem dependency

>> Let me give you a specific example. On OpenWrt, Ethernet -> WLAN bridge hw flow
>> acceleration works by having a user space daemon that replicates the bridge
>> state, measures L2 flows via eBPF and programs no-sw tc-flower offload rules
>> for L2 flows. On the MTK driver side, the offload core uses the programmed
>> L2 rules to trigger actual hw forwarding. Only for routing/NAT flow offload
>> does nftables get used. The kernel side is fully implemented in upstream
>> kernels without any out-of- tree subsystems.
>> 
>> The forwarding from Ethernet to WLAN works because the kernel code can
>> resolve the hardware path via dev_fill_forward_path and query the relevant
>> metadata (which happens by calling into the WLAN driver through mac80211).
>> 
> 
> Thanks for the example.
> 
> If both traffic types (bridged and routed) ultimately require policy
> classification and offload decisions, having a common framework could provide
> a single policy repository and a consistent programming model across all
> forwarding paths.
> 
> Referring to the following article, can nftables be considered for bridge
> offload as well?
> 
> https://lwn.net/Articles/1082320/

So you're saying we should force user space away from existing actively 
used offload APIs because they don't fit into your design?

>> In the series that I've built on top of this one (but not yet posted), the 
>> offload core driver can additionally query the classifier result for a flow
>> at the point where it enables actual offloading (the trigger is PPS
>> threshold exceeded). This works because mac80211 has the active
>> classifiers, allowing the WLAN driver to provide them to the offload core
>> driver.
>> 
> 
> If possible, could you share the patches (or a draft branch) for the series
> you mentioned?
> 
> We would be interested in reviewing the end-to-end architecture and
> understanding how it integrates with the existing tc and nftables offload
> paths separately.

Will do. I need to post RFC v2 of this series first though.

Thanks,

- Felix
