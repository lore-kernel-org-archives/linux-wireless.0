Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:15642 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931AbbLTTAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 14:00:21 -0500
Date: Sun, 20 Dec 2015 20:00:02 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Joe Perches <joe@perches.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] ath9k: fix ath9k_hw_nvram_check_version()
In-Reply-To: <1450637228.3430.30.camel@perches.com>
Message-ID: <alpine.DEB.2.02.1512201959090.2055@localhost6.localdomain6> (sfid-20151220_200040_339446_7C861E37)
References: <20151219105919.GB3749@mwanda> <1450637228.3430.30.camel@perches.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1604696573-1450638003=:2055"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1604696573-1450638003=:2055
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 20 Dec 2015, Joe Perches wrote:

> On Sat, 2015-12-19 at 13:59 +0300, Dan Carpenter wrote:
> > There is a type bug so it always returns success.
> 
> How many false positives do you have to sift
> through to find this sort of error?

The return type is thoughtfully bool, so it should be easy in this case.  
The function has a return -EINVAL and a return true, so even without the 
return type it would be locally apparent that there is an inconsistency.

julia

> 
> > +++ b/drivers/net/wireless/ath/ath9k/eeprom.c
> > @@ -206,7 +206,7 @@ bool ath9k_hw_nvram_check_version(struct ath_hw *ah, int version, int minrev)
> >  		ath_err(common, "Bad EEPROM VER 0x%04x or REV 0x%04x\n",
> >  			ah->eep_ops->get_eeprom_ver(ah),
> >  			ah->eep_ops->get_eeprom_rev(ah));
> > -		return -EINVAL;
> > +		return false;
> >  	}
> >  
> >  	return true;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1604696573-1450638003=:2055--
