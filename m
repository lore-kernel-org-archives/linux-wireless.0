Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35594 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2K2Nvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 08:51:37 -0500
Date: Thu, 29 Nov 2012 07:51:20 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Fengguang Wu <fengguang.wu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: kbuild@01.org, Julia Lawall <julia.lawall@lip6.fr>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [wireless-next:master 207/237]
 drivers/net/wireless/brcm80211/brcmsmac/dma.c:352:20-24: ERROR: di is NULL
 but dereferenced.
Message-ID: <20121129135120.GA29726@thinkpad-t410> (sfid-20121129_145142_869088_47D32A77)
References: <50b6477a.KNKuUJi++FBSGGYg%fengguang.wu@intel.com>
 <20121129011337.GA5785@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121129011337.GA5785@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 29, 2012 at 09:13:37AM +0800, Fengguang Wu wrote:
> Hi Seth,
> 
> FYI, there are coccinelle warnings in
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
> head:   0751f8654602e4255f0b9c17784d8100d5896010
> commit: 90123e045cac4ce8ec13e266f030c618fa674554 [207/237] brcmsmac: Add brcms_dbg_dma() debug macro
> 
> + drivers/net/wireless/brcm80211/brcmsmac/dma.c:352:20-24: ERROR: di is NULL but dereferenced.
> 
> vim +352 drivers/net/wireless/brcm80211/brcmsmac/dma.c
> 
> 5b435de0 Arend van Spriel 2011-10-05  336  
> 5b435de0 Arend van Spriel 2011-10-05  337  static uint ntxdactive(struct dma_info *di, uint h, uint t)
> 5b435de0 Arend van Spriel 2011-10-05  338  {
> 5b435de0 Arend van Spriel 2011-10-05  339  	return txd(di, t-h);
> 5b435de0 Arend van Spriel 2011-10-05  340  }
> 5b435de0 Arend van Spriel 2011-10-05  341  
> 5b435de0 Arend van Spriel 2011-10-05  342  static uint nrxdactive(struct dma_info *di, uint h, uint t)
> 5b435de0 Arend van Spriel 2011-10-05  343  {
> 5b435de0 Arend van Spriel 2011-10-05  344  	return rxd(di, t-h);
> 5b435de0 Arend van Spriel 2011-10-05  345  }
> 5b435de0 Arend van Spriel 2011-10-05  346  
> 5b435de0 Arend van Spriel 2011-10-05  347  static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
> 5b435de0 Arend van Spriel 2011-10-05  348  {
> ae8e4672 Arend van Spriel 2011-10-29  349  	uint dmactrlflags;
> 5b435de0 Arend van Spriel 2011-10-05  350  
> 5b435de0 Arend van Spriel 2011-10-05  351  	if (di == NULL) {
> 90123e04 Seth Forshee     2012-11-15 @352  		brcms_dbg_dma(di->core, "NULL dma handle\n");
> 5b435de0 Arend van Spriel 2011-10-05  353  		return 0;
> 5b435de0 Arend van Spriel 2011-10-05  354  	}

Hi Fengguang,

Yep, that's obviously wrong. Thanks for the bug report.

John, here's a fix. There's no way to have a debug message if di is
NULL, so I've just removed it. Obviously I've never hitting that
condition anyway.

Seth


>From b0d7b62345e5b32b4022278f238296f5bdf06e8a Mon Sep 17 00:00:00 2001
From: Seth Forshee <seth.forshee@canonical.com>
Date: Thu, 29 Nov 2012 07:36:00 -0600
Subject: [PATCH] brcmsmac: Fix possible NULL pointer dereference in
 _dma_ctrlflags()

There's a debug message to warn if this function is passed a NULL
pointer, but in order to print the message we have to dereference the
pointer. Obviously this isn't a good idea, so remove the message.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 511e457..1860c57 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -349,10 +349,8 @@ static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 {
 	uint dmactrlflags;
 
-	if (di == NULL) {
-		brcms_dbg_dma(di->core, "NULL dma handle\n");
+	if (di == NULL)
 		return 0;
-	}
 
 	dmactrlflags = di->dma.dmactrlflags;
 	dmactrlflags &= ~mask;
-- 
1.7.9.5

