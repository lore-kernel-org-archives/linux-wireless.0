Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:38146 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab1EGK7S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 06:59:18 -0400
Received: from [195.4.92.16] (helo=6.mx.freenet.de)
	by mout1.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QIfEC-00065B-Ba
	for linux-wireless@vger.kernel.org; Sat, 07 May 2011 12:59:16 +0200
Received: from p54a18705.dip0.t-ipconnect.de ([84.161.135.5]:33124 helo=mail.maya.org)
	by 6.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QIfEC-0005hM-06
	for linux-wireless@vger.kernel.org; Sat, 07 May 2011 12:59:16 +0200
Message-ID: <4DC5267F.6020202@01019freenet.de> (sfid-20110507_125923_453771_4A32A9BD)
Date: Sat, 07 May 2011 13:01:19 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: users@rt2x00.serialmonkey.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rmmod rt2800pci broken since compat-wireless-2011-04-21 - CPU
 load is 1
References: <4DC44F80.8040605@01019freenet.de> <4DC50FDA.3020700@gmail.com>
In-Reply-To: <4DC50FDA.3020700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Gertjan,

Gertjan van Wingerde wrote:
> Hi Andreas,
> 
> On 05/06/11 21:44, Andreas Hartmann wrote:
>> Hello,
>>
>> since compat-wireless-2011-04-21 (running with kernel 2.6.34.9),
>> removing of rt2800pci is broken: rmmod hangs and system load goes up to
>> 1 on one CPU.
>>
>> Loading:
>>
>> [ 5951.248390] Compat-wireless backport release:
>> compat-wireless-2011-04-14-3-g77081fd
>> [ 5951.248402] Backport based on linux-next.git next-20110421
>> [ 5951.293158] cfg80211: Calling CRDA to update world regulatory domain
>> [ 5951.316293] cfg80211: World regulatory domain updated:
>> [ 5951.316300] cfg80211:     (start_freq - end_freq @ bandwidth),
>> (max_antenna_gain, max_eirp)
>> [ 5951.316307] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
>> (300 mBi, 2000 mBm)
>> [ 5951.316313] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
>> (300 mBi, 2000 mBm)
>> [ 5951.316319] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
>> (300 mBi, 2000 mBm)
>> [ 5951.316324] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
>> (300 mBi, 2000 mBm)
>> [ 5951.316330] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
>> (300 mBi, 2000 mBm)
>> [ 5951.387120] rt2800pci 0000:03:07.0: PCI INT A -> GSI 21 (level, low)
>> -> IRQ 21
>> [ 5951.396951] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
>> [ 5951.399528] Registered led device: rt2800pci-phy0::radio
>> [ 5951.399685] Registered led device: rt2800pci-phy0::assoc
>> [ 5951.399831] Registered led device: rt2800pci-phy0::quality
>> [ 5951.408153] wlan0 renamed to wlan1 by udevd [26800]
>> [ 5951.411780] udev: renamed network interface wlan0 to wlan1
>> ifup:     wlan1     device: RaLink RT2800 802.11n PCI
>> ifup:               No configuration found for wlan1
>>
>>
>> "Unloading" doesn't produce any logentries in /var/log/messages.
>>
>> compat-wireless-2011-04-19 doesn't show this problem
>> (compat-wireless-2011-04-20 doesn't exist).
>>
>>
>> My hardware: Linksys WMP600N
>>
>> 03:07.0 Network controller: RaLink RT2800 802.11n PCI
>>         Subsystem: Linksys Device 0067
>>         Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV+ VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Interrupt: pin A routed to IRQ 21
>>         Region 0: Memory at fdce0000 (32-bit, non-prefetchable) [size=64K]
>>         Capabilities: [40] Power Management version 3
>>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>>
>>
>> Could you please fix this problem?
>>
> 
> This is just a hunch and untested, but could you check if the attached patch
> solves the problem?

Yes, I know. But this code will go to production some time later. If
nobody tests it before, the problems will go to production, too.

Your patch works fine for me. Thank you!


I've got another problem, which comes up on all versions I tested (even
with 2.6.39-rc6-1-sp):

The card runs in AP mode (ieee80211n - wpa2tls) with the following
capabilities set in hostapd:

ht_capab=[HT40+][SHORT-GI-40][TX-STBC][MAX-AMSDU-3839][RX-STBC12][SMPS-STATIC]

The ralink-firmware is the actual version from git.


On the client-side (supplicant), I'm running a script which stresses the
wlan (no other client is connected):

while true ; do
	netperf -t TCP_STREAM -H AP
	netperf -t TCP_MAERTS -H AP
	netperf -t TCP_SENDFILE -H AP
done

After about 10 minutes, the connection stalls (no more datas are going
into AP - no logfile entries can be found in messages or elsewhere).

I switched of hwcrypt - but this doesn't make the connection more stable.

I tested in bridged mode and in router mode (2 different networks) - the
problem doesn't change.

I'm pretty sure that this is not a client problem, because I have a
dedicated AP, where the connection doesn't stall.

I'm doing this test because the connection isn't stable in real live. too.


Do you have any idea, how to solve this problem? If you need more info,
please ask - I'll try to get it!


Kind regards,
Andreas



> rmmod_hang_fix.patch
> 
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 7776d9f..ae61d24 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1071,9 +1071,9 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>  	/*
>  	 * Stop all work.
>  	 */
> -	del_timer_sync(&rt2x00dev->txstatus_timer);
>  	cancel_work_sync(&rt2x00dev->intf_work);
>  	if (rt2x00_is_usb(rt2x00dev)) {
> +		del_timer_sync(&rt2x00dev->txstatus_timer);
>  		cancel_work_sync(&rt2x00dev->rxdone_work);
>  		cancel_work_sync(&rt2x00dev->txdone_work);
>  	}

