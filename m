Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11989 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752152AbcJKLso (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Oct 2016 07:48:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/2] ath10k: clean up HTT tx buffer allocation and free
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1475743188-12007-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1475743188-12007-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <c617b703956d4a038349494b87f65d0a@euamsexm01a.eu.qualcomm.com> (sfid-20161011_134848_605323_D84C4D62)
Date: Tue, 11 Oct 2016 13:36:22 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> cleanup 'ath10k_htt_tx_alloc' by introducing the API's
> 'ath10k_htt_tx_alloc/free_{cont_txbuf, txdone_fifo} and
> re-use them whereever needed
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Applies but fails to build:

drivers/net/wireless/ath/ath10k/htt_tx.c: In function ‘ath10k_htt_tx_free’:
drivers/net/wireless/ath/ath10k/htt_tx.c:424:19: error: ‘struct ath10k_htt’ has no member named ‘txrx_compl_task’
make[5]: *** [drivers/net/wireless/ath/ath10k/htt_tx.o] Error 1
make[4]: *** [drivers/net/wireless/ath/ath10k] Error 2
make[3]: *** [drivers/net/wireless/ath] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

2 patches set to Changes Requested.

9363863 [v2,1/2] ath10k: clean up HTT tx buffer allocation and free
9363861 [v2,2/2] ath10k: Remove extraneous error message in tx alloc

-- 
https://patchwork.kernel.org/patch/9363863/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
