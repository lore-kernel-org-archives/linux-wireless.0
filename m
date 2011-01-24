Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:33204 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197Ab1AXJoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 04:44:46 -0500
Date: Mon, 24 Jan 2011 11:44:33 +0200
From: Jouni Malinen <j@w1.fi>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
Message-ID: <20110124094433.GA5487@jm.kir.nu>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1295816579-28925-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 23, 2011 at 11:02:53PM +0200, Arik Nemtsov wrote:
> Support passing SSID and probe-response template to drivers.
> This data can be used to offload the beacon -> probe-req -> probe-resp
> process to HW.

What is the expected driver behavior for passing the SSID as a separate
attribute vs. passing the SSID as an IE within the Probe Response
template? Is the SSID-as-attr ever used to fill in a Probe Response by
the driver/firmware? Or is the driver/firmware only allowed to use the
full Probe Response template (with DA and timestamp updated)? It would
be useful to get this documented so that it is clear for people working
with both a driver and user space applications that could use the new
interface.

We should also document the need for special Probe Request processing
for WPS and P2P and have capability flags indicating whether the driver
needs the SSID and/or Probe Response template and whether it supports
various special rules for Probe Request processing (remove P2P IE from
Probe Response template if Probe Request does not include it, do not
reply to Probe Request if there is no match for Requested Device Type,
do not reply if there is no match for P2P Device Address). hostapd (or
wpa_supplicant AP mode) would then automatically disable use of P2P
and/or WPS if the driver/firmware does not have necessary capabilities
to implement this correctly.

-- 
Jouni Malinen                                            PGP id EFC895FA
