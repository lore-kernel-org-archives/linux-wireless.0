Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:51793 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbYETX3h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 19:29:37 -0400
Subject: Re: [PATCH] b43: Upload both beacon templates on initial load
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200805201216.29134.mb@bu3sch.de>
References: <200805201216.29134.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 20 May 2008 19:29:35 -0400
Message-Id: <1211326175.21859.10.camel@dv> (sfid-20080521_012946_108767_E99FC0F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-20 at 12:16 +0200, Michael Buesch wrote:
> This updates the beacon template code to upload both templates,
> if we never uploaded one before.
=2E..
> +	bool beacon_templates_virgin; /* Never wrote the templates? */
=2E..
> @@ -4164,12 +4191,15 @@ static int b43_op_start(struct ieee80211
>  	 * and mac80211 reconfiguring it. */
>  	memset(wl->bssid, 0, ETH_ALEN);
>  	memset(wl->mac_addr, 0, ETH_ALEN);
>  	wl->filter_flags =3D 0;
>  	wl->radiotap_enabled =3D 0;
>  	b43_qos_clear(wl);
> +	wl->beacon0_uploaded =3D 0;
> +	wl->beacon1_uploaded =3D 0;
> +	wl->beacon_templates_virgin =3D 1;

=EF=BB=BFJust a hint.  You may want to revert the logic, so that you st=
art with
0 and set the variable to 1 as something substantial happens.  You can
introduce more states later if required, or count the upload events.

This way, it would be beacon_templates_loaded or
beacon_templates_touched.

The human brain is better at understanding positive meanings.  "virgin"
means that something did _not_ happen, and it's not like it's very
valuable per se, at least for beacon templates :-)

I worked on code full of things like HAVE_NO_CURSES_H and DISABLE_COLOR=
,
and it wasn't fun.

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
