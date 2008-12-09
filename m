Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34998 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbYLIOpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 09:45:13 -0500
Date: Tue, 9 Dec 2008 09:35:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] p54usb: rewriting rx/tx routines to make use of
	usb_anchor's facilities
Message-ID: <20081209143530.GA3653@tuxdriver.com> (sfid-20081209_154518_789797_6B257830)
References: <200812091514.37634.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200812091514.37634.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 09, 2008 at 03:14:37PM +0100, Christian Lamparter wrote:
> Alan Stern found several flaws in p54usb's implementation and annotat=
ed:=20
> "usb_kill_urb() and similar routines do not expect an URB's completio=
n
> routine to deallocate it. =A0This is almost obvious -- if the URB is =
deallocated
> before the completion routine returns then there's no way for usb_kil=
l_urb
> to detect when the URB actually is complete."
>=20
> This patch addresses all known limitations in the old implementation =
and fixes
> khub's "use-after-freed" hang, when SLUB debug's poisoning option is =
enabled.
>=20
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> Cc: stable@kernel.org

That's a big patch for so late in the cycle.  Is there a bugzilla open =
for it?

John
--=20
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
