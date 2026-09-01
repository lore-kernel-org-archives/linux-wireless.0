Received: from smtp.inf.ufrgs.br (smtp.inf.ufrgs.br [143.54.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49604A2E02
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 20:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.54.11.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788294323; cv=none; b=otvNNiTLpSF0+81AngsCjlOdJMziaLi49dD/8KGtkiMm406kWl0LLQ60GCie5O2d/8jCBnSsx86Myxamqyjbro0pMPAA9jPwAgUuc7oalGcYD+VL2lb9Nq09jmdaGsI5l9mdI/KZh52FYiQ4/8XVAumiG5reNRA+UB86iXYQrJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788294323; c=relaxed/simple;
	bh=YpSEe/QeNNcL5SUb0P9guYoRbvyYY8c7s5p4Uk+t/mk=;
	h=MIME-Version:Content-Type:Date:From:To:Cc:Subject:In-Reply-To:
	 References:Message-ID; b=W9uYzx4U//a+ujRTpaUmTOeVGW1JmeBNxeXrcpzL/6jmSEzQBd77nMU2wvwujxjhRlmNsR4r8ZbzUUMnYhUq9HdHT9gHFI28CFpiwkaepr0Z5OlFuhlC/EhBFeOxckHxQjmEHKUm9APp4hmy7huh0rx2WiR8rtZHSdGe4k1L9KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inf.ufrgs.br; spf=pass smtp.mailfrom=inf.ufrgs.br; dkim=pass (2048-bit key) header.d=inf.ufrgs.br header.i=@inf.ufrgs.br header.b=KrN5vhf0; arc=none smtp.client-ip=143.54.11.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inf.ufrgs.br
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inf.ufrgs.br
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=inf.ufrgs.br header.i=@inf.ufrgs.br header.b="KrN5vhf0"
Received: from webmail.inf.ufrgs.br (webmail.inf.ufrgs.br [143.54.11.45])
	by smtp.inf.ufrgs.br (Postfix) with ESMTPSA id 369531210E9;
	Tue,  1 Sep 2026 17:25:13 -0300 (-03)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inf.ufrgs.br;
	s=dkim2026; t=1788294313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZKLqU9L/8UvKxH4648IEH/avxS1YpdOxrXvY+OvEEWg=;
	b=KrN5vhf0GMNe4+LsMGcn2Wrxwoivh3gcGybfbkAnR8Ogm9KgIINlPcGgZ2NFK+KsBHdXj1
	uAfcfvP2oeJK8ItR9EaK+aTI6mMT9c70Uqb4OB8zG7kX4bfXNNIqTYToBpZg8tio6PXaqR
	BXk3gaPNL4AYlU6c+iDX0yYHsYQOTgnWk3jB7sE+9Syz86OT9sGgzfULsVI8AznfWc+K33
	WYJo/w+9W0TnRt3pdESg6z+gx1IyDCuI+51YPrX6sNLxS1aohHk4NnXALH+FMUNo+XVNQ1
	ke5USGCWPNpriR7XGF5B6LzHYub1/t1ovhpTwoHrrmucR6ZMAc5Hg832IEQioQ==
Received: from 179-104-165-168.xd-dynamic.algarnetsuper.com.br
 ([179.104.165.168])
 by webmail.inf.ufrgs.br
 with HTTP (HTTP/1.1 POST); Tue, 01 Sep 2026 17:25:13 -0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 01 Sep 2026 17:25:13 -0300
From: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: mac80211: fix channel changes for active
 monitors
In-Reply-To: <20260901192258.6603-1-lucid_duck@justthetip.ca>
References: <20260901025525.4017-1-matheus.aalmeida@inf.ufrgs.br>
 <20260901192258.6603-1-lucid_duck@justthetip.ca>
Message-ID: <42caafdd41111750ee6303ee6ea672ad@inf.ufrgs.br>
X-Sender: matheus.aalmeida@inf.ufrgs.br
User-Agent: Roundcube Webmail/0.9.5

> Tested-by: Devin Wittmayer <...>
> 
> Two MediaTek USB adapters ...

Thanks for testing this, especially on real hardware and on both kernel
versions.

I originally ran into this while writing my own 802.11 stack and had only
tested the fix with mac80211_hwsim, so it's good to see the same issue
reproduced and fixed on actual hardware as well.

> Still open is that an active monitor gets no channel at all when it is
> created ...

The initial-channel case is interesting too. That sounds like a separate
issue, so I’ll keep this patch focused on channel changes.

Matheus
