Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50726 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752508AbdIFKde (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 06:33:34 -0400
Message-ID: <1504694012.13457.8.camel@sipsolutions.net> (sfid-20170906_123337_345891_610D17C6)
Subject: Re: [PATCH 09/10] mac80211_hwsim: Add command to control rx status
 RSSI
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, Beni Lev <beni.lev@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 06 Sep 2017 12:33:32 +0200
In-Reply-To: <20170805084438.12550-10-luca@coelho.fi>
References: <20170805084438.12550-1-luca@coelho.fi>
         <20170805084438.12550-10-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-08-05 at 11:44 +0300, Luca Coelho wrote:
> 
> +static int hwsim_fops_rx_rssi_write(void *dat, u64 val)
> +{
> +	struct mac80211_hwsim_data *data = dat;
> +	int rssi = (int)val;

That cast is wrong - you should go to s64, do the range check, and only
then restrict to int. Basically, just do

s64 rssi = val;

in this line instead.


> +	debugfs_create_file("rx_rssi", 0666, data->debugfs, data,
> +			    &hwsim_fops_rx_rssi);

I also can't say I'm really happy with this, since there's no such
thing as an "RX RSSI".

Also, wmediumd already allows changing this - I'd rather people start
using the infrastructure better than papering over more.

IOW - do we really need this? Why can't you do the (simple) wmediumd
setup? There's even a hwsim test in wpa_s with wmediumd, it's not all
that difficult.

johannes
