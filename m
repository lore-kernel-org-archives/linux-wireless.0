Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D4F49690C
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372967; cv=none; b=KVgcqePWIK9RnljAEK/ppzq4vK5u3NgzR+Jnj4s030TPDD+l5wsLt3fh1ylB9Aokk+wa1w2LZGSJJ7y3Wpl1I8+Mj9uZuwql9Ee2nacIFd8Nn9N04ON7di/6R8ejbpwo9zrL7d9GxjJDRdPo59l11wtoIyWhJZFTFD8cRowoxCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372967; c=relaxed/simple;
	bh=Jf937isbMSjdNsEyM4+i0aVGJWxxRN4bP6juvpbAabk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=US5CVOZXmgvm17pqgF0dAbvhi7bPdVrseUPjdqBYScGMO+aLBsN3RBQ3ivsKEzHQBlQHWgD8BOr1PJx3L0us0kQTA55C/R1eabIcefEnIPnk2GHAzJUSZXboBsD0xXuxW6pPBkEgkekvpN13+2LxEZWz3hORh9DOq0I3Iua+aJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nj/no8C8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PZDwPJWR; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nj/no8C8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PZDwPJWR"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BV0BL2969244
	for <linux-wireless@vger.kernel.org>; Wed, 7 Oct 2026 11:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Nmz35Ni0+dtT362qMHoufJDeftmuh3Qb7H5vQYCOXew=; b=nj/no8C86rebNLv3
	44z9MDYtr6oOWOCov8z6vtsLtttXIr12nsTQA/55VxBfl9pXM0sr7A2XsJR6r68P
	40q94QvTDvS5X2lwpRXEdP3N9owZ4PIwjklv/VzDAcdIBI74NP1k33E5R2rZqEVH
	29BHbXrxeFuR1dJGLDOzWx+AwFiER1wowActHcfxvpm+pJ6HbXYjLBE+DZRLldvg
	VIgN6V+RbX9WBNXpo//SKuNrN/zYM57kyezIt7vZYx5E4/9lxKHJ6c2+aJd4khql
	nH0qyj47TrvK06FAP28ekMtCPnTn0JfIfCt3jTdxZ2v5YyYG0yD62ZkkFLg6uUBi
	PbP9vQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5c6u1v4t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 11:35:37 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-88f7b357bb4so55696b3a.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 04:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791372937; x=1791977737; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nmz35Ni0+dtT362qMHoufJDeftmuh3Qb7H5vQYCOXew=;
        b=PZDwPJWRO3dwnrE5aE1sYKVd1/hQpKrjb976uEZ09DTg0EOl3+0wx/oUKEBWlosucb
         8uz/n+5ZsS8RekBsQVgwFGeByg9FCRxApHoDArwSthubx8QDdAHalBk7MedTZnIcIqff
         qSLd38UWyg1nnAuLxKH8TwywH5Ijicq+8F6UmVOVXhqReYjJdiyX8k44+sE21BnV7BIt
         v2q7s1S2wLd/HQ7N+goZQryZTK5Vh2TIDyG8/CZoS7zhAtTEQOl17pnUfk8C44Nj9bKf
         bf58yqdnHEGtFy+dL82D/TEU6OAjnENiihfQmGlRIyfHDUh74bJeoLvkbqekKxmG6vBF
         0w9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791372937; x=1791977737;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nmz35Ni0+dtT362qMHoufJDeftmuh3Qb7H5vQYCOXew=;
        b=iTk39KBe0yR5+obV8z/+YC7EWCtCk6nHz/ViINZkcS029eJ7o5Tw9mh+nTIs1oDSGA
         8o8KX6sArQkPwvrswuRXwmE3+rf96xcJgX8bDmRBTGH8r/sB7+xPvIqrDmFs+7vNvQHT
         evRf6PLtfsEOHF0nZs32TrOo1u0rNyFRtzHn06uIWOT0t5I+JuLFiv33HPD8BrkNv55T
         cJ7WMKb/yOGHbxh3snxx/2mR48dt4DCQ4egYVIyKlGifr98BA4HXMreve8nljeHHh0PD
         3d4sNQJHA9nkdflGSFyqCgKCx+OS6eINTaJ1NEl7sFRdApuTBrZSYy0rG6r//LUrZ/Rm
         gYAg==
X-Gm-Message-State: AFuF++kI/JBEpC4/r5rwMp/fJJpITphuvdZrHdw768ClMm2FpDByFT38
	hxBR/nAL6/0LmsMwCphOpe35Ff7fCHJ1ORrv7JiPyeO5SPLcWvMjhI1Hdskigmja6tE4nsSq5Az
	YVXKCd5ssFiZ6V6bBzoQG9VvXC/qdZBn0A3tfZqhvjm2qNqGjFAfZVELP3uqRjC0jjAHk5clezt
	wc
