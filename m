Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42978 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab0GVLKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 07:10:05 -0400
Received: by fxm14 with SMTP id 14so4182880fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 04:10:02 -0700 (PDT)
Date: Thu, 22 Jul 2010 13:09:33 +0200
From: Dan Carpenter <error27@gmail.com>
To: nbd@openwrt.org
Cc: linux-wireless@vger.kernel.org
Subject: potential null deref in minstrel_ht_update_caps()?
Message-ID: <20100722110933.GA17585@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a smatch thing.

net/mac80211/rc80211_minstrel_ht.c +639 minstrel_ht_update_caps(15)
	warn: variable dereferenced before check 'sta'
   631          struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
   632          struct ieee80211_local *local = hw_to_local(mp->hw);
   633          u16 sta_cap = sta->ht_cap.cap;
                              ^^^^^^^^^^^^^^^
	Dereferenced here.

   634          int ack_dur;
   635          int stbc;
   636          int i;
   637
   638          /* fall back to the old minstrel for legacy stations */
   639          if (sta && !sta->ht_cap.ht_supported) {
                    ^^^
	Checked here.

   640                  msp->is_ht = false;
   641                  memset(&msp->legacy, 0, sizeof(msp->legacy));

It seems like a bug, but I'm not sure how to deal with it.

regards,
dan carpenter
