Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbXGKVV4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 17:21:56 -0400
Subject: Re: [PATCH 2.6] libertas : fix a few wext abuses...
From: Dan Williams <dcbw@redhat.com>
To: jt@hpl.hp.com
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070710213706.GA7929@bougret.hpl.hp.com>
References: <20070710213706.GA7929@bougret.hpl.hp.com>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 17:19:48 -0400
Message-Id: <1184188789.28850.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-07-10 at 14:37 -0700, Jean Tourrilhes wrote:
> 	Hi guys,
> 
> 	I have no clue to who is the official libertas maintainer, so
> please tell me where to send this patch.

Me, actually :)  Thanks for the patch.

Dan

> 	I did a quick review of the WE support in libertas. I don't
> have the hardware, so it was very superficial. These are my comments :
> 		o SIOCGIWNAME is not designed to return the version
> number of the driver. On the other hand, you are free to abuse
> SIOCGIWNICKN for that purpose.
> 		o Don't attempt to fix the WE19/WE20 transition in the
> driver, because your fixes are bogus, and redundant with the code in
> the kernel (you may endup with +2, you can't read 32 char ESSID...).
> 		o In SIOCSIWTXPOW, if you specified in iwrange that
> you want dBm, you should only get dBm, which allow to reduce code
> bloat.
> 	I would like someone with the hardware to review to changes,
> fix my buggy patch and send that to John.
> 	Thanks.
> 
> 	Jean
> 
> Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
> 
> -----------------------------------------------------------
> 
> --- linux/drivers/net/wireless/libertas/wext.j1.c	2007-07-10 11:44:07.000000000 -0700
> +++ linux/drivers/net/wireless/libertas/wext.c	2007-07-10 14:04:01.000000000 -0700
> @@ -30,52 +30,6 @@ static u8 libertas_wlan_data_rates[WLAN_
>  };
>  
>  /**
> - *  @brief Convert mw value to dbm value
> - *
> - *  @param mw	   the value of mw
> - *  @return 	   the value of dbm
> - */
> -static int mw_to_dbm(int mw)
> -{
> -	if (mw < 2)
> -		return 0;
> -	else if (mw < 3)
> -		return 3;
> -	else if (mw < 4)
> -		return 5;
> -	else if (mw < 6)
> -		return 7;
> -	else if (mw < 7)
> -		return 8;
> -	else if (mw < 8)
> -		return 9;
> -	else if (mw < 10)
> -		return 10;
> -	else if (mw < 13)
> -		return 11;
> -	else if (mw < 16)
> -		return 12;
> -	else if (mw < 20)
> -		return 13;
> -	else if (mw < 25)
> -		return 14;
> -	else if (mw < 32)
> -		return 15;
> -	else if (mw < 40)
> -		return 16;
> -	else if (mw < 50)
> -		return 17;
> -	else if (mw < 63)
> -		return 18;
> -	else if (mw < 79)
> -		return 19;
> -	else if (mw < 100)
> -		return 20;
> -	else
> -		return 21;
> -}
> -
> -/**
>   *  @brief Find the channel frequency power info with specific channel
>   *
>   *  @param adapter 	A pointer to wlan_adapter structure
> @@ -243,28 +197,11 @@ static int get_active_data_rates(wlan_ad
>  static int wlan_get_name(struct net_device *dev, struct iw_request_info *info,
>  			 char *cwrq, char *extra)
>  {
> -	const char *cp;
> -	char comm[6] = { "COMM-" };
> -	char mrvl[6] = { "MRVL-" };
> -	int cnt;
>  
>  	lbs_deb_enter(LBS_DEB_WEXT);
>  
> -	strcpy(cwrq, mrvl);
> -
> -	cp = strstr(libertas_driver_version, comm);
> -	if (cp == libertas_driver_version)	//skip leading "COMM-"
> -		cp = libertas_driver_version + strlen(comm);
> -	else
> -		cp = libertas_driver_version;
> -
> -	cnt = strlen(mrvl);
> -	cwrq += cnt;
> -	while (cnt < 16 && (*cp != '-')) {
> -		*cwrq++ = toupper(*cp++);
> -		cnt++;
> -	}
> -	*cwrq = '\0';
> +	/* We could add support for 802.11n here as needed. Jean II */
> +	snprintf(cwrq, IFNAMSIZ, "IEEE 802.11b/g");
>  
>  	lbs_deb_leave(LBS_DEB_WEXT);
>  	return 0;
> @@ -344,29 +281,37 @@ static int wlan_set_nick(struct net_devi
>  static int wlan_get_nick(struct net_device *dev, struct iw_request_info *info,
>  			 struct iw_point *dwrq, char *extra)
>  {
> -	wlan_private *priv = dev->priv;
> -	wlan_adapter *adapter = priv->adapter;
> +	const char *cp;
> +	char comm[6] = { "COMM-" };
> +	char mrvl[6] = { "MRVL-" };
> +	int cnt;
>  
>  	lbs_deb_enter(LBS_DEB_WEXT);
>  
>  	/*
> -	 * Get the Nick Name saved
> +	 * Nick Name is not used internally in this mode,
> +	 * therefore return something useful instead. Jean II
>  	 */
>  
> -	mutex_lock(&adapter->lock);
> -	strncpy(extra, adapter->nodename, 16);
> -	mutex_unlock(&adapter->lock);
> +	strcpy(extra, mrvl);
>  
> -	extra[16] = '\0';
> +	cp = strstr(libertas_driver_version, comm);
> +	if (cp == libertas_driver_version)	//skip leading "COMM-"
> +		cp = libertas_driver_version + strlen(comm);
> +	else
> +		cp = libertas_driver_version;
>  
> -	/*
> -	 * If none, we may want to get the one that was set
> -	 */
> +	cnt = strlen(mrvl);
> +	extra += cnt;
> +	while (cnt < 16 && (*cp != '-')) {
> +		*extra++ = toupper(*cp++);
> +		cnt++;
> +	}
>  
>  	/*
>  	 * Push it out !
>  	 */
> -	dwrq->length = strlen(extra) + 1;
> +	dwrq->length = cnt;
>  
>  	lbs_deb_leave(LBS_DEB_WEXT);
>  	return 0;
> @@ -385,12 +330,12 @@ static int mesh_get_nick(struct net_devi
>  	if (adapter->connect_status == libertas_connected) {
>  		strncpy(extra, "Mesh", 12);
>  		extra[12] = '\0';
> -		dwrq->length = strlen(extra) + 1;
> +		dwrq->length = strlen(extra);
>  	}
>  
>  	else {
>  		extra[0] = '\0';
> -		dwrq->length = 1 ;
> +		dwrq->length = 0 ;
>  	}
>  
>  	lbs_deb_leave(LBS_DEB_WEXT);
> @@ -1983,8 +1928,10 @@ static int wlan_set_txpow(struct net_dev
>  
>  	wlan_radio_ioctl(priv, RADIO_ON);
>  
> +	/* Userspace check in iwrange if it should use dBm or mW,
> +	 * therefore this should never happen... Jean II */
>  	if ((vwrq->flags & IW_TXPOW_TYPE) == IW_TXPOW_MWATT) {
> -		dbm = (u16) mw_to_dbm(vwrq->value);
> +		return -EOPNOTSUPP;
>  	} else
>  		dbm = (u16) vwrq->value;
>  
> @@ -2032,12 +1979,7 @@ static int wlan_get_essid(struct net_dev
>  	 * If none, we may want to get the one that was set
>  	 */
>  
> -	/* To make the driver backward compatible with WPA supplicant v0.2.4 */
> -	if (dwrq->length == 32)	/* check with WPA supplicant buffer size */
> -		dwrq->length = min_t(size_t, adapter->curbssparams.ssid_len,
> -				   IW_ESSID_MAX_SIZE);
> -	else
> -		dwrq->length = adapter->curbssparams.ssid_len + 1;
> +	dwrq->length = adapter->curbssparams.ssid_len;
>  
>  	dwrq->flags = 1;	/* active */
>  
> @@ -2058,14 +2000,6 @@ static int wlan_set_essid(struct net_dev
>  
>  	lbs_deb_enter(LBS_DEB_WEXT);
>  
> -	/*
> -	 * WE-20 and earlier NULL pad the end of the SSID and increment
> -	 * SSID length so it can be used like a string.  WE-21 and later don't,
> -	 * but some userspace tools aren't able to cope with the change.
> -	 */
> -	if ((in_ssid_len > 0) && (extra[in_ssid_len - 1] == '\0'))
> -		in_ssid_len--;
> -
>  	/* Check the size of the string */
>  	if (in_ssid_len > IW_ESSID_MAX_SIZE) {
>  		ret = -E2BIG;

