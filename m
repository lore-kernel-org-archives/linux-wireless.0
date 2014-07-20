Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:34702 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaGTLuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 07:50:40 -0400
Received: by mail-oa0-f43.google.com with SMTP id i7so6013294oag.16
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 04:50:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140720132634.2cb9e916@wiggum>
References: <1405854022-11833-1-git-send-email-zajec5@gmail.com>
	<1405854022-11833-2-git-send-email-zajec5@gmail.com>
	<20140720132634.2cb9e916@wiggum>
Date: Sun, 20 Jul 2014 13:50:39 +0200
Message-ID: <CACna6rx-LFvQZrLmuQTm7B9wME9OmFBAf_qJPRio1D_hVzA1BQ@mail.gmail.com> (sfid-20140720_135042_668253_756A8761)
Subject: Re: [PATCH 2/2] b43: N-PHY: support setting custom TX power
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 July 2014 13:26, Michael Büsch <m@bues.ch> wrote:
> On Sun, 20 Jul 2014 13:00:22 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>> @@ -6656,5 +6721,4 @@ const struct b43_phy_operations b43_phyops_n = {
>>       .switch_channel         = b43_nphy_op_switch_channel,
>>       .get_default_chan       = b43_nphy_op_get_default_chan,
>>       .recalc_txpower         = b43_nphy_op_recalc_txpower,
>> -     .adjust_txpower         = b43_nphy_op_adjust_txpower,
>
> recalc_txpower once was designed to just recalculate the txpower and not write it
> to hardware. adjust_txpower was supposed to write it to hardware afterwards.
> That had to do with some locking foo and stuff I forgot (AFAIR these callbacks are called
> in different contexts, but I may be wrong).
> But I don't think it really matters. Just as a general hint here.

Yeah, I noticed that and was starring at it for a long time.

First of all I verified if @config is allowed to sleep. It is, so our
"recalc_txpower" can sleep as well if it needs to.

I think that using adjust_txpower on G-PHY could have something to do
with the way TX power is controlled on these devices. They don't have
hardware (firmware?) power control, so much more has to be done in the
driver. It's probably what Broadcom calls a "software" TX power
recalc. If you take a look at
[PATCH] Staging: Add initial release of brcm80211 - Broadcom 802.11n
wireless LAN driver.
you will see there was a wlc_phy_txpower_target_set with following calls:
wlc_phy_txpower_recalc_target(pi);
wlc_phy_cal_txpower_recalc_sw(pi);

The second was an empty function, most probably because Broadcom
stripped it our of G-PHY code before releasing.

In N-PHY world there are two registers for setting TX power: 0x1E7 and
0x222 (one per core) and two for reading current state: 0x1ED and
0x1EE. However you don't really touch them unless you're doing some
initialization/calibration. For most of the time hardware is supposed
to adjust TX power, you simply tell the firmware what should it be
(this is what 0x1EA register is for).

In G-PHY you were setting that manually, so you could indeed need some
hacks to avoid some conflict or sth. This should not be needed for
N-PHY.

-- 
Rafał
