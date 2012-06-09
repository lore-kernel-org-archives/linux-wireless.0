Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab2FIH7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 03:59:31 -0400
Message-ID: <1339228767.4539.3.camel@jlt3.sipsolutions.net> (sfid-20120609_095934_001921_2A6986E0)
Subject: Re: [RFC] mac80211: follow 802.11-2007 11.5.3 Error recovery upon
 HT BA failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Sean Patrick Santos <quantheory@gmail.com>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org,
	helmut.schaa@googlemail.com, mar.kolya@gmail.com,
	Per-Erik Westerberg <per-erik.westerberg@bredband.net>,
	=?UTF-8?Q?Miko=C5=82aj?= Kuligowski <mikolaj.q@wp.pl>
Date: Sat, 09 Jun 2012 09:59:27 +0200
In-Reply-To: <201206090311.21153.chunkeey@googlemail.com> (sfid-20120609_031203_315241_7A41DF31)
References: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com>
	 <CAFR4AqahHPR9s4vn+1HFMFk+-oi2ROxLGrqa79ufLJ=Gmzb5rQ@mail.gmail.com>
	 <201206090218.27603.chunkeey@googlemail.com>
	 <201206090311.21153.chunkeey@googlemail.com>
	 (sfid-20120609_031203_315241_7A41DF31)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> introduced a TX BA session timeout timer. However the
> timer was reset for each outgoing transmission instead
> what 802.11-2007 11.5.3 specifies: 

You should probably reference 802.11-2012 now since some things were
renumbered.

> "The inactivity timer at the originator is reset when a
> BlockAck frame corresponding to the TID for which the
> Block Ack policy is set is received."

> This patch was only compile-tested and the design has 
> some rather big problems: 

Maybe then we should just revert Nikolay's patch?

>  - The spec says we should test for BlockAcks, however
>    that is not feasible because it is a control frame
>    (so FIF_CONTROL might filter it on some hardware).

In some way, all devices are going to have to report these frames. Maybe
not as the frame itself, but as some other notification, to allow
cleaning up the TX queues accordingly, I think? There's a BA
notification in iwlwifi for example.

> +++ b/net/mac80211/status.c
> @@ -439,6 +439,29 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>  			}
>  		}
>  
> +		if (ieee80211_is_data_qos(fc) && acked &&
> +		    info->flags & IEEE80211_TX_CTL_AMPDU &&
> +		    local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) {

I'm confused -- what does this have to do with HW_HAS_RATE_CONTROL?

johannes

