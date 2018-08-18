Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20394 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbeHRVua (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 17:50:30 -0400
Message-ID: <3a02cd8191f222eeda50e75228b121edf9e28a17.camel@intel.com> (sfid-20180818_204350_736294_0A867183)
Subject: Re: [PATCH] Fix Bug 199967 - change WARN_ON(1) to IWL_ERR()
From: Luciano Coelho <luciano.coelho@intel.com>
To: Joe Perches <joe@perches.com>, Nye Liu <nyet@nyet.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org
Date: Sat, 18 Aug 2018 21:41:43 +0300
In-Reply-To: <b175d55db809739bdcd94a63eaf076097ffd12fd.camel@perches.com>
References: <20180818033555.18110-1-nyet@nyet.org>
         <c052cdda16fa0df1b3672f4be9c20df053703ac0.camel@intel.com>
         <084b662c-4701-9a18-ffb1-c661f4534d8c@nyet.org>
         <b175d55db809739bdcd94a63eaf076097ffd12fd.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-08-18 at 09:52 -0700, Joe Perches wrote:
> On Sat, 2018-08-18 at 09:11 -0700, Nye Liu wrote:
> > On 8/18/2018 1:41 AM, Luciano Coelho wrote:
> > 
> > > On Fri, 2018-08-17 at 20:35 -0700, Nye Liu wrote:
> > > > The TX_STATUS_FAIL_DEST_PS case fills logs with full
> > > > backtraces, which
> > > > are pretty useless. Just do IWL_ERR() printk.
> > > > 
> > > > Signed-off-by: Nye Liu <nyet@nyet.org>
> > > > ---
> > > >   drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 4 +++-
> > > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> > > > b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> > > > index cf2591f2ac23..87044953e6b4 100644
> > > > --- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> > > > +++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> > > > @@ -1407,8 +1407,10 @@ static void
> > > > iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
> > > >   			/* the FW should have stopped the queue
> > > > and not
> > > >   			 * return this status
> > > >   			 */
> > > > -			WARN_ON(1);
> > > >   			info->flags |=
> > > > IEEE80211_TX_STAT_TX_FILTERED;
> > > > +			IWL_ERR(mvm, "TX_STATUS_FAIL_DEST_PS: "
> > > > +				"tid %d, status %x, flags
> > > > %x\n", tid, status,
> > > > +				info->flags);
> > > >   			break;
> > > >   		default:
> > > >   			break;
> > > 
> > > I think this error is serious enough and we would like to catch
> > > it when
> > > it occurs so we can debug the actual cause.
> > > 
> > > But I agree that we shouldn't be repeating it millions of
> > > times.  What
> > > about just changing it to WARN_ON_ONCE() instead?
> > > 
> > 
> > That would be fine, but IMO the WARN_ON() provides less information
> > that 
> > the printk(). I'm not an IWL devel but there is limited information
> > on 
> > the wifi state itself in the WARN() - just call stack and register 
> > information. Also, with WARN_ON_ONCE() the frequency of the error
> > is masked.
> 
> This could also use WARN_ON_RATELIMIT with some
> appropriate state.

I think it's overkill.  If it happens once, we will know and we will
investigate.  I don't see the added value of making it happen more than
one, especially since it seems that the connection continues to work
properly.

I agree that passing more data in the warning could be useful, and that
could be done with WARN_ONCE() instead of WARN_ON_ONCE() then.  But the
status is useless, we know it's TX_STATUS_FAIL_DEST_PS if we check
where it happened.  The flags are also not necessary, since it's data
we are *setting* in this function.  Maybe the tid, but I'm not sure
it's really relevant either.

--
Luca.
