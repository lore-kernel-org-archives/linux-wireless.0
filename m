Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6264 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZHEF1H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 01:27:07 -0400
Subject: Re: [PATCH] wireless: display wext SSID when connected by cfg80211
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1249449590.4168.16.camel@johannes.local>
References: <1249437950-8059-1-git-send-email-yi.zhu@intel.com>
	 <1249449590.4168.16.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 13:27:06 +0800
Message-Id: <1249450026.4069.111.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-08-05 at 13:19 +0800, Johannes Berg wrote:
> On Wed, 2009-08-05 at 10:05 +0800, Zhu Yi wrote:
> > cfg80211 displays correct link info when connected by wext. But if
> > the connection is setup by cfg80211, wext cannot display the SSID.
> > This patch fixed this issue.
> > 
> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> > ---
> > diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
> > index 7bacbd1..48c165b 100644
> > --- a/net/wireless/wext-sme.c
> > +++ b/net/wireless/wext-sme.c
> > @@ -210,6 +210,10 @@ int cfg80211_mgd_wext_giwessid(struct net_device *dev,
> >  		data->flags = 1;
> >  		data->length = wdev->wext.connect.ssid_len;
> >  		memcpy(ssid, wdev->wext.connect.ssid, data->length);
> > +	} else if (wdev->ssid && wdev->ssid_len) {
> > +		data->flags = 1;
> > +		data->length = wdev->ssid_len;
> > +		memcpy(ssid, wdev->ssid, data->length);
> 
> Hmm. I suspect using wdev->current_bss would be less prone to breakage,
> since we've had some trouble with wdev->ssid already, and current_bss
> has to be present all the time for various nl80211 too. I guess
> ultimately it doesn't matter that much since somebody will see the
> problem.

Yeah, I'm lazy to parse the current_bss.pub->information_elements for
SSID in the first instance. Should we implement some beacon parsing in
cfg80211 or move ieee802_11_parse_elems from mac80211?

Thanks,
-yi

