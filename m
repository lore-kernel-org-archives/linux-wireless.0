Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:37532 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbZGSRUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 13:20:12 -0400
Received: by bwz28 with SMTP id 28so1581853bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2009 10:20:10 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] handle broken V4 fw region code shift
Date: Sun, 19 Jul 2009 19:19:51 +0200
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org
References: <200907162032.00777.marek.vasut@gmail.com> <43e72e890907161311m99e454v7daf9c58a340ae77@mail.gmail.com> <200907162229.41697.marek.vasut@gmail.com>
In-Reply-To: <200907162229.41697.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200907191919.51998.marek.vasut@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dne Čt 16. července 2009 22:29:41 Marek Vasut napsal(a):
> Dne Čt 16. července 2009 22:11:26 Luis R. Rodriguez napsal(a):
> > On Thu, Jul 16, 2009 at 11:32 AM, Marek Vasut<marek.vasut@gmail.com> 
wrote:
> > > Dne Čt 16. července 2009 20:21:30 Dan Williams napsal(a):
> > >> On Thu, 2009-07-16 at 19:40 +0200, Marek Vasut wrote:
> > >> > Hi,
> > >> >
> > >> > please consider applying/commenting on the following trivial fix.
> > >> > The description is in the patch. Thanks.
> > >>
> > >> Please CC to linux-wireless@vger.kernel and I'll ack there so Linville
> > >> will pick it up.  Any patch that you consider appropriate for actual
> > >> inclusion at the time you send it is better on linux-wireless.
> > >> libertas-dev should really be only for hardware/firmware discussions
> > >> and not-yet-ready patches.
> > >>
> > >> Thanks!
> > >> Dan
> > >
> > > Done, thanks! :-)
> > > (sorry for sending it twice, I missed the address was incomplete in
> > > your mail)
> >
> > Please resend inline
> >
> >  Luis
>
> Here you go

Any update ?
>
> From d69e6db9d424e40dade6bbf107dbab2ff4d692d5 Mon Sep 17 00:00:00 2001
> From: Marek Vasut <marek.vasut@gmail.com>
> Date: Thu, 16 Jul 2009 19:19:53 +0200
> Subject: [PATCH] Fix problem with broken V4 firmware on CF8381
>
> Firmware V4 on CF8381 reports region code shifted by 1 byte to left.
> The following patch checks for this and handles it properly.
>
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> ---
>  drivers/net/wireless/libertas/cmd.c  |    8 +++++++-
>  drivers/net/wireless/libertas/defs.h |    2 ++
>  2 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/libertas/cmd.c
> b/drivers/net/wireless/libertas/cmd.c
> index 01db705..445288d 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -135,8 +135,14 @@ int lbs_update_hw_spec(struct lbs_private *priv)
>         /* Clamp region code to 8-bit since FW spec indicates that it
> should * only ever be 8-bit, even though the field size is 16-bit.  Some
> firmware
>          * returns non-zero high 8 bits here.
> +        *
> +        * Firmware version 4.0.102 used in CF8381 has region code shifted.
> We +        * need to check for this problem and handle it properly.
>          */
> -       priv->regioncode = le16_to_cpu(cmd.regioncode) & 0xFF;
> +       if (MRVL_FW_MAJOR_REV(priv->fwrelease) == MRVL_FW_V4)
> +               priv->regioncode = (le16_to_cpu(cmd.regioncode) >> 8) &
> 0xFF; +       else
> +               priv->regioncode = le16_to_cpu(cmd.regioncode) & 0xFF;
>
>         for (i = 0; i < MRVDRV_MAX_REGION_CODE; i++) {
>                 /* use the region code to search for the index */
> diff --git a/drivers/net/wireless/libertas/defs.h
> b/drivers/net/wireless/libertas/defs.h
> index 48da157..72f3479 100644
> --- a/drivers/net/wireless/libertas/defs.h
> +++ b/drivers/net/wireless/libertas/defs.h
> @@ -234,6 +234,8 @@ static inline void lbs_deb_hex(unsigned int grp, const
> char *prompt, u8 *buf, in
>  /** Mesh enable bit in FW capability */
>  #define MESH_CAPINFO_ENABLE_MASK                       (1<<16)
>
> +/** FW definition from Marvell v4 */
> +#define MRVL_FW_V4                                     (0x04)
>  /** FW definition from Marvell v5 */
>  #define MRVL_FW_V5                                     (0x05)
>  /** FW definition from Marvell v10 */
> --
> 1.6.3.3

