Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE533C10BF;
	Thu,  3 Sep 2026 18:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788461984; cv=none; b=mXxJwTaP3bwXy4cLMYwEFnxJLwx8X4WaF6kY5feEZdboWgWssNKlbBHEATWbB+L/OAoneMJgAuPOoE2kRiYBMhMc7UXnHQao+b6E+Zaj+wEhs9Cow6AYNyie0q7JMA4KjdzU4p9Bd4BxTaXc5uKpl8D+gBz3baKh4AmSKWCoJjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788461984; c=relaxed/simple;
	bh=9rlMdKLT9ZwQz2IBdKjTluaDQbnSjBTWvJ/5OcIXTdA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KPzSjvSYmdikJwKELHpWF9zytRWzouWSJ5bxJ4VxysOx4xubAUX/SlL7PIsTmjk5T7dK5OdLObFBItBNv8EtyhTcj9INqlvjWIew2qJdK3q6HFtSpsP6KkMA9/YCKPGVyPgtpv6xK4DSQmoLEQwu/+oGMJ7VCF2ILTPtGEoM63g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=buUwxI6l; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="buUwxI6l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=N3aXLM4xDtH4quSEohjf0XTdS5heaOKcxANRiQoikMw=;
	t=1788461979; x=1789671579; b=buUwxI6lJzURD8VDhJcr5Pm9InTWthJYB0oEax8bIQJv+gA
	h57KsNMeFKL9NFbCYYRGvklc8x5H0XN0RaFE9NzExP9Xvc/B8sSejumNIJg33FCDRwCE2YhYs+E0E
	tdBt4SVwrzkV3NMQgjbNJUBT0dOHPTGNNGvijTTatZNspfFWjSNxyPFkNovqrOTmF6qUHLF07gURp
	WTVEX8FZpih9SWadxwu/wsswmEV3FCviYkLlrFs88kzltO9RF2Yev6tkwf5LirR7/ghc1veNv4x/k
	w8RiLJlWW40ybudAGqOAq4IWRfnyhHte/ZVnLSe3w//GWgNRk1wgNHT2sZW6kMNw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2Ceq-00000000YRj-2JnZ;
	Thu, 03 Sep 2026 20:59:32 +0200
Message-ID: <97fdc1b8cff6477217100beb9b242ede810a7dc2.camel@sipsolutions.net>
Subject: Re: [PATCH v4] wifi: mwifiex: validate event lengths before copying
 bodies
From: Johannes Berg <johannes@sipsolutions.net>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>, Brian Norris
 <briannorris@chromium.org>
Cc: Jeff Chen <chunfan.chen@gmail.com>, Jeff Chen <jeff.chen_1@nxp.com>, 
 Francesco Dolcini <francesco@dolcini.it>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, Francesco Dolcini
 <francesco.dolcini@toradex.com>
Date: Thu, 03 Sep 2026 20:59:31 +0200
In-Reply-To: <20260731141600.2-mwifiex-v4-pengpeng@iscas.ac.cn>
References: <20260731141600.2-mwifiex-v4-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-07-31 at 22:20 +0800, Pengpeng Hou wrote:
>=20
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -1712,12 +1712,19 @@ static int mwifiex_decode_rx_packet(struct mwifie=
x_adapter *adapter,
>  	case MWIFIEX_TYPE_EVENT:
>  		mwifiex_dbg(adapter, EVENT,
>  			    "info: --- Rx: Event ---\n");
> +		if (skb->len < MWIFIEX_EVENT_HEADER_LEN ||
> +		    skb->len - MWIFIEX_EVENT_HEADER_LEN > MAX_EVENT_SIZE) {
> +			mwifiex_dbg(adapter, ERROR,
> +				    "EVENT: invalid skb->len %u\n", skb->len);
> +			dev_kfree_skb_any(skb);
> +			break;
> +		}
> +
>  		adapter->event_cause =3D get_unaligned_le32(skb->data);

Are you all sure this is right? PCIe still delivers the event w/o the
body if it's too big?

johannes
