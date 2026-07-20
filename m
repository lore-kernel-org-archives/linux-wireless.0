Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6D343E483
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 16:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784564762; cv=none; b=O0mLlnwvKVCKNgqlhSQfWAFa6pBJtOAHlXG/KTK8ej+C6KPUOwsq0VXScTljFlFFYAao54DTTA3H9QrYKpTxPusdt1is6cdWnBEvI/yHxPsht8NDXLs9O+1G6vvylgbwkQCjF8/eRBXrYH8Z9QGquRz0HvAm5dlBHhQuJWxuHjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784564762; c=relaxed/simple;
	bh=/bUvZzyTiG+m8V4zU1L+YOGKZHVTgLFBddQwesVSmjc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=QJi+zITAJwvO8Z4piLnoygclD+nnHDnk0QDaKj2AK38k57pOQvvG7/P0z3vB8RnfTTxuD4pwad0HxBdQ3yySmU9UJeGWgZwPuE6SwDYBAJ/ITifGWkgTWBQQd7dKDVkh+xh7x1R7LyvuzIvUhk7hvJXTFyKXk5Wu+FTiWxnNpcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=adcosXux; arc=none smtp.client-ip=148.163.129.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="adcosXux"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 84B2F2A6DAB
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 16:25:53 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C4E7CC40078;
	Mon, 20 Jul 2026 16:25:45 +0000 (UTC)
Received: from [172.31.0.20] (174-21-95-71.tukw.qwest.net [174.21.95.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 70FD713C2B0;
	Mon, 20 Jul 2026 09:25:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 70FD713C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1784564743;
	bh=/bUvZzyTiG+m8V4zU1L+YOGKZHVTgLFBddQwesVSmjc=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=adcosXuxpV+lkWem/2aBA0CO+g6FSGcZ/0o0tUQMABqgKOOhou9ZaFhvBcGsTnuFl
	 Oi0pGaSds/q/SVlxEFQTHXgN1esEZrmh5B7sZp/9aYNqur+b4tkjPeftNpH1tCEwcA
	 f1jJPw5NUPtb10r1IcFIB+BexHhbS1RTNJmvRomE=
Message-ID: <a6c1fe34-bfe1-4a5f-906f-0959a86e37d4@candelatech.com>
Date: Mon, 20 Jul 2026 09:25:35 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: mt76: mt7996: remove beacon_int_min_gcd from
 ADHOC interface combinations
From: Alex Gavin <alex.gavin@candelatech.com>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, nbd@nbd.name,
 lorenzo@kernel.org
Cc: linux-wireless@vger.kernel.org, ryder.lee@mediatek.com,
 shayne.chen@mediatek.com
References: <20260702104337.679536-1-jtornosm@redhat.com>
 <20260720060432.7943-1-jtornosm@redhat.com>
 <407f7ac5-0e97-4c84-8272-c0f3cec3890c@candelatech.com>
Content-Language: en-US
In-Reply-To: <407f7ac5-0e97-4c84-8272-c0f3cec3890c@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1784564746-GdvjeQLHkHzK
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1784564746;GdvjeQLHkHzK;<alex.gavin@candelatech.com>;fc82d0c64e4f7319780297d333c27853
X-PPE-TRUSTED: V=1;DIR=OUT;

On 7/20/26 09:17, Alex Gavin wrote:
> On 7/19/26 23:04, Jose Ignacio Tornos Martinez wrote:
>> Hi Felix, Lorenzo,
>>
>> Just a gentle ping on this patch when you have a chance to take a look.
>>
>> It fixes a device registration failure (-EINVAL) for mt7996/mt7992 
>> devices
>> introduced by commit 5ef0e8e2653b. Without this fix the device is 
>> completely
>> unusable, as cfg80211 validates all advertised interface combinations at
>> registration time and rejects the entire driver.
>>
>> Please let me know if there is anything I should improve or change.
>>
>> Thank you for your time
>>
>> Best regards,
>> Jose Ignacio
>>
> 
> This patch fixes driver initialization in my testing. I had previously 
> used this patch [1] from OpenWRT's tree as a workaround. I have not done 
> any testing with IBSS/ADHOC interfaces, though.
> 
> 
> Best,
> 
> Alex
> 
> [1] https://github.com/openwrt/openwrt/blob/main/package/kernel/ 
> mac80211/patches/subsys/220-allow-ibss-mixed.patch
> 

Tested-by: Alex Gavin <alex.gavin@candelatech.com>

