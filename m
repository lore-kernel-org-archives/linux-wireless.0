Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:41794 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab0CWQSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 12:18:55 -0400
Received: by ewy8 with SMTP id 8so612560ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 09:18:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1269348417-4081-2-git-send-email-sgruszka@redhat.com>
References: <1269348417-4081-1-git-send-email-sgruszka@redhat.com>
	<1269348417-4081-2-git-send-email-sgruszka@redhat.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 23 Mar 2010 09:18:33 -0700
Message-ID: <43e72e891003230918g2e662957vd9bce29d36f3f334@mail.gmail.com>
Subject: Re: [PATCH 2/2] iwlwifi: implement disabling/enabling QoS
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 23, 2010 at 5:46 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-core.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
> index 112149e..f1729ca 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -2410,6 +2410,15 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
>                priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
>        }
>
> +       if (changes & BSS_CHANGED_QOS) {
> +               unsigned long flags;
> +
> +               spin_lock_irqsave(&priv->lock, flags);
> +               priv->qos_data.qos_active = bss_conf->qos_disabled ? 0 : 1;
> +               iwl_activate_qos(priv, 1);
> +               spin_unlock_irqrestore(&priv->lock, flags);
> +       }
> +
>        if (changes & BSS_CHANGED_BEACON_INT) {
>                priv->beacon_int = bss_conf->beacon_int;
>                /* TODO: in AP mode, do something to make this take effect */

What happened without this BTW, did it not associate? What AP was it?
Did you get to test with other drivers by chance?

  Luis
