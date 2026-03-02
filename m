Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14703FFAD6
	for <linux-wireless@vger.kernel.org>; Mon,  2 Mar 2026 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772465181; cv=none; b=UfXaSGW2wgnP5osX2S/ISeZsvJ0fHnv/kym9OAaR7FAS2DCzxSAVZL3AUPUydIVEVTHAoV64tfc5k5tN7P26gDVlpIPHmhRxEDt7kjjrZzJ0wHMop0Hxw3rDCjhTvPPLHiVml1HvQ4VI4UKpVf9NjBKiozkLMCWKnbBq1INqliI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772465181; c=relaxed/simple;
	bh=5Cq0fVCetPqhcVASCeSHY0gogH2h4nFJPBTkk9lvNfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fy3x4u8pY1aU/uf4AhdPWXnX6T5GwkfLPrSfN4Y1y15C1Hi9EKctGOOewfFpmO5ApUHXHz5bzRO8f7LyfoWtysGTsh6E8L9GNUNllJx+bqzMtyB4JCrIciULNjQm14MxLJxUuwYST36kV2FEDWLYQW1uDHlKOsL8HdBZGOGVCh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=FOM90vyu; arc=none smtp.client-ip=148.163.129.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="FOM90vyu"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3411EA80078;
	Mon,  2 Mar 2026 15:26:16 +0000 (UTC)
Received: from [192.168.1.23] (unknown [98.97.35.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 7D1C913C2B0;
	Mon,  2 Mar 2026 07:26:09 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 7D1C913C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1772465173;
	bh=5Cq0fVCetPqhcVASCeSHY0gogH2h4nFJPBTkk9lvNfk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FOM90vyuh0qq/iMnZYLAAcRptykQDh2Evs1um/z69V2V2SxPiVd1+q4aNOZKbUSwJ
	 VWFbbG+3zsJmk2UJMtS6WXE7q49Q+MIJaILNAj5VBzdt8J83vc9qlJxR9hI0yTjdj/
	 AU6aKrtlQ9jWY04ry3GB2JCeHiPsKiJ0cRKhpZRU=
Message-ID: <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
Date: Mon, 2 Mar 2026 07:26:06 -0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
To: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
 linux-mm@kvack.org
References: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com>
 <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
Content-Language: en-MW
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-MDID: 1772465178-3OC3rV38qpc3
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1772465178;3OC3rV38qpc3;<greearb@candelatech.com>;61b5a6caf2130fd460623c1c7a4e3fbd
X-PPE-TRUSTED: V=1;DIR=OUT;

On 3/2/26 00:07, Johannes Berg wrote:
> On Sun, 2026-03-01 at 07:38 -0800, Ben Greear wrote:
>> On 2/27/26 08:31, Ben Greear wrote:
>>> On 2/23/26 14:36, Ben Greear wrote:
>>>> Hello,
>>>>
>>>> I hit a deadlock related to CMA mem allocation attempting to flush all work
>>>> while holding some wifi related mutex, and with a work-queue attempting to process a wifi regdomain
>>>> work item.  I really don't see any good way to fix this,
>>>> it would seem that any code that was holding a mutex that could block a work-queue
>>>> cannot safely allocate CMA memory?  Hopefully someone else has a better idea.
>>>
>>> I tried using a kthread to do the regulatory domain processing instead of worker item,
>>> and that seems to have solved the problem.  If that seems reasonable approach to
>>> wifi stack folks, I can post a patch.
>>
>> The other net/wireless work-item 'disconnect_work' also needs to be moved to the kthread
>> for the same reason....
> 
> I don't think we want to use a kthread for this, it doesn't really make
> sense.
> 
> Was this with lockdep? If so, it complain about anything?
> 
> I'm having a hard time seeing why it would deadlock at all when wifi
> uses  schedule_work() and therefore the system_percpu_wq, and
> __lru_add_drain_all() flushes lru_add_drain_work on mm_percpu_wq, and
> lru_add_and_bh_lrus_drain() doesn't really _seem_ to do anything related
> to RTNL etc.?
> 
> I think we need a real explanation here rather than "if I randomly
> change this, it no longer appears".

The path where iwlwifi acquires CMA holds rtnl and/or wiphy locks before
allocating CMA memory, as expected.

And the CMA allocation path attempts to flush the work queues in
at least some cases.

If there is a work item queued that is trying to grab rtnl and/or wiphy lock
when CMA attempts to flush, then the flush work cannot complete, so it deadlocks.

Lockdep doesn't warn about this.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

