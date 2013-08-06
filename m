Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:26184 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab3HFLS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 07:18:57 -0400
Date: Tue, 6 Aug 2013 13:18:51 +0200
From: Michael Braun <michael.braun@fem.tu-ilmenau.de>
To: Felix Fietkau <nbd@openwrt.org>
Cc: projekt-wlan@fem.tu-ilmenau.de, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: ath9k AR9380 packets take long to be sent
Message-ID: <20130806111851.GA25326@dynamic.fami-braun.de> (sfid-20130806_131859_684406_D3106730)
Reply-To: projekt-wlan@fem.tu-ilmenau.de, linux-wireless@vger.kernel.org,
	  ath9k-devel@lists.ath9k.org
References: <e86f61ba4c0540d1d22be989362cbeb1@fami-braun.de>
 <5200D199.8080808@openwrt.org>
 <5200D1C9.1090008@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5200D1C9.1090008@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Aug 06, 2013 at 12:36:57PM +0200, Felix Fietkau wrote:
> On 2013-08-06 12:36 PM, Felix Fietkau wrote:
> > On 2013-08-06 10:52 AM, Michael Braun wrote:
> >> Hi,
> >> 
> >> I've upgraded my OpenWRT based AP firmware from kernel 3.8 to kernel 
> >> 3.10.5 with compat-wireless 2013-06-27.
> >> Since then I started to notice that some packets take very long to be 
> >> actually sent from AP to STA.
> > Which specific OpenWrt revision are you using?

I've been running devel from monday 13h (cfa0f1e910855a04b98d46bda14183dea421d2f8) before writing this mail.
In the meantime I tried removing package/kernel/mac80211/patches/5(6|7).*.patch and it currently looks like it helps.

> > Also, can you please test
> > with the latest one (I just committed some more fixes).

sure

> One more thing, the clients you're talking about - are these 802.11n
> clients or 802.11a/b/g legacy?

these are 802.11n capable clients but I disabled 802.11n in hostapd (ieee80211n=0).

Michael Braun
