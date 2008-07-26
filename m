Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:53488 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYGZW0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 18:26:47 -0400
Received: by wf-out-1314.google.com with SMTP id 27so4911524wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jul 2008 15:26:47 -0700 (PDT)
Message-ID: <69e28c910807261526g17d1aeb1m7427b257cf61fc5e@mail.gmail.com> (sfid-20080727_002654_974823_69F494CA)
Date: Sun, 27 Jul 2008 00:26:47 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] iwlwifi: Enable packet injection for iwl4965
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"Tomas Winkler" <tomas.winkler@intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Marco Schuster" <marco@harddisk.is-a-geek.org>
In-Reply-To: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 18, 2008 at 9:05 PM, Stefanik G=E1bor <netrolller.3d@gmail.=
com> wrote:
> @@ -822,7 +819,10 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_=
buff *skb)
>        hdr_len =3D ieee80211_get_hdrlen(le16_to_cpu(fc));
>
>        /* Find (or create) index into station table for destination s=
tation */
> -       sta_id =3D iwl_get_sta_id(priv, hdr);
> +       if (info->flags & IEEE80211_TX_CTL_INJECTED)
> +               sta_id =3D priv->hw_params.bcast_sta_id;
> +       else
> +               sta_id =3D iwl_get_sta_id(priv, hdr);
>        if (sta_id =3D=3D IWL_INVALID_STATION) {
>                DECLARE_MAC_BUF(mac);

Oops... this hunk (last hunk in iwl-tx.c) is unneeded, just ignore it
(it's a leftover from another patch I have in my tree).

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
