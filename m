Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:50152 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726219AbeHRUBQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 16:01:16 -0400
Message-ID: <b175d55db809739bdcd94a63eaf076097ffd12fd.camel@perches.com> (sfid-20180818_185259_785732_8B4CDA3D)
Subject: Re: [PATCH] Fix Bug 199967 - change WARN_ON(1) to IWL_ERR()
From: Joe Perches <joe@perches.com>
To: Nye Liu <nyet@nyet.org>, Luciano Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org
Date: Sat, 18 Aug 2018 09:52:53 -0700
In-Reply-To: <084b662c-4701-9a18-ffb1-c661f4534d8c@nyet.org>
References: <20180818033555.18110-1-nyet@nyet.org>
         <c052cdda16fa0df1b3672f4be9c20df053703ac0.camel@intel.com>
         <084b662c-4701-9a18-ffb1-c661f4534d8c@nyet.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-08-18 at 09:11 -0700, Nye Liu wrote:
> On 8/18/2018 1:41 AM, Luciano Coelho wrote:
> 
> > On Fri, 2018-08-17 at 20:35 -0700, Nye Liu wrote:
> > > The TX_STATUS_FAIL_DEST_PS case fills logs with full backtraces, which
> > > are pretty useless. Just do IWL_ERR() printk.
> > > 
> > > Signed-off-by: Nye Liu <nyet@nyet.org>
> > > ---
> > >   drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 4 +++-
> > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> > > index cf2591f2ac23..87044953e6b4 100644
> > > --- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> > > +++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> > > @@ -1407,8 +1407,10 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
> > >   			/* the FW should have stopped the queue and not
> > >   			 * return this status
> > >   			 */
> > > -			WARN_ON(1);
> > >   			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
> > > +			IWL_ERR(mvm, "TX_STATUS_FAIL_DEST_PS: "
> > > +				"tid %d, status %x, flags %x\n", tid, status,
> > > +				info->flags);
> > >   			break;
> > >   		default:
> > >   			break;
> > 
> > I think this error is serious enough and we would like to catch it when
> > it occurs so we can debug the actual cause.
> > 
> > But I agree that we shouldn't be repeating it millions of times.  What
> > about just changing it to WARN_ON_ONCE() instead?
> > 
> 
> That would be fine, but IMO the WARN_ON() provides less information that 
> the printk(). I'm not an IWL devel but there is limited information on 
> the wifi state itself in the WARN() - just call stack and register 
> information. Also, with WARN_ON_ONCE() the frequency of the error is masked.

This could also use WARN_ON_RATELIMIT with some
appropriate state.
