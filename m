Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47338 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab0AJWil convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 17:38:41 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 3/6] b43: N-PHY: add RSSI calculation for PHY rev < 3
Date: Sun, 10 Jan 2010 23:38:26 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <op.u6b70wtk9lhzdc@linux-g0th.site>
In-Reply-To: <op.u6b70wtk9lhzdc@linux-g0th.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001102338.28721.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 January 2010 23:13:34 Rafał Miłecki wrote:
> +	s32 results_min[4];
> +	u8 vcm_final[4];
> +	s32 results[4][4];
> +	s32 miniq[4][2];
> +	memset(results_min, 0, sizeof(s32) * 4);
> +	memset(vcm_final, 0, sizeof(u8) * 4);
> +	memset(results, 0, sizeof(s32) * 4 * 4);
> +	memset(miniq, 0, sizeof(s32) * 4 * 2);

Just initialize the variables to zero instead of doing a memset:

+	s32 results_min[4] = { 0, };
+	u8 vcm_final[4] = { 0, };
+	s32 results[4][4] = { 0, };
+	s32 miniq[4][2] = { 0, };

> +	b43_radio_maskset(dev, B2055_C1_PD_RSSIMISC, 0xF8, 0);
> +	b43_radio_maskset(dev, B2055_C2_PD_RSSIMISC, 0xF8, 0);

If you don't set anything, you can use
b43_radio_mask();

-- 
Greetings, Michael.
