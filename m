Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:38220 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938Ab1DOQey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 12:34:54 -0400
Date: Fri, 15 Apr 2011 19:34:43 +0300
From: Jouni Malinen <j@w1.fi>
To: Juan Carlos Garza <juancarlosgarza@gmail.com>
Cc: hostap@lists.shmoo.com, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Subject: Re: WPA2 Access Point (HostAPD) authentication with Samsung Galaxy
 Tab fails.
Message-ID: <20110415163443.GH23532@jm.kir.nu>
References: <BANLkTimEipE8q-ehYFrXpVqHRSHrCcZxXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTimEipE8q-ehYFrXpVqHRSHrCcZxXw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 15, 2011 at 12:54:28PM +0200, Juan Carlos Garza wrote:
> I am having trouble to authenticate a Samsung Galaxy Tab with an AP on
> a rt3070 usb device. The specifics follow...

> However, I am trying to authenticate with a Samsung Galaxy Tab with
> Android 2.2 on it, and I get the following log:

> mgmt::auth
> authentication: STA=bc:47:60:93:74:bd auth_alg=0 auth_transaction=1
> wlan0: STA bc:47:60:93:74:bd IEEE 802.11: authentication OK (open system)
> authentication reply: STA=bc:47:60:93:74:bd auth_alg=0
> mgmt::assoc_req
> association request: STA=bc:47:60:93:74:bd capab_info=0x431 listen_interval=10
> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
>   new AID 2
> HT: STA bc:47:60:93:74:bd HT Capabilities Info: 0x182c
> wlan0: STA bc:47:60:93:74:bd IEEE 802.11: association OK (aid 2)
> mgmt::auth cb
> wlan0: STA bc:47:60:93:74:bd IEEE 802.11: authenticated

Huh... That rt3070 device or driver sure takes long to deliver the TX
status information.

> Data/PS-poll frame from not associated STA bc:47:60:93:74:bd
> mgmt::assoc_resp cb

And since the station you are using here seems to send some Data frames
quickly after the association, it happens to hit a race condition
between the association response TX status callback and first Data frame
being received. This in turn makes hostapd disassociate the station
since from its view point, the station tried to send a Data frame while
it had not yet completed association.

You can now find a workaround for this in the current development branch
for hostapd:
http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=commitdiff;h=b8281964afb1df98135418fc22a9fa240968d100

-- 
Jouni Malinen                                            PGP id EFC895FA
