Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:20598 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbYGISDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 14:03:25 -0400
Received: by ug-out-1314.google.com with SMTP id h2so104121ugf.16
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 11:03:21 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh beacons
Date: Wed, 9 Jul 2008 20:12:11 +0200
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807091511.14288.IvDoorn@gmail.com> <200807091812.55271.IvDoorn@gmail.com> <1215625355.3246.41.camel@johannes.berg>
In-Reply-To: <1215625355.3246.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807092012.11234.IvDoorn@gmail.com> (sfid-20080709_200347_864387_F892135E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008, Johannes Berg wrote:
> On Wed, 2008-07-09 at 18:12 +0200, Ivo van Doorn wrote:
> 
> > > I'll put off the fix until after davem's TX MQ rework though.
> 
> Actually, I don't have to.
> 
> > Ok, that would allow some time for rt2x00 to come up with the
> > implementation for the rt2400pci and rt2500pci drivers.
> > 
> > And this is extra motivation for a volunteer to look into this,
> > because when mac80211 removes the seq counting, it is not
> > just adhoc and master mode that are broken. ;)
> 
> Here's a patch to try it out:
> 
> http://johannes.sipsolutions.net/patches/kernel/all/2008-07-09-17%3a38/022-mac80211-fix-hwseq.patch

Personally I have my doubts about the meaningfullness of the flag
	IEEE80211_TX_CTL_QOS_FRAME
since drivers will probably use ieee80211_is_data_qos() instead.
Perhaps it is better to have the flag named something like:
	IEEE80211_TX_CTS_SW_SEQUENCE
or
	IEEE80211_TX_CTS_HAS_SEQUENCE

That way it is a bit clearer what the intention of the flag is.

Ivo
