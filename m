Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00415505DA
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962145; cv=none; b=b3G+86zh863db2r6BFQE/OFuVwoiVU88T/1SNc5rF4AQB48vxiG0R71OOOKIhntm39otdtxFyqiPuRW0ykVyb6D/uT7IZgUcbwdRKXR5UHiQ7yLbcIsFLvRQV933rBL7Ts14EMpDH2gdNgUjCU3h4PbzUfQ8QtEZjmty/6mi2mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962145; c=relaxed/simple;
	bh=qGyhlmA+flVxZQA5A5OpsQWeUCTfP6VIRu2HhyqLlCs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n2p4Jy4C9VHW6Nkaxrb44/GndYSWEReWTV+w6VeJMm0O0L1YqMEhEQqdVqEqvjEVvzZS7mvgX9izxJzrKY5gf9SgL1/jDixHIFbx/KqR3d+WsbfY4Yf3oAEUjFunMDS0SUJLfvtFQBXlb2ySrzghAYK0WTM60BZPzZdp3tYTWtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=cRhSKRPV; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="cRhSKRPV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=iqPe4v206bzffNSIVaTX6sJSQ2G4U4ZlKKuE3M408aI=; b=cRhSKRPVM9gqZfCQjNR/HvvkdB
	YOq19ENvxEu8zUKC/NJcXnz48ZOFCVCCje60TvGwHsqCwUU40Z2W8/ZnM4iGpyZWJgAP+WhTkQdqD
	SB2RqlOwMbPKg72y0DUH1f17gLkBxP/0fQpDaRHS7BlpVBXJcwmmnX7ohry447PMYS+Y=;
Received: from p54a43140.dip0.t-ipconnect.de ([84.164.49.64] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x4Ilx-00GoZ4-3C;
	Wed, 09 Sep 2026 15:55:34 +0200
Message-ID: <6ed64b95-57a3-42a2-9280-c98978382fa6@nbd.name>
Date: Wed, 9 Sep 2026 15:55:33 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/15] wifi: SCS and MSCS
To: Bhagavathi Perumal S <bhagavathi.pillai@oss.qualcomm.com>,
 linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, ripan.deuri@oss.qualcomm.com,
 Vivek Chettri <vchettri@qti.qualcomm.com>
References: <cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name>
 <4c3aee64-d289-4648-9520-edb6518b3d13@oss.qualcomm.com>
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
In-Reply-To: <4c3aee64-d289-4648-9520-edb6518b3d13@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

thanks for your feedback. Comments below.

On 09.09.26 15:05, Bhagavathi Perumal S wrote:
> SCS and MSCS are primarily mechanisms for negotiating QoS treatment 
> between an AP and a STA. A negotiated policy consists of:
> 
> 1.a traffic classifier, such as the applicable TCLAS or flow parameters; and
> 
> 2.the QoS treatment to apply to matching traffic, such as the User 
> Priority/TID and, where applicable, other QoS characteristics.
> 
> The classifier and the QoS treatment should be considered separately 
> from the protocol state.

I'm not sure I agree. From my understanding of the standard, acceptance 
and lifetime of the classifier data and the QoS characteristics must be 
considered together. If applying characteristics fails, the full 
descriptor (including its classifier information) must be rejected.
Handling this together in one place seems beneficial.
> The protocol state needs to be maintained so that the AP can validate 
> requests, generate the appropriate responses,
> 
> handle updates and deletions, and associate the policy with the correct 
> STA and link.
> 
> For IP traffic, classification is based primarily on L3/L4 information— 
> for example, IPv4/IPv6 addresses, protocol, ports, DSCP, and related 
> flow attributes.
> 
> Linux already provides mature packet-classification mechanisms through 
> netfilter/nftables, conntrack, flow tables, and vendor-specific flow- 
> offload infrastructure.
> 
> These mechanisms can classify the traffic and attach the required QoS 
> information(TID or additional QoS attributes) for mac80211 and the 
> vendor driver to consume.
> 
> Therefore, the packet-classification implementation does not need to be 
> duplicated in mac80211.
> 
> mac80211 should not independently reimplement a second L3/L4 classifier 
> when the same classification can already be performed by the networking 
> stack or by an accelerated data path.

 From my perspective, it's not as simple as that. Re-implementation is 
perfectly acceptable if the part that's being re-implemented is not a 
good fit for the use case and if the end result is more functional and 
less complex.
I believe this to be the case here. Consider the following data points:

In my implementation, net/wireless/scs.c (which implements the full 
classifier) is 586 lines of code.
net/mac80211/scs.c, which handles glue for maintaining the data 
structures and the outer classifier call is less than 400 lines.

In the hostapd implementation from QSDK 14, the nft.c glue code alone 
(which is just one part of the classifier related code) is ~1350 lines.
robust_av.c (which is ~2060 lines) adds even more classifier related code.

With that in mind, reusing nft already seems significantly more complex 
than a narrowly scoped classifier implementation written specifically 
for SCS/MSCS.

> mac80211 may still need to own the wireless-specific policy state and 
> provide an interface for:
> 
>  1. installing, updating, and removing a negotiated SCS/MSCS policy;
>  2. associating the policy with a particular STA;
>  3. reporting whether the policy was accepted, rejected, or could not be
>     enforced; and
>  4. handling station disassociation, policy update, and teardown.
> 
> The actual packet matching can then remain in the existing packet- 
> classification infrastructure.
> 
> This avoids duplicating classifier logic in mac80211 and allows the same 
> policy to be used consistently for both software and accelerated paths.

So far the only working upstream acceleration path from Ethernet to WLAN 
is for MTK hardware. Having written (though not yet published) an 
implementation to handle SCS/MSCS for offloaded flows, I can tell you 
that it's much more straightforward to do this in the kernel based on my 
series. It allows handling both netfilter based flows (L3 routed) and L2 
bridge offloaded flows via tc-flower consistently in the same way.

Especially the L2 tc-flower offload case would be hard to handle with 
your nft based proposal in a way that handles runtime flow updates well.

> If CPU overhead is a concern, it should be evaluated using profiling 
> data. In particular, the evaluation should compare:
> 
>  1. classification with and without SCS/MSCS rules;
>  2. the first-packet/flow-learning cost;
>  3. the per-packet cost after flow establishment;
>  4. the number of active rules and stations; and
>  5. the effect of conntrack, nftables flow tables, and hardware offload.
>  6. For hardware-accelerated paths, the packet-classification framework
>     can notify or program the accelerator when a matching flow is learned.

Again, not as simple as that. There's inherent cost to using an 
implementation that uses dynamic dispatch and is written for a lot of 
different use cases, vs a static fixed-purpose classifier.

> This architecture keeps the protocol and wireless-specific policy 
> handling in the Wi-Fi stack
> 
> while reusing the existing Linux networking and flow-offload 
> infrastructure for L3/L4 classification.
> 
> It avoids duplicate classification logic and provides a clear path for 
> both software and hardware-accelerated data paths.
I don't see the clear path for the hardware-accelerated data path at 
all. Could you elaborate?

- Felix
