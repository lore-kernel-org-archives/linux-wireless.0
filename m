Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7CD3FBB46
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 13:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792415537; cv=none; b=iN/qHDMBYZ+UFfetslrtIMJSiEolUN5nuV2O3VZGRIZSedeA+G0GEo7mpBq8hZtSxIF/N9oVh11mlX1MSuJ8sTKAjeZxqPR4HOZ2me+dDWPwFzQk7ZcwKhx8O5BwsIaNp3nOERihYSft5aHB2KbwDGCx55r/3NIYfJaNAkJEY9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792415537; c=relaxed/simple;
	bh=AylRuBno5Pn8TsJf9Ogcc7yJ2eqTf3rwdkgyP0EaziM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rOl4wwWSAm09NSSx1PM7MfQYCQTvWfBA4aUBO7bEXwE4gEe4nZefgqQmaYf95pgPPsLTyUagkQwUPuxWp0tOqHMePuGXK/pYrwRgTot9FckTyk7HH5AXvkOVbQC4/16Wg/087vgqJ1h8lpSvQPMjyjNqKN70gZ818JtxogKX8iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EbyhOs0t; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EbyhOs0t"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e5fb79ce82so10545155ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 06:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792415535; x=1793020335; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gT7565n3cY+YDTERB3uQ8khKJFfspA8uXPmSUyaFk3g=;
        b=EbyhOs0tFneOfR9xE/+BSI3DP45VZFZje1WhNWGgycmEF1wEOUqUQSyZLzSpVZkx2L
         qZZCXHei2N7+ZmdiivPDUThwJtK28eHmjXAhEN7JSPScUu47dR+snYIN8ctRyT9miEf9
         4K3B9YLN3F7/Qns7iug3EFqfgfVhpb5QYdaTYQ6VhY4XlSQbtDX0f23P+BlWqEfd9XR3
         fdYKY1sWeqfmfLkmLn/zRUp4ieXl1NhbF+7hunG25u8vATtj0uSdRAIRftPxX+tBZA29
         SmAYo/lfeXIdMtV+LaybytDBLSogqQ7ABVEnu7YWu+W/4InGc3ojwdguobJRbigGGPgq
         mwnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792415535; x=1793020335;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gT7565n3cY+YDTERB3uQ8khKJFfspA8uXPmSUyaFk3g=;
        b=g874rcgN7pqAS18Qgf5Fg1KEs620XudJ0juD0Ssa/DnBp5LCB0JTKBP81CKPlhL3Ip
         C84HQMmMiMxbqjUbeU+r4+HRUqUXNiOXDbY2xOkslrqgJtHXYfse0+5Ykr3nXtfFffWG
         qq7OdG/UfYiKfSONr/VL6+rWJ6D+qoZCMQ4XTp9gdYaJi1g5zDBN/xspaJgkHRFCPYYA
         QgW0KNQXatXWjx46Bf95ZHbxwwBaZhWbFU/ybR7KYPBHFbmucBh6KXm8cP6xn8BbDN5+
         XtU2ujfCK8QIz7y1HdTVxR9KoHq7ggd9uc3e1Ne39yP62ZZS4y0JGfUr4FGzn+DM0viK
         NUKg==
X-Gm-Message-State: AFq9FYLEhKtIhNoOO4i+6vPRS2kOmlaaY2oezE60AlCWws15XSgcODv+
	Xj57xxk9YLcYKOJpaCEFk4CnQw7N7qWVO6ibrK0XaLY9Ujuk1ijdFNYX
