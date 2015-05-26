Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58680 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbbEZN5v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:57:51 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: brcmfmac: avoid gcc-5.1 warning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <2201884.BixNBcLJhn@wuerfel>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arend Van Spriel <arend@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Brett Rudley <brudley@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Message-Id: <20150526105410.13F6F1416C2@smtp.codeaurora.org> (sfid-20150526_155810_059490_B44B33C6)
Date: Tue, 26 May 2015 10:54:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> gcc-5.0 gained a new warning in the fwsignal portion of the brcmfmac
> driver:
> 
> drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c: In function 'brcmf_fws_txs_process':
> drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c:1478:8: warning: 'skb' may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> This is a false positive, and marking the brcmf_fws_hanger_poppkt function
> as 'static inline' makes the warning go away. I have checked the object
> file output and while a little code gets moved around, the size of
> the binary remains identical.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
