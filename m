Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33693 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3LPNTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 08:19:18 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix band reporting for mgmt CCK frames on 5GHz
References: <1386927883-14028-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 16 Dec 2013 15:19:12 +0200
In-Reply-To: <1386927883-14028-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 13 Dec 2013 10:44:43 +0100")
Message-ID: <87wqj5exwv.fsf@kamboji.qca.qualcomm.com> (sfid-20131216_141921_374234_FF7E1695)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Although CCK modulation isn't expected for 11a if
> it happened it made ath10k report wrong band
> (2GHz) for a mgmt frame that were actually
> received on 5Ghz band. Frequency would also
> decoded incorrectly too.
>
> In case of 5GHz-only devices this triggered
> mac80211 WARN_ON because there was no according
> sband pointer to be found.
>
> The patch should fix delivery of such frames by
> using different means to acquire band parameter.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
