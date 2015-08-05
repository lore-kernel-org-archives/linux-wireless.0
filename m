Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57224 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbbHEOCX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 10:02:23 -0400
Message-ID: <1438783338.29746.172.camel@linux.intel.com> (sfid-20150805_160248_584547_63456FD9)
Subject: Re: [PATCH 1/5] device property: helper macros for property entry
 creation
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Date: Wed, 05 Aug 2015 17:02:18 +0300
In-Reply-To: <1438781947-7952-2-git-send-email-heikki.krogerus@linux.intel.com>
References: <1438781947-7952-1-git-send-email-heikki.krogerus@linux.intel.com>
	 <1438781947-7952-2-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-05 at 16:39 +0300, Heikki Krogerus wrote:
> Marcos for easier creation of build-in property entries.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  include/linux/property.h | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/include/linux/property.h b/include/linux/property.h
> index 76ebde9..204d899 100644
> --- a/include/linux/property.h
> +++ b/include/linux/property.h
> @@ -152,6 +152,41 @@ struct property_entry {
>  	} value;
>  };
>  
> +#define PROP_ENTRY_U8(_name_, _val_) { \

PROP_ prefix is too generic.
Maybe DEVPROP_ ? At least for the latter no records in the current
sources.

> +	.name = _name_, \
> +	.type = DEV_PROP_U8, \
> +	.nval = 1, \
> +	.value.u8_data = _val_, \
> +}
> +
> +#define PROP_ENTRY_U16(_name_, _val_) { \
> +	.name = _name_, \
> +	.type = DEV_PROP_U16, \
> +	.nval = 1, \
> +	.value.u16_data = _val_, \
> +}
> +
> +#define PROP_ENTRY_U32(_name_, _val_) { \
> +	.name = _name_, \
> +	.type = DEV_PROP_U32, \
> +	.nval = 1, \
> +	.value.u32_data = _val_, \
> +}
> +
> +#define PROP_ENTRY_U64(_name_, _val_) { \
> +	.name = _name_, \
> +	.type = DEV_PROP_U64, \
> +	.nval = 1, \
> +	.value.u64_data = _val_, \
> +}
> +
> +#define PROP_ENTRY_STRING(_name_, _val_) { \

…_STRING_ARRAY I can notice.

> +	.name = _name_, \
> +	.type = DEV_PROP_STRING, \
> +	.nval = 1, \
> +	.value.str = (const char **)_val_, \
> +}
> +
>  /**
>   * struct property_set - Collection of "built-in" device properties.
>   * @fwnode: Handle to be pointed to by the fwnode field of struct 
> device.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
