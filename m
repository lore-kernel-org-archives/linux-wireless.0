Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61555 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab3KNPHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 10:07:51 -0500
Received: by mail-pb0-f51.google.com with SMTP id xa7so2134588pbc.38
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 07:07:50 -0800 (PST)
Date: Thu, 14 Nov 2013 07:18:31 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/5] cfg80211: add regulatory quiescing support
Message-ID: <20131114151809.GB29954@garbanzo.do-not-panic.com> (sfid-20131114_160755_350789_87588827)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384366379-25301-4-git-send-email-mcgrof@do-not-panic.com>
 <1384377738.28806.15.camel@jlt4.sipsolutions.net>
 <20131114141105.GB19070@garbanzo.do-not-panic.com>
 <1384440286.13941.27.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384440286.13941.27.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 14, 2013 at 03:44:46PM +0100, Johannes Berg wrote:
> On Thu, 2013-11-14 at 06:11 -0800, Luis R. Rodriguez wrote:
> > On Wed, Nov 13, 2013 at 10:22:18PM +0100, Johannes Berg wrote:
> > > On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
> > > > This quiesces devices when appropriate to ensure that
> > > > regulatory domain updates take effect and avoid having
> > > > devices initiate radiation when they should not.
> > > 
> > > I'm not really sure this makes sense.
> > > 
> > > If we're staying connected, how can we be moving far enough to go
> > > through regulatory domains to have totally different rules?
> > 
> > Don't think of what makes sense, think of the corner cases that
> > could happen here, such as plugging in a card that disagrees
> > with regulatory settings, and creates a conflict on DFS regions.
> > One example might be someone plugging in a USB 802.11 card programmed
> > for JP in say a FR 802.11 AP, assuming the AP had the USB 802.11
> > driver. Another example may be if a user provides an input with
> > say 'iw reg set JP' on a FR AP. In such cases we want to stop IR,
> > even if the user was dumb, we'd be respecting the regulatory settings,
> > as silly as they may be.
> 
> Think of the other way around, such as plugging in a stupid USB NIC just
> to see if it works - and suddenly finding your 5 GHz connection broken
> because that USB NIC said it really needed some stupid country with 2.4
> only. I'm not convinced.

Actually your example is a good one that I'd use to make my case, but I
can also see this being like a sledge hammer. What if we only quiesce on
wdevs of types:

  o NL80211_IFTYPE_ADHOC
  o NL80211_IFTYPE_MESH_POINT
  o NL80211_IFTYPE_AP
  o NL80211_IFTYPE_P2P_GO

  Luis
