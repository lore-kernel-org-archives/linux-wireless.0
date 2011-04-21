Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:65078 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1DUHln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 03:41:43 -0400
Date: Thu, 21 Apr 2011 09:44:36 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Nishant Sarmukadam <nishants@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Pradeep Nemavat <pnemavat@marvell.com>
Subject: Re: [PATCH V2 3/4] mwl8k: Reserve buffers for tx management frames
Message-ID: <20110421074436.GY1897@wantstofly.org>
References: <1303231582-17333-1-git-send-email-nishants@marvell.com>
 <1303231582-17333-3-git-send-email-nishants@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303231582-17333-3-git-send-email-nishants@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 19, 2011 at 10:16:21PM +0530, Nishant Sarmukadam wrote:

> -	if (txq->len >= MWL8K_TX_DESCS) {
> -		if (start_ba_session) {
> -			spin_lock(&priv->stream_lock);
> -			mwl8k_remove_stream(hw, stream);
> -			spin_unlock(&priv->stream_lock);
> +	/* Mgmt frames that go out frequently are probe responses.
> +	 * Other mgmt frames got out relatively infrequently.
> +	 * Hence reserve 2 buffers so that other mgmt frames do not get
> +	 * dropped due to an already queued probe response in one of
> +	 * the reserved buffers.
> +	 */

Comment formatting..


> +	if (txq->len >= (MWL8K_TX_DESCS - 2)) {
> +		if ((mgmtframe == false) ||
> +			(txq->len == MWL8K_TX_DESCS)) {
> +			if (start_ba_session) {
> +				spin_lock(&priv->stream_lock);
> +				mwl8k_remove_stream(hw, stream);
> +				spin_unlock(&priv->stream_lock);
> +			}

..and lots of superfluous parentheses here:

	txq->len >= MWL8K_TX_DESCS - 2
	mgmtframe == false
	txq->len == MWL8K_TX_DESCS
