Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:28491 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbYIUUFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 16:05:20 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1142713fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2008 13:05:18 -0700 (PDT)
Date: Mon, 22 Sep 2008 00:05:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arjan van de Ven <arjan@infradead.org>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com, jgarzik@pobox.com,
	linville@tuxdriver.com, davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware
	restart.
Message-ID: <20080921200518.GK7736@localhost> (sfid-20080921_220525_267076_BC2CF099)
References: <20080921172316.GA6306@2ka.mipt.ru> <20080921110422.1d010b96@infradead.org> <20080921182835.GA11473@2ka.mipt.ru> <20080921113513.16677c4e@infradead.org> <20080921190050.GA20484@2ka.mipt.ru> <1222024444.3023.53.camel@johannes.berg> <20080921193809.GA8735@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080921193809.GA8735@2ka.mipt.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Evgeniy Polyakov - Sun, Sep 21, 2008 at 11:38:09PM +0400]
| Hi.
| 
| On Sun, Sep 21, 2008 at 09:14:04PM +0200, Johannes Berg (johannes@sipsolutions.net) wrote:
| > > Do you want me to implement ipw2100 driver as a big work structure
| > > which will run ipw2100_init()/wait/ipw2100_exit() in a loop?
| > > And that will be the fix suggested by Intel? That would explain a lot.
| > 
| > I think what Arjan is saying is that it would be better to put pressure
| > on the responsible folks (I don't think Arjan is anywhere near them at
| 
| Both maintainers were added to the copy list.
| 
| > all) if you'd put in a WARN_ON() for this error and that would make the
| > top entry on kerneloops.org all the time... And additionally put in a
| > workaround for yourself for now.
| 
| As I pointed, I can rewrite the whole driver's initialization process,
| so that it looked like init/wait/exit loop, which can be processed at
| the module load and when fatal interrupt fires. Do this a fix? This is
| not even a remotely workaround. We can just add
| rmmod/modprobe/ifdown/ifup to the crontab job. Another users reported in
| bugzilla that they needed to reboot a machine to make card working
| again. I'm not sure that user tried to do a rmmod/modprobe though.
| 
| > And can we keep the flames off this list please? That comment from Wei
| > Weng was absolutely uncalled for, and inciting a flamewar (as you have
| > already blogged) was not really productive either.
| 
| If we will keep silence, no one will notice that problem exists.
| 
| I do hope this will result in a progress. Arjan, do you aggree to add
| this patch to the current tree?
| 
| diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
| index 19a401c..9a7b64c 100644
| --- a/drivers/net/wireless/ipw2100.c
| +++ b/drivers/net/wireless/ipw2100.c
| @@ -206,6 +206,8 @@ MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
|  
|  static u32 ipw2100_debug_level = IPW_DL_NONE;
|  
| +static int ipw2100_max_fatal_ints = 10;
| +
|  #ifdef CONFIG_IPW2100_DEBUG
|  #define IPW_DEBUG(level, message...) \
|  do { \
| @@ -3174,6 +3176,10 @@ static void ipw2100_irq_tasklet(struct ipw2100_priv *priv)
|  	if (inta & IPW2100_INTA_FATAL_ERROR) {
|  		printk(KERN_WARNING DRV_NAME
|  		       ": Fatal interrupt. Scheduling firmware restart.\n");
| +		WARN_ON(1);
| +
| +		BUG_ON(ipw2100_max_fatal_ints-- <= 0);
| +
|  		priv->inta_other++;
|  		write_register(dev, IPW_REG_INTA, IPW2100_INTA_FATAL_ERROR);
|  
| 
| 
| -- 
| 	Evgeniy Polyakov
| 

Since it's that serious maybe we should change

		IPW_DEBUG_INFO("%s: Fatal error value: 0x%08X\n",
			       priv->net_dev->name, priv->fatal_error);

to printk(KERN_WARN)? And here is why - as I see now we can't say what
exactly is wrong - Evgeniy said he has a suspicious about firmware so
this WARNS will be collected by Arjan thru kerneloops and we could not
ask users to change debug level and repost problem - oops will have it
by default - and if it really firmware problem - firmware engineers could
find this _additional_ info usefull and resolve it (probably).

		- Cyrill -
