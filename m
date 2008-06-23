Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:11355 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYFWMxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 08:53:34 -0400
Received: by py-out-1112.google.com with SMTP id p76so963467pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2008 05:53:33 -0700 (PDT)
Message-ID: <69e28c910806230553k6c878126s1f8ee15770bada57@mail.gmail.com> (sfid-20080623_145339_050579_A0A9F9E6)
Date: Mon, 23 Jun 2008 14:53:32 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: [BUG] Two bugs in monitor mode, iwl3945
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <485F687C.1050407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <485F687C.1050407@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 23, 2008 at 11:10 AM, Maxim Levitsky
<maximlevitsky@gmail.com> wrote:
> I noticed two bugs:
>
> 1) Monitor mode hangs the system randomly, and what is interesting th=
at this
> bug disappears if I patch the driver with packet injection patch from=
 G=E1bor
> Stefanik.
> I noticed this bug, after I removed his patch to see if it caused som=
e
> problems.
> Always reproducible, usually hangs just after airodump launch.

Something tries to transmit on the monitor interface, which is
impossible without the injection patch. However, the method used for
preventing TX in monitor mode is incorrect (it just drops the packet
silently, without notifying mac80211, which, in the absence of an ACK,
tries to retransmit the packet - an obvious infinite loop). This is
what causes the freeze. (Do you have networkmanager running? That
often tends to interfere with monitor interfaces.)

>
> 2) If I enable monitor mode regardless of injection patch, the scanni=
ng
> results got garbaged,
> iwlist scan reports > 100 quality on most APs, or 0% quality on my ro=
uter,
> shows extremely low and hi power levels, like
> -127dBm or 160 dBm, and those levels change rapidly.
> This why I removed the injection patch, I suspected it, but this bug =
appears
> to be not related to it.

Does this also happen if you create an extra managed or AP (AP
requires a patch to mac80211) interface, or is it specific to monitor
interfaces?

>
>
> Injection patch from G=E1bor Stefanik <netrolller.3d@gmail.com> attac=
hed
> (I modified the patch to apply on latest wireless -git, but patch is =
the
> same)
>
> I use iw to create new monitor interface and use it.
>
> Best regards,
>        Maxim Levitsky
>



--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
