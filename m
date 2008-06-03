Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:25489 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbYFCUC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 16:02:28 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1414465wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 13:02:27 -0700 (PDT)
Message-ID: <69e28c910806031302s91fdcd8wcd2827baa64b04b@mail.gmail.com> (sfid-20080603_220231_709653_A6C76F2E)
Date: Tue, 3 Jun 2008 22:02:27 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH 05/11] rt2x00: Don't kill guardian_urb when it wasn't created
Cc: "John W. Linville" <linville@tuxdriver.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200806032029.51057.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200806032024.52931.IvDoorn@gmail.com>
	 <200806032026.40506.IvDoorn@gmail.com>
	 <200806032027.06094.IvDoorn@gmail.com>
	 <200806032029.51057.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 3, 2008 at 8:29 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote=
:
> This fixes a "BUG: unable to handle kernel paging request"
> bug in rt73usb which was caused by killing the guardian_urb
> while it had never been allocated for rt73usb.
>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00usb.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wi=
reless/rt2x00/rt2x00usb.c
> index 52d12fd..36a087a 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -394,8 +394,11 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *=
rt2x00dev)
>        }
>
>        /*
> -        * Kill guardian urb.
> +        * Kill guardian urb (if required by driver).
>         */
> +       if (!test_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags)=
)
> +               return;
> +
>        for (i =3D 0; i < rt2x00dev->bcn->limit; i++) {
>                bcn_priv =3D rt2x00dev->bcn->entries[i].priv_data;
>                if (bcn_priv->guardian_urb)
> --
> 1.5.5.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
