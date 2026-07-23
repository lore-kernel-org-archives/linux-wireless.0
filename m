Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7283290C9;
	Thu, 23 Jul 2026 14:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784817112; cv=none; b=sG88VSOymbHCzDr6J/Jd7j+Fos3j/mkw33FmadVIIkb4uMMq9+WVItCBtbBlwm6bWC2JQes2NaeGfZ2tpGoCUrASKrWK/o31moK0G0agG2AunJARhTChsvCL9BaR76oA5YI6uuNB1El+YR0WHKUCNsKQJcJa0qH6ZxPiqnUFoVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784817112; c=relaxed/simple;
	bh=mdG5MAvENyL65k6AlcFc4AksMusDonCUkEqrUGXIQZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBB43861zA8RpzXxEVqRHAWbExzftV/ODwNxOAzrrw8F5Qu0Bm2ML9uoFQhPIPz3VbdZGjeubhWr8zT+8zis2YKPxCKJpVmMuw5i+RfGo0XO/y1mu1EhH3g3LgGmh8do1lX5508ujdeU1uIphm4vnEqTm2YDgQGiLMJjwrpX/28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=KiycYgN3; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="KiycYgN3"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 106DD22C16;
	Thu, 23 Jul 2026 16:31:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1784817100;
	bh=nhwiqU3E3+zr9IW5f4eZjkJ1A6MoAI3zrH4fK9VldhY=; h=From:To:Subject;
	b=KiycYgN3bHZaB5AjROvODHs+/5hav0NtBGdrVDarxvbwkDI9JmkMtSMwOmEm0PNo7
	 Xyd4qmZDI9iS0zC0HXo428ymMnhwtXYVAPu8Kk3X1+z7gPXU8b5ppQHinUYyMF6N/y
	 1X+x4fhV/NjgF4ccm78P0/R3jnfwIpEFqiXejkz2bHjwkNkzatWBnnoiD3viY3bGgQ
	 UEWRSSNEPrH5idFC9rN7CXIJUYQTnp83yPZD0zBjlaD8J027i4b8Ht4/WhgOFgBvtr
	 LUvuqGZCfOYGSwDcwbhaG2wfyOgKn4i/Fr52u0qPcSeKCWCGvlQOvpKJnRwEh4dcgJ
	 VQY7DfkTUYaDA==
Date: Thu, 23 Jul 2026 16:31:36 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>, Jeff Chen <chunfan.chen@gmail.com>
Cc: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] wifi: mwifiex: validate event lengths before copying
 bodies
Message-ID: <20260723143136.GA232769@francesco-nb>
References: <20260723103510.3-mwifiex-event-v3-pengpeng@iscas.ac.cn>
 <amHdiy0tuh55F0ug@nxpwireless-Inspiron-14-Plus-7440>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amHdiy0tuh55F0ug@nxpwireless-Inspiron-14-Plus-7440>

On Thu, Jul 23, 2026 at 05:23:23PM +0800, Jeff Chen wrote:
> On Thu, Jul 23, 2026 at 10:40:05 AM +0800, Pengpeng Hou wrote:
> > mwifiex event packets contain a four-byte event cause followed by the
> > event body. The USB and SDIO paths copy from data after that header using
> > the full packet length, so the source range extends four bytes beyond the
> > skb. The SDIO path also reads the event cause before validating the
> > packet and publishes oversized events without a copied body.
> > 
> > Reject SDIO events that are shorter than the header or larger than the
> > event buffer limit. Discard them through the same free-and-break contract
> > used for unknown upload types. Retain USB's existing error path and copy
> > only the bytes after the event header in both paths.
> > 
> > Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> > ---
> > Changes since v2: https://lore.kernel.org/all/20260720115119.80059-1-pengpeng@iscas.ac.cn/
> > - replace the new SDIO return -1 with free plus break as requested
> > - preserve USB's established error return contract
> > - rebase onto the current wireless tree
> > 
> > diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > index f039d6f19183..3588c36f64cf 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > @@ -1712,12 +1712,19 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
> >  	case MWIFIEX_TYPE_EVENT:
> >  		mwifiex_dbg(adapter, EVENT,
> >  			    "info: --- Rx: Event ---\n");
> > +		if (skb->len < MWIFIEX_EVENT_HEADER_LEN ||
> > +		    skb->len > MAX_EVENT_SIZE) {
> > +			mwifiex_dbg(adapter, ERROR,
> > +				    "EVENT: invalid skb->len %u\n", skb->len);
> > +			dev_kfree_skb_any(skb);
> > +			break;
> > +		}
> 
> skb->len includes the 4-byte header, so the body size is
> skb->len - MWIFIEX_EVENT_HEADER_LEN. The upper bound should be:
> skb->len - MWIFIEX_EVENT_HEADER_LEN > MAX_EVENT_SIZE
> 
> Otherwise packets with a full MAX_EVENT_SIZE body are incorrectly
> rejected.

Agree.

Please send a v4 With that fixed, and with that feel free to add

Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
