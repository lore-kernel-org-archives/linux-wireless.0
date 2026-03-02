Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D38391854;
	Mon,  2 Mar 2026 20:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772485173; cv=none; b=CzegcLJ1UJrzcHDnedjcHPgIzrl1+xzeNBztnk/eyB6dDrLL6evMgkqsVmj7ZbRqtAZgh4dRwHvmKpevo7r5Hgwbt+dOoHVuMeMrheqMoX1bbnxDCgH8dIgNGZ+shE2DCB1IJfL4MELgk9Tl1JUDazVScekv4TZYPUCuuxjr4yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772485173; c=relaxed/simple;
	bh=PKuEHcGXkYhdCFGf1NEEbcoZoiY1Jl4ljSph9vshrps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2iVc0PSvCg2wzx3yZhETEmG/wIaLjIpqvftIO/IwtrNUgbC85y8JG45TuQCS6fKu6w3FvvYx5iotirRYt8KqaEhWHbPOSGYwojHcGWg94RekHcBVHp+ItKhFoDzMwOQHiAngtDTv0i0qeH+E3Nbpr398PvSCpEvQC5szMnycns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2VTm1KkX; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2VTm1KkX"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fPrsH4497z1XM6JP;
	Mon,  2 Mar 2026 20:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772485163; x=1775077164; bh=YwqA8Bx/xnytu69OXNQDV3UD
	bjVFG/c/g3pM3jAH1j0=; b=2VTm1KkX898xU7TLNx3dysVuSK7rTKWr5WpVjDHa
	lEPopsYhDVRf5NYYgYIVl3QhhPTp4zic//CRk388vEFcG9P19Nn513Y+3TW3PcQE
	YQNMdYYDI+Yy8mMqsfbPL6bscAL1k5imM3Zvou7jEZQ3U1dVTJhGCl9RQGoDqMhy
	UihxSSet+tPAlfQ1zZNnmpU68C8mRnCJ/pWvuVzJxySHNgjKLoxyoFQauKbYSIW1
	L/VdjmDTac+DdAUppZh+qYrfW4QeMQrAmsSGlIcOS7CIVV/v7h9G/fUyg6vXTN1q
	OgTDcngfR2JA3WB+wmABMtZpKEDyTKiA7ewNXpG2nbxklg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qtLDyhjiP62K; Mon,  2 Mar 2026 20:59:23 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fPrs16GtFz1XM6J7;
	Mon,  2 Mar 2026 20:59:17 +0000 (UTC)
Message-ID: <e4924fd6-4b7d-4d89-814c-904a0b384c01@acm.org>
Date: Mon, 2 Mar 2026 12:59:16 -0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 24/62] net/cw1200: Fix locking in error paths
To: Johannes Berg <johannes@sipsolutions.net>,
 Bart Van Assche <bart.vanassche@linux.dev>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
 linux-kernel@vger.kernel.org, Marco Elver <elver@google.com>,
 Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
 Jann Horn <jannh@google.com>, Kalle Valo <kvalo@codeaurora.org>,
 linux-wireless@vger.kernel.org
References: <20260223220102.2158611-1-bart.vanassche@linux.dev>
 <20260223220102.2158611-25-bart.vanassche@linux.dev>
 <38b05b3519fc7b1ddc91937990d4b667d6314d78.camel@sipsolutions.net>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <38b05b3519fc7b1ddc91937990d4b667d6314d78.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/26 3:08 AM, Johannes Berg wrote:
> On Mon, 2026-02-23 at 14:00 -0800, Bart Van Assche wrote:
>> From: Bart Van Assche <bvanassche@acm.org>
>>
>> cw1200_wow_suspend() must only return with priv->conf_mutex locked if it
>> returns zero. This mutex must be unlocked if an error is returned. Add
>> mutex_unlock() calls to the error paths from which that call is missing.
>> This has been detected by the Clang thread-safety analyzer.
>>
>> Cc: Kalle Valo <kvalo@codeaurora.org>
>> Cc: Johannes Berg <johannes@sipsolutions.net>
>> Cc: linux-wireless@vger.kernel.org
> 
> This, and 25, are part of a larger series and I didn't get a cover
> letter, so not sure what's supposed to happen with it.

Peter Zijlstra prefers that subsystem maintainers queue these patches as
one can see here:
https://lore.kernel.org/lkml/20260223220117.GT1282955@noisy.programming.kicks-ass.net/

I plan to resend the patches from this series that have not yet been
queued by subsystem maintainers to the respective maintainers.

Thanks,

Bart.
