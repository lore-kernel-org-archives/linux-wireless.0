Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from osmium.mv.net ([199.125.85.152]:53436 "HELO shell.mv.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751157Ab0D1Bob (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 21:44:31 -0400
Date: Tue, 27 Apr 2010 20:01:08 -0400 (EDT)
From: RHS Linux User <xxx@nei.mv.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: noise floor calibration process
In-Reply-To: <4BD74B66.3030500@free.fr>
Message-ID: <Pine.LNX.3.95.1100427193637.9331F-100000@nei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi All,

   <preaching>

   The chip *FOR SURE* *CANNOT* measure the thermal noise level!! It isn't
that sensitive. That said under some conditions it CAN measure the
local interference level which IS useful.

   I am *VERY MUCH* in favor of making real time level measurements of
various parts of real packets easy to use!  Troubleshooting becomes so
much easier :).

   </preaching>

   Great ideas !!

   FWIW - I have on occasion used a low noise preamp to feed the chip. 
Many more signals are detectable which "proves" the chip by itself *IS
NOT* that sensitive. Try it yourself !

   Have fun,

   Wiz


On Tue, 27 Apr 2010, Benoit PAPILLAULT wrote:

> Hello,
> 
> In order to move forward with noise & signal reporting, I'd like to 
> share my current understanding of the way  ath9k HW is working before 
> sending patches (unfortunately, I did the work before the introduction 
> of ar9003... so I need to redo the work).
> 
> The ultimate purpose of this work is to be able to measure signal levels 
> (and noise if possible) as accurately as a spectrum analyzer or power meter.
> 
> First, signal level reporting. It is reported in a per packet basis in 
> RX descriptors. There are 7 fields:
>     AR_RxRSSIAnt00    0x000000ff    rs_rssi_ctl0
>     AR_RxRSSIAnt01    0x0000ff00    rs_rssi_ctl1
>     AR_RxRSSIAnt02    0x00ff0000    rs_rssi_ctl2
>     AR_RxRSSIAnt10        0x000000ff    rs_rssi_ext0
>     AR_RxRSSIAnt11        0x0000ff00    rs_rssi_ext1
>     AR_RxRSSIAnt12        0x00ff0000    rs_rssi_ext2
>     AR_RxRSSICombined    0xff000000    rs_rssi
> 
> Each value is for a 20 MHz wide channel, on the 3 RX chains. "ctl" is 
> for the primary channel and "ext" is for the secondary channel (using 
> the 802.11n words). The latter rs_rssi is the sum of the 6 previous 
> value. However, since each value is dB, the sum is not an arithmetic 
> sum. Each field is a signed value and the value -128 means that no 
> measurement has been done  (no RX chain, RX chain disabled, no secondary 
> channel, ...). It seems that in some cases, the combined value is just 
> plain wrong. Here are few examples:
> 
>   RSSI: ctl=(10,7,-128) ext=(-128,-128,-128) => 12 (11.76)    correct
> 
>   RSSI: ctl=(38,29,-128) ext=(69,-84,-101) => -22        incorrect!!!
> 
> 
> Next, noise floor calibration. From what I understand, signal levels is 
> measured using the AGC + RX amplifiers gain (RF, IF and BB). However, 
> the various gains are not really accurate, only the relative gain are 
> accurate. This means that reading a signal value of -100dBm might not 
> exactly means -100dBm. There is a delta between real signal and measured 
> value. In order to know this value, we need a calibration process with a 
> known signal.
> 
> One know signal is thermal noise. Thermal noise is generated in any 
> resistor and can be computed using the well know value N = kTB. For a 20 
> MHz bandwidth, this gives -101dBm. If the HW tries to measure signal 
> strength when the network is supposed to be idle (during SIFS) and with 
> RX/TX switch disabled (?), then it will in fact measure the thermal 
> noise at the RX input.
> 
> So, we have :
> 
> Real noise (-101dBm) = Measured noise + delta
> 
> There are type of registers to control noise floor calibration :
> 
> - control register at 0x9860    (AR_PHY_AGC_CONTROL)
> 
> This register allows 3 differents operations :
> 
> 1. start noise floor measurement
> 
>   write AR_PHY_MAXCCA_PWR (AR_PHY_CCA & 0x000001ff) : this is apparently 
> a max value
>     for noise floor
>   REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_ENABLE_NF);
>   REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
>   REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
> 
>   When channel has been changed however, the noise floor needs to be 
> updated immediately, so AR_PHY_AGC_CONTROL_NO_UPDATE_NF should be 
> cleared in this particular case. Otherwise, the chip is no longer 
> receiving (problem since CCA is defined with noise floor as reference).
> 
> 2. read noise floor measurement result
> 
>     check REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF
>     if 0 (noise floor calibration is finished), read AR_PHY_MINCCA_PWR :
>       nf = MS(REG_READ(ah, AR_PHY_CCA), AR_PHY_MINCCA_PWR = 0x0ff80000)
> 
> 3. write noise floor reference
> 
>   write AR_PHY_MAXCCA_PWR (the value has not the same meaning as 
> operation 1!)
>   REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_ENABLE_NF);
>   REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
>   REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
> 
> - data register at 0x9864 (AR_PHY_CCA, + more location for other RX chains)
> 
>   The fields are different for AR9280+ chipsets, but the mechanism is 
> the same.
> 
>     AR_PHY_MAXCCA_PWR        0x000001ff (half dBm unit!)
>     AR_PHY_CCA_THRESH62    0x0007f000
>     AR_PHY_MINCCA_PWR        0x0ff80000
> 
> Now, we have :
> 
> Real signal = Measured signal + delta
>     = RSSI + Noise floor + delta
>     = RSSI + (-101 dBm)
> 
> Real noise is not thermal noise. There are a lot of definition for noise 
> since noise is NOT signal. Of course, noise includes thermal noise. 
> Since the noise measured by the chip is variable, I think we could do :
> 
> - Noise floor = minimum (Noise floor measures)
> - Noise = moving average (Noise floor measures) + delta
>   with delta = (-101 dBm) - Noise floor
> 
> I'd like to get comments before sending patches. Since ath5k and ath9k 
> are quite close, I'm pretty sure a similar (if not same) process is used 
> on ath5k.
> 
> Regards,
> Benoit
> 
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
> 

