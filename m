Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53180 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbbHSLIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 07:08:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add pktlog support for 10.4 firmware
References: <1435043155-3111-1-git-send-email-rmani@qti.qualcomm.com>
Date: Wed, 19 Aug 2015 14:08:06 +0300
In-Reply-To: <1435043155-3111-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Tue, 23 Jun 2015 12:35:55 +0530")
Message-ID: <87io8ba63t.fsf@kamboji.qca.qualcomm.com> (sfid-20150819_130817_260950_639D0633)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> 10.4 firmware uses dedicated copy engine for pktlog transaction.
> Whatever the data received in that dedicated copy engine will
> have only pkt log header and followed by pktlog payload (will not
> have htc header). In the current design, htc layer callback
> registered with hif are acting as default receiver for all copy
> engine. We need to change the design in a way dedicated copy
> engine assigned for pktlog directly goes to pktlog module
> (bypassing htc) and rest of copy engine data goes to htc layer.
> In order to meet this, hif layer is changed to maintain copy
> engine specific tx and rx callbacks.
>
> Also, new firmware ie is added to get copy engine number used
> for pktlog in the firmware. Based this, pktlog receiver callback
> handler will be plugged into hif layer.
>
> pktlog.c/h are newly added to have pktlog related stuff.
> 10.4 firmware pktlog header differs from non 10.4 firmware.
> So, new pktlog header is added for 10.4.
>
> This patch enables pktlog to capture only TX related info on
> 10.4 firmware. Some more effort is need to capture RX related
> info in pktlog which is not covered in this patch.
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

Like discussed privately, let's drop this now and revisit later.

-- 
Kalle Valo
