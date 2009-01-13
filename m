Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web57611.mail.re1.yahoo.com ([66.196.100.93]:38870 "HELO
	web57611.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752089AbZAMDNA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 22:13:00 -0500
References: <326502.74480.qm@web57615.mail.re1.yahoo.com> <1231528324.30298.14.camel@rc-desk> <960943.33934.qm@web57604.mail.re1.yahoo.com> <20090112183808.GA8485@sortiz.org>
Date: Mon, 12 Jan 2009 19:12:59 -0800 (PST)
From: Deuce <the_deuce@yahoo.com>
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
To: Samuel Ortiz <samuel@sortiz.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <614533.26753.qm@web57611.mail.re1.yahoo.com> (sfid-20090113_041307_409298_122F45C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>





----- Original Message ----
> From: Samuel Ortiz <samuel@sortiz.org>
> To: Deuce <the_deuce@yahoo.com>
> Cc: reinette chatre <reinette.chatre@intel.com>; "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
> Sent: Monday, January 12, 2009 1:38:08 PM
> Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
> 
> Hi Jason,
> 
> On Fri, Jan 09, 2009 at 03:07:01PM -0800, Deuce wrote:
> > > From: reinette chatre 
> > 
> > > On Thu, 2009-01-08 at 19:28 -0800, Deuce wrote:
> > > > Kernel BUG in iwl3945 with 20090107 wireless-testing and firmware 
> 15.28.2.8  
> > > The Microcode SW error detected seems to be the beginning of the end.  An 
> > > attempt with Ubuntu's distributed iwlwifi-3945-1.ucode firmware was not 
> > > successful either (I do not know the version).
> > > > 
> > > > The BUG happens a short period after logging in when Netmanager starts to 
> scan 
> > > and attempt to associate.  Association never completes.
> > > > 
> > > > Curiously, the bug was not triggered the first time I finally booted up 
> with 
> > > iwl3945 debug=0x43fff and netconsole functioning.  However it was 
> immediately 
> > > triggered on a subsequent reboot.  The first try may have been a warm reboot 
> vs. 
> > > a cold reboot.
> > > > 
> > > > Below is the dmesg output without debug.  Attached is a full dmesg output 
> with 
> > > debug=0x43fff.
> > > 
> > > There appears to be a few things going on here. I am still investigating
> > > the firmware error, but we could start with something that will not let
> > > your machine crash and get us some more information about one of the
> > > issues.
> > > 
> > > Could you please try with this patch? Please do run your test with
> > > debugging enabled as you have done before. Thank you very much.
> > > 
> > > diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c 
> > > b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > > index a23d51d..09c1c8d 100644
> > > --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > > +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > > @@ -3118,7 +3118,14 @@ static void iwl3945_tx_cmd_complete(struct iwl_priv 
> > > *priv,
> > >     int cmd_index;
> > >     struct iwl_cmd *cmd;
> > > 
> > > -    BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
> > > +    if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
> > > +         "wrong command queue %d, sequence 0x%X readp=%d writep=%d\n",
> > > +          txq_id, sequence,
> > > +          priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
> > > +          priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
> > > +        iwl_print_hex_dump(priv, IWL_DL_INFO , rxb, 32);
> > > +        return;
> > > +    }
> > > 
> > >     cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
> > >     cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
> > 
> > New log attached.  Only the above patch was applied to the previous code base.
> It seems you can easily reproduce this bug, but unfortunately we can't.
> Would you be able to run a code bisection on this one ? Can you try if commit
> cbd8b90ffd8a321ffb2a705733729f0d5ebb20f9 is working for you ? If that's so,
> that should let you bisect quite quickly.

First off, cbd8b90ffd8a321ffb2a705733729f0d5ebb20f9 worked fine.

I ran through the git bisect as you can see below.  However, the original BUG_ON was not triggered.  Instead, I encountered authentication time outs with my unencrypted AP.  This made the nominally straightforward good/bad bisect question a little more interesting.  When the BUG_ON was triggered, authentication did not complete either, so take for what it's worth.

Was the restriction of git bisect to drivers/net/wireless/iwlwifi a bad idea?

I'll look into actually triggering the BUG_ON proper.

Jason

$ git bisect log 
# bad: [10bc72100559eae0e27f111be96b5e4afd07a1dc] p54: power save management
# good: [cbd8b90ffd8a321ffb2a705733729f0d5ebb20f9] iwl3945: iwl3945_queue and iwl3945_channel_info replacement
git-bisect start 'master-2009-01-06' 'cbd8b90ffd8a321ffb2a705733729f0d5ebb20f9' '--' 'drivers/net/wireless/iwlwifi/'
# good: [a0dedce20b4db9e6a7200eacb4d10fc3ee4c1b6b] iwlwifi: replace IWL_ERROR with IWL_ERR
git-bisect good a0dedce20b4db9e6a7200eacb4d10fc3ee4c1b6b
# skip: [9bfb965e2826a3cc2f6abbefe59b9c3e8f0a8294] iwl3945: use iwl_get_hw_mode
# ***  authentication timed out
git-bisect skip 9bfb965e2826a3cc2f6abbefe59b9c3e8f0a8294
# bad: [ba95810656873203d14f6274f1aa73ad0b42cffe] iwl3945: release resources before shutting down
# ***  authentication timed out
git-bisect bad ba95810656873203d14f6274f1aa73ad0b42cffe
# bad: [b5e33e433937e7525c6e6102ff9b2c47c0bf8d5a] iwl3945: add load ucode op
# ***  authentication timed out
git-bisect bad b5e33e433937e7525c6e6102ff9b2c47c0bf8d5a
# bad: [259fc66b6afeb2f10bb86c7fbef541981a3216c9] iwl3945: use iwl_mod_params for 3945
# ***  authentication timed out
git-bisect bad 259fc66b6afeb2f10bb86c7fbef541981a3216c9
# good: [bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d] iwlwifi: use iwl_cmd instead of iwl3945_cmd
git-bisect good bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d


259fc66b6afeb2f10bb86c7fbef541981a3216c9 is first bad commit
commit 259fc66b6afeb2f10bb86c7fbef541981a3216c9
Author: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>
Date:   Fri Dec 19 10:37:35 2008 +0800

    iwl3945: use iwl_mod_params for 3945
    
    Use iwl_mod_params for 3945.
    
    Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
    Signed-off-by: Zhu Yi <yi.zhu@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

:040000 040000 13a738ff0a9b89db4838c70937f32a6434a0384f 32eabfca375a07a548cf3b4323d1edb550474d4f M    drivers


      
