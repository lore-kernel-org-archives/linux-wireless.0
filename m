Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.compendium.com.ar ([200.69.223.40]:39373 "EHLO
	rocinante.compendium.com.ar" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752219Ab1IVNXf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 09:23:35 -0400
Received: from localhost (localhost [127.0.0.1])
	by rocinante.compendium.com.ar (Postfix) with ESMTP id 688C614825B
	for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 10:23:33 -0300 (ART)
Received: from rocinante.compendium.com.ar ([127.0.0.1])
	by localhost (rocinante.compendium.com.ar [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W4Zv+poOAmdJ for <linux-wireless@vger.kernel.org>;
	Thu, 22 Sep 2011 10:23:32 -0300 (ART)
Date: Thu, 22 Sep 2011 10:23:32 -0300
From: Horacio =?iso-8859-1?Q?J=2E_Pe=F1a?= <horape@compendium.com.ar>
To: linux-wireless@vger.kernel.org
Subject: Re: Multiple Virtual Interfaces: when the station one fails the ap
 follows
Message-ID: <20110922132332.GY18063@compendium.com.ar> (sfid-20110922_152338_804399_61BF6B1B)
References: <20110917205507.GK8298@compendium.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20110917205507.GK8298@compendium.com.ar>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following on this, I've found that "It seems that this channel hopping looking
for AP1 is what breaks AP2." was wrong. I've tried a very dirty workaround,
making a fake regulatory domain that only allows channel 6. Then, there is no
channel hopping, but still the AP2 doesn't works. It sometimes sends out Probe
Responses but no beacons.

Some idea on where to look?

Thanks,
Horacio J. Peña

On Sat, Sep 17, 2011 at 05:55:07PM -0300, Horacio J. Peña wrote:
> [Please excuse me the openwrt syntax, I wrote this first on the openwrt forum]
> 
> When using multiple virtual interfaces like:
> 
> 
> config wifi-device  radio0
>         option type     mac80211
>         option channel  6
> ...
> 
> config wifi-iface
>         option device   radio0
>         option network  wan
>         option mode     sta
>         option ssid     AP1
> ...
> config wifi-iface
>         option device   radio0
>         option network  wlan
>         option mode     AP2
> 
> 
> If wan gets deassociated from AP1, it gets impossible to associate to AP2 network. 
> 
> Looking with airodump-ng I see a few beacons sent on the right channel and that it's sending probes on the wrong channels. It seems that this channel hopping looking for AP1 is what breaks AP2.
> 
> It seems that devices in managed mode disregard the channel configuration. Is there any way to force it?
> 
> This has been tested on a TP-LINK MR3420 (AR9287)
> 
> Thanks!
> -- 
> Horacio J. Peña
> horape@compendium.com.ar
> horape@uninet.edu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Horacio J. Peña
horape@compendium.com.ar
horape@uninet.edu
