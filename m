Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3AB51D512;
	Mon,  7 Sep 2026 16:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788799122; cv=none; b=Yy19lmIyrC07fAdULvwetdHC6skwjfRjdxJdysJILR1DxnVpMNftRg3/zgYKhjvsUDA8Zf4GExt2ZcokUTmzkNVkF8Wrll1PLcE5Vlltgw61tP+WSuPYMD9LPrcVKgFRtcSRjLotoXmgnavACswUNqHL0L+CKcda7iq/IKN6h4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788799122; c=relaxed/simple;
	bh=0jap3ZDKcYB9NpovB34NodaYGLRQNOA87oMfzixSoDc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VnIPB+nIjfVeNkbFRsLctthQxRHqvlKnrsR540GWw2o6TrHyTpq6tvFZpY1B8+SP0EFKztE7WVVjtSTXbUy5ODS7Mkc9wN6ABnhFVVCzYBgPa4BFCTd2SoXBLbDsjE0W8TDgP++HcXI/u2XI+ipKc7n8ibygRh5fNwMtT2M4uO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=b+M1y5rE; arc=none smtp.client-ip=148.163.129.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="b+M1y5rE"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 85CBD2A5342;
	Mon,  7 Sep 2026 16:30:41 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2B1851C0077;
	Mon,  7 Sep 2026 16:30:33 +0000 (UTC)
Received: from [192.168.3.187] (unknown [98.97.32.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 5ED3513C2B0;
	Mon,  7 Sep 2026 09:30:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 5ED3513C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1788798632;
	bh=0jap3ZDKcYB9NpovB34NodaYGLRQNOA87oMfzixSoDc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b+M1y5rE1xdBy4i+oy/zYD3L+1rBaAApiScuYqt3tHSlzIEfZlgXml5O9c3e7gkcA
	 3oakjFv806GSgyFouKq4nKfhvvthUnqFUmvsJ93Fuxp5Fiv95VNKDvu6cERfy1MtsN
	 efVNc7bmb3Fj80bC/OmvinGynRJv2Zebkj7688Gk=
Message-ID: <eb405366-6574-4e4c-a89d-363751ed848b@candelatech.com>
Date: Mon, 7 Sep 2026 09:30:31 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug] Triple whammy of mt7996e bugs on 7.2+
To: Ilya K <me@0upti.me>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-mediatek@lists.infradead.org
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd>
 <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com>
 <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615>
 <3acf531c-bcc7-412b-b3bb-665069260e46@candelatech.com>
 <2028561788553569@f088f4ec-f441-47a1-b7e4-75a1052aa4df>
 <2418461788691106@84aa39c5-f501-4e64-8418-6a8b6eb88e21>
Content-Language: en-MW
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <2418461788691106@84aa39c5-f501-4e64-8418-6a8b6eb88e21>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1788798634-Qedb_RYpJlvj
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1788798634;Qedb_RYpJlvj;<greearb@candelatech.com>;6f76c88c2c731de9ad886e575864f8cc
X-PPE-TRUSTED: V=1;DIR=OUT;

On 9/6/26 3:38 AM, Ilya K wrote:
>> This abomination is now booted on my hardware and I'll get back to you if it explodes again, which I'd expect to happen at some point
> during the weekend at worst (and if it survives longer, that's already an improvement).
> 
> OK so it's been over a day with no explosions which is already better than its previous best. The question now I guess is: which one of the patches actually fixes it? And do the teardown paths still need fixing?
> 

I don't know why your kernel wasn't working to begin with, so not sure exactly what in our tree would
fix it.  We do have some mt7996 tx-hang work arounds, but that bug was reproduced in STA mode in a fairly weird
test case with lots of virtual STA vdevs, so not sure it applies to your case.

Possibly too it is something we pulled in from Felix's tree that will likely be in 7.3
kernel.

As a note, we found a regression in our current 7.2 tree, MLMR has regressed with scan failure being the
symptom, hopefully we'll get that fixed this week.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
