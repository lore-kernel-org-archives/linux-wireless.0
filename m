Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26023 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbbIIJdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 05:33:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: fix mu-mimo rx status reporting
References: <1440679653-20289-1-git-send-email-michal.kazior@tieto.com>
	<1440679653-20289-2-git-send-email-michal.kazior@tieto.com>
Date: Wed, 9 Sep 2015 12:33:23 +0300
In-Reply-To: <1440679653-20289-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 27 Aug 2015 14:47:33 +0200")
Message-ID: <877fo09bto.fsf@kamboji.qca.qualcomm.com> (sfid-20150909_113352_566656_E12A9B30)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> MU-MIMO Rx involves different interpretation of
> the VHT-SIG-A compared to SU-MIMO.
>
> The incorrect interpretation led ath10k to report
> VHT MCS values greater than 9 which subsequently
> prompted mac80211 to drop such frames. This
> effectively broke Rx with MU-MIMO in many cases
> and manifested with a kernel warning in the log
> which looked like this:
>
>   [   14.552520] WARNING: CPU: 2 PID: 0 at net/mac80211/rx.c:3578 ieee80211_rx+0x26c/0x940 [mac80211]()
>   [   14.552522] Rate marked as a VHT rate but data is invalid: MCS: 10, NSS: 2
>   ... call trace follows ...
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, patch 2 applied.

-- 
Kalle Valo
