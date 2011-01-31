Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:47461 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755620Ab1AaLrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:47:25 -0500
Date: Mon, 31 Jan 2011 13:47:17 +0200
From: Jouni Malinen <j@w1.fi>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Rajkumar Manoharan <Rajkumar.Manoharan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: deauthenticate STAs before suspend
Message-ID: <20110131114717.GA2919@jm.kir.nu>
References: <1296468391-12268-1-git-send-email-rmanoharan@atheros.com>
 <1296473261.3812.12.camel@jlt3.sipsolutions.net>
 <20110131113835.GA14176@vmraj-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110131113835.GA14176@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 31, 2011 at 05:08:35PM +0530, Rajkumar Manoharan wrote:
> On Mon, Jan 31, 2011 at 04:57:41PM +0530, Johannes Berg wrote:
> > Is that a big problem? We actually had this intentionally, and we go to
> > PS before going to sleep, so if the sleep is very short then we will not
> > be disconnected. Also, it's much easier this way to implement WoWLAN.
> I looked it as a problem ;) And if we use NM/supplicant, obviously the STA
> got disconnected. So just to align with that I sent the RFC.

While this may behave differently if NM is running (wpa_supplicant
should not be being the disconnection on suspend), the comment about
Wake-on-WLAN is something that should be considered here. I would expect
there to be some interest in being able to support it and forcing a
disconnection on suspend would make that impossible. In addition,
extended PS mode from 802.11v will make it even more desirable to be
able to sleep for extended periods of time without dropping the
association for some use cases. If we force a disconnection here, we
would need to have a flag for disabling that if there is any chance of
the association being of use for something else after the resume or if
Wake-on-WLAN is enabled.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
