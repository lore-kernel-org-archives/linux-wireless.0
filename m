Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1EF4E9C10
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 12:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790684109; cv=none; b=O7Fq6+kqRVP+jD4b0Gf4ZtkylV3k5LwnbNpxrLoJKaNUFGP758rrqbbmcbWZeDOunwTP2zJIeXUXz/F5djkIPBiItFjxswaNZ8cC8AtbxfVwGcB8RnDNWq3z3M/DhGnZlP22+til5XbjQotztuNwu1ZtTgVjFUCYPCHReRRS1tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790684109; c=relaxed/simple;
	bh=SSYHkj8qKjCj2Se4vF5Xnbj9WEKB8bKIkSuGwF/bHQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eDRaDeS2AtyvB+N/UD2remMZIpGELhu83X2SniVQewvZ96Z8bVWd6vL25hrGCYM/ygV+oGlXOseIqzakZ42HrjcKDR4bcanuB4xtUr1ARYEBYl084I/283Gb/HqSTwobALnrNyI8PH2lwxHR7mpf0QU1m7x9TFuIB8Z6e6yXBP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=sykKvZZk; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="sykKvZZk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=vIzbWg9SkfDJJUsq6lZnHSzkk1u0FFkRtVQyJXwWoGA=; b=sykKvZZk0c5JAULO0+NY0/olmP
	cWSwWXdG+uPYubg+FzdwezQhM5onm8mG/IQWgYINGDNcIJhx1x8NdIDJ2/5TfH1+9uYhp+aw/AlAj
	YOuwCxjY+IsZ7RrkY0TvpAFpZZlOmkb55Oz3PENcUr8DkOMHUtYL2OpB5df92WYb6PNc=;
