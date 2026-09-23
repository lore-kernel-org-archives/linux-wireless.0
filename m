Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AE037DE83;
	Wed, 23 Sep 2026 02:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790130401; cv=none; b=rUhOHCWJvnXBSi07X0qkklCXtlnnE7AIHd7BqmN7dNQYGdncpzpqAsdMiplhzEEgO+G3Je3eu4DdYn5c0k3xvM4mthAwk/A01+Twhl0epIHBVyUwW+S5keQwDLQ2r64q6Om/tSdxRrLmqSJtWIEkuTP1FCrmxzge8csDVqDALSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790130401; c=relaxed/simple;
	bh=j7bUQF400pDYiwgMJ+fY6jNBqjzoCFhJMjSVucHap4E=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=XvbNVc0plBOh3H+3PjhUnVv8iq+wrgIIvU1rBa/rM35e00qZXmPMqZNLWRb9KT0q7iJ/3GuJr6VsE4y9e8gGJmhW0TRQcNFJ+teIgHE82LFHNU1eaem4mAPfqZj4xBPQZTDtUxAE3ick8FEcpnNlbbfNVRCqvtzBwImPkBMa60Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=IRNvyDux; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="IRNvyDux"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N2QUTQ04168887, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790130390; bh=quinJoc7LMiQbr3BZ9Nqz5Gn02OufP56+3mq/FhzUls=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=IRNvyDuxN+AKkX9RfHKz7cNiLnmi7wl43KcHbd+FXrtF8elaittsJMiq5Fe0lKOwU
	 GwcmnxaGjfKvgWC88/SM6U71yNRm0hKUUqJwKkVx5rDjGf81FDRXyuqgI+HhsUQFwa
	 PJ/2VvxXiNhEaJhHAOQwL+1HP6IffZvE1rV1/yS3v23ZCJiucEBMPqRVlSicaZStcJ
	 rSz2CgBnVrP8UE9xdNaeDB4WDfTY+tmFr471monqwrfkX/ot4kjRkWSempgN59T2wM
	 loVuoitqrIyGJ95Syo4ktp0pIvSZQ6I3y+6+MUDibexkDCcDC6dHgAh9a0e7CvCV66
	 8lJWdwrFwHA5w==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N2QUTQ04168887
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 23 Sep 2026 10:26:30 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 10:26:24 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 10:26:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Kim Wooseok <5mghybrid@khu.ac.kr>, <linux-wireless@vger.kernel.org>
CC: Ping-Ke Shih <pkshih@realtek.com>, Jes Sorensen <Jes.Sorensen@gmail.com>,
	Kalle Valo <kvalo@kernel.org>, <linux-kernel@vger.kernel.org>, Kim Wooseok
	<5mghybrid@khu.ac.kr>
Subject: Re: [PATCH rtw-next v4 1/3] wifi: rtl8xxxu: free RX skb when URB submission fails
In-Reply-To: <20260921-codex-rtl-rx-v3-submit-v4-1-eeb09fe8f791@khu.ac.kr>
References: <20260921-codex-rtl-rx-v3-submit-v4-0-eeb09fe8f791@khu.ac.kr> <20260921-codex-rtl-rx-v3-submit-v4-1-eeb09fe8f791@khu.ac.kr>
Message-ID: <9199cc45-08ff-4346-b4e7-afbfda32a790@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 23 Sep 2026 10:26:19 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Kim Wooseok <5mghybrid@khu.ac.kr> wrote:

> From: Kim Wooseok <5mghybrid@khu.ac.kr>
> 
> When usb_submit_urb() fails, rtl8xxxu_submit_rx_urb() unanchors the URB
> but leaves the newly allocated skb in urb.context. For ENOMEM/EAGAIN,
> the RX worker puts the request back on the pending list. The next
> submission allocates another skb and overwrites that pointer, leaking
> the previous buffer. Stopping before the retry also leaks it, because
> pending-list cleanup frees only the URB.
> 
> Free the skb and clear urb.context in rtl8xxxu_submit_rx_urb() when
> submission fails. This keeps buffer allocation and failure cleanup in
> the same function, so a request returned for retry or teardown no longer
> owns an skb. Remove the corresponding cleanup from start and the RX
> worker; they only need to decide whether to retry or free the URB.
> 
> Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
> Assisted-by: GPT-6 Astra
> Signed-off-by: Kim Wooseok <5mghybrid@khu.ac.kr>

3 patch(es) applied to rtw-next branch of rtw.git, thanks.

9f7edf4e8584 wifi: rtl8xxxu: free RX skb when URB submission fails
4c58fb8944a2 wifi: rtl8xxxu: unwind incomplete receive startup
2f77c6669410 wifi: rtl8xxxu: preserve RX requests across recoverable transfer errors

---
https://github.com/pkshih/rtw.git

