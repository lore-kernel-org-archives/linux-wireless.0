Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:44909 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866Ab1AYSdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 13:33:05 -0500
Date: Tue, 25 Jan 2011 20:32:05 +0200
From: Jouni Malinen <j@w1.fi>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/6] ath: Fix WEP hardware encryption
Message-ID: <20110125183205.GA29410@jm.kir.nu>
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
 <20110125041549.6944.15800.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110125041549.6944.15800.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 25, 2011 at 01:15:49PM +0900, Bruno Randolf wrote:
> In AP mode hardware encryption for WEP was not used on the RX side because
> there was a mismatch in the key indices. The key index in the WLAN header is
> 0-3 while the hardware key cache was configured for key indices >= 4. This is
> ok for transmit but received packets were not decrypted in HW and therefore
> mac80211 had to decrypt them in SW - this can be easily seen by adding some
> debug prints in mac80211/wep.c (around line 296). I have noticed it by watching
> the system CPU load under high traffic.
> 
> This patch configures WEP keys into the "standard" key indices 0-4 which were
> reserved for that.

Have you tested this with multiple vifs? I would assume it would break
things pretty completely for all but one vif.. As such, I'm not sure
that it would be that good of an idea to try to improve on something
like WEP which is known to be completely insecure and unusable with
802.11n when it is likely to break use cases that are much more relevant
in modern, post-WEP, time..

If you really think you need this, there would need to be code somewhere
kicking out the default keys from key cache if another vif is added.
When working with the key cache implementation for ath9k, the extra
effort did not seem to be justifiable for WEP and it is now couple of
years from that and surely there is even less justification now.

-- 
Jouni Malinen                                            PGP id EFC895FA
