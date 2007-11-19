Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:4767 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbXKSKns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 05:43:48 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [BUG] libertas: probing for Marvell USB8388 fails
Date: Mon, 19 Nov 2007 11:44:02 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>
References: <20071117023548.79a7a33c@morte> <200711191008.26174.hs4233@mail.mn-solutions.de> <20071119102117.74932cc1@morte>
In-Reply-To: <20071119102117.74932cc1@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711191144.02169.hs4233@mail.mn-solutions.de> (sfid-20071119_104353_961585_1B910A33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> As long as probing fails, I doubt that my issue is firmware
> related...

I was not sure that probing failed for you. I saw an URB submit 
error.

If usb8xxx.ko and libertas.ko get loaded, then it might be a 
wrong firmware. When the USB driver loads, it first uses URBs to 
send a helper firmware to the card. Then this helper firmware 
get's started. And then it sends again URBs to the card, e.g. 
for setup stuff. Now if the helper firmware is bogus and doesn't 
accept the URBs to download the real firmware ...


If probing fails and udev doesn't even load usb8xxx.ko, then you 
have an USB problem and the wireless mailing list might not be 
of much help to you.
