Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61573C68A
	for <linux-wireless@vger.kernel.org>; Mon, 12 Feb 2024 15:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707752268; cv=none; b=i7vnUysJIQBn2L9yCnJHKyxca+qOvBrAYn0OL6SV/a+ThVHgUTdRxCmnaml2N91Mgr5HN3EHi2VzIU0MH0eL44pkHXs3E7J1Y3Dh32QcQgu7h8UjYx7qzteCO+UIJYfABzmFGIyA1c8TVZB1KEglhnjppb0ejQLJP8i/PaxQxCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707752268; c=relaxed/simple;
	bh=igfkJTvjRNdI54+qIvnhJ0gZeN0TQlPRGirAI5EtB9A=;
	h=Content-Type:MIME-Version:Subject:From:In-Reply-To:References:To:
	 Cc:Message-ID:Date; b=Fs3QrfvPfllNs86lqczzyL/C8eKqTUsa3wm4nFwT6wP65GvuXumebakwAeEyNer5qDTXRPTEB+BA2I4N2oPTWQ2ERyr/rmUTn/KbdMT6nRh9Pf7NVJVbdeen9nHFR9PF4SZRzICrxUG7fRmeMP/8aha7XWCc+h7ijXROiHTR7SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U++PPMw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U++PPMw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B797C43390;
	Mon, 12 Feb 2024 15:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707752268;
	bh=igfkJTvjRNdI54+qIvnhJ0gZeN0TQlPRGirAI5EtB9A=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=U++PPMw1AeNEBIdAJWoxMtXjhr5z7GLyN2ZRG6a1Rl1TtJKrJ2qRq8ZRLIpEOfgs6
	 HPYDvSd3DI5/xpKp/GkzStUT8rD9mqHXGa0s3Y10XFi5jeQv/fgkujv/9xE/A5zu3T
	 GDw7zzAy+IPoEETn+WEoxt92xuOVA/CdqH4OG+jDP/wOekrD0kvBXD49hAoXekjeRH
	 EyzE1OawLWd3J4rbCfY27xEj/k33+iIsQp2gbd03X7ZIv4W3HF+CJnns4+FevVC1Li
	 GhrdYp9sS/VKF8O4HW/aAFRfRFiYVKc0xPVQSQQscd/KNWY5J0tyWcMnxurT1QsLn+
	 EIAayGN/bwP6w==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: wilc1000: correct CRC7 calculation
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20240207050736.2717641-1-davidm@egauge.net>
References: <20240207050736.2717641-1-davidm@egauge.net>
To: David Mosberger-Tang <davidm@egauge.net>
Cc: linux-wireless@vger.kernel.org, Ajay.Kathat@microchip.com,
 alexis.lothore@bootlin.com, David Mosberger-Tang <davidm@egauge.net>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <170775226580.2851594.14123930588067888872.kvalo@kernel.org>
Date: Mon, 12 Feb 2024 15:37:47 +0000 (UTC)

David Mosberger-Tang <davidm@egauge.net> wrote:

> Document
> 
>     ATWILC1000/ATWILC3000
>     Baremetal Wi-Fi/BLE Link Controller Software Design Guide
> 
>     https://tinyurl.com/yer2xhyc
> 
> says that bit 0 of the CRC7 code must always be a 1.
> 
> I confirmed that today with a logic analyzer: setting bit 0 causes
> wilc1000 to accept a command with CRC7 enabled, whereas clearing bit 0
> causes wilc1000 to reject the command with a CRC error.
> 
> Signed-off-by: David Mosberger-Tang <davidm@egauge.net>

Patch applied to wireless-next.git, thanks.

c08a986344a5 wifi: wilc1000: correct CRC7 calculation

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20240207050736.2717641-1-davidm@egauge.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

