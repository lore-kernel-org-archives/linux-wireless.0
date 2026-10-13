Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C821485944
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 19:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791918288; cv=none; b=Kn/rfdIJzUhzRz2V6q6o7fslusw9vPQ8dSh+H42EN+Yp9VUP+JyzRqm6z2KJjkburR8cS3lduHcqU7UK+gq1G9cC0zjeGFxnTgAad5XTS0KVxhMWGIs/1Vx34q3q+8Wf834UhUva1TLPjkWTxetexWGezi0XkETMSaDPJYqFuVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791918288; c=relaxed/simple;
	bh=4Cgr51UFCVWtdQBae5zghvpcCJ8qLuqYqparbPX+/tU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QMChxhDaMGT5dQWUA5nz8kXEn4x/FhEqZAjbdm1yQ3Azuoc1fWU+E1ui5APpBDAPdES7pKgkrHAfgYZkc3wxJOgqsqRVIO52cYGrYO3aCq9o44QlcoSI/CFm/zRhkp270O7jaKgaMeJy3NHFn4rm5go8MO0x681te3uYcofVCM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZT2145JI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FsliZG+b; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZT2145JI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FsliZG+b"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69DEq9Hl1404263
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 19:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	E6tTAr/QFwZtf53OiSJyqnMPDpZC+/sRmc2/eZIOuWY=; b=ZT2145JINW8z3nYf
	jbk108NNf2YoI4BO8HWMm5j3SteBkGWpoGceqwfSJFZLki236jX3xehe+xxWBtKb
	++GJ3MDtgmnX/HJzz+7Cza2zNUz26R4lPMr5orCAbkjChKPKXZPS3F5dZzEvyfse
	mQwjk9Z3V49+m158rVXUhB4rsyMSdfClAJnr8Q4gdiUHcNmR4kY9jzk0voIVLa04
	uPQqCv4p0a/hpF90BrcpM+353y8IYT0ZdKBYKlKpIV8X7WZxLxXm8ub0sMEJuwuN
	yVm+Q9uurTaKLe7xyaplVyjUjcthmhhCZi7PiaNbVrtD4ttD3uWl5KKQ3FLweLmG
	zALHxw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9psk16nr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 19:04:44 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3a470ead068so3417583a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 12:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791918284; x=1792523084; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E6tTAr/QFwZtf53OiSJyqnMPDpZC+/sRmc2/eZIOuWY=;
        b=FsliZG+bL3rs5+QdKgJWJDxd88t8tChiOluhSj/tPotwb285+WnDWV8dEvmqS6pGLc
         X27af2Of+iddZFT7JR3ltrcrPhK96+3Jvq2f2PhTLFCLBEWIibO6cKCyRL+xIWtrxcTO
         CXhHl4XtWpIlCmeo64b4ErcIcd60KSaJyAPdKQloxRdDftPDwhlG7W8MaJNOYimw6oFC
         Uh2ip3BNHNXRZdX5ArVX+kE5zlt4wKj2fts990tUtwQdD/Zm+hNo5KVCNDP69dGfYu2D
         XcXsqd5VDSw+CM0Jv+TB7pCFFWjpGzlEReeSqVnGQ2J1XKS+sR9qcy6YiyRYK/IviA0b
         L2Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791918284; x=1792523084;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E6tTAr/QFwZtf53OiSJyqnMPDpZC+/sRmc2/eZIOuWY=;
        b=mllIcu2M46D6wDO9go+VaalCG5O0zQzwZIoTOEr0YGLJRD2AJVg/9J/D9DOJjWuVWB
         BWVI7ICu2RJozpPI3AOtGbEcJYcGabU5neWkDrGkxJkHBx4d8/c7tEfGY3ueWUVKI7HW
         oB2k0Jum1PpdlBMhuQlm7sdHOWCIiD0YHmznw13gJIM3XmSOoA5lF0xwk4h/GDNC6L4o
         CAxUcc5GEpookcFpndi5NwkfD5mnS8/SwI4jKOJKg7SktGx4a504AdL280VlDFT6nRXV
         u5SBvjFuiHS80CyT7bazSAiMwNmusp8nhdv+fFLRv6ocOVAXYCoqM9wVQWa+SfwouNs2
         4Ovg==
