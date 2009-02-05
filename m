Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:57538 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515AbZBEJ36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 04:29:58 -0500
Date: Thu, 5 Feb 2009 11:29:34 +0200
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Kishore Ramachandran <kishore@winlab.rutgers.edu>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Setting 11n MCS TX bitrate
Message-ID: <20090205092934.GA12435@jm.kir.nu> (sfid-20090205_103003_622854_36EBC272)
References: <604f6e750902041408k7335234bs565e8fe6868f0f54@mail.gmail.com> <20090204222203.GJ5581@tesla> <604f6e750902041451x340e0b14x4561125c1f7163c6@mail.gmail.com> <20090204231840.GL5581@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090204231840.GL5581@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 04, 2009 at 03:18:40PM -0800, Luis R. Rodriguez wrote:
> Well in general I was talking about IEEE-802.11 section 10.3 stuff.
> In cfg80211/nl80211 we don't want to allow things like "set essid"
> as iwconfig has, instead we want to break things down a bit more,
> which can really help debugging. The MLME SAP already has some
> decent layout of commands/responses but after a quick glance
> I do not see anything for setting a static rate. May want to review
> that a bit before implementing set rate though. Just remember
> post early and review early. If you have an idea of how you want
> to do it let us know to get feedback.

TX rate control is outside the scope of IEEE Std 802.11-2007 (see 9.6
Multirate support) and as such, there is no MLME SAP (or any other)
primitives for this type of functionality defined in the standard. The
parameters are passed into PHY through the PHY-SAP interface in TXVECTOR
(e.g., DATARATE and MCS). How the MAC sublayer decides how to set these
parameters or even things like how to control the decision process are
very much out of scope.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
