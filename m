Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:51564 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbXJ1Svb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 14:51:31 -0400
Date: Sun, 28 Oct 2007 11:49:59 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, Zhu Yi <yi.zhu@intel.com>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep
	network
Message-ID: <20071028184959.GN4936@jm.kir.nu> (sfid-20071028_185135_192281_E40CACD0)
References: <1193148453.8648.20.camel@localhost.localdomain> <1193161034.7733.38.camel@johannes.berg> <1193238423.2557.41.camel@localhost.localdomain> <1193318969.6092.19.camel@johannes.berg> <1193320140.5542.11.camel@localhost.localdomain> <1193320661.14136.10.camel@johannes.berg> <1193548708.7779.10.camel@localhost.localdomain> <1193567294.3966.6.camel@johannes.berg> <20071028173610.GM4936@jm.kir.nu> <1193594085.5197.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1193594085.5197.20.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 28, 2007 at 06:54:45PM +0100, Johannes Berg wrote:

> Hmm. Is there a good explanation of all these values? I still haven't
> understood what all the IW_AUTH_* means. I'm fairly sure though that
> this particular instance hasn't changed in terms of behaviour since the
> original devicescape code (not that this means it's bug-free, of course)

The only documentation for these that I'm aware of is linux/wireless.h.
The original code was not doing this right either (it was implemented
before WE-18, if I remember correctly). The odd part is that I'm sure
this used to work long time ago..

IW_AUTH_* values were designed to provide mechanism for notifying the
driver on number of parameters related to authentication (and
association, in practice). WPA_VERSION, CIPHER_PAIRWISE, CIPHER_GROUP,
KEY_MGMT, 80211_AUTH_ALG, WPA_ENABLED, PRIVACY_INVOKED are parameters
describing the enabled security configuration for associations. Number
of these parameters are bitfields and can include multiple enabled modes
(e.g., both TKIP and CCMP could be allowed as the group cipher). I would
assume most of these parameters be obvious from the field and bitfield
value names.

PRIVACY_INVOKED is describing whether any sort of encryption is to be
used (boolean). If mixed-cell mode (for which there does not seem to be
configuration options in WE) is enabled, any privacy flag combination is
allowed. If mixed-cell is disabled, the PRIVACY_INVOKED has to match
with the Privacy flag advertized in the Beacon/ProbeRsp frames.

TKIP_COUNTERMEASURES is used to notify the driver of a two Michael MIC
failures within 60 seconds to trigger TKIP countermeasures (i.e.,
disable all TKIP encryption/decryption and prevent new associations that
would use TKIP). For client mode, it is also possible that this is
implemented in the driver, so some drivers do not need this. Anyway, for
AP mode, the notification is needed since the driver would not get
notifications of MIC errors detected at clients (which are reported to
the AP in EAPOL-Key frames).

DROP_UNENCRYPTED is a flag for configuring whether any unencrypted
non-EAPOL data frames are allowed through. There is a MIB variable for
this for WEP, but this is of limited use nowadays. I would expect all
WPA configuration to prevent unencrypted data frames (apart from initial
EAPOL frames) anyway.

RX_UNENCRYPTED_EAPOL is used to configure whether unencrypted EAPOL
frames are to be received when pairwise keys are set. This is needed for
IEEE 802.1X (i.e., non-WPA) which never encrypted EAPOL frames. With
WPA, EAPOL frames are encrypted when pairwise keys are set and as such,
unencrypted EAPOL frames should be dropped after the pairwise keys are
configured.

ROAMING_CONTROL can be used to enable/disable roaming decision in the
driver/firmware. The original need for this came from the Prism2
firmware design that has a configuration option for indicating which
component is responsible for roaming (selecting a new BSS if the current
one is likely to end up getting out of range).

-- 
Jouni Malinen                                            PGP id EFC895FA