X-Gm-Gg: AYBFou22zIcXpiYZmb/+wSCxbC1IDUcPW7I5VBAmHP+aWWysusa76Cv2BoK331GoPpb
	0uL+y8/wXakOtRj4Jg2mbf6zy5vCsesLwYZAkbWfB+4swz4WMMbfD69LyzfAZzXJ1JWUnCDPs30
	DTnsElA3gKfkwpjIOPwG5zVQNo3wxfHWBkzcbSnfvquG5fXj45Zyk8CCl73cJvqDFtweR6OF+ei
	wTpfkqGLU+11YbTurP/u7Sc2dXPTEOSfG31m6sgttup4Y0Br/aox+GqGQpz0UtBBzmDeA8SOT5r
	H0i0MtS8RqokCyFN853y6plqnUoHPz0ii7ZsZ2ZdH2rN8DYbh/8HnW1F/cPZVj4YyNm56Ym9b3q
	SjIItMOB194g1qgqQ8AcmEcdLqv01PVAD737/tc3ogZX2gd9/SH702S9xXCQ7iCKEgvYQO09Fwr
	mcHPhlKxYSH5Ff6pGf
X-Received: by 2002:a05:6a00:288a:b0:882:23ce:f51e with SMTP id d2e1a72fcca58-891b4ce43c2mr1402647b3a.30.1791372936871;
        Wed, 07 Oct 2026 04:35:36 -0700 (PDT)
X-Received: by 2002:a05:6a00:288a:b0:882:23ce:f51e with SMTP id d2e1a72fcca58-891b4ce43c2mr1402627b3a.30.1791372936207;
        Wed, 07 Oct 2026 04:35:36 -0700 (PDT)
Received: from [10.50.61.110] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89183a8c76csm1251343b3a.0.2026.10.07.04.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 04:35:35 -0700 (PDT)
Message-ID: <369a95a2-2fe7-4827-9686-eeb88c5e0087@oss.qualcomm.com>
Date: Wed, 7 Oct 2026 17:05:33 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2 09/16] wifi: mac80211: Define layouts for
 SMD BSS Transition context
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
 <20260924-smd-v2-9-bb40094da1d4@oss.qualcomm.com>
 <fc91329053c0cbedecf51bcccd4a0e74eba850e5.camel@sipsolutions.net>
Content-Language: en-US
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
In-Reply-To: <fc91329053c0cbedecf51bcccd4a0e74eba850e5.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX364zpt82ady8
 /U60qwo30cyL8ZSxjScNlVG7/t5KD3kZr5gHk/9BHPNsi5ENl33juEsL/MmeX6kkkm24E6qweQk
 PMYEGQvKMOYOzDTSnxyzU2FgoiNMWhA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX521M7M0JwwGH
 xu0UNgmwMCjsVS1+OU5gMBW17IFY6EhC5DUUNVe9QW306rSCK4aAslewgHBu1Nxy0KVRkxxOghK
 j3zcSJPvUdcH532z9/dpGbIqBu1WLBKmnh1JkMClZxJxpIsOq7KDnEmZ60QkPWm0SbumvJpNGOx
 6uCQeQKvU0DbyENPwa0gCQm2ikhvxAumGJ61JA1E1GtlSvM5QoE2hw98Os1y3/02nJweQMb++em
 jabLe1x3kuTUE4/k7FJTKu+bJcOhwzv25CXPgvGaQ7QJKQtOGaTsyiKJEnkN3UORQ/Wg81w1Zy/
 73BRJxLsrZwdekdsiaq4WvktK0C/9zXtwhwBhBt9RaHCWOk6A4/TpICv0yI/yo7rArbeTwKUkHv
 7tsqEiBEvIqH7yrZlB16sp4JCJe0xSxsXXZQOampz4nSd//Y6U7tI8/C1EAqUS4GX/DmIjXMryt
 SDlUfENfijAreGuaVug==
X-Proofpoint-ORIG-GUID: DTUjkwleBmS1dlBeuTXEa6SzLyW4nFPp
X-Authority-Analysis: v=2.4 cv=T5EZ3PKQ c=1 sm=1 tr=0 ts=6ac62e89 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=I2K72IQzrYoTmYq68goA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-GUID: DTUjkwleBmS1dlBeuTXEa6SzLyW4nFPp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070046



