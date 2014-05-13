Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62222 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaEMGuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 02:50:00 -0400
Received: by mail-ie0-f173.google.com with SMTP id rp18so8111605iec.32
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2014 23:50:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53711646.1030909@openwrt.org>
References: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com>
	<20140507195435.GF20432@tuxdriver.com>
	<536A9479.8010201@openwrt.org>
	<20140512174910.GM17022@tuxdriver.com>
	<53711646.1030909@openwrt.org>
Date: Tue, 13 May 2014 08:50:00 +0200
Message-ID: <CANq1E4Seak3MoBVdQTV7afFHQWmir14DJCQe_knjhC8szp4EhA@mail.gmail.com> (sfid-20140513_085012_061479_C6AF5FD3)
Subject: Re: [ath9k-devel] [PATCH] ath9k: fix NULL-deref in
 hw_per_calibration() for ar9002
From: David Herrmann <dh.herrmann@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	ath9k-devel@venema.h4ckr.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, May 12, 2014 at 8:43 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> I looked into it again, the scenario where I assumed that this problem
> could occur didn't turn out to be true. I have no idea how this crash
> can occur.

The only path that can set ah->caldata to NULL is through:

ieee80211_hw_config()
  ath9k_htc_config()
    ath9k_htc_set_channel()
      ath9k_hw_reset()

This happens whenever IEEE80211_CONF_OFFCHANNEL is set.

Now mac80211 is way to big for me to review right now and
ieee80211_hw_config() is used quite often. Given that the described
call-path does no synchronization against ath9k_htc_ani_work(), all
the callers of mac80211_hw_config(OFFCHANNEL) must guarantee that no
ani-work is running. Is that intentional? I cannot see any of those
functions calling into ath9k_htc_stop_ani(). This might of course be
implicit.

One call-path I see is:
ieee80211_scan_cancel()
  cancel_delayed_work()

We cannot use cancel_delayed_work_sync() here due to locking issues.
However, this obviously races against any following
set_channel(OFFCHANNEL) request.

If there's anything I can do to debug this, let me know. I tried
adding some printk()'s into the hot-path and it turns out to no longer
fail then. So this really seems to be a quite small race (given that a
bunch of simple printk()s is slow enough to work around it).

Thanks
David
