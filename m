Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35816 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751490AbdI2LYl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 07:24:41 -0400
Message-ID: <1506684270.908.9.camel@coelho.fi> (sfid-20170929_132445_617258_DFB43100)
From: Luca Coelho <luca@coelho.fi>
To: Beni Lev <beni.lev@intel.com>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 29 Sep 2017 14:24:30 +0300
In-Reply-To: <1504694012.13457.8.camel@sipsolutions.net>
References: <20170805084438.12550-1-luca@coelho.fi>
         <20170805084438.12550-10-luca@coelho.fi>
         <1504694012.13457.8.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 09/10] mac80211_hwsim: Add command to control rx status
 RSSI
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-09-06 at 12:33 +0200, Johannes Berg wrote:
> On Sat, 2017-08-05 at 11:44 +0300, Luca Coelho wrote:
> > 
> > +static int hwsim_fops_rx_rssi_write(void *dat, u64 val)
> > +{
> > +	struct mac80211_hwsim_data *data = dat;
> > +	int rssi = (int)val;
> 
> That cast is wrong - you should go to s64, do the range check, and
> only
> then restrict to int. Basically, just do
> 
> s64 rssi = val;
> 
> in this line instead.
> 
> 
> > +	debugfs_create_file("rx_rssi", 0666, data->debugfs, data,
> > +			    &hwsim_fops_rx_rssi);
> 
> I also can't say I'm really happy with this, since there's no such
> thing as an "RX RSSI".
> 
> Also, wmediumd already allows changing this - I'd rather people start
> using the infrastructure better than papering over more.
> 
> IOW - do we really need this? Why can't you do the (simple) wmediumd
> setup? There's even a hwsim test in wpa_s with wmediumd, it's not all
> that difficult.

Beni,

Can you answer Johannes here? I'm removing this patch from my pending
list, so I won't take any action anymore until further notice.

--
Cheers,
Luca.
