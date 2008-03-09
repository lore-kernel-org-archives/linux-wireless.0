Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:55979 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYCIQKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 12:10:52 -0400
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 06/12] Add support for monitor mode
References: <20080210145733.17592.61729.stgit@tikku>
	<20080210150034.17592.71617.stgit@tikku>
	<200802101649.28711.mb@bu3sch.de>
From: Kalle Valo <Kalle.Valo@iki.fi>
Date: Sun, 09 Mar 2008 18:10:46 +0200
In-Reply-To: <200802101649.28711.mb@bu3sch.de> (Michael Buesch's message of "Sun\, 10 Feb 2008 16\:49\:28 +0100")
Message-ID: <87ve3vyj21.fsf@litku.valot.fi> (sfid-20080309_161109_960930_2A7C1B42)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

>> +#define AT76_SUPPORTED_FILTERS FIF_PROMISC_IN_BSS
>
> See my recent patch to zd1211rw:
> [PATCH] zd1211rw: Fix beacon filter flags thinko
> I think this thinko also applies here.
>
> A driver does not support a flag, if it can _not_ _provide_
> a specific frame. (so in case it always filters it)
> Not the other way around. So if it always
> provides a specific type of frames, it _does_ support the filter flag.

Thanks for looking at this. 

I have to admit that I didn't undertstand the filter flags logic at
that time, but I think I understand it now. I hope this is right:


static void at76_op_configure_filter(struct ieee80211_hw *hw,
				  unsigned int changed_flags,
				  unsigned int *total_flags, int mc_count,
				  struct dev_addr_list *mc_list)
{
	struct at76_priv *priv = hw->priv;

	at76_dbg(DBG_MAC80211, "%s(): changed_flags=0x%08x "
		 "total_flags=0x%08x mc_count=%d",
		 __func__, changed_flags, *total_flags, mc_count);

	*total_flags &= FIF_PROMISC_IN_BSS;

	if (changed_flags & FIF_PROMISC_IN_BSS) {
		/* FIXME: access to priv->promisc should be protected with
		 * priv->mtx, but it's impossible because this function
		 * needs to be atomic */
		priv->promisc = *total_flags & FIF_PROMISC_IN_BSS;
		queue_work(hw->workqueue, &priv->work_set_promisc);
	}

}


-- 
Kalle Valo
