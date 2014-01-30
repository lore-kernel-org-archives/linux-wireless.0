Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:53758 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaA3K6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 05:58:22 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Fix IBSS join
Date: Thu, 30 Jan 2014 11:58:18 +0100
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org
References: <1390874095-28008-1-git-send-email-sujith@msujith.org> <21226.184.85287.849137@gargle.gargle.HOWL> <1391069448.4134.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1391069448.4134.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201401301158.18604.sw@simonwunderlich.de> (sfid-20140130_115825_337534_E997D66B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On Thu, 2014-01-30 at 13:05 +0530, Sujith Manoharan wrote:
> > Simon Wunderlich wrote:
> > > In the CSA case the BSS is still used, we modify the BSS entry in
> > > ieee80211_ibss_finish_csa()  (which is not really clean, but done by
> > > all the current CSA code).
> > > 
> > > Since the BSS is changed and the node continues to beacon, I think
> > > that's ok to do it like Sujith proposed.
> > 
> > I think Johannes is right. If a station receives a CSA and is unable to
> > switch to the new channel, it leaves the IBSS network. In this case we
> > don't need to keep the BSS entry around, since we proceed to scan again.
> 
> Hah, I wasn't paying attention ... yeah I think you're right, it's the
> *failure* case, in which we shouldn't care any more. Simon, you were
> thinking of the successful case, but that doesn't call disconnect ...

Oh yes, I was just thinking, not reading. You are right, of course! Thanks for 
correcting me. :)

I see Sujith has already posted v2, thanks a lot!
     Simon
