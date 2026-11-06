Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.158.117
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793961693;
	b=CUuQFtorSZMiSOyJw4rRNzKPqiCODFF9dtUpZsuaj5dIB4xeT8NQDLMJYfoMDUp+6HJK
	 btR/gHgR4DFVYUj48VVz07SJ+Yavfoa9iFCLDpBo8SsNlflOj0nxNdfnERB0pIdvr/hVO
	 u4MdgyuCHJaliT3ZmS7JpMZTV3rDBVMMGEJdcXrakb5j3WycRyGCaa8qmurWG1k+YVyyB
	 JOc3+2LJ8V/szGllWK4yCnqIXDVE7ADc7Y9q662C2h73QljeUByaA+5OCKRfP6abESTEU
	 nVFS663wpkUTcR5uqz0sb5jtFrAnY1pPyILdN7Xj+P0PwjQ6KxaqcbaYW64pSo1kYYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793961693;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=VVLo+1PoaqL+9ZuGgKyKf3JrT04a5KF8FAVfDEZgKGg=;
	b=xupcfpZRdxgtF9UHib4CtUA29weopNsUXj2bJeP61yugGxJmMD6hdurxNUHZ8I7lhjSY
	 ReCUanEvJtxJVV1oC15PAwI166F8f+DE5Qm2F1JPJs68VGHIeIv7kcJXOTRe6J7WZyqPz
	 G9ckKM6TSfHOo0cq8WgFCCGlZWiTLWEMLQPDIR/6w7AhCYc+qBbNoAfV3QZXKfsnieW47
	 zAXDwsr9RmrPCL6u6zlMahBIA7ZSJiwd9xSttEIj2Xiqa9/dlNTY+1++d0KcTPh0thk3k
	 kO7Ao7H7SGF9Z9VTrgjyhOYkWfXQ1sYzXUwONRwnlUVps28ZbHznvTaybYbxgW0qJRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=Uaq37KtJ;
	arc=none smtp.remote-ip=62.149.158.117
Received: from smtpcmd03117.aruba.it (smtpcmd03117.aruba.it [62.149.158.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC37606A336
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 10:41:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FC37606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=Uaq37KtJ
Received: from DELL-MOBILE03.ad.smart.it ([87.16.49.252])
	by Aruba SMTP with ESMTPSA
	id PHNwxz9v507TYPHNwxQBzh; Fri, 06 Nov 2026 11:41:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793961689; bh=rnIcWknTm82+IfhrWzDsEesFJyKXyUrZvYdUYSEquMo=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=Uaq37KtJQ6CPpxSvZ8q9mpxdNteQwmJog9MVuJ4+TBoWbG+StLd7U5viN6sjSXzyx
	 129NbkVAt6YbuUOtgB4lUN2P5t5bdUCYBqcR4Z/t3cvi8aFFMtmPBvyv4QmLIIjB7R
	 AdWemGAXZawgRV3ONgoUKWULJdFh3sGE4VKQqRJX7HCUpxXWwbYWBy+4dgXCiQjQKy
	 oiFPbTikZl+rSSYH9NspcshI0HhraS1v6yIibZg7AgAAbxUNJxux92jimwPNWb1UAK
	 i58RRCNBpTAXbeXPxMeAVfFh4TU+qkuI+1T9KQMciBqhsgLBXb4G3oEOqNpuPMdEjq
	 myEctcse9LkAw==
Date: Fri, 6 Nov 2026 11:41:26 +0100
From: Alessio Ferri <alessio.ferri@mythread.it>
To: Luca Casati <luk00casati@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
 arend.vanspriel@broadcom.com, b43-dev@lists.infradead.org
Subject: Re: [PATCH wireless-next 4/5] b43: N-PHY: wait for the first 2057
 RC calibration run
Message-ID: <20261106114126.235ce63d@DELL-MOBILE03.ad.smart.it>
In-Reply-To: <20261026181543.77763-5-luk00casati@gmail.com>
References: <20261026181543.77763-1-luk00casati@gmail.com>
	<20261026181543.77763-5-luk00casati@gmail.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfFkGvyzT1Bin2ldD6WeRe2uCeHeZ8fF2waBGxf38ODpZU7EB6Ba7SXADOaxej3LHJt6nPCEPkfkxqsbMraPOjnmq8yRwXobOAk6flFjtrzS5sZKy1ebH
 l8tx9sb0N2OBUmky0Wc227yUap8b3nIK4tOqTDdxQYmLtqBhTKJ8VQ47dVkRsn9aWkjfZREXcqhZfuSNNE6+C1lmfBxBDrj98Psb4pEoaszFs0a5mCvvvEL7
 b9gQNX4/JVBqIYdHfd6ErytrP+SkjQBOs63Fg634BpYfdxh/IhraXFPpvR3A7aPVnNaNslOw+PuXIE7HS264hcAT1awhScw8kkuG+dwssb2CtDulYLTTXkcw
 uvyWFFDwCtNN+JfadRPovxzBEUdjxA==

On Mon, 26 Oct 2026 19:15:42 +0100
Luca Casati <luk00casati@gmail.com> wrote:

> RCCAL_DONE_OSCCAP still shows the previous run's done bit for a few us
> after a start, and the first (SCAP) run polled it immediately, so the
> run was stopped before it happened. RCCAL_SCAP_VAL then read 0 (wl
> gets 8 on a BCM43228), which detunes the TX low-pass filter set up in
> the rev7+ workarounds. Sleep before polling, as the other two runs do.
> 
> Found and fixed with the help of an AI coding assistant (Claude Opus
> 5.5), by comparing mmiotraces of b43 and wl on the same card.
> 
> Signed-off-by: Luca Casati <luk00casati@gmail.com>
> ---
>  drivers/net/wireless/broadcom/b43/phy_n.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c
> b/drivers/net/wireless/broadcom/b43/phy_n.c index
> 44769dbb7..cd50614ff 100644 ---
> a/drivers/net/wireless/broadcom/b43/phy_n.c +++
> b/drivers/net/wireless/broadcom/b43/phy_n.c @@ -938,8 +938,15 @@
> static u16 b43_radio_2057_rccal(struct b43_wldev *dev) }
>  	b43_radio_write(dev, R2057_RCCAL_X1, 0x6E);
>  
> -	/* Start, wait, stop */
> +	/*
> +	 * Start, wait, stop. DONE still holds the previous run's
> done bit
> +	 * for a few us after the start, so give the cal time to
> clear it
> +	 * before polling, as for the other two runs. Polling right
> away
> +	 * stopped this (SCAP) cal before it ran and left
> RCCAL_SCAP_VAL at
> +	 * 0, which detunes the TX LPF on radio rev 9.
> +	 */
>  	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x55);
> +	usleep_range(70, 140);
>  	if (!b43_radio_wait_value(dev, R2057_RCCAL_DONE_OSCCAP, 2,
> 2, 500, 5000000))
>  		b43dbg(dev->wl, "Radio 0x2057 rccal timeout\n");


It seems to me, from your own traces, that wl does as b43. It
doesn't wait and it exits immediately, just like b43. So the commit
message is wrong. 
Note: There is a bug somewhere, because wl do read 8, while b43 do
read 0, but this isn't the reason. Find the real motivation and provide
the real fix.

Alessio
