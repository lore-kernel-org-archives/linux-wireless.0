Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:44351 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756571Ab2EGN73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 09:59:29 -0400
Date: Mon, 7 May 2012 16:59:17 +0300
From: Jouni Malinen <j@w1.fi>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: hostap@lists.shmoo.com,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] [rt2800pci (AP) - ath9k] 802.11w: broken
 aggregation handling?
Message-ID: <20120507135917.GB19222@w1.fi> (sfid-20120507_155932_768233_6A1EFD9F)
References: <4FA75983.9040003@01019freenet.de>
 <201205070702.q4772uem002960@mail.maya.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201205070702.q4772uem002960@mail.maya.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 07, 2012 at 09:02:58AM +0200, Andreas Hartmann wrote:
> - Why is the authentication started here at all, regardless of an error?

I don't think that hostapd would verify driver capabilities for 802.11w
at the moment, so it does not know that it should have rejected the
configuration here.. Same for wpa_supplicant and station mode, I'd
guess.

> - Why does TLS succeed? (802.11g is "working"). 

If you are using SHA-1 -based AKM, the initial association, 4-way
handshake, and data TX/RX are almost identical..

> - Why does set_key fail?

The driver did not support configuration of IGTK for BIP (i.e., key to
protect group-addressed robust management frames).

-- 
Jouni Malinen                                            PGP id EFC895FA
