Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35126 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933052AbeE2KBL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 06:01:11 -0400
Date: Tue, 29 May 2018 13:00:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mac80211_hwsim: add error check to call to
 rhashtable_init
Message-ID: <20180529100049.up6wzjkzmd5a3v2q@mwanda> (sfid-20180529_120145_208291_E0B1CED6)
References: <20180529091412.8530-1-colin.king@canonical.com>
 <1527585428.6955.7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1527585428.6955.7.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 29, 2018 at 11:17:08AM +0200, Johannes Berg wrote:
> On Tue, 2018-05-29 at 10:14 +0100, Colin King wrote:
> > 
> > @@ -3573,7 +3573,9 @@ static int __init init_mac80211_hwsim(void)
> >  	hwsim_wq = alloc_workqueue("hwsim_wq", 0, 0);
> >  	if (!hwsim_wq)
> >  		return -ENOMEM;
> > -	rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
> > +	err = rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
> > +	if (err)
> > +		return err;
> 
> That's missing a workqueue free, but I can fix that while applying if
> you prefer.
> 

And we don't free the hashtable on error either.

regards,
dan carpenter