Received: from p54a434bb.dip0.t-ipconnect.de ([84.164.52.187] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xBWja-00CuOa-02;
	Tue, 29 Sep 2026 14:14:58 +0200
Message-ID: <085bd870-0ec1-4b92-bc99-dfbfe3c7132e@nbd.name>
Date: Tue, 29 Sep 2026 14:14:57 +0200
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
 <3132508e-3b02-41bb-8d93-28f30ef3a864@nbd.name>
 <5cd8adcf-2c52-49b0-802c-d995eaf8960f@oss.qualcomm.com>
From: Felix Fietkau <nbd@nbd.name>
Content-Language: en-US
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
In-Reply-To: <5cd8adcf-2c52-49b0-802c-d995eaf8960f@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Vivek,


On 26.09.26 07:07, Vivek Chettri wrote:
> On 9/22/2026 3:35 PM, Felix Fietkau wrote:
>> Hi Vivek,
>> 
>> On 20.09.26 18:22, Vivek Chettri wrote:
>> 
>>> The proposal is not to implement a full policy framework in hostapd.
>>>
>>> Following is the functionality split:
>>>
>>> Hostapd:
>>>     Primarily responsible for SCS/MSCS protocol handling.
>>>     Processing of the protocol descriptors ie TCLAS and QoS elements.
>>>     Programming an existing kernel policy framework such as nftable.
>>>
>>> Nftables:
>>>     Policy storage.
>>>     Classification.
>>>     Packet marking along with offload enablement.
>> 
>> I'm not sure that nftables is a good policy storage for SCS/MSCS.
>> In my proposal, all accepted SCS descriptors sent to mac80211 are enforced without direct policy override. That is by design, because it is expected by the standard.
>> If system policy contradicts SCS descriptors requested by the stations, that's fundamentally an admission problem that needs to be dealt with in user space before descriptors ever reach mac80211, so that the station is told what is accepted and what isn't.
>> 
> 
> We believe admission control can still be handled through a centralized policy database.
> Instead of always giving SCS/MSCS requests higher priority,
> administrators could choose whether SCS/MSCS policies or existing system policies take precedence.
> This provides flexibility for different deployments.
> When policy conflicts occur, the centralized policy layer can make an admission decision before enforcement,
> rather than automatically prioritizing SCS/MSCS requests.
> 
> Consider a deployment where a station successfully negotiates an SCS stream
> for a video application and the corresponding QoS policy is accepted and programmed.
> Later, an administrator updates the network policy to de prioritize or block that traffic class,
> for example due to congestion, bandwidth quotas, or enterprise policy requirements.
> 
> In a centralized policy model, the new administrative policy can be viewed and compared
> against the previously accepted SCS policy, the conflict can be detected.
> With the SCS policy in mac80211, the admin is not even aware of the policies.
> The SCS session can be re-evaluated or torn down as appropriate.
> This ensures that policy changes made after SCS admission can still be enforced consistently across the system.

That doesn't really make much sense to me. If SCS policy is accepted, 
then centralized policy changes that affect it must go through the user 
space component that deals with SCS admission.

Unilaterally dropping the classification policy based on centralized 
policy updates without also notifying the station by tearing down the 
SCS descriptor is a protocol violation. Also, if classification is torn 
down, any installed QoS characteristics belonging to the same descriptor 
must be removed as well.

Changes to SCS policy must be sent as unsolicited SCS response, e.g. 
with TCLAS_PROCESSING_TERMINATED_POLICY_CONFLICT.

I'd consider this an advantage of my design because the relevant SCS 
state is kept in one place without accidental partial drop due to 
external actions.

>>>>> 2. Policy Framework: Considerations and Challenges
>>>>>
>>>>> A policy framework should help ensure consistent behavior across software forwarding, bridging, routing, and hardware-offloaded data paths.
>>>>>
>>>>> The policy framework can be realized using either nftables or tc-flower. Both
>>>>> approaches provide a persistent and centralized repository for traffic classification and policy enforcement, but differ in integration complexity,
>>>>> feature scope, and deployment model.
>>>>>
>>>>> Common Capabilities: nftables and tc-flower
>>>>>
>>>>> • Both nftables and tc-flower maintain centralized rule databases for traffic
>>>>> classification and policy enforcement.
>>>>>
>>>>> • For software-forwarded traffic, both solutions require flow lookups against
>>>>> installed rules and therefore have broadly comparable classification overhead.
>>>>>
>>>>> • Both mechanisms can serve as the policy enforcement layer for SCS/MSCS-
>>>>> derived traffic policies.
>>>>>
>>>>> Advantages of nftables
>>>>>
>>>>> • nftables provides a unified framework for firewalling, traffic classification,
>>>>> and QoS policy marking.
>>>>>
>>>>> • nftables can support both software and hardware-accelerated forwarding paths
>>>>> and can be extended to additional offload scenarios with minimal architectural
>>>>> changes.
>>>>>
>>>>> • Existing support for nftables-based policy handling in hostapd reduces integration effort and leverages infrastructure that is already available and
>>>>> upstream-ready.
>>>>>
>>>>> The implementation is done using libmnl, which avoids licensing incompatibility
>>>>> between hostapd (BSD-3-Clause) and libnftnl (GPLv2). This approach was
>>>>> also reviewed with Jouni.
>>>>>
>>>>> • Using nftables allows SCS/MSCS policies to be integrated into a broader, system-wide policy framework rather than introducing a WLAN-specific policy
>>>>> engine.
>>>>>
>>>>> • Using nftables can also facilitate scalability by allowing these rules to
>>>>> be applied at software acceleration decision-making stages. For example, the
>>>>> NFT rule can be cleanly integrated into NFT flow tables as well.
>>>>>
>>>>> Challenges with a tc-flower-based Approach
>>>>>
>>>>> • A tc-flower solution would require substantial additional implementation for rule programming from hostapd.
>>>>>
>>>>> • tc-flower typically requires qdisc configuration (at a minimum, a clsact pseudo qdisc) before classification rules can be installed and enforced.
>>>>
>>>> Most of these points are very abstract and in my opinion gloss over a lot of
>>>> implementation complexity. I'd argue that just because nftables is used to enable
>>>> offloading in some setups doesn't mean that it handles the different policy
>>>> aspects of SCS and especially MSCS well, or provides good ways to deal with
>>>> runtime changes to existing flows.
>>>>
>>>
>>> I agree that implementation complexity and runtime updates are important
>>> considerations. For SCS/MSCS cases, nftables address the highlighted concerns
>>> in following ways
>>>
>>> Complexity: not a concern
>>>    - Linux Kernel NFT Infra provides well defined APIs to program policies
>>> which satisfies present use cases and does not add much implementation
>>> complexity or overhead.
>> 
>> You can claim that, but reading the QSDK implementation of the hostapd/nft integration code gives me the opposite impression.
>> 
> 
> While the implementation is not particularly complex,
> its size is largely driven by the need to implement wrapper APIs
> for programming nftables rules via Netlink messages.
> 
> Due to licensing constraints, libnftnl cannot be used directly with hostapd,
> requiring the use of libmnl and direct construction of Netfilter Netlink messages.
> 
> Much of the code therefore consists of standard message encoding and communication
> with existing nftables kernel interfaces rather than complex policy or algorithmic logic.

It's still a significant amount of code that we would not need in my 
approach.

>>> Runtime: supported
>>>   - These APIs indeed having support for runtime modifications as per SCS/MSCS
>>> protocol requirements.
>>>
>>> Offload cases: supported seamlessly
>>>   - nftables is already used as a general policy and classification framework
>>> for both software-forwarded and software/hardware-offloaded traffic.
>>>
>>> Protocol classifiers: all mandatory variations supported
>>>   - The classifiers required mandatorily by SCS/MSCS, including cases such as
>>> TCLAS Type 10 (ESP/SPI Based rules), are supported with nftables.
>> 
>> One aspect this ignores is intra-AP forwarding handled by mac80211.
>> 
> 
> This should not be a major concern.
> In such scenarios, traffic can be forwarded via the bridge using hairpin mode,
> 
> In addition, upcoming peer-isolation support introduces per-peer controls for intra-AP forwarding,
> either at the mac80211 or bridge layer.
> This would allow SCS/MSCS clients to be configured to use bridge-based hairpin forwarding
> and for other clients we can still do forwarding from mac80211.
> 
> As a result, intra-AP forwarding does not fundamentally alter the architectural considerations discussed here.
> 
> The same policy classification, storage, and forwarding mechanisms
> can continue to be applied through the common policy framework,
> while keeping network-wide policy decisions outside of mac80211.

So you plan to make hostapd selectively switch clients using SCS or MSCS 
over to bridge hairpin by configuring peer specific isolation and 
hairpin mode? A bit cumbersome, but I guess it could work.
>>>> I get the impression that your proposal is designed to handle the needs of a
>>>> single Qualcomm implementation of an out-of-tree policy framework service well,
>>>> while neglecting in-tree kernel offload mechanisms, as well as standalone
>>>> AP implementations by pushing extra complexity there.
>>>>
>>>
>>> The nft based proposal is neither Qualcomm-specific nor based on out-of-tree
>>> policy framework.
>>>
>>> Qualcomm's approach using nftables works for systems with no offload, software
>>> offload, or hardware offload by leveraging existing upstream infrastructure as
>>> follows.
>>>
>>>     1. SCS policies programmed by hostapd are part of the net filter egress hook
>>> which maintains classifier info along with QoS identifier (nfttable rule->mark).
>>>
>>>     2. Mark field part of the nftable gets populated into connmark of the ct
>>> during connection establishment.
>>>
>>>     3. The connmark information that is populated at the egress hook can be used
>>> for HW offload programming by the vendor driver
>> 
>> Having the driver make DSCP tagging decisions based on connmark seems like a band-aid hack to me. connmark can be used by the user for multiple purposes, including policy related decisions.
>> Relying on it in the driver for a specific purpose seems like a bad idea to me.
> 
> We understand the concern that connmark is a generic field and may be used for other policy decisions.
> However, using conntrack marks for QoS-related state is already an established pattern in the kernel networking stack.
> 
> The NET_ACT_CTINFO documentation explicitly states:
> 
> ▎ "Current actions transfer connmark stored DSCP into ipv4/v6 diffserv and/or to transfer connmark to packet mark.
> Both are useful for restoring egress based marks back onto ingress connections for qdisc priority mapping purposes."
> 
> This is further reinforced by the upstream commit introducing act_ctinfo (Kevin Darbyshire-Bryant, 2019),
> which explains the motivation directly:
> 
> ▎ "Ingress classification is traditionally a challenging task since iptables rules haven't yet run
> and tc filter/eBPF programs are pre-NAT lookups...
> Thus marking the connection in some manner on egress for later restoration of classification on ingress is easier to implement."
> 
> This indicates that carrying QoS classification information in conntrack state,
> and consuming it later for QoS-related decisions, is already an intended and documented use case within the kernel.
> Importantly, our proposal does not have the driver read connmark directly.
> The connmark → skb->mark translation is performed by an explicit, nftables rule. The driver only consumes skb->mark.
> Therefore, the proposal is not introducing a new semantic for connmark,
> but leveraging a mechanism that is already used for QoS-related classification and priority handling.

Having this mapping as an explicit action is not the same as introducing 
it as a private contract between one particular driver and the system 
configuration. An important goal of offloads in the Linux network stack 
is to stay as close as possible to the software configuration mechanisms 
of the Linux user space network API.
In my opinion, adding magic reinterpretation of generic fields by the 
driver violates that principle.

How does driver consuming skb->mark even work in the SCS case? Which 
driver would consume it?
For packets flowing from ethernet to WLAN, does that mean you intercept 
packets in ath12k tx and read skb->mark there in order to update the UP?

Either way, abusing connmark for SCS means you can't use connmark 
elsewhere for policy decisions on flows that might hit WLAN.
Another gotcha for administrators to be aware of.
>>>     4. As the SCS policies are added at egress hook this would seamlessly work
>>> even when software offload(nft flow table) is enabled
>>>
>>> SCS/MSCS would simply act as a policy producer, while classification and
>>> enforcement remain within common in-tree mechanisms.
>> 
>> I also don't see how nft handles MSCS well. It learns per flow from the TID of received uplink frames, with a per station classifier mask, UP bitmap, UP limit, entry timeout and entry limit. How does a dynamic nft set expresses "record the UP of this uplink flow under this station's mask, expire it after this station's timeout, cap it at this station's limit".
> 
> Our proposal for MSCS is that mac80211 parses the uplink priority for a client with active
> MSCS session, it updates the skb->mark which then updates the conmark in the ingress hook.
> 
> Since the mirror flow is part of the same ct,
> we can extract the meta data and update for the down link flow as well.

Updating skb->mark from mac80211 based on UP does not make much sense to 
me, because it's yet another abuse of a generic field for a specific 
purpose.
>>> The goal was not to push Qualcomm out-of tree implementation, but to have a
>>> solution using existing in-tree kernel mechanisms
>>>     1. Avoids Duplication of the same coming at mac80211
>>>     2. Reduces system complexity with centralization.
>>>
>>> Qualcomm offload mechanism can work with policy data base built at mac80211
>>> also; however what we wanted to explore was avoiding non 802.11 network-wide
>>> policy and classification decisions within mac80211. This helps prevent the
>>> creation of a parallel policy framework and keeps mac80211 focused on Wi-Fi-
>>> specific functionality and concepts.
>> 
>> While I do agree that avoiding duplication is useful, I believe in this case it comes at a cost that makes it seem like a bad trade-off to me.
>> The main reason for that is the unhandled gaps and the extra overhead it introduces.
>> 
>> Gaps:
>>  - mac80211 intra-AP forwarding not handled
>>  - TC offload API not handled
>>  - hw offload depends on abusing existing fields
>> 
>> Costs:
>>  - mandatory conntrack
>>  - mandatory extra packet filter table
>>  - complexity of translating standard mandated behavior into nft rulesets, which do not always align well.
>>  - extra subsystem dependency
>> 
>>>> Let me give you a specific example. On OpenWrt, Ethernet -> WLAN bridge hw flow
>>>> acceleration works by having a user space daemon that replicates the bridge
>>>> state, measures L2 flows via eBPF and programs no-sw tc-flower offload rules
>>>> for L2 flows. On the MTK driver side, the offload core uses the programmed
>>>> L2 rules to trigger actual hw forwarding. Only for routing/NAT flow offload
>>>> does nftables get used. The kernel side is fully implemented in upstream
>>>> kernels without any out-of- tree subsystems.
>>>>
>>>> The forwarding from Ethernet to WLAN works because the kernel code can
>>>> resolve the hardware path via dev_fill_forward_path and query the relevant
>>>> metadata (which happens by calling into the WLAN driver through mac80211).
>>>>
>>>
>>> Thanks for the example.
>>>
>>> If both traffic types (bridged and routed) ultimately require policy
>>> classification and offload decisions, having a common framework could provide
>>> a single policy repository and a consistent programming model across all
>>> forwarding paths.
>>>
>>> Referring to the following article, can nftables be considered for bridge
>>> offload as well?
>>>
>>> https://lwn.net/Articles/1082320/
>> 
>> So you're saying we should force user space away from existing actively used offload APIs because they don't fit into your design?
>> 
> 
> The goal is not to replace or discourage existing offload APIs.
> The bridge offload solutions based on tc flower that you mentioned
> can continue to be used where they already fit the deployment needs.
> The point is that, for SCS/MSCS policy enforcement and offload,
> using a common framework such as nftables across both bridged and routed traffic
> may provide a single policy store and a consistent programming model.
> 
> This is not a requirement. Vendors can choose the approach that best fits their architecture and offload capabilities.
> Some may continue using separate bridge and routing mechanisms, while others may prefer a unified framework.
> Our proposed approach remains compatible with existing offload mechanisms for two reasons:
> 1. The egress path is already part of the transmit flow, where SCS policy matching can be performed
>     and the resulting QoS state encoded in conntrack metadata.
> 2. Hardware offload continues to use the standard ndo offload APIs,
>     allowing drivers to extract the required QoS information without introducing new offload interfaces.
> 
> Following are the high level view of the flows for pure SW, nft flowtable offload(Bridging/Routing/NAT)
> 
> 1. Software Flow
> 
> 
>                                                  │
>                                                  │
>                                                  │
>                                                  │1. Packets of flow
>                                                  │
>        ┌────────────┐  ┌────────────┐   ┌────────▼────────┐  2. Initial packet, set conmark
>        │  ingress   │  │  forward   │   │     egress      │  Subsequent packets, skb->mark = conmark
>        └────────────┘  └────────────┘   └────┬────────────┘
>                                              │
>                                              │                       netfilter
>    ──────────────────────────────────────────┼────────────────────────────────────
>                                              │                       mac80211
>                                     ┌────────▼──────────┐                +
>                                     │      mac80211     │          vendor driver
>                                     └────────┬──────────┘
>                                              │
>                                     ┌────────▼──────────┐
>                                     │   vendor driver   │
>                                     └───────────────────┘
>                                     3. Use skb mark data,
>                                        program the HW descriptors
> 
> 
> 
> 2. nft flowtable offload flow
> 
> 
>                      │  1. flowtable rules created
>                      │      (Bridged/Routed Flows)
>                      │
>                ┌─────▼──────┐
>                │    nft     │
>                └─────┬──────┘
>         userspace    │
>         ─────────────┼──────────────────────────────────────────────────────────────────────────────
>         kernel       │
>                      │                             │                            │
>                      │                             │                            │
>                      │                             │                            │
>                      │                             │ 5. Flow state              │3. Inital packets of flow
>    2. ndo_tc_setup   │                             │    CT ESTABLISHED          │
>                      │       ┌────────────┐ ┌──────▼─────┐             ┌────────▼────────┐
>                      │       │  ingress   │ │  forward   │             │   egress        │  4. Initial packet, set conmark
>                      │       └────────────┘ └──────┬─────┘             └─────────────────┘
>                      │                             │ 6. flow_block_cb
>                      │                             │    (flow data)
>                      │                             │
>                      │                             │
>                      │                             │
>                      │                             │                                               netfilter
>                    ──┼─────────────────────────────┼────────────────────────────────────────────────────────────
>                      │                             │                                               mac80211
>             ┌────────▼───────────┐       ┌─────────▼─────────┐                                         +
>             │      mac80211      │       │   vendor driver   │                                   vendor driver
>             └────────────────────┘       └───────────────────┘
>                                           7. Use con mark QoS data
>                                              program the HW
> 
This setup flow is not compatible with the L2 offload rules programmed 
by bridger. bridger programs offload rules based on MAC address tuples. 
The hardware flow table uses them to trigger hw offloading of recognized 
L4 tuples. It considers both directions separately.

When it's time to offload a flow based on a packet flowing from ethernet 
to wireless, the hw offload engine needs to know the tag that shall be 
applied after forwarding. How would this even work in your approach?

In my approach, I deal with this issue by allowing the driver to query 
the output tag through callbacks at offload bind time, as well as 
reacting to SCS descriptor changes for existing flows (through the 
unbind trigger).

That makes it completely independent of nft vs tc-flower created flows, 
or even L2 vs L4 offload rules.

I don't see anything in your approach that could support this without 
forcing users to create flow offload rules through nft instead of tc.
If you do, please let me know and describe the exact chain of events.

- Felix
