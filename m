Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56659 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0IPOUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 10:20:00 -0400
Received: by pzk34 with SMTP id 34so342059pzk.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 07:19:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100916044933.GA30871@vasanth-laptop>
References: <1284560528-8934-1-git-send-email-vasanth@atheros.com>
 <AANLkTim5xPKBsitVut-74BNM9riL0C95Nqnyj7M5Bg87@mail.gmail.com> <20100916044933.GA30871@vasanth-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Sep 2010 07:19:39 -0700
Message-ID: <AANLkTim8xb3V_QpFm3BEx+W4PD6a3n+JRuZqPDkamtwu@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k: Fix regression in starting ANI after association
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 9:49 PM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> On Wed, Sep 15, 2010 at 09:51:43PM +0530, Luis R. Rodriguez wrote:
>> On Wed, Sep 15, 2010 at 7:22 AM, Vasanthakumar Thiagarajan
>> <vasanth@atheros.com> wrote:
>> > Author: Felix Fietkau <nbd@openwrt.org>
>> > Date:   Sat Jul 31 00:11:59 2010 +0200
>> >
>> >    ath9k: prevent calibration during off-channel activity
>> >
>> > The above patch checks for off-channel before starting ANI,
>> > but when the operating channel is set right after association,
>> > IEEE80211_CONF_OFFCHANNEL would be set as still local->tmp_channel
>> > is non-NULL. This would result in not starting calibration after
>> > the association.
>
> Yes, the bug is in mac80211, but fixing this one in mac80211 looks
> not straight forward and probably Felix would know this one better,
> for now let me do this in driver and remove it once it is cleanly
> fixed in mac80211.

No, please address in mac80211, if we clean this up as a work around
we likely are overlooking other possible issues which can be affected
as well.

  Luis