X-Gm-Gg: AYBFou2fYEW9zxn50BEg+Rlb3vDZw5BRDmuX5qMXSqUlkzXLGLyxO3smhIl7vjvokwa
	RkA+UF8M0v8yb6hIlj6pb5pjus8AKz2m6VrsBX9Cmg5ibbERQLCdJk0hTKZ0Bfp28QjeKqpSYcP
	YHFAxX51CbVN8XzYIRmagRtyRYdmtZxuJa2/JKc7zJAd0Ssk3G6D/mwOQAtXYIFOJBDK7peSTvG
	Pe4enCAHnuoS9bvyS5kPwYomM7M+ccThoJQdoV37kIw3596RZzAnbTvBhKqv9WZTfqorTqRoHH4
	FBF6rLLnel0JTelPspaHkFvvw+ikzNG5Way4zOX8OjPy2RiALeor9rd+fhFcs0co2LZcX10Xdzp
	St3UVwjgOVsDXTqj7E2hNSKWyk1PJnI0fWvPd/LncGyS7s0Y8TrPMxBg2FjRdQ3DBgpkb7zLsSG
	OaeJY66PzPpvrAUyICFJgTzuQX241gessuQJBdg57wahITJvG7VaV8Nq2400PMz+ZAGmyPnYWfn
	nSkrDuWWCmobrH4WJZ+2fSCIa4bDYr7pzzy96vabv4rerYbk178Pvy6sYSCaNE+8A9Iy5Mu9w2e
	T90ET2LN
X-Received: by 2002:a17:902:e84c:b0:2e9:6b5b:3db6 with SMTP id d9443c01a7336-2e9a69e93d4mr70486035ad.30.1792415535050;
        Mon, 19 Oct 2026 06:12:15 -0700 (PDT)
Received: from [192.168.1.164] (h69-130-12-20.bendor.broadband.dynamic.tds.net. [69.130.12.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea1517e895sm430215ad.57.2026.10.19.06.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 06:12:12 -0700 (PDT)
Message-ID: <61207966-c403-441d-9019-583702833a7f@gmail.com>
Date: Mon, 19 Oct 2026 06:12:11 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 3/3] wifi: ath10k: bring down a station vdev that
 never came up
To: shunsuke@nagashi.ma, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
 linux-kernel@vger.kernel.org, David Heidelberg <david@ixit.cz>,
 Fabricio Akio <fabricioakio@gmail.com>
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
 <20261016-ath10k-series-v1-send-v1-3-c847697b3558@nagashi.ma>
Content-Language: en-US
From: James Prestwood <prestwoj@gmail.com>
In-Reply-To: <20261016-ath10k-series-v1-send-v1-3-c847697b3558@nagashi.ma>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Shunsuke,

On 10/15/26 5:17 PM, Shunsuke Nagashima via B4 Relay wrote:
> From: Shunsuke Nagashima <shunsuke@nagashi.ma>
>
> When a connection attempt fails before the station vdev is brought up
> (authentication timeout, SAE failure, association rejected, or an Auth
> burst the AP never acknowledged), mac80211 removes the AP station and
> unassigns the channel context. ath10k deletes the peer and sends
> WMI_VDEV_STOP, but no WMI_VDEV_DOWN: for a station vdev that never came
> up, the down would only come from ath10k_bss_disassoc(), which a failed
> connection attempt never reaches.
>
> On WCN3990 firmware WLAN.HL.2.0.c10-00459 and c10-00236, the Auth frames
> of the next attempt on the same vdev are then not transmitted
> (management tx completion status "discard") until about 20 s after the
> first Auth frame of the failed attempt. In sniffer captures, 241 such
> holds ended 19.94-20.03 s after that frame. Some lasted longer (in one
> overnight run, 29 of 226 had not ended when the cycle ended), for
> example when user space gave up on the attempt during the hold. Probe
> requests still go out. The state belongs to the vdev: an attempt to
> another network (another BSS on the same AP) on the same vdev was held
> too (2 of 2), and re-creating the vdev cleared it (2 of 2). This happens
> on WPA2 networks as well as WPA3. An older firmware build,
> WLAN.HL.2.0-01387, did not hold the frames (0 of 7 reconnects after
> status 30).

This seems similar to an issue we see on the QCA6174's. I don't see a 20 
second delay, but sometimes after an auth/assoc timeout we get a spam of 
failed connections with NL80211_TIMEOUT_UNSPECIFIED. I've mentioned this 
quite some time ago [1]. Do you think it has any relation to whats being 
fixed here?

Thanks,

James

[1] 
https://lore.kernel.org/linux-wireless/441e9883-1efc-498b-ba33-6a4f12443f3b@gmail.com/

