Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35814 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab0I2FUW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 01:20:22 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 22:20:14 -0700
Date: Wed, 29 Sep 2010 10:50:06 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Jouni Malinen <j@w1.fi>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: [PATCH] mac80211: fix rate_control_send_low warnings for delbas
Message-ID: <20100929052006.GC18450@vasanth-laptop>
References: <20100928222945.GB10932@tux> <20100928230211.GA9844@jm.kir.nu> <AANLkTimGPPUW6=QYpZz7q96vt1GOd5kJ-tvYEKxZZT2B@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTimGPPUW6=QYpZz7q96vt1GOd5kJ-tvYEKxZZT2B@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 29, 2010 at 05:28:35AM +0530, Luis R. Rodriguez wrote:
> On Tue, Sep 28, 2010 at 4:02 PM, Jouni Malinen <j@w1.fi> wrote:
> > On Tue, Sep 28, 2010 at 03:29:45PM -0700, Luis R. Rodriguez wrote:
> >
> >> Added support for cfg80211/mac80211 to cleanly roam between two BSSes
> >> on an ESS by allowing the station to reassociate to an old AP and
> >> only when that is done drop the old association. What we forgot to
> >> take into consideration is that when we disassociate with the older
> >> AP we may need to transmit frames to that AP and those frames may
> >> actually be intended to go under a different channel and even sometimes
> >> a completely separate band than the new APs.
> >
> > which frames are you talking about here?
> 
> ieee80211_send_delba()
> 
> > When reassociating to a new BSS
> > in an ESS, there should be no need to transmit frames to the old AP
> > anymore, i.e., we are never associated with more than one BSS (when
> > talking about a single vif). We could just drop any potential TX frame
> > to the old AP after the moment the new AP is marked associated.
> 
> That's the goal of this patch.

>From my debugging, this happens when cleaning up BA session for old
AP but on a different channel (where we just authenticated with
another AP) just before starting association with the new AP.
Though local->work_work takes care of moving to right channel,
it is possible that cfg80211 receives NL80211_CMD_ASSOCIATE before
local->work_work configures the hw back to old AP's channel (that
is what happening in our case).


Vasanth
