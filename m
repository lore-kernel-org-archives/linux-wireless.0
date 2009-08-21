Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45258 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755459AbZHUXgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 19:36:18 -0400
Message-ID: <4A8F2F71.1010100@gmx.de>
Date: Sat, 22 Aug 2009 01:36:17 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFT] ar9170: use eeprom's frequency calibration values
References: <200908212252.41053.chunkeey@web.de>
In-Reply-To: <200908212252.41053.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/21/2009 10:52 PM, Christian Lamparter wrote:
> This patch adds some more bits from the vendor driver, which
> are supposed to help users with the one-stage/openfw firmwares.

The otus driver sets phy registers 672-703 only for the one-stage firmware -
hal/hpmain.c, line 3445:

        #ifndef ZM_OTUS_LINUX_PHASE_2
        reg_write(regAddr + i, val);  /* CR672 */
        #endif

Are you sure it doesn't hurt with the two-stage firmware?

Jörg
