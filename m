Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1144 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab3JGQdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 12:33:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: Fix bug in max. VHT A-MPDU size
References: <to=1380292567-2363-1-git-send-email-michal.kazior@tieto.com>
	<1380874630-14280-1-git-send-email-michal.kazior@tieto.com>
	<1380874630-14280-2-git-send-email-michal.kazior@tieto.com>
Date: Mon, 7 Oct 2013 19:33:35 +0300
In-Reply-To: <1380874630-14280-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 4 Oct 2013 10:17:09 +0200")
Message-ID: <87pprht50g.fsf@kamboji.qca.qualcomm.com> (sfid-20131007_183349_238059_C2C6DECF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> For VHT peers, the maximum A-MPDU size has to be calculated
> from the VHT capabilities element and not the HT-cap. The formula
> is the same, but a higher value is used in VHT, allowing larger
> aggregates to be transmitted.
>
> The patch contains a workaround for some Netgear/Linksys APs that
> report Rx A-MPDU factor incorrectly.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I see warnings with this patch:

drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_peer_assoc_h_vht':
drivers/net/wireless/ath/ath10k/mac.c:1049:179: warning: comparison of distinct pointer types lacks a cast [enabled by default]
drivers/net/wireless/ath/ath10k/mac.c:1049:30: error: incompatible types in comparison expression (different signedness)
drivers/net/wireless/ath/ath10k/mac.c:1042: WARNING: line over 80 characters

-- 
Kalle Valo
