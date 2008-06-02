Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:53638 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbYFBR5d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 13:57:33 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K3EHi-0007CM-Ui
	for linux-wireless@vger.kernel.org; Mon, 02 Jun 2008 17:57:30 +0000
Received: from cpc1-cwma5-0-0-cust137.swan.cable.ntl.com ([80.4.12.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2008 17:57:30 +0000
Received: from sitsofe by cpc1-cwma5-0-0-cust137.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2008 17:57:30 +0000
To: linux-wireless@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH] mac80211: fix rate control initialisation
Date: Mon, 02 Jun 2008 18:50:20 +0100
Message-ID: <g21c9v$vdl$1@ger.gmane.org> (sfid-20080602_195737_496928_9DF3D142)
References: <g1uicv$se6$1@ger.gmane.org> <1212392284.4148.7.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> In commit 2e92e6f2c50b4baf85cca968f0e6f1b5c0df7d39 ("mac80211: use rate
> index in TX control") I forgot to initialise a few new variables to -1
> which means that the rate control algorithm is never triggered and 0 is
> used as the only rate index, effectively fixing the transmit bitrate at
> the lowest supported.
> 
> This patch adds the missing initialisation.

This is far better (the rate sets itself to 24Mb/s or 36 Mb/s rather than
being fixed on 54 Mb/s). However when using iwl3945 the rate could not be
forced using iwconfig wlan0 rate 54M fixed and it took a little . The rate
it chooses also seems to bounce about a bit - simply telling networkmanager
to reconnect results in a different speed (although it's hard to tell how
good the connection is while this is happening).

-- 
Sitsofe | http://sucs.org/~sits/

