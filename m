Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:33286 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbbA0Osj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 09:48:39 -0500
From: "Dedy Lansky" <dlansky@codeaurora.org>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	"'Vladimir Kondratiev'" <qca_vkondrat@qca.qualcomm.com>
References: <1422345312-2963-1-git-send-email-dlansky@codeaurora.org>	 <1422347067.1890.49.camel@sipsolutions.net>	 <002501d03a1f$024d1e30$06e75a90$@codeaurora.org> <1422356461.1890.64.camel@sipsolutions.net>
In-Reply-To: <1422356461.1890.64.camel@sipsolutions.net>
Subject: RE: [PATCH] cfg80211: PBSS basic support
Date: Tue, 27 Jan 2015 16:48:34 +0200
Message-ID: <002801d03a40$55b81630$01284290$@codeaurora.org> (sfid-20150127_154842_403994_F1760C44)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: Tuesday, January 27, 2015 1:01 PM

> On Tue, 2015-01-27 at 12:50 +0200, Dedy Lansky wrote:
> 
> > > > @@ -896,6 +949,7 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
> > > >  	struct cfg80211_bss_ies *ies;
> > > >  	struct ieee80211_channel *channel;
> > > >  	struct cfg80211_internal_bss tmp = {}, *res;
> > > > +	int bss_type;
> > > 
> > > enum.
> > > 
> > > Except that you actually forgot to store the BSS type ...
> > > 
> > > Actually - you didn't add it to the bss struct, but to wdev? Why is it needed there?? I don't see you using it?
> > 
> > wdev->bss_type refers to the BSS that we are connecting/connected to (Maybe rename to "conn_bss_type"?).
> > This member is used in sme.c. It was introduced because once the connect is complete and driver calls cfg80211_connect_result(), cfg needs to find the BSS being connected to.
> 
> Ok I was thinking you were adding it to struct cfg80211_bss. Wouldn't that make a bit more sense? Of course it can also be derived from cfg80211_bss::channel and cfg80211_bss::capability, your call.
> 
> However, it doesn't seem that you need it in wdev if you have it there inside wdev->current_bss?

current_bss is set later.

inside __cfg80211_connect_result(), we look for the BSS being connected to:
  bss = cfg80211_get_bss(..., bssid, wdev->bss_type, ...)
only after that, current_bss is set to this BSS:
  wdev->current_bss = bss_from_pub(bss);

> 
> johannes


