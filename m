Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:33172 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932475AbZHDHAI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 03:00:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MYE0A-00017q-PN
	for linux-wireless@vger.kernel.org; Tue, 04 Aug 2009 07:00:02 +0000
Received: from i59F7B022.versanet.de ([89.247.176.34])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 07:00:02 +0000
Received: from jal2 by i59F7B022.versanet.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 07:00:02 +0000
To: linux-wireless@vger.kernel.org
From: Joerg Albert <jal2@gmx.de>
Subject: Re: [PATCH] cfg80211: clear SSID on disconnect
Date: Tue, 4 Aug 2009 06:55:53 +0000 (UTC)
Message-ID: <loom.20090804T064513-963@post.gmane.org>
References: <1249311832.4561.2.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@...> writes:


>  	wdev->current_bss = NULL;
>  	wdev->sme_state = CFG80211_SME_IDLE;
> +	wdev->ssid_len = 0;
> 
>  	if (wdev->conn) {
>  		kfree(wdev->conn->ie);

Sorry, but this didn't help with the ar9170 problem. I still get a call
to  ar9170_op_bss_info_changed() after ifconfig wlan1 down.
I put a printk at your change in sme.c and it's not called.

Please be aware that in managed mode my adapter stays in state SCANNING, 'cause
there is not AP around with essid huhu_m:

ifconfig wlan1 up
iwconfig wlan1 essid huhu_m
ifconfig wlan1 down
iwconfig wlan1 mode ad-hoc essid huhu_a channel 1
/* ar9170_op_bss_info_changed() is called with ar->vif == NULL */

Regards,
Jörg.



