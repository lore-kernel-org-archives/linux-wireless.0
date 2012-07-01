Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:10958 "EHLO
	qualcomm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750937Ab2GAQ3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 12:29:41 -0400
From: Vladimir Kondratiev <vkondrat@qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH 60g v1 0/5] Infrastructure for 60g (802.11ad)
Date: Sun, 01 Jul 2012 19:28 +0300
Message-ID: <3398883.J9mbiBD70h@lx-vladimir> (sfid-20120701_182945_490484_4A114F9B)
In-Reply-To: <1341141808.6603.1.camel@jlt3.sipsolutions.net>
References: <1341125155-628-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1341141808.6603.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, July 01, 2012 01:23:28 PM Johannes Berg wrote:
> 
> Please fix indentation better :-)
> 
> johannes


I am confused a bit. What is "proper" identation for this case?
Immediately following code idents with 4 spaces:

                if (cfg80211_disable_40mhz_24ghz &&
                    band == IEEE80211_BAND_2GHZ &&
                    sband->ht_cap.ht_supported) {
                        sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
                        sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
                }

This is what I did initially, to comply with surrounding code style.
Fragment in question is:

		if (WARN_ON((band != IEEE80211_BAND_60GHZ) &&
				!sband->n_bitrates))
			return -EINVAL;


Should I ident line containing
!sband->n_bitrates))
with:
 - 4 spaces as next code fragment,
 - one tab (same level as 'return')
 - 2 tabs (one level more then 'return')
 - other (what?)

