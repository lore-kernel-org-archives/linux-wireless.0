Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55324 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1AZGIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 01:08:47 -0500
Received: by yxt3 with SMTP id 3so2027333yxt.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 22:08:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110125094130.GA25962@jm.kir.nu>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <20110124094433.GA5487@jm.kir.nu> <AANLkTimYZN5438DOGNOE9Ltny5M-qg-K1ShFKToRMyuw@mail.gmail.com>
 <20110125094130.GA25962@jm.kir.nu>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Jan 2011 08:08:31 +0200
Message-ID: <AANLkTimybq=P+mJW36yYCyQeEq7SeACa8ZDewYsy2w38@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 25, 2011 at 11:41, Jouni Malinen <j@w1.fi> wrote:
> On Mon, Jan 24, 2011 at 11:16:43PM +0200, Arik Nemtsov wrote:
>> The SSID-as-attr not used for the probe-resp template. It is used by
>> FW to filter out which probe-reqs should be responded to when
>> operating with a hidden SSID.
>
> OK, that would be useful to mention in nl80211.h comments and
> cfg80211.h, too, I'd guess.

Sure. I'll put in a few words.

>
>> The wl12xx FW updates the timestamp and DA. I mentioned in the
>> documentation of ieee80211_proberesp_get (and various other parts)
>> that the DA should be set manually and that this should be used as a
>> template (which also implies timestamp should be set). If some part is
>> unclear can you point out a specific patch?
>
> DA should be pretty obvious. Timestamp is something that I hope is clear
> for whoever is implementing a driver, but it could be mentioned
> somewhere.

Sure.

>
>> Perhaps we can start with these AP-mode only patches and expand the
>> functionality when it is needed for p2p?
>
> I'm fine with them if there is a capability flag that allows user space
> to know that the driver does not use user space -based Probe Request
> processing. With that, hostapd/wpa_supplicant can disable functionality
> like multi-SSID support, WPS 2.0, P2P until we get more complete
> capability information on what devices that process Probe Request frames
> internally can do.

Makes sense. I'll look into it.

Arik
