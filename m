Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E333B5841;
	Wed, 29 Jul 2026 05:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785303648; cv=none; b=igWh71uE4HZwgv1PD0y9U1mDWgb1f1dx9XETBPY4qOCzSHsJjoxI4VegWLhpBjZaIow5rIoAwVzmTtPGEhjUwicJ6ivaEJNsD2ob2qzAJzTUiHEa4K80qxYs4f0Jz3t32mov/AJSriGTzKa7IzwNRWB5rNtqWKpmaG2StyT6xFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785303648; c=relaxed/simple;
	bh=j3ukjpRfKf60Rl9QvBOOs4QvXRIMAbDPkms1Rg04Zow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eWVvgpRYkDHmQswXBCyZJDME2BDy2xacPDBuJf+aqNmkBbUYr4mg389dv7Gaoi5H1PqCA+n+HSb8bnW1zabsEW/XVPfRrgJufi1z6J2aWnbZMh8oU+iAf0rF4F0jbo8bijKNfxyNybnGRWu7SLyR5oGXnw4Ks2y4HkBfBybWkgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=Im7apfUU; arc=none smtp.client-ip=148.163.129.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="Im7apfUU"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7A5F92C87EE;
	Wed, 29 Jul 2026 05:32:24 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2776FC40077;
	Wed, 29 Jul 2026 05:32:15 +0000 (UTC)
Received: from [192.168.0.26] (unknown [76.121.133.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 77D2713C2B0;
	Tue, 28 Jul 2026 22:32:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 77D2713C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1785303132;
	bh=j3ukjpRfKf60Rl9QvBOOs4QvXRIMAbDPkms1Rg04Zow=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Im7apfUUTOIN+L2g5xxaTeTsyki92JDwc98Xi+bnUHuPp/RRV15m5xGbBgZ2RGrqN
	 k24aCuR8MmdbeCa6xDv6vH986RQ17RiikiVQOXaGy83tIlddOYeNhH/zVQnmZXY7lj
	 g4sm5X6e+zB1tL9e5J63RW4qqt+FeIMV0XIMplk8=
Message-ID: <fb6a4b6f-08a9-484c-b170-698673a711ad@candelatech.com>
Date: Tue, 28 Jul 2026 22:32:05 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] wifi: cfg80211: add fw_version device
 attribute for sysfs
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20260728234726.27479-1-roryl@candelatech.com>
 <64aaccd3-7a96-48b6-9cdc-fede692351a5@oss.qualcomm.com>
Content-Language: en-US
From: Rory Little <roryl@candelatech.com>
In-Reply-To: <64aaccd3-7a96-48b6-9cdc-fede692351a5@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1785303136-jUL8Nxs0pxQd
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1785303136;jUL8Nxs0pxQd;<roryl@candelatech.com>;ad53361cb16e13f6f29cc39f16bb8319
X-PPE-TRUSTED: V=1;DIR=OUT;

On 7/28/26 18:34, Jeff Johnson wrote:
> On 7/28/2026 4:47 PM, Rory Little wrote:
>> The firmware version is already exposed via ethtool, but is not
>> accessible without an attached interface to create a netdev. Expose this
>> info in sysfs to allow users to query it without the use of ethtool.
> Curious what is the value?

Here are some that I have seen:

10.4-ct-9984-xtH-011-33ec52c8
____000000-20251118163234
____000000-20251015213023
DEV_000000-20240823172837
DEV_000000-20220929104205
89.7207fc64.0 ty-a0-gf-a0-89.uc

Top one is ath10k with CT firmware, next four are an assortment of 
Mediatek radios, bottom is Intel.

> It looks like many drivers, including ath11k and ath12k, do not populate this.
> 
> And this attribute is pointless for Wi-Fi 7 drivers supporting MLO with
> multiple underlying hardware running different firmware images. I suspect
> there are a few wiphy attributes that have this issue.
> 
> You'd need to instantiate these attribute on a per-radio basis to properly
> handle the new multi-radio wiphy model.

Hm, good point. It seems like it would either need a fw_version member 
on the wiphy_radio struct, or something similar to the addresses field 
off the wiphy. Would either of those be acceptable solutions?

- Rory

> 
> /jeff
> 
