Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36623 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1JRSXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 14:23:09 -0400
Subject: RE: [patch 3/4] mwifiex: prevent corruption instead of just warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430817F59764@SC-VEXCH1.marvell.com> (sfid-20111018_202134_304312_48DE1FDF)
References: <20111018061514.GI27732@elgon.mountain>
	 <477F20668A386D41ADCC57781B1F70430817F59764@SC-VEXCH1.marvell.com>
	 (sfid-20111018_202134_304312_48DE1FDF)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 20:23:00 +0200
Message-ID: <1318962180.3958.30.camel@jlt3.sipsolutions.net> (sfid-20111018_202314_187365_2E2D47CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-18 at 11:19 -0700, Bing Zhao wrote:

> > @@ -1228,9 +1228,11 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
> >  	if (!skb)
> >  		return 0;
> > 
> > -	if (rdptr >= MWIFIEX_MAX_EVT_BD)
> > +	if (rdptr >= MWIFIEX_MAX_EVT_BD) {
> >  		dev_err(adapter->dev, "event_complete: Invalid rdptr 0x%x\n",
> >  					rdptr);
> > +		return -EINVAL;
> 
> Instead of returning directly, we should set the error code and go through the error handling:
> 		ret = -EINVAL;
> 		goto done;

Are you sure? You don't go to error handling a few lines earlier.

johannes

