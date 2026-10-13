Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1375F5349D4
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 19:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791921406; cv=none; b=n0f1XcOpyq8jG64d1NezcPe0aUfa3zldMv5ZdGtp/Aj9zAoopb0TagKk8lJazen/BQi3nQ28F62nxAyLRa0iwmguYYtwOVYwW0QOJHUmvIsP3D6hv4QNhIyhRlqxsqAkbx0rXLnbf2PmIBrPHhVLa6HbcZpHY1bquEkkfudxuuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791921406; c=relaxed/simple;
	bh=dMDMlbXTiTsufEwrytq6GBKghuKIDzuN3nsSaJH6yn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cHjzcL+dXMrZMjX2OGJDhbsAGJyYzB3b+rlP0fbcY+fivB+XBtyPxnVmZ5sIdrk3Rl6ghdRfA+OmXgCmo20BqqKdEyADk55TAOj1y+RJvbm6xhgr8caYs5lo/aNuUTM195qPxf/sdaprQXl1JUcSN9OS805zJDSWPT1vnzNirj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Ms3haL+I; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Ms3haL+I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=irARKbPJfTFDIICcEiMzMKc+WL14ee2QnV9CKBTrswU=; b=Ms3haL+IP/Xf9FYZt8D+nU9zC3
	yAnmx3LP6oCN2j+Ep3ns2ttlgaa7eHUsyu6WlHn3MlMEYNwBhlqfjsEjpeUuzUFJC+UndMszDqzNW
	3CvGkDHKVlFLFEw1ih5apDTJ827e7U0K3+n38jfIZVY1NBxglm3Onhc7oXiw7F4P2cyg=;
Received: from p54a434bb.dip0.t-ipconnect.de ([84.164.52.187] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xGibz-003nPC-0x;
	Tue, 13 Oct 2026 21:56:35 +0200
Message-ID: <ec490ae3-e37a-418a-b1a5-b5b76bafaa9e@nbd.name>
Date: Tue, 13 Oct 2026 21:56:34 +0200
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
 <085bd870-0ec1-4b92-bc99-dfbfe3c7132e@nbd.name>
 <eedb870e-16ce-4f43-af9b-764fa81ae04b@oss.qualcomm.com>
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
In-Reply-To: <eedb870e-16ce-4f43-af9b-764fa81ae04b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Vivek,

On 13.10.26 21:04, Vivek Chettri wrote:
> We agree that any policy conflict must be handled in a protocol-compliant manner
> and should not result in a silent or partial removal of established state.
> 
> In the proposed model, policy conflicts are detected by the centralized policy layer in
> user space. When an administrative policy update conflicts with an active SCS session,
> user space is expected to re-evaluate the affected session and initiate the appropriate
> tear down procedure through the SCS control path.
> 
> If the negotiated SCS policy can no longer be honored, user space would issue an
> unsolicited SCS response with TCLAS_PROCESSING_TERMINATED_POLICY_CONFLICT to
> notify the STA that the previously accepted SCS session is being terminated due
> to a policy conflict. As part of the same operation, any classification state and
> QoS characteristics associated with the affected SCS descriptor would also be removed.
> 
> The intent is therefore not to unilaterally drop classification policies, but to ensure
> coordinated tear down of the SCS session and all related enforcement state,
> keeping SCS state, policy state, and QoS enforcement synchronized throughout the session
> lifecycle.
> 
> One area where a centralized policy model may also provide value is conflict detection
> and policy prioritization. Since both administratively configured policies and
> SCS/MSCS-derived policies are visible within the same policy repository, conflicts can
> be detected and resolved according to deployment-specific policy precedence rules before
> enforcement occurs.
> 
> In the context of the proposed mac80211-centric approach, it is not entirely clear to us
> how conflicts between existing system policies and previously accepted SCS policies
> are detected, how policy precedence is determined, and which component is responsible
> initiating the required SCS session tear down when such conflicts arise.
> Additional clarification on this aspect would be helpful.

All of this needs to be done in user space anyway and is completely 
orthogonal to where the classifier is executed. If you have a system 
policy framework that provides constraints for what SCS policy can be 
accepted, it needs to run in a different layer than where the SCS 
classifier lives anyway.

Ideally it should be completely unconstrained by whatever intermediate 
format is chosen for the classifier ruleset (nftables rules or mac80211 
tracked SCS descriptors).

Such a policy framework should (in my opinion) also not be forced onto 
deployments that don't need it.

 From my perspective, there should be two modes:

a) no policy framework is present
In this case, hostapd accepts SCS descriptors from clients, validates 
them and pushes the accepted ones to mac80211 as-is. SCS state is tied 
to client state and cleaned up as such.

b) system wide policy framework is present
In this case, hostapd parses SCS descriptors and communicates with a 
policy manager process through a defined IPC API, installs only 
descriptors into mac80211 that are accepted by the policy manager, and 
later removes those that the policy manager indicates as conflicting 
with system policy. In that case, the policy manager has full control, 
can consider the non-wireless side as well. At the same time, its 
implementation is not baked into hostapd, there can be multiple 
different implementations that serve different needs, and they are not 
forced onto simple single-AP setups that wish to use SCS/MSCS.

>> That makes it completely independent of nft vs tc-flower created flows, or even L2 vs L4 offload rules.
>> 
>> I don't see anything in your approach that could support this without forcing users to create flow offload rules through nft instead of tc.
>> If you do, please let me know and describe the exact chain of events.
>> 
>> - Felix
> 
> For the L2 bridge flow hw offload case, there is an active upstream series gaining traction:
> 
> https://lore.kernel.org/netfilter-devel/20260708093250.1187068-1-pablo@netfilter.org/T/#mb9581ceac031c8222db29af384f9fbbdfa9cc2a8
> 
> This series adds native L2 bridge offload to nf_flowtable using nf_conntrack_bridge.
> The kernel community appears to be converging on native bridge offload through nf_flowtable and nf_conntrack_bridge
> as the standard mechanism.
> 
> Our nftables/connmark-based classification approach aligns naturally with this direction.
> 
> For offload designs that do not rely on kernel connection tracking
> (e.g., MediaTek eth-to-WLAN flows via bridger), the connmark can still be retrieved
> through the standard netfilter API using the 5-tuple from the flow.

That again assumes that the user is forced change the configuration to 
push bridged traffic through netfilter. This adds visible extra CPU 
overhead (through netfilter table processing and conntrack) in cases 
where you have a mix of offloaded and non-offloaded traffic.
Currently hw offload can work with upstream kernels without netfilter by 
using the tc API with L2 offload entries.
> Regarding your ethernet patches: we notice that a non-WLAN module calls
> ieee80211_sta_flow_prio() directly to perform policy matching.
> This introduces a direct cross-subsystem dependency where offload drivers
> outside mac80211 must call into mac80211 APIs.
No, the call to ieee80211_sta_flow_prio comes from mt76.

To give you some more context: there is a mt76 part which attaches to 
the WED (wireless ethernet dispatch) device. WED is the hardware glue 
that handles forwarding between the WLAN device and the ethernet subsystem.

When transitioning a flow from unbind to bind (= enabling offload), the 
ethernet subsystem already gets the index of the WED device from 
ndo_fill_forward_path. Using that to look up the struct (which it 
already has a pointer to), it can call into callbacks provided by the 
WLAN driver.
Indirect calls from ethernet to wireless are already required for 
offload anyway, since wireless specific metadata is needed in the hw 
offload entry.

Thanks,

- Felix
