Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:46444 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750973AbZALSfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 13:35:38 -0500
Date: Mon, 12 Jan 2009 19:38:08 +0100
From: Samuel Ortiz <samuel@sortiz.org>
To: Deuce <the_deuce@yahoo.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
Message-ID: <20090112183808.GA8485@sortiz.org> (sfid-20090112_193542_054268_21642E29)
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <326502.74480.qm@web57615.mail.re1.yahoo.com> <1231528324.30298.14.camel@rc-desk> <960943.33934.qm@web57604.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <960943.33934.qm@web57604.mail.re1.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jason,

On Fri, Jan 09, 2009 at 03:07:01PM -0800, Deuce wrote:
> > From: reinette chatre <reinette.chatre@intel.com>
> 
> > On Thu, 2009-01-08 at 19:28 -0800, Deuce wrote:
> > > Kernel BUG in iwl3945 with 20090107 wireless-testing and firmware 15.28.2.8  
> > The Microcode SW error detected seems to be the beginning of the end.  An 
> > attempt with Ubuntu's distributed iwlwifi-3945-1.ucode firmware was not 
> > successful either (I do not know the version).
> > > 
> > > The BUG happens a short period after logging in when Netmanager starts to scan 
> > and attempt to associate.  Association never completes.
> > > 
> > > Curiously, the bug was not triggered the first time I finally booted up with 
> > iwl3945 debug=0x43fff and netconsole functioning.  However it was immediately 
> > triggered on a subsequent reboot.  The first try may have been a warm reboot vs. 
> > a cold reboot.
> > > 
> > > Below is the dmesg output without debug.  Attached is a full dmesg output with 
> > debug=0x43fff.
> > 
> > There appears to be a few things going on here. I am still investigating
> > the firmware error, but we could start with something that will not let
> > your machine crash and get us some more information about one of the
> > issues.
> > 
> > Could you please try with this patch? Please do run your test with
> > debugging enabled as you have done before. Thank you very much.
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c 
> > b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > index a23d51d..09c1c8d 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > @@ -3118,7 +3118,14 @@ static void iwl3945_tx_cmd_complete(struct iwl_priv 
> > *priv,
> >     int cmd_index;
> >     struct iwl_cmd *cmd;
> > 
> > -    BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
> > +    if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
> > +         "wrong command queue %d, sequence 0x%X readp=%d writep=%d\n",
> > +          txq_id, sequence,
> > +          priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
> > +          priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
> > +        iwl_print_hex_dump(priv, IWL_DL_INFO , rxb, 32);
> > +        return;
> > +    }
> > 
> >     cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
> >     cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
> 
> New log attached.  Only the above patch was applied to the previous code base.
It seems you can easily reproduce this bug, but unfortunately we can't.
Would you be able to run a code bisection on this one ? Can you try if commit
cbd8b90ffd8a321ffb2a705733729f0d5ebb20f9 is working for you ? If that's so,
that should let you bisect quite quickly.

Thanks in advance for your time.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
