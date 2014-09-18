Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40507 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaIRFtF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 01:49:05 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21530.29268.867868.46188@gargle.gargle.HOWL> (sfid-20140918_074909_779365_0226DCE8)
Date: Thu, 18 Sep 2014 11:19:08 +0530
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
In-Reply-To: <CANUX_P3o6=sdjHPp2L7tGAeXRW0v4xqSV-2q27Neetu75bDc1A@mail.gmail.com>
References: <1410928422-25587-1-git-send-email-sujith@msujith.org>
	<21529.5141.845629.86918@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B523034@hasmsx107.ger.corp.intel.com>
	<21529.8110.26388.664223@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5230C9@hasmsx107.ger.corp.intel.com>
	<21529.9155.323515.987489@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B52311D@hasmsx107.ger.corp.intel.com>
	<21529.10109.308613.563543@gargle.gargle.HOWL>
	<CANUX_P3hdFeCPmqHCdP8JKwqvUUnjgp3SNy1GQDrQd0bG+WKng@mail.gmail.com>
	<21530.19430.782437.984290@gargle.gargle.HOWL>
	<21530.23545.178915.653622@gargle.gargle.HOWL>
	<CANUX_P3o6=sdjHPp2L7tGAeXRW0v4xqSV-2q27Neetu75bDc1A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach wrote:
> I still think it does not match the original intent of mgd_prepare_tx().
> The way I see it, mgd_prepare_tx() ensures that the Tx *will* happen
> in cases the driver has no specific reason to be on channel, mainly
> because the context is not associated yet. Note that after association
> mac80211 does not interfere with the context switches. The driver is in
> charge of all this - why would it be different in this case?
> flush() makes sure that the Tx *has* happened before destroying things.
> The context switches from association until destruction are under the driver's
> responsibility.
> 
> At least this is the way I see it.
> We (Intel) will not break if you add this call, but in my eyes this does not
> comply with the design. I guess you can always send a patch to add it and
> see what others will say, but Johannes is away right now.
> If you choose to do that, please add a reason as a parameter to mgd_prepare_tx()
> so that we can ignore it when it is called before sending a frame that
> is flush()'ed.
> I still prefer to rely on flush(). And I agree that flush() isn't a
> trivial implementation.

I can see your point and agree that the original intention of the mgd_prepare_tx()
callback is as described in the documentation. But with multiple active
contexts, flush() becomes a big hammer rather than a simple emptying of
the queues. :-)

I think we can extend the intention of the API and use mgd_prepare_tx()
for deauth/disassoc too. And this was done in the original patch, anyway.
This would greatly reduce driver complexity.

I'll send a patch including your suggestion about adding a parameter
to mgd_prepare_tx() which iwlwifi can use.

Sujith
