Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f170.google.com ([209.85.210.170]:43094 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab3CXSzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Mar 2013 14:55:45 -0400
Received: by mail-ia0-f170.google.com with SMTP id h8so4964789iaa.15
        for <linux-wireless@vger.kernel.org>; Sun, 24 Mar 2013 11:55:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmok-iP+=6EK+mG+jqnEPY2gPLhypjcGKxceEvy=EG59Ngw@mail.gmail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
 <CAMgrJ3YQ5oua0MJvmVcbb-GuQ8Rr5vwAO3Jy1vs0w-VRRDdcMg@mail.gmail.com>
 <CAJ-VmomnvMqc_0sKvmL-_OQY4cm5xKjqfeWXs_jfUsvFtK9YcQ@mail.gmail.com>
 <CAMgrJ3bvJ-XwBGVcWuUGGyqAoJbjRFZz=om5dsG6MecRAYRO7g@mail.gmail.com>
 <CAJ-VmonzUE9uFN=tDfMXVF-b1Vk3c_+ZTWiGZKPgw8Vnwwadgw@mail.gmail.com>
 <CAMgrJ3ZHRMxzzxf0pj5zc+1TeWkfT2RPwL82JSkTU=AsYnXwfg@mail.gmail.com>
 <CAJ-VmomRvj2hf0i6AMJzCiR42thmTUQ=QCe7FX0k3tw1DTbkoQ@mail.gmail.com>
 <CAMgrJ3YCryn2VvtZJbJSVFUT61TQYPXw+cOXnJQN8Jab-rSuKA@mail.gmail.com>
 <CAMgrJ3b-_a5aBDjAMPChnxEWobnYOhXX3y_FwfNwF75u4hHD6A@mail.gmail.com>
 <CAJ-VmombhTgTaFuQXWR1Q4M8Awg4CwFseDu+iN_U6GfBDUaCig@mail.gmail.com>
 <CAMgrJ3bLJyVYa47zxGgNOcks0bK70oo1w1JLObW4DT_vpyU_SA@mail.gmail.com>
 <CAJ-VmomvQKNHP008vXA8dHrSnG1mUkkx1yoBy6B1jwv_VxTZjw@mail.gmail.com>
 <CAMgrJ3b_W0it4p9pY0rayuZu5yupMJPrGc2T6DTrKO-G27y4Vg@mail.gmail.com> <CAJ-Vmok-iP+=6EK+mG+jqnEPY2gPLhypjcGKxceEvy=EG59Ngw@mail.gmail.com>
From: Robert Shade <robert.shade@gmail.com>
Date: Sun, 24 Mar 2013 14:55:25 -0400
Message-ID: <CAMgrJ3aDhKgPjWx_znDCJVeibTChHAORnFS4Cv6fF56SvV=sNA@mail.gmail.com> (sfid-20130324_195558_331845_DB4AC464)
Subject: Re: Auth Packet TX Delay
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've done some more testing on this and it looks like the auth packets
aren't delayed, they're never sent.  The "TX Complete" messages are
from the queue being purged before a reset due to channel change.

It only gets in this state when it's unable to change the channel due
to the timeout on setting the AR_PHY_AGC_CONTROL register.  One thing
that does look interesting is that, when we fail to change the
channel, ath_complete_reset is never called and therefore
ieee80211_wake_queues is never called either.  Are stop/wake queues
calls supposed to be balanced?

Felix's "ath9k_hw: improve reset reliability after errors" did help a
bit, but I still get the DMA errors periodically and it eventually got
into the state where the calibration fails leading to not sending any
auth packets.

Based on your suggestions, I've been testing a few days with the
following patch and I have yet to see any DMA messages or the auth
stuck state.  I had to check for SC_OP_INVALID because the initial
reset in ath9k_start would cause a kernel panic when the system was
being initialized from a powered off state.  I don't know enough about
the internals to know if I should expect that, but I'll need to set up
a serial console in order to capture the panic.

diff --git a/drivers/net/wireless/ath/ath9k/hw.c
b/drivers/net/wireless/ath/ath9k/hw.c
index 07e2526..05eebdb 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1456,6 +1456,7 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw
*ah, u32 type)
 static bool ath9k_hw_chip_reset(struct ath_hw *ah,
                                struct ath9k_channel *chan)
 {
+       struct ath_softc *sc = ah->hw->priv;
        int reset_type = ATH9K_RESET_WARM;

        if (AR_SREV_9280(ah)) {
@@ -1463,9 +1464,12 @@ static bool ath9k_hw_chip_reset(struct ath_hw *ah,
                        reset_type = ATH9K_RESET_POWER_ON;
                else
                        reset_type = ATH9K_RESET_COLD;
-       } else if (ah->chip_fullsleep || REG_READ(ah, AR_Q_TXE) ||
-                  (REG_READ(ah, AR_CR) & AR_CR_RXE))
+       } else if (AR_SREV_9160(ah) && !test_bit(SC_OP_INVALID,
&sc->sc_flags)) {
+        reset_type = ATH9K_RESET_COLD;
+    } else if (ah->chip_fullsleep || REG_READ(ah, AR_Q_TXE) ||
+                  (REG_READ(ah, AR_CR) & AR_CR_RXE)) {
                reset_type = ATH9K_RESET_COLD;
+    }

        if (!ath9k_hw_set_reset_reg(ah, reset_type))
                return false;
diff --git a/drivers/net/wireless/ath/ath9k/main.c
b/drivers/net/wireless/ath/ath9k/main.c
index 6e66f9c..09b4699 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -252,7 +252,7 @@ static int ath_reset_internal(struct ath_softc
*sc, struct ath9k_channel *hchan)
        struct ath_hw *ah = sc->sc_ah;
        struct ath_common *common = ath9k_hw_common(ah);
        struct ath9k_hw_cal_data *caldata = NULL;
-       bool fastcc = true;
+       bool fastcc = !AR_SREV_9160(ah);
        int r;

        __ath_cancel_work(sc);

--

On Sat, Feb 9, 2013 at 2:39 AM, Adrian Chadd <adrian@freebsd.org> wrote:
>
> On 8 February 2013 10:48, Robert Shade <robert.shade@gmail.com> wrote:
> > Maybe I have the terminology wrong, but I thought a cold reset meant
> > toggling the PCI reset line.
>
> That's a very very cold reset line, that resets the PCI bus glue
> inside the chip.
>
> There's a bunch of different reset lines; most of the device can be
> reset without resetting the PCI/PCIe host interface.
>
> So a "cold" reset here is resetting almost everything inside the chip
> by pulling down those reset lines and stopping/restarting clocks.
>
>
> Adrian
