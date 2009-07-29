Return-path: <netrolller.3d@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4a6fa3fe.kYeW+HADItDIXTLm%Larry.Finger@lwfinger.net>
References: <4a6fa3fe.kYeW+HADItDIXTLm%Larry.Finger@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 29 Jul 2009 14:43:36 +0200
Message-ID: <69e28c910907290543t7532bd07g2ffdc2a04973a6f8@mail.gmail.com>
Subject: Re: [PATCH] b43: Work around mac80211 race condition that may
	transmit one packet after queue is stopped
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2009 at 3:21 AM, Larry Finger<Larry.Finger@lwfinger.net> wr=
ote:
> As shown in http://thread.gmane.org/gmane.linux.kernel.wireless.general/3=
6497,
> mac80211 has a bug that allows a call to the TX routine after the queues =
have
> been stopped. This situation will only occur under extreme stress. Althou=
gh
> b43 does not crash when this condition occurs, it does generate a WARN_ON=
 and
> also logs a queue overrun message. This patch recognizes b43 is not at fa=
ult
> and logs a message only when the most verbose debugging mode is enabled. =
In
> the unlikely event that the queue is not stopped when the DMA queue becom=
es
> full, then a warning is issued.
>
> During testing of this patch with one output stream running repeated tcpp=
erf
> writes and a second running a flood ping, this routine was entered with
> the DMA ring stopped about once per hour. The condition where the DMA que=
ue is
> full but the ring has not been stopped has never been seen by me.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> John,
>
> This patch is 2.6.32 material.
>
> Larry
> ---
>
> Index: wireless-testing/drivers/net/wireless/b43/dma.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/b43/dma.c
> +++ wireless-testing/drivers/net/wireless/b43/dma.c
> @@ -1334,13 +1334,23 @@ int b43_dma_tx(struct b43_wldev *dev, st
> =A0 =A0 =A0 =A0spin_lock_irqsave(&ring->lock, flags);
>
> =A0 =A0 =A0 =A0B43_WARN_ON(!ring->tx);
> - =A0 =A0 =A0 /* Check if the queue was stopped in mac80211,
> - =A0 =A0 =A0 =A0* but we got called nevertheless.
> - =A0 =A0 =A0 =A0* That would be a mac80211 bug. */
> - =A0 =A0 =A0 B43_WARN_ON(ring->stopped);
> +
> + =A0 =A0 =A0 if (unlikely(ring->stopped)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We get here only because of a bug in mac=
80211.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Because of a race, one packet may be q=
ueued after
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the queue is stopped, thus we got call=
ed when we shouldn't.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* For now, just refuse the transmit. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (b43_debug(dev, B43_DBG_DMAVERBOSE))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 b43err(dev->wl, "Packet aft=
er queue stopped\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -ENOSPC;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_unlock;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0if (unlikely(free_slots(ring) < TX_SLOTS_PER_FRAME)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 b43warn(dev->wl, "DMA queue overflow\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If we get here, we have a real error wit=
h the queue
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* full, but queues not stopped. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 b43err(dev->wl, "DMA queue overflow\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(1);

Is this really the best way to do this? Any reason why not have the
WARN_ON in the if-condition?

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D -ENOSPC;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_unlock;
> =A0 =A0 =A0 =A0}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
