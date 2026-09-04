Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239D63783AF;
	Fri,  4 Sep 2026 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538866; cv=none; b=DYE/x/9KynxFyYIZu4j8PkEjzb0brK6sxjFggE1AmspAVL79AYen3QI1ImuwrLPtudXtBa3zxVAEH7/NXEXtXVckEc3W7MvVyRZF9ungHVftkGvs05QuzICzIKL6WA8n061lc9C7yvMvdUNqQlDpXmokvQ08NVchFacM1Gr1aYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538866; c=relaxed/simple;
	bh=CZ4bX4F6PSEhTLlZpD0mtDFxKqPvIwiS/pvOwbtl71Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mX8HlnY2i1NRsmxejhiCkgF4vBi0H92ovVNKHTsSXsRw5y/t5AzPP5bshOyRIbvbffn7Zq9b+Bh27Thy4QfrjYz20SVhVbjmz91EGP4wmq5ngVCbHCDHL+6dehqMtnkQLJbLe6kBarDraMaaAzUb00osPfDUfqSOYKSkCbvnuqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=ZbDLmJ+o; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="ZbDLmJ+o"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0DDB634006E;
	Fri,  4 Sep 2026 16:20:56 +0000 (UTC)
Received: from [192.168.100.159] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 09E7313C2B0;
	Fri,  4 Sep 2026 09:20:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 09E7313C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1788538856;
	bh=CZ4bX4F6PSEhTLlZpD0mtDFxKqPvIwiS/pvOwbtl71Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZbDLmJ+omTBJC9EX1VXfLQB5O+L1AkFUCyKevIW6t7d9BrvjpZcQih0pQSaTwqbrv
	 06ymwTEmMIRJr4FrAsrZ3k1AlmZ3FjcfM7NaOJqGKeu180Nr928wupIck06/64MQ39
	 McBN4oYK37AXz1t9zWSm8VhR6zi1G6HZ5+wpib1A=
Message-ID: <3acf531c-bcc7-412b-b3bb-665069260e46@candelatech.com>
Date: Fri, 4 Sep 2026 09:20:55 -0700
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
To: Ilya K <me@0upti.me>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-mediatek@lists.infradead.org
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd>
 <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com>
 <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615>
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1788538858-B9LB1mY0FrGP
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1788538858;B9LB1mY0FrGP;<greearb@candelatech.com>;6f76c88c2c731de9ad886e575864f8cc
X-PPE-TRUSTED: V=1;DIR=OUT;

On 9/4/26 09:11, Ilya K wrote:
>> https://github.com/greearb/linux-ct-7.2
> Hoo boy that's a lot of patches. Anything specific in there, or do you want me to just rebase my changes on that entire branch? I can try, I guess, but probably not today...
> 

I don't have a good answer for you...it *is* a lot of patches, and I'm not sure if any of it
would actually help your system.  We do have this kernel working for an ARM based AP that uses
mtk7996 radio, and at one time it compiled for bpi4, but I'm not sure bpi4 still
works as we do not test it.

If you can get it to compile for your system by adding any needed patches on top, that is likely best
approach, and if that actually solves the problem, we'd be happy to consider adding any bpi4 patches
to our tree.

./build_bpi4.bash may be of some interest...that is how we built it back when we did try to support bpi4.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


