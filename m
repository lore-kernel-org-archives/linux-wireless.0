Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [185.244.194.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B6C4ABBB8
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 15:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.244.194.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791820367; cv=none; b=db6+0GO/3qzRGDmSQ5g+geBypBpGJqV6sLdl3dmSSzIAbwzO8xOYRKNmw7eQc1KNeIr3qG741fpyhfzKTAvSS1A4Vl0UOtkPmPQpue3Rrkwkb6hqEa9FNZGfrqyblxa0XGc0UirgJoM0WYCeNGewLCZD7A4hfUru2NSVZCJg0vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791820367; c=relaxed/simple;
	bh=hygyd5zmMGXvFm7+2BspxyK/OLvbvLr1S1Fr2zHUSPU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=psl1Hwr7xSeZMLnjz8VoYit4VCGfaHLASdMLMeHDxRMI94uh8dulb5VJ4pAcEAJSWrgJHzcNLHNdntiuI3fRtzmyqSU6e9Puff4myQN5nG8IMumCQWgZDl42AEYERk8ipZabMC3n1uOI1AJnnAymxQ7hDxUEtJGy4dl2J1BQwDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=WnUu+Lla; arc=none smtp.client-ip=185.244.194.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="WnUu+Lla"
Received: from relay01-mors.netcup.net (localhost [127.0.0.1])
	by relay01-mors.netcup.net (Postfix) with ESMTPS id 4j3MRv3gLcz9Ly1;
	Mon, 12 Oct 2026 17:52:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1791820363;
	bh=hygyd5zmMGXvFm7+2BspxyK/OLvbvLr1S1Fr2zHUSPU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WnUu+LlaEqfFte+mag0SfeGGibZt+e2gjIn83vS1VlrKCxF/k337Un/jr4+HesNjN
	 QeWLH6AAn5iPQ6BRAnb3X7L3M791TCKUNrv3SgxVhHOhZC+vozGMKVTZ0den+SS0rx
	 Nc+iC1LIiW+e54b6gw6UZ9OP7/cDwCKZ1M89v70jt+/3jkVZ57U6+sC1eOIzN+Vojx
	 doRWy7vme4tup2Ou3NtKvYKu7aAzO2U1SGftqfbpGiGNPjMJ5O1v8EPDH8Jq9zZpPp
	 BRZsJqQUoat8uwzGcIdqFiVGbPXYy+HGYDMdf+n4lVmxQeSExrHGPSMz6y/BQVbYt6
	 r6rK+gQbeC68A==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by relay01-mors.netcup.net (Postfix) with ESMTPS id 4j3MRv2zTXz7wZy;
	Mon, 12 Oct 2026 17:52:43 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4j3MRt5hk4z8svT;
	Mon, 12 Oct 2026 17:52:42 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 3330D5FA0A;
	Mon, 12 Oct 2026 17:52:42 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <e320fab5-d4d4-40fd-b032-d64554e5c0b0@leemhuis.info>
Date: Mon, 12 Oct 2026 17:52:41 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] iwlwifi IO_PAGE_FAULT and Master Disable Timed Out
To: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
 Chris Bainbridge <chris.bainbridge@gmail.com>,
 "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "Berg, Johannes" <johannes.berg@intel.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <amzVtgQb2p-_nShU@debian.local>
 <DS0PR11MB78800B96A0FE637DC5390E4AA3D62@DS0PR11MB7880.namprd11.prod.outlook.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: 
 <DS0PR11MB78800B96A0FE637DC5390E4AA3D62@DS0PR11MB7880.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <179182036254.916946.193245867647113137@mxe9fb.netcup.net>
X-NC-CID: O65oeUgYbdELQmmjMuZizHrhAiH0KDrimmTzhhciNC9tT/bRvUE=

On 8/2/26 09:24, Korenblit, Miriam Rachel wrote:
>> -----Original Message-----
>> From: Chris Bainbridge <chris.bainbridge@gmail.com>
>> Sent: Friday, July 31, 2026 8:05 PM
>> To: Grumbach, Emmanuel <emmanuel.grumbach@intel.com>
>> Cc: Berg, Johannes <johannes.berg@intel.com>; Korenblit, Miriam Rachel
>> <miriam.rachel.korenblit@intel.com>; linux-wireless@vger.kernel.org;
>> regressions@lists.linux.dev
>> Subject: [REGRESSION] iwlwifi IO_PAGE_FAULT and Master Disable Timed Out
>>
>> 0eaa1f245ac0 ("wifi: iwlwifi: mvm: don't support the reset handshake for old
>> firmwares") introduced an intermittent boot regression on my laptop:
>> [...]
> 
> Yes, seems like you are right.
> Thanks for the report!
> 
> I am attaching a fix candidate, I'd appreciate if you could test it.
Miri, Chris, what happened to this regression fix? From the outside it
looks like it fell through the cracks, but well, it's easy to miss
something from there, that's why I'm asking.

Ciao, Thorsten

> From 825098f2de2bc63e5ce180213d9fad040f644fb2 Mon Sep 17 00:00:00 2001
> From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> Date: Sun, 2 Aug 2026 10:16:13 +0300
> Subject: [PATCH] wifi: iwlwifi: mvm: properly check the FW version
> Organization: Intel Israel (74) Limited
> 
> The mentioned commit aimed to disable fw reset handshake for FWs which
> their API version is less than 77.
> But the check is incorrect: in the old format, we should use
> IWL_UCODE_API, and for the new TLV format - fw.ucode_ver.
> Since iwlmvm handles only FWs with the new format, we can always use
> here fw.ucode_ver.
> 
> Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> [...]

