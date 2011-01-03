Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:46422 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755546Ab1ACSLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 13:11:42 -0500
Message-ID: <20110103201138.146879onsq0vcqqg@hayate.sektori.org>
Date: Mon, 03 Jan 2011 20:11:38 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: OOPS at ieee80211_aes_ccm_encrypt()?
References: <20110103001006.13085vt89qfm6pcs@hayate.sektori.org>
 <1294073190.3436.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1294073190.3436.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Johannes Berg <johannes@sipsolutions.net>:

>
> It looks like it. Can you reproduce this fairly easily? I wonder if it's
> an RCU problem, we do key lookups under RCU but I see no grace period
> right now ... try the patch below, I'll look into it in more detail.
>

I have been running tests past two weeks and this came up once. I have  
been running hostapd with wpa_group_rekey=30 and wpa_ptk_rekey=60 and  
doing 'nc < /dev/zero > /dev/null' at both ends and 'ping -f'. When  
this crash happened other end was rndis_wlan. I'll try reproducing,  
but doubt it will.

-Jussi