X-Forwarded-Encrypted: i=1; AKwUvBwkeOS5PwvlM0XJaZ/zFCPuAJCSZfgLzlofEYLFFL7X1gIa4XpTowR2n/aVP/RS4cY1TrWmv6E7LpHTbLSwkg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKjnSa4+UjpE+icfeHd6DCED0RrqixneBG/EN6xlVMFZybhoqPM
	GIXQLSeR8LCalVU9q5RN1/97eXJ0ZSgFF9GfKNxTbHe4dJHD/IqoRbDGXSXJfYDqpP7o8cyZSYS
	An/0Uzoao6L4V2m8w50dRBBjb7zRu70mMucKC6J9o+Sef3OFlmqgL3KCaXm6gJ47nsHlbsg==
X-Gm-Gg: AYBFou0PYbf3dDKZuUBnakQ8/PM6S+KB9uHnuK1RXbHEgj1D0G9JrVZGb64K3sTaz20
	H3pWiQdv9GSQ8V4H5VcYKizf5akFVdEmnA/aTflVBsSFwiQYxrzHfTyhWwQMENkb5iM/Mrwq3pW
	GnknpFODT/vEwnhb7D+/jPrPZTAWzpWwI7uanpCULK2ewS4B51VCUCrbJw/yYnXGP7g2cJd7Rp4
	5caTgCXtcmzAX4xecHULT14XscslwHCjh5rfqpcNJltLzz0uJmEFEc6xNM+/FQNakAzLk4sBF9T
	VFs2iCOonrmAm9MD6PZZcztW74fT+npx0o/v9vS8OYN3Tl847ZPgdo3S+cLIsI8i8IJgbubofib
	neD+9NB0SbFYLtO88aCLRl5J6CNo=
X-Received: by 2002:a17:903:240c:b0:2e8:1ec2:a8c4 with SMTP id d9443c01a7336-2e8428a2092mr103295095ad.14.1791918283677;
        Tue, 13 Oct 2026 12:04:43 -0700 (PDT)
X-Received: by 2002:a17:903:240c:b0:2e8:1ec2:a8c4 with SMTP id d9443c01a7336-2e8428a2092mr103294575ad.14.1791918282775;
        Tue, 13 Oct 2026 12:04:42 -0700 (PDT)
Received: from [192.168.1.6] ([171.76.86.55])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422fe6ddsm60820725ad.83.2026.10.13.12.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 12:04:42 -0700 (PDT)
Message-ID: <eedb870e-16ce-4f43-af9b-764fa81ae04b@oss.qualcomm.com>
Date: Wed, 14 Oct 2026 00:34:36 +0530
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
 <d5cd9c2b-a37a-40be-8916-162d9250adce@oss.qualcomm.com>
 <3132508e-3b02-41bb-8d93-28f30ef3a864@nbd.name>
 <5cd8adcf-2c52-49b0-802c-d995eaf8960f@oss.qualcomm.com>
 <085bd870-0ec1-4b92-bc99-dfbfe3c7132e@nbd.name>
