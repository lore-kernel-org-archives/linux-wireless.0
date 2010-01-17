Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51785 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab0AQWqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 17:46:07 -0500
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH 1/4] b43: N-PHY: add writing one element tables
Date: Sun, 17 Jan 2010 23:45:52 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
References: <op.u6o7s9rq9lhzdc@linux-g0th.site>
In-Reply-To: <op.u6o7s9rq9lhzdc@linux-g0th.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001172345.54110.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 17 January 2010 23:37:50 Rafał Miłecki wrote:
> @@ -1895,14 +1880,12 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
>   			b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDNNUM, tmp);
> 
>   			if (type == 1 || type == 3 || type == 4) {
> -				/* TODO: Read an N PHY Table with ID 15,
> -					length 1, offset 69 + core,
> -					width 16, and data pointer buffer */
> +				b43_ntab_write(dev, B43_NTAB16(15, 69 + core),
> +						buffer[0]);
>   				diq_start = buffer[0];
>   				buffer[0] = 0;
> -				/* TODO: Write an N PHY Table with ID 15,
> -					length 1, offset 69 + core, width 16,
> -					and data of 0 */
> +				b43_ntab_write(dev, B43_NTAB16(15, 69 + core),
> +						0);
>   			}
> 
>   			b43_phy_write(dev, B43_NPHY_IQLOCAL_CMD, cmd);

What is this supposed to do? It writes a value to a table entry and immediately
clobbers the entry with 0. This doesn't make any sense.

-- 
Greetings, Michael.
