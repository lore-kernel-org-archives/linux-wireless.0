Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:33175 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaGXJgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 05:36:10 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCHv3-ath-resend 2/2] ath10k: add spectral scan feature
Date: Thu, 24 Jul 2014 11:36:07 +0200
Cc: ath10k@lists.infradead.org, mathias.kretschmer@fokus.fraunhofer.de,
	kgiori@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	sven@narfation.org
References: <87mwc0ro8i.fsf@kamboji.qca.qualcomm.com> <1406136773-19957-1-git-send-email-sw@simonwunderlich.de> <871ttbrtp8.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871ttbrtp8.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201407241136.08090.sw@simonwunderlich.de> (sfid-20140724_113614_901636_C200CCA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +ath10k_core-$(CPTCFG_ATH10K_DEBUGFS) += spectral.o
> 
> This one still uses CPTCFG_ prefix, I'll fix those.
> 

Argh, OK, thanks!

> > @@ -800,8 +800,6 @@ int ath10k_core_start(struct ath10k *ar)
> > 
> >  	else
> >  	
> >  		ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
> > 
> > -	INIT_LIST_HEAD(&ar->arvifs);
> > -
> > 
> >  	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags)) {
> >  	
> >  		ath10k_info("%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
> >  		
> >  			    ar->hw_params.name,
> > 
> > @@ -1084,6 +1082,12 @@ struct ath10k *ath10k_core_create(void *hif_priv,
> > struct device *dev,
> > 
> >  	INIT_WORK(&ar->register_work, ath10k_core_register_work);
> >  	INIT_WORK(&ar->restart_work, ath10k_core_restart);
> > 
> > +	INIT_LIST_HEAD(&ar->arvifs);
> 
> I'm a bit suspicious about this, why is it needed?

ath10k_spectral_init() clears the spectral_enabled bit for each vif, and 
therefore needs the list to be initialized ... it is also called on firmware 
crash by ath10k_halt, where checking the list is more useful.

Thanks,
    Simon
