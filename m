Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:9526 "EHLO
	qualcomm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932239Ab2GAMHX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 08:07:23 -0400
From: Vladimir Kondratiev <vkondrat@qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC 60g 2/5] wireless: rate check logic for 60g
Date: Sun, 01 Jul 2012 15:05:44 +0300
Message-ID: <1497614.ftLOcXq5Bn@lx-vladimir> (sfid-20120701_140727_723210_3797C990)
In-Reply-To: <1340906664.4491.47.camel@jlt3.sipsolutions.net>
References: <1340882220-31768-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1340882220-31768-3-git-send-email-qca_vkondrat@qca.qualcomm.com> <1340906664.4491.47.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, June 28, 2012 08:04:24 PM Johannes Berg wrote:
> On Thu, 2012-06-28 at 14:16 +0300, Vladimir Kondratiev wrote:
> > +		/*
> > +		 * on 60gHz band, there are no legacy rates, so
> > +		 * n_bitrates is 0
> > +		 */
> > +		if (WARN_ON((band != IEEE80211_BAND_60GHZ) &&
> > +		    !sband->n_bitrates))
> > 
> >  			return -EINVAL;
> 
> Please fix indentation.
> 
> johannes

I am confused a bit. What is "proper" identation for this case
(wrapped expression)?
Immediately following code use same identation (4 spaces).

		if (cfg80211_disable_40mhz_24ghz &&
		    band == IEEE80211_BAND_2GHZ &&
		    sband->ht_cap.ht_supported) {
			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
		}

Should I ident line containing (see above):
!sband->n_bitrates))
with:
 - 4 spaces as next code fragment,
 - one tab (same level as 'return')
 - 2 tabs (one level more then 'return')
 - other (what?)


