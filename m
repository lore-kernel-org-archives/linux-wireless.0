Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45638 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYCIRji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 13:39:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Kalle Valo <Kalle.Valo@iki.fi>
Subject: Re: [PATCH 06/12] Add support for monitor mode
Date: Sun, 9 Mar 2008 18:39:15 +0100
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>
References: <20080210145733.17592.61729.stgit@tikku> <200802101649.28711.mb@bu3sch.de> <87ve3vyj21.fsf@litku.valot.fi>
In-Reply-To: <87ve3vyj21.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803091839.15514.mb@bu3sch.de> (sfid-20080309_173942_257537_1DD8C721)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 09 March 2008 17:10:46 Kalle Valo wrote:
> Michael Buesch <mb@bu3sch.de> writes:
> 
> >> +#define AT76_SUPPORTED_FILTERS FIF_PROMISC_IN_BSS
> >
> > See my recent patch to zd1211rw:
> > [PATCH] zd1211rw: Fix beacon filter flags thinko
> > I think this thinko also applies here.
> >
> > A driver does not support a flag, if it can _not_ _provide_
> > a specific frame. (so in case it always filters it)
> > Not the other way around. So if it always
> > provides a specific type of frames, it _does_ support the filter flag.
> 
> Thanks for looking at this. 
> 
> I have to admit that I didn't undertstand the filter flags logic at
> that time, but I think I understand it now. I hope this is right:
> 
> 
> static void at76_op_configure_filter(struct ieee80211_hw *hw,
> 				  unsigned int changed_flags,
> 				  unsigned int *total_flags, int mc_count,
> 				  struct dev_addr_list *mc_list)
> {
> 	struct at76_priv *priv = hw->priv;
> 
> 	at76_dbg(DBG_MAC80211, "%s(): changed_flags=0x%08x "
> 		 "total_flags=0x%08x mc_count=%d",
> 		 __func__, changed_flags, *total_flags, mc_count);
> 
> 	*total_flags &= FIF_PROMISC_IN_BSS;

So your driver can not pass control frames and beacons in normal operation
to the stack?

> 
> 	if (changed_flags & FIF_PROMISC_IN_BSS) {
> 		/* FIXME: access to priv->promisc should be protected with
> 		 * priv->mtx, but it's impossible because this function
> 		 * needs to be atomic */
> 		priv->promisc = *total_flags & FIF_PROMISC_IN_BSS;
> 		queue_work(hw->workqueue, &priv->work_set_promisc);
> 	}
> 
> }
> 
> 



-- 
Greetings Michael.
