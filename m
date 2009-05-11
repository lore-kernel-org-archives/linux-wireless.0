Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54966 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751388AbZEKKtW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 06:49:22 -0400
Message-ID: <4A0802B0.9070206@gmx.de>
Date: Mon, 11 May 2009 12:49:20 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Christian Lamparter <chunkeey@web.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: ath/regd.c: regdomain 0x8000 fails to retrieve a regulatory domain
 pair
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Plugging in a WNDA3100 (ar9170usb) I get the error

ath: No regulatory domain pair found, cannot continue

Seems like the EEPROM of the stick initializes regulatory.current_rd 
to 0x8000, current_rd_ext to 0. Is this a valid setting?

Looked into ath/regd.c, ath_regd_init():

ath_get_regpair(regdmn)

is called with regdmn == 0x8000 and returns NULL.

Shall that regdmn value be dealt with by

         if (reg->country_code == CTRY_DEFAULT &&
             regdmn == CTRY_DEFAULT)
                 reg->country_code = CTRY_UNITED_STATES;
?

wireless-testing is git v2.6.30-rc4-22735-gbd48c47, I run 
compat-wireless with a 2.6.29.2 kernel.
