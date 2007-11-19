Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:34563 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbXKSD77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2007 22:59:59 -0500
Date: Sun, 18 Nov 2007 19:59:43 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <Kalle.Valo@nokia.com>,
	Li YanBo <dreamfly281@gmail.com>, Ben Gamari <ben@mw0.ath.cx>,
	linux-wireless@vger.kernel.org,
	Jose Ignacio Naranjo Hernandez
	<joseignacio.naranjo@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: Suspend/Resume support
Message-ID: <20071119035943.GJ8672@jm.kir.nu> (sfid-20071119_040005_733971_066DBCED)
References: <1195087905.3814.11.camel@mercury> <1197ff4c0711141937gc7bb1f8w499cd9d8634fa232@mail.gmail.com> <1195171869.8147.79.camel@johannes.berg> <87ir42z5kq.fsf@nokia.com> <1195224067.8147.122.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1195224067.8147.122.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 16, 2007 at 03:41:07PM +0100, Johannes Berg wrote:

> mac80211 has a comment that NULL frames are just for PS control
> operation and otherwise ignored. So no idea.

Please note that this comment in ieee80211_rx_h_sta_process() is only
after having went through association state validation in
ieee80211_rx_h_check(). However, it looks like the sending of
deauth/disassoc based on Class 2/3 frames being received in wrong state
(IEEE 802.11, Clause 5.5) has been broken at some point..

mac80211 is supposed to notify userspace (hostapd) of this and hostapd
would then reply with disassoc/deauth depending on the current state of
the STA. The current mac80211 implementation is just silently dropping
the frames. The way this used to work was by sending the
ieee80211_msg_sta_not_assoc message with ieee80211_rx_mgmt() in
ieee80211_rx_h_check().

-- 
Jouni Malinen                                            PGP id EFC895FA
