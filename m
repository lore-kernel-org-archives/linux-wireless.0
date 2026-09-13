Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2A22DECC2
	for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 21:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334370; cv=none; b=OGoJ9CoZLadH1CXuopib1PHSoZMSqdbz+42ZqqMrZkE4Qtm0iUpJHji6eMyJabTEPSJbjUzyE09XW5FJX6PV8O3lt9AZdaVXgRbnC3njWuGu/5iTlx2Mv/+ppDX74wQgwDU8QZBddGTVvsg75NWNu9BCPL4X91qMVgs4pRV/Tzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334370; c=relaxed/simple;
	bh=3nuBIM2SibhVzl1ceby77Or94RdA0LXKHicoLt+ZEpY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=i7QSkyo6pIAsRR9OXDUi31YnHD0gELpcewBZ3f+JJeX0fMZHddXHBOtO5zVJyi1Os2re6VdE21GM3gRUw+u70xq79JEsyHiq8CV9ct7XOKrJ5P3YNHqXitNpr3xDUydCeURaApvnl6R1X5OmR5sk5iqWQrQk8l63hmfZs7kdj7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=oeLZFJ0G; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="oeLZFJ0G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
	Cc:To:Subject:From:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GAO4GHcpcwhtHIPHNaj+2jidGuYpfOndmSnoWSkegYo=; b=oeLZFJ0G9GM4WIoFDipLVGGLwD
	55smqjlipBorKc6pB4ZKYl+Lxwm/LuzAVdYFNa9pvjpwSZuIjPf2KRsjTonSxNVtozC29rdhrzeTo
	OdIzKoxLKNWH+twNqS0Lv8PdJSbmbljdFE7ZPoLYiaz+MNqtIpXVH8LFpp2Xgl5i9eIM=;
Received: from p54a43140.dip0.t-ipconnect.de ([84.164.49.64] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x5rba-003SUx-1h;
	Sun, 13 Sep 2026 23:19:18 +0200
Message-ID: <43012c2f-3623-4211-b2de-de53e39df2e9@nbd.name>
Date: Sun, 13 Sep 2026 23:19:18 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH 00/15] wifi: SCS and MSCS
To: Vivek Chettri <vchettri@qti.qualcomm.com>,
 Bhagavathi Perumal S <bhagavathi.pillai@oss.qualcomm.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
 "ripan.deuri@oss.qualcomm.com" <ripan.deuri@oss.qualcomm.com>,
 "vivek.chettri@oss.qualcomm.com" <vivek.chettri@oss.qualcomm.com>
References: <cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name>
 <4c3aee64-d289-4648-9520-edb6518b3d13@oss.qualcomm.com>
 <6ed64b95-57a3-42a2-9280-c98978382fa6@nbd.name>
 <CH0PR02MB8168357184D7A6354A24A338F1BC2@CH0PR02MB8168.namprd02.prod.outlook.com>
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
In-Reply-To: <CH0PR02MB8168357184D7A6354A24A338F1BC2@CH0PR02MB8168.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Vivek,

On 13.09.26 21:23, Vivek Chettri wrote:

> The preference for reusing existing packet-classification infrastructure is driven by the need to have a centralized policy management and policy framework that operates across both software and hardware-offloaded forwarding paths, rather than introducing a separate classifier within the WLAN stack.
> 
> 1. Centralized QoS and Policy Management
> 
>     A centralized policy management framework provides the following advantages:
> 
>     • A centralized policy database enables end-to-end QoS policy enforcement across
>       different forwarding paths, improving manageability and policy visibility
>       throughout the system.
> 
>     • SCS/MSCS policies represent only one source of policy management.
>       Administrators may also configure firewall, QoS, or other policies that must
>       coexist with negotiated WLAN policies.
> 
>     • Centralized policy management provides clear visibility into the interaction
>       between administrator-defined policies and dynamically negotiated SCS/MSCS
>       policies, making conflicts easier to detect and manage.
> 
>     • Implementing packet prioritization independently within mac80211 can introduce
>       policy conflicts or ambiguous precedence when administrator-defined QoS
>       policies overlap with SCS/MSCS-derived priorities.
> 
>     • A common policy framework helps ensure consistent behavior across software
>       forwarding, bridging, routing, and hardware-offloaded data paths.

I don't think any of this really conflicts with my proposal.
A full end-to-end policy framework seems out of scope for direct 
implementation in hostapd anyway, so it should be an external component. 
hostapd should allow deferring management and policy decisions of 
client-requested SCS/MSCS exchanges to external components anyway to 
support things like EasyMesh well.

Having this separation would help if you intend to push flow 
classification for things like wired upstream links, which hostapd 
should not worry about at all.

In such a scenario, a custom implementation could choose to omit passing 
full classifiers to mac80211.
That said, for most common use cases, including standalone APs and 
simpler EasyMesh implementations, I believe that using the mac80211 
support that I added is the right choice due to the lower complexity and 
overhead.

