Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651794;
	b=JwCR4OmlIORKhgxmbukYb7B4esMftyaxDsuKomTb9aSihF5AncbA9KEck63/YfC6IR1Z
	 oO7k3B6LjxQVr31bAqMlO1aRfNk7Z48mm5ffe6a1ZKQ4MCWoaPKwWpB6/sqiX356M5RCf
	 arLBqNsjOkqrhwk4saJRAkG///R5q6HB4KoSP4Ft98Z1GR5/ar7hgc7+rC0fMVdcPoZ9h
	 IteiIGO/r0vgbgJj05ICs3dB54WHP2ngE5/tkH7IoxByUxAQlKBCovDggoycf8pqlmYXO
	 3PEyYZ1qvGrEsJxV0RUgDjtWCr8ZzgWllNElp40OOK9P6+LMfVh5aJZtjgCMvXuUYAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651794;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=bHWKaERtAi0KZdxKYF+OUpJ8/Bldo0rEve4gnihr47s=;
	b=Qh+8U5pVjW0Fbc6gJ4tu6tThlJ6BvK7ptEJUhB8sdZHhzVFv+pdUJTDOapDS1pkwbrFB
	 P4xE5mIh7DkUmSOCkEL2cR+lgs+izhupHJyFkdbfR6YL1HcPYHcHEYM8BTGFjgaEkQKHi
	 S2MfKedGUW/28s9heQ7sXr9aUKnUKWVHfTzMNkRbZDqpUmyXv/+wAXSCJ88y7FCF7npB/
	 3Y5d3aF0tRErCniWlDa4y818xCLOHX5aHdRJYQH5NLxyWo0Czh4JyJQ77vKyGym/JzKvp
	 iQINoMuveuGIz6rgb+IED1YhCdN0yghpE30VX9T5/Cl+ZOjTRGNM4myiMKfbqOwfzVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=jannau.net;
	spf=pass smtp.mailfrom=jannau.net;
	dkim=pass header.d=jannau.net header.i=@jannau.net header.a=rsa-sha256 header.s=fm1 header.b=os8Ll2R1;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=h5DOnkEO;
	arc=none smtp.remote-ip=103.168.172.149
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7A9606A335
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C7A9606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jannau.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jannau.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jannau.net header.i=@jannau.net header.a=rsa-sha256 header.s=fm1 header.b=os8Ll2R1;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=h5DOnkEO
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 85A03EC0665
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 15:36:32 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 02 Nov 2026 15:36:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jannau.net; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1793651792; x=1793738192; bh=bHWKaERtAi
	0KZdxKYF+OUpJ8/Bldo0rEve4gnihr47s=; b=os8Ll2R1WPClwOD0418Dt38jFf
	xcyFj2bptWy4byXoq4AY6B/CcBISHNZiyWIturlDvoJ09xkoNEg2qzwzl9OHBBaa
	5qK1ZW5xL6zs9ORjsif8rZ1NDoObRfiM5N6nsN+i5mf5n+ITr90/bLvZYYaMMJPZ
	XUlN3l7w/yhmYxETSXdgy5iLDZOP3EpRXlfn7POds446JcFH38EzK3tJXd2CTXte
	vGSe+MiDG9FC4BIBnlPGD3lG6ZHXBO4PbmHGGvQjMpXAXu7fcoyK2zofZJfxOhDZ
	Gb60OfELKosf7XJbWMVdgu4+cRVqrXknMwDBYzUuN3zi8GAUukhFHWr1xRRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793651792; x=1793738192; bh=bHWKaERtAi0KZdxKYF+OUpJ8/Bldo0rEve4
	gnihr47s=; b=h5DOnkEOCKYPpn8pOV3NDM24QIRjPjvfwfNZBcIjtFl6qOI8tnw
	p0XQPddjwMGtunEdga8+8W6QS/5K6+Igp7s05d9OyB0rIhw6r/55GrHyjL7Q82Xg
	QoM2rJ1QbGxwPgYJQEQZnypB3jXYDjNaafZwtxdrw6MKeMRKofojpHF78T0mHkYE
	W8Fnl79gt4Ravugo8lVNonsSuXKTFccA1WZv5lE8Gya31J6Ik6me1Tkb555vt+sI
	TwNYo1jzBe1g6jO1jQgkI1E/gEbjaQIoSADEQNo3uZ81+22Qd85+Q/WVqqnaooTl
	UbEv2gAgk+375xiJOzfqdWcAqcMJNxK8qMA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=jannau.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793651792; d=jannau.net;
	mf=PGpAamFubmF1Lm5ldD4=;
	rt=PGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:eVs6q8YkQ9JlcVwbZwN7jn1af+BeyGWmHfy9rWzEGS6f422
	MAe1l5BsFfjoZ2HtMeznGXRzjzi7VsGbzNseszzZSNfTkEliddAykoZze+kCGf9W
	cL8dDTAA87CyTsJr2qaOABUHXg5UDkjXz9RF26YlQbpS0SfD7KAkImIEhjfmAwD3
	7jOOlxa+V4Z59BoAWqg3RJqz1+nToOliH/lWU8d0ds7F4rX0INLk6yUbvnrXrXrX
	KwIacX3JOXN5gzdEFttu5ihBgwteNMe0eoN4GUaS4lutc9IcKJ80d9j+NwWnRkO0
	LnZz6HY0YYpjkJ6CG810CElX8owH/dwfWntXNAQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:GBByxwy6Y+7EBiXGCpW7rPEigVJIy5KDT7P2syj2s1A=:4ImU0nTE+hMJVvzGDTYVbJNhPQLEnCoRx0cWZ3ikQVo=;
