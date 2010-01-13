Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57537 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab0AMNbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 08:31:41 -0500
Received: by yxe17 with SMTP id 17so22526301yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2010 05:31:41 -0800 (PST)
Message-ID: <4B4DCB39.7030801@lwfinger.net>
Date: Wed, 13 Jan 2010 07:31:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: Re: [PATCH 3/3] b43: N-PHY: add RX IQ calculation for rev < 3
References: <op.u6fp66hl9lhzdc@linux-g0th.site>
In-Reply-To: <op.u6fp66hl9lhzdc@linux-g0th.site>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2010 01:38 PM, Rafał Miłecki wrote:
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> 
> Uh, bigger one. This patch causes false warning:
> drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_rev2_cal_rx_iq’:
> drivers/net/wireless/b43/phy_n.c:627: warning: large integer implicitly truncated to unsigned type
> 
> That's for:
> b43_phy_maskset(dev, B43_NPHY_RFSEQCA, ~B43_NPHY_RFSEQCA_RXDIS, ((1 - i) << B43_NPHY_RFSEQCA_RXDIS_SHIFT));
> 
> It's inside loop i=0,1. I tried casting i on (u8) but this didn't help. Can we leave this? Or can sb share some trick to avoid this warning?

It is ~B43_NPHY_RFSEQCA_RXDIS, not i, that causes the warning. Change the
statement to

b43_phy_maskset(dev, B43_NPHY_RFSEQCA, (u16)(~B43_NPHY_RFSEQCA_RXDIS),
               ((1 - i) << B43_NPHY_RFSEQCA_RXDIS_SHIFT));

Larry


