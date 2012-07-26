Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2GZQRm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 12:17:42 -0400
Message-ID: <1343319453.4477.2.camel@jlt3.sipsolutions.net> (sfid-20120726_181745_936314_D74A954D)
Subject: Re: [PATCH v6] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org,
	ilw@linux.intel.com, users@rt2x00.serialmonkey.com,
	b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	chunkeey@googlemail.com, buytenh@wantstofly.org, dsd@gentoo.org,
	coelho@ti.com, nbd@openwrt.org
Date: Thu, 26 Jul 2012 18:17:33 +0200
In-Reply-To: <1343318961-46933-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120726_180930_993025_AB3D0B96)
References: <1343318961-46933-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 (sfid-20120726_180930_993025_AB3D0B96)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-26 at 18:09 +0200, Thomas Huehn wrote:
> The pointer control.sta is removed from ieee80211_tx_info to free up
> sufficient memory in SKB_CB on the tx-path to enable new annotations
> per data packet e.g.support of upcoming Transmit Power Control (TPC).
> Now the control.sta pointer is put on the stack where passed as
> function parameter to the .tx equivalent (ieee80211_ops) of each
> affected wireless driver.
> Therefore a new structure ieee80211_tx_control is added to mac80211.h
> which holds the sta structure instead. The tx-path of all affected
> drivers is restructured to respect the chaneges.

*sigh*

/home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/tx.c: In
function ‘wl1271_skb_queue_head’:
/home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/tx.c:622:48:
warning: ‘hlid’ may be used uninitialized in this function
[-Wuninitialized]
/home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/tx.c: In
function ‘wlcore_tx_work_locked’:
/home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/tx.c:391:47:
warning: ‘hlid’ may be used uninitialized in this function
[-Wuninitialized]
/home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/tx.c:351:5:
note: ‘hlid’ was declared here


johannes