On 10/02/2026 01:39 am, Johannes Berg wrote:
> [dropping CC's, I have no idea why you CC'ed hardening?!?]
> 
> On Thu, 2026-09-24 at 08:10 +0530, Pooventhiran G wrote:
>> IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.9, defines the context
>> data to be transported during SMD BSS Transition (ST) laid out in
>> subclause 37.16. The station's context data is attached to the ST
>> Preparation or Execution Request action frames so that userspace
>> receives the context along with the relevant frame.
>>
>> Define the context data: per-TID sequence numbers (SN) in downlink (DL)
>> and uplink (UL) directions, packet number (PN) in DL, per-TID packet
>> numbers in UL, and per-TID BlockAck session parameters in DL and UL;
>> along with this, define an optional driver context. This data is used by
>> drivers to report the context along with the frame SKB.
> 
> 
> Just a couple of _very_ quick comments, having imported this to my tree
> to compare notes with the client side implementation I'm working on:
> 
>> Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
>> ---
>>  include/linux/ieee80211-uhr.h | 86 +++++++++++++++++++++++++++++++++++++++++++
> 
> This isn't really mac80211 (commit subject), but I also don't think this
> should be defined here at all. I mean, I get why - the spec defines what
> needs to be transferred, but it doesn't actually define the _layout_ of
> the data and it's never used over the air, so I think it'd be confusing
> to have it here anyway.
> 
> Probably should define it in cfg80211.h instead, since it's used all the
> way through nl80211 down to the driver(s)?
> 

Sure, Johannes. I will move this to cfg80211.

>>  1 file changed, 86 insertions(+)
>>
>> diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
>> index c3f87d4c8bec..e6aaef9ae9e6 100644
>> --- a/include/linux/ieee80211-uhr.h
>> +++ b/include/linux/ieee80211-uhr.h
>> @@ -649,6 +649,92 @@ struct ieee80211_uhr_mode_change_tuple {
>>  	u8 variable[];
>>  } __packed;
>>  
>> +/*
>> + * Context information carried in SMD BSS Transition (refer IEEE P802.11bn/D2.0,
>> + * Aug 2026, subclause 37.16.9.
>> + */
>> +#define IEEE80211_SMD_CTX_NUM_VALID_CTX    8
> 
> Why is there such an arbitrary limitation?
> 

It was defined for the BITMAPs usage but I will clean this up as I will
replace BITMAP with individual valid:1 bitfields.

>> +/**
>> + * struct ieee80211_smd_ctx_ba - BlockAck parameters for DL and UL
>> + *
>> + * @amsdu_supported: Peer's capability to support A-MSDU within A-MPDU.
>> + * @ba_policy: BlockAck policy (0 = delayed BlockAck, 1 = immediate BlockAck)
>> + * @buffer_size: Reorder buffer size from ADDBA Request (10-bit, max 1023)
>> + * @timeout: BlockAck session timeout
>> + * @ext_no_frag: ADDBA Extension fragmentation support
>> + * @extfrag_level: ADDBA Extension HE fragmentation level
>> + * @ext_buffer_size: ADDBA Extension buffer size; combined with @buffer_size as
>> + *	(@ext_buffer_size << 10 | @buffer_size) to get the full reorder
>> + *	buffer size
>> + */
>> +struct ieee80211_smd_ctx_ba {
>> +	bool amsdu_supported;
>> +	u8 ba_policy;
>> +	u16 buffer_size;
>> +	u16 timeout;
>> +	bool ext_no_frag;
>> +	u8 extfrag_level;
>> +	u16 ext_buffer_size;
>> +};
> 
> What about WinStartO?
> 
> Though I honestly lost track of where the spec is going with all the
> options of transfer/not transfer - need to try to catch up next week.
> 

In ath12k implementation, WinStartO functionality to not exceed the BA window
on the target AP MLD is achieved differently. But I will translate that to
using WinStartO so that it is more generic.

