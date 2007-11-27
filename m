Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:36816 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbXK0Cec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 21:34:32 -0500
Date: Tue, 27 Nov 2007 13:34:30 +1100
To: Michael Wu <flamingice@sourmilk.net>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	akpm@linux-foundation.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-11-20-01-45 Build Fail - net/wireless driver
Message-ID: <20071127023430.GA24243@bakeyournoodle.com> (sfid-20071127_023436_013467_35FF96F8)
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org> <4742DFC3.80305@linux.vnet.ibm.com> <20071127005950.GZ24243@bakeyournoodle.com> <200711262120.13218.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <200711262120.13218.flamingice@sourmilk.net>
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 26, 2007 at 09:20:08PM -0500, Michael Wu wrote:

> I would rather have a patch to temporarily not allow them to be built into the 
> kernel. (or only allow one at a time to be built as a module) There's no 
> issues when these drivers are compiled as modules.

Perhaps as below?
 
> It's mostly the rtl8225 radio tuning code that's similar. They're not exactly 
> the same though, so it'll be a bit messy to merge the usb rtl8225 radio 
> tuning and pci rtl8225 radio tuning code. However, I do think it'll be better 
> overall so the merger of that code is planned.

okay, the diff between the 2 drivers doesn't look too bad really, but as
you say it won't be trivial to merge them.
 
From: Tony Breeds <tony@bakeyournoodle.com>

Temporarily ensure that Realtek 8185 and 8187 can only be built as modules.

These two drivers share a number of common (global) functions.  While a better
long term solution is developed lets ensure that they are never built into
the kernel, to avoid symbol conflicts.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

---

 drivers/net/wireless/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 82e5de7..023dd9d 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -555,11 +555,13 @@ config USB_ZD1201
 config RTL8180
 	tristate "Realtek 8185 PCI support"
 	depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENTAL
+	depends on m
 	select EEPROM_93CX6
 
 config RTL8187
 	tristate "Realtek 8187 USB support"
 	depends on MAC80211 && USB && WLAN_80211 && EXPERIMENTAL
+	depends on m
 	select EEPROM_93CX6
 	---help---
 	  This is a driver for RTL8187 based cards.

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

