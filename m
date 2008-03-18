Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:11019 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYCRLAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2008 07:00:45 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] mac80211: use hardware flags for signal/noise units
Date: Tue, 18 Mar 2008 11:57:47 +0100
References: <200803082101.24424.bruno@thinktube.com>
In-Reply-To: <200803082101.24424.bruno@thinktube.com>
Cc: libertas-dev@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803181157.47575.hs4233@mail.mn-solutions.de> (sfid-20080318_110123_763747_A4FE18C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>     ath5k           dBm     dBm     percent rssi
>     b43legacy       dBm(?)  dBm     percent jssi(?)
>     b43             dBm(?)  dBm     percent jssi(?)
>     iwl-3945        dBm     dBm     percent snr+more
>     iwl-4965        dBm     dBm     percent snr+more
>     rt2x00          dBm(?)  n/a     percent rssi+tx/rx frame
> success rt2400        dBm(?)  n/a
>       rt2500pci     dBm(?)  n/a
>       rt2500usb     dBm(?)  n/a
>       rt61pci       dBm(?)  n/a
>       rt73usb       dBm(?)  n/a
>     rtl8180		nounit	n/a    (?)
>     rtl8187		nounit	(?)    (?)
>     zd1211		dB(?)	/      percent

This list made me think about the libertas values. Here the 
firmware provides SNR and NF and RSSI is calculated from those 
values. However,

Is it ok to add a dBm value (noisefloor) to a dB value (SNR) ??




The libertas firmware can give me SNR and NF for beacons (via 
CMD_802_11_RSSI) and also for each received frame (in the rx 
packet descriptor structure).

In the firmware manual they say:

   SNR  UINT8  Signal to noise ratio for this packet
               This should be a positive value (dB)
   NF   UINT8  Noise floor for this packet (dBm)
               Noise floor is always negative. The absolute
               value is passed.

That was the description for the RX packet descriptor, the 
description for the CMD_802_11_RSSI is basically the same. 

Now I see two macros:

#define CAL_NF(NF)       ((s32)(-(s32)(NF)))
#define CAL_RSSI(SNR,NF) ((s32)((s32)(SNR) + CAL_NF(NF)))

While I understand the CAL_NF() macro, but I'm not sure if the 
second one does the right thing. Or maybe the manual is simply 
wrong. Here are some samples with my WLAN card sitting next to 
an AP:

rxpd:     SNR  41, NF  86
get_rssi: SNR  41, NF  86
rxpd:     SNR  41, NF  86
get_rssi: SNR  42, NF  86
rxpd:     SNR  41, NF  86
get_rssi: SNR  41, NF  86
rxpd:     SNR  41, NF  86
get_rssi: SNR  41, NF  86
get_rssi: SNR  40, NF  85
rxpd:     SNR  41, NF  86

