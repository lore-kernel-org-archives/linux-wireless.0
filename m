Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35791 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbbEGMrk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 08:47:40 -0400
Message-ID: <1431002853.11214.3.camel@sipsolutions.net> (sfid-20150507_144745_545468_C3D90983)
Subject: Re: [patch] iwlwifi: mvm: remove some dead code
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Arik Nemtsov <arik@wizery.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	Liad Kaufman <liad.kaufman@intel.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Thu, 07 May 2015 14:47:33 +0200
In-Reply-To: <20150507124224.GX16501@mwanda>
References: <20150507095844.GA17996@mwanda>
	 <1431001635.11214.2.camel@sipsolutions.net> <20150507124224.GX16501@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-07 at 15:42 +0300, Dan Carpenter wrote:

> > >  		_iwl_trans_stop_device(mvm->trans, false);
> > >  		_iwl_trans_start_hw(mvm->trans, false);
> > > -		if (ret)
> > > -			return ret;
> > 
> > It looks like "ret = _iwl_trans_start_hw(...)" was intended though?
> > 
> 
> Hm...  You may be right.  Should it also be "goto error;" instead of a
> direct return?  I'm not positive.

Yes, looks like.

> Eran can you fix this and give me a Reported-by tag?

I think Eran is on sabbatical, I'll get this on the way internally with
your reported-by.

johannes

