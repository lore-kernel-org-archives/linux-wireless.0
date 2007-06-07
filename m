Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:51732 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965326AbXFGUj2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 16:39:28 -0400
Date: Thu, 7 Jun 2007 22:39:34 +0200
From: Jiri Benc <jbenc@suse.cz>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH 3/3] mac80211: debugfs support for TSM and DLS
Message-ID: <20070607223934.4726e8a7@griffin.suse.cz>
In-Reply-To: <20070606082239.GA28667@mail.intel.com>
References: <20070606082239.GA28667@mail.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 6 Jun 2007 16:22:39 +0800, Zhu Yi wrote:
> --- a/net/mac80211/debugfs_netdev.c
> +++ b/net/mac80211/debugfs_netdev.c
> @@ -87,6 +87,270 @@ static const struct file_operations name##_ops = {			\
>  		IEEE80211_IF_FMT_##format(name, field)			\
>  		__IEEE80211_IF_FILE(name)
>  
> +static struct ieee80211_elem_tspec _tspec = {
> +	.nominal_msdu_size = 200,
> +	.inactivity_interval = 40,
> +	.mean_data_rate = 40000,
> +	.min_phy_rate = 6000000,
> +	.surplus_band_allow = 8192,
> +	.medium_time = 30,
> +};
> +static u8 _dls_mac[ETH_ALEN];

A global variable? Common for all devices you have in your computer?
That's broken.

> +
> +#define DEBUGFS_QOS_FILE(name, f)					\
> +static ssize_t qos_ ##name## _write(struct file *file,			\
> +				    const char __user *userbuf,		\
> +				    size_t count, loff_t *ppos)		\
> +{									\
> +	struct ieee80211_sub_if_data *sdata = file->private_data;	\
> +									\
> +	f(sdata->dev, &sdata->u.sta, &_tspec);				\
> +									\
> +	return count;							\
> +}									\

Triggering an event just by writing anything to the debugfs file
doesn't seem like a clean and intelligible way to configure things.

Also, are you aware this is just a _debug_ stuff? Given the fact that
you're calling (for example) ieee80211_send_addts from debugfs handler
only, it looks like you're misusing it as an user space API.

 Jiri

-- 
Jiri Benc
SUSE Labs
