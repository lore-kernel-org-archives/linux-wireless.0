Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:58892 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbZGNToy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 15:44:54 -0400
Received: by ewy26 with SMTP id 26so3547398ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2009 12:44:53 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "Lars Ericsson" <Lars_Ericsson@telia.com>
Subject: Re: RT61 antenna diversity in 2.6.30
Date: Tue, 14 Jul 2009 21:44:50 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <0DC66442F4FF4076964868A5ECAB9790@gotws1589>
In-Reply-To: <0DC66442F4FF4076964868A5ECAB9790@gotws1589>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907142144.50697.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 13 July 2009, Lars Ericsson wrote:
> Hi Ivo,
> 
> I recently moved from 2.6.26 to 2.6.30 with a HW that do 
> SW antenna diversity with .26 but not with .30
> 
> I have found two problems:
> 1) The rt2x00mac_config() calls rt2x00lib_config_antenna() and reset the
> rt2x00dev->default_ant.

Where is this reset of default_ant occuring?
There is only 1 write action in that function and that is altering the
rt2x00dev->link.ant.active field.

> 2) The rt2x00lib_antenna_diversity_sample() does not update the sampled
> antenna rssi.

And why should that be done?

> I have applied the following patches to correct the problems:
> 
> 1)
> --- a/drivers/net/wireless/rt2x00/rt2x00link.c	2009-07-13
> 21:48:45.000000000 +0200
> +++ b/drivers/net/wireless/rt2x00/rt2x00link.c	2009-07-13
> 21:52:42.000000000 +0200
> @@ -146,8 +151,13 @@ static void rt2x00lib_antenna_diversity_
>  {
>  	struct link_ant *ant = &rt2x00dev->link.ant;
>  	struct antenna_setup new_ant;
> -	int sample_a = rt2x00link_antenna_get_rssi_history(rt2x00dev,
> ANTENNA_A);
> -	int sample_b = rt2x00link_antenna_get_rssi_history(rt2x00dev,
> ANTENNA_B);
> +	int rssi_curr, sample_a, sample_b;
> +			
> +	rssi_curr = rt2x00link_antenna_get_link_rssi(rt2x00dev);
> +	rt2x00link_antenna_update_rssi_rx_history(rt2x00dev, rssi_curr);
> +	
> +	sample_a = rt2x00link_antenna_get_rssi_history(rt2x00dev,
> ANTENNA_A);
> +	sample_b = rt2x00link_antenna_get_rssi_history(rt2x00dev,
> ANTENNA_B);
>  
>  	memcpy(&new_ant, &ant->active, sizeof(new_ant));
> ---
> 
> 2)
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c	2009-07-13
> 21:51:26.000000000 +0200
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c	2009-07-13
> 21:54:28.000000000 +0200
> @@ -375,10 +375,12 @@ int rt2x00mac_config(struct ieee80211_hw
>  		 * diversity. But for non-diversity configurations, we need
>  		 * to have configured the correct state now.
>  		 */
> -		if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED)
> +		if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED) {
> +			rt2x00dev->link.ant.active = rt2x00dev->default_ant;

This is done in rt2x00lib_config_antenna where it should.

>  			rt2x00lib_config_antenna(rt2x00dev,
> -						 &rt2x00dev->default_ant);
> +
> &rt2x00dev->link.ant.active);

This is very bad, since calling rt2x00lib_config_antenna() to set it to
the active configuration should always result in nothing being done.
Your hack by reseting the active field will cause it to do something,
but it looks extremely hackish.
