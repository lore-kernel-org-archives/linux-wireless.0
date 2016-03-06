Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57210 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbcCFO1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 09:27:44 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 07/11] ath10k: implement wake_tx_queue
Date: Sun, 6 Mar 2016 14:27:37 +0000
Message-ID: <87ziubvfzm.fsf@kamboji.qca.qualcomm.com> (sfid-20160306_153007_402880_1B91063A)
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
	<1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
	<1456828376-2795-8-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1456828376-2795-8-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 1 Mar 2016 11:32:52 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This implements very basic support for software
> queueing. It also contains some knobs that will be
> patched later.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Oddly this patch introduces a new warning:

drivers/net/wireless/ath/ath10k/mac.c: In function ath10k_mac_op_tx:
drivers/net/wireless/ath/ath10k/mac.c:3949:29: warning: is_mgmt may be used uninitialized in this function [-Wuninitialized]

But I think that's just a false warning, most likely because my gcc is
ancient. Do you agree?

gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3

-- 
Kalle Valo