Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coruscant.huijgen.tk ([84.245.31.19]:23219 "EHLO
	coruscant.huijgen.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbZHTHRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 03:17:11 -0400
Message-ID: <4A8CF814.8040009@huijgen.tk>
Date: Thu, 20 Aug 2009 09:15:32 +0200
From: Mark Huijgen <mark.sf.net@huijgen.tk>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ANN] b43 LP-PHY support (BCM4310/4312/4315) working (partially)!
References: <69e28c910908181329r4b6b7cc8w3c9c0d79dda3730c@mail.gmail.com> 	<69e28c910908190428s46f3d25dnb2f2d8591f99618f@mail.gmail.com> 	<4A8BF35E.1090507@huijgen.tk> <1250687066.1067.25.camel@johannes.local> 	<69e28c910908190626s46fd0bfer5cc9dec9c5bb1c24@mail.gmail.com> 	<4A8C02D8.7080309@huijgen.tk> <69e28c910908190654v231d66c7k6a223f481f702c7c@mail.gmail.com> 	<4A8C056A.4050005@huijgen.tk> <69e28c910908190703h1ad7e98bqa4fe55a5fe7800e2@mail.gmail.com> 	<4A8C0B38.2020402@huijgen.tk> <69e28c910908190754p4f96f2ddhec00300a1c287f5c@mail.gmail.com> <4A8CF7C2.30400@huijgen.tk>
In-Reply-To: <4A8CF7C2.30400@huijgen.tk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What I forgot to mention, is that all tests in this mail were done with
the 410 firmware version.

Mark

