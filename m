Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:36626 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2GCLcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 07:32:36 -0400
Date: Tue, 3 Jul 2012 14:32:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: qca_vkondrat@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: cfg80211: add 802.11ad (60gHz band) support
Message-ID: <20120703113223.GE4519@mwanda> (sfid-20120703_133240_879805_BF7FF38D)
References: <20120703105342.GA29879@elgon.mountain>
 <1341313457.5131.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1341313457.5131.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 03, 2012 at 01:04:17PM +0200, Johannes Berg wrote:
> On Tue, 2012-07-03 at 13:53 +0300, Dan Carpenter wrote:
> > Hello Vladimir Kondratiev,
> > 
> > The patch 3a0c52a6d82c: "cfg80211: add 802.11ad (60gHz band) support" 
> > from Jul 2, 2012, leads to the following warning:
> > drivers/net/wireless/mac80211_hwsim.c:1841 init_mac80211_hwsim()
> > 	 warn: buffer overflow 'data->bands' 2 <= 2
> > 
> > drivers/net/wireless/mac80211_hwsim.c
> >   1839  
> >   1840                  for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
> >                                                                 ^^^^^^^^^^^^^^^^^^^
> > We raised IEEE80211_NUM_BANDS to 3.
> > 
> >   1841                          struct ieee80211_supported_band *sband = &data->bands[band];
> >                                                                                 ^^^^^^^^^^^
> > This only has 2 elements still.
> > 
> >   1842                          switch (band) {
> >   1843                          case IEEE80211_BAND_2GHZ:
> > 
> > It causes a bogus dereference later.
> 
> Thanks Dan!
> 
> Is this one of your non-default tests? I think I ran smatch on this, but
> it might be old.

It should be on by default in the latest code.  :)

regards,
dan carpenter
