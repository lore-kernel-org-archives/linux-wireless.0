Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FE4446060;
	Thu, 30 Jul 2026 17:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785434361; cv=none; b=RIjLkuCZ7Igem0WOgf0IdNsfKz3EojfgaY/hsx3+LBNgTJ+z0Ar8FRgKN/9Ujg66vc/SESmcDKH3n66euGvUjkonBU1QgXDwOHsGk9e1OGHvZKiLULPKAGtoNjCvhtAFMEZDkh2+M+GGkgyQ1xqLr07s2ZPO+h0gkosONMU0Mug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785434361; c=relaxed/simple;
	bh=S9Cc8eM2cpXMMfSn4ySm8aB11UTe57XuzbWczXOL2l0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=YhSNR8WT+xvsugDv08FXfM4ijUAoZlg5hAv+AbKcpESbm7QcbWNAHSBpNKCcD/W2IhBCyji5TH0hdgq2APcU0jJIx54kRDiF5yrb+ts+pzvMpWWLeT6uarNI8GtH6wY4TnAhR8KgjO0U873fgWvjY+l6dn18tMA8XxDldsJcP14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=gNgSZWzD; arc=none smtp.client-ip=67.231.154.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="gNgSZWzD"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5F8BF304865;
	Thu, 30 Jul 2026 17:59:19 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 730E7180077;
	Thu, 30 Jul 2026 17:59:10 +0000 (UTC)
Received: from [192.168.101.245] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id C8FBF13C2B0;
	Thu, 30 Jul 2026 10:59:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com C8FBF13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1785434347;
	bh=S9Cc8eM2cpXMMfSn4ySm8aB11UTe57XuzbWczXOL2l0=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=gNgSZWzDdEaugmC0wiuoNSfznSJszjCnRBnMxiyoIPI+xCxyBT7M0qvU7sTJhk0Jo
	 KBtRMIba+HVFWBwsfyVWg6A4A6wnNaU9wFWnjWnvBgoH3wQ919QXONaWPXaiP+FwR1
	 1+r6JkFYVcjNSfkz1dPDy3kHyEMUpMF/rXVXvcl0=
Message-ID: <897f899c-f7b3-4920-bb87-1dfb2fcdfcbc@candelatech.com>
Date: Thu, 30 Jul 2026 10:59:07 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] wifi: cfg80211: add fw_version device
 attribute for sysfs
From: Rory Little <roryl@candelatech.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20260728234726.27479-1-roryl@candelatech.com>
 <64aaccd3-7a96-48b6-9cdc-fede692351a5@oss.qualcomm.com>
 <fb6a4b6f-08a9-484c-b170-698673a711ad@candelatech.com>
Content-Language: en-US
Organization: Candela Technologies
In-Reply-To: <fb6a4b6f-08a9-484c-b170-698673a711ad@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1785434351-SJPB3PQVcptC
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1785434351;SJPB3PQVcptC;<roryl@candelatech.com>;ad53361cb16e13f6f29cc39f16bb8319
X-PPE-TRUSTED: V=1;DIR=OUT;

On 7/28/26 10:32 PM, Rory Little wrote:
> On 7/28/26 18:34, Jeff Johnson wrote:
>> On 7/28/2026 4:47 PM, Rory Little wrote:
>>> The firmware version is already exposed via ethtool, but is not
>>> accessible without an attached interface to create a netdev. Expose this
>>> info in sysfs to allow users to query it without the use of ethtool.
>> Curious what is the value?
> 
> Here are some that I have seen:
> 
> 10.4-ct-9984-xtH-011-33ec52c8
> ____000000-20251118163234
> ____000000-20251015213023
> DEV_000000-20240823172837
> DEV_000000-20220929104205
> 89.7207fc64.0 ty-a0-gf-a0-89.uc
> 
> Top one is ath10k with CT firmware, next four are an assortment of 
> Mediatek radios, bottom is Intel.

I just realized that I misinterpreted what you were asking about here. 
Sorry about that.

The value of an interface to query fw_version for us is to keep track of 
system info and generate valuable bug reports (we do our own firmware 
packaging, and certain issues that we encounter can be solved by 
changing firmware version). This particular commit was motivated by the 
desire to be able to query it in any system configuration, as we were 
hitting a case where it needed to be queried while no interfaces were 
attached to the phy (thereby preventing ethtool use).

- Rory
