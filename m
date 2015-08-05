Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15656 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbbHEOHe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 10:07:34 -0400
Message-ID: <1438783649.29746.175.camel@linux.intel.com> (sfid-20150805_160739_100285_530A87D7)
Subject: Re: [PATCH 2/5] net: rfkill: add rfkill_find_type function
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Date: Wed, 05 Aug 2015 17:07:29 +0300
In-Reply-To: <1438781947-7952-3-git-send-email-heikki.krogerus@linux.intel.com>
References: <1438781947-7952-1-git-send-email-heikki.krogerus@linux.intel.com>
	 <1438781947-7952-3-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-05 at 16:39 +0300, Heikki Krogerus wrote:
> Helper for finding the type based on name. Useful if the
> type needs to be determined based on device property.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  include/linux/rfkill.h | 15 +++++++++++++
>  net/rfkill/core.c      | 57 +++++++++++++++++++++++++---------------
> ----------
>  2 files changed, 44 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index d901078..02f563c 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -212,6 +212,15 @@ void rfkill_set_states(struct rfkill *rfkill, 
> bool sw, bool hw);
>   * @rfkill: rfkill struct to query
>   */
>  bool rfkill_blocked(struct rfkill *rfkill);
> +
> +/**
> + * rfkill_find_type - Helpper for finding rfkill type by name
> + * @name: the name of the type
> + *
> + * Returns enum rfkill_type that conrresponds the name.
> + */
> +enum rfkill_type rfkill_find_type(const char *name);
> +
>  #else /* !RFKILL */
>  static inline struct rfkill * __must_check
>  rfkill_alloc(const char *name,
> @@ -268,6 +277,12 @@ static inline bool rfkill_blocked(struct rfkill 
> *rfkill)
>  {
>  	return false;
>  }
> +
> +static inline enum rfkill_type rfkill_find_type(const char *name)
> +{
> +	return 0;

Hmm… Besides 0 is implicitly casted to enum type the issue with enums
that you rather have to supply existing enum entry. I would suggest to
add RFKILL_TYPE_UNKNOWN if _ALL is reserved for some use cases.

> +}
> +
>  #endif /* RFKILL || RFKILL_MODULE */
>  
>  
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index f12149a..53d7a97e 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -574,6 +574,33 @@ void rfkill_set_states(struct rfkill *rfkill, 
> bool sw, bool hw)
>  }
>  EXPORT_SYMBOL(rfkill_set_states);
>  
> +static const char *rfkill_types[NUM_RFKILL_TYPES] = {
> +	[RFKILL_TYPE_WLAN]	= "wlan",
> +	[RFKILL_TYPE_BLUETOOTH]	= "bluetooth",
> +	[RFKILL_TYPE_UWB]	= "ultrawideband",
> +	[RFKILL_TYPE_WIMAX]	= "wimax",
> +	[RFKILL_TYPE_WWAN]	= "wwan",
> +	[RFKILL_TYPE_GPS]	= "gps",
> +	[RFKILL_TYPE_FM]	= "fm",
> +	[RFKILL_TYPE_NFC]	= "nfc",
> +};
> +
> +enum rfkill_type rfkill_find_type(const char *name)
> +{
> +	int i;
> +
> +	BUILD_BUG_ON(NUM_RFKILL_TYPES != RFKILL_TYPE_NFC + 1);
> +
> +	if (!name)
> +		return RFKILL_TYPE_ALL;
> +
> +	for (i = 1; i < NUM_RFKILL_TYPES; i++)
> +		if (!strcmp(name, rfkill_types[i]))
> +			return i;
> +	return RFKILL_TYPE_ALL;
> +}
> +EXPORT_SYMBOL(rfkill_find_type);
> +
>  static ssize_t name_show(struct device *dev, struct device_attribute 
> *attr,
>  			 char *buf)
>  {
> @@ -583,38 +610,12 @@ static ssize_t name_show(struct device *dev, 
> struct device_attribute *attr,
>  }
>  static DEVICE_ATTR_RO(name);
>  
> -static const char *rfkill_get_type_str(enum rfkill_type type)
> -{
> -	BUILD_BUG_ON(NUM_RFKILL_TYPES != RFKILL_TYPE_NFC + 1);
> -
> -	switch (type) {
> -	case RFKILL_TYPE_WLAN:
> -		return "wlan";
> -	case RFKILL_TYPE_BLUETOOTH:
> -		return "bluetooth";
> -	case RFKILL_TYPE_UWB:
> -		return "ultrawideband";
> -	case RFKILL_TYPE_WIMAX:
> -		return "wimax";
> -	case RFKILL_TYPE_WWAN:
> -		return "wwan";
> -	case RFKILL_TYPE_GPS:
> -		return "gps";
> -	case RFKILL_TYPE_FM:
> -		return "fm";
> -	case RFKILL_TYPE_NFC:
> -		return "nfc";
> -	default:
> -		BUG();
> -	}
> -}
> -
>  static ssize_t type_show(struct device *dev, struct device_attribute 
> *attr,
>  			 char *buf)
>  {
>  	struct rfkill *rfkill = to_rfkill(dev);
>  
> -	return sprintf(buf, "%s\n", rfkill_get_type_str(rfkill
> ->type));
> +	return sprintf(buf, "%s\n", rfkill_types[rfkill->type]);
>  }
>  static DEVICE_ATTR_RO(type);
>  
> @@ -760,7 +761,7 @@ static int rfkill_dev_uevent(struct device *dev, 
> struct kobj_uevent_env *env)
>  	if (error)
>  		return error;
>  	error = add_uevent_var(env, "RFKILL_TYPE=%s",
> -			       rfkill_get_type_str(rfkill->type));
> +			       rfkill_types[rfkill->type]);
>  	if (error)
>  		return error;
>  	spin_lock_irqsave(&rfkill->lock, flags);

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
