Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55755 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3KNOA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 09:00:28 -0500
Received: by mail-pa0-f54.google.com with SMTP id lj1so2125365pab.41
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 06:00:27 -0800 (PST)
Date: Thu, 14 Nov 2013 06:11:07 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/5] cfg80211: add regulatory quiescing support
Message-ID: <20131114141105.GB19070@garbanzo.do-not-panic.com> (sfid-20131114_150032_488250_4C2F3D0A)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384366379-25301-4-git-send-email-mcgrof@do-not-panic.com>
 <1384377738.28806.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384377738.28806.15.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 13, 2013 at 10:22:18PM +0100, Johannes Berg wrote:
> On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
> > This quiesces devices when appropriate to ensure that
> > regulatory domain updates take effect and avoid having
> > devices initiate radiation when they should not.
> 
> I'm not really sure this makes sense.
> 
> If we're staying connected, how can we be moving far enough to go
> through regulatory domains to have totally different rules?

Don't think of what makes sense, think of the corner cases that
could happen here, such as plugging in a card that disagrees
with regulatory settings, and creates a conflict on DFS regions.
One example might be someone plugging in a USB 802.11 card programmed
for JP in say a FR 802.11 AP, assuming the AP had the USB 802.11
driver. Another example may be if a user provides an input with
say 'iw reg set JP' on a FR AP. In such cases we want to stop IR,
even if the user was dumb, we'd be respecting the regulatory settings,
as silly as they may be.

Another more resonable case may be one AP creating a secondary
wdev as a STA, consider a P2P GO, with a P2P STA on another channel
and lets assume the P2P GO is misprogrammed for JP but the STA
wdev picks up association with an AP from FR.

> (Also, probably best to squash patches 2 and 3, 2 is pointless by itself
> and the code move is obvious with this patch)

OK.

  Luis
