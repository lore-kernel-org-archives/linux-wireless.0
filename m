Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BE04EC65A;
	Thu, 15 Oct 2026 12:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.221
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068192; cv=pass; b=fVjLJpr9XtfDTNlH2fFlRFw26Qw6kffmpdFDaPVj1SBPyTY3jeFExIcHmWfR9bVOVN1jgFQtrTCQNbx7fYqsWyIce7q7/3DGq95JOUitDm6NnIFuAb5zuTBeMt36edPdItsiv1t5w0Zs11d0U+jkC/nAWfhPwVwgwJP0GcTLluE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068192; c=relaxed/simple;
	bh=QJDF35CwaWHOLbMgoeuNtkHs0cP9mQOrc+xj8n5yvXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p0V6D+tM62Qln//Oqvj69gOIRrIiOkOtV+LtU7ZfOeF5UAWrR64LhcdZOI0qXaz9v80Nj8bod7GrkMpINLTPR3kbli2E6obkS1TkJy5Asi12X1XS682l540lo0dcr0zFUdWlsLVB8PQT/6+xFQ5AnXJ3zXvsx2swfcSjkRPv/kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net; spf=fail smtp.mailfrom=hartkopp.net; dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=sW1E4IcL; dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=P+ATfxwg; arc=pass smtp.client-ip=81.169.146.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="sW1E4IcL";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="P+ATfxwg"
ARC-Seal: i=1; a=rsa-sha256; t=1792068187; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=S7bCQDeGsS6XVQXcoOgv4sKceA3epw4O/XGRJptKZBaxR0FMR9l4m/gRusNRSotZbb
    q59/13OLd64JJ9K0lPz2rDt/8cDL9SHABUe8RDf4M+Kb8UISg/Q0atmeVC2fCT3Br41o
    1fowhyz7mfBfC/no0sZbqJAB8lD555QGBW/LNS8nU+9XsSdFsbNa68NGkRTUV3/3nlXT
    fGD+nxXHMQ0fCo3JzInewafIBMcmoyau7Pr0d4sXhHMjN2EPh4hB6Jvv9HiG/7WB7t2D
    zSg4/HI1R6+XT+d4WFmHvGyFRLUI/wDT0qM80JfhKin7ReNf/EtGPQG6OXfJLaXH4o6U
    im+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1792068187;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Xk4vDY1JiszPg1l07kO1UsZn9d4C6kQlPuTTk84vw+E=;
    b=bvUIfemNMVsJPFXyRnm3RJqzdniTX0ssQgRr7qm+/UGyk4pqbIIujtqbwG5MWHEhjj
    8DfUk56hfKIoMF4KZzn45m7k+rpLcKVTHHv9QqmlyG3LS43qPXdYqNzvZeas5nMSWmG8
    GComd72eKHwzArWk1mrE9rAczLnip/lC+Dtz5phwKMtz8P33UGkoSLnldaDUp4X2H/69
    le6wDztH+GZ5vkNW5h5QHPavDccOpnpq8tEaJf3kKJUiK3KYBptbk/xwTjNMJFDOYNHs
    tMJWwkuMVYeoPQf5o6WQAA2wGie5FxHq2QcVGhUzPaayRQ7rxeiz29KyCq+l7Z+yrHiP
    J5oA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792068187;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Xk4vDY1JiszPg1l07kO1UsZn9d4C6kQlPuTTk84vw+E=;
    b=sW1E4IcLApJ4+XEXoH0ow2VsBRj0CeXu/cDtJsVGyj2IlRqlJY6fcu/dL3bosd+SwF
    vrT+WPsOWqw1yMzbOYQFVQZ2zUj1sThdHcGh3/T114FC9K0/iKF9bbjvvBFjcdZYZfJn
    KHPaT3IO5s6S2yiWrNkNwg7f7XqaqS/3oX8PDh9XwH2xZDRBl4F29j/444SATzQpKYHn
    xMIwZ/wmLmZhF+JdQkyzixke+mMTgeTnQXWr2/el2sctRuHivcu/pX2elQslAsbja5BN
    uDE+/Sy/TgDH68BdRaw7xkHzFIqpp6DdchqUdKNyNjWHt08h3G5sbGhqrxw3tuc/j6pu
    F2Cw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792068187;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=Xk4vDY1JiszPg1l07kO1UsZn9d4C6kQlPuTTk84vw+E=;
    b=P+ATfxwg7J/+s8GseDi2EUg2JliASakt4ombBHxf157FAvb5Q+0pBsz7lLRjW9cIhX
    ONCOge0NRy+Z/wbdUWCQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjH4JKvMdQv2tRkI16oOSW1Ti/f4Kp38="
Received: from [192.168.20.237]
    by smtp.strato.de (RZmta 55.6.3 SBL|AUTH)
    with ESMTPSA id Kfdf2a29FCh7I9b
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 15 Oct 2026 14:43:07 +0200 (CEST)
Message-ID: <51e3f9ce-fa8c-4cdb-b5bf-d05f53cb52ac@hartkopp.net>
Date: Thu, 15 Oct 2026 14:43:02 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] wireless-next-2026-10-07
To: Johannes Berg <johannes@sipsolutions.net>,
 Kuniyuki Iwashima <kuniyu@google.com>, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
References: <20261007205827.467974-3-johannes@sipsolutions.net>
 <20261007163616.1088d364@kernel.org>
 <CAAVpQUATko2Oig53r1+VHe+4Y3fFeX1xOw5RAnXtUAGwvQoB5A@mail.gmail.com>
 <44cb773984f61ae85b8c42904ef1ce7a62e85e4e.camel@sipsolutions.net>
Content-Language: en-US
From: Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <44cb773984f61ae85b8c42904ef1ce7a62e85e4e.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 15.10.26 14:27, Johannes Berg wrote:
> On Wed, 2026-10-07 at 19:05 -0700, Kuniyuki Iwashima wrote:
>>
>> Also,
>> I hope we could remove the long comment in __rtnl_unlock().
> 
> So I sent my next PR, and we could therefore do that now. I also checked
> across the other places in the tree, and isotp_release() was the only
> one that seems to do something similar, keeping a socket pinned around
> rtnl_unlock(), but I don't think that could cause a similar problem.

If I got your claim correctly, I think we are solving this in this 
net-next PR too:

https://lore.kernel.org/linux-can/20261015015336.816543-8-mkl@pengutronix.de/

Best regards,
Oliver

> 
> I was going to send a patch, but then I didn't (and am sending this mail
> instead) because I'm not really sure what we should do with the WARN_ON.
> 
> On the one hand, it's no longer strictly _necessary_, code that queues a
> work item (unregistered a netdev) and then calls __rtnl_unlock()
> explicitly wouldn't have any expectation of completing that soon.
> 
> On the other hand, the next random code that acquired the rtnl and then
> unlocked it would suddenly have to do the unregistration work for some
> other code and it'd be accounted to that thread and cause latency there
> (not that it can have much expectation on latency while using the rtnl
> ...), so in some way the WARN_ON() still seems justified?
> 
> Anyway, the cfg80211 bits are gone once the PR lands, so you can remove
> the comment (and possibly WARN_ON) whichever way you prefer :)
> 
> johannes
> 

