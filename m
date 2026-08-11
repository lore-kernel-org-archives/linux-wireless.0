Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.61.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2681313546;
	Tue, 11 Aug 2026 09:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.61.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786439506; cv=none; b=QmBLmoZIiC8fuRUA/xLgUFs+PXB9L1lJ6PjxvIYAZscnaCfiH5KZesvzhgigguE76ZQmF1tLzecCyjDUSLX3IEJZUdgemfXi9ZVI9gcidBRmsYPyp4/DD5KcmOf7Kx6dRxqHe2QqK9ML9XDIgcKORhaFcGvtgaeuUxrzJI/nq6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786439506; c=relaxed/simple;
	bh=pduLq0xfM1j5vFXj++w3Ljq3jSAnaaIYmtcTGSCxgjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MDJgdP/Pdvm4/XugIdIFDBNcl6W17pDijA460cpwEGwUBuQicInQeaum9ZN1RLojJhqPMRKprQwr+htF4TbMe+lxASa42zksGciPIBGYUY1oAHez8lu0/QbMdvwcEmKop43ls8IvOq75A9531aFgPRscH7qXfLVPj72olYwFAIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=hgx0TiHl; arc=none smtp.client-ip=188.68.61.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="hgx0TiHl"
Received: from mors-relay-8403.netcup.net (localhost [127.0.0.1])
	by mors-relay-8403.netcup.net (Postfix) with ESMTPS id 4hK5Tf0lLrz8G6W;
	Tue, 11 Aug 2026 11:11:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1786439494;
	bh=pduLq0xfM1j5vFXj++w3Ljq3jSAnaaIYmtcTGSCxgjo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hgx0TiHlkbXSyFXHiLFytZ0ReEpk6pT6L2OzuA8Gcl1qMhPJgLMXPK2bGjDFNpbBQ
	 ni50h2NCD1GYhKhG/OESQrtrdarRs/BxlVDMb6nyc7Dizun+K0UDoW99eXMTvlar5h
	 FOcwNEJ3oOiAHe8FDkmliPeAn+hpMPQOva9+xAQxdEOuq0GFrbD9AWOXVPnd9SCUgQ
	 tGlJQ3PoYBqVEi+993k2evfTXVn6UqxzUS+5+dlm4x+FC3/8VEeXm17vQ7wgfReNOY
	 VzKdYKkXAY5SYgBJZEQBFSA4hdlddzEuqOBbiRaDqokmCC2nQ805mkHQZHZa3QkuSk
	 NlR8hT+dyMSbw==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8403.netcup.net (Postfix) with ESMTPS id 4hK5Tf00Ttz8FsC;
	Tue, 11 Aug 2026 11:11:34 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4hK5Td1RYRz8sb9;
	Tue, 11 Aug 2026 11:11:33 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 49F0B5FB9F;
	Tue, 11 Aug 2026 11:11:32 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <18b018d0-7f7d-4975-b0b3-5e3c9f413698@leemhuis.info>
Date: Tue, 11 Aug 2026 11:11:31 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless] Revert "wifi: mt76: Disable napi when removing
 device"
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
 linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>,
 Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
 Bert Karwatzki <spasswolf@web.de>, Devin Wittmayer
 <lucid_duck@justthetip.ca>, Eric Biggers <ebiggers@kernel.org>,
 regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <20260804120004.523934-1-mikhail.v.gavrilov@gmail.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
X-Enigmail-Draft-Status: N11222
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 MEK4
In-Reply-To: <20260804120004.523934-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <178643949291.1778080.8629527780920957825@mxe9fb.netcup.net>
X-NC-CID: uzt+PSFyfq7cjCp0QSeR89ltQkT0z8wf4jqMtxuhVJK9Vra3dw4=

