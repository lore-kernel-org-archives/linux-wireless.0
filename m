Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47094 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933310AbcCIQos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 11:44:48 -0500
Date: Wed, 9 Mar 2016 22:14:33 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: kbuild test robot <lkp@intel.com>,
	"Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"kbuild-all@01.org" <kbuild-all@01.org>
Subject: Re: [PATCH v1 1/2] ath10k: Add support for ath10k_sta_statistics
 support
Message-ID: <20160309164433.GB10524@atheros-ThinkPad-T61> (sfid-20160309_174458_822315_E880DB46)
References: <201603091546.RFfnsS0y%fengguang.wu@intel.com>
 <87oaanr4g7.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87oaanr4g7.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 09, 2016 at 04:39:30PM +0000, Valo, Kalle wrote:
> kbuild test robot <lkp@intel.com> writes:
> 
> > Hi Mohammed,
> >
> > [auto build test ERROR on wireless-drivers-next/master]
> > [also build test ERROR on next-20160309]
> > [cannot apply to v4.5-rc7]
> > [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> >
> > url:    https://github.com/0day-ci/linux/commits/Mohammed-Shafi-Shajakhan/ath10k-Add-support-for-ath10k_sta_statistics-support/20160309-153522
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> > config: sparc64-allmodconfig (attached as .config)
> > reproduce:
> >         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # save the attached .config to linux build tree
> >         make.cross ARCH=sparc64 
> >
> > All errors (new ones prefixed by >>):
> >
> >    drivers/net/wireless/ath/ath10k/debugfs_sta.c: In function 'ath10k_sta_statistics':
> >>> drivers/net/wireless/ath/ath10k/debugfs_sta.c:51:2: error: implicit declaration of function 'ath10k_peer_stats_enabled' [-Werror=implicit-function-declaration]
> >      if (!ath10k_peer_stats_enabled(ar))

[shafi] this is due to the dependency patch in ath10k "ath10k: Enable debugfs
provision to enable Peer Stats feature"

> >      ^
> >>> drivers/net/wireless/ath/ath10k/debugfs_sta.c:54:7: error: 'struct station_info' has no member named 'rx_duration'
> >      sinfo->rx_duration = arsta->rx_duration;
> >           ^
> >>> drivers/net/wireless/ath/ath10k/debugfs_sta.c:55:27: error: 'NL80211_STA_INFO_RX_DURATION' undeclared (first use in this function)
> >      sinfo->filled |= 1ULL << NL80211_STA_INFO_RX_DURATION;
> >                               ^
> >    drivers/net/wireless/ath/ath10k/debugfs_sta.c:55:27: note: each undeclared identifier is reported only once for each function it appears in
> >    cc1: some warnings being treated as errors
> 
> This is expected as the patches depend on mac80211 patches.
>
[shafi] thanks Kalle !, yes correct .
