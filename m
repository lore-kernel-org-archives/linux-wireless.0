Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54270 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214Ab0IOUb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 16:31:58 -0400
Date: Wed, 15 Sep 2010 10:31:33 -1000
From: Jouni Malinen <j@w1.fi>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC:  mac80211/ath9k:  allow scanning single channel if other
 VIF is associated.
Message-ID: <20100915203133.GA14541@jm.kir.nu>
References: <4C8EB03D.7070808@candelatech.com>
 <20100915030316.GB30253@jm.kir.nu>
 <4C9059DC.7060009@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C9059DC.7060009@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 14, 2010 at 10:30:04PM -0700, Ben Greear wrote:
> I think for the multi-VIF scenario, it should scan the single associated
> channel by default, but it would be nice to allow full scans on demand.
> (I would very much like to work with standard wpa_supplicant, but if hacking it
> is the only way, then I can attempt that.)

"Standard wpa_supplicant" needs to become more aware of multiple users
of the same radio, so it is certainly fine to add changes there. For
example, a mechanism for noticing that interfaces are sharing a radio
would be useful. With that, it should also be possible to share the BSS
table and scan results (and requests!) within wpa_supplicant.

Sure, mac80211 could potentially do some of merging and reusing, too,
but as far as wpa_supplicant use cases (including hostapd and AP mode in
Wi-Fi P2P like use cases here) are concerned, mac80211 changes may not
be needed for handling the scanning part.

-- 
Jouni Malinen                                            PGP id EFC895FA
