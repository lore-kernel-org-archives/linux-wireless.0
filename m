Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:50013 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3IJOPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 10:15:32 -0400
Received: by mail-ie0-f172.google.com with SMTP id c10so16503154ieb.3
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 07:15:31 -0700 (PDT)
Date: Tue, 10 Sep 2013 10:14:13 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] ath10k: simplify HTC credits calculation
Message-ID: <20130910141413.GE29385@localhost> (sfid-20130910_161542_092863_BEF346E5)
References: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
 <1378821003-22925-2-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1378821003-22925-2-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 03:49:57PM +0200, Michal Kazior wrote:
> +		skb = __skb_dequeue(&ep->tx_queue);
> +
> +		if (ep->tx_credit_flow_enabled) {
> +			/* integer division w/ round-up */
> +			credits = (skb->len + htc->target_credit_size - 1) /
> +				  htc->target_credit_size;

There's a macro for that...

            credits = DIV_ROUND_UP(skb->len, htc->target_credit_size);

-- 
Bob Copeland %% www.bobcopeland.com
