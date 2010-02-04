Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:40108 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab0BDKNE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 05:13:04 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: cfg80211 support
Date: Thu, 4 Feb 2010 11:11:26 +0100
Cc: Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	Holger Schurig <holgerschurig@googlemail.com>
References: <20100202000934.GA19847@sortiz.org>
In-Reply-To: <20100202000934.GA19847@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002041111.26722.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel !

You wrote this code:

> +static int lbs_cfg_del_key(struct wiphy *wiphy, struct net_device *netdev,
> +                          u8 key_index, const u8 *mac_addr)
> +{
> +       struct lbs_private *priv = wiphy_priv(wiphy);
> +
> +       lbs_deb_enter(LBS_DEB_CFG80211);
> +
> +       if (key_index < 3 && priv->wep_key_len[key_index]) {
> +               priv->wep_key_len[key_index] = 0;
> +               lbs_set_wep_keys(priv);
> +       }
> +
> +       lbs_deb_assoc("del_key: key_idx %d, mac_addr %pM\n",
> +                     key_index, mac_addr);
> +
> +       return 0;
> +}

while I had this a no-op. I had a long comment at this code,
where I wrote:

/*
 * I think can keep this a NO-OP, because:
 * - we clear all keys whenever we do lbs_cfg_connect() anyway
 * - neither "iw" nor "wpa_supplicant" won't call this during
 *   an ongoing connection
 * - TODO: but I have to check if this is still true when
 *   I set the AP to periodic re-keying
 * - we've not kzallec() something when we've added a key at
 *   lbs_cfg_connect() or lbs_cfg_add_key().
 *
 * This causes lbs_cfg_del_key() only called at disconnect time,
 * where we'd just waste time deleting a key that is not going
 * to be used anyway.
 */

Didn't you agree with that test?  Did any of the WPA/WPA2/WEP
connections broke for you?  I didn't saw any problems, even
when changing from WEP to WPA and back without reloading the
driver.

However, I haven't tested libertas+cfg with the wext-
compatibility thing, maybe it's needed then?  But I doubt
it, because of point one in my comment-list.

-- 
http://www.holgerschurig.de
