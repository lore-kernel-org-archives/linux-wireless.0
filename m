Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799AbXITPbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 11:31:46 -0400
Date: Thu, 20 Sep 2007 08:30:56 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: ath5k and network manager
Message-ID: <20070920083056.31f231b9@freepuppy.rosehill>
In-Reply-To: <200709201511.23400.mb@bu3sch.de>
References: <20070919214007.1a6a9b4a@freepuppy.rosehill>
	<43e72e890709200555r779aaa50i6bb8ab90195686bc@mail.gmail.com>
	<200709201511.23400.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 20 Sep 2007 15:11:23 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> On Thursday 20 September 2007, Luis R. Rodriguez wrote:
> > On 9/20/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > > Network manager doesn't seem to detect ath5k. Perhaps it is because
> > > it is name "ath0".  I think device should follow the convention of using
> > > name "wifi0" rather than BSD convention of putting driver name in device name.
> > 
> > I couldn't agree anymore. But my ath5k kicks out a wlan%d name as with
> > any other mac80211 driver. Is yours coming out to ath%d ?
> > 
> > ieee80211_register_hw():
> > 
> >         /* add one default STA interface */
> >         result = ieee80211_if_add(local->mdev, "wlan%d", NULL,
> >                                   IEEE80211_IF_TYPE_STA);
> > 
> 
> 
> Probably udev renames it.

It was udev, don't know why Ubuntu was adding a rule for it (and getting wrong)
value.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
