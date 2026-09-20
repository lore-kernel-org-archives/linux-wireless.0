Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F44832AABD
	for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789915790; cv=none; b=MERaWJg0Spdo8gFt4xPGO8oI0lJnkq7vcN9OsNbq+9rX84HY5SSeHZWmOdtwYcruREKNOkZzwfJhhDQiFhjUvApGFJlaCFHYCjdGAuULkhh9psLHJ1LR93AmEr0OENTi8JkO41OQSeD/ZVxe/2vj4dQS8277TNcCYDKxPTbT1lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789915790; c=relaxed/simple;
	bh=HOypawCg01zp6a+LrYrKj3sXWu5oOMxRj3XL5TVBPdA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e9s6+CLdbJyBeDaS6XcFF+awGTZ82vrCMpoxVuLtsCsjojijfhqxCTWXqfTxIhjtPWdlRivA0c7+j/PW1LscDGeOSewfND95C4jtI99C1vpAB4IRh7a6gvWTOs1b7MQtHQG+LR2fGrnIzvoSsgEC+UVplm7XgjKUasn4EFYtHiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=kcVBhjje; arc=none smtp.client-ip=67.231.154.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="kcVBhjje"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 517B980007E;
	Sun, 20 Sep 2026 14:49:40 +0000 (UTC)
Received: from [192.168.1.23] (unknown [98.97.32.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 47C8F13C2B0;
	Sun, 20 Sep 2026 07:49:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 47C8F13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1789915779;
	bh=HOypawCg01zp6a+LrYrKj3sXWu5oOMxRj3XL5TVBPdA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kcVBhjje2TL4/pY9DtYSXFiqDRytLAq6MfoZMY46tJjO6HviWlecDrEMNAy3PiP6b
	 tx6gAg71Mlp60Luu6V2nN3210juROFd01VQ8bmT5Q8iQaLlj5TxLRfQpFbKeh8YWSH
	 PAlrp3anUik9IkHcAFZNC6q+vtmGhaFl0LNPwp7k=
Message-ID: <599b4d0d-31fa-4466-bfdc-8185d6c0ee5d@candelatech.com>
Date: Sun, 20 Sep 2026 07:49:38 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/2] wifi: mt76: disable NAPI before deleting in dma_cleanup
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
 nbd@nbd.name, lorenzo@kernel.org, Shiji Yang <yangshiji66@outlook.com>
References: <20260916204750.1439984-1-greearb@candelatech.com>
 <20260920034907.199687-1-lucid_duck@justthetip.ca>
Content-Language: en-MW
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <20260920034907.199687-1-lucid_duck@justthetip.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1789915781-QqhLh0O8VnRk
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1789915781;QqhLh0O8VnRk;<greearb@candelatech.com>;5a03f558aff5a5117b3feee4b78a8f35
X-PPE-TRUSTED: V=1;DIR=OUT;

On 9/19/26 20:49, Devin Wittmayer wrote:
> On 9/16/26 13:47, Ben Greear wrote:
>> +		napi_disable(&dev->napi[i]);
>>   		netif_napi_del(&dev->napi[i]);
> 
> Ben,
> 
> The warning and the softirqd spin are both real, and your 2/2 looks like
> the right place for them.
> 
> On 1/2 there is a snag. mt7921e and mt7925e already stop RX themselves,
> and they do it early:
> 
> 	mt76_unregister_device()
> 	napi_disable() on each rx queue
> 	tx_token_put()
> 	mt792x_dma_cleanup()
> 
> It has to be early. A poll still in flight can come back with a transmit
> status and take an entry out of the table tx_token_put() is tearing
> down. By the time the shared cleanup runs RX is already stopped, so a
> second disable there just sits:
> 
> 	task in D state, refcount -1
> 	napi_disable_locked <- mt76_dma_cleanup <- mt7925_pci_remove
> 
> That was on MT7927. The USB parts tear down a different way and never
> arrive, which is probably why this is easy to miss.
> 
> Would putting the disable next to the IRQ and tasklet work in your 2/2
> cover mt7996? That keeps it where the driver already knows whether it
> has stopped RX.

I have a hard time figuring out exactly how to safely tear down
the mt7996 driver, especially without breaking other mt76 drivers.

But instead of just playing whack-a-mole with this,
we should figure out if sub-driver or mt76 core should be handling this,
and add some comments of expected behaviour so we don't keep fixing one chipset
and breaking another.

Maybe Felix has an opinion on correct path forward?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

