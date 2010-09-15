Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41710 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0IODk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 23:40:57 -0400
Received: by wyf22 with SMTP id 22so8153353wyf.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 20:40:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikvdkR=w-vGL=0LHnxQSibfoFBpuhLwjJZWVCuM@mail.gmail.com>
References: <AANLkTi=azJS6bn7-=Bbb--ibACaQWqv4ZGLMUpfxynm7@mail.gmail.com> <AANLkTikvdkR=w-vGL=0LHnxQSibfoFBpuhLwjJZWVCuM@mail.gmail.com>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 15 Sep 2010 13:40:36 +1000
Message-ID: <AANLkTi=SDxw36LtH44gLB185oxARHLvE41ryLiEFdBYn@mail.gmail.com>
Subject: Re: [support] ath5k contention windows
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 14, 2010 at 3:53 PM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
> Hi all,
>
> I have some behaviour I'm observing with some Atheros cards we use
> that doesn't seem to match what the initvals of ath5k are set up to.
> These are the cards I used:
> http://www.mini-box.com/s.nl/it.A/id.387/.f
>
> I have run a saturated iPerf flow on a conducted testbed with both
> stations being inside RF-shielding boxes. They are set to 802.11a
> mode, on channel 1. I then parse the trace, looking for ACK-DATA
> pairs, and calculating the time difference between them. From this, I
> remove the TX_TIME of the DATA frame, as well as a DIFS:
>
> ACK_TIMESTAMP + DIFS + CONTENTION_TIME + DATA_TX_TIME = DATA_TIMESTAMP
>
> which will leave me with the CONTENTION_TIME. Dividing this time by a
> SLOT_TIME will give me the slot which was chosen by the hardware.
>
>
> According to the driver, in ath5k.h:
>
> #define AR5K_TUNE_CWMIN                15
>
> CWMIN is initialised to 15.
>
> The actual distribution of contention slots I'm observing resembles this:
>
> Slot Number,Count
> 0,1315
> 1,1302
> 2,1249
> 3,1291
> 4,1347
> 5,1219
> 6,1249
> 7,0
> 8,0
> 9,0
> <truncated>
>
> as well as 1360 frames which came in with a negative CONTENTION_TIME.
>
> Ignoring the fact that some frames are coming up with a negative
> CONTENTION_TIME (which potentially points to another problem), what is
> being observed here is that CW_MIN appears to start at 7, rather than
> the 15 which it should be.
>
> I'm just wondering if anyone would have any idea why this is occurring?

Sorry to bring the post back on topic, I'm just trying to narrow down
what the driver is doing with the CW_MIN and CW_MAX parameters.

$$ ath5k.h
#define AR5K_TUNE_CWMIN				15
#define AR5K_TUNE_CWMIN_11B			31
#define AR5K_TUNE_CWMIN_XR			3
#define AR5K_TUNE_CWMAX				1023
#define AR5K_TUNE_CWMAX_11B			1023
#define AR5K_TUNE_CWMAX_XR			7

$$ qcu.c
/*
 * Set DFS properties for a transmit queue on DCU
 */
int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
{
<... truncated ...>
	/*
	 * Calculate cwmin/max by channel mode
	 */
	cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN;
	cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX;
	ah->ah_aifs = AR5K_TUNE_AIFS;
	/*XR is only supported on 5212*/
	if (IS_CHAN_XR(ah->ah_current_channel) &&
			ah->ah_version == AR5K_AR5212) {
		cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN_XR;
		cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX_XR;
		ah->ah_aifs = AR5K_TUNE_AIFS_XR;
	/*B mode is not supported on 5210*/
	} else if (IS_CHAN_B(ah->ah_current_channel) &&
			ah->ah_version != AR5K_AR5210) {
		cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN_11B;
		cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX_11B;
		ah->ah_aifs = AR5K_TUNE_AIFS_11B;
	}

	cw_min = 1;
	while (cw_min < ah->ah_cw_min)
		cw_min = (cw_min << 1) | 1;

	cw_min = tq->tqi_cw_min < 0 ? (cw_min >> (-tq->tqi_cw_min)) :
		((cw_min << tq->tqi_cw_min) + (1 << tq->tqi_cw_min) - 1);
	cw_max = tq->tqi_cw_max < 0 ? (cw_max >> (-tq->tqi_cw_max)) :
		((cw_max << tq->tqi_cw_max) + (1 << tq->tqi_cw_max) - 1);
<... truncated ...>
}

$$ attach.c
int ath5k_hw_attach(struct ath5k_softc *sc)
{
<... truncated ...>
	/*
	 * HW information
	 */
	ah->ah_radar.r_enabled = AR5K_TUNE_RADAR_ALERT;
	ah->ah_turbo = false;
	ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
	ah->ah_imr = 0;
	ah->ah_atim_window = 0;
	ah->ah_aifs = AR5K_TUNE_AIFS;
	ah->ah_cw_min = AR5K_TUNE_CWMIN;
<... truncated ...>
}

I'm trying to understand where the CW_MIN value is being set. My
understanding is that if the hardware is in 802.11a (non-turbo) mode,
it will be set to AR5K_TUNE_CWMIN, both when it is attached, and when
the queue is reset.

Is there anywhere else that this value might be overridden and explain
the behaviour I'm observing? I can see a few places where the queues
are initilised to AR5K_TXQ_USEDEFAULT - does this make the card pull
the value from the ah->ah_cw_min variable?


>
> Thanks,
>
> --
> Jonathan Guerin