>> +/**
>> + * struct ieee80211_smd_ctx - IEEE 802.11bn SMD Roaming Context (refer
>> + *	IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.9)
>> + *
>> + * @valid_ctx_bmap: Bitmap indicating which context fields are valid;
>> + *	bit positions defined by IEEE80211_SMD_CTX_VALID_* constants
>> + * @pn_len: Length of PN in bytes; varies by cipher type
>> + *	(e.g. CCMP (6), GCMP-256 (16))
>> + * @dl: Down-link context data
>> + * @dl.valid_tid_bmap: valid DL TIDs for which context is present
>> + * @dl.sn: DL SN per-TID to be assigned next
>> + * @dl.pn: DL PN to be assigned next
>> + * @dl.ba: DL BlockAck parameters per-TID for the BlockAck session
>> + * @ul: Up-link context data
>> + * @ul.valid_tid_bmap: valid UL TIDs for which context is present
>> + * @ul.sn: UL SN per-TID to be checked next
>> + * @ul.pn: UL PN per-TID to be checked next
>> + * @ul.ba: UL BlockAck parameters per-TID for the BlockAck session
>> + * @drv_ctx_size: Number of valid bytes in @drv_ctx.
>> + * @drv_ctx: Variable-sized array of driver-specific context, counted by
>> + *	@drv_ctx_size. Opaque to the wireless core; interpreted by drivers.
>> + */
>> +struct ieee80211_smd_ctx {
>> +	DECLARE_BITMAP(valid_ctx_bmap, IEEE80211_SMD_CTX_NUM_VALID_CTX);
> 
> This seems overly complex for ... 4 bits? Could just have individual
> valid:1 bitfield entries or something?
> 

Yeah, I will change valid_ctx_bmap to bitfields.

>> +	u8 pn_len;
>> +
>> +	struct {
>> +		DECLARE_BITMAP(valid_tid_bmap, IEEE80211_SMD_CTX_NUM_TIDS);
>> +		u16 sn[IEEE80211_SMD_CTX_NUM_TIDS];
> 
> Aren't there more counters, e.g. for mgmt frames?
> 

Since std does not define it explicitly, ath12k implementation transfers this
in the driver data separately. But I will move this to proper definitions
since mgmt queues need to continue anyways.

>> +		u8 pn[IEEE80211_SMD_CTX_MAX_PN_LEN];
>> +		struct ieee80211_smd_ctx_ba ba[IEEE80211_SMD_CTX_NUM_TIDS];
>> +	} dl;
> 
> It feels like there should be some information here about "how many
> frames are buffered for each TID" and mac80211 could increment that by
> however many are buffered there, both to give the AP an ability to
> estimate the downlink drain time, as well as how much to bump the PN
> forward to by? Although the latter could just be like 1 million and
> nobody cares.
> 

Estimating the draining period is a work-in-progress and this series (and its
corresponding ath12k implementation) does not support it. Current
implementation works with a static configuration. I will add the required
changes as part upstreaming the dynamic estimation support.

Reg the PN offset, based on the below std language (subclause 37.16.9), the DL
SN and PN getting transferred here are already offset to reserve some space
for draining. I will add the required documentation to establish that.

`
NOTE 1—When the current AP MLD determines the next SN to be assigned for DL
individually addressed Data frames of each TID, the current AP MLD accounts
for some reserved set of SNs so that any DL MSDUs of that TID from the DS to
the current AP for the non-AP MLD can still be assigned SN that is less than
the “Next SN”. This reserved set of SNs also depends on when the “Next SN” is
sent to the target AP MLD—i.e., during ST preparation or during ST execution.
If the former, then more SNs need to be reserved because new DL MSDUs may keep
arriving the current AP MLD from the DS during the preparation timeout.

NOTE 2—When the current AP MLD determines the starting PN to be assigned for
DL individually addressed frames by the target AP MLD, the current AP MLD
selects a starting PN high enough such that the PN values used for the DL
frames from the target AP MLD will not repeat any PN values that were used by
the current AP MLD.
`

>> +	struct {
>> +		DECLARE_BITMAP(valid_tid_bmap, IEEE80211_SMD_CTX_NUM_TIDS);
> 
> again I think the whole DECLARE_BITMAP is a bit of a contortion when
> really you needed ... a u8? perhaps a u16 or u32 when accounting for
> mgmt? still not longer than the "unsigned long" this results in, and
> seems way more understandable?
> 
> (and wouldn't even have the kernel-doc problem)
> 

Yeah, I will clean up BITMAPs.

>> +		u16 sn[IEEE80211_SMD_CTX_NUM_TIDS];
>> +		u8 pn[IEEE80211_SMD_CTX_NUM_TIDS][IEEE80211_SMD_CTX_MAX_PN_LEN];
> 
> Does this even need to be per TID? I guess I could see that maybe it
> must be, but if so you forgot mgmt frames here too?
> 

Yes, UL PN is maintained per TID. I will add proper definitions for UL mgmt
information as well.

> I'd also love for you to think about hwsim supporting this - in that
> case mac80211 maintains a lot of this data. Having mac80211 fill in some
> data unconditionally though seems brittle - what if the driver just
> forgot the PN and then mac80211 says "sure the PN is 0" because
> something, so ideally drivers would somehow say "this should be filled
> in from mac80211 software state" or something.
> 

Yes, it is in the pipeline. I will add hwsim changes as well to this series.
For end-to-end upstream validation, if there is STA SMD support in upstream,
we can leverage that; otherwise, I will have some minimal changes locally just
to support AP testing and submit the AP changes. For hwsim, I will add APIs to
fill in these data that mac80211 maintains.

> johannes

