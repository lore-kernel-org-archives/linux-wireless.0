Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39048 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab1AXVQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 16:16:59 -0500
Received: by yxt3 with SMTP id 3so1448527yxt.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 13:16:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110124094433.GA5487@jm.kir.nu>
References: <1295816579-28925-1-git-send-email-arik@wizery.com> <20110124094433.GA5487@jm.kir.nu>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 24 Jan 2011 23:16:43 +0200
Message-ID: <AANLkTimYZN5438DOGNOE9Ltny5M-qg-K1ShFKToRMyuw@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 24, 2011 at 11:44, Jouni Malinen <j@w1.fi> wrote:
> On Sun, Jan 23, 2011 at 11:02:53PM +0200, Arik Nemtsov wrote:
>> Support passing SSID and probe-response template to drivers.
>> This data can be used to offload the beacon -> probe-req -> probe-resp
>> process to HW.
>
> What is the expected driver behavior for passing the SSID as a separate
> attribute vs. passing the SSID as an IE within the Probe Response
> template? Is the SSID-as-attr ever used to fill in a Probe Response by
> the driver/firmware? Or is the driver/firmware only allowed to use the
> full Probe Response template (with DA and timestamp updated)? It would
> be useful to get this documented so that it is clear for people working
> with both a driver and user space applications that could use the new
> interface.

The SSID-as-attr not used for the probe-resp template. It is used by
FW to filter out which probe-reqs should be responded to when
operating with a hidden SSID.
The wl12xx FW updates the timestamp and DA. I mentioned in the
documentation of ieee80211_proberesp_get (and various other parts)
that the DA should be set manually and that this should be used as a
template (which also implies timestamp should be set). If some part is
unclear can you point out a specific patch?

>
> We should also document the need for special Probe Request processing
> for WPS and P2P and have capability flags indicating whether the driver
> needs the SSID and/or Probe Response template and whether it supports
> various special rules for Probe Request processing (remove P2P IE from
> Probe Response template if Probe Request does not include it, do not
> reply to Probe Request if there is no match for Requested Device Type,
> do not reply if there is no match for P2P Device Address). hostapd (or
> wpa_supplicant AP mode) would then automatically disable use of P2P
> and/or WPS if the driver/firmware does not have necessary capabilities
> to implement this correctly.
>

For WPS (without p2p), it appears the probe-resp doesn't depend on the
probe-req (in hostapd code).
I also explicitly made sure this scenario works since this is a good
example for a use-case when the probe-response is different from the
beacon.

Perhaps we can start with these AP-mode only patches and expand the
functionality when it is needed for p2p?
It may be hard to predict what other special handling will be needed
for offloading p2p probe-resps to FW (when such FW is available).

Note that the current patch doesn't remove existing functionality - a
driver/FW operating in p2p mode can simply choose not to use the
template and just pass probe-requests up.

Regards,
Arik
