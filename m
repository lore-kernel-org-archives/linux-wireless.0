Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2KXNo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 08:44:27 -0500
Message-ID: <1353764695.9789.4.camel@jlt4.sipsolutions.net> (sfid-20121124_144454_472931_AC61427C)
Subject: Re: [RFC 1/1] ath9k: Add radiotap vendor specific data example
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Nov 2012 14:44:55 +0100
In-Reply-To: <1353667565-4212-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20121123_115242_843402_5FE9C369)
References: <1353667565-4212-1-git-send-email-Wojciech.Dubowik@neratec.com>
	 (sfid-20121123_115242_843402_5FE9C369)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 11:46 +0100, Wojciech Dubowik wrote:

> +			rxs->vendor_radiotap_bitmap = 0x00000001;

I would recommend adding multiple fields so that it's extensible in the
future or some things can be left out:

field 0 (0x1):
	4 x u8, alignment 1 - RSSI data
field 1 (0x2):
	4 x u32 + 1 x u16, alignment ? - evm data


Also:
Ness, STBC are going to be standardised.
noise floor is already standardised I think

johannes

