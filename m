Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:33941 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552Ab1DUIYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 04:24:19 -0400
Subject: Re: [PATCH V2 3/4] mwl8k: Reserve buffers for tx management frames
From: Nishant Sarmukadam <nishants@marvell.com>
Reply-To: <nishants@marvell.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pradeep Nemavat <pnemavat@marvell.com>
In-Reply-To: <20110421074436.GY1897@wantstofly.org>
References: <1303231582-17333-1-git-send-email-nishants@marvell.com>
	 <1303231582-17333-3-git-send-email-nishants@marvell.com>
	 <20110421074436.GY1897@wantstofly.org>
Content-Type: text/plain
Date: Thu, 21 Apr 2011 13:45:14 +0530
Message-ID: <1303373714.24017.47.camel@localhost.localdomain>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2011-04-21 at 00:44 -0700, Lennert Buytenhek wrote:
> On Tue, Apr 19, 2011 at 10:16:21PM +0530, Nishant Sarmukadam wrote:
> 
> > -	if (txq->len >= MWL8K_TX_DESCS) {
> > -		if (start_ba_session) {
> > -			spin_lock(&priv->stream_lock);
> > -			mwl8k_remove_stream(hw, stream);
> > -			spin_unlock(&priv->stream_lock);
> > +	/* Mgmt frames that go out frequently are probe responses.
> > +	 * Other mgmt frames got out relatively infrequently.
> > +	 * Hence reserve 2 buffers so that other mgmt frames do not get
> > +	 * dropped due to an already queued probe response in one of
> > +	 * the reserved buffers.
> > +	 */
> 
> Comment formatting..
> 
> 
> > +	if (txq->len >= (MWL8K_TX_DESCS - 2)) {
> > +		if ((mgmtframe == false) ||
> > +			(txq->len == MWL8K_TX_DESCS)) {
> > +			if (start_ba_session) {
> > +				spin_lock(&priv->stream_lock);
> > +				mwl8k_remove_stream(hw, stream);
> > +				spin_unlock(&priv->stream_lock);
> > +			}
> 
> ..and lots of superfluous parentheses here:
> 
> 	txq->len >= MWL8K_TX_DESCS - 2
> 	mgmtframe == false
> 	txq->len == MWL8K_TX_DESCS

I will address both these comments in patch set V3.


