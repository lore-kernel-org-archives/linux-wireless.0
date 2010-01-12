Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47750 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab0ALWT1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 17:19:27 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 3/3] b43: N-PHY: add RX IQ calculation for rev < 3
Date: Tue, 12 Jan 2010 23:19:23 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <op.u6fp66hl9lhzdc@linux-g0th.site>
In-Reply-To: <op.u6fp66hl9lhzdc@linux-g0th.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001122319.23626.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 12 January 2010 20:38:56 Rafał Miłecki wrote:
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> 
> Uh, bigger one. This patch causes false warning:
> drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_rev2_cal_rx_iq’:
> drivers/net/wireless/b43/phy_n.c:627: warning: large integer implicitly truncated to unsigned type
> 
> That's for:

I think the warning is caused by

		b43_phy_maskset(dev, B43_NPHY_RFSEQCA,
	THIS>>>>>   ~B43_NPHY_RFSEQCA_RXDIS,
		((1 - i) << B43_NPHY_RFSEQCA_RXDIS_SHIFT));

Well, I think the warning is pretty much bogus, but I think it can be worked around
by doing
	(u16)~B43_NPHY_RFSEQCA_RXDIS


-- 
Greetings, Michael.
