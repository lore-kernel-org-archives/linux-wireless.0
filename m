Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:39560 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbXK0EGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 23:06:13 -0500
Date: Mon, 26 Nov 2007 20:05:36 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211: unencrypted packet vulnerability
Message-ID: <20071127040536.GF5698@jm.kir.nu> (sfid-20071127_040616_869011_91ABBC38)
References: <1195686097.6323.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1195686097.6323.22.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 22, 2007 at 12:01:37AM +0100, Johannes Berg wrote:

> As I just found, mac80211 is susceptible to an attack where the attacker
> simply sends frames it wants us to see unencrypted instead of bothering
> with replay attacks or such. This could possibly cause us to reply to
> these frames or worse yet, a mac80211 based AP could encrypt the frames
> and broadcast them if the attacker uses a MAC address of another station
> that is properly associated!

> The reason is that ieee80211_rx_h_drop_unencrypted() drops unencrypted
> frames, but only if "sdata->drop_unencrypted" is set which never
> happens!

Hmm.. What happened to the original code that had (rx->key ||
rx->sdata->drop_unencrypted)?

The drop_unencrypted was originally designed as just an extra layer of
protection and it was not really needed in most configurations. There
might have been some odd corner cases where it was needed in
multi-SSID/BSSID case, but other than that, the rx->key part would have
taken care of this.

> The patch below is necessary for wpa_supplicant to be able to set the
> drop_unencrypted setting, but I'm not convinced it actually needs to be
> able to set it. Can't the kernel just do a sane default?

I thought it did.. By the use of rx->key here, not by use of
drop_unencrypted. Anyway, like I said, drop_unencrypted is an extra
layer of security, so having possibility of using it may be nice safety
net should something else go wrong in the RX logic.

> Considering the AP case, on the other hand, hostapd will need to be able
> to set the setting since we don't actually look into the beacon it tells
> us to transmit. But hostapd on the other hand doesn't even invoke the
> iwauth ioctl! I have to admit to being rather confused.

The Devicescape version of hostapd did.. I do not remember why this was
not merged, but I would assume it was just something that I never got to
and since it was using a private ioctl for setting the parameter that
option already disappeared. Sure, it would be reasonable to add support
for it now that the parameter is available with WE-18.

-- 
Jouni Malinen                                            PGP id EFC895FA
