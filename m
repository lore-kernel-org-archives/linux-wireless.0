Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175E8342173
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 11:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785584326; cv=none; b=KE6idKT7aPFkBZj3OaCXpikSSRfK4XKP8wCUEjSva6t3un4KcpVlunwA87Jjyn0WQdR+TaGiJkbuAb41wJULC9ik17thwxyQHUcTrKC4ynqLDMhec09JAknz4ZQWw6PjPTfiQ5URYFb4HNkBNbK1cVtBtxHgIOoZwKGX4vYV+no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785584326; c=relaxed/simple;
	bh=7CCSIq4hhpffLOWovMqtMAAul1pl5G2JEVRaxekG/eo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PGI6/Br4eE+sK8AKjW9/kOuuUpXAhUgNhulB7hzSZThcCRvp/BXv4mmeOv2Ay5p7Qg7VM+HcOoSk2sEb2aLeRFRFeA+zi0Plpxxw3Xyvx2BDYDsUeLHGzPibsMUWGyKZTTqWJ1o2bPL2UsMNQNKoyHCRfDIltxAt2octzdmUcYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=eGUbmg4f; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="eGUbmg4f"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38759bcd877so1730137a91.2
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2026 04:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1785584324; x=1786189124; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p+f2gJFRKiSHuvZrOCKoONo8EmCeMk/bZVo3Md0qG7E=;
        b=eGUbmg4fltNmQqArwASL3iOcZFLOMt0cPQhcDDBRarNoN/Np4J7yhpKNhnetrHSQnJ
         wKwrX87t7+OkUG/RCmUlRWnf1AQuS7B2RSzvyDTHM+iFIuXYncNFvUsgBlbPcCs0qPNh
         l5f7lQ2qrgo+Z3XPIabGhXyn66bEwGNsqt6OFda/yUsfA9FmudeEQo1W93gKA4xt1WVN
         YTS7k0EokNrHAIbJYrhwT+XXFwwkDN0GUrW1d9jkBy174z5iLLmIe1goztAyhmrl84kg
         OEMr5xSz//41LJC4o8XRu/LkLJkK0TWTGX+YEjJOiAUMxANV2+HLpEKbDxSXMT8lHIT7
         hPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785584324; x=1786189124;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p+f2gJFRKiSHuvZrOCKoONo8EmCeMk/bZVo3Md0qG7E=;
        b=OkWVRCvXFg4MyDZk7N1x/80TRNc0lTyXUzlJvAKzkyuZA9SJ2NzY9kZn2NQCEldfHd
         CqH68VVnXjSH1qFw8TOYVz7j5loQAStDL0Jg7VfvGVWwoGiUs7Yun7r0iF6HiSBpaucK
         zyTM42BpRwp5IMSteSyxOTAVqw0fHw0iQBt1b6BzjJAYl6CbRjPXjwQiClw2FXpIqhNM
         bJEAAUihWW4P9uNL1ZKMb5eVWvx+jviSAsTNqLgf3UG+n/5kbWsDCAvNlThfQTncF9N0
         c3NbMxFv/xConm/c2LLRUWOtXryZCIgMrZdUeVttQ3DcU+8sq2Uf8ytNBY4d3/zehRv1
         cSTA==
X-Forwarded-Encrypted: i=1; AHgh+RoXiFXe5kdBqHvIDlYz6+tzVa46NO+9mVObbfgUj+0SAgudAOyONl4QcMsjck3iWWcXiY5NMcJ8gY7MxgRtgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvVUdmWFuBZ3yAM31vMx8sg3Mu7PcfMp0edbGSQtNBD7c6XFOI
	PU4Mdz0bslhSnxo3SkLyl1bsgzcqzbJ7U7AAWfbg8jWGMtVJ/96Ii3lBhGx1Ush2iTQ=
X-Gm-Gg: AR+sD11kldkB2ZNHYOWopn1kf3I5fUNPlnD7bzEGJWIb7YdHSWoEBdLZh5qvmrxkxte
	WZtNrPyqofrwhi/uwCK633Q/Q/gU6UKc92mOAEbOqMQZuieukfmncp7g6SaXGvhZmpQpoGx8B+r
	lJt9+J6NCXe0aMgKVu70kpTPiCtjMjPUIL+fDJrE5GPmdOFgVLQpEHeTfusws2y14Wyi79pLNIz
	JNcAXEd3PLvo+8CyUnzPwU/KV9pP1bcpWzheDU0aPngnsj0WKzQalOodgWhZGh7Jq3iS8dbaUy7
	b+P5L9lecVUxfRFxkiPAUDQsH3+xbgv2GkGDnP9QtA/hL/dmLVu0Rn5rXLjeE1qfDRRZTO7Zc/2
	dbZPWBc5qVPeb2KV8IZ/pXfdXRkTU0VLjBFh9f+/GnYKoahcd2GcU24ElC8f1Kf1W+3uRXarVft
	TXKtnuaRDfd8X5s5eB6w3nwc2r5wMr7b4AjEVlDbR1KzHLWWTgZxV8puMkQABrwPe2Mj6duxhW9
	/Rs0G49llJc7wa919Oyjzy1HeNXyiIl6ytDyv6Rf51RAoTEFS1U43KhzvRkjPandjeQGyX4a12m
X-Received: by 2002:a17:90b:4a11:b0:37d:f983:7b5 with SMTP id 98e67ed59e1d1-38fbc3f9a96mr2804697a91.9.1785584324474;
        Sat, 01 Aug 2026 04:38:44 -0700 (PDT)
Received: from Metius ([103.158.43.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab4fdb80sm11588402c88.15.2026.08.01.04.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 04:38:44 -0700 (PDT)
Date: Sat, 1 Aug 2026 17:08:38 +0530
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: jjohnson@kernel.org, linux-wireless@vger.kernel.org, 
	ath11k@lists.infradead.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] wifi: ath11k: Fix possible memory leak in
 ath11k_dp_srng_setup()
Message-ID: <l2m3df76j6tzdshgoecqx2fn3b2kzjsytqsxq6mpououga2wjn@zjxksj4z6iov>
References: <20260727105532.118164-1-nihaal@cse.iitm.ac.in>
 <041f72ea-7dfc-4d50-ac0d-e0556f037a27@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <041f72ea-7dfc-4d50-ac0d-e0556f037a27@oss.qualcomm.com>

On Fri, Jul 31, 2026 at 02:40:37PM -0700, Jeff Johnson wrote:
> On 7/27/2026 3:55 AM, Abdun Nihaal wrote:
> > In ath11k_dp_srng_setup(), the memory allocated for
> > ring->vaddr_unaligned is not freed when ath11k_hal_srng_setup() fails.
> > Fix that by calling ath11k_dp_srng_cleanup() in that error path.
> 
> Did you find this on your own? Just want to make sure you are aware of:
> https://docs.kernel.org/process/coding-assistants.html

I used a prototype static analysis tool that I'm building using the LLVM
compiler infrastructure, to detect this memory leak issue.
Didn't use LLMs, that's why didn't include the Assisted-by tag.

> FWIW my coding agent says this patch is correct but incomplete. There is a 2nd
> leak, at the switch (type) default: case which returns -EINVAL without cleanup.
> 
> Care to incorporate a fix for that in a v2?
> For that part you can add Assisted-by: Claude:claude-sonnet-4-6

I didn't find any calls to ath11k_dp_srng_setup() that passes any
hal_ring_type other than the handled ones. That's why I left the default
case as infeasible. But anyways, to be safe, I'll add a free in the
default case as well, and send a v2.

Regards,
Nihaal
