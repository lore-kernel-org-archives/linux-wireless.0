Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:57961 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbYEMM2D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 08:28:03 -0400
Date: Tue, 13 May 2008 15:27:18 +0300
From: Jouni Malinen <j@w1.fi>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
Subject: Re: 11n + wpa_supplicant
Message-ID: <20080513122718.GA6309@jm.kir.nu> (sfid-20080513_142808_443690_FD2B19E3)
References: <8704f27d0805130118p6f597743sebed5a2cdb6d59cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8704f27d0805130118p6f597743sebed5a2cdb6d59cb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2008 at 11:18:29AM +0300, Emmanuel Grumbach wrote:

> the spec of 11n makes the support on AES mandatory, but not TKIP.
> Meaning that a NIC can support WPA2 and 11n separately, but not TKIP
> in 11n. The RC4 encryption machine has a delay that makes difficult to
> encrypt in TKIP (or WEP) in 11n rates. Intel's 11n are such NICs, 11n
> + TKIP/WEP is not supported.

This is not just a hardware support question; 11n explicitly disallows
use of TKIP between HT STAs and this needs to be enforced somewhere.

> The problem here is that the association (which can be 11n or not)
> occurs before the 4-way handshake. Let's say that I have an AP that
> publishes only TKIP in its WPA IE and 11n IE, I can understand that
> there is no way I should do 11n association. But what happens with an
> AP that publishes TKIP + AES in its RSN IE and 11n IE ? I could
> associate in 11n, but then wpa_supplicant might be configured to
> associate in TKIP (although the AP support AES), and I would be in an
> unsupported mode.

In most cases, the pairwise cipher is selected during association, not
during 4-way handshake. Consequently, the driver/firmware should refuse
to send an (Re)Association Request that requests TKIP as the pairwise
cipher when using .11n.

In the corner case (which I don't think I have even implemented yet in
wpa_supplicant..) the AP/Authenticator could request the STA to use
another pairwise cipher if security policy for that specific STA does
not allow the pairwise cipher suite that the STA tried to select in
(re)association request. In this particular case (should it ever be
implemented), it could be useful for wpa_supplicant to know that .11n is
used. However, no sane security policy would require TKIP as the
pairwise cipher in such a case, so I don't think this is really going to
ever happen in real networks and any kind of failure to use the network
is suitable end result for such an attempt..

> One solution would be to make wpa_supplicant understand what 11n is,
> but that's not it's job.
> Another solution would be to make wpa_supplicant tell me that it
> intends to use TKIP before asking me to associate.

The exact mechanism depends on whether ap_scan=1 or ap_scan=2 is being
used, i.e., whether wpa_supplicant is responsible for selecting a BSS
from scan results or not.

In ap_scan=1, I would say that it would be useful for wpa_supplicant to
know whether the BSS (and the local wlan driver/hardware for that
matter!) supports .11n. If the scan results indicate this in some
reliable way (e.g., all IEs are delivered to wpa_supplicant), the AP's
support for 11n can be figured out. The local side support would need to
be added, e.g., to driver capabilities reporting.

In ap_scaqn=2, wpa_supplicant requests the driver to select a BSS based
on configuration (SSID, security policy, including a specific cipher
suite), i.e., the driver would be told about TKIP use before
association and the driver would be responsible for not trying to use
11n in that case. The corner case of AP/Authenticator requesting another
pairwise cipher would still be possible here, but not really something
that I would consider a real problem that needs to be solved.

-- 
Jouni Malinen                                            PGP id EFC895FA
