Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F349C53CA71;
	Wed, 14 Oct 2026 14:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986485; cv=none; b=AV4hecIFzXei/btBzmRYb3RwELXcOJS830eROl6manweHcWB3/if3Ajwbtguxnvwb15YaIy03TLBLYBx3PTMOWRMU9JqHyrLhNvZzKho44uwuyeHhXkSM4UEp2+xDPiA8GHkiVPOToIMtK/sGCcq1blA21wNSBDTs2HaS6eJ8eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986485; c=relaxed/simple;
	bh=VVqUpLIr6hwDyUujSgCjZbQGFEBvkJMBUVsT0nmXs40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KexQQaqopKGXQphnC5qfMoIe3XTQI+rPBma2KSsE8J/xUHigA8JKmMNEaLVWboxigEYnwGyQeF/W3QExZcDY+3tvuVSXU2/+rUb1KOQto3qNitDxsxrxF5wLd1BAWBmtfOWKfZYS7TO29xoyV89HQ+mVRMPDvVCclS9IMDyLvg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=BgCTta/w; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="BgCTta/w"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6B0BB2400A9;
	Wed, 14 Oct 2026 14:01:11 +0000 (UTC)
Received: from [192.168.1.23] (unknown [98.97.36.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id A592813C2B0;
	Wed, 14 Oct 2026 07:01:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com A592813C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1791986470;
	bh=VVqUpLIr6hwDyUujSgCjZbQGFEBvkJMBUVsT0nmXs40=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BgCTta/wrclsuYkxXt+DLq9Ue6zjfARjph9k+OyolG+ry4eN5aHR7GeIRy0FgcGX2
	 y2zDPq0fwUD4nLa+6+pUUfcRzm5jqouGQD8pIySzOwSgkME0df5lXkxHYcc2rZ99Lm
	 L/Mof5BwaGNXLNnm/8GammwqaR82ApI06W3Vrll0=
Message-ID: <04b8b928-b671-4236-a792-1141cd81a34b@candelatech.com>
Date: Wed, 14 Oct 2026 07:01:10 -0700
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
 <eb405366-6574-4e4c-a89d-363751ed848b@candelatech.com>
 <4175721788798939@f00554c7-d809-471c-9bcf-78e5d8eceab4>
 <1556871789207706@7dc9deb3-4292-4932-8568-de9b411208d8>
 <1443771789748846@4a8ec5ae-80ed-44bc-b7d3-6bc660c90136>
 <211851789913261@df1900ea-d467-4ed7-a7f1-de68a4c3e6dd>
 <143991791036721@40be7595-980b-4665-ba66-1601e10a0899>
 <c4286904-2a9a-41fd-93ce-be57964909f6@candelatech.com>
 <221941791052355@558b3e58-c2b1-4e14-91fe-beb5649d18f6>
 <5955851791966910@d362902e-9931-4ad0-8e86-72401cc67703>
Content-Language: en-MW
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <5955851791966910@d362902e-9931-4ad0-8e86-72401cc67703>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1791986472-9G5xvht-Puv2
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1791986472;9G5xvht-Puv2;<greearb@candelatech.com>;6f76c88c2c731de9ad886e575864f8cc
X-PPE-TRUSTED: V=1;DIR=OUT;

On 10/14/26 01:35, Ilya K wrote:
> OK, so I took some time off of this because of real life, but during that time, my 7.2-stable-with-Ben's-patches frankentree actually crashed! I am not sure if this is the same issue or a different one, but I thought it's at least interesting.
> 
> Here's the logs from the ~hour when it crashed (exported from Loki, so sorry for the weird format): https://gist.github.com/K900/e2e5b21d6a49f450fe353c7cc3057916
> 
> If there's any more info you need, please tell me.
> 

Well, not exactly a crash, but the system stopped being able to talk to the radios it seems.  Error is 12, which is ENOMEM,
so possibly memory leak or something like that is causing trouble.  Or maybe firmware is just wedged and the ENOMEM is a symptom
of that.

You might try the latest mt76 tree from Felix, it recently gained a large number of fixes.
Maybe that made it into wireless-next tree as well, not sure.
We're working on pulling Felix's patch series into our tree, but not done with rebase yet.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

