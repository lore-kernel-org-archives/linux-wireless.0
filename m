Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42576 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab2IKHEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 03:04:01 -0400
Message-ID: <1347347067.17626.2.camel@smile> (sfid-20120911_090406_787415_4AD5AD48)
Subject: Re: [resend][PATCH] wireless: at76c50x: eliminate hex2str()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>, proski@gnu.org
Date: Tue, 11 Sep 2012 10:04:27 +0300
In-Reply-To: <20120910183458.GB2137@tuxdriver.com>
References: <1341391552-4842-3-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1346835153-5321-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20120910183458.GB2137@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-10 at 14:34 -0400, John W. Linville wrote: 
> Could you point me at the commit that adds the 'phD' specification?
There it is:
http://www.spinics.net/lists/linux-wireless/msg93694.html

commit 31550a16a5d2af859e8a11839e8c6c6c9c92dfa7

> On Wed, Sep 05, 2012 at 11:52:32AM +0300, Andy Shevchenko wrote:
> > The hex2str() is substituted by '%*phD' specificator.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> > 
> > ---
> >  drivers/net/wireless/at76c50x-usb.c |   54 ++++++++---------------------------
> >  1 file changed, 12 insertions(+), 42 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
> > index e361afe..99b9ddf 100644
> > --- a/drivers/net/wireless/at76c50x-usb.c
> > +++ b/drivers/net/wireless/at76c50x-usb.c
> > @@ -498,36 +498,6 @@ exit:
> >  	return ret;
> >  }
> >  
> > -#define HEX2STR_BUFFERS 4
> > -#define HEX2STR_MAX_LEN 64
> > -
> > -/* Convert binary data into hex string */
> > -static char *hex2str(void *buf, size_t len)
> > -{
> > -	static atomic_t a = ATOMIC_INIT(0);
> > -	static char bufs[HEX2STR_BUFFERS][3 * HEX2STR_MAX_LEN + 1];
> > -	char *ret = bufs[atomic_inc_return(&a) & (HEX2STR_BUFFERS - 1)];
> > -	char *obuf = ret;
> > -	u8 *ibuf = buf;
> > -
> > -	if (len > HEX2STR_MAX_LEN)
> > -		len = HEX2STR_MAX_LEN;
> > -
> > -	if (len == 0)
> > -		goto exit;
> > -
> > -	while (len--) {
> > -		obuf = hex_byte_pack(obuf, *ibuf++);
> > -		*obuf++ = '-';
> > -	}
> > -	obuf--;
> > -
> > -exit:
> > -	*obuf = '\0';
> > -
> > -	return ret;
> > -}
> > -
> >  /* LED trigger */
> >  static int tx_activity;
> >  static void at76_ledtrig_tx_timerfunc(unsigned long data);
> > @@ -1004,9 +974,9 @@ static void at76_dump_mib_mac_wep(struct at76_priv *priv)
> >  	    WEP_SMALL_KEY_LEN : WEP_LARGE_KEY_LEN;
> >  
> >  	for (i = 0; i < WEP_KEYS; i++)
> > -		at76_dbg(DBG_MIB, "%s: MIB MAC_WEP: key %d: %s",
> > +		at76_dbg(DBG_MIB, "%s: MIB MAC_WEP: key %d: %*phD",
> >  			 wiphy_name(priv->hw->wiphy), i,
> > -			 hex2str(m->wep_default_keyvalue[i], key_len));
> > +			 key_len, m->wep_default_keyvalue[i]);
> >  exit:
> >  	kfree(m);
> >  }
> > @@ -1031,7 +1001,7 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
> >  	at76_dbg(DBG_MIB, "%s: MIB MAC_MGMT: beacon_period %d CFP_max_duration "
> >  		 "%d medium_occupancy_limit %d station_id 0x%x ATIM_window %d "
> >  		 "CFP_mode %d privacy_opt_impl %d DTIM_period %d CFP_period %d "
> > -		 "current_bssid %pM current_essid %s current_bss_type %d "
> > +		 "current_bssid %pM current_essid %*phD current_bss_type %d "
> >  		 "pm_mode %d ibss_change %d res %d "
> >  		 "multi_domain_capability_implemented %d "
> >  		 "international_roaming %d country_string %.3s",
> > @@ -1041,7 +1011,7 @@ static void at76_dump_mib_mac_mgmt(struct at76_priv *priv)
> >  		 le16_to_cpu(m->station_id), le16_to_cpu(m->ATIM_window),
> >  		 m->CFP_mode, m->privacy_option_implemented, m->DTIM_period,
> >  		 m->CFP_period, m->current_bssid,
> > -		 hex2str(m->current_essid, IW_ESSID_MAX_SIZE),
> > +		 IW_ESSID_MAX_SIZE, m->current_essid,
> >  		 m->current_bss_type, m->power_mgmt_mode, m->ibss_change,
> >  		 m->res, m->multi_domain_capability_implemented,
> >  		 m->multi_domain_capability_enabled, m->country_string);
> > @@ -1069,7 +1039,7 @@ static void at76_dump_mib_mac(struct at76_priv *priv)
> >  		 "cwmin %d cwmax %d short_retry_time %d long_retry_time %d "
> >  		 "scan_type %d scan_channel %d probe_delay %u "
> >  		 "min_channel_time %d max_channel_time %d listen_int %d "
> > -		 "desired_ssid %s desired_bssid %pM desired_bsstype %d",
> > +		 "desired_ssid %*phD desired_bssid %pM desired_bsstype %d",
> >  		 wiphy_name(priv->hw->wiphy),
> >  		 le32_to_cpu(m->max_tx_msdu_lifetime),
> >  		 le32_to_cpu(m->max_rx_lifetime),
> > @@ -1080,7 +1050,7 @@ static void at76_dump_mib_mac(struct at76_priv *priv)
> >  		 le16_to_cpu(m->min_channel_time),
> >  		 le16_to_cpu(m->max_channel_time),
> >  		 le16_to_cpu(m->listen_interval),
> > -		 hex2str(m->desired_ssid, IW_ESSID_MAX_SIZE),
> > +		 IW_ESSID_MAX_SIZE, m->desired_ssid,
> >  		 m->desired_bssid, m->desired_bsstype);
> >  exit:
> >  	kfree(m);
> > @@ -1160,13 +1130,13 @@ static void at76_dump_mib_mdomain(struct at76_priv *priv)
> >  		goto exit;
> >  	}
> >  
> > -	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: channel_list %s",
> > +	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: channel_list %*phD",
> >  		 wiphy_name(priv->hw->wiphy),
> > -		 hex2str(m->channel_list, sizeof(m->channel_list)));
> > +		 (int)sizeof(m->channel_list), m->channel_list);
> >  
> > -	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: tx_powerlevel %s",
> > +	at76_dbg(DBG_MIB, "%s: MIB MDOMAIN: tx_powerlevel %*phD",
> >  		 wiphy_name(priv->hw->wiphy),
> > -		 hex2str(m->tx_powerlevel, sizeof(m->tx_powerlevel)));
> > +		 (int)sizeof(m->tx_powerlevel), m->tx_powerlevel);
> >  exit:
> >  	kfree(m);
> >  }
> > @@ -1369,9 +1339,9 @@ static int at76_startup_device(struct at76_priv *priv)
> >  	int ret;
> >  
> >  	at76_dbg(DBG_PARAMS,
> > -		 "%s param: ssid %.*s (%s) mode %s ch %d wep %s key %d "
> > +		 "%s param: ssid %.*s (%*phD) mode %s ch %d wep %s key %d "
> >  		 "keylen %d", wiphy_name(priv->hw->wiphy), priv->essid_size,
> > -		 priv->essid, hex2str(priv->essid, IW_ESSID_MAX_SIZE),
> > +		 priv->essid, IW_ESSID_MAX_SIZE, priv->essid,
> >  		 priv->iw_mode == IW_MODE_ADHOC ? "adhoc" : "infra",
> >  		 priv->channel, priv->wep_enabled ? "enabled" : "disabled",
> >  		 priv->wep_key_id, priv->wep_keys_len[priv->wep_key_id]);
> > -- 
> > 1.7.10.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
