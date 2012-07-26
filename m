Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:57233 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601Ab2GZQby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 12:31:54 -0400
Message-ID: <501170F2.3050300@net.t-labs.tu-berlin.de> (sfid-20120726_183157_075377_CF916324)
Date: Thu, 26 Jul 2012 18:31:46 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org,
	ilw@linux.intel.com, users@rt2x00.serialmonkey.com,
	b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	chunkeey@googlemail.com, buytenh@wantstofly.org, dsd@gentoo.org,
	coelho@ti.com, nbd@openwrt.org
Subject: Re: [PATCH v6] mac80211: Remove control.sta from struct ieee80211_tx_info
 and restructure tx-path
References: <1343318961-46933-1-git-send-email-thomas@net.t-labs.tu-berlin.de>  (sfid-20120726_180930_993025_AB3D0B96) <1343319453.4477.2.camel@jlt3.sipsolutions.net>  (sfid-20120726_181745_936314_D74A954D) <1343319579.4477.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343319579.4477.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Johannes Berg schrieb:

>>
>> /home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/tx.c: In
>> function ‘wl1271_skb_queue_head’:
>> /home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/tx.c:622:48:
>> warning: ‘hlid’ may be used uninitialized in this function
>> [-Wuninitialized]
> 
> Those changes make no sense anyway -- you should be able to pass the
> station pointer through if it previously used info->control.sta, instead
> of doing an (expensive) lookup.


This is the call path

in main.c ... INIT_WORK(&wl->tx_work, wl1271_tx_work);
 jumps to tx.c...wl1271_tx_work(struct work_struct *work)
  calls wl1271_tx_work(struct work_struct *work)
   calls wlcore_tx_work_locked(struct wl1271 *wl)
    calls wl1271_skb_queue_head()
     calls wl12xx_tx_get_hlid()
      calls wl12xx_tx_get_hlid_ap() .... where sta is needed.

But I could not find any point in the call path where I could grab the
sta pointer and pass it through. I will move the rcu into
wl12xx_tx_get_hlid_ap(), but I do not see any cheaper way here as using rcu.

Greetings Thomas


