Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDA14FD7BB
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790016389; cv=none; b=hQUV+EhnNbbCTDis5vz4c4S//eqGGfSLfbDe0Ll2AbQ5LiiSIwswOblAu9NtOdpwzYzjDjdA15CbHvayT5x0LpPBec1jgG1+NEk3Z5Y2xKrTJV7fK5vOlSXNJpA3InC8P3si5UPIiE27HemnNjJ0BBmZJERHItv+KSQvgjSL7hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790016389; c=relaxed/simple;
	bh=9ZJJd4v21uqPIH2djWH6MDU2H/3uRED+d/Fx4BdPozs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fkgguTrIVXypPzhyxU9ZdT2A6jmKFoDOpvORZKFLllDmSlrtU/6HXAnVkRI0y53uV0Qly9Ha2IvqVCl999/cKAcK1ia825cEp2G3Xc4K8rPOoBsMEx6GQUEtnv5hRpKnnGgP4hwc5jAdSmyiBNLOEbGKKaL0mNoeVGjFgk5vE60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=Xa4XMz2M; arc=none smtp.client-ip=148.163.129.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="Xa4XMz2M"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 91421C0073;
	Mon, 21 Sep 2026 18:46:18 +0000 (UTC)
Received: from [192.168.0.38] (unknown [136.27.42.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id E5B0613C2B0;
	Mon, 21 Sep 2026 11:46:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com E5B0613C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1790016378;
	bh=9ZJJd4v21uqPIH2djWH6MDU2H/3uRED+d/Fx4BdPozs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Xa4XMz2ME5S5BB0kTsihui7mvZ/JIcEHaWJ7q3Ikyl2/LHnQLcesknIgzzri9e9+O
	 09X06TyOZvN7VC1GS2uIci3ArMnEFpXNi72gRGm5tvc7dpB3LJ+4HgHVVcfNxcC0VT
	 aAyOhyyFbbl683PDyUsj4FUBjW/HE1sAO7rMwwCY=
Message-ID: <610ac20b-57ce-4020-b079-ad551629b223@candelatech.com>
Date: Mon, 21 Sep 2026 11:46:17 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] net: cfg80211: Validate monitor channel set
 against radio usage
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Dylan Eskew <dylan.eskew@candelatech.com>
References: <20260918170746.3824-1-roryl@candelatech.com>
 <2318ac388c0da7a200c8a1aec0d0af662fdf1ba8.camel@sipsolutions.net>
Content-Language: en-US
From: Rory Little <roryl@candelatech.com>
In-Reply-To: <2318ac388c0da7a200c8a1aec0d0af662fdf1ba8.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-MDID: 1790016379-et1qsLICXbFY
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1790016379;et1qsLICXbFY;<roryl@candelatech.com>;b42792dba290a1257c3f0aaf1c60b0ff
X-PPE-TRUSTED: V=1;DIR=OUT;

> You didn't really have to send it twice 🙂

Sorry about that!

> Please fix the subject and the syzbot reported issue.

Will do.

- Rory
