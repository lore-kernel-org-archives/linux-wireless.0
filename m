Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946674Ab3BHRPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:15:49 -0500
Message-ID: <1360343742.29851.24.camel@jlt4.sipsolutions.net> (sfid-20130208_181552_690081_F517E462)
Subject: Re: [PATCH] mac80211: introduce beacon-only timing data
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 08 Feb 2013 18:15:42 +0100
In-Reply-To: <87k3qibujn.fsf@purkki.adurom.net>
References: <1360160966-26163-1-git-send-email-johannes@sipsolutions.net>
	 <87k3qibujn.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 19:10 +0200, Kalle Valo wrote:
> Hi,
> 
> I'm getting seriously behind email, but...
> 
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > In order to be able to predict the next DTIM TBTT
> > in the driver, add the ability to use timing data
> > from beacons only with the new hardware flag
> > IEEE80211_HW_TIMING_BEACON_ONLY and the BSS info
> > value sync_dtim_count which is only valid if the
> > timing data came from a beacon. The data can only
> > come from a beacon, and if no beacon was received
> > before association it is updated later together
> > with the DTIM count notification.
> 
> Just out of curiosity, who uses this?

I have a patch for our MVM driver to use it. And in fact, our DVM driver
should probably use it as well, but it seems to work without since it
only really supports a single channel (although it might explain the
beacon loss it has when using P2P? not sure)

The thing is that the device wants to know when to expect the DTIM
beacon, so it can schedule powersave correctly. It needs this from a
beacon frame because probe response frames don't tell you when to expect
a DTIM TBTT (1). Hence, this patch.

johannes

(1) technically, the spec says somewhere that if you calculate backwards
in time TSF==0 is a DTIM TBTT, but not all APs even have TSF==0 as a
TBTT, let alone a DTIM TBTT.

