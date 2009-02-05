Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:37347 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754AbZBEJHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 04:07:05 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: at76_usb development
Date: Thu, 5 Feb 2009 10:08:02 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jason Andryuk <jandryuk@gmail.com>, gregkh@suse.de,
	linux-wireless@vger.kernel.org, milan.plzik@gmail.com
References: <c4d76b3b0902032005m3847235cu42f963ca6ad796af@mail.gmail.com> <20090204144317.GA3845@tuxdriver.com> <da94abde0902040748l6194cdd3i7044c839f3110e5a@mail.gmail.com>
In-Reply-To: <da94abde0902040748l6194cdd3i7044c839f3110e5a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200902051008.04061.oliver@neukum.org> (sfid-20090205_100722_027673_A50EBBA0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Wednesday 04 February 2009 16:48:11 schrieb Kalle Valo:
> > AFAIK you should be sending patches to Greg against the version in
> > drivers/staging. =A0Kalle may want to be copied.
>=20
> Yes, please cc also me. I try to keep up-to-date what's happening wit=
h
> at76-usb so that the same fixes will be fixed in at76c50x-usb as well=
=2E

Here is what I found with at76-usb as it is in the current kernel:

 static int at76_wait_completion(struct at76_priv *priv, int cmd)
 {
        int status =3D 0;

        unsigned long timeout =3D jiffies + CMD_COMPLETION_TIMEOUT;

        do {

This can go wrong in a preemptible kernel. You have no guarantee the fu=
ll
timeout is granted.

@@ -1631,7 +1633,7 @@ static void at76_rx_tasklet(unsigned long param)
        buf =3D (struct at76_rx_buffer *)priv->rx_skb->data;

        if (urb->status !=3D 0) {
-               if (urb->status !=3D -ENOENT && urb->status !=3D -ECONN=
RESET)
+               if (urb->status !=3D -ENOENT && urb->status !=3D -ECONN=
RESET && urb->status !=3D -ESHUTDOWN)

Should also check for ESHUTDOWN, also in at76_mac80211_tx_callback()

	Regards
		Oliver
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
