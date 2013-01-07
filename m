Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:43335 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab3AGL5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 06:57:23 -0500
Received: by mail-we0-f172.google.com with SMTP id r3so10043410wey.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 03:57:22 -0800 (PST)
Date: Mon, 7 Jan 2013 12:57:18 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Ben Greear <greearb@candelatech.com>,
	=?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	linux-wireless@vger.kernel.org,
	Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH repost] net,wireless: check against default_ethtool_ops
Message-ID: <20130107115718.GC1587@minipsycho.orion> (sfid-20130107_125730_971120_144864A3)
References: <20130107095548.GA6931@redhat.com>
 <20130107102307.GA1587@minipsycho.orion>
 <20130107104413.GB6931@redhat.com>
 <20130107111108.GB1587@minipsycho.orion>
 <20130107112012.GE6931@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130107112012.GE6931@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mon, Jan 07, 2013 at 12:20:12PM CET, sgruszka@redhat.com wrote:
>On Mon, Jan 07, 2013 at 12:11:08PM +0100, Jiri Pirko wrote:
>> Mon, Jan 07, 2013 at 11:44:14AM CET, sgruszka@redhat.com wrote:
>> >On Mon, Jan 07, 2013 at 11:23:07AM +0100, Jiri Pirko wrote:
>> >> >-static const struct ethtool_ops default_ethtool_ops;
>> >> >+const struct ethtool_ops default_ethtool_ops;
>> >> >+EXPORT_SYMBOL_GPL(default_ethtool_ops);
>> >> 
>> >> I think that default_ethtool_ops should stay static. Wouldn't it be
>> >> nicer to introduce a helper like:
>> >> 
>> >> bool dev_has_default_ethtool_ops(struct net_device *dev)
>> >> {
>> >> 	return dev->ethtool_ops == &default_ethtool_ops;
>> >> }
>> >
>> >Then I still have to export this function. So with your approch, number
>> >of exported symbols will be the same, but there will be few more lines
>> >of code.
>> 
>> I think it's always better to add few more lines in order to prevent possible
>> confusion which exporting default_ethtool_ops might introduce...
>
>What possible confusion it might cause?

Someone would possibly like to do:

dev->netdev_ops = &default_ethtool_ops

in drivers for example...

+ I just do not think that exporting structs is the correct way in order
to do anything.

>
>Stanislaw
