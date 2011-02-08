Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:43258 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab1BHUJJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 15:09:09 -0500
Date: Tue, 8 Feb 2011 21:09:05 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC] rt2x00: Add autowakeup timer for receiving beacons while
 in powersave mode
Message-ID: <20110208200905.GB32133@sig21.net>
References: <201101311600.39486.IvDoorn@gmail.com>
 <874o8mbaec.fsf@purkki.adurom.net>
 <20110202212912.GA28687@sig21.net>
 <87r5bj7wyx.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87r5bj7wyx.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 08, 2011 at 10:27:02AM +0200, Kalle Valo wrote:
> So I have my concerns if it really makes sense to implement this in
> mac80211. Extra complexity (and extra maintenance) for two sub-optimal
> (from power save point of view) hardware.

Agreed the timer thing is ugly and should stay in the driver,
provided it survives stress testing.

But the mc/bc check Ivo suggested as part of his RFC patch is already on
the mac80211 TODO list because of ath9k (ath_beacon_dtim_pending_cab()):
http://wireless.kernel.org/en/developers/todo-list#power_saving

I'm not sure if the mac80211 changes suggested by Ivo would work for
ath9k (and carl9170 which also has a similar check).  Maybe someone
could comment on that.


Johannes
