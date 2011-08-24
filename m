Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61544 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab1HXUut (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 16:50:49 -0400
Subject: Re: [PATCH 00/60] update for 3.2
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110824182936.GI9770@tuxdriver.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20110824182936.GI9770@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 13:09:07 -0700
Message-ID: <1314216547.21077.5.camel@wwguy-huron> (sfid-20110824_225059_216712_EB3687C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-24 at 11:29 -0700, John W. Linville wrote:
> On Sat, Aug 13, 2011 at 10:37:36AM -0700, Wey-Yi Guy wrote:
> > We make a lot of changes to separate out the transport layer and bus layer
> > We also add a special SKU for 2000 series
> >
> > Daniel Halperin (1):
> >   iwlagn: fix compile warnings when CONFIG_PM_SLEEP is not set
> >
> > Emmanuel Grumbach (52):
> >   iwlagn: use iwl_get_debug_level instead of iwl_debug_level
> >   iwlagn: introduce iwl-shared.h
> >   iwlagn: introduce struct iwl-shared - known by all layers
> >   iwlagn: debug_level moves to struct iwl_shared
> >   iwlagn: hw_params moves to iwl_shared
> >   iwlagn: cmd_queue moves to iwl_shared
> >   iwlagn: workqueue moves to iwl_shared
> >   iwlagn: priv->lock moves to iwl_shared
> >   iwlagn: modify the debug macro to be usable by all the layers
> >   iwlagn: add IWL_DEBUG_FW_ERRORS
> >   iwlagn: priv->sta_lock moves to iwl_shared
> >   iwlagn: bus layer chooses its transport layer
> >   iwlagn: add comments to iwl_bus / iwl_trans
> >   iwlagn: transport handler can register debugfs entries
> >   iwlagn: iwl_rx_queue moves to the iwl_trans_pcie
> >   iwlagn: move iwl_suspend / iwl_resume to the transport layer
> >   iwlagn: move ISR related data to transport layer
> >   iwlagn: move the NIC error flow to the transport layer
> >   iwlagn: move isr_statistics to transport layer
> >   iwlagn: reclaim the packets in transport layer
> >   iwlagn: move reclaim related functions
> >   iwlagn: move scd_bc_tbls and scd_base_addr to iwl_trans_pcie
> >   iwlagn: fix the check of IWLAGN_FIRST_AMPDU_QUEUE
> >   iwlagn: move all iwl_is_XXX helpers to iwl-shared.h
> >   iwlagn: move iwl_free_pages to iwl-shared.h
> >   iwlagn: transport layer should receive iwl_trans
> >   iwlagn: move hcmd_lock to transport layer
> >   iwlagn: move dump_csr and dump_fh to transport layer
> >   iwlagn: remove references to priv from the transport layer
> >   iwlagn: remove unused parameters from hw_params
> >   iwlagn: iwl-dev.h doesn't include iwl-fh.h any more
> >   iwlagn: move Keep Warm to transport layer
> >   iwlagn: add missing includes
> >   iwlagn: iwl-pci doesn't include iwl-dev any more
> >   iwlagn: iwl_tid_data moves to iwl-shared
> >   iwlagn: stop the device before freeing it
> >   iwlagn: upper layer stores iwl_rxon_context in skb's CB
> >   iwlagn: set tx_fifo for ampdu in transport layer
> >   iwlagn: upper layer uses slabs to allocate tx cmds
> >   iwlagn: move the mapping ac to queue / fifo to transport
> >   iwlagn: allocate resources for TX BA session in transport
> >   iwlagn: move the check_empty logic to the transport layer
> >   iwlagn: move the disable agg logic to transport layer
> >   iwlagn: cosmetics in iwl-trans.h
> >   iwlagn: move wait_for_tx_queue_empty to transport layer
> >   iwlagn: move check_stuck_queue to transport layer
> >   iwlagn: move the stop / wake queue logic to transport layer
> >   iwlagn: move tx queues to transport layer
> >   iwlagn: priv->status moves to iwl_shared
> >   iwlagn: priv->mutex moves to iwl_shared
> >   iwlagn: all function iwl-io.c receive iwl_bus
> >   iwlagn: remove dereferences of priv from transport
> >
> > Wey-Yi Guy (7):
> >   iwlagn: Rename iwlcore prefix
> >   iwlagn: remove out-dated comments
> >   iwlagn: enable 11n aggregation without checking traffic load
> >   iwlagn: support small form factor SKU of 6205
> >   iwlagn: more comments for bt channel inhibition
> >   iwlagn: add comments to module parameters
> >   iwlagn: adding special "D" SKU for 2000 series
> >
> >
> > these patches are also available from wireless-next-2.6 branch on
> >  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
> 
> Hmmm...
> 
> /home/linville/git/wireless-next
> [linville-8530p.local]:> git pull git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git wireless-next-2.6
> From git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6
>  * branch            wireless-next-2.6 -> FETCH_HEAD
> Already up-to-date.
> 
> Yet, I don't seem to have the patches above.  No problem, I could just
> apply them directly...except that 2 of the first 10 patches failed
> to apply.  I tried to fix-up the first one, but the 2nd failure
> touched a line that didn't seem to exist in my tree!
> 
> I'm going to leave these 60 patches alone, and the one from Johannes
> for GO powersave.  Please try to straighten this out and post a new
> pull request at your convenience.
> 
hmm, I must miss something, :-(, I should know never get thing done
right when in a hurry :-(

I am on vacation in Taiwan this 2 weeks,so the response will be late,
but I will fix the problem and re-summit the request when I have the
chance.

Sorry for the mistake and thanks for let me know

Wey

