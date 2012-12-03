Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:43473 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab2LCOXy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 09:23:54 -0500
Message-ID: <50BCB3A3.4090708@01019freenet.de> (sfid-20121203_152358_048012_19FD131C)
Date: Mon, 03 Dec 2012 15:13:55 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Francisco Pina Martins <f.pinamartins@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/2] mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
References: <20121203115632.GA2490@redhat.com>
In-Reply-To: <20121203115632.GA2490@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw!

Stanislaw Gruszka wrote:
> Commit f0425beda4d404a6e751439b562100b902ba9c98 "mac80211: retry sending
> failed BAR frames later instead of tearing down aggr" caused regression
> on rt2x00 hardware (connection hangs).

This patch caused a problem, too, with carl9170
(http://thread.gmane.org/gmane.linux.kernel.wireless.general/92203/focus=92376).
How did they fix it (the thread unfortunately ends without any solution
/ patch).

> This regression was fixed by
> commit be03d4a45c09ee5100d3aaaedd087f19bc20d01 "rt2x00: Don't let
> mac80211 send a BAR when an AMPDU subframe fails". But the letter
> commit, caused yet another problem reported in
> https://bugzilla.kernel.org/show_bug.cgi?id=42828#c22

This already was a workaround as stated in the removed comment: "TODO:
Need to tear down BA session here if not successful."

My general question is:
Is the behaviour of f0425beda spec conform? Is it implemented correctly
and w/o demanding any special hardware feature? If both questions can be
answered with yes, rt2x00 should be fixed to get the same behaviour working.

If f0425beda isn't spec conform or if it expects special hardware
features, it would be a more or less a ath9k specific "solution", which
should be removed from mac80211 and should be moved to the driver. I'm
thinking of this, because rt2x00 is not the only one having problems and
Felix comment in
http://news.gmane.org/find-root.php?group=gmane.linux.drivers.rt2x00.user&article=1383

"If you want to tear down the BA session in rt2x00, either do it in the
driver or add a proper flag to ensure that ath9k remains unaffected by
the change."

sounds to me really ath9k specific (what about other hardware)?

> After long discussion in this thread:
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2012-October/005349.html
> and testing various alternative solutions, which failed on one or other
> setup, we have no other good fix for the issues like just revert both
> mentioned earlier commits.

I'm scared of all the solutions proposed, which don't work (although
they should have worked), some of them even crash the machine of some
users (but not of all - e.g. see
http://news.gmane.org/find-root.php?group=gmane.linux.drivers.rt2x00.user&article=703).

My question is: why don't they work, or better: why don't they work for
all users? Obviously the driver seems to behave not always as expected,
iow: It's doing things, which are not known or even expected and which
are not planned. This really scares me, especially because I couldn't
see any answer explaining the unexpected behaviour.

That's why I think it would be really necessary to fix the real cause
instead of implementing another workaround (given f0425beda is correct).

I know that there should be a more or less fast fix, but I'm sure, too,
that most probably nobody will care about this problem any more (the
usual "out of sight, out of mind" effect) after this fire has been
turned off (again, given f0425beda isn't wrong).

> To do not affect other hardware which benefit from commit
> f0425beda4d404a6e751439b562100b902ba9c98, instead of reverting it,
> introduce flag that when used will restore mac80211 behaviour before
> the commit.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> It's fine to queue this to 3.8 and this will get 3.7 and older
> releases through -stable.
> 
>  include/net/mac80211.h |    5 +++++
>  net/mac80211/status.c  |    6 +++++-
>  2 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 82558c8..d481cc6 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1253,6 +1253,10 @@ struct ieee80211_tx_control {
>   * @IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF: Use the P2P Device address for any
>   *	P2P Interface. This will be honoured even if more than one interface
>   *	is supported.
> + *
> + * @IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL: On this hardware TX BA session
> + *	should be tear down once BAR frame will not be acked.
> + *
>   */
>  enum ieee80211_hw_flags {
>  	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
> @@ -1281,6 +1285,7 @@ enum ieee80211_hw_flags {
>  	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
>  	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
>  	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF		= 1<<25,
> +	IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL		= 1<<26,
>  };
>  
>  /**
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index 101eb88..c511e9c 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -432,7 +432,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>  				       IEEE80211_BAR_CTRL_TID_INFO_MASK) >>
>  				      IEEE80211_BAR_CTRL_TID_INFO_SHIFT;
>  
> -				ieee80211_set_bar_pending(sta, tid, ssn);
> +				if (local->hw.flags &
> +				    IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL)
> +					ieee80211_stop_tx_ba_session(&sta->sta, tid);
> +				else
> +					ieee80211_set_bar_pending(sta, tid, ssn);
>  			}
>  		}
>  

Besides the fact that I'm not (yet) convinced about the way of fixing
the problem, both patches work for me (tested with
compat-wireless-3.5rc5 and Linksys WMP600N as AP using 802.11n on 2.4
GHz band / 40MHz / WPA2 / EAPTLS / AES with rt3572sta (Linksys WUSB600Nv2)).


Thanks,
kind regards,
Andreas
