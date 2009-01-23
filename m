Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:45792 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbZAWCo5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 21:44:57 -0500
Received: by ewy13 with SMTP id 13so3225000ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 18:44:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090123013000.GA5604@sortiz.org>
References: <20090123013000.GA5604@sortiz.org>
Date: Fri, 23 Jan 2009 03:44:53 +0100
Message-ID: <2d0a357f0901221844h1849f4fanc577dcc2c5037101@mail.gmail.com> (sfid-20090123_034513_028039_499E8174)
Subject: Re: [PATCH] mac80211: ieee80211_sta_set_bssid should call
	config_interface()
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Alina Friedrichsen <x-alina@gmx.net>,
	Kalle Valo <kalle.valo@iki.fi>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to clarify:
The revert-patch of Alina's fix (causing regression) is no more needed?

-SD

On Fri, Jan 23, 2009 at 2:30 AM, Samuel Ortiz <samuel@sortiz.org> wrote:
> From: Samuel Ortiz <samuel.ortiz@intel.com>
>
> With commit e32b1b9a33759e8a83ac566c4c43f23ed5d6343b, we end up not calling
> config_interface() when we're in STA, but not Ad-Hoc. This breaks several
> drivers, and the fix is to get ieee80211_sta_set_bssid() to call
> ieee80211_if_config() again.
>
> Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  net/mac80211/mlme.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> Index: wireless-testing/net/mac80211/mlme.c
> ===================================================================
> --- wireless-testing.orig/net/mac80211/mlme.c   2009-01-23 01:33:54.000000000 +0100
> +++ wireless-testing/net/mac80211/mlme.c        2009-01-23 01:36:51.000000000 +0100
> @@ -2650,6 +2650,18 @@ int ieee80211_sta_set_bssid(struct ieee8
>                ifsta->flags &= ~IEEE80211_STA_BSSID_SET;
>        }
>
> +       if (netif_running(sdata->dev)) {
> +               int ret;
> +
> +               ret = ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
> +
> +               if (ret) {
> +                       printk(KERN_DEBUG "%s: Failed to config new BSSID to "
> +                              "the low-level driver\n", sdata->dev->name);
> +                       return ret;
> +               }
> +       }
> +
>        return ieee80211_sta_set_ssid(sdata, ifsta->ssid, ifsta->ssid_len);
>  }
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