Mark Huijgen wrote:
> Gábor Stefanik wrote:
>   
>> 2009/8/19 Mark Huijgen <mark.sf.net@huijgen.tk>:
>>   
>>     
>>> To summarize, all cases with patches and new firmware:
>>> case 1: cold boot with default channel 7, RC calib error and 'init
>>> channel failed' error,
>>> case 2: recompile+reload b43 with default channel 1, just 'init channel
>>> failed' error,
>>> case 3: recompile+reload b43 with default channel 7, works
>>>
>>>
>>> You mean 'iw dev wlan0 set channel 1' for example?
>>>
>>> In case 2 (with default chan 1), ifconfig wlan0 gives error
>>> "SIOCSIFFLAGS: Input/output error"
>>>
>>> # iw dev wlan0 set channel 1
>>> no output generated, also nothing in dmesg
>>>
>>> # iw dev wlan0 scan trigger
>>> command failed: Network is down (-100)
>>> nothing in dmesg.
>>>
>>> Both commands do not give any output in dmesg in case 3 either.
>>>
>>> Tried channel 1 up to 11, 12 and higher gives 'command failed: Invalid
>>> argument (-22)', which is expected I think.
>>>     
>>>       
>> Set your regulatory domain to something that allows higher channels
>> (e.g. iw reg set JP - this one unlocks channels 1-14 (14 is
>> CCK/802.11b only); or iw reg set HU - channels 1-13) to test channels
>> 14 and up.
>>   
>>     
> # iw reg set JP
> [  606.879287] cfg80211: Calling CRDA for country: JP
> # iw phy phy5 info
> <<snip>>
>                         * 2467 MHz [12] (disabled)
>                         * 2472 MHz [13] (disabled)
>                         * 2484 MHz [14] (disabled)
> <<snip>>
>
> # iw dev wlan0 set channel 14
> command failed: Invalid argument (-22)
>
>
>
>   
>> Also, test this:
>>
>> Create a monitor interface (iw dev wlan0 interface add mon0 type monitor)
>> Up the interface (ifconfig mon0 up)
>> Set channel to 1 (iwconfig mon0 channel 1 or iw dev wlan0 set channel 1)
>> Run tcpdump on the interface (tcpdump -i mon0).
>>   
>>     
> This produces quite a lot of packages, small snippet:
> 08:35:31.676268 171437241us tsft 1.0 Mb/s 31 MHz (0x00a0) -82dB signal
> 0dB noise antenna 0 [0x0000000e] Beacon ESS, PRIVACY
> 08:35:31.679047 171439995us tsft 1.0 Mb/s 31 MHz (0x00a0) -82dB signal
> 0dB noise antenna 0 [0x0000000e] Beacon ESS, PRIVACY
> 08:35:31.691757 171454461us tsft 1.0 Mb/s 31 MHz (0x00a0) -72dB signal
> 0dB noise antenna 0 [0x0000000e] Data IV:8a27a7 Pad 20 KeyID 1
> 08:35:31.693722 171457076us tsft 2.0 Mb/s 31 MHz (0x00a0) -58dB signal
> 0dB noise antenna 0 [0x0000000e] Probe Request () [1.0* 2.0* 5.5* 11.0*
> 9.0 18.0 36.0 54.0 Mbit]
> 08:35:31.710293 171472955us tsft 1.0 Mb/s 31 MHz (0x00a0) -59dB signal
> 0dB noise antenna 0 [0x0000000e] Beacon ESS, PRIVACY
>
> So channel 1 does receive packets it seems. Should I be able to see data
> packets from another system thats associated and downloading from my AP
> on channel 1? Protected by WPA. Or are they not shown?
> I don't see any, only thin I notice is the number of pkgs/second is a
> lot less when I'm downloading something on the other system.
>
> If I cycle through the channels with iw dev mon0 set channel N, all
> channels give similar output in tcpdump.
>
>   
>> Try for other channel values as well. (You don't need to recreate the
>> interface for each channel, just use the channel-setting command to
>> switch the channel.) You should see packets on all channels.
>>
>> Another thing to try: add a printk to b43_lpphy_op_set_channel and
>> print out new_channel. This will log all channel change requests
>> (including automatic ones) to dmesg, which can be helpful.
>>   
>>     
> Done, see further down in this mail.
>   
>> If you set your AP to channel 11, can you connect to it & use it as normal?
>>   
>>     
> After doing my tripple module load/recompile to switch default chan from
> 7->1->7,
> yes, then everything seems to work on channel 11. Then all reloads with
> default chan 7 still work fine,
> but if I try a default chan of 1 again, it fails to bring the inteface up.
>
> I cannot connect to my AP on channel 1, since it does not show up in the
> scan results (on another system right beside it, with another type of
> card, it does show up and work).
>
>
> With the added printk in switch channel:
>
> After cold boot with default chan 1:
> [   70.066976] b43-phy1 debug: Switching to channel: 7
> [   70.071314] b43-phy1 debug: Switching to channel: 1
> [   70.071808] b43-phy1 debug: Switch to init channel failed, error = -5.
> [   70.071844] b43-phy1 debug: Switching to channel: 1
> [   70.072341] b43-phy1 ERROR: PHY init: Channel switch to default failed
>
> After recompile with default chan 7:
> [  226.810985] b43-phy2 debug: Switching to channel: 7
> [  226.815320] b43-phy2 debug: Switching to channel: 7
> [  226.815632] b43-phy2 debug: Switching to channel: 7
> [  226.824062] b43-phy2 debug: Chip initialized
> [  226.824274] b43-phy2 debug: 64-bit DMA initialized
> [  226.845588] Registered led device: b43-phy2::tx
> [  226.845610] Registered led device: b43-phy2::rx
> [  226.845630] Registered led device: b43-phy2::radio
> [  226.845696] b43-phy2 debug: Wireless interface started
> [  226.845717] b43-phy2 debug: Adding Interface type 2
> [  226.845812] b43-phy2 debug: Switching to channel: 1
>
> And a working interface.
>
> Another cold boot, this time starting with default chan 7:
> [  100.426965] b43-phy1 debug: Switching to channel: 7
> [  100.431295] b43-phy1 debug: Switching to channel: 7
> [  100.431607] b43-phy1 debug: Switching to channel: 7
> [  100.440061] b43-phy1 debug: Chip initialized
> [  100.440259] b43-phy1 debug: 64-bit DMA initialized
> [  100.461545] Registered led device: b43-phy1::tx
> [  100.461567] Registered led device: b43-phy1::rx
> [  100.461587] Registered led device: b43-phy1::radio
> [  100.461653] b43-phy1 debug: Wireless interface started
> [  100.461673] b43-phy1 debug: Adding Interface type 2
> [  100.461755] b43-phy1 debug: Switching to channel: 1
>
> Working directly after boot ! Are the printk's slowing something down
> enough to make it work better?
> Note: phy0 is from autoloading on boot, no interface up attempts done,
> just a reload with verbose=3.
>
> Just to be sure I did another reboot, with autoloading disabled. Also
> working right away with default channel 7.
> Default channel 1 still no go, and also still not seeing any AP's on
> channel 1 in scan results.
>
> Mark
>
>
>   

