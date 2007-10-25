Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:51397 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbXJYNJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:09:39 -0400
Date: Thu, 25 Oct 2007 15:09:38 +0200
To: Ian Schram <ischram@telenet.be>
Cc: wireless <linux-wireless@vger.kernel.org>,
	Ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [RFC][PATCH] iwlwifi using mac80211_leds
Message-ID: <20071025130938.GA31342@gamma.logic.tuwien.ac.at> (sfid-20071025_140943_854178_CCCCFEDF)
References: <47164DA9.3050001@telenet.be> <471E92FC.1000305@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <471E92FC.1000305@telenet.be>
From: Norbert Preining <preining@logic.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mi, 24 Okt 2007, Ian Schram wrote:
> This is the second version of this patch with a few several bugfixes,
> please test this one instead. I also included a 4965 part to the patch

Hmm, patching onto 2.6.24-rc1 does work without problems, but
configuring not:
	scripts/kconfig/conf -o arch/i386/Kconfig
	drivers/net/wireless/iwlwifi/Kconfig:131: invalid option
	make[1]: *** [oldconfig] Error 1
Must be this part:

> --- a/drivers/net/wireless/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/iwlwifi/Kconfig
> @@ -126,3 +126,9 @@ config IWL3945
>  	  inserted in and remvoed from the running kernel whenever you want),
>  	  say M here and read <file:Documentation/modules.txt>.  The module
>  	  will be called iwl3945.ko.
> +config IWLWIFI_LEDS
> +	bool	"IWLWIFI leds"
> +	depends IWLWIFI && MAC80211_LEDS	
> +	default y
> +	---help---
> +	This options enables the wireless led.	

I though all necessary changes are in -rc1 already, what else do I need?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
Aaaargggh...'
These two words are usually coupled together in the Old
Pink Dog Bar.
                 --- Ford in a spot of bother.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
