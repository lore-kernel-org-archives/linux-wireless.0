Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:60086 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbXKLE1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 23:27:42 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IrQth-0006GN-4n
	for linux-wireless@vger.kernel.org; Sun, 11 Nov 2007 23:27:41 -0500
Subject: Re: Linux wireless compatibility package for kernels >= 2.6.22
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <43e72e890711101953w6e046b82j6b9087d30c8195b2@mail.gmail.com>
References: <43e72e890711101953w6e046b82j6b9087d30c8195b2@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 11 Nov 2007 23:27:38 -0500
Message-Id: <1194841658.2276.8.camel@dv> (sfid-20071112_042749_403684_1D224BA8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

On Sat, 2007-11-10 at 22:53 -0500, Luis R. Rodriguez wrote:
> I've started a compatibility package for the Linux wireless subsystem
> for kernels >= 2.6.22. You can download it here:
> 
> http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2

I would prefer that you use exactly the same path for all drivers, so
that the patches are compatible.  Wireless drivers should be in
drivers/net/wireless.

Also, I cannot compile it against current wireless-2.6/everything
compiled outside the source tree:

/home/proski/src/compat-wireless-2.6/drivers/iwlwifi/iwl-3945-rs.c:40:40: error: ../mac80211/ieee80211_rate.h: No such file or directory

After some hack to make it compile, I still get:

  CC [M]  /home/proski/src/compat-wireless-2.6/mac80211/ieee80211.o
/home/proski/src/compat-wireless-2.6/mac80211/ieee80211.c:24:6: warning:
"LINUX_VERSION_CODE" is not defined
/home/proski/src/compat-wireless-2.6/mac80211/ieee80211.c:24:28:
warning: "KERNEL_VERSION" is not defined
/home/proski/src/compat-wireless-2.6/mac80211/ieee80211.c:24:42: error:
missing binary operator before token "("

-- 
Regards,
Pavel Roskin

