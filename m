Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:48623 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab1AaLjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:39:24 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 03:39:04 -0800
Date: Mon, 31 Jan 2011 17:08:35 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: deauthenticate STAs before suspend
Message-ID: <20110131113835.GA14176@vmraj-lnx.users.atheros.com>
References: <1296468391-12268-1-git-send-email-rmanoharan@atheros.com>
 <1296473261.3812.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1296473261.3812.12.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 31, 2011 at 04:57:41PM +0530, Johannes Berg wrote:
> On Mon, 2011-01-31 at 15:36 +0530, Rajkumar Manoharan wrote:
> > The STA is not deauthenticated before the system goes to sleep,
> > when the vif was configured by iw/iwconfig. This holds the AP
> > resources unnecessarily, till the STA entry got expired in AP.
> 
> Is that a big problem? We actually had this intentionally, and we go to
> PS before going to sleep, so if the sleep is very short then we will not
> be disconnected. Also, it's much easier this way to implement WoWLAN.
I looked it as a problem ;) And if we use NM/supplicant, obviously the STA
got disconnected. So just to align with that I sent the RFC.

> > So before going to sleep ensure that all stations
> > got deauthenticated.
> 
> Also your text and subject and code is really confusing -- I thought you
> wanted to deauthenticate stations that are associated to mac80211 acting
> as an AP.
I meant that the stations associated in all vifs.

--
Rajkumar
