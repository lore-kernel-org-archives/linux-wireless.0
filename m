Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2GCLEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 07:04:24 -0400
Message-ID: <1341313457.5131.3.camel@jlt3.sipsolutions.net> (sfid-20120703_130427_842651_4A7DF367)
Subject: Re: cfg80211: add 802.11ad (60gHz band) support
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: qca_vkondrat@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 03 Jul 2012 13:04:17 +0200
In-Reply-To: <20120703105342.GA29879@elgon.mountain> (sfid-20120703_125355_865535_D89FFB14)
References: <20120703105342.GA29879@elgon.mountain>
	 (sfid-20120703_125355_865535_D89FFB14)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-03 at 13:53 +0300, Dan Carpenter wrote:
> Hello Vladimir Kondratiev,
> 
> The patch 3a0c52a6d82c: "cfg80211: add 802.11ad (60gHz band) support" 
> from Jul 2, 2012, leads to the following warning:
> drivers/net/wireless/mac80211_hwsim.c:1841 init_mac80211_hwsim()
> 	 warn: buffer overflow 'data->bands' 2 <= 2
> 
> drivers/net/wireless/mac80211_hwsim.c
>   1839  
>   1840                  for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
>                                                                 ^^^^^^^^^^^^^^^^^^^
> We raised IEEE80211_NUM_BANDS to 3.
> 
>   1841                          struct ieee80211_supported_band *sband = &data->bands[band];
>                                                                                 ^^^^^^^^^^^
> This only has 2 elements still.
> 
>   1842                          switch (band) {
>   1843                          case IEEE80211_BAND_2GHZ:
> 
> It causes a bogus dereference later.

Thanks Dan!

Is this one of your non-default tests? I think I ran smatch on this, but
it might be old. Anyway, I'll commit this fix: 

http://p.sipsolutions.net/a1c40eea7e33541b.txt

johannes

