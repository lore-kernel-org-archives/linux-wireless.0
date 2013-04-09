Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55878 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935212Ab3DIJmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 05:42:11 -0400
Message-ID: <1365500525.8465.8.camel@jlt4.sipsolutions.net> (sfid-20130409_114215_786518_11556CF2)
Subject: Re: [PATCH 6/6] mac80211: avoid mesh peer rate update warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Tue, 09 Apr 2013 11:42:05 +0200
In-Reply-To: <1365500301.8465.6.camel@jlt4.sipsolutions.net> (sfid-20130409_113828_957604_9F52C1F0)
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
	 <1365444377-9959-6-git-send-email-thomas@cozybit.com>
	 (sfid-20130408_200821_359359_9CD5C99F) <1365500301.8465.6.camel@jlt4.sipsolutions.net>
	 (sfid-20130409_113828_957604_9F52C1F0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-09 at 11:38 +0200, Johannes Berg wrote:
> On Mon, 2013-04-08 at 11:06 -0700, Thomas Pedersen wrote:
> > Some drivers (like ath9k_htc) will take a mutex in
> > rate_control_rate_update(), so drop the sta lock before we
> > get there.
> 
> That driver is broken then. rate_control_rate_update() can be called
> from the RX path where this also isn't allowed.

 * @sta_rc_update: Notifies the driver of changes to the bitrates that
can be
 *      used to transmit to the station. The changes are advertised with
bits
 *      from &enum ieee80211_rate_control_changed and the values are
reflected
 *      in the station data. This callback should only be used when the
driver
 *      uses hardware rate control (%IEEE80211_HW_HAS_RATE_CONTROL)
since
 *      otherwise the rate control algorithm is notified directly.
 *      Must be atomic.

(note last line)

johannes

