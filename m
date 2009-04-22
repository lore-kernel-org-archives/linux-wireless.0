Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:57530 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbZDVRI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 13:08:58 -0400
Date: Wed, 22 Apr 2009 20:08:52 +0300
From: Jouni Malinen <j@w1.fi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Using wpa_supplicant in D-Bus mode with nl80211 driver
Message-ID: <20090422170852.GA7298@jm.kir.nu> (sfid-20090422_190902_787643_D1BB9D20)
References: <1240419177.12282.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1240419177.12282.3.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 22, 2009 at 05:52:57PM +0100, Marcel Holtmann wrote:

> I am trying to use wpa_supplicant in D-Bus mode with the nl80211 driver
> instead of WEXT. I don't seem to be able to control the from the command
> line and the -D option doesn't take.

I would assume you are doing this with NM. You could either change it to
register the interface (this is not from -D option, but from the D-Bus
message) with the nl80211 driver or try to build wpa_supplicant without
WEXT support (which would make the nl80211 wrapper the default one). I
don't think either of these are yet acceptable as a generic solution,
but making NM request driver "nl80211,wext" could be a suitable first
step when moving to wpa_supplicant 0.7.x (this makes wpa_supplicant
first try with nl80211 and if needed, fall back to WEXT).

> Can we fix this somehow? I really wanna get rid of using WEXT.

There still one remaining WEXT operation even with driver_nl80211.c in
wpa_supplicant, so we are not yet there, but there is work going on in
getting that added to nl80211 after which point -Dnl80211 (or
-Dnl80211,wext for more likely distro use) should allow this goal to be
met.

-- 
Jouni Malinen                                            PGP id EFC895FA
