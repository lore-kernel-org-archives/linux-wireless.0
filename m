Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49462 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753742AbcJDPkO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 11:40:14 -0400
Date: Tue, 4 Oct 2016 21:09:24 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: ath10k: Cleanup calling ath10k_htt_rx_h_unchain
Message-ID: <20161004153924.GA4203@atheros-ThinkPad-T61> (sfid-20161004_174018_519624_DD1041A3)
References: <1474981314-15987-1-git-send-email-mohammed@qca.qualcomm.com>
 <2cb38dba80294e6da1005ac0927d01eb@euamsexm01a.eu.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2cb38dba80294e6da1005ac0927d01eb@euamsexm01a.eu.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 04, 2016 at 05:30:17PM +0200, Kalle Valo wrote:
> Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > 
> > 'ath10k_htt_rx_h_unchain' is need to be called only if the return
> > value from 'ath10k_htt_rx_amsdu_pop' is 1('chained msdu's'), this
> > change makes it more explicit and avoids doing a skb_peek, fetching
> > rx descriptor pointer, checking rx msdu decap format for the case of
> > ret = 0 (unchained msdus). Found this change during code walk through,
> > not sure if this addresses any issue.
> > 
> > Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Failed to apply to pending branch
> 
> error: patch failed: drivers/net/wireless/ath/ath10k/htt_rx.c:1550
> error: drivers/net/wireless/ath/ath10k/htt_rx.c: patch does not apply
> stg import: Diff does not apply cleanly

[shafi] thanks, will rebase/fix this and send a v2
> 
> Patch set to Changes Requested.
> 
> -- 
> https://patchwork.kernel.org/patch/9351833/
> 
> Documentation about submitting wireless patches and checking status
> from patchwork:
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
> 
