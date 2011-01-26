Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:7179 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751978Ab1AZCjA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 21:39:00 -0500
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-053239538
	for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 11:38:59 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH 6/6] ath: Fix WEP hardware encryption
Date: Wed, 26 Jan 2011 11:38:53 +0900
Cc: linville@tuxdriver.com, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6> <20110125041549.6944.15800.stgit@localhost6.localdomain6> <20110125183205.GA29410@jm.kir.nu>
In-Reply-To: <20110125183205.GA29410@jm.kir.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101261138.53169.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed January 26 2011 03:32:05 Jouni Malinen wrote:
> On Tue, Jan 25, 2011 at 01:15:49PM +0900, Bruno Randolf wrote:
> > In AP mode hardware encryption for WEP was not used on the RX side
> > because there was a mismatch in the key indices. The key index in the
> > WLAN header is 0-3 while the hardware key cache was configured for key
> > indices >= 4. This is ok for transmit but received packets were not
> > decrypted in HW and therefore mac80211 had to decrypt them in SW - this
> > can be easily seen by adding some debug prints in mac80211/wep.c (around
> > line 296). I have noticed it by watching the system CPU load under high
> > traffic.
> > 
> > This patch configures WEP keys into the "standard" key indices 0-4 which
> > were reserved for that.
> 
> Have you tested this with multiple vifs? I would assume it would break
> things pretty completely for all but one vif.. As such, I'm not sure
> that it would be that good of an idea to try to improve on something
> like WEP which is known to be completely insecure and unusable with
> 802.11n when it is likely to break use cases that are much more relevant
> in modern, post-WEP, time..
> 
> If you really think you need this, there would need to be code somewhere
> kicking out the default keys from key cache if another vif is added.
> When working with the key cache implementation for ath9k, the extra
> effort did not seem to be justifiable for WEP and it is now couple of
> years from that and surely there is even less justification now.

Please let's not go into the discussion about the usefulness of WEP - there is 
no need to convince me. But unfortunately there are users and customers who 
still want to use WEP for a variety of reasons. Yes it's legacy, yes it's 
flawed especially with regards to multiple vifs, but we still need to support 
it.

Even without my patch, WEP does not work with multiple vifs. 
(As far as i understand it, with WEP the lookup is just done based on the key 
index in the WLAN header field. mac80211 (or is it hostapd?) sets up both keys 
for both interfaces with a key index of 0, which causes the lookup to go to 
the same key for both vifs. I guess mac80211 or hostapd would need to be 
changed to use different key indices for different vif WEP keys, but then of 
course we can only use 4 different WEP keys in sum, and not 4 different WEP 
keys per vif. No big deal imho.)

My patch just adds a special case for WEP, so it does not break anything for 
the other use cases. It improves the performance for the one vif case where 
WEP works right now.

bruno
