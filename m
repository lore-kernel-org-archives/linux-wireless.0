Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47765 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbYJ2JSk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 05:18:40 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 02:18:40 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18696.10706.405455.724835@gargle.gargle.HOWL> (sfid-20081029_101846_822971_4E44FF14)
Date: Wed, 29 Oct 2008 14:46:02 +0530
To: Tomas Winkler <tomasw@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH 16/16] mac80211: Add a new event in
 ieee80211_ampdu_mlme_action
In-Reply-To: <1ba2fa240810290211s16f5506cgf7c828b5c3d8aea9@mail.gmail.com>
References: <18695.60248.383916.563413@gargle.gargle.HOWL>
	<1ba2fa240810290211s16f5506cgf7c828b5c3d8aea9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> On Wed, Oct 29, 2008 at 6:49 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> > Send a notification to the driver on succesful
> > reception of an ADDBA response, add IEEE80211_AMPDU_TX_RESUME
> > for this purpose.
> 
> What what is wrong with IEEE80211_AMPDU_TX_START ? I don' t understand
> why this is needed?

On receiving an IEEE80211_AMPDU_TX_START notification, packets destined to
that TID are stored in a buffer, and to send them out as aggregates, ath9k
needs to know whether the ADDBA exchange has completed or not.

If the ADDBA request has been declined, IEEE80211_AMPDU_TX_STOP is sent to
the driver, but no notification is sent if the ADDBA request has been accepted.

Sujith
