Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59078 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab1ACSQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 13:16:16 -0500
Subject: Re: OOPS at ieee80211_aes_ccm_encrypt()?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110103201138.146879onsq0vcqqg@hayate.sektori.org>
References: <20110103001006.13085vt89qfm6pcs@hayate.sektori.org>
	 <1294073190.3436.2.camel@jlt3.sipsolutions.net>
	 <20110103201138.146879onsq0vcqqg@hayate.sektori.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 19:16:14 +0100
Message-ID: <1294078574.3436.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-03 at 20:11 +0200, Jussi Kivilinna wrote:
> Quoting Johannes Berg <johannes@sipsolutions.net>:
> 
> >
> > It looks like it. Can you reproduce this fairly easily? I wonder if it's
> > an RCU problem, we do key lookups under RCU but I see no grace period
> > right now ... try the patch below, I'll look into it in more detail.
> >
> 
> I have been running tests past two weeks and this came up once. I have  
> been running hostapd with wpa_group_rekey=30 and wpa_ptk_rekey=60 and  
> doing 'nc < /dev/zero > /dev/null' at both ends and 'ping -f'. When  
> this crash happened other end was rndis_wlan. I'll try reproducing,  
> but doubt it will.

Alright, thanks. In the meantime, I dug through the code and history and
saw that there was a synchronize_rcu that I accidentally removed, so
I'll just send out the patch with more commentary.

johannes



