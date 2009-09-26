Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:58020 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890AbZIZTJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 15:09:21 -0400
Date: Sat, 26 Sep 2009 22:09:21 +0300
From: Jouni Malinen <j@w1.fi>
To: ASIC Felix <ic.felix@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Is this normal: ath9k: Two wiphys trying to scan at the same
	time
Message-ID: <20090926190921.GA22838@jm.kir.nu>
References: <1253825462.19221.14.camel@darkslate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1253825462.19221.14.camel@darkslate>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 01:51:02PM -0700, ASIC Felix wrote:

> is this normal:
> 
>   ath9k: Two wiphys trying to scan at the same time
> 
> afaik, I did not enable virtual phy stuff. Connection appears to be
> working okay. I've been seeing this for quite some time.

That should only be showing up if virtual wiphys are used. In this case,
it should not really be showing up and is likely indicating a bug
somewhere (ath9k or mac80211). I don't know how to reproduce this
easily, so I have not looked into more details yet. It would be
interesting to add printk calls into ath9k_sw_scan_start() and
ath9k_sw_scan_complete() just after the mutex_lock() call to figure out
whether mac80211 ends up calling sw_scan_start() driver handler twice in
a row which would be one possible way to get this triggered. The other
way to hit this would be if ath9k were to somehow not update aphy->state
correctly when the scan has been completed.

-- 
Jouni Malinen                                            PGP id EFC895FA
