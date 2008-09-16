Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42919 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbYIPBzH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 21:55:07 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KfPmR-0007YJ-15
	for linux-wireless@vger.kernel.org; Tue, 16 Sep 2008 01:55:03 +0000
Received: from 129.96.153.230 ([129.96.153.230])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 16 Sep 2008 01:55:03 +0000
Received: from podge by 129.96.153.230 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 16 Sep 2008 01:55:03 +0000
To: linux-wireless@vger.kernel.org
From: Shawn Haggett <podge@podgeweb.com>
Subject: Re: [PATCH 2.6.27-rc4] mac80211: don't send empty extended rates IE
Date: Tue, 16 Sep 2008 10:33:54 +0930
Message-ID: <gan0ln$ikd$1@ger.gmane.org> (sfid-20080916_035524_958836_2586E488)
References: <200808251832.m7PIW6kA071701@enterprise.localnet.radiotube.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jan-Espen Pettersen wrote:

> The association request includes a list of supported data rates.
> 
> 802.11b: 4 supported rates.
> 802.11g: 12 (8 + 4) supported rates.
> 802.11a: 8 supported rates.
> 
> The rates tag of the assoc request has room for only 8 rates. In case of
> 802.11g an extended rate tag is appended. However in net/wireless/mlme.c
> an extended (empty) rate tag is also appended if the number of rates is
> exact 8. This empty (length=0) extended rates tag causes some APs to
> deny association with code 18 (unsupported rates). These APs include my
> ZyXEL G-570U, and according to Tomas Winkler som Cisco APs.
> 
> 'If count == 8' has been used to check for the need for an extended rates
> tag. But count would also be equal to 8 if the for loop exited because of
> no more supported rates. Therefore a check for count being less than
> rates_len would seem more correct.
> 
> Thanks to:
>  * Dan Williams for newbie guidance
>  * Tomas Winkler for confirming the problem
> 
> Signed-off-by: Jan-Espen Pettersen

Just to add to this. I've had a long standing issue with my laptop not
associating to my AP at home and this patch has fixed my issue as well. My
AP however is a Billion 7404VGO-M ADSL modem/router/802.11b/g and my
wireless card an Intel Wireless 4965AGN chipset.

Previous behaviour was the card would associate, then drop out, then
associate again... over and over. Never any traffic, but would work fine on
other APs. I applied this patch to my 2.6.26 kernel and now it works fine.

Thanks!

