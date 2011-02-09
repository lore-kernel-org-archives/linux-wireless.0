Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:49451 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174Ab1BIOjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:39:05 -0500
Date: Wed, 9 Feb 2011 16:38:53 +0200
From: Jouni Malinen <j@w1.fi>
To: =?utf-8?B?QmrDtnJu?= Smedman <bjorn.smedman@venatech.se>
Cc: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com
Subject: Re: [PATCH 1/1] ath9k: Update comments for not parsing DTIM period
Message-ID: <20110209143853.GA6519@jm.kir.nu>
References: <1297093108-28541-1-git-send-email-mshajakhan@atheros.com>
 <AANLkTimXCXW8mT8tPbSuCDpwyyD=NSRyBvFcC2Y+Nq7N@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTimXCXW8mT8tPbSuCDpwyyD=NSRyBvFcC2Y+Nq7N@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 08, 2011 at 10:22:39PM +0100, Björn Smedman wrote:
> On Mon, Feb 7, 2011 at 4:38 PM, Mohammed Shafi Shajakhan
> <mshajakhan@atheros.com> wrote:
> > -        * Some times we dont parse dtim period from mac80211, in that case
> > -        * use a default value
> > +        * We don't parse dtim period from mac80211 during the driver
> > +        * initialization as it breaks association with hidden-ssid
> > +        * AP and it causes latency in roaming

> I realize I'm not the perfect representative for the intended audience
> but I don't understand that comment at all. The previous one made
> sense to me, but the new one seems to refer to some logic somewhere
> else. In ath_beacon_config() I expect AP/IBSS logic but the comment
> seems to be about some special case for a STA vif associating with a
> hidden access point, no? I don't understand that special case either
> but that is more easily attributable to ignorance. :)

While I agree that the proposed comment is quite confusing, this
function is actually used even in station mode to set beacon timers for
when to wake up for receiving beacon frames, etc. However, I don't see
why this comment should really be here. In addition, this should really
be fixed by updating DTIM period after the first Beacon frame is
received. Forcing a wait for that Beacon frame is the one that causes
the extra latency; I don't remember why exactly this would break
hidden SSID case unless there is another bug somewhere.

ath9k does not need to know the DTIM period before association and the
first call to this function may need to handle the 0 -> 1 safety check.
This should then be followed by another call (likely new code in
mac80211 needed for this) to update the timers after the DTIM period has
been learned post-association.

-- 
Jouni Malinen                                            PGP id EFC895FA
