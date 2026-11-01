Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=129.217.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793546699;
	b=feCxqwW5JLbqRIPki6Zx3AEsk2ra4Fa5FTmd7RmWkK7ZxTdtyit72CtAqC2yUaqOIMhn
	 /c3ML7qXymuH4yVT8J9P7hT9/7MH0ZnIaeZgvSxE8u99jTGBz6Ko/Fs2wK6TiZWWuo/Of
	 q7fOQ5yImnSGPUxp1sSoiil0U6fYe9TKlRHeLGtMC5po/BFPgxTIdUE6wyA4+AgzxOJ8E
	 MV82oGQw2x0cGDb+Dw5jBKBSmxJ7w23sUvhCxN/tuCSmrcBwg/0PLDpQ6dLoqlD7h2da5
	 GzVhKD4WnxddrY7bXq4SKivds8rIRDzr4e3vDXtTMbknzvc4DlJQcsB8mUUgU/Q5Eeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793546699;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=hG7wTTHLx/WqfjBm2asmQSJhJWPNMKDFj+A9omGS4dQ=;
	b=SEF8hydl43F5v/J+HmWkX1Wel84ZxZ+z1ASgHC30tqxiyUIOD1KhBObvS2WgyllfSfEo
	 qf64okkhb4FU9hLkGf8q4gsk596/K6JR6+YbsMKHxCHHm/G593TaHFZUEGUU09IMiuOa8
	 FvL1SBYL1xM5tDowQyeX5Rsi+bg4tlZYPs4T+p+zYPIB5/bSf2TGMeo77W1r1spzudM5G
	 HCXc4fMpF8oymq8vx0j73G5W3I3XjzEHxYW9teM0m8IDm2Ypnc8VAGVeB6WdQHimX9Zmv
	 /53h6WFl9ElI6i1ZOpz2ZAj+UXzWF9gVNwQNXhcReyFVzyQfir+jctsMvt1nj0p7B3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tu-dortmund.de;
	spf=pass smtp.mailfrom=tu-dortmund.de;
	dkim=pass header.d=tu-dortmund.de header.i=@tu-dortmund.de header.a=rsa-sha256 header.s=unimail header.b=ifs6FUFU;
	arc=none smtp.remote-ip=129.217.128.51
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4AD606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 15:24:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B4AD606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.a=rsa-sha256 header.s=unimail header.b=ifs6FUFU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tu-dortmund.de;
	s=unimail; t=1793546692;
	bh=hG7wTTHLx/WqfjBm2asmQSJhJWPNMKDFj+A9omGS4dQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ifs6FUFUqz+sMwn+YnjIzx0hHTlT45A9fKLDsyGh5d+YprggJVNbKXRCBEE6QjBUT
	 acwCKua/+bwGf1bCrnoqCP2TtwKWitCLrJ7vBfn8FWbdxy92kymC5/q2lcqUhMuRxT
	 GqJv/CsnSKRh7GypI7FpwHxXax6vxqsyQLpCxtTc=
Received: from [192.168.178.125] (p5dc88c48.dip0.t-ipconnect.de [93.200.140.72])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.19.0.2/8.19.0.2) with ESMTPSA id 6A1FOqPx011415
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 1 Nov 2026 16:24:52 +0100 (CET)
Message-ID: <26af137a-e2f4-4b96-b72c-1e95ffa9dddf@tu-dortmund.de>
Date: Sun, 1 Nov 2026 16:24:51 +0100
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] wifi: mac80211: mesh: notify driver of peer
 capability changes
To: Florian Maurer <fmaurer@disroot.org>
Cc: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
References: <20261101130636.1867958-1-fmaurer@disroot.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20261101130636.1867958-1-fmaurer@disroot.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/1/26 14:06, Florian Maurer wrote:
> This touches the same FIXME as Simon's RFC [1], but addresses a
> different case: a peer whose capabilities change between peerings.
> It does not change anything for an established peer, so it does not
> help when a peer comes back with the same capabilities.

Thanks for your work! I think I ran into a similar issue while
experimenting with changing bandwidth live via iw. Your change looks
good to me.

My patch is more of an (ugly) workaround calling
rate_control_rate_init() on every beacon, which fixed my case of a
peer that temporarily went out of range and came back with the wrong
MCS still selected.

I'd still like to find a proper fix for that case. I'm not sure
whether this is the right place for it, or whether it belongs in the
rate control algorithm itself.
