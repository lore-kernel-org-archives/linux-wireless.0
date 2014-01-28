Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33133 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaA1Br2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 20:47:28 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21223.2785.44186.69761@gargle.gargle.HOWL> (sfid-20140128_024734_848194_67B988AC)
Date: Tue, 28 Jan 2014 07:11:53 +0530
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	"ath9k-devel\@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@meshcoding.com>,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: Re: IBSS can't beacon after rejoin / regression in TSF syncing code?
In-Reply-To: <201401271427.51372.sw@simonwunderlich.de>
References: <201401241826.45121.sw@simonwunderlich.de>
	<21221.57261.792711.70974@gargle.gargle.HOWL>
	<201401271427.51372.sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich wrote:
> Yeah, this patch works for my case. I'm not completely sure why we only unlink 
> for this special case (no stations & bssid = zero), I don't see why it would 
> hurt to always throw away that BSS and rescan on the next join?
> 
> I'm CCing Teemu, who introduced this roughly 3.5 years ago ("mac80211: remove 
> BSS from cfg80211 list when leaving IBSS", 
> 5ea096c0c85e80335889539899af9a4717976e0b) , maybe he can explain it more.  I 
> couldn't understand that from the commit message and the corresponding mail 
> thread.

I think we can drop the BSS when we leave an IBSS network. The only advantage
of not doing so is a slightly faster join command that is given after
leaving - if there are more than 2 nodes in the cell, that is. But it would
be prudent to scan and check if the network exists before trying to join it,
so I'll send the patch for review.

Sujith