X-ME-Sender: <xms:UPToaoSb8wznKirn8BunyCD-NadKuT-bcKgO-GF_R_sW3qCh-oQXNg>
    <xme:UPToahuOZoBdehcXISuXK8qY8EfhzqCR7_0F_dRCIXeG07vHlwUQPvzcdwMP0xkNW
    uB00NFtvhn2yL8rmOIzxz20-O4c-g8Dp798BXHCmGzepSHge6lo0MFD>
X-ME-Received: <xmr:UPToar9fHP0tPduyopTdi2nQzMbwTyGmakbFWKMkZR63HxGXwlcUhUFCed4PZl627ZjWEy4h6ODjv3eOOl1PKW5idhKa_uXiJ1I>
X-ME-Proxy-Cause: dmFkZTETqbBZgMr8LASuCzYXMcQ1n8Wz2x7AzJAiO29JCpVXDRhjMr32l3uAMprjAEUqtK
    GKYpo725RJvnQo1g6HAzrgJoMl+ceaIzsdelMfjqBm6W9AbrHj0EqQvCvQZtCmV8DGu1Ic
    wT9Ob1vXJ9se9or8imCctZAu3TIyPKAv1hchNzuVZ8H2F9HxRi4svI8/C6zcjdKxNe2D7f
    BT4WL4uDP0e8knk+un4CjXroDmw9BMcw+HDIynjDn51t/KMf9I9qSwfD6pwAdWgRblocbR
    eKLxC55g3/MswkFakXzkeL6eZidN1byrvqSpPcFyjhb2V9vmbTiMptZJj7WuFAfFT1NNLK
    JsMMYWOPeVGz1SfipOX8tyjTXIX+DAXqYCDB7E+X8u/YQ33FwmKhsVEUtd2fPr43hExoWp
    nocn/pCjnefnH74kE7KZWr0Wg7ThfDaFqxf6uogXpwZd9Zndx3cb1F9CiALQyxIUCuQNDb
    yKfvJX3QyJCSeo1FVCC9rIGqkbrRs6UcNKDi2YppI49p+bryibWnGwiP2un8RNH6tZPZd/
    fhD71sfaP5deMPDg4hdhLIsH6lKd++q9mySxHPRYo6J8OHdbZNsZi7OUqKE+xI8aybLw5s
    BjquyB9jKg4FOxgOqBfIjmbUMMPbVQ1Tb0+J6rKb7zDbCBH49CJvc9oSkhFA
X-ME-Proxy: <xmx:UPToaiY31EthMldCqYfhCbMfBvCGXhK_ZJvvCrvyJWXNDtZ4gafN6A>
    <xmx:UPToavpRr8pnbKDu2l1Wf5raDtPDKQ6HOaaxvIR9i2FZQw7h4xvmzw>
    <xmx:UPToaiYf7cu4mN96YPI5KFpwABvuEgcnsy-3fqXIRD4c5Dfm-5uaXg>
    <xmx:UPToaq6GmdMGKl-5Oq4HvFVcRPng1vcmRvyNS35l76g-k2-15r2Y0g>
    <xmx:UPToapZATw_31BIiYUwOqHJYz8wPwpdWkfwBKorGsPVHSrHiC8PW5BV->
Feedback-ID: i47b949f6:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 15:36:31 -0500 (EST)
Date: Mon, 2 Nov 2026 21:36:29 +0100
From: Janne Grunau <j@jannau.net>
To: michael.reeves077@gmail.com
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"Franky Lin (Zhenhui)" <frankyl@broadcom.com>,
	Mathy Vanhoef <vanhoefm@gmail.com>, Kalle Valo <kvalo@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com, asahi@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Daniel Berlin <dberlin@dberlin.org>, linux-kernel@vger.kernel.org,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 13/13] wifi: brcmfmac: Add BCM4388 support
