Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAAC435500
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 16:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784564283; cv=none; b=kSwthdxH8skf/Iv8J8YnzPW5k8pj7tQisml37nTks5dyTR3V3L0HoyYUE2BYz/BreiWb8kQNvuv5DgL73tTe+lLhkXdkFoDC7UKZHxDTMZI9m5nrz63lfgv0aWVuLq54WJfhauGCkJVF0AVd0tWzZVKsDfROh9ZCIx6agYPb4eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784564283; c=relaxed/simple;
	bh=cVk/mZXNjxj5oVAO2rOr3izfZa9EBTGieOTS1gVFI/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QkBbrmb+ZPmhMBpPVi/Bi5qBhX5eXEt+w8ylEcSFYkZ6eAHUsV0IVCz6N/EM1VZMESD2FBlupJoGyylEyyRgPt32vZxjsakw6KIqtY5orWeFiHYkCpovnZtWLLWMAGb7MMaUWqA1s8y7L4zpEa3SEowE2Ams7+NPX5J1UTAQyVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=oxZhdy75; arc=none smtp.client-ip=148.163.129.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="oxZhdy75"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8C5F42C42B0
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 16:17:48 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E5BBDAC0085;
	Mon, 20 Jul 2026 16:17:39 +0000 (UTC)
Received: from [172.31.0.20] (174-21-95-71.tukw.qwest.net [174.21.95.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 776F413C2B0;
	Mon, 20 Jul 2026 09:17:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 776F413C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1784564257;
	bh=cVk/mZXNjxj5oVAO2rOr3izfZa9EBTGieOTS1gVFI/E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oxZhdy75VvMZvlfM0E2GuHKtmCWD/ZP2U2i2vEEvuP3WCRVM+HyS2rBA7KZ3ZR7qt
	 dRISnVWUsoIc8o1of1nkeryEU0OQ8d6bV9zNZLj/v3KHWuruT6Wq/uU+idffPvH0Xn
	 IiJxXh28Lf98nYCCx+KzINp3kYIfotjc5/ocNLWQ=
Message-ID: <407f7ac5-0e97-4c84-8272-c0f3cec3890c@candelatech.com>
Date: Mon, 20 Jul 2026 09:17:29 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: mt76: mt7996: remove beacon_int_min_gcd from
 ADHOC interface combinations
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, nbd@nbd.name,
 lorenzo@kernel.org
Cc: linux-wireless@vger.kernel.org, ryder.lee@mediatek.com,
 shayne.chen@mediatek.com
References: <20260702104337.679536-1-jtornosm@redhat.com>
 <20260720060432.7943-1-jtornosm@redhat.com>
Content-Language: en-US
From: Alex Gavin <alex.gavin@candelatech.com>
In-Reply-To: <20260720060432.7943-1-jtornosm@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1784564261-io7oc5bBX02Y
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1784564261;io7oc5bBX02Y;<alex.gavin@candelatech.com>;fc82d0c64e4f7319780297d333c27853
X-PPE-TRUSTED: V=1;DIR=OUT;

On 7/19/26 23:04, Jose Ignacio Tornos Martinez wrote:
> Hi Felix, Lorenzo,
> 
> Just a gentle ping on this patch when you have a chance to take a look.
> 
> It fixes a device registration failure (-EINVAL) for mt7996/mt7992 devices
> introduced by commit 5ef0e8e2653b. Without this fix the device is completely
> unusable, as cfg80211 validates all advertised interface combinations at
> registration time and rejects the entire driver.
> 
> Please let me know if there is anything I should improve or change.
> 
> Thank you for your time
> 
> Best regards,
> Jose Ignacio
> 

This patch fixes driver initialization in my testing. I had previously 
used this patch [1] from OpenWRT's tree as a workaround. I have not done 
any testing with IBSS/ADHOC interfaces, though.


Best,

Alex

[1] 
https://github.com/openwrt/openwrt/blob/main/package/kernel/mac80211/patches/subsys/220-allow-ibss-mixed.patch
