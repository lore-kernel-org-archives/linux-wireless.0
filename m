Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:41454 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2GTH2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2012 03:28:34 -0400
Date: Fri, 20 Jul 2012 10:28:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt2x00: Don't call ieee80211_get_tx_rate for MCS rates
Message-ID: <20120720072823.GL16348@mwanda> (sfid-20120720_092838_316954_6B477BB3)
References: <20120719113308.GA32491@elgon.mountain>
 <CAGXE3d-OVz6Uj_d8YxdCXJ3VTk0iQBWqts1EC5megfR81_Hnsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d-OVz6Uj_d8YxdCXJ3VTk0iQBWqts1EC5megfR81_Hnsg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 19, 2012 at 01:46:15PM +0200, Helmut Schaa wrote:
> Hi Dan,
> 
> On Thu, Jul 19, 2012 at 1:33 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > Hello Helmut Schaa,
> >
> > I'm going through some old static checker warnings and I was concerned
> > about this one:
> >
> > The patch 55b585e29095: "rt2x00: Don't call ieee80211_get_tx_rate for
> > MCS rates" from Mar 3, 2011, leads to the following warning:
> > drivers/net/wireless/rt2x00/rt2x00queue.c:508
> >         rt2x00queue_create_tx_descriptor()
> >         error: potential NULL dereference 'hwrate'.
> >
> >    482          /*
> >    483           * Determine rate modulation.
> >    484           */
> >    485          if (txrate->flags & IEEE80211_TX_RC_GREEN_FIELD)
> >    486                  txdesc->rate_mode = RATE_MODE_HT_GREENFIELD;
> >
> > hwrate is NULL here.
> >
> >    487          else if (txrate->flags & IEEE80211_TX_RC_MCS)
> >    488                  txdesc->rate_mode = RATE_MODE_HT_MIX;
> >    489          else {
> >    490                  rate = ieee80211_get_tx_rate(rt2x00dev->hw, tx_info);
> >    491                  hwrate = rt2x00_get_rate(rate->hw_value);
> >    492                  if (hwrate->flags & DEV_RATE_OFDM)
> >    493                          txdesc->rate_mode = RATE_MODE_OFDM;
> >    494                  else
> >    495                          txdesc->rate_mode = RATE_MODE_CCK;
> >    496          }
> >    497
> >    498          /*
> >    499           * Apply TX descriptor handling by components
> >    500           */
> >    501          rt2x00crypto_create_tx_descriptor(rt2x00dev, skb, txdesc);
> >    502          rt2x00queue_create_tx_descriptor_seq(rt2x00dev, skb, txdesc);
> >    503
> >    504          if (test_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags))
> >    505                  rt2x00queue_create_tx_descriptor_ht(rt2x00dev, skb, txdesc,
> >    506                                                      hwrate);
> >
> > On this path we dereference dereference hwrate if IEEE80211_TX_RC_MCS is
> > not set, but we don't check for IEEE80211_TX_RC_GREEN_FIELD.
> 
> Right, I guess the basic assumption is that IEEE80211_TX_RC_GREEN_FIELD is
> only used in conjunction with IEEE80211_TX_RC_MCS.
> 
> >
> >    507          else
> >    508                  rt2x00queue_create_tx_descriptor_plcp(rt2x00dev, skb, txdesc,
> >    509                                                        hwrate);
> >
> > On this patch we dereference hwrate unconditionally.
> 
> mac80211 should never request a MCS rate for devices that don't register
> MCS rate support.
> 
> I think we could make the static checker happy by moving the hwrate
> dereferencing
> into rt2x00queue_create_tx_descriptor_plcp and
> rt2x00queue_create_tx_descriptor_ht?
> 
> Any better ideas?

If IEEE80211_TX_RC_GREEN_FIELD implies IEEE80211_TX_RC_MCS and
REQUIRE_HT_TX_DESC are set then the code is fine as is.

I'm confused by your suggestion, because the "hwrate" dereferencing
is already inside the functions.  Smatch only cares about the call
to rt2x00queue_create_tx_descriptor_plcp() because that is an
unconditional dereference.  But when I was reviewing the error
message I looked at the dereference inside
rt2x00queue_create_tx_descriptor_ht() as well.

Anyway, we shouldn't ever make the code less readable for static
checkers so lets just leave it as is.

regards,
dan carpenter

