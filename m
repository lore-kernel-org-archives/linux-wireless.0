Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46825 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaJ0SPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 14:15:11 -0400
Date: Mon, 27 Oct 2014 14:10:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	ath6kl@lists.infradead.org
Subject: Re: Pull request: ath 20141024
Message-ID: <20141027181010.GG28300@tuxdriver.com> (sfid-20141027_191519_287904_7E440EE4)
References: <87bnp1ofof.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87bnp1ofof.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2014 at 02:44:32PM +0300, Kalle Valo wrote:
> Hi John,
> 
> here are the latest ath10k patches plus a small logging change to ath6kl
> and wil6210. Unfortunately this time there's a small conflict in
> drivers/net/wireless/ath/wil6210/wil6210.h but luckily it's easy to fix.
> Here's an example how I propose to resolve it:
> 
> ----------------------------------------------------------------------
> #define wil_to_ndev(i) (wil_to_wdev(i)->netdev)
> #define ndev_to_wil(n) (wdev_to_wil(n->ieee80211_ptr))
> #define wil_to_pcie_dev(i) (&i->pdev->dev)
> 
> __printf(2, 3)
> void wil_dbg_trace(struct wil6210_priv *wil, const char *fmt, ...);
> __printf(2, 3)
> void wil_err(struct wil6210_priv *wil, const char *fmt, ...);
> __printf(2, 3)
> void wil_info(struct wil6210_priv *wil, const char *fmt, ...);
> #define wil_dbg(wil, fmt, arg...) do { \
> 	netdev_dbg(wil_to_ndev(wil), fmt, ##arg); \
> 	wil_dbg_trace(wil, fmt, ##arg); \
> } while (0)
> 
> #define wil_dbg_irq(wil, fmt, arg...) wil_dbg(wil, "DBG[ IRQ]" fmt, ##arg)
> #define wil_dbg_txrx(wil, fmt, arg...) wil_dbg(wil, "DBG[TXRX]" fmt, ##arg)
> ----------------------------------------------------------------------
> 
> I think a lesson learned here is that I should not apply patches which
> touch wil6210 and instead ask the submitter to split the patch. Sorry
> for this.
> 
> Here's a changelog for the pull request:
> 
> ----------------------------------------------------------------------
> Major changes are:
> 
> o ethtool support (Ben)
> 
> o print dev string prefix with debug hex buffers dump (Michal)
> 
> o debugfs file to read calibration data from the firmware verification
>   purposes (me)
> 
> o fix fw_stats debugfs file, now results are more reliable (Michal)
> 
> o firmware crash counters via debugfs (Ben&me)
> 
> o various tracing points to debug firmware (Rajkumar)
> 
> o make it possible to provide firmware calibration data via a file (me)
> 
> And we have quite a lot of smaller fixes and clean up.
> ----------------------------------------------------------------------
> 
> Please pull and let me know if you have any problems.
> 
> Kalle
> 
> ----------------------------------------------------------------------
> 
> The following changes since commit b25f32cb02155d68c690255ba846796a1c248fd3:
> 
>   ath10k: use ether_addr_copy() (2014-09-18 10:47:03 +0300)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git tags/for-linville-20141024
> 
> for you to fetch changes up to 84cbf3a7592879810f80cece6c7f736f099ab163:
> 
>   ath10k: split ce pipe init/alloc further (2014-10-23 16:41:32 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
