Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53801
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760538AbXHHWNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 18:13:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: arm allmodconfig
Date: Thu, 9 Aug 2007 00:13:06 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070808145705.756597b0.akpm@linux-foundation.org>
In-Reply-To: <20070808145705.756597b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708090013.06846.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 08 August 2007 23:57:05 Andrew Morton wrote:
> drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c:4038: error: implicit declaration of function `ssb_pcihost_register'
> drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c:4055: error: implicit declaration of function `ssb_pcihost_unregister'

I have no idea how this is possible.

bcm43xx_main.c:

#ifdef CONFIG_BCM43XX_MAC80211_PCI
	err = ssb_pcihost_register(&bcm43xx_pci_driver);
	if (err)
		goto err_dfs_exit;
#endif


bcm43xx Kconfig:

config BCM43XX_MAC80211_PCI
	bool "BCM43xx PCI device support"
	depends on BCM43XX_MAC80211 && PCI
	select SSB_PCIHOST
	select SSB_DRIVER_PCICORE


ssb Kconfig:

config SSB_PCIHOST
	bool "Support for SSB on PCI-bus host"
	depends on SSB && PCI


ssb function declaration:

#ifdef CONFIG_SSB_PCIHOST
/* PCI-host wrapper driver */
extern int ssb_pcihost_register(struct pci_driver *driver);
static inline void ssb_pcihost_unregister(struct pci_driver *driver)
{
	pci_unregister_driver(driver);
}
#endif /* CONFIG_SSB_PCIHOST */


So what is going on? CONFIG_BCM43XX_MAC80211_PCI must be enabled.
Otherwise the func call would be ifdef'ed out. So but if
it is enabled, it would SELECT SSB_PCIHOST. Which would enable
the declaration and definition of ssb_pcihost_register().
What am I missing?

-- 
Greetings Michael.
