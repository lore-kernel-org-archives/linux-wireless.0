Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37522 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbcAEKKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:10:53 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	chunfan chen <jeffc@marvell.com>
Subject: Re: [PATCH 1/3] mwifiex: fix misleading firmware download messages
References: <1451486589-15010-1-git-send-email-akarwar@marvell.com>
Date: Tue, 05 Jan 2016 12:10:47 +0200
In-Reply-To: <1451486589-15010-1-git-send-email-akarwar@marvell.com>
	(Amitkumar Karwar's message of "Wed, 30 Dec 2015 06:43:07 -0800")
Message-ID: <8760z8mj4o.fsf@kamboji.qca.qualcomm.com> (sfid-20160105_111151_125751_6D2340BF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> From: chunfan chen <jeffc@marvell.com>
>
> mwifiex_check_fw_status() checks firmware status and also
> check if WLAN is the winner for firmware downloading.
>
> Once we detect that other interface is downloading
> the firmware, we call this routine again with max
> poll count to wait until firmware is ready.
>
> This patch splits the routine to avoid checking
> winner status multiple times and ensures that
> correct warning messages are displayed.
>
> Firmware status poll count is also increased to 150.

The title is somewhat misleading, you are doing a lot more than just
fixing messages. Also please clarify the concept here, especially about
"winner", "loser" and the other interface.

> Signed-off-by: chunfan chen <jeffc@marvell.com>

It's good practise to capitalise the name.

-- 
Kalle Valo