Content-Language: en-US
From: Vivek Chettri <vivek.chettri@oss.qualcomm.com>
In-Reply-To: <085bd870-0ec1-4b92-bc99-dfbfe3c7132e@nbd.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: msa_KeHX2LtgPsA90oZKg2bS620IPygc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDA3NSBTYWx0ZWRfXzRnC7AEZkJxW
 A4+AsZnJAZ/9qdpRAcIJjwegm5fBxoqR5NFzqFaZyqDIFDBU2XQ/9hTR5ti/i7QniQSpqGQha3M
 SbhzwOXnKMVWF6LX6KvxdVtlEBfZxEo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDA3NSBTYWx0ZWRfX32au3fXJglWb
 OQ9NeOI8a1TxWAgKCV0mOXSNxx6/4/gSHYeSHyU/OSaCE15xnfOoF1vyXoXnnaCQoXfPUaPDqWK
 38nOBBEqMIyku4MCdgBPLEhL1GLKH4/3jQMrGD/9vYvNh5QHp57G9tGgnpXT95bs43iI6ZFN5n7
 SeqUnNSVk5HrsgX17HSXPRbHdVwyi2pl0gQ6mg04RbwNaZPKAUJ5r+/4N0TGXRo5j1srPh36JN/
 x8LWs3uccszStnuM2AeHl4pBV6RykLdb2cl9uUaHV56Bk+PsaHrLMEZUyU/W4Fv+9LzNbtUCc7d
 k/NOuqv8TttK5H5bfxx0e8/pzlGifCQnc/DquCPsy4CNC4D9ohAnfAlfuJU7iMUsMRsu0kiqS1U
 PPBARK2slrKnF/PL7eFcJhm1Wirb1J3SlRkB1O92dbpe6jW4SQa9Dzy9sLzT15uvLA2FxSvebYo
 ORgpK3sZ7ectzH5n/6g==
X-Authority-Analysis: v=2.4 cv=cbJHPXDM c=1 sm=1 tr=0 ts=6ace80cd cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=YaV4VRRLC15e4hseul3+nA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=07d9gI8wAAAA:8 a=VwQbUJbxAAAA:8 a=3HDBlxybAAAA:8 a=3CTnopHvpFOvPAwoJZkA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
 a=e2CUPOnPG4QKp8I52DXD:22 a=laEoCiVfU_Unz3mSdgXN:22
X-Proofpoint-GUID: msa_KeHX2LtgPsA90oZKg2bS620IPygc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610130075

Hi Felix,

On 9/29/2026 5:44 PM, Felix Fietkau wrote:
> Hi Vivek,
> 
> 
> On 26.09.26 07:07, Vivek Chettri wrote:
>> On 9/22/2026 3:35 PM, Felix Fietkau wrote:
>>> Hi Vivek,
>>>
>>> On 20.09.26 18:22, Vivek Chettri wrote:
>>>
>>>> The proposal is not to implement a full policy framework in hostapd.
>>>>
>>>> Following is the functionality split:
>>>>
>>>> Hostapd:
>>>>     Primarily responsible for SCS/MSCS protocol handling.
>>>>     Processing of the protocol descriptors ie TCLAS and QoS elements.
>>>>     Programming an existing kernel policy framework such as nftable.
>>>>
>>>> Nftables:
>>>>     Policy storage.
>>>>     Classification.
>>>>     Packet marking along with offload enablement.
>>>
>>> I'm not sure that nftables is a good policy storage for SCS/MSCS.
>>> In my proposal, all accepted SCS descriptors sent to mac80211 are enforced without direct policy override. That is by design, because it is expected by the standard.
>>> If system policy contradicts SCS descriptors requested by the stations, that's fundamentally an admission problem that needs to be dealt with in user space before descriptors ever reach mac80211, so that the station is told what is accepted and what isn't.
>>>
>>
>> We believe admission control can still be handled through a centralized policy database.
>> Instead of always giving SCS/MSCS requests higher priority,
>> administrators could choose whether SCS/MSCS policies or existing system policies take precedence.
>> This provides flexibility for different deployments.
>> When policy conflicts occur, the centralized policy layer can make an admission decision before enforcement,
>> rather than automatically prioritizing SCS/MSCS requests.
>>
>> Consider a deployment where a station successfully negotiates an SCS stream
>> for a video application and the corresponding QoS policy is accepted and programmed.
>> Later, an administrator updates the network policy to de prioritize or block that traffic class,
>> for example due to congestion, bandwidth quotas, or enterprise policy requirements.
>>
>> In a centralized policy model, the new administrative policy can be viewed and compared
>> against the previously accepted SCS policy, the conflict can be detected.
>> With the SCS policy in mac80211, the admin is not even aware of the policies.
>> The SCS session can be re-evaluated or torn down as appropriate.
>> This ensures that policy changes made after SCS admission can still be enforced consistently across the system.
> 
> That doesn't really make much sense to me. If SCS policy is accepted, then centralized policy changes that affect it must go through the user space component that deals with SCS admission.
> 
> Unilaterally dropping the classification policy based on centralized policy updates without also notifying the station by tearing down the SCS descriptor is a protocol violation. Also, if classification is torn down, any installed QoS characteristics belonging to the same descriptor must be removed as well.
> 
> Changes to SCS policy must be sent as unsolicited SCS response, e.g. with TCLAS_PROCESSING_TERMINATED_POLICY_CONFLICT.
> 
> I'd consider this an advantage of my design because the relevant SCS state is kept in one place without accidental partial drop due to external actions.
> 

