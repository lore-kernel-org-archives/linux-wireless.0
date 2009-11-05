Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43297 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbZKEPpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 10:45:07 -0500
Date: Thu, 5 Nov 2009 10:33:29 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: Re: BUG: oops when "rmmod ipw2200"
Message-ID: <20091105153329.GB2817@tuxdriver.com>
References: <S1754043AbZKEPJ1/20091105150927Z+225@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <S1754043AbZKEPJ1/20091105150927Z+225@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 05, 2009 at 03:59:16PM +0100, Holger Schurig wrote:
> This happened on wireless-testing v2.6.32-rc6-41575-g5e68bfb. I
> modprobed ipw2200, put it into monitor mode, used tshark a while to
> monitor, then I stopped tshark, "ifconfig eth2 down" and finally
> "rmmod ipw2200", and voila:
> 
> [  917.189620] ------------[ cut here ]------------
> [  917.189717] kernel BUG at net/wireless/core.c:543!
> [  917.189805] invalid opcode: 0000 [#1] PREEMPT SMP
> [  917.190002] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:02:0d.0/firmware/0000:02:0d.0/loading
> [  917.190136] Modules linked in: lib80211_crypt_wep ipw2200(-) libipw lib80211 ath5k mac80211 ath cfg80211 psmouse uhci_hcd

<snip>

Crud...this has to be the following:

commit e6c5fc53d0f44a772398402ee8a1879818e42b4e
Author: Zhu Yi <yi.zhu@intel.com>
Date:   Thu Oct 15 14:50:28 2009 +0800

    ipw2200: fix oops on missing firmware
    
    For non-monitor interfaces, the syntax for alloc_ieee80211/free_80211
    is wrong. Because alloc_ieee80211 only creates (wiphy_new) a wiphy, but
    free_80211() does wiphy_unregister() also. This is only correct when
    the later wiphy_register() is called successfully, which apparently
    is not the case for your fw doesn't exist one.
    
    Signed-off-by: Zhu Yi <yi.zhu@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Can you revert that and attempt to recreate?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
