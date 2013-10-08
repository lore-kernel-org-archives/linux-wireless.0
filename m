Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:63652 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab3JHTUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 15:20:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH/RFT v2 0/4] ath10k: fixes
References: <1380805765-31521-1-git-send-email-michal.kazior@tieto.com>
	<1380865425-3791-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 8 Oct 2013 22:17:30 +0300
In-Reply-To: <1380865425-3791-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 4 Oct 2013 07:43:41 +0200")
Message-ID: <87ob6zr2r9.fsf@kamboji.qca.qualcomm.com> (sfid-20131008_212049_162706_77CF9AAE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This patchset addresses recently spotted issue
> with (yet another) scheduling while atomic bug
> (the other being WEP key index setting). This one
> is related to hw_config() and powersave settings.
> This comes from recent changes I've done to
> HTC/WMI. WMI commands can block now so it's
> illegal to call them in an atomic context anymore.
>
> ath10k needs to setup some settings per-vdev (i.e.
> per-interface) such as powersave, rts, fragmentation.
> Until now mac80211 iteration functions were used.
> However using non-atomic iteration function variant
> doesn't solve the problem as it introduces an
> issue with iflist_mtx deadlock in some cases.
>
> I briefly tried to reproduce the issue Kalle
> reported but was unsuccessful thus the "/RFT".
>
> v2:
>  * fix kbuild test robot warning
>    (uninitialized `ret`)
>  * add patch #4 that removes code that becomes
>    unnecessary after patch #3
>
>
> Michal Kazior (4):
>   ath10k: fix add_interface failure handling
>   ath10k: track vif list internally
>   ath10k: fix scheduling while atomic config bug
>   ath10k: remove unnecessary checks

Due to problems with patch 1 I'm dropping this patchset for now.

-- 
Kalle Valo
