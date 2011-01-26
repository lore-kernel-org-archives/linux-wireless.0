Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:50965 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039Ab1AZJrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 04:47:14 -0500
Date: Wed, 26 Jan 2011 11:46:08 +0200
From: Jouni Malinen <j@w1.fi>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
Message-ID: <20110126094608.GB11832@jm.kir.nu>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <20110124094433.GA5487@jm.kir.nu>
 <AANLkTimYZN5438DOGNOE9Ltny5M-qg-K1ShFKToRMyuw@mail.gmail.com>
 <20110125094130.GA25962@jm.kir.nu>
 <AANLkTimybq=P+mJW36yYCyQeEq7SeACa8ZDewYsy2w38@mail.gmail.com>
 <AANLkTi=Ud-QPqxOx8xLUPA4UgoTCx+H78QWACpotMcX9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=Ud-QPqxOx8xLUPA4UgoTCx+H78QWACpotMcX9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 26, 2011 at 08:24:32AM +0200, Arik Nemtsov wrote:
> Just to clear up - I don't want to disable p2p or wps support in
> hostapd if probe-resp offloading is configured. The low level
> driver/fw could realistically differentiate between regular and
> non-support probe requests, and only handle the former.
> The kind of capability flag you asked won't work with such a low lever
> driver/fw combo. Is muti-ssid support currently implemented?

You may not want to disable something, but I do want
hostapd/wpa_supplicant to be able disable P2P or other features if it is
not clear the the driver is unable to support them correctly. Knowing
whether the driver is planning on using hostapd for processing Probe
Request frames is a key for this and as such, I cannot support use of
this functionality in hostapd/wpa_supplicant before that driver
capability information is exposed to user space.

How would the firmware be aware of new protocols that pop up every now
and then? There does not seem to be any other way of doing this reliably
apart from being able to advertise support for protocol specific needs
like adding a P2P-Probe-Request-offload capability and
P2P-Probe-Request-will-be-passed-up-but-everything-else-offloaded
capability when support for P2P is added. Similar flags would then be
needed for whatever new protocol comes up with silly Probe Request
processing requirements.

Parts of multi-SSID support are in hostapd, but I do not think it is
enabled at the moment.

> How about a different solution - I'll just disable p2p IEs for the
> probe-resp template for now. Let's assume the FW behaves correctly in
> this case and passes up the probe-requests. The code for generating
> the WPS IE for the probe-resp seems to not depend on the probe-req. Is
> the feature of WPS 2.0 you mentioned currently implemented? If so this
> can be disabled as well.

Disable where? And how would hostapd/wpa_supplicant know that something
is disabled? We cannot design a new driver interface that depends on an
assumed hack in a firmware of one device. This needs to be usable by
other drivers, too, and unless such assumptions are clearly documented
(and not randomly changing) it will be difficult to see consistent
behavior between different drivers and user space applications.

-- 
Jouni Malinen                                            PGP id EFC895FA
