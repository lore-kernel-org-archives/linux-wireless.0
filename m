Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35404 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2GSLqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 07:46:16 -0400
Received: by yenl2 with SMTP id l2so2636812yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jul 2012 04:46:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120719113308.GA32491@elgon.mountain>
References: <20120719113308.GA32491@elgon.mountain>
Date: Thu, 19 Jul 2012 13:46:15 +0200
Message-ID: <CAGXE3d-OVz6Uj_d8YxdCXJ3VTk0iQBWqts1EC5megfR81_Hnsg@mail.gmail.com> (sfid-20120719_134621_695006_8C15E028)
Subject: Re: rt2x00: Don't call ieee80211_get_tx_rate for MCS rates
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Thu, Jul 19, 2012 at 1:33 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Hello Helmut Schaa,
>
> I'm going through some old static checker warnings and I was concerned
> about this one:
>
> The patch 55b585e29095: "rt2x00: Don't call ieee80211_get_tx_rate for
> MCS rates" from Mar 3, 2011, leads to the following warning:
> drivers/net/wireless/rt2x00/rt2x00queue.c:508
>         rt2x00queue_create_tx_descriptor()
>         error: potential NULL dereference 'hwrate'.
>
>    482          /*
>    483           * Determine rate modulation.
>    484           */
>    485          if (txrate->flags & IEEE80211_TX_RC_GREEN_FIELD)
>    486                  txdesc->rate_mode = RATE_MODE_HT_GREENFIELD;
>
> hwrate is NULL here.
>
>    487          else if (txrate->flags & IEEE80211_TX_RC_MCS)
>    488                  txdesc->rate_mode = RATE_MODE_HT_MIX;
>    489          else {
>    490                  rate = ieee80211_get_tx_rate(rt2x00dev->hw, tx_info);
>    491                  hwrate = rt2x00_get_rate(rate->hw_value);
>    492                  if (hwrate->flags & DEV_RATE_OFDM)
>    493                          txdesc->rate_mode = RATE_MODE_OFDM;
>    494                  else
>    495                          txdesc->rate_mode = RATE_MODE_CCK;
>    496          }
>    497
>    498          /*
>    499           * Apply TX descriptor handling by components
>    500           */
>    501          rt2x00crypto_create_tx_descriptor(rt2x00dev, skb, txdesc);
>    502          rt2x00queue_create_tx_descriptor_seq(rt2x00dev, skb, txdesc);
>    503
>    504          if (test_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags))
>    505                  rt2x00queue_create_tx_descriptor_ht(rt2x00dev, skb, txdesc,
>    506                                                      hwrate);
>
> On this path we dereference dereference hwrate if IEEE80211_TX_RC_MCS is
> not set, but we don't check for IEEE80211_TX_RC_GREEN_FIELD.

Right, I guess the basic assumption is that IEEE80211_TX_RC_GREEN_FIELD is
only used in conjunction with IEEE80211_TX_RC_MCS.

>
>    507          else
>    508                  rt2x00queue_create_tx_descriptor_plcp(rt2x00dev, skb, txdesc,
>    509                                                        hwrate);
>
> On this patch we dereference hwrate unconditionally.

mac80211 should never request a MCS rate for devices that don't register
MCS rate support.

I think we could make the static checker happy by moving the hwrate
dereferencing
into rt2x00queue_create_tx_descriptor_plcp and
rt2x00queue_create_tx_descriptor_ht?

Any better ideas?

Helmut
