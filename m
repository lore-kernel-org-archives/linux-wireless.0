Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-22.dex002.intermedia.net ([64.78.21.93]:50164 "EHLO
	dhost002-22.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992963AbXDDPiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2007 11:38:21 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Wed, 4 Apr 2007 08:38:14 -0700
To: Pavel Roskin <proski@gnu.org>
Cc: Dan Williams <dcbw@redhat.com>, Jan Dittmer <jdi@l4x.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Orinoco, mac80211 and wpa2
Message-ID: <20070404153814.GC8229@devicescape.com>
References: <4613A4A9.1060902@l4x.org> <1175697737.2656.3.camel@localhost.localdomain> <1175700158.5322.9.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1175700158.5322.9.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 04, 2007 at 11:22:38AM -0400, Pavel Roskin wrote:

> Porting Orinoco driver to mac80211 would be a fun project, and I don't
> think it's impossible.  It should be possible to dumb down the card,
> turn off scanning and authentication and send raw packets.
> 
> I'm not sure if the firmware support would be needed, but Lucent 9.xx
> firmware has WPA support.  Since it's RAM loadable, the firmware loading
> will need to be added.  Fortunately, the implementation already exists
> in the now defunct HermesAP project.

If Orinoco cards added WPA support in the same (or similar) way as
Intersil Prism2/2.5/3, firmware support is certainly needed. In case of
Intersil, it was needed for adding WPA/RSN IE into (Re)AssocReq and to
receive Beacon/ProbeResp frames (to get WPA/RSN IE from AP). In
addition, the firmware must allow host-based encryption/decryption to be
enabled.

-- 
Jouni Malinen                                            PGP id EFC895FA
