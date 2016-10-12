Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753300AbcJLHJ2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 03:09:28 -0400
Date: Wed, 12 Oct 2016 12:39:18 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [v2,1/2] ath10k: clean up HTT tx buffer allocation and free
Message-ID: <20161012070918.GA2993@atheros-ThinkPad-T61> (sfid-20161012_090933_709594_ED984749)
References: <1475743188-12007-1-git-send-email-mohammed@qca.qualcomm.com>
 <c617b703956d4a038349494b87f65d0a@euamsexm01a.eu.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <c617b703956d4a038349494b87f65d0a@euamsexm01a.eu.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Tue, Oct 11, 2016 at 01:36:22PM +0200, Kalle Valo wrote:
> Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > 
> > cleanup 'ath10k_htt_tx_alloc' by introducing the API's
> > 'ath10k_htt_tx_alloc/free_{cont_txbuf, txdone_fifo} and
> > re-use them whereever needed
> > 
> > Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Applies but fails to build:

[shafi] sorry for the trouble again, I just figured out I had a private patch by
mistake  and it worked for me, I will make sure that v3 is properly rebased
without any errors.

> 
> drivers/net/wireless/ath/ath10k/htt_tx.c: In function ‘ath10k_htt_tx_free’:
> drivers/net/wireless/ath/ath10k/htt_tx.c:424:19: error: ‘struct ath10k_htt’ has no member named ‘txrx_compl_task’
> make[5]: *** [drivers/net/wireless/ath/ath10k/htt_tx.o] Error 1
> make[4]: *** [drivers/net/wireless/ath/ath10k] Error 2
> make[3]: *** [drivers/net/wireless/ath] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [drivers] Error 2
> 
> 2 patches set to Changes Requested.
> 
> 9363863 [v2,1/2] ath10k: clean up HTT tx buffer allocation and free
> 9363861 [v2,2/2] ath10k: Remove extraneous error message in tx alloc
> 
> -- 
> https://patchwork.kernel.org/patch/9363863/
> 
> Documentation about submitting wireless patches and checking status
> from patchwork:
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
> 
