Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38980 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2AQAqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 19:46:45 -0500
Received: by iagf6 with SMTP id f6so3356599iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2012 16:46:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1326723806-15960-3-git-send-email-coelho@ti.com>
References: <1326723806-15960-1-git-send-email-coelho@ti.com> <1326723806-15960-3-git-send-email-coelho@ti.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 17 Jan 2012 11:46:24 +1100
Message-ID: <CAGRGNgVfJeEji1EtU5u_GfHN9sgKGEkDRg9ko7JdkMqUUFvFyw@mail.gmail.com> (sfid-20120117_014709_822311_4E12C5BB)
Subject: Re: [PATCH 2/2] wl12xx: add operation to retrieve the MAC address
 from Fuse ROM
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luciano,

On Tue, Jan 17, 2012 at 01:23, Luciano Coelho <coelho@ti.com> wrote:
> Add a testmode command to retrieve the MAC address that is stored in
> the Fuse ROM in newer PGs.  In old PGs this operation is not
> supported.
>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>  drivers/net/wireless/wl12xx/boot.c     |    3 +-
>  drivers/net/wireless/wl12xx/boot.h     |   10 ----
>  drivers/net/wireless/wl12xx/reg.h      |   15 ++++++
>  drivers/net/wireless/wl12xx/testmode.c |   87 ++++++++++++++++++++++++++++++++
>  4 files changed, 104 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/testmode.c b/drivers/net/wireless/wl12xx/testmode.c
> index 25093c0..613e0b3 100644
> --- a/drivers/net/wireless/wl12xx/testmode.c
> +++ b/drivers/net/wireless/wl12xx/testmode.c
> @@ -264,6 +266,89 @@ static int wl1271_tm_cmd_recover(struct wl1271 *wl, struct nlattr *tb[])
>        return 0;
>  }
>
> +static bool wl12xx_tm_mac_in_fuse(struct wl1271 *wl)
> +{
> +       bool supported = false;
> +       u8 major, minor;
> +
> +       if (wl->chip.id == CHIP_ID_1283_PG20) {
> +               major = (wl->hw_pg_ver & WL128X_PG_MAJOR_VER_MASK) >>
> +                       WL128X_PG_MAJOR_VER_OFFSET;
> +               minor = (wl->hw_pg_ver & WL128X_PG_MINOR_VER_MASK) >>
> +                       WL128X_PG_MINOR_VER_OFFSET;
> +
> +               /* in wl128x we have the MAC address if the PG is >= (2, 1) */
> +               if (major > 2 || (major == 2 && minor >= 1))
> +                       supported = true;
> +       } else {
> +               major = (wl->hw_pg_ver & WL127X_PG_MAJOR_VER_MASK) >>
> +                       WL127X_PG_MAJOR_VER_OFFSET;
> +               minor = (wl->hw_pg_ver & WL127X_PG_MINOR_VER_MASK) >>
> +                       WL127X_PG_MINOR_VER_OFFSET;
> +
> +               /* in wl127x we have the MAC address if the PG is >= (3, 1) */
> +               if (major == 3 && minor >= 1)

Is this test correct? Do only major == 3 PGs support this command?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