We agree that any policy conflict must be handled in a protocol-compliant manner
and should not result in a silent or partial removal of established state.

In the proposed model, policy conflicts are detected by the centralized policy layer in
user space. When an administrative policy update conflicts with an active SCS session,
user space is expected to re-evaluate the affected session and initiate the appropriate
tear down procedure through the SCS control path.

If the negotiated SCS policy can no longer be honored, user space would issue an
unsolicited SCS response with TCLAS_PROCESSING_TERMINATED_POLICY_CONFLICT to
notify the STA that the previously accepted SCS session is being terminated due
to a policy conflict. As part of the same operation, any classification state and
QoS characteristics associated with the affected SCS descriptor would also be removed.

The intent is therefore not to unilaterally drop classification policies, but to ensure
coordinated tear down of the SCS session and all related enforcement state,
keeping SCS state, policy state, and QoS enforcement synchronized throughout the session
lifecycle.

One area where a centralized policy model may also provide value is conflict detection
and policy prioritization. Since both administratively configured policies and
SCS/MSCS-derived policies are visible within the same policy repository, conflicts can
be detected and resolved according to deployment-specific policy precedence rules before
enforcement occurs.

In the context of the proposed mac80211-centric approach, it is not entirely clear to us
how conflicts between existing system policies and previously accepted SCS policies
are detected, how policy precedence is determined, and which component is responsible
initiating the required SCS session tear down when such conflicts arise.
Additional clarification on this aspect would be helpful.


