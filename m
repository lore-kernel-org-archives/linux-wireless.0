Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:3809 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbXKQUdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2007 15:33:09 -0500
Received: by py-out-1112.google.com with SMTP id u77so4918836pyb
        for <linux-wireless@vger.kernel.org>; Sat, 17 Nov 2007 12:33:08 -0800 (PST)
Message-ID: <43e72e890711171233x735ad06t31bbdd8b7b454579@mail.gmail.com> (sfid-20071117_203333_002332_97431B48)
Date: Sat, 17 Nov 2007 15:33:07 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: sandra <makevuy@ehas.org>
Subject: Re: [Madwifi-devel] How to modify acktimeout, ctstimeout and TXOP limits in MadWifi driver?
Cc: madwifi-devel@lists.sourceforge.net, ath5k-devel@lists.ath5k.org,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <473C1F48.5040800@ehas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <473C1F48.5040800@ehas.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 15, 2007 5:28 AM, sandra <makevuy@ehas.org> wrote:
> Hello,
>
> I would want to know if the limits for setting acktimeout, ctstimeout
> and txop

What's txop?

> (I don't know if there is limitation using other parameters) is
> because of chipset or software code.

I am not sure yet. I do know a bit about the registers which I think
are used for ACK timeout and CTS timeout though. Let me explain.

> Thank you very much and best regards.

I believe the ACK timeout are what the ar5k ended up calling "rate
duration registers". These are specific per rate and for the rates
that are capable of short preamble (802.11b rates 2Mbps, 5.5Mbps, and
11Mbps) there is another register you can use to set the 'rate
duration' for short preamble. The HAL and our ath5k driver sets these
registers upon reset. I do not believe this is necessary though --
these are static values and should just be set IMO if we change mode.
Anyway, please have a look at ath5k in ath5k_hw_write_rate_duration()
in hw.c for this.

The value used during rate duration will depend on what rate you are
configuring the driver to TX ACKs at. By default (from Nick's tests)
the defined 'control' rate for each rate is used. The control rate is
listed per rate on the
AR5K_RATES_* macros in ath5k.h as the last element. For example:

        { 1, IEEE80211_RATE_OFDM, 54000, 12, 108, 4 } }         \

In here on rate 54Mbps, the control rate is the index 4, which is
24Mbps. I believe Atheros chose this by design based on IEEE-802.11 Ch
9.6 (after 802.11g changes). Now, note the control rates can be
modified. So far it seem the only way to do this is by enabling some
bits on the AR5K_STA_ID1 register. We currently do this on base.c by
calling ath5k_hw_set_ack_bitrate_high(). We currently set up the ACK
bit rate to the low rates as we are having problems with higher rates
in ath5k (anything above 11M). This would sets ACK bit rates to 11b
rates which is just 1Mbps and 2Mbps. It sees the
AR5K_STA_ID1_ACKCTS_6MB sets the ACK rate to 6Mbps for higher rates
than 11Mbps. All this needs more testing and verification.

At least within implementation on the 'rate duration' register so far
the entire register may be used here and in that case a whole 32 bits
are available. Not sure if that is a hard boundary here or if its
actually less.

Then here's a curve ball. We also have a register AR5K_TIME_OUT, which
is split into two to set an 'ACK timeout' and 'CTS timeout':

#define AR5K_TIME_OUT           0x8014                  /* Register Address */
#define AR5K_TIME_OUT_ACK       0x00001fff      /* ACK timeout mask */
#define AR5K_TIME_OUT_ACK_S     0
#define AR5K_TIME_OUT_CTS       0x1fff0000      /* CTS timeout mask */
#define AR5K_TIME_OUT_CTS_S     16

_S means shift.

We currently do not set these values other than what is set by default
through the initvals per mode for each baseband MAC and per mode. For
ar5211 we set this to:

        /*        a/XR        aTurbo      b           g(OFDM?)
gTurbo (N/A) */
        { AR5K_TIME_OUT,
                { 0x04000400, 0x08000800, 0x20003000, 0x04000400,
0x04000400 } },

For ar5212 we set this to:

        /*        a/XR        aTurbo      b           g (DYN)     gTurbo */
        { AR5K_TIME_OUT,
                { 0x03e803e8, 0x06e006e0, 0x04200420, 0x08400840,
0x06e006e0 } },

The value set seems to have to match the PLL clock. You do this by
using ath5k_hw_htoclock() and to read from it ath5k_hw_clocktoh().

Using this for 802.11g this seems to be set to 0x840 = 2112 (base 10).

2112 / 40 = 52.8

So perhaps this is an upper limit on the ACK timeout. If so what does
this do and what is the difference in behavior between reaching a
timeout with this value than with the specific value in the rate
duration? I am not sure yet. I think one of them must trigger a
retransmit. We do at least match what the HAL current does except
remember we are currently setting the ACK bit rates to lower bit
rates.

These registers are sharply split. ACK and CTS can only use a 0x1fff
mask of the 32 bits, which is 13 bits. For each value it leaves us
with with the 3 Most Significant BIts as either unused or for some
purpose we are not yet sure how to use.

Hope this helps. Also if you end up testing and getting more
information please do let us know.

  Luis