Message-ID: <20261102203629.GA770347@robin.jannau.net>
References: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
 <20260925-brcm4388-submit-v1-13-b5cbc2cde2fb@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260925-brcm4388-submit-v1-13-b5cbc2cde2fb@gmail.com>

On Fri, Sep 25, 2026 at 11:43:48PM +1000, Michael Reeves via B4 Relay wrote:
> From: Hector Martin <marcan@marcan.st>
> 
> Add BCM4388 firmware mappings, RAM base and OTP handling, and increase
> the RX posting and completion ring capacities to 2048 items.
> 
> On BCM4388, DMA_FROM_DEVICE mappings for posted receive buffers cause
> DART read-permission faults followed by firmware DMA failure. Map these
> buffers with DMA_BIDIRECTIONAL to allow device reads as well as writes.

Not only on BCM4388. See commit 7ed5dce55fa8 ("wifi: brcmfmac: map msgbuf
RX packet IDs bidirectional") [1] only in wireless/main, doesn't seem to
made it into next yet. BCM4378 and BCM4387 do need the RX msgbufs mapped
as bidirectional as well.

Link: https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git/commit/?id=7ed5dce55fa8393972b1bf2bf5af1c818c5e7dc2 [1]

> Keep the existing mapping direction for other chips.
> 
> Signed-off-by: Hector Martin <marcan@marcan.st>
> Co-developed-by: Michael Reeves <michael.reeves077@gmail.com>
> Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c      |  1 +
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c    |  8 +++++---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h    |  4 ++--
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c      | 12 +++++++++++-
>  .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h    |  2 ++
>  5 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> index 253ab45c33..411188010f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> @@ -751,6 +751,7 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
>  	case BRCM_CC_4366_CHIP_ID:
>  	case BRCM_CC_43664_CHIP_ID:
>  	case BRCM_CC_43666_CHIP_ID:
> +	case BRCM_CC_4388_CHIP_ID:
>  		return 0x200000;
>  	case BRCM_CC_4355_CHIP_ID:
>  	case BRCM_CC_4359_CHIP_ID:
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> index 8e5c697e7f..5ad46d7ec6 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> @@ -12,6 +12,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>
>  
> +#include <brcm_hw_ids.h>
>  #include <brcmu_utils.h>
>  #include <brcmu_wifi.h>
>  
> @@ -51,7 +52,7 @@
>  #define MSGBUF_TYPE_D2H_MAILBOX_DATA		0x24
>  
>  #define NR_TX_PKTIDS				2048
> -#define NR_RX_PKTIDS				1024
> +#define NR_RX_PKTIDS				2048
>  
>  #define BRCMF_IOCTL_REQ_PKTID			0xFFFE
>  
> @@ -330,7 +331,6 @@ brcmf_msgbuf_init_pktids(u32 nr_array_entries,
>  	return pktids;
>  }
>  
> -

nit: cosmetic change

>  static int
>  brcmf_msgbuf_alloc_pktid(struct device *dev,
>  			 struct brcmf_msgbuf_pktids *pktids,
> @@ -1695,8 +1695,10 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
>  						     DMA_TO_DEVICE);
>  	if (!msgbuf->tx_pktids)
>  		goto fail;
> +	/* BCM4388 firmware also reads from posted RX buffers. */
>  	msgbuf->rx_pktids = brcmf_msgbuf_init_pktids(NR_RX_PKTIDS,
> -						     DMA_FROM_DEVICE);
> +			drvr->bus_if->chip == BRCM_CC_4388_CHIP_ID ?
> +			DMA_BIDIRECTIONAL : DMA_FROM_DEVICE);

This conflicts with the linked change. Best to drop this hunk and rely
on the linked change.

[...]

> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -2459,7 +2468,7 @@ static int brcmf_pcie_read_otp(struct brcmf_pciedev_info *devinfo)
>  
>  static bool brcmf_pcie_request_fw_signature(struct brcmf_pciedev_info *devinfo)
>  {
> -	return false;
> +	return devinfo->ci->chip == BRCM_CC_4388_CHIP_ID;
>  }

nit: this is hard to extend.

```
        switch (devinfo->ci->chip) {
	case BRCM_CC_4388_CHIP_ID:
	        return true;
	default:
	        return false;
	}
```
would be easier to extend and is in my opinion easier to read

Janne
