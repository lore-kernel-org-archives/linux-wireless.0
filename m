Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:36308 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab3BQN61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2013 08:58:27 -0500
Received: by mail-bk0-f52.google.com with SMTP id jk13so2167084bkc.11
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2013 05:58:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361042551-15598-1-git-send-email-thomas@cozybit.com>
References: <1361042551-15598-1-git-send-email-thomas@cozybit.com>
Date: Sun, 17 Feb 2013 21:58:24 +0800
Message-ID: <CAEFj985iOoNWK-6-D7A_KbSm9kc8dL4CTyCKy4xtt7uXBzmu+g@mail.gmail.com> (sfid-20130217_145838_045876_BA8E1891)
Subject: Re: [RFC] mac80211: make CONFIG_MAC80211_MESH=y default
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://o11s.org seems not active.

---
Chun-Yeow

On Sun, Feb 17, 2013 at 3:22 AM, Thomas Pedersen <thomas@cozybit.com> wrote:
> Increases mac80211 memory use by about 95K.
>
> At least Ubuntu, Debian, and Arch Linux already enable
> this in their default kernels.
>
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  net/mac80211/Kconfig |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index 0ecf947..4ca2a49 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -80,14 +80,15 @@ comment "Some wireless drivers require a rate control algorithm"
>         depends on MAC80211 && MAC80211_HAS_RC=n
>
>  config MAC80211_MESH
> -       bool "Enable mac80211 mesh networking (pre-802.11s) support"
> -       depends on MAC80211 && EXPERIMENTAL
> +       bool "Enable mac80211 mesh networking (802.11s) support"
> +       depends on MAC80211
> +       default y
>         ---help---
> -        This options enables support of Draft 802.11s mesh networking.
> -        The implementation is based on Draft 2.08 of the Mesh Networking
> -        amendment.  However, no compliance with that draft is claimed or even
> -        possible, as drafts leave a number of identifiers to be defined after
> -        ratification.  For more information visit http://o11s.org/.
> +        This options enables support for 802.11s mesh networking.  The
> +        implementation is based on the 11s amendment introduced in IEEE
> +        802.11-2012. An effort has been made to be standard-compliant, so If
> +        you notice something amiss, please contact the maintainers.  For more
> +        information visit http://o11s.org/.
>
>  config MAC80211_LEDS
>         bool "Enable LED triggers"
> --
> 1.7.10.4
>
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
