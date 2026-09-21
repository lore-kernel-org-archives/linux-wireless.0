Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590F2428470
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790021861; cv=none; b=ktekjfFSy/9Dd9oJGiR6g3J3z9D3FHMZQpMHw82s7sWzqonc7SbIfRv0MB4bcyZoWvYx1zP4zk9zrxmI5yghN3m+DYCymjYL93GIBNxq5Px9QJPERfUsTrgmvs8T2zm6lpWFKlWml78NzIPOCau4uCw6GXj6jWlDb/6zd93Wpmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790021861; c=relaxed/simple;
	bh=F8AyQBBDCoyRzQlD30bpE6UJKYN2rAmbrxKjpebhWuU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cI7VOl5aP4y/07lSXHqQwtLkJnyOGkwMA4O/1xLTEoXDy+LlaFhBMR9jLdhjPGcFwaktwYuoAbPwApj0Vgj1pcPg2qMRb2BkzbkzvOgIcrYWn6yp5WqlKQhlU1w/NVeHn9mGT/0t1CoteZTYK1GJb/m+Lnys0jASMBq4gPuF6kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=QnezJudF; arc=none smtp.client-ip=67.231.154.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="QnezJudF"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BB02E3C0073;
	Mon, 21 Sep 2026 20:17:37 +0000 (UTC)
Received: from [192.168.0.38] (unknown [136.27.42.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id DD34A13C2B0;
	Mon, 21 Sep 2026 13:17:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com DD34A13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1790021857;
	bh=F8AyQBBDCoyRzQlD30bpE6UJKYN2rAmbrxKjpebhWuU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QnezJudFeQ4/eUTN4tA8sGM3Q1EStPNoHOORQrvqaVssi1ZU9rPidKTQNxTfN2Qop
	 CVc6iD1kaLphdvfzyHpeXTvlHZpriaZsgtI4LGb1zFD+4wm7jHVZBwj9TmCBcF0kU8
	 1uVcXnCN8x1eHKFY66U6WsPcxeTWaKWFAnHk/DaE=
Message-ID: <f7788e68-3292-4337-943a-032a838947fe@candelatech.com>
Date: Mon, 21 Sep 2026 13:17:36 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2] net: cfg80211: validate monitor channel
 set against radio usage
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Dylan Eskew <dylan.eskew@candelatech.com>
References: <2318ac388c0da7a200c8a1aec0d0af662fdf1ba8.camel@sipsolutions.net>
 <20260921184605.2699-1-roryl@candelatech.com>
 <289eaefe3389894758d3ba1b3d24aa73aa630d91.camel@sipsolutions.net>
Content-Language: en-US
From: Rory Little <roryl@candelatech.com>
In-Reply-To: <289eaefe3389894758d3ba1b3d24aa73aa630d91.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1790021858-4EfAczE94kXT
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1790021858;4EfAczE94kXT;<roryl@candelatech.com>;b42792dba290a1257c3f0aaf1c60b0ff
X-PPE-TRUSTED: V=1;DIR=OUT;

>> - Handle error return from cfg80211_get_radio_idx_by_chan
> Yes, but did you do it correctly? I don't think so?

You mean propagating -EINVAL out to the caller, right? I'd need to 
handle the n_radio == 0 case to keep the -EBUSY behavior consistent.

>> - Fixed subject line
> No? "wifi:" instead of "net:"

Oops, I read that as a casing comment. Will fix in v3.

- Rory
