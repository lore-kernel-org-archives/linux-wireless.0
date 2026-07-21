Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4C32DEA8F;
	Tue, 21 Jul 2026 05:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784610928; cv=none; b=CZ8jRrkU2lMXC69Wg5Sz0gAN/lO6/kDVU+pTO4Lw4WNifl+gXaj78Ggl3GT/nU8bxXEiQrGzuvg9vSi6pftny9WzEbW5iJyUwtYUXvkVpqiamfpv/SbkiDZe2Dypl2uvSMB3DFoLKm0nGCU/THyrs4/eXlsPLabyv+YQQ55xHyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784610928; c=relaxed/simple;
	bh=92iS+igxokzatGe34DnFy7AWq69/Qx1WJpRAwsFUtUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DgWsYXuJVbQyyQ+lZI63KI1IofTSe5VGOjlVwadjxNA6g0kfBgh4ZQT/XhJDaT0ZQHn0THNowgKQlczsIsNu4mIueIYSAqwwmUPQtzjFBh7SALWpiNV+3u9f0/2asq+sKC1Qpkbfa6LKtUDqtoH8daRl/VxQ9fz6AljOtY/6Ym4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=F9wXR33z; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="F9wXR33z"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id EE5601F939;
	Tue, 21 Jul 2026 07:15:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1784610921;
	bh=rIBP+cfCWHY4nS3wNo6qMF2a2hGT7OtXRAy7W4xo9Qs=; h=From:To:Subject;
	b=F9wXR33zoLkgdM5YAxz0z8QzuAFOPbHd7Q5mMJUZlAMr/lILRqVXUWVuqwBDuSHYL
	 o/m85BMPCDWXIvrs5d6s6tUKs0iOI4hPlHPAaW8qyDvyUzOVUHxBedzQQzPor9sLIz
	 7tWSN/YAUT5Gs/E/sHYcVc6stg7AOxHa6E6Y0TesEvI6nox/JUecYoxcbWBxI1WY01
	 hptGlFW7wb+QdnRe6qKkOahYaFS8kYG4gqkeoDLmG/JQsdL1up6Wqi7Lldi3mSnkwE
	 9pJJ7vW+O7AcHLA7JHQIwIQtxNZWou8lZHVHxwT/PNXschL+GFL8MEMJiypnLdwfVQ
	 bjKQhltjcwdxA==
Date: Tue, 21 Jul 2026 07:15:16 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mwifiex: validate event lengths before copying
 bodies
Message-ID: <20260721051516.GA7903@francesco-nb>
References: <20260720115119.80059-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720115119.80059-1-pengpeng@iscas.ac.cn>

On Mon, Jul 20, 2026 at 07:51:19PM +0800, Pengpeng Hou wrote:
> mwifiex event packets contain a four-byte event cause followed by the
> event body. The USB and SDIO paths copy from data after that header using
> the full packet length, so the source range extends four bytes beyond the
> skb. The SDIO path also reads the event cause before validating the
> packet and publishes oversized events without a copied body.
> 
> Reject SDIO events that are shorter than the header or larger than the
> event buffer limit, using the same skb-release path for both failures.
> Retain the equivalent USB bounds and copy only the bytes after the event
> header in both paths.
> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
> Changes since v1: https://lore.kernel.org/all/20260704011317.50900-1-pengpeng@iscas.ac.cn/
> - reject both short and oversized SDIO events through one cleanup path
> - copy only the body length in the SDIO and USB paths
> - rebase onto v7.2-rc4
> 
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 15 +++++++++++----
>  drivers/net/wireless/marvell/mwifiex/usb.c  |  3 ++-
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index f039d6f19183..4101bf1edca1 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -1712,12 +1712,19 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
>  	case MWIFIEX_TYPE_EVENT:
>  		mwifiex_dbg(adapter, EVENT,
>  			    "info: --- Rx: Event ---\n");
> +		if (skb->len < MWIFIEX_EVENT_HEADER_LEN ||
> +		    skb->len > MAX_EVENT_SIZE) {
> +			mwifiex_dbg(adapter, ERROR,
> +				    "EVENT: invalid skb->len %u\n", skb->len);
> +			dev_kfree_skb_any(skb);
> +			return -1;

break instead of return -1?

mwifiex_decode_rx_packet() never return -1 in similar situations, why
doing this only in this case?

Francesco

