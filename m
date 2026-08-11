Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432083264F1;
	Tue, 11 Aug 2026 09:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786440860; cv=none; b=CjFlWfDvQOjmkfRvLr9U3GCuDpoP582xUlAf7P/rgsU/vKyzEADdTQ4ygev/Ls6G/BhEtiiKhKbdbK4JFaTHx7zz+1nd97z0MgcB/G3K/zqB/xTqH+6Jwwo7yzGqoP6SlK/LiOpgD+jpol5dFZdT9d+Ci58RyQcgI2K/DPRSK44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786440860; c=relaxed/simple;
	bh=ewllke0+EmgPXnALcqXSDT0heDfgtIqzqxEjHmxLcU0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lo47y0oBZQXZ7V7Eo5cccYZYWGi5v/p3Gf8jGRpGIw8LhR8nRFYJPYL0DGvy6rH742Ws4AD0dKWMueBturB+4Hou5r7al5t700Cwwjp1hfIOQSJLtWVNUdi8xb7wnIgJPKfqETMQPz3duXCtJxOXtU/L5Wa26osM5kjf/ilKxPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=green-communications.fr; spf=pass smtp.mailfrom=green-communications.fr; arc=none smtp.client-ip=212.227.126.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=green-communications.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=green-communications.fr
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue011
 [213.165.67.103]) with ESMTPSA (Nemesis) id 1MOQyE-1wW0oo37gk-00OMHc; Tue, 11
 Aug 2026 11:34:08 +0200
Message-ID: <ad56e2b3-c3f7-4461-b963-e56fa4212ed8@green-communications.fr>
Date: Tue, 11 Aug 2026 11:34:06 +0200
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
 Sean Wang <sean.wang@mediatek.com>, Bert Karwatzki <spasswolf@web.de>,
 Devin Wittmayer <lucid_duck@justthetip.ca>,
 Eric Biggers <ebiggers@kernel.org>, Thorsten Leemhuis <linux@leemhuis.info>,
 regressions@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260804120004.523934-1-mikhail.v.gavrilov@gmail.com>
Content-Language: fr
From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
In-Reply-To: <20260804120004.523934-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:07XwSLwzLwf9lYP71SE9qaK9SNl9jMQf4BS755L/Ixu9GeoJxUo
 faCo2hnaLauG/fmlPkK7C1n8lKAM4hD553SC6YCDH1XAGakcO9zN8HsaoK8hcjGR/Vim4Ll
 YvLqtVEfI5FlvmixxARVoGFfwx0piaA2xFCT23Cu1jVFrgD9HC4YmFpmPRO7KYx4XeJNhBK
 4fuV7cNUEDDiohHScyVNg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:M8MPQUp3ipc=;5ROrDF27cJsBp1kvUPjnlAByMRL
 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
 =

Le 04/08/2026 à 14:00, Mikhail Gavrilov a écrit :
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
> 
>    task:modprobe        state:D stack:25720 pid:7954  tgid:7954
>    Call Trace:
>     <TASK>
>     __schedule+0x11b8/0x26d0
>     schedule+0xe7/0x2f0
>     schedule_hrtimeout_range_clock+0x218/0x330
>     usleep_range_state+0x133/0x1b0
>     napi_disable_locked+0x37d/0x5f0
>     napi_disable+0x43/0x80
>     mt76_dma_cleanup+0x2b4/0x860 [mt76]
>     mt7921_pci_remove+0x17f/0x350 [mt7921e]
>     pci_device_remove+0xb6/0x1e0
>     device_release_driver_internal+0x38d/0x540
>     driver_detach+0xd0/0x1b0
>     bus_remove_driver+0x127/0x2d0
>     pci_unregister_driver+0x2a/0x280
>     __do_sys_delete_module+0x36a/0x5b0
>     do_syscall_64+0x11c/0x6d0
>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
>     </TASK>
> 
> Dropping the two driver-side loops instead was tried and rejected: with
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
> 
> Reported-by: Bert Karwatzki <spasswolf@web.de>
> Closes: https://lore.kernel.org/all/20260724151419.26014-1-spasswolf@web.de/
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221818
> Link: https://lore.kernel.org/all/20260730050428.GA73812@sol/ [1]
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Acked-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

Sorry for the trouble.

For what is it worth, wifibot reports: "Series targets non-next tree, 
but doesn't contain any Fixes tags"

https://patchwork.kernel.org/project/linux-wireless/patch/20260804120004.523934-1-mikhail.v.gavrilov@gmail.com/

Fixes: 13b7e6a96a00 ("wifi: mt76: Disable napi when removing device")

> Sending this because the regression is now in its second week with four
> independent reporters, and the two-part alternative (this revert plus
> napi_disable() added inside mt7915_unregister_device()) needs MT7916
> hardware that I do not have.  I deliberately left the mt7915 side out;
> Nicolas is best placed to do it, since MT7916 is what he reported
> against.

Did that here: 
https://patchwork.kernel.org/project/linux-wireless/patch/20260810154923.32546-1-nicolas.cavallari@green-communications.fr/
