Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:36547 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754771Ab1BINWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 08:22:34 -0500
Date: Wed, 9 Feb 2011 15:22:18 +0200
From: Jouni Malinen <j@w1.fi>
To: Ben Greear <greearb@candelatech.com>
Cc: Daniel Halperin <dhalperi@cs.washington.edu>,
	Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Scanning and channel types.
Message-ID: <20110209132218.GA6183@jm.kir.nu>
References: <4D4F0D83.4040401@candelatech.com>
 <4D4F0DFF.9010703@openwrt.org>
 <AANLkTin=zENpxMQYe65Vxs7oSVqe37Lt3mgiPp=L-jzA@mail.gmail.com>
 <4D5033DE.4070701@candelatech.com>
 <AANLkTimzp3nL=vbxnhH2ZYZtGNFqMsKKqTw1+pfjkUMu@mail.gmail.com>
 <4D50503E.4090007@candelatech.com>
 <AANLkTim_rcWdzPhraUaTvC_C3-Tm5_w5xH6xHOK=mviE@mail.gmail.com>
 <4D505DDD.8050805@candelatech.com>
 <AANLkTimybx2pQGsy908ZOKCUndQX55vOQy1aToingWSY@mail.gmail.com>
 <4D50909B.1020005@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D50909B.1020005@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 07, 2011 at 04:38:51PM -0800, Ben Greear wrote:
> On 02/07/2011 03:53 PM, Daniel Halperin wrote:
> >Just as there are G-only APs that don't advertise 1-11 Mbps in their
> >beacons, there are HT-only APs that don't advertise support for 1-11
> >or 6-54 Mbps in their beacons and *only* support MCS rates.

> If anyone knows how to configure such a beast, I'll run some
> tests.  Or, if someone else has an AP like this, please let
> me know if you see any problems with these patches.

As of today, the hostap.git snapshot of hostapd allows you to configure
the AP to require HT PHY support from every station trying to associate
with it. This can be configured with require_ht=1. This by itself does
not change the advertised rate sets, but when set, this allows following
configuration to remove all non-MCS rates to be disabled:

ieee80211n=1
require_ht=1
supported_rates=
basic_rates=

I'm not sure whether we currently handle such configuration correctly
everywhere, but at least this will remove the non-MCS rates from
Beacon/Probe Response frames from the AP. It does not prevent the AP
from actually receiving frames at non-MCS rates, so it may still reply
to Probe Request frames even if they are sent without using MCS rates. I
think I can make hostapd not reply to those frames if they do not
contain HT Capabilities IE, but still, you would likely see a response
to a Probe Request with that IE included even if it is sent at 1 Mbps.
Whether the response goes out using MCS in such a case is unknown to me
at this point, though.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
