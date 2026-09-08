Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D240C492E26
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 23:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788910861; cv=none; b=dAQKl8VlSnMR4rd5UYLbp9iwP720kFZ2hTbNlUrHLaTjuzIg19jWZE0FSDIRmqN5A4SMnyqNkWhet34ThX0lDMVLMolHv9BsIdvhQV/b/cnLTiPZp2v0a5xP1dkKdaAXVRhcz4tDtxL38JzX86LF/POngAGxaRzRNXn3LUVL3VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788910861; c=relaxed/simple;
	bh=xSbVh3zXYxyUauOs7QH+avrLyw2hYggzI4Lh/uU1F6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lj4cG5D0gtDtAtKASiMHtvxEUHapTMGH0Tp+fJgK1+50F5RZrVnBL63AjJLn78Gj2UmoFOV7dB18c5eXS/3sBs3f3UDnXLJcQDmCraOMJ2L21/OtA5BKehGmdSEhdstHjl5FYUp+cTZFrSaP3ntZ38qGneadrmeS5J+SSI5duFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=alPYfT/m; arc=none smtp.client-ip=148.163.129.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="alPYfT/m"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 706F01C006B;
	Tue,  8 Sep 2026 23:40:51 +0000 (UTC)
Received: from [192.168.0.105] (unknown [208.52.85.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 8FAB913C2B0;
	Tue,  8 Sep 2026 16:40:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 8FAB913C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1788910850;
	bh=xSbVh3zXYxyUauOs7QH+avrLyw2hYggzI4Lh/uU1F6M=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=alPYfT/mN9XqwF993s7UGtQnhVrMml9VixLtw47vhj4UtIxlk6QHwoQHxl6xc6fwy
	 ypWXmkAfQkuNArioOpKVG/dxcCjI88YbCAp/ZRQJ/UmOmTprv50i2pDsDq0/MYHisL
	 YhbNWC2s8uOq1zrTIRcKaK5C5kDXGoXg5s94Tmpo=
Message-ID: <98829360-4d7c-4faa-8fac-63dbe32c0df3@candelatech.com>
Date: Tue, 8 Sep 2026 16:40:47 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: cfg80211: avoid holding rtnl_mutex across all
 cfg80211_leave() calls
To: =?UTF-8?Q?=C3=96mer_Mete_Kaya?= <omermetekaya0@gmail.com>,
 linux-wireless@vger.kernel.org
References: <20260903151542.486376-2-omermetekaya0@gmail.com>
 <20260906002657.620076-1-omermetekaya0@gmail.com>
 <20260906002657.620076-2-omermetekaya0@gmail.com>
 <81a437a9-4ffd-4d6d-84c9-c093af5c46a5@candelatech.com>
 <b65da403-8144-4524-a076-5d25c86c0c14@gmail.com>
 <dce34788-a6fb-b2e0-4657-aab3843111b6@candelatech.com>
 <faf385e5-5fe7-4b66-bd06-e5f9a88d12ba@gmail.com>
 <bbb382ee-9ada-f060-9128-c2cb6e5f524c@candelatech.com>
 <35a68705-0bcf-4b65-9c0b-050c0344f985@gmail.com>
Content-Language: en-MW
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <35a68705-0bcf-4b65-9c0b-050c0344f985@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-MDID: 1788910852-pKpvB2POTTln
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1788910852;pKpvB2POTTln;<greearb@candelatech.com>;de889796e53c34c4d532d20f77e1c862
X-PPE-TRUSTED: V=1;DIR=OUT;

On 9/8/26 3:32 PM, Ömer Mete Kaya wrote:


> I cant produce from my own machine without fake sleeps because I lack
> the actual hardware or a fuzzing ability as syzbot, its impossible with
> a laptop and virtual radios. But according to syzbot's full crash report:

Assuming you are talking about this:

https://syzkaller.appspot.com/bug?extid=a2de4763f84f61499210

It is interesting.  I don't think it has anything to do with
your attempt to fix, but it certainly shows a lot of tasks that might be blocked,
one of which has rdev->mutex held while trying to acquire more locks.  I do not
see an obvious deadlock, but maybe it is there.

If you decide to post more fixes for random syscaller stuff, at least link the
source material so one can take a look at the larger picture.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
