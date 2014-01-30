Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47802 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaA3ILG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 03:11:06 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: properly return err from start()
References: <52E8248F.8090601@candelatech.com>
	<1390976791-9223-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 30 Jan 2014 10:10:59 +0200
In-Reply-To: <1390976791-9223-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 29 Jan 2014 07:26:31 +0100")
Message-ID: <87r47pyjn0.fsf@kamboji.qca.qualcomm.com> (sfid-20140130_091110_982947_6B7FFC14)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If recovery failed ath10k returned 0 (success) and
> mac80211 continued to call other driver callbacks.
> This caused null dereference.
>
> This is how the failure looked like:
>
> ath10k: ctl_resp never came in (-110)
> ath10k: failed to connect to HTC: -110
> ath10k: could not init core (-110)
> BUG: unable to handle kernel NULL pointer dereference at           (null)

[...]

> Reported-By: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

> Thanks for reporting, Ben!

Indeed, thanks Ben. Please keep the reports coming :)

-- 
Kalle Valo
