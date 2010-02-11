Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab0BKMEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 07:04:11 -0500
Date: Thu, 11 Feb 2010 13:03:30 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	Holger Schurig <holgerschurig@googlemail.com>
Subject: Re: [PATCH] libertas: cfg80211 support
Message-ID: <20100211120329.GB3136@sortiz.org>
References: <20100202000934.GA19847@sortiz.org>
 <201002041111.26722.holgerschurig@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <201002041111.26722.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Holger,

On Thu, Feb 04, 2010 at 11:11:26AM +0100, Holger Schurig wrote:
> Hi Samuel !
> 
> You wrote this code:
> 
> > +static int lbs_cfg_del_key(struct wiphy *wiphy, struct net_device *netdev,
> > +                          u8 key_index, const u8 *mac_addr)
> > +{
> > +       struct lbs_private *priv = wiphy_priv(wiphy);
> > +
> > +       lbs_deb_enter(LBS_DEB_CFG80211);
> > +
> > +       if (key_index < 3 && priv->wep_key_len[key_index]) {
> > +               priv->wep_key_len[key_index] = 0;
> > +               lbs_set_wep_keys(priv);
> > +       }
> > +
> > +       lbs_deb_assoc("del_key: key_idx %d, mac_addr %pM\n",
> > +                     key_index, mac_addr);
> > +
> > +       return 0;
> > +}
> 
> while I had this a no-op. 
Sorry about this one. I was hitting WEP connection issues and I uncommented
that as I thought it could be the problem. But it wasnt related and then I
forgot to comment it again.
I definitely agree this could be left as a NO-OP.

Cheers,
Samuel.


> I had a long comment at this code,
> where I wrote:
> 
> /*
>  * I think can keep this a NO-OP, because:
>  * - we clear all keys whenever we do lbs_cfg_connect() anyway
>  * - neither "iw" nor "wpa_supplicant" won't call this during
>  *   an ongoing connection
>  * - TODO: but I have to check if this is still true when
>  *   I set the AP to periodic re-keying
>  * - we've not kzallec() something when we've added a key at
>  *   lbs_cfg_connect() or lbs_cfg_add_key().
>  *
>  * This causes lbs_cfg_del_key() only called at disconnect time,
>  * where we'd just waste time deleting a key that is not going
>  * to be used anyway.
>  */
> 
> Didn't you agree with that test?  Did any of the WPA/WPA2/WEP
> connections broke for you?  I didn't saw any problems, even
> when changing from WEP to WPA and back without reloading the
> driver.
> 
> However, I haven't tested libertas+cfg with the wext-
> compatibility thing, maybe it's needed then?  But I doubt
> it, because of point one in my comment-list.
> 
> -- 
> http://www.holgerschurig.de

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
