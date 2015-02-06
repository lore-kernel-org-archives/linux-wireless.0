Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38206 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbbBFGmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 01:42:47 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath5k: fix spontaneus AR5312 freezes
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1422998473-3709-1-git-send-email-ryazanov.s.a@gmail.com>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Message-Id: <20150206064246.9AA43140C6D@smtp.codeaurora.org> (sfid-20150206_074249_755157_70BC53DB)
Date: Fri,  6 Feb 2015 06:42:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Sometimes while CPU have some load and ath5k doing the wireless
> interface reset the whole WiSoC completely freezes. Set of tests shows
> that using atomic delay function while we wait interface reset helps to
> avoid such freezes.
> 
> The easiest way to reproduce this issue: create a station interface,
> start continous scan with wpa_supplicant and load CPU by something. Or
> just create multiple station interfaces and put them all in continous
> scan.
> 
> This patch partially reverts the commit 1846ac3dbec0 ("ath5k: Use
> usleep_range where possible"), which replaces initial udelay()
> by usleep_range().
> 
> I do not know actual source of this issue, but all looks like that HW
> freeze is caused by transaction on internal SoC bus, while wireless
> block is in reset state.
> 
> Also I should note that I do not know how many chips are affected, but I
> did not see this issue with chips, other than AR5312.
> 
> CC: Jiri Slaby <jirislaby@gmail.com>
> CC: Nick Kossifidis <mickflemm@gmail.com>
> CC: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> Fixes: 1846ac3dbec0 ("ath5k: Use usleep_range where possible")
> Reported-by: Christophe Prevotaux <c.prevotaux@rural-networks.com>
> Tested-by: Christophe Prevotaux <c.prevotaux@rural-networks.com>
> Tested-by: Eric Bree <ebree@nltinc.com>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
