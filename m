Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:59873 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbaIJLKo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 07:10:44 -0400
Date: Wed, 10 Sep 2014 14:10:40 +0300
From: Jouni Malinen <j@w1.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Re: P2P_DEVICE support in Android KitKat
Message-ID: <20140910111040.GA5269@w1.fi> (sfid-20140910_131047_726380_2C72D4FC)
References: <540FFDFD.2070302@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <540FFDFD.2070302@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 10, 2014 at 09:30:05AM +0200, Arend van Spriel wrote:
> I am running some tests on a haswell target with Android KitKat
> (3.10.20 kernel). In this configuration our brcmfmac driver is used
> with driver param 'p2p_device=1'. So we end up with wlan0 and
> p2p-dev-wlan0 interfaces (can blame myself for that). The
> configuration has a network configured, but I did not expect
> wpa_supplicant to start association using the p2p device interface.
> The wlan0 interface is already connected to the AP. How can I fix
> this to assure p2p-dev-wlan0 is only used for p2p management
> scenarios.

Hmm.. Can you please show the wpa_supplicant command line that is used
here and describe how that network block gets configured for the
p2p-dev-wlan0 "interface"? I would have expected that there would never
be a configuration with an enabled network block being passed for the
P2P management interface.. Internally, wpa_supplicant should not add
such for P2P groups, but I don't think there is any filtering on
configuration if something is externally trying to make wpa_supplicant
use that management interface for a station mode connection.

-- 
Jouni Malinen                                            PGP id EFC895FA