> 2. Policy Framework: Considerations and Challenges
> 
>     A policy framework should help ensure consistent behavior across software
>     forwarding, bridging, routing, and hardware-offloaded data paths.
> 
>     The policy framework can be realized using either nftables or tc-flower.
>     Both approaches provide a persistent and centralized repository for traffic
>     classification and policy enforcement, but differ in integration complexity,
>     feature scope, and deployment model.
> 
>     Common Capabilities: nftables and tc-flower
> 
>     • Both nftables and tc-flower maintain centralized rule databases for traffic
>       classification and policy enforcement.
> 
>     • For software-forwarded traffic, both solutions require flow lookups against
>       installed rules and therefore have broadly comparable classification
>       overhead.
> 
>     • Both mechanisms can serve as the policy enforcement layer for
>       SCS/MSCS-derived traffic policies.
> 
>     Advantages of nftables
> 
>     • nftables provides a unified framework for firewalling, traffic
>       classification, and QoS policy marking.
> 
>     • nftables can support both software and hardware-accelerated forwarding
>       paths and can be extended to additional offload scenarios with minimal
>       architectural changes.
> 
>     • Existing support for nftables-based policy handling in hostapd reduces
>       integration effort and leverages infrastructure that is already available
>       and upstream-ready.
> 
>       The implementation is done using libmnl, which avoids licensing
>       incompatibility between hostapd (BSD-3-Clause) and libnftnl (GPLv2).
>       This approach was also reviewed with Jouni.
> 
>     • Using nftables allows SCS/MSCS policies to be integrated into a broader,
>       system-wide policy framework rather than introducing a WLAN-specific
>       policy engine.
> 
>     • Using nftables can also facilitate scalability by allowing these rules to
>       be applied at software acceleration decision-making stages. For example,
>       the NFT rule can be cleanly integrated into NFT flow tables as well.
> 
>     Challenges with a tc-flower-based Approach
> 
>     • A tc-flower solution would require substantial additional implementation
>       for rule programming from hostapd.
> 
>     • tc-flower typically requires qdisc configuration (at a minimum, a clsact
>       pseudo qdisc) before classification rules can be installed and enforced.

Most of these points are very abstract and in my opinion gloss over a 
lot of implementation complexity. I'd argue that just because nftables 
is used to enable offloading in some setups doesn't mean that it handles 
the different policy aspects of SCS and especially MSCS well, or 
provides good ways to deal with runtime changes to existing flows.

I get the impression that your proposal is designed to handle the needs 
of a single Qualcomm implementation of an out-of-tree policy framework 
service well, while neglecting in-tree kernel offload mechanisms, as 
well as standalone AP implementations by pushing extra complexity there.

Let me give you a specific example. On OpenWrt, Ethernet -> WLAN bridge 
hw flow acceleration works by having a user space daemon that replicates 
the bridge state, measures L2 flows via eBPF and programs no-sw 
tc-flower offload rules for L2 flows.
On the MTK driver side, the offload core uses the programmed L2 rules to 
trigger actual hw forwarding.
Only for routing/NAT flow offload does nftables get used.
The kernel side is fully implemented in upstream kernels without any 
out-of-tree subsystems.

The forwarding from Ethernet to WLAN works because the kernel code can 
resolve the hardware path via dev_fill_forward_path and query the 
relevant metadata (which happens by calling into the WLAN driver through 
mac80211).

In the series that I've built on top of this one (but not yet posted), 
the offload core driver can additionally query the classifier result for 
a flow at the point where it enables actual offloading (the trigger is 
PPS threshold exceeded). This works because mac80211 has the active 
classifiers, allowing the WLAN driver to provide them to the offload 
core driver.

This design allows transparently respecting the SCS/MSCS classifier for 
hw offloaded flows regardless of which API was used to trigger offload 
(tc or nftables).
Additionally, the user space components handling the offload for both 
approches do not have to worry about SCS/MSCS in any way.

I don't see how your hostapd programmed nftables rules approach would 
handle the same properly.

> 3. Summary
> 
>     • The primary role of SCS/MSCS handling within the WLAN subsystem should be
>       to negotiate and manage QoS policies between the AP and STA.
> 
>     • Packet classification and policy enforcement should be delegated to a
>       centralized policy framework such as nftables, which is already designed
>       to manage system-wide traffic policies.
> 
>     • The WLAN driver remains responsible for mapping classified traffic to the
>       appropriate transmission priorities and ensuring the negotiated QoS
>       behavior is achieved across the data path.
> 
> Also, what is the plan for supporting repeaters and backend devices?

Not sure what you mean by backend devices. For repeaters I would use a 
software component (preferably outside of hostapd/wpa_supplicant but 
interacting with both), which acts as a repeater for SCS policies 
requested by local clients (pushing them to the upstream AP) and tells 
hostapd to install local descriptors where local classification is needed.
If you have concerns about specific scenarios, please describe them to me.

Thanks,

- Felix