On 8/4/26 14:00, Mikhail Gavrilov wrote:
> This reverts commit 13b7e6a96a005c656d38f3da51581deaf9866375.
> 
> That commit made mt76_dma_cleanup() disable every RX NAPI instance before
> deleting it, to silence WARNs in __netif_napi_del_locked() and
> page_pool_disable_direct_recycling() seen when unloading mt7915e with an
> MT7916.
> 
> On mt7921e and mt7925e the same instances are already disabled earlier,
> in mt7921e_unregister_device() and mt7925e_unregister_device(), which
> only afterwards call mt792x_dma_cleanup() -> mt76_dma_cleanup().  Each
> instance is therefore disabled twice, and napi_disable() is not
> idempotent: on return it leaves NAPIF_STATE_SCHED and NAPIF_STATE_NPSVC
> set, so the second call spins in usleep_range() forever, waiting for bits
> that nobody will clear.
> 
> mt7921_pci_shutdown() and mt7925_pci_shutdown() reuse the remove path, so
> this is hit on every reboot, poweroff and module unload.  It is silent:
> the stuck task keeps sleeping and rescheduling, so neither the hung task
> detector nor the lockup detectors fire, and the last line on the console
> is "systemd-shutdown[1]: Rebooting."
> [...]> Dropping the two driver-side loops instead was tried and
rejected: with
> them gone, the RX poll can reach mt76_token_release() via
> PKT_TYPE_TXRX_NOTIFY and mt7921_mac_tx_free() while
> mt76_connac2_tx_token_put() is running idr_destroy(&dev->token) outside
> token_lock, which is a use-after-free rather than a hang [1].
> 
> Revert for now, so that reboot, poweroff and module unload work again.
> The WARNs on mt7915e are a less severe problem than an unbootable
> machine, and fixing them belongs in the drivers that delete the NAPI
> instances, where each one can pick a point that is safe for its own
> teardown order, rather than in the shared mt76_dma_cleanup().

What's the status of this? Looks like things stalled.

> Reported-by: Bert Karwatzki <spasswolf@web.de>
> Closes: https://lore.kernel.org/all/20260724151419.26014-1-spasswolf@web.de/
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221818

FWIW, I think it would be good to get this revert into 7.2 final, as
there were more reports about this:

https://bugzilla.kernel.org/show_bug.cgi?id=221848
https://bugzilla.kernel.org/show_bug.cgi?id=221862

And this is likely the same issue, too:
https://bugzilla.kernel.org/show_bug.cgi?id=221831

I've also seen multiple people mention it in a matrix channel dedicated
to Fedora's kernel.

Ciao, Thorsten

> Link: https://lore.kernel.org/all/20260730050428.GA73812@sol/ [1]
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> ---
> 
> Sending this because the regression is now in its second week with four
> independent reporters, and the two-part alternative (this revert plus
> napi_disable() added inside mt7915_unregister_device()) needs MT7916
> hardware that I do not have.  I deliberately left the mt7915 side out;
> Nicolas is best placed to do it, since MT7916 is what he reported
> against.
>  
> Verified on 7.2.0-rc5 with KASAN and lockdep enabled, MT7922 / mt7921e:
> before the revert 'modprobe -r mt7921e' hangs (backtrace above, taken
> with sysrq-w) and the machine never gets past "Rebooting."; after it,
> module unload and reload, reboot and poweroff all work again.
>  
> The hang was independently bisected to the same commit by Bert Karwatzki
> on MT7925 and reproduced by Devin Wittmayer on MT7927 and MT7922, and
> Eric Biggers saw it on mt7925e as well.
> 
>  drivers/net/wireless/mediatek/mt76/dma.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
> index 322041859217..f8c2fe5f2f58 100644
> --- a/drivers/net/wireless/mediatek/mt76/dma.c
> +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> @@ -1189,10 +1189,7 @@ void mt76_dma_cleanup(struct mt76_dev *dev)
>  	mt76_for_each_q_rx(dev, i) {
>  		struct mt76_queue *q = &dev->q_rx[i];
>  
> -		if (!mt76_queue_is_wed_rro(q)) {
> -			napi_disable(&dev->napi[i]);
> -			netif_napi_del(&dev->napi[i]);
> -		}
> +		netif_napi_del(&dev->napi[i]);
>  		mt76_dma_rx_cleanup(dev, q);
>  
>  		page_pool_destroy(q->page_pool);

