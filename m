Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:42811 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1946088AbbEENu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 09:50:56 -0400
Message-ID: <1430833852.7191.7.camel@perches.com> (sfid-20150505_155122_051039_96FB8587)
Subject: Re: [PATCH] adm8211: fix checkpatch errors for indentation and new
 line around switch-case
From: Joe Perches <joe@perches.com>
To: Peter Rosin <peda@lysator.liu.se>
Cc: Okash Khawaja <okash.khawaja@gmail.com>, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Tue, 05 May 2015 06:50:52 -0700
In-Reply-To: <5548B192.8020808@lysator.liu.se>
References: <5548B192.8020808@lysator.liu.se>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-05-05 at 14:03 +0200, Peter Rosin wrote:
> > diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
[]
> > @@ -1098,14 +1098,18 @@ static void adm8211_hw_init(struct ieee80211_hw *dev)
> >  		pci_read_config_byte(priv->pdev, PCI_CACHE_LINE_SIZE, &cline);
> >  
> >  		switch (cline) {
[]
> > +		case  0x8:
> > +			reg |= (0x1 << 14);
> > +			break;
> > +		case 0x16:
> > +			reg |= (0x2 << 14);
> > +			break;
> > +		case 0x32:
> > +			reg |= (0x3 << 14);
> > +			break;
> > +		default:
> > +			reg |= (0x0 << 14);
> > +			break;
> >  		}
> >  	}
> >  
> 
> Those 0x16/0x32 hexadecimal case-selectors looking suspiciously like
> decimal bits need a comment if they are in fact correct, which I doubt.

Good spot.

As it's testing PCI_CACHE_LINE_SIZE,
they seem very much broken.


