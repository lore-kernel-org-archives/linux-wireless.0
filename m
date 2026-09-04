Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CD33E63B2;
	Fri,  4 Sep 2026 16:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538069; cv=none; b=jMzrCO5AJCUughfin8FQboaUaKCTMex6wHWkI6qViY+vCXnV3kqQsAdggvgfR87HfAbqgooDqhg5PWD5ahLcAyRPt1V+S8upyoRiipYyk+h6yibFg+ooi92OQVP2XV7NbutTZE30+6EBdoLfdGM5PXr0geEu077CZDIWUA55UCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538069; c=relaxed/simple;
	bh=ri1r9OnJf92OGYlpu54n35ueeIP1GvO4Q8BuBCanV2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g0NJREpcXTNoLQdxI0Lfu7PFsHH7ENzj5nbZZyyY/1GMf5BRCM3gcZ2BBGfcKteksvfWepqdVEnFK0LXKRkEesRHx6hYAhZS+SuXdtphGOV1nI9qlhs2zzmCUdzcxPe3cDwoER32wXxY52ycKnTPeSeXiNO+W4NSDB/cRbfKO2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=qp6LQCR4; arc=none smtp.client-ip=67.231.154.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="qp6LQCR4"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A31E68008F;
	Fri,  4 Sep 2026 16:07:32 +0000 (UTC)
Received: from [192.168.100.159] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 02D9D13C2B0;
	Fri,  4 Sep 2026 09:07:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 02D9D13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1788538052;
	bh=ri1r9OnJf92OGYlpu54n35ueeIP1GvO4Q8BuBCanV2I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qp6LQCR4F0yvQLRKIogLnglDTsF5IwPwyh6O7Zg+JR/jPVFl9o0vgf0Sqmqjpq0qZ
	 5dN2a2V38PrBwQWfAqBFbRQAPDBr0QhfpsRVKFgS2xH6wRByapv5xQq4WMPkEm+qEb
	 Z9VKSky/zR7UcBtIiXcIoXKRg7q3aDyJE3W9bV3w=
Message-ID: <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com>
Date: Fri, 4 Sep 2026 09:07:31 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [bug] Triple whammy of mt7996e bugs on 7.2+
Content-Language: en-US
To: Ilya K <me@0upti.me>, linux-mediatek@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd>
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1788538053-BglbB7lMUdBY
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1788538053;BglbB7lMUdBY;<greearb@candelatech.com>;6f76c88c2c731de9ad886e575864f8cc
X-PPE-TRUSTED: V=1;DIR=OUT;

On 9/4/26 07:28, Ilya K wrote:
> Hey folks,
> 
> Not really sure where to report this, but I've encountered some "interesting" issues on my bpi-r4 running kernel 7.2 and up.

Hello Ilya,

In case you feel like experimenting, I'm interested to know if this kernel
works better for you.  We have some tx-hang work-arounds for mtk7996, among
other things:

https://github.com/greearb/linux-ct-7.2

We have not tested on bpi-r4 anytime recently, however, and never used WED as far
as I am aware.

Thanks,
Ben

> 
> The first issue is that after a while the firmware on the mt7996e sometimes seemingly just locks up.
> As it usually is with those things, there's not much debug info available, so all I get is
> 
> [58764.004954] mt7996e 0000:01:00.0: Message 00130022 (seq 12) timeout
> 
> This has happened before, but very rarely, and now it seems to happen consistently at least once a day or so, on
> the exact same setup that is stable for weeks on end with 7.1. I have not attempted a bisect yet because
> 1) I kinda need my network to actually work reliably and 2) it happens so inconsistently that it's hard to
> pin down a good commit.
> 
> The other issue is that the kernel then fully explodes trying to recover from this, in two different ways
> depending on whether WED is enabled or disabled: with WED on, it tries to double free a page somewhere on the
> teardown path, and with WED off it just wedges seemingly all of nl80211 and any process that happened to be talking to it.
> 
> I'm attaching the logs for both cases, hopefully this helps figure out what's going on, and happy to do more testing if
> needed.
> 
> For posterity, my current kernel tree is basically vanilla + just enough changes to get bpi-r4 10G ports working on NixOS:
> - 7.1 branch: https://github.com/K900/linux/tree/bpi-r4-71
> - 7.2 branch: https://github.com/K900/linux/tree/bpi-r4-72
> 
> (there are exactly zero *80211/mt76/mt7996e changes).
> 
> Oh, I've also tried pulling the latest firmware from vendor OpenWRT feed and that did not help matters at all.
> 
> Any help in figuring this out would be greatly appreciated!
> 
> - Ilya
> 
> 

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


