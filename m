Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0249B4DA9A4
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790024157; cv=none; b=TPkegbpSVQBssEXf5e1MHGoq96tFMTtY3n4Oqmf5KLi+JjrEQWl58GneQ2rloVSIQHRYVFMh0tYDbJshBBlEZRxeI2g9kjW81JsDKPxEwddbqTFf0nRIveOcqPF4kV+ZwfCRhf/yR50a87XRT4YV5ZNjVYTm1mMGM8aY/COPSoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790024157; c=relaxed/simple;
	bh=m6wML1zkRSmO0pfp2qNennGlNbcbSTKl0fZ/50RMKLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nIGalcpSLCGHPABzzZ7u1OekCudDDNb155j7I2fXZ8nFi/kFz3DiVrIK2zcz7tGRS0v4XU/2w8nZejr6MMCv3w5pYl+yo7V6+Ql1RnazkGpdE5GT2DP9GIJ4Y9j+yiMgtlYeOsv8Sw2oLachJQ2TAvD1rjflSBzJC/PdhBwCgDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=WX7VgCz2; arc=none smtp.client-ip=148.163.129.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="WX7VgCz2"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1DFE71C0073;
	Mon, 21 Sep 2026 20:55:52 +0000 (UTC)
Received: from [192.168.0.38] (unknown [136.27.42.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 4222F13C2B0;
	Mon, 21 Sep 2026 13:55:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 4222F13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1790024151;
	bh=m6wML1zkRSmO0pfp2qNennGlNbcbSTKl0fZ/50RMKLE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WX7VgCz2py1wMfGdhh2l/d5Wr39MaawvltlemR5x09WzXLHv4zsZUhHgaCF487Klh
	 AioPHtrYCa3T7i8yQeOMo40XrN8EQqhParawtVj3lICCMtSZyOKGaZp9ognoXsCgMC
	 /C3yaA7ct/tSY8snsd+rJsyeh00CuErjSeGRwzDQ=
Message-ID: <af8ee959-a35e-4bd3-ab34-7836f1517fca@candelatech.com>
Date: Mon, 21 Sep 2026 13:55:50 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2] net: cfg80211: validate monitor channel
 set against radio usage
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Dylan Eskew <dylan.eskew@candelatech.com>
References: <2318ac388c0da7a200c8a1aec0d0af662fdf1ba8.camel@sipsolutions.net>
 <20260921184605.2699-1-roryl@candelatech.com>
 <289eaefe3389894758d3ba1b3d24aa73aa630d91.camel@sipsolutions.net>
 <f7788e68-3292-4337-943a-032a838947fe@candelatech.com>
 <63e5e755ce0b8390864f36c9e2eb74cf5749b5e7.camel@sipsolutions.net>
Content-Language: en-US
From: Rory Little <roryl@candelatech.com>
In-Reply-To: <63e5e755ce0b8390864f36c9e2eb74cf5749b5e7.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1790024152-dc8muM9yVVPI
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1790024152;dc8muM9yVVPI;<roryl@candelatech.com>;b42792dba290a1257c3f0aaf1c60b0ff
X-PPE-TRUSTED: V=1;DIR=OUT;

On 9/21/26 13:20, Johannes Berg wrote:
> On Mon, 2026-09-21 at 13:17 -0700, Rory Little wrote:
>>>> - Handle error return from cfg80211_get_radio_idx_by_chan
>>> Yes, but did you do it correctly? I don't think so?
>> You mean propagating -EINVAL out to the caller, right? I'd need to
>> handle the n_radio == 0 case to keep the -EBUSY behavior consistent.
> Yeah, I get that, but it seemed tgo me it should return true (accepting
> the channel change) - but then again maybe not, since it already accepts
> "only have monitors", and then getting there means there's something
> else ... sorry.

Yeah, if we are there then there are other interfaces up, so rejecting 
at that point keeps the existing behavior. I'll add a comment clarifying 
that.

On a different note, I also noticed that this introduced an issue - 
cfg80211_has_monitors_only also verifies that there is at least one 
active interface. This patch loses that verification for multi-radio 
wiphys. I will fix this in v3.

- Rory
