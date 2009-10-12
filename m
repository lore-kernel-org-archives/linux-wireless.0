Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34434 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754049AbZJLHQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 03:16:35 -0400
Date: Mon, 12 Oct 2009 10:15:50 +0300
From: Jouni Malinen <j@w1.fi>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com
Subject: Re: BUG? I can reproduce "Association request to the driver
	failed" at will
Message-ID: <20091012071550.GD25578@jm.kir.nu>
References: <200909211309.40476.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200909211309.40476.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 21, 2009 at 01:09:40PM +0200, Holger Schurig wrote:
> The following is an indication about yet another MLME problem:
> 
> Two APs, both set to the MNHS/WPA.
> 
> Let wpa_supplicant associate. Turn one AP off. wpa_supplicant
> automatically associates to the second.

Though, even in this case, there is actually a bug somewhere (in
mac80211, I would assume).. The authentication attempt with the second
AP times out because mac80211 ends up sending the direct probes to the
MAC address of the old AP (which is now turned off). When wpa_supplicant
tries to authenticate again, the direct probes are going to the correct
destination and connection can be established.

> Now turn the first AP on again. Issue a manual scan command:

..

> 1253527140.953161: nl80211: Event message available
> 1253527140.953200: nl80211: MLME event 37
> 1253527140.953216: SME: Authentication response: peer=00:13:19:80:da:30 auth_type=0 status_code=0
> 1253527140.953243: Trying to associate with 00:13:19:80:da:30 (SSID='MNWPA' freq=2412 MHz)
> 1253527140.953257: State: AUTHENTICATING -> ASSOCIATING
> 1253527140.953270: wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
> 1253527140.953284: nl80211: Operstate: linkmode=-1, operstate=5
> 1253527140.953901: nl80211: Associate (ifindex=34)
> 1253527140.953919:   * bssid=00:13:19:80:da:30
> 1253527140.953934:   * freq=2412
> 1253527140.953945:   * SSID - hexdump_ascii(len=5):
>      4d 4e 57 50 41                                    MNWPA
> 1253527140.953977:   * IEs - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
> 1253527140.954064: nl80211: MLME command failed: ret=-114 (Operation already in progress)
> 1253527140.954086: Association request to the driver failed

I can reproduce this with the current wpa_supplicant (that has a
workaround for this EALREADY for authentication case, but not for
assoc) and the current wireless-testing. Roaming will get mac80211 into
very odd state..

Not only is this association failing (after the authentication with the
same AP actually worked), but the scanning state will also get quite
confused.. The next scan trigger after this is never completed (iw scan
gets stuck). Or well, actually, once I wait long enough for the AP to
deauthenticate the client, it looks like mac80211 can recover. The scan
command returned after five minutes of waiting.. ;-)

> The "Association request to the driver failed" will
> be shown even without "-d". Also note that the association
> seems to actually work, e.g. I can ping throught the
> connection.

mac80211 remains associated with the old AP (I think) and somehow
remains in the state between authentication and association (with the
new AP) which will block scans.

-- 
Jouni Malinen                                            PGP id EFC895FA
