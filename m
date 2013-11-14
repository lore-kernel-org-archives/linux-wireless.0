Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3KNOow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 09:44:52 -0500
Message-ID: <1384440286.13941.27.camel@jlt4.sipsolutions.net> (sfid-20131114_154455_861907_9B43E27B)
Subject: Re: [RFC 3/5] cfg80211: add regulatory quiescing support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 14 Nov 2013 15:44:46 +0100
In-Reply-To: <20131114141105.GB19070@garbanzo.do-not-panic.com> (sfid-20131114_150029_534220_D0403B29)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	 <1384366379-25301-4-git-send-email-mcgrof@do-not-panic.com>
	 <1384377738.28806.15.camel@jlt4.sipsolutions.net>
	 <20131114141105.GB19070@garbanzo.do-not-panic.com>
	 (sfid-20131114_150029_534220_D0403B29)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-14 at 06:11 -0800, Luis R. Rodriguez wrote:
> On Wed, Nov 13, 2013 at 10:22:18PM +0100, Johannes Berg wrote:
> > On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
> > > This quiesces devices when appropriate to ensure that
> > > regulatory domain updates take effect and avoid having
> > > devices initiate radiation when they should not.
> > 
> > I'm not really sure this makes sense.
> > 
> > If we're staying connected, how can we be moving far enough to go
> > through regulatory domains to have totally different rules?
> 
> Don't think of what makes sense, think of the corner cases that
> could happen here, such as plugging in a card that disagrees
> with regulatory settings, and creates a conflict on DFS regions.
> One example might be someone plugging in a USB 802.11 card programmed
> for JP in say a FR 802.11 AP, assuming the AP had the USB 802.11
> driver. Another example may be if a user provides an input with
> say 'iw reg set JP' on a FR AP. In such cases we want to stop IR,
> even if the user was dumb, we'd be respecting the regulatory settings,
> as silly as they may be.

Think of the other way around, such as plugging in a stupid USB NIC just
to see if it works - and suddenly finding your 5 GHz connection broken
because that USB NIC said it really needed some stupid country with 2.4
only. I'm not convinced.

johannes

