Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53212 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1BNK03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:26:29 -0500
Subject: Re: [RFC] rt2x00: Add autowakeup timer for receiving beacons while
 in powersave mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: RA-Jay Hung <Jay_Hung@ralinktech.com>,
	Kalle Valo <kvalo@adurom.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	RA-Dennis Lee <Dennis_Lee@ralinktech.com>,
	RA-Eddy Tsai <Eddy_Tsai@ralinktech.com>
In-Reply-To: <AANLkTimRT-2B4G1jC4D+BZURmd_FRGSkLT5MKsEvcS3r@mail.gmail.com>
References: <201101311600.39486.IvDoorn@gmail.com>
	 <874o8mbaec.fsf@purkki.adurom.net>
	 <AANLkTikKevPWkWMu=HLPHt-jACLZLQzqN6thr-2LNk59@mail.gmail.com>
	 <B7288B2B5878D747BA031EF4B170D7F6092D2727@TWHCMBS01.tw.ralinktech.ad>
	 <AANLkTimRT-2B4G1jC4D+BZURmd_FRGSkLT5MKsEvcS3r@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 11:25:54 +0100
Message-ID: <1297679154.3785.24.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-14 at 11:14 +0100, Ivo Van Doorn wrote:

> Thanks. So I'll add this routine to the rt2800usb driver then. :)
> 
> Johannes, if you don't want to add the complexity for checking the
> "pending MC/BC frames" in
> a received frame. Would you mind if I add some utility functions to
> mac80211 then? That way the
> logic is still shared for the drivers that need it, but it doesn't
> impact the code paths in mac80211 itself...

Sure, that's ok I suppose. FWIW, if it makes the implementation a lot
simpler, adding it in mac80211 would be acceptable, but I'm not
convinced that CONF_PS is the right hook for it, since mac80211
throughout assumes CONF_PS will automatically wake up for beacons etc.,
and changing that would imho exponentially increase the already high
complexity of the powersaving implementation.

johannes

