Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:44347 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756171Ab2EGNzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 09:55:50 -0400
Date: Mon, 7 May 2012 16:55:33 +0300
From: Jouni Malinen <j@w1.fi>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
	hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [rt2x00-users] [rt2800pci (AP) - ath9k] 802.11w: broken
 aggregation handling?
Message-ID: <20120507135533.GA19222@w1.fi> (sfid-20120507_155555_460543_47BC8F10)
References: <4FA75983.9040003@01019freenet.de>
 <201205070702.q4772uem002960@mail.maya.org>
 <4FA7A13D.6020405@01019freenet.de>
 <CAGXE3d-pwTraDvC6yOKt7hHPTXL5LtaHFovD_SFmaPgajJbS9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d-pwTraDvC6yOKt7hHPTXL5LtaHFovD_SFmaPgajJbS9g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 07, 2012 at 01:04:29PM +0200, Helmut Schaa wrote:
> I'm fine with enabling MFP in rt2800pci but I don't know enough about the
> necessary requirements.
> 
> Jouni, are there any special requirements for MFP?

The main requirements:
- support CCMP encryption/decryption of unicast robust management frames
  (subset of Action frames, Deauthentication, Disassociation)
- support BIP and IGTK configuration for group addressed robust
  management frames (TX-only for AP, RX-only for STA); I would expect
  most drivers to use software implementation on the host CPU for this
  taken into account that there is only very limited use of group
  addressed robust management frames
- SA Query mechanism (mac80211-based drivers get this pretty much
  automatically from hostapd for AP mode and mac80211 for STA)
- ability to configure RSN capabilities into RSN element and to
  provide the received element to user space (again, most mac80211-based
  drivers should work as-is)

-- 
Jouni Malinen                                            PGP id EFC895FA
