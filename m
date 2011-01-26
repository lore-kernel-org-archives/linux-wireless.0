Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58725 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1AZGYs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 01:24:48 -0500
Received: by ywe10 with SMTP id 10so1642404ywe.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 22:24:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimybq=P+mJW36yYCyQeEq7SeACa8ZDewYsy2w38@mail.gmail.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <20110124094433.GA5487@jm.kir.nu> <AANLkTimYZN5438DOGNOE9Ltny5M-qg-K1ShFKToRMyuw@mail.gmail.com>
 <20110125094130.GA25962@jm.kir.nu> <AANLkTimybq=P+mJW36yYCyQeEq7SeACa8ZDewYsy2w38@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Jan 2011 08:24:32 +0200
Message-ID: <AANLkTi=Ud-QPqxOx8xLUPA4UgoTCx+H78QWACpotMcX9@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 26, 2011 at 08:08, Arik Nemtsov <arik@wizery.com> wrote:
> On Tue, Jan 25, 2011 at 11:41, Jouni Malinen <j@w1.fi> wrote:
>> On Mon, Jan 24, 2011 at 11:16:43PM +0200, Arik Nemtsov wrote:
>>> The SSID-as-attr not used for the probe-resp template. It is used by
>>> FW to filter out which probe-reqs should be responded to when
>>> operating with a hidden SSID.
>>
>> OK, that would be useful to mention in nl80211.h comments and
>> cfg80211.h, too, I'd guess.
>
> Sure. I'll put in a few words.
>
>>
>>> The wl12xx FW updates the timestamp and DA. I mentioned in the
>>> documentation of ieee80211_proberesp_get (and various other parts)
>>> that the DA should be set manually and that this should be used as a
>>> template (which also implies timestamp should be set). If some part is
>>> unclear can you point out a specific patch?
>>
>> DA should be pretty obvious. Timestamp is something that I hope is clear
>> for whoever is implementing a driver, but it could be mentioned
>> somewhere.
>
> Sure.
>
>>
>>> Perhaps we can start with these AP-mode only patches and expand the
>>> functionality when it is needed for p2p?
>>
>> I'm fine with them if there is a capability flag that allows user space
>> to know that the driver does not use user space -based Probe Request
>> processing. With that, hostapd/wpa_supplicant can disable functionality
>> like multi-SSID support, WPS 2.0, P2P until we get more complete
>> capability information on what devices that process Probe Request frames
>> internally can do.
>
> Makes sense. I'll look into it.
>

Just to clear up - I don't want to disable p2p or wps support in
hostapd if probe-resp offloading is configured. The low level
driver/fw could realistically differentiate between regular and
non-support probe requests, and only handle the former.
The kind of capability flag you asked won't work with such a low lever
driver/fw combo. Is muti-ssid support currently implemented?

How about a different solution - I'll just disable p2p IEs for the
probe-resp template for now. Let's assume the FW behaves correctly in
this case and passes up the probe-requests. The code for generating
the WPS IE for the probe-resp seems to not depend on the probe-req. Is
the feature of WPS 2.0 you mentioned currently implemented? If so this
can be disabled as well.

Arik
