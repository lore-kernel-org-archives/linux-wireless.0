Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299Ab0AZA3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 19:29:31 -0500
Date: Mon, 25 Jan 2010 16:28:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>, stable@kernel.org,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Krister Svanlund <krister.svanlund@gmail.com>,
	bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 15089] New: Fail to get ethernet IP-adress
Message-Id: <20100125162835.6619e3f4.akpm@linux-foundation.org>
In-Reply-To: <bug-15089-10286@http.bugzilla.kernel.org/>
References: <bug-15089-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).



On Tue, 19 Jan 2010 14:35:03 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=15089

2.6.32.2 -> 2.6.32.3 regression.  Hence the regression is probably in
2.6.33-rc.

Looking through the changelog I'd be suspecting 


: commit 3815270b3107d31c8b7bd69461f0bb3c350ee25c
: Author: Gertjan van Wingerde <gwingerde@gmail.com>
: Date:   Mon Dec 14 20:33:55 2009 +0100
: 
:     rt2x00: Disable powersaving for rt61pci and rt2800pci.
:     
:     commit 93b6bd26b74efe46b4579592560f9f1cb7b61994 upstream.

Mainly because I didn't spot any other change to that driver.


Krister, are you able to apply this reversion patch to 2.6.32.3 and see
if it helps?

Thanks.


 drivers/net/wireless/rt2x00/rt2800lib.c |    6 ------
 drivers/net/wireless/rt2x00/rt61pci.c   |    5 -----
 2 files changed, 11 deletions(-)

diff -puN drivers/net/wireless/rt2x00/rt2800lib.c~revert-1 drivers/net/wireless/rt2x00/rt2800lib.c
--- a/drivers/net/wireless/rt2x00/rt2800lib.c~revert-1
+++ a/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2037,12 +2037,6 @@ int rt2800_probe_hw_mode(struct rt2x00_d
 	u16 eeprom;
 
 	/*
-	 * Disable powersaving as default on PCI devices.
-	 */
-	if (rt2x00_intf_is_pci(rt2x00dev))
-		rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
-
-	/*
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
diff -puN drivers/net/wireless/rt2x00/rt61pci.c~revert-1 drivers/net/wireless/rt2x00/rt61pci.c
--- a/drivers/net/wireless/rt2x00/rt61pci.c~revert-1
+++ a/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2535,11 +2535,6 @@ static int rt61pci_probe_hw_mode(struct 
 	unsigned int i;
 
 	/*
-	 * Disable powersaving as default.
-	 */
-	rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
-
-	/*
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
_


