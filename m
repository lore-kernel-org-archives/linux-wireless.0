Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3484D6C2D;
	Fri,  2 Oct 2026 16:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790956846; cv=none; b=svgcZwHeNRJnLtwGmF5VWUrqxA7AtIo3U+fIdY/AWpJrSTmfUYr9LnGoACc3rgZgeTDvEAOPXvxuCltmIbYuevsKzG/JAOe9iQIt0PwiGC7HkvWIpuIOfwUkRkxzD9vJClhC7kMblhc88Lwo9DwlYcOzfsXBdY8LVJpeHtAPdkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790956846; c=relaxed/simple;
	bh=uqoRXNb8nhCLUgiV1REVDGDZeBLMF+1B0pKcr/g40Rc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WVL+3a0X8B+n3Y7t7T49BdUOQNu+4N9h58txBSy5kK58b05YMHOdr9orThhywGydlRjmTwRwzxOwiAKCXaHgWDcNWVHyLjGds0nf1OGNd7sjiHt7yA3n+rBGJDhJY4Y0Chk855rT5hJ0CGCC12PmWzcyPnQdIdjCdjFY/edmRWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yE33YnYZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gufVQjiZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VfJNEcHD; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4grVwDEo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yE33YnYZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gufVQjiZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VfJNEcHD";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4grVwDEo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0CB9421C9A;
	Fri,  2 Oct 2026 16:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790956834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QlQ4eXkvNmCq/AL22SqSiEsqwg8fY3YhkzfHaeAUlRw=;
	b=yE33YnYZ+g0lN6zV59tbGedgFoB1c8zLp4Ws9RGYuDfUlVv3VRlhVCXgZoecBaaz9ZJhqD
	VnlqEyOX1o+uX0f4eqdi42wasE5E/9hJI6QQjSdF43ZX2Zl3ygn/9fo2Ls9pOTeWGM14FP
	P9Q4JnKZDXXTK2hBASV5PEZJj5XPctM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790956834;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QlQ4eXkvNmCq/AL22SqSiEsqwg8fY3YhkzfHaeAUlRw=;
	b=gufVQjiZaaCR0lHV1PZp8a3iFvAH1PpyQeOXFDi9KnvGhBf3PD+QOJvlgmnec7eZ/GlD0r
	JkI2Gm8L8ceFQgAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790956830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QlQ4eXkvNmCq/AL22SqSiEsqwg8fY3YhkzfHaeAUlRw=;
	b=VfJNEcHDqTDyPse7JSTojtBqdII6xQX59a1hEJc35WQPVM0MX+tXw/YZ1fOZDWrD+pyctV
	mAwOmz1fD+T0M/5VS6pSzjiKQ5goLk77dDFts2AAs1Um1URwLlnPiZewOb6/2+r33tq994
	Gzrjula3ldE4ku49D0D9CiL1tsW8j74=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790956830;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QlQ4eXkvNmCq/AL22SqSiEsqwg8fY3YhkzfHaeAUlRw=;
	b=4grVwDEoFUi2Z6j3BXP66gOiCsbPO4pDu4aqD+jlCyXAb7EJykVR4vx43PnzloOFaMz3El
	FiOV0+e22jVg6GDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8D42139C9;
	Fri,  2 Oct 2026 16:00:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Wf5kIx3Vv2ptHwAAD6G6ig
	(envelope-from <tiwai@suse.de>); Fri, 02 Oct 2026 16:00:29 +0000
Date: Fri, 02 Oct 2026 18:00:29 +0200
Message-ID: <877bk0ytwi.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Johannes Berg <johannes.berg@intel.com>,
    linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: libertas: reject short monitor TX frames
In-Reply-To: <20260704011140.37639-1-pengpeng@iscas.ac.cn>
References: <20260704011140.37639-1-pengpeng@iscas.ac.cn>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[iscas.ac.cn:email,imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO

On Sat, 04 Jul 2026 03:11:40 +0200,
Pengpeng Hou wrote:
> 
> In monitor mode, lbs_hard_start_xmit() casts skb->data to a
> radiotap TX header, skips that header, and then copies the 802.11
> destination address from offset 4 in the remaining frame.  The
> generic length check only rejects zero-length and oversized skbs, so
> a short monitor frame can be read past the end of the skb data.
> 
> Require enough bytes for the radiotap TX header and the destination
> address field before using the monitor-mode header layout.
> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/net/wireless/marvell/libertas/tx.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> --- a/drivers/net/wireless/marvell/libertas/tx.c
> +++ b/drivers/net/wireless/marvell/libertas/tx.c
> @@ -117,6 +117,13 @@
>  	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
>  		struct tx_radiotap_hdr *rtap_hdr = (void *)skb->data;
>  
> +		if (skb->len < sizeof(*rtap_hdr) + 4 + ETH_ALEN) {
> +			lbs_deb_tx("tx err: short monitor frame %u\n", skb->len);
> +			dev->stats.tx_dropped++;
> +			dev->stats.tx_errors++;
> +			goto free;
> +		}
> +
>  		/* set txpd fields from the radiotap header */
>  		txpd->tx_control = cpu_to_le32(convert_radiotap_rate_to_mv(rtap_hdr->rate));
>  
> 
> 

Now this commit is included in the stable trees, and the review for
distro kernel indicated some bugs.

The place you jump with goto-free is outside the priv->driver_lock
spinlock, while jumping to free follows the spin_unlock_irqrestore():

```
 free:
		dev_kfree_skb_any(skb);
	}

 unlock:
	spin_unlock_irqrestore(&priv->driver_lock, flags);
	wake_up(&priv->waitq);

	return ret;
}
```

So this patch introduced an unbalanced spinlock.

Moreover, at that point, priv->tx_pending_len is set to -1.  Then
netif queues won't be woken up because priv->tx_pending_len isn't
restored -- which may lead to permanently blocking transmission.

I guess this fix needs to be revisited or reverted.


thanks,

Takashi
