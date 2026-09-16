Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8124A99DD;
	Wed, 16 Sep 2026 09:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789551399; cv=none; b=AGi3/fCkfEQ+ah8+55TRRq0gzAwNUF+N0amG2dJfq1NJ3r4Ndo0ennLaKuMuF9pIZhq9n8ZmFGjqts2guYBEL+dz0dnEMnMLjRvAYzi0vVVhDWqAZ3I1TqNoMVhhAD4yfuX/s8bU7ZgbwF/0L1tpo5QpQD7DsoNKAJt6tSlIBHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789551399; c=relaxed/simple;
	bh=Tv8q4KRhHYd6df+3R2bPg1gJXfFzLEsuAAmD8hbaHmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QshLiol5mDldZOzob7/jj+y0ZNWcXXmsLrwbJIgT4uKS79ggICB8brrn3tnssR0g8Gzfa7Xt6AKb76PiW8q3LVRPFAEa3KRqUmkt87x7d5dmzPkseSXLnugaeYjeJwXZxCawirD3Zm+WyYtylRP0UIhM9JzznzsIqy++vzG3adQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=FrwusAfm; arc=none smtp.client-ip=188.68.63.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="FrwusAfm"
Received: from mors-relay8204.netcup.net (localhost [127.0.0.1])
	by mors-relay8204.netcup.net (Postfix) with ESMTPS id 4hlDKX1HLYz8k2q;
	Wed, 16 Sep 2026 09:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1789551376;
	bh=Tv8q4KRhHYd6df+3R2bPg1gJXfFzLEsuAAmD8hbaHmc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FrwusAfmP8YMMj2RRVKzKx+h6Vnq/gUqUyIL0fiEsTBtUtA8ux+7RXO7FUh2Fy7tU
	 xuqFroAZtyTtHK5sbkPfhGC+YvK0yheoK2kD4R3EuXGVVKKHgzlZ0hvPWYTctk2rL7
	 8a4v0wkVlyM0xHvIT1HTRkxPZ91l06OSep+OwFMcVcjKd4t+WEDnLVX1SnprlOuePB
	 m9yB4U6f1y9kdx80cbBBCkeWX7qbuzfJw27J4IBt1dBZ7lBH81avFzdx0g9RrHo9AS
	 vuNL+T10TiR67NOyMP6HowEhbB9z8NSt++6/nfrhSW6/0qYfeA0OeRFJtsG+lAEoLc
	 5fcOuqX0ELSNQ==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay8204.netcup.net (Postfix) with ESMTPS id 4hlDKV4WRXz8jp0;
	Wed, 16 Sep 2026 09:36:14 +0000 (UTC)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4hlDKS1lcwz8sbH;
	Wed, 16 Sep 2026 11:36:11 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 25E5E5F9C8;
	Wed, 16 Sep 2026 11:36:06 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <6e1aa91c-3749-4d8f-ae77-a7180d7ff84d@leemhuis.info>
Date: Wed, 16 Sep 2026 11:36:04 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net: qrtr: resend HELLO on MHI resume
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Vlastimil Babka <vbabka@suse.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Daniel J Blueman <daniel@quora.org>,
 Linux regressions mailing list <regressions@lists.linux.dev>,
 Takashi Iwai <tiwai@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Chris Lew <christopher.lew@oss.qualcomm.com>,
 Pranav Mahesh Phansalkar <pranav.phansalkar@oss.qualcomm.com>,
 Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-wireless <linux-wireless@vger.kernel.org>,
 "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>,
 "ath12k@lists.infradead.org" <ath12k@lists.infradead.org>,
 netdev <netdev@vger.kernel.org>
References: <20260909055846.16539-1-daniel@quora.org>
 <hcr4woicsnz3pbhzlguuwjlego7yli3znhjmsx4cdz66xa74zd@wjtle2yslc4b>
 <c99d9feb-0a19-4f8d-915b-c2ece401e3fa@suse.com>
 <6257c447-788d-4362-851e-0d552bcf7c56@oss.qualcomm.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <6257c447-788d-4362-851e-0d552bcf7c56@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <178955136698.941304.16981546198776007441@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 25E5E5F9C8
X-NC-CID: CUZg8elczhzvougDh6PJ0vtRzakfTbjPRF8VlS48Dsn0b8J++jc=

On 9/16/26 05:09, Jeff Johnson wrote:
> On 9/15/2026 3:48 AM, Vlastimil Babka wrote:
>> On 9/11/26 12:44, Manivannan Sadhasivam wrote:
>>> On Wed, Sep 09, 2026 at 01:58:44PM +0800, Daniel J Blueman wrote:
>>>> Since the MHI HELLO exchange was relocated, it is sent only at device
>>>> registration. During a suspend-resume cycle, the firmware in WiFi
>>>> cards such as WCN7850 indefinitely waits for another HELLO,
>>>> triggering:
>>>> [...]
>>>> Fixes: 544d85de4dc2 ("net: qrtr: Send HELLO message on endpoint register")
>>>> Signed-off-by: Daniel J Blueman <daniel@quora.org>
>>>> [...]
>>>> diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
>>>> index 78347c937af7..2ffcfc2fdb4a 100644
>>>> --- a/net/qrtr/af_qrtr.c
>>>> +++ b/net/qrtr/af_qrtr.c
>>>> @@ -623,6 +623,19 @@ static void qrtr_hello_work(struct work_struct *work)
>>>>  	qrtr_port_put(ctrl);
>>>>  }
>>>>  
>>>> +/* Trigger the HELLO handshake after the remote has been reset, eg on resume */
>>>
>>> Use proper kernel-doc please.
>
>> Please prioritize merging this sooner than later (it's a regression from
>> 7.3-rc2 that would hit people if it made it to 7.3 final) even if it means
>> fixing up non-critical aspects later, or by maintainer upon merging.
> 
> Concur. I recently fast-forwarded my ath tree and picked up the buggy commit,
> so everyone using my tree is now affected.

I wonder if we need somebody (Daniel?) to repost this patch to at least
have a chance to get it into the next -rc, as I didn't find the fix in
netdev's patchwork when I just looked -- maybe I missed something, but I
guess that's because the patch wasn't CCed to netdev.

Ciao, Thorsten

> And just want to point out that many of the function comments in this file do
> not use kernel-doc format, so I would not consider that a blocker. But it also
> would be trivial for the maintainer to add.
> 
> I've tested this on my HP ZBook 14 where I've replaced the OEM Wi-Fi adapter
> with WCN7850...
> 
> Tested-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
> 
> /jeff
> 

