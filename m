Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34961 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbaEHUQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 16:16:45 -0400
Received: by mail-ie0-f180.google.com with SMTP id as1so3004975iec.25
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2014 13:16:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140508181830.GA9859@qca.qualcomm.com>
References: <1399447378-31503-1-git-send-email-dh.herrmann@gmail.com>
	<20140508181830.GA9859@qca.qualcomm.com>
Date: Thu, 8 May 2014 22:16:44 +0200
Message-ID: <CANq1E4TJdiwRM4i1_CSEynPdDHRUxajuc5EwCt1AJvYH_GfXwQ@mail.gmail.com> (sfid-20140508_221650_042352_A142529E)
Subject: Re: [PATCH] ath9k: fix NULL-deref in hw_per_calibration() for ar9002
From: David Herrmann <dh.herrmann@gmail.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qti.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Oleksij Rempel <linux@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Thu, May 8, 2014 at 8:18 PM, Rajkumar Manoharan
<rmanohar@qti.qualcomm.com> wrote:
> On Wed, May 07, 2014 at 09:22:58AM +0200, David Herrmann wrote:
>> ah->caldata may be NULL if no channel is selected. Check for that before
>> accessing it.
>>
>> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>> ---
>> Hi
>>
>> This is _definitely_ only a workaround, given that no-one guarantees ah->caldata
>> is freed while we run in hw_per_calibration(). However, this patch fixes serious
>> kernel panics with wifi-P2P on my machine.
>>
>> I'm not sure why ah->caldata can be NULL, but it definitely is. I think the
>> correct fix would be to synchronously stop any running hw-calibration before
>> setting ah->caldata to NULL. I don't know whether/where that is done, so I wrote
>> this small workaround.
>>
> David,
>
> Whenever the DUT is moving to off-channel, ah->caldata is set to NULL in
> hw_reset. As you mentioned, before doing hw_reset, the on-going calibration is stopped
> synchronously. I using ar9280 for p2p (GO & CLI) validation. Somehow i do not observe
> the panics. Is there a easiest way to reproduce the problem. Are you
> using wireless-testing tree? Thanks for reporting the problem. Will try
> to fix asap.

Reproducing it is actually quite easy on my machine. Whenever I start
a P2P-connect from my Android-phone to my linux-host and _immediately_
accept it (via p2p_connect on wpas), I get the kernel-panic. Adding
the NULL-protection fixes this.

However, if I delay accepting the connection (ie, issuing p2p_connect
by hand instead of automatically), I cannot see the bug. Furthermore,
on my slower Intel Core 2 Duo, the bug happens much less likely. On my
ARM machine I never saw this happening. Given that my main machine is
an Intel hsw quad-core, I guess it's a simple race-condition.

I also added a printk() whenever caldata is NULL and noticed that it
fires only during the first 2 or 3 runs. After that, it never happened
again.

The bug happens on all linux kernels I tested (starting with 3.9ish up
to linux-next). However, if I apply my fix, anything after 3.13-stable
fails to transmit DHCP data. I can connect properly but DHCP always
times out. I'm not sure why that happens and I'm still debugging this,
but it's quite likely a separate issue. (if I find some time, I will
bisect this)

I now looked at the ath9k code and I couldn't see any locking around
the hw_reset at all. I don't know whether the wifi-core / nl80211
locks this, but what happens if two hw_resets race each other? Just a
guess.. I will try to look into it tomorrow.

Thanks
David
