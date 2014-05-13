Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:50171 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759833AbaEMJJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 05:09:49 -0400
Received: by mail-ig0-f181.google.com with SMTP id h3so132206igd.8
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2014 02:09:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140513090056.GA31546@qca.qualcomm.com>
References: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com>
	<20140507195435.GF20432@tuxdriver.com>
	<536A9479.8010201@openwrt.org>
	<20140512174910.GM17022@tuxdriver.com>
	<53711646.1030909@openwrt.org>
	<CANq1E4Seak3MoBVdQTV7afFHQWmir14DJCQe_knjhC8szp4EhA@mail.gmail.com>
	<20140513090056.GA31546@qca.qualcomm.com>
Date: Tue, 13 May 2014 11:09:48 +0200
Message-ID: <CANq1E4QY+mSeMJx0ctWvAdmrsONCFaD+6268HnuowMKOM2FdFQ@mail.gmail.com> (sfid-20140513_110957_930539_187BA736)
Subject: Re: [ath9k-devel] [PATCH] ath9k: fix NULL-deref in
 hw_per_calibration() for ar9002
From: David Herrmann <dh.herrmann@gmail.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	ath9k-devel@venema.h4ckr.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qti.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, May 13, 2014 at 11:00 AM, Rajkumar Manoharan
<rmanohar@qti.qualcomm.com> wrote:
> On Tue, May 13, 2014 at 08:50:00AM +0200, David Herrmann wrote:
>> Hi
>>
>> On Mon, May 12, 2014 at 8:43 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> > I looked into it again, the scenario where I assumed that this problem
>> > could occur didn't turn out to be true. I have no idea how this crash
>> > can occur.
>>
>> The only path that can set ah->caldata to NULL is through:
>>
>> ieee80211_hw_config()
>>   ath9k_htc_config()
>>     ath9k_htc_set_channel()
>>       ath9k_hw_reset()
>>
>> This happens whenever IEEE80211_CONF_OFFCHANNEL is set.
>>
>> Now mac80211 is way to big for me to review right now and
>> ieee80211_hw_config() is used quite often. Given that the described
>> call-path does no synchronization against ath9k_htc_ani_work(), all
>> the callers of mac80211_hw_config(OFFCHANNEL) must guarantee that no
>> ani-work is running. Is that intentional? I cannot see any of those
>> functions calling into ath9k_htc_stop_ani(). This might of course be
>> implicit.
>>
>> One call-path I see is:
>> ieee80211_scan_cancel()
>>   cancel_delayed_work()
>>
>> We cannot use cancel_delayed_work_sync() here due to locking issues.
>> However, this obviously races against any following
>> set_channel(OFFCHANNEL) request.
>>
>> If there's anything I can do to debug this, let me know. I tried
>> adding some printk()'s into the hot-path and it turns out to no longer
>> fail then. So this really seems to be a quite small race (given that a
>> bunch of simple printk()s is slow enough to work around it).
>
> David,
>
> Are you using USB devices? What is the PID/VID? I have not looked at
> HTC driver perspective.

Yes, I'm using the htc driver. I thought that was clear by pointing at
ar9002, but I was wrong, sorry. lsusb information is:
  'Bus 003 Device 056: ID 0411:017f BUFFALO INC. (formerly MelCo.,
Inc.) Sony UWA-BR100 802.11abgn Wireless Adapter [Atheros
AR7010+AR9280]'

Thanks
David
