Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:6187 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751159Ab1AZKgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 05:36:16 -0500
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0975108171
	for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 19:36:15 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH 6/6] ath: Fix WEP hardware encryption
Date: Wed, 26 Jan 2011 19:36:02 +0900
Cc: linville@tuxdriver.com, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6> <201101261138.53169.br1@einfach.org> <20110126093700.GA11832@jm.kir.nu>
In-Reply-To: <20110126093700.GA11832@jm.kir.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101261936.02831.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed January 26 2011 18:37:00 Jouni Malinen wrote:
> On Wed, Jan 26, 2011 at 11:38:53AM +0900, Bruno Randolf wrote:
> > Even without my patch, WEP does not work with multiple vifs.
> 
> Are you sure about that? 

Yes, I'm sure. Please test it yourself, if you don't believe me. :)
I'm using ath5k, not ath9k, BTW.

> Why would there be any issues in using software
> crypto for decrypting WEP frames while everything else is done in
> hardware? 

I don't know why it doesn't work at this point, but it doesn't and this looks 
suspicious:

root@RMR1:~# cat /sys/kernel/debug/ieee80211/phy0/keys/0/hw_key_idx 
4
root@RMR1:~# cat /sys/kernel/debug/ieee80211/phy0/keys/0/keyidx 
0
root@RMR1:~# cat /sys/kernel/debug/ieee80211/phy0/keys/1/hw_key_idx 
68
root@RMR1:~# cat /sys/kernel/debug/ieee80211/phy0/keys/1/keyidx 
0

> > My patch just adds a special case for WEP, so it does not break anything
> > for the other use cases. It improves the performance for the one vif
> > case where WEP works right now.
> 
> As far as I can tell, it will break all multi-vif cases where at least
> one of the vifs is using WEP (which would be one of the only acceptable
> uses of WEP as a temporary upgrade path while providing more reasonable
> security on other vifs). As such, I would have to NAK this patch in its
> current form.

Why do you believe it would break something? It just uses key indices 0-3, 
which are not used for anything else.

I tested it with 1 WEP vif and 3 WPA vifs and it works.

> To make this acceptable, the patch would need to handle a case where
> multiple vifs are added (which may happen either before or after the WEP
> keys would be set to default key indexes) and prevent the use of those
> key indexes (which would include removing the already configured keys in
> case of vif added after the WEP configuration on another vif).

Given the fact that it works i think this is not necessary.

bruno