>>>>>> 2. Policy Framework: Considerations and Challenges
>>>>>>
>>>>>> A policy framework should help ensure consistent behavior across software forwarding, bridging, routing, and hardware-offloaded data paths.
>>>>>>
>>>>>> The policy framework can be realized using either nftables or tc-flower. Both
>>>>>> approaches provide a persistent and centralized repository for traffic classification and policy enforcement, but differ in integration complexity,
>>>>>> feature scope, and deployment model.
>>>>>>
>>>>>> Common Capabilities: nftables and tc-flower
>>>>>>
>>>>>> • Both nftables and tc-flower maintain centralized rule databases for traffic
>>>>>> classification and policy enforcement.
>>>>>>
>>>>>> • For software-forwarded traffic, both solutions require flow lookups against
>>>>>> installed rules and therefore have broadly comparable classification overhead.
>>>>>>
>>>>>> • Both mechanisms can serve as the policy enforcement layer for SCS/MSCS-
>>>>>> derived traffic policies.
>>>>>>
>>>>>> Advantages of nftables
>>>>>>
>>>>>> • nftables provides a unified framework for firewalling, traffic classification,
>>>>>> and QoS policy marking.
>>>>>>
>>>>>> • nftables can support both software and hardware-accelerated forwarding paths
>>>>>> and can be extended to additional offload scenarios with minimal architectural
>>>>>> changes.
>>>>>>
>>>>>> • Existing support for nftables-based policy handling in hostapd reduces integration effort and leverages infrastructure that is already available and
>>>>>> upstream-ready.
>>>>>>
>>>>>> The implementation is done using libmnl, which avoids licensing incompatibility
>>>>>> between hostapd (BSD-3-Clause) and libnftnl (GPLv2). This approach was
>>>>>> also reviewed with Jouni.
>>>>>>
>>>>>> • Using nftables allows SCS/MSCS policies to be integrated into a broader, system-wide policy framework rather than introducing a WLAN-specific policy
>>>>>> engine.
>>>>>>
>>>>>> • Using nftables can also facilitate scalability by allowing these rules to
>>>>>> be applied at software acceleration decision-making stages. For example, the
>>>>>> NFT rule can be cleanly integrated into NFT flow tables as well.
>>>>>>
>>>>>> Challenges with a tc-flower-based Approach
>>>>>>
>>>>>> • A tc-flower solution would require substantial additional implementation for rule programming from hostapd.
>>>>>>
>>>>>> • tc-flower typically requires qdisc configuration (at a minimum, a clsact pseudo qdisc) before classification rules can be installed and enforced.
>>>>>
>>>>> Most of these points are very abstract and in my opinion gloss over a lot of
>>>>> implementation complexity. I'd argue that just because nftables is used to enable
>>>>> offloading in some setups doesn't mean that it handles the different policy
>>>>> aspects of SCS and especially MSCS well, or provides good ways to deal with
>>>>> runtime changes to existing flows.
>>>>>
>>>>
>>>> I agree that implementation complexity and runtime updates are important
>>>> considerations. For SCS/MSCS cases, nftables address the highlighted concerns
>>>> in following ways
>>>>
>>>> Complexity: not a concern
>>>>    - Linux Kernel NFT Infra provides well defined APIs to program policies
>>>> which satisfies present use cases and does not add much implementation
>>>> complexity or overhead.
>>>
>>> You can claim that, but reading the QSDK implementation of the hostapd/nft integration code gives me the opposite impression.
>>>
>>
>> While the implementation is not particularly complex,
>> its size is largely driven by the need to implement wrapper APIs
>> for programming nftables rules via Netlink messages.
>>
>> Due to licensing constraints, libnftnl cannot be used directly with hostapd,
>> requiring the use of libmnl and direct construction of Netfilter Netlink messages.
>>
>> Much of the code therefore consists of standard message encoding and communication
>> with existing nftables kernel interfaces rather than complex policy or algorithmic logic.
> 
> It's still a significant amount of code that we would not need in my approach.
> 
>>>> Runtime: supported
>>>>   - These APIs indeed having support for runtime modifications as per SCS/MSCS
>>>> protocol requirements.
>>>>
>>>> Offload cases: supported seamlessly
>>>>   - nftables is already used as a general policy and classification framework
>>>> for both software-forwarded and software/hardware-offloaded traffic.
>>>>
>>>> Protocol classifiers: all mandatory variations supported
>>>>   - The classifiers required mandatorily by SCS/MSCS, including cases such as
>>>> TCLAS Type 10 (ESP/SPI Based rules), are supported with nftables.
>>>
>>> One aspect this ignores is intra-AP forwarding handled by mac80211.
>>>
>>
>> This should not be a major concern.
>> In such scenarios, traffic can be forwarded via the bridge using hairpin mode,
>>
>> In addition, upcoming peer-isolation support introduces per-peer controls for intra-AP forwarding,
>> either at the mac80211 or bridge layer.
>> This would allow SCS/MSCS clients to be configured to use bridge-based hairpin forwarding
>> and for other clients we can still do forwarding from mac80211.
>>
>> As a result, intra-AP forwarding does not fundamentally alter the architectural considerations discussed here.
>>
>> The same policy classification, storage, and forwarding mechanisms
>> can continue to be applied through the common policy framework,
>> while keeping network-wide policy decisions outside of mac80211.
> 
> So you plan to make hostapd selectively switch clients using SCS or MSCS over to bridge hairpin by configuring peer specific isolation and hairpin mode? A bit cumbersome, but I guess it could work.
>>>>> I get the impression that your proposal is designed to handle the needs of a
>>>>> single Qualcomm implementation of an out-of-tree policy framework service well,
>>>>> while neglecting in-tree kernel offload mechanisms, as well as standalone
>>>>> AP implementations by pushing extra complexity there.
>>>>>
>>>>
>>>> The nft based proposal is neither Qualcomm-specific nor based on out-of-tree
>>>> policy framework.
>>>>
>>>> Qualcomm's approach using nftables works for systems with no offload, software
>>>> offload, or hardware offload by leveraging existing upstream infrastructure as
>>>> follows.
>>>>
>>>>     1. SCS policies programmed by hostapd are part of the net filter egress hook
>>>> which maintains classifier info along with QoS identifier (nfttable rule->mark).
>>>>
>>>>     2. Mark field part of the nftable gets populated into connmark of the ct
>>>> during connection establishment.
>>>>
>>>>     3. The connmark information that is populated at the egress hook can be used
>>>> for HW offload programming by the vendor driver
>>>
>>> Having the driver make DSCP tagging decisions based on connmark seems like a band-aid hack to me. connmark can be used by the user for multiple purposes, including policy related decisions.
>>> Relying on it in the driver for a specific purpose seems like a bad idea to me.
>>
>> We understand the concern that connmark is a generic field and may be used for other policy decisions.
>> However, using conntrack marks for QoS-related state is already an established pattern in the kernel networking stack.
>>
>> The NET_ACT_CTINFO documentation explicitly states:
>>
>> ▎ "Current actions transfer connmark stored DSCP into ipv4/v6 diffserv and/or to transfer connmark to packet mark.
>> Both are useful for restoring egress based marks back onto ingress connections for qdisc priority mapping purposes."
>>
>> This is further reinforced by the upstream commit introducing act_ctinfo (Kevin Darbyshire-Bryant, 2019),
>> which explains the motivation directly:
>>
>> ▎ "Ingress classification is traditionally a challenging task since iptables rules haven't yet run
>> and tc filter/eBPF programs are pre-NAT lookups...
>> Thus marking the connection in some manner on egress for later restoration of classification on ingress is easier to implement."
>>
>> This indicates that carrying QoS classification information in conntrack state,
>> and consuming it later for QoS-related decisions, is already an intended and documented use case within the kernel.
>> Importantly, our proposal does not have the driver read connmark directly.
>> The connmark → skb->mark translation is performed by an explicit, nftables rule. The driver only consumes skb->mark.
>> Therefore, the proposal is not introducing a new semantic for connmark,
>> but leveraging a mechanism that is already used for QoS-related classification and priority handling.
> 
> Having this mapping as an explicit action is not the same as introducing it as a private contract between one particular driver and the system configuration. An important goal of offloads in the Linux network stack is to stay as close as possible to the software configuration mechanisms of the Linux user space network API.
> In my opinion, adding magic reinterpretation of generic fields by the driver violates that principle.
> 
> How does driver consuming skb->mark even work in the SCS case? Which driver would consume it?
> For packets flowing from ethernet to WLAN, does that mean you intercept packets in ath12k tx and read skb->mark there in order to update the UP?
> 
> Either way, abusing connmark for SCS means you can't use connmark elsewhere for policy decisions on flows that might hit WLAN.
> Another gotcha for administrators to be aware of.
>>>>     4. As the SCS policies are added at egress hook this would seamlessly work
>>>> even when software offload(nft flow table) is enabled
>>>>
>>>> SCS/MSCS would simply act as a policy producer, while classification and
>>>> enforcement remain within common in-tree mechanisms.
>>>
>>> I also don't see how nft handles MSCS well. It learns per flow from the TID of received uplink frames, with a per station classifier mask, UP bitmap, UP limit, entry timeout and entry limit. How does a dynamic nft set expresses "record the UP of this uplink flow under this station's mask, expire it after this station's timeout, cap it at this station's limit".
>>
>> Our proposal for MSCS is that mac80211 parses the uplink priority for a client with active
>> MSCS session, it updates the skb->mark which then updates the conmark in the ingress hook.
>>
>> Since the mirror flow is part of the same ct,
>> we can extract the meta data and update for the down link flow as well.
> 
> Updating skb->mark from mac80211 based on UP does not make much sense to me, because it's yet another abuse of a generic field for a specific purpose.
>>>> The goal was not to push Qualcomm out-of tree implementation, but to have a
>>>> solution using existing in-tree kernel mechanisms
>>>>     1. Avoids Duplication of the same coming at mac80211
>>>>     2. Reduces system complexity with centralization.
>>>>
>>>> Qualcomm offload mechanism can work with policy data base built at mac80211
>>>> also; however what we wanted to explore was avoiding non 802.11 network-wide
>>>> policy and classification decisions within mac80211. This helps prevent the
>>>> creation of a parallel policy framework and keeps mac80211 focused on Wi-Fi-
>>>> specific functionality and concepts.
>>>
>>> While I do agree that avoiding duplication is useful, I believe in this case it comes at a cost that makes it seem like a bad trade-off to me.
>>> The main reason for that is the unhandled gaps and the extra overhead it introduces.
>>>
>>> Gaps:
>>>  - mac80211 intra-AP forwarding not handled
>>>  - TC offload API not handled
>>>  - hw offload depends on abusing existing fields
>>>
>>> Costs:
>>>  - mandatory conntrack
>>>  - mandatory extra packet filter table
>>>  - complexity of translating standard mandated behavior into nft rulesets, which do not always align well.
>>>  - extra subsystem dependency
>>>
>>>>> Let me give you a specific example. On OpenWrt, Ethernet -> WLAN bridge hw flow
>>>>> acceleration works by having a user space daemon that replicates the bridge
>>>>> state, measures L2 flows via eBPF and programs no-sw tc-flower offload rules
>>>>> for L2 flows. On the MTK driver side, the offload core uses the programmed
>>>>> L2 rules to trigger actual hw forwarding. Only for routing/NAT flow offload
>>>>> does nftables get used. The kernel side is fully implemented in upstream
>>>>> kernels without any out-of- tree subsystems.
>>>>>
>>>>> The forwarding from Ethernet to WLAN works because the kernel code can
>>>>> resolve the hardware path via dev_fill_forward_path and query the relevant
>>>>> metadata (which happens by calling into the WLAN driver through mac80211).
>>>>>
>>>>
>>>> Thanks for the example.
>>>>
>>>> If both traffic types (bridged and routed) ultimately require policy
>>>> classification and offload decisions, having a common framework could provide
>>>> a single policy repository and a consistent programming model across all
>>>> forwarding paths.
>>>>
>>>> Referring to the following article, can nftables be considered for bridge
>>>> offload as well?
>>>>
>>>> https://lwn.net/Articles/1082320/
>>>
>>> So you're saying we should force user space away from existing actively used offload APIs because they don't fit into your design?
>>>
>>
>> The goal is not to replace or discourage existing offload APIs.
>> The bridge offload solutions based on tc flower that you mentioned
>> can continue to be used where they already fit the deployment needs.
>> The point is that, for SCS/MSCS policy enforcement and offload,
>> using a common framework such as nftables across both bridged and routed traffic
>> may provide a single policy store and a consistent programming model.
>>
>> This is not a requirement. Vendors can choose the approach that best fits their architecture and offload capabilities.
>> Some may continue using separate bridge and routing mechanisms, while others may prefer a unified framework.
>> Our proposed approach remains compatible with existing offload mechanisms for two reasons:
>> 1. The egress path is already part of the transmit flow, where SCS policy matching can be performed
>>     and the resulting QoS state encoded in conntrack metadata.
>> 2. Hardware offload continues to use the standard ndo offload APIs,
>>     allowing drivers to extract the required QoS information without introducing new offload interfaces.
>>
>> Following are the high level view of the flows for pure SW, nft flowtable offload(Bridging/Routing/NAT)
>>
>> 1. Software Flow
>>
>>
>>                                                  │
>>                                                  │
>>                                                  │
>>                                                  │1. Packets of flow
>>                                                  │
>>        ┌────────────┐  ┌────────────┐   ┌────────▼────────┐  2. Initial packet, set conmark
>>        │  ingress   │  │  forward   │   │     egress      │  Subsequent packets, skb->mark = conmark
>>        └────────────┘  └────────────┘   └────┬────────────┘
>>                                              │
>>                                              │                       netfilter
>>    ──────────────────────────────────────────┼────────────────────────────────────
>>                                              │                       mac80211
>>                                     ┌────────▼──────────┐                +
>>                                     │      mac80211     │          vendor driver
>>                                     └────────┬──────────┘
>>                                              │
>>                                     ┌────────▼──────────┐
>>                                     │   vendor driver   │
>>                                     └───────────────────┘
>>                                     3. Use skb mark data,
>>                                        program the HW descriptors
>>
>>
>>
>> 2. nft flowtable offload flow
>>
>>
>>                      │  1. flowtable rules created
>>                      │      (Bridged/Routed Flows)
>>                      │
>>                ┌─────▼──────┐
>>                │    nft     │
>>                └─────┬──────┘
>>         userspace    │
>>         ─────────────┼──────────────────────────────────────────────────────────────────────────────
>>         kernel       │
>>                      │                             │                            │
>>                      │                             │                            │
>>                      │                             │                            │
>>                      │                             │ 5. Flow state              │3. Inital packets of flow
>>    2. ndo_tc_setup   │                             │    CT ESTABLISHED          │
>>                      │       ┌────────────┐ ┌──────▼─────┐             ┌────────▼────────┐
>>                      │       │  ingress   │ │  forward   │             │   egress        │  4. Initial packet, set conmark
>>                      │       └────────────┘ └──────┬─────┘             └─────────────────┘
>>                      │                             │ 6. flow_block_cb
>>                      │                             │    (flow data)
>>                      │                             │
>>                      │                             │
>>                      │                             │
>>                      │                             │                                               netfilter
>>                    ──┼─────────────────────────────┼────────────────────────────────────────────────────────────
>>                      │                             │                                               mac80211
>>             ┌────────▼───────────┐       ┌─────────▼─────────┐                                         +
>>             │      mac80211      │       │   vendor driver   │                                   vendor driver
>>             └────────────────────┘       └───────────────────┘
>>                                           7. Use con mark QoS data
>>                                              program the HW
>>
> This setup flow is not compatible with the L2 offload rules programmed by bridger. bridger programs offload rules based on MAC address tuples. The hardware flow table uses them to trigger hw offloading of recognized L4 tuples. It considers both directions separately.
> 
> When it's time to offload a flow based on a packet flowing from ethernet to wireless, the hw offload engine needs to know the tag that shall be applied after forwarding. How would this even work in your approach?
> 
> In my approach, I deal with this issue by allowing the driver to query the output tag through callbacks at offload bind time, as well as reacting to SCS descriptor changes for existing flows (through the unbind trigger).
> 
> That makes it completely independent of nft vs tc-flower created flows, or even L2 vs L4 offload rules.
> 
> I don't see anything in your approach that could support this without forcing users to create flow offload rules through nft instead of tc.
> If you do, please let me know and describe the exact chain of events.
> 
> - Felix

For the L2 bridge flow hw offload case, there is an active upstream series gaining traction:

https://lore.kernel.org/netfilter-devel/20260708093250.1187068-1-pablo@netfilter.org/T/#mb9581ceac031c8222db29af384f9fbbdfa9cc2a8

This series adds native L2 bridge offload to nf_flowtable using nf_conntrack_bridge.
The kernel community appears to be converging on native bridge offload through nf_flowtable and nf_conntrack_bridge
as the standard mechanism.

Our nftables/connmark-based classification approach aligns naturally with this direction.

For offload designs that do not rely on kernel connection tracking
(e.g., MediaTek eth-to-WLAN flows via bridger), the connmark can still be retrieved
through the standard netfilter API using the 5-tuple from the flow.

Regarding your ethernet patches: we notice that a non-WLAN module calls
ieee80211_sta_flow_prio() directly to perform policy matching.
This introduces a direct cross-subsystem dependency where offload drivers
outside mac80211 must call into mac80211 APIs.

Thanks!
Vivek.
