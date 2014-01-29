Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:52191 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaA2MTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 07:19:07 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Fix IBSS join
Date: Wed, 29 Jan 2014 13:19:03 +0100
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org
References: <1390874095-28008-1-git-send-email-sujith@msujith.org> <1390997315.4143.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1390997315.4143.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201401291319.03802.sw@simonwunderlich.de> (sfid-20140129_131910_838687_87458C50)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, 2014-01-28 at 07:24 +0530, Sujith Manoharan wrote:
> > -	ieee80211_ibss_disconnect(sdata);
> > +	ieee80211_ibss_disconnect(sdata, false);
> 
> I'm not sure why you'd want to have 'false' here? If the network is
> switching channel, then the old BSS entry is useless, no?

In the CSA case the BSS is still used, we modify the BSS entry in 
ieee80211_ibss_finish_csa()  (which is not really clean, but done by all the 
current CSA code).

Since the BSS is changed and the node continues to beacon, I think that's ok 
to do it like Sujith proposed.

Cheers,
    Simon
