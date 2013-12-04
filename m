Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28010 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab3LDNTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 08:19:12 -0500
Date: Wed, 4 Dec 2013 16:19:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Stepanov, Max" <Max.Stepanov@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211: add generic cipher scheme support
Message-ID: <20131204131905.GT5443@mwanda> (sfid-20131204_141916_019376_420B7CAC)
References: <20131203163712.GA1857@elgon.mountain>
 <3A934E7FDB083A4683727C7D377065951172F2E5@HASMSX105.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3A934E7FDB083A4683727C7D377065951172F2E5@HASMSX105.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 04, 2013 at 01:07:29PM +0000, Stepanov, Max wrote:
> >   304                  if (pairwise)
> >   305                          key = rcu_dereference(sta->ptk[key_idx]);
> >   306                  else if (key_idx < NUM_DEFAULT_KEYS)
> >   307                          key = rcu_dereference(sta->gtk[key_idx]);
> >
> >key_idx is a number between 0 and 5.
> >NUM_DEFAULT_KEYS is 4.
> >->ptk has 4 elements.
> >->gtk has 6 elements.
> >
> >I looked but I didn't see that "pairwise" implied that key_idx is less than 4.
> >These are set in nl80211_get_key().
> 
> Hi Dan,
> 
> 1. ptk - I think you are right here - need to verify that key_idx doesn't exceed sta->ptk array boundaries. I'll prepare the fix
> 2. gtk - frankly I'm not sure about key_idx < NUM_DEFAULT_KEYS. I understand why it's here: not to return management keys, but I don't see a reason why not to do it... In any case I'll prepare the fix for this case too

It worries me that we are doing #2 without being sure...  I have no
idea about this code, I'm just doing static analysis without a deep
understanding at all.

regards,
dan carpenter

