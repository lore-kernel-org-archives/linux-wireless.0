Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63406 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759526Ab0I0RWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 13:22:04 -0400
Received: by pvg2 with SMTP id 2so1351839pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 10:22:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100922134927.GA18450@vasanth-laptop>
References: <1284560528-8934-1-git-send-email-vasanth@atheros.com>
 <AANLkTim5xPKBsitVut-74BNM9riL0C95Nqnyj7M5Bg87@mail.gmail.com>
 <20100916044933.GA30871@vasanth-laptop> <AANLkTim8xb3V_QpFm3BEx+W4PD6a3n+JRuZqPDkamtwu@mail.gmail.com>
 <20100922134927.GA18450@vasanth-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 27 Sep 2010 10:21:23 -0700
Message-ID: <AANLkTik3O2WK_ZUWN=bZu0nvfNq798erk9WTgotfwi+G@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k: Fix regression in starting ANI after association
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 22, 2010 at 6:49 AM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> On Thu, Sep 16, 2010 at 07:49:39PM +0530, Luis R. Rodriguez wrote:
>> On Wed, Sep 15, 2010 at 9:49 PM, Vasanthakumar Thiagarajan
>> <vasanth@atheros.com> wrote:
>> > On Wed, Sep 15, 2010 at 09:51:43PM +0530, Luis R. Rodriguez wrote:
>> >> On Wed, Sep 15, 2010 at 7:22 AM, Vasanthakumar Thiagarajan
>> >> <vasanth@atheros.com> wrote:
>> >> > Author: Felix Fietkau <nbd@openwrt.org>
>> >> > Date:   Sat Jul 31 00:11:59 2010 +0200
>> >> >
>> >> >    ath9k: prevent calibration during off-channel activity
>> >> >
>> >> > The above patch checks for off-channel before starting ANI,
>> >> > but when the operating channel is set right after association,
>> >> > IEEE80211_CONF_OFFCHANNEL would be set as still local->tmp_channel
>> >> > is non-NULL. This would result in not starting calibration after
>> >> > the association.
>> >
>> > Yes, the bug is in mac80211, but fixing this one in mac80211 looks
>> > not straight forward and probably Felix would know this one better,
>> > for now let me do this in driver and remove it once it is cleanly
>> > fixed in mac80211.
>>
>> No, please address in mac80211, if we clean this up as a work around
>> we likely are overlooking other possible issues which can be affected
>> as well.
>
> It is not easy (from my understanding at least) to fix this in
> mac80211 as the assumption of off-channel activity (IEEE80211_CONF_OFFCHANNEL)
> itself seems to be wrong sometimes (in case of station mode, setting this flag
> before the association does not look right). As I dont know any
> clean fix in mac80211, this patch can be an interim fix for the
> regression.

It was tricky indeed, mac80211 does use the offchannel operation to
associate as an atomic operation, the fix was to lif the offchannel
flag when we have already decided we are going to switch to it as our
home channel. Please try the patch "mac80211: fix offchannel
assumption upon association". Works for me.

  Luis
