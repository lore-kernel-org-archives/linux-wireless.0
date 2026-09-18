Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED277502546
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 15:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789744984; cv=none; b=MeqsLkLD8CeBsO0MU1RTJcm1tvPuME5UC6gwYDWsqEPUaUR16jsyNMEiY+ieBHKYoewHPDvEMIZ9D3UG5lkmrsBCk6WEstHegvotYUs1ly9ye8rI3a2CX5FfBl8ztaMeNSwJgjqBVCItrpXxRel5iPshnQb2TlzDNl43IEdtP34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789744984; c=relaxed/simple;
	bh=sElqZatLM/nOH+Y4AxoF6DMC5G1j9UBzR/razStA3Qs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e0oiSo/imqAbmzfjEyuYC+JDxJPZb/yfoxfE3bdT5br7g/Ac1n1F3wT6XfZ8x+HXwwERhP3+Nbfjpbu657vt6n7qJZJ1C0HcXLNNj2vsdTYCC2MVMx8umWDPGiE1BwLNfsV251rOcxOEEvySvhzZ+8L+/CQqUJHL/wjwWSZcMzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=RGgZ/Cu1; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="RGgZ/Cu1"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1ECE93C0077;
	Fri, 18 Sep 2026 15:22:55 +0000 (UTC)
Received: from [192.168.1.23] (unknown [98.97.34.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 3955D13C2B0;
	Fri, 18 Sep 2026 08:22:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 3955D13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1789744974;
	bh=sElqZatLM/nOH+Y4AxoF6DMC5G1j9UBzR/razStA3Qs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RGgZ/Cu1MLpfm5JT22H87SgeFbqirNrgPtgfWsvRPfID6ek/cZtk+YltX1GXZ+ctF
	 4shClKFLoxHc5UNJFAMEaKa/qK0b1BxIw8RuB6iEWaf268tb2G1nqBesirdld8+xhY
	 5jjd/Nwz6HpDUGT/Sqbp7cIQfn/uKq37uV3LoHX4=
Message-ID: <faccc8e6-eb5d-43f3-8180-4793d03388b6@candelatech.com>
Date: Fri, 18 Sep 2026 08:22:53 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/2] wifi: mt76: disable NAPI before deleting in dma_cleanup
To: Shiji Yang <yangshiji66@outlook.com>
Cc: linux-wireless@vger.kernel.org
References: <20260916204750.1439984-1-greearb@candelatech.com>
 <OSZPR01MB814065F2461844D2AA2A9788BC872@OSZPR01MB8140.jpnprd01.prod.outlook.com>
Content-Language: en-MW
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <OSZPR01MB814065F2461844D2AA2A9788BC872@OSZPR01MB8140.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1789744976-zIg6pKpv2vvw
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1789744976;zIg6pKpv2vvw;<greearb@candelatech.com>;ff7a3d4eb7a5e026633eec0e86f8b1bb
X-PPE-TRUSTED: V=1;DIR=OUT;

On 9/18/26 04:04, Shiji Yang wrote:
> Hi,
> This change will result in another regression. See:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3aa1dcaa4f6f5ae08936491e08bd456f331f2d40
> 
> Regards,
> Shiji Yang
> 

Thanks for the pointer.  Maybe we have to make the common code pay attention to the radio
type since different radio driver logic is acting differently.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

