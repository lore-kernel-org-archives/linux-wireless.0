Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:33782 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbYISSJw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 14:09:52 -0400
Received: by ug-out-1314.google.com with SMTP id k3so1043962ugf.37
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 11:09:45 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] Resend: [PATCH] rt2x00: Consolidate definition of CSR_OFFSET
Date: Fri, 19 Sep 2008 20:09:42 +0200
Cc: John Daiker <daikerjohn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <48D2F0C6.9080409@gmail.com>
In-Reply-To: <48D2F0C6.9080409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-Id: <200809192009.42870.IvDoorn@gmail.com> (sfid-20080919_200955_903919_1B3E17D1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 19 September 2008, John Daiker wrote:
> Resend: Premature send to Linville only... this version copies=20
> linux-wireless and rt2400-devel.

I was in the BCC list, but here goes my official reply. :)

> This consolidates the definition of CSR_OFFSET when=20
> CONFIG_RT2X00_LIB_DEBUG is also set.
> The original definition appeared in 5 files, but was moved to a commo=
n
> .h file instead.
>=20
> Compile-tested only, as I don't have any rt2x00 HW in a working machi=
ne.

NACK
This patch does more then consolidating =A0the CRS_OFFSET definition si=
nce it
changes several lines for adding/removing whitespaces as well.
It completely breaks rt2500usb, and I really dislike using define
names in rt2x00.h
while the define itself is declared in the register headers only (and
is thus not really
visible in rt2x00.h, even though the compiler would accept it and it
would work as
expected).

Ivo

> Signed-off-by: John Daiker <daikerjohn@gmail.com>
>=20
> ---
>=20
>=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
