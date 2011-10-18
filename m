Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46500 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab1JRGy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 02:54:58 -0400
Subject: Re: [patch] rndis_wlan: add range check in del_key()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20111018064729.GQ27732@elgon.mountain> (sfid-20111018_084803_556321_DCB3993A)
References: <20111018064729.GQ27732@elgon.mountain>
	 (sfid-20111018_084803_556321_DCB3993A)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 08:54:47 +0200
Message-ID: <1318920887.3958.0.camel@jlt3.sipsolutions.net> (sfid-20111018_085502_908939_5676BADE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-18 at 09:47 +0300, Dan Carpenter wrote:
> Wifi drivers can have up to 6 keys but the rndis_wlan only has 4 so
> it needs to have its own checks to make sure we don't go out of
> bounds.  The add_key() function already checks but I added some
> checks to del_key() and set_default_key().

Semantically, that shouldn't be possible unless it advertises support
for WLAN_CIPHER_SUITE_AES_CMAC. Is there a bug in those checks?

The checks don't hurt, obviously.

johannes

