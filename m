Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:59783 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752153AbeCaOdc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Mar 2018 10:33:32 -0400
Message-ID: <1522506808.11653.7.camel@perches.com> (sfid-20180331_163402_235647_C68AF8CD)
Subject: Re: [PATCH 06/12] wireless: Convert simple uses of a static const
 Ethernet broadcast address
From: Joe Perches <joe@perches.com>
To: Pkshih <pkshih@realtek.com>, "huxm@marvell.com" <huxm@marvell.com>,
        "gbhat@marvell.com" <gbhat@marvell.com>,
        "jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Date: Sat, 31 Mar 2018 07:33:28 -0700
In-Reply-To: <1522504872.1910.17.camel@realtek.com>
References: <cover.1522479607.git.joe@perches.com>
         <79196f134a513d50968e8e208a0e56b3c0236ee3.1522479607.git.joe@perches.com>
         <1522504872.1910.17.camel@realtek.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-03-31 at 14:01 +0000, Pkshih wrote:
> On Sat, 2018-03-31 at 00:05 -0700, Joe Perches wrote:
> > Use the new ether_broadcast_addr global instead to save some object code.
[]
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c
[]
> > @@ -1649,7 +1648,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
> >  			memcpy(rtlpriv->sec.key_buf[key_idx],
> >  			       key->key, key->keylen);
> >  			rtlpriv->sec.key_len[key_idx] = key->keylen;
> > -			memcpy(mac_addr, bcast_addr, ETH_ALEN);
> > +			memcpy(mac_addr, ether_broadcast_addr, ETH_ALEN);
> 
> Use ether_addr_copy(mac_addr, ether_broadcast_addr) ?

This should use eth_broadcast_addr(mac_addr) instead.

There are similar conversion still possible in the tree.
One day.
