Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:18849 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194AbYGIPkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 11:40:01 -0400
Received: by nf-out-0910.google.com with SMTP id d3so923370nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 08:39:59 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh beacons
Date: Wed, 9 Jul 2008 17:48:49 +0200
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807091511.14288.IvDoorn@gmail.com> <200807091736.55061.IvDoorn@gmail.com> <1215617595.3246.26.camel@johannes.berg>
In-Reply-To: <1215617595.3246.26.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807091748.49796.IvDoorn@gmail.com> (sfid-20080709_174016_039390_BF67F5D1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008, Johannes Berg wrote:
> On Wed, 2008-07-09 at 17:36 +0200, Ivo van Doorn wrote:
> 
> > True, I have to double check it, but the legacy drivers use per-queue locking as well.
> > And it would still be possible for the driver to send out frames with a higher
> > sequence number before one with a lower number.
> 
> The legacy drivers hopefully also implement proper sequence numbering
> per TID. I'll send another mail on the topic.

Heh, I seriously doubt that. As far as I know it is working using a single
counter in the main interface structure. Just the same way it currently
works in mac80211 (which isn't surprising, since I based the mac80211 patch
on the legacy driver implementation).

> > But I'll put out a request on the rt2400-devel list to see if anybody is interested
> > in looking into this issue for rt2400pci and rt2500pci. In if there is nobody, I'll
> > disable adhoc and master mode for those drivers to prevent problems.
> 
> Heh, that works. Just disable it and tell folks who want it to work to
> fix it :)

Well I am putting out an in advance notice first. ;)

Ivo

