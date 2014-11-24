Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46287 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaKXPPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 10:15:44 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath10k: Fix locking for WEP keys
References: <1416796657-24657-1-git-send-email-sujith@msujith.org>
	<1416796657-24657-3-git-send-email-sujith@msujith.org>
Date: Mon, 24 Nov 2014 17:15:38 +0200
In-Reply-To: <1416796657-24657-3-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Mon, 24 Nov 2014 08:07:36 +0530")
Message-ID: <87h9xo6351.fsf@kamboji.qca.qualcomm.com> (sfid-20141124_161547_573691_8FC79659)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> peer->keys needs to be protected by data_lock
> since it is also accessed from the WMI path.
>
> Both install() and clear() routines for peer
> keys modify the key contents, so use the data_lock
> to avoid races.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Can you also document the field with "protected by data_lock" in core.h?

-- 
Kalle Valo
