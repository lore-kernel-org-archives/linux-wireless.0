Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:12840 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456AbbFBJjF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 05:39:05 -0400
Date: Tue, 2 Jun 2015 11:39:01 +0200
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Yanbo Li <yanbol@qca.qualcomm.com>
Cc: <kvalo@qca.qualcomm.com>, <dreamfly281@gmail.com>,
	<ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: Debugfs entry to enable/disable
 WLAN&Blutooth Coexist feature
Message-ID: <20150602113901.2da3542d@north> (sfid-20150602_113909_142161_292497E1)
In-Reply-To: <1432840745-21725-1-git-send-email-yanbol@qca.qualcomm.com>
References: <1432840745-21725-1-git-send-email-yanbol@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 28 May 2015 12:19:05 -0700, Yanbo Li wrote:
> As some radio have no connection with BT modules, enable the WLAN/Bluetooth
> coexist(BTC) feature will has some side effect if the radio's GPIO connect
> with any other HW modules. Add the control switcher "btc_feature" at
> debugfs and set the feature as disable by default to avoid such case.
>
> To enable this feature, execute:
> echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
> To disable:
> echo 0 > /sys/kernel/debug/ieee80211/phyX/ath10k/btc_feature
> 
> Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>

IMHO common API for disabling/enabling btcoex is something we would all
benefit from and easy enough to implement properly.  Burying it in
driver-specific debugfs is less than appropriate.

I seem to recall there were plans to discuss btcoex at one of the
linux-wireless summits.  If the consensus was to leave it in debugfs
then I apologize for the noise ;)
