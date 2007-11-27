Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36141 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753356AbXK0Czp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 21:55:45 -0500
Date: Mon, 26 Nov 2007 18:54:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: tony@bakeyournoodle.com (Tony Breeds)
Cc: Michael Wu <flamingice@sourmilk.net>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-11-20-01-45 Build Fail -
 net/wireless driver
Message-Id: <20071126185423.9280b263.akpm@linux-foundation.org> (sfid-20071127_025549_190917_3067B617)
In-Reply-To: <20071127023430.GA24243@bakeyournoodle.com>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
	<4742DFC3.80305@linux.vnet.ibm.com>
	<20071127005950.GZ24243@bakeyournoodle.com>
	<200711262120.13218.flamingice@sourmilk.net>
	<20071127023430.GA24243@bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 27 Nov 2007 13:34:30 +1100 tony@bakeyournoodle.com (Tony Breeds) wrote:

> On Mon, Nov 26, 2007 at 09:20:08PM -0500, Michael Wu wrote:
> 
> > I would rather have a patch to temporarily not allow them to be built into the 
> > kernel. (or only allow one at a time to be built as a module) There's no 
> > issues when these drivers are compiled as modules.
> 
> Perhaps as below?
>  
> > It's mostly the rtl8225 radio tuning code that's similar. They're not exactly 
> > the same though, so it'll be a bit messy to merge the usb rtl8225 radio 
> > tuning and pci rtl8225 radio tuning code. However, I do think it'll be better 
> > overall so the merger of that code is planned.
> 
> okay, the diff between the 2 drivers doesn't look too bad really, but as
> you say it won't be trivial to merge them.
>  
> From: Tony Breeds <tony@bakeyournoodle.com>
> 
> Temporarily ensure that Realtek 8185 and 8187 can only be built as modules.
> 
> These two drivers share a number of common (global) functions.  While a better
> long term solution is developed lets ensure that they are never built into
> the kernel, to avoid symbol conflicts.
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> 
> ---
> 
>  drivers/net/wireless/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index 82e5de7..023dd9d 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -555,11 +555,13 @@ config USB_ZD1201
>  config RTL8180
>  	tristate "Realtek 8185 PCI support"
>  	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
> +	depends on m
>  	select EEPROM_93CX6
>  
>  config RTL8187
>  	tristate "Realtek 8187 USB support"
>  	depends on MAC80211 && USB && WLAN_80211 && EXPERIMENTAL
> +	depends on m
>  	select EEPROM_93CX6
>  	---help---
>  	  This is a driver for RTL8187 based cards.
> 

<head spins>

Why not just rename one of them?

diff -puN drivers/net/wireless/rtl8187_dev.c~a drivers/net/wireless/rtl8187_dev.c
--- a/drivers/net/wireless/rtl8187_dev.c~a
+++ a/drivers/net/wireless/rtl8187_dev.c
@@ -764,7 +764,7 @@ static int __devinit rtl8187_probe(struc
 	if (rtl8225_read(dev, 8) != 0x588 || rtl8225_read(dev, 9) != 0x700)
 		priv->rf_init = rtl8225_rf_init;
 	else
-		priv->rf_init = rtl8225z2_rf_init;
+		priv->rf_init = rtl8187_rf_init;
 
 	rtl8225_write(dev, 0, 0x0B7);
 
diff -puN drivers/net/wireless/rtl8187_rtl8225.c~a drivers/net/wireless/rtl8187_rtl8225.c
--- a/drivers/net/wireless/rtl8187_rtl8225.c~a
+++ a/drivers/net/wireless/rtl8187_rtl8225.c
@@ -567,7 +567,7 @@ static const u8 rtl8225z2_gain_bg[] = {
 	0x63, 0x15, 0xc5  /* -66dBm */
 };
 
-void rtl8225z2_rf_init(struct ieee80211_hw *dev)
+void rtl8187_rf_init(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
diff -puN drivers/net/wireless/rtl8187_rtl8225.h~a drivers/net/wireless/rtl8187_rtl8225.h
--- a/drivers/net/wireless/rtl8187_rtl8225.h~a
+++ a/drivers/net/wireless/rtl8187_rtl8225.h
@@ -24,7 +24,7 @@ void rtl8225_write(struct ieee80211_hw *
 u16  rtl8225_read(struct ieee80211_hw *, u8 addr);
 
 void rtl8225_rf_init(struct ieee80211_hw *);
-void rtl8225z2_rf_init(struct ieee80211_hw *);
+void rtl8187_rf_init(struct ieee80211_hw *);
 void rtl8225_rf_stop(struct ieee80211_hw *);
 void rtl8225_rf_set_channel(struct ieee80211_hw *, int);
 
_

