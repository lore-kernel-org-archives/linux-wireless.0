Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:47383 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbYFQRsr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 13:48:47 -0400
Date: Tue, 17 Jun 2008 20:47:49 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] IEEE 802.11w / management frame protection
Message-ID: <20080617174749.GB4974@jm.kir.nu> (sfid-20080617_194850_990319_709D3ACA)
References: <20080617154008.883383150@localhost> <1213721067.3803.73.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213721067.3803.73.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 17, 2008 at 06:44:27PM +0200, Johannes Berg wrote:

> > crypto. It is unclear whether this can be used as-is with devices that
> > use hwaccel for crypto at least before the low-level drivers and/or
> > firmware have been modified to cope with the possibility of CCMP being
> > used with management frames.
> 
> b43 will be able to do this for sure, it doesn't care what sort of frame
> is encrypted. The question is how drivers can indicate
> support/non-support I guess.

One of the problems is that CCMP as defined in IEEE 802.11i for data
frames is not compatible with CCMP as defined in IEEE 802.11w for
management frames (there are small differences in AAD and nonce
generation). As such, if the hardware/firmware is trying to decrypt
received CCMP protected frames based on the IEEE 802.11i rules even if
the frame is a management frame, the end result is not going to be very
good.. It would be necessary to either disable hwaccel for CCMP
decryption for management frames (if possible) or add software
workaround to re-encrypt the management frame incorrectly (to undo
hardware/firmware operations) and then decrypt it in software..

-- 
Jouni Malinen                                            PGP id EFC895FA
