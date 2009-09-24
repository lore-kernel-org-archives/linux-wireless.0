Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:34316 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbZIXSgF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 14:36:05 -0400
Received: by iwn8 with SMTP id 8so1144858iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 11:36:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090924180251.14503.64152.stgit@tikku>
References: <20090924180048.14503.9579.stgit@tikku> <20090924180251.14503.64152.stgit@tikku>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 24 Sep 2009 11:35:48 -0700
Message-ID: <43e72e890909241135j21f687a7oc4f929d2134b6310@mail.gmail.com>
Subject: Re: [PATCH 2/2] at76c50x-usb: set firmware and hardware version in
	wiphy
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, Felix Bitterli <ic.felix@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 11:02 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Set firmware and hardware version in wiphy so that user space can access
> it.
>
> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
> ---
>
>  drivers/net/wireless/at76c50x-usb.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
> index 8e1a55d..b6de657 100644
> --- a/drivers/net/wireless/at76c50x-usb.c
> +++ b/drivers/net/wireless/at76c50x-usb.c
> @@ -2217,6 +2217,8 @@ static struct ieee80211_supported_band at76_supported_band = {
>  static int at76_init_new_device(struct at76_priv *priv,
>                                struct usb_interface *interface)
>  {
> +       struct wiphy *wiphy;
> +       size_t len;
>        int ret;
>
>        /* set up the endpoint information */
> @@ -2254,6 +2256,7 @@ static int at76_init_new_device(struct at76_priv *priv,
>        priv->device_unplugged = 0;
>
>        /* mac80211 initialisation */
> +       wiphy = priv->hw->wiphy;
>        priv->hw->wiphy->max_scan_ssids = 1;
>        priv->hw->wiphy->max_scan_ie_len = 0;
>        priv->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
> @@ -2265,6 +2268,18 @@ static int at76_init_new_device(struct at76_priv *priv,
>        SET_IEEE80211_DEV(priv->hw, &interface->dev);
>        SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
>
> +       len = sizeof(wiphy->fw_version);
> +       snprintf(wiphy->fw_version, len, "%d.%d.%d-%d",
> +                priv->fw_version.major, priv->fw_version.minor,
> +                priv->fw_version.patch, priv->fw_version.build);
> +
> +       len = sizeof(wiphy->hw_version);
> +       snprintf(wiphy->hw_version, len, "%d", priv->board_type);

So ath9k and ath5k keep their own strings for such things, to name the
MAC/Baseband, and then the radio revision and subrevisions... What I'd
like to see documented on the kdoc for hw_version is what exactly is
expected to be put there.

The hw_version and fw_version seem to be helpful in providing more
information to userspace which you would not typically see -- things
you would only tend to see on a dmesg output so at least for that
purpose I think its nice. For example lspci won't really tell you the
exact hardware type on atheros chipsets, so this seems nice.

Anyway, getting some more clarification on the docs would be nice.

  Luis
