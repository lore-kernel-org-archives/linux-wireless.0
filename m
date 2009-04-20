Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:40349 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZDTWsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 18:48:31 -0400
Received: by bwz7 with SMTP id 7so1480722bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2009 15:48:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8e92b4100904171948g5d961578ne46cbf1a135bfdc7@mail.gmail.com>
References: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com>
	<2da21fe50904171257v17ea8431h1979f0d004885600@mail.gmail.com>
	<8e92b4100904171948g5d961578ne46cbf1a135bfdc7@mail.gmail.com>
From: Davide Pesavento <davidepesa@gmail.com>
Date: Tue, 21 Apr 2009 00:48:14 +0200
Message-ID: <2da21fe50904201548t21a4bca6s806d50fe5e6cc74f@mail.gmail.com> (sfid-20090421_004835_626625_0044A19C)
Subject: Re: ath9k and power management
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 18, 2009 at 04:48, Vivek Natarajan <vivek.natraj@gmail.com>=
 wrote:
> On Sat, Apr 18, 2009 at 1:27 AM, Davide Pesavento <davidepesa@gmail.c=
om> wrote:
>> On Fri, Mar 27, 2009 at 16:27, Davide Pesavento <davidepesa@gmail.co=
m> wrote:
>>> Hello,
>>>
>>> I'm running a 2.6.29-wl kernel, using ath9k and wpa_supplicant 0.6.=
9
>>> (with -Dnl80211).
>>> Enabling power management when connected (i.e. 'iwconfig wlan0 powe=
r
>>> on'), causes the currently established connection to break and the
>>> machine is no longer able to reconnect to the AP. Right after enabl=
ing
>>> pm, dmesg says:
>>>
>>> [ 2625.513233] wlan0: beacon loss from AP 00:1b:2f:35:14:78 - sendi=
ng
>>> probe request
>>> [ 2627.513210] wlan0: no probe response from AP 00:1b:2f:35:14:78 -
>>> disassociating
>>> [ 2627.514430] phy0: Removed STA 00:1b:2f:35:14:78
>>> [ 2627.543407] phy0: Destroyed STA 00:1b:2f:35:14:78
>>> [ 2776.444279] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>>> [ 2776.659861] wlan0: deauthenticating by local choice (reason=3D3)
>>> [ 2776.831004] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>>>
>>> When I turn power management off again, wpa_supplicant is able to
>>> reconnect just fine.
>>> Is this a known bug? If ath9k doesn't support power management
>>> properly, wouldn't it be better to reject the userspace request rig=
ht
>>> away?
>>>
>>
>> This is still unfixed on latest git (2.6.30-rc2-wl). The symptoms ar=
e
>> exactly the same as reported above.
>
> This is the power save mechanism used in ath9k:
> An interrupt is triggered just 4ms before the target beacon time
> so that the chip can wake up and receive the beacons. In all the
> latest chipsets like AR92XX, this is working fine.I wonder why
> AR54XX has some problems related to that.
> A quick look into the debug logs shows me that this wake up interrupt
> (TIM_TIMER) stops triggering after some time which leads to beacon
> loss and disconnection.
> Although there is an option of autosleep(in latest versions) where hw=
 can
> wakeup automatically and receive beacon instead of a sw trigger call,
> the hw may sleep for a longer duration(sometimes) =C2=A0and we may ne=
ed to
> have some timer mechanism to verify if the hw is hung or not.
> I did not have much time to look into this somewhat older chipsets an=
d
> I will try to debug more if I manage to get some free time.
>
> Thanks
> Vivek
>

I did some more testing with ATH_DBG_RESET and ATH_DBG_BEACON enabled.
Here is dmesg output:

< first I try to connect with PS disabled >

[17772.421740] ath9k: AWAKE -> AWAKE
[17772.658457] ath9k: AWAKE -> AWAKE
[17772.659600] ath9k: AWAKE -> AWAKE
[17772.661119] ath9k: ah->misc_mode 0x4
[17772.662783] ath9k: AWAKE -> AWAKE
[17772.663840] ath9k: AWAKE -> AWAKE
[17772.664968] ath9k: AWAKE -> AWAKE
[17772.666484] ath9k: ah->misc_mode 0x4
[17772.667711] wlan0: authenticate with AP 00:1b:2f:58:30:76
[17772.669950] wlan0: authenticated
[17772.669954] wlan0: associate with AP 00:1b:2f:58:30:76
[17772.673211] wlan0: RX AssocResp from 00:1b:2f:58:30:76 (capab=3D0x43=
1
status=3D0 aid=3D2)
[17772.673215] wlan0: associated
[17772.673233] phy1: Allocated STA 00:1b:2f:58:30:76
[17772.673242] phy1: Inserted STA 00:1b:2f:58:30:76
[17772.673246] wmaster0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D3 cWmin=3D=
15
cWmax=3D1023 txop=3D0
[17772.673256] wmaster0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D=
15
cWmax=3D1023 txop=3D0
[17772.673265] wmaster0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D=
7 cWmax=3D15 txop=3D94
[17772.673273] wmaster0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D=
3 cWmax=3D7 txop=3D47
[17772.673283] wlan0: switched to short barker preamble
(BSSID=3D00:1b:2f:58:30:76)
[17772.673286] wlan0: switched to short slot time (BSSID=3D00:1b:2f:58:=
30:76)
[17772.673312] ath9k: tsf: 5595 tsftu: 7
[17772.673315] ath9k: bmiss: 10 sleep: 100 cfp-period: 10000 maxdur: 0 =
next: 100
[17772.673333] ath9k: next DTIM 100
[17772.673336] ath9k: next beacon 100
[17772.673338] ath9k: beacon period 100
[17772.673341] ath9k: DTIM period 10000
[17772.673598] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

< ok, wpa_supplicant is connected >
< now I execute `iwconfig wlan0 power timeout 1` >

[17836.991721] ath9k: AWAKE -> NETWORK SLEEP
[17836.991742] ath9k: NETWORK SLEEP -> AWAKE
[17836.991838] ath9k: AWAKE -> AWAKE
[17837.011506] ath9k: AWAKE -> AWAKE
[17837.113945] ath9k: AWAKE -> AWAKE
[17837.216346] ath9k: AWAKE -> AWAKE
[17837.318753] ath9k: AWAKE -> AWAKE
[17837.410312] ath9k: AWAKE -> NETWORK SLEEP
[17837.410340] ath9k: NETWORK SLEEP -> AWAKE
[17837.410414] ath9k: AWAKE -> NETWORK SLEEP
[17837.474938] ath9k: NETWORK SLEEP -> AWAKE
[17837.475021] ath9k: AWAKE -> NETWORK SLEEP
[17837.475061] ath9k: NETWORK SLEEP -> AWAKE
[17837.475134] ath9k: AWAKE -> NETWORK SLEEP
[17837.571609] ath9k: NETWORK SLEEP -> AWAKE
[17837.571689] ath9k: AWAKE -> NETWORK SLEEP
[17837.671610] ath9k: NETWORK SLEEP -> AWAKE
[17837.671690] ath9k: AWAKE -> NETWORK SLEEP
[17837.671731] ath9k: NETWORK SLEEP -> AWAKE
[17837.671803] ath9k: AWAKE -> NETWORK SLEEP
[17837.774920] ath9k: NETWORK SLEEP -> AWAKE
[17837.774997] ath9k: AWAKE -> NETWORK SLEEP
[17837.871610] ath9k: NETWORK SLEEP -> AWAKE
[17837.871694] ath9k: AWAKE -> NETWORK SLEEP
[17837.971618] ath9k: NETWORK SLEEP -> AWAKE
[17837.971701] ath9k: AWAKE -> NETWORK SLEEP
[17838.071609] ath9k: NETWORK SLEEP -> AWAKE
[17838.071689] ath9k: AWAKE -> NETWORK SLEEP
[17838.171609] ath9k: NETWORK SLEEP -> AWAKE
[17838.171691] ath9k: AWAKE -> NETWORK SLEEP
[17838.271611] ath9k: NETWORK SLEEP -> AWAKE
[17838.271694] ath9k: AWAKE -> NETWORK SLEEP
[17838.271713] ath9k: NETWORK SLEEP -> AWAKE
[17838.271786] ath9k: AWAKE -> NETWORK SLEEP
[17838.271805] ath9k: NETWORK SLEEP -> AWAKE

< this bouncing between power states goes on for a bit more, until... >

[17840.684940] wlan0: beacon loss from AP 00:1b:2f:58:30:76 - sending
probe request
[17840.684984] ath9k: NETWORK SLEEP -> AWAKE
[17841.685023] ath9k: AWAKE -> AWAKE
[17841.685127] ath9k: AWAKE -> NETWORK SLEEP
[17841.687395] ath9k: NETWORK SLEEP -> AWAKE
[17841.722144] ath9k: AWAKE -> AWAKE
[17841.824534] ath9k: AWAKE -> AWAKE
[17841.926945] ath9k: AWAKE -> AWAKE
[17842.018507] ath9k: AWAKE -> NETWORK SLEEP
[17842.029339] ath9k: NETWORK SLEEP -> AWAKE
[17842.029428] ath9k: AWAKE -> AWAKE
[17842.131762] ath9k: AWAKE -> AWAKE
[17842.234162] ath9k: AWAKE -> AWAKE
[17842.336567] ath9k: AWAKE -> AWAKE
[17842.438969] ath9k: AWAKE -> AWAKE
[17842.530529] ath9k: AWAKE -> NETWORK SLEEP
[17842.530556] ath9k: NETWORK SLEEP -> AWAKE
[17842.530629] ath9k: AWAKE -> NETWORK SLEEP
[17842.571607] ath9k: NETWORK SLEEP -> AWAKE
[17842.571690] ath9k: AWAKE -> NETWORK SLEEP
[17842.571730] ath9k: NETWORK SLEEP -> AWAKE
[17842.571802] ath9k: AWAKE -> NETWORK SLEEP
[17842.671606] ath9k: NETWORK SLEEP -> AWAKE
[17842.671686] ath9k: AWAKE -> NETWORK SLEEP
[17842.671712] ath9k: NETWORK SLEEP -> AWAKE
[17842.671784] ath9k: AWAKE -> NETWORK SLEEP
[17842.771617] ath9k: NETWORK SLEEP -> AWAKE
[17842.771699] ath9k: AWAKE -> NETWORK SLEEP
[17842.771724] ath9k: NETWORK SLEEP -> AWAKE
[17842.771797] ath9k: AWAKE -> NETWORK SLEEP
[17842.871608] ath9k: NETWORK SLEEP -> AWAKE
[17842.871690] ath9k: AWAKE -> NETWORK SLEEP

< and then the whole thing starts over again for another couple of
times, with the hardware rapidly alternating its power state, until it
disconnects >

[17852.691611] wlan0: no probe response from AP 00:1b:2f:58:30:76 -
disassociating
[17852.691695] ath9k: AWAKE -> AWAKE
[17852.691782] phy1: Removed STA 00:1b:2f:58:30:76
[17852.731944] phy1: Destroyed STA 00:1b:2f:58:30:76
[17852.821730] ath9k: AWAKE -> AWAKE
[17852.888413] ath9k: AWAKE -> AWAKE
[17852.955081] ath9k: AWAKE -> AWAKE
[17853.021725] ath9k: AWAKE -> AWAKE
[17853.088395] ath9k: AWAKE -> AWAKE
[17853.155083] ath9k: AWAKE -> AWAKE
[17853.221726] ath9k: AWAKE -> AWAKE
[ ...above message repeated many times... ]
[17857.517104] ath9k: AWAKE -> NETWORK SLEEP
[17857.517117] ath9k: NETWORK SLEEP -> AWAKE
[17857.517280] ath9k: AWAKE -> AWAKE
[17857.518407] ath9k: AWAKE -> AWAKE
[17857.519923] ath9k: ah->misc_mode 0x4
[17857.521323] ath9k: AWAKE -> NETWORK SLEEP
[17857.521336] ath9k: NETWORK SLEEP -> AWAKE
[17857.521405] ath9k: AWAKE -> NETWORK SLEEP
[17857.521424] ath9k: NETWORK SLEEP -> AWAKE
[17857.521493] ath9k: AWAKE -> NETWORK SLEEP
[17857.521509] wlan0: authenticate with AP 00:1b:2f:58:30:76
[17857.521527] ath9k: NETWORK SLEEP -> AWAKE
[17857.522564] ath9k: AWAKE -> AWAKE
[17857.523684] ath9k: AWAKE -> AWAKE
[17857.525216] ath9k: ah->misc_mode 0x4
[17857.526329] ath9k: AWAKE -> AWAKE
[17857.527450] ath9k: AWAKE -> AWAKE
[17857.528972] ath9k: ah->misc_mode 0x4
[17857.529901] wlan0: authenticate with AP 00:1b:2f:58:30:76
[17857.532614] wlan0: authenticated
[17857.532618] wlan0: associate with AP 00:1b:2f:58:30:76
[17857.535619] wlan0: deauthenticated (Reason: 6)
[17858.534801] wlan0: dropped data frame to not associated station
00:1b:2f:58:30:76
[17858.534838] ath9k: AWAKE -> NETWORK SLEEP
[17858.534853] wlan0: direct probe to AP 00:1b:2f:58:30:76 try 1
[17858.534879] ath9k: NETWORK SLEEP -> AWAKE
[17858.538389] wlan0 direct probe responded
[17858.538394] wlan0: authenticate with AP 00:1b:2f:58:30:76
[17858.540608] wlan0: authenticated
[17858.540612] wlan0: associate with AP 00:1b:2f:58:30:76
[17858.543844] wlan0: RX ReassocResp from 00:1b:2f:58:30:76
(capab=3D0x431 status=3D0 aid=3D2)
[17858.543851] wlan0: associated
[17858.543885] phy1: Allocated STA 00:1b:2f:58:30:76
[17858.543897] phy1: Inserted STA 00:1b:2f:58:30:76
[17858.543900] wmaster0: WMM queue=3D2 aci=3D0 acm=3D0 aifs=3D3 cWmin=3D=
15
cWmax=3D1023 txop=3D0
[17858.543913] wmaster0: WMM queue=3D3 aci=3D1 acm=3D0 aifs=3D7 cWmin=3D=
15
cWmax=3D1023 txop=3D0
[17858.543922] wmaster0: WMM queue=3D1 aci=3D2 acm=3D0 aifs=3D2 cWmin=3D=
7 cWmax=3D15 txop=3D94
[17858.543931] wmaster0: WMM queue=3D0 aci=3D3 acm=3D0 aifs=3D2 cWmin=3D=
3 cWmax=3D7 txop=3D47
[17858.543944] wlan0: switched to short barker preamble
(BSSID=3D00:1b:2f:58:30:76)
[17858.543946] wlan0: switched to short slot time (BSSID=3D00:1b:2f:58:=
30:76)
[17858.544358] ath9k: tsf: 18236047462 tsftu: 17808642
[17858.544365] ath9k: bmiss: 10 sleep: 100 cfp-period: 10000 maxdur: 0
next: 17810100
[17858.544384] ath9k: next DTIM 17810100
[17858.544387] ath9k: next beacon 17808700
[17858.544390] ath9k: beacon period 100
[17858.544393] ath9k: DTIM period 10000
[17859.551695] ath9k: AWAKE -> AWAKE
[17859.551803] ath9k: AWAKE -> NETWORK SLEEP
[17859.553670] ath9k: NETWORK SLEEP -> AWAKE
[17859.626507] ath9k: AWAKE -> AWAKE
[17862.241612] ath9k: NETWORK SLEEP -> AWAKE
[17862.241693] ath9k: AWAKE -> NETWORK SLEEP
[17862.241719] ath9k: NETWORK SLEEP -> AWAKE
[17862.241792] ath9k: AWAKE -> NETWORK SLEEP
[17862.341627] ath9k: NETWORK SLEEP -> AWAKE
[17862.341710] ath9k: AWAKE -> NETWORK SLEEP
[17862.341732] ath9k: NETWORK SLEEP -> AWAKE
[17862.341805] ath9k: AWAKE -> NETWORK SLEEP
[17862.441623] ath9k: NETWORK SLEEP -> AWAKE
[17862.441703] ath9k: AWAKE -> NETWORK SLEEP
[17862.541625] ath9k: NETWORK SLEEP -> AWAKE
[ ...above messages repeated many times... ]
[17862.541706] ath9k: AWAKE -> NETWORK SLEEP
[17862.541727] ath9k: NETWORK SLEEP -> AWAKE
[17862.541800] ath9k: AWAKE -> NETWORK SLEEP
[17862.541818] ath9k: NETWORK SLEEP -> AWAKE
[17862.541900] ath9k: AWAKE -> NETWORK SLEEP
[17862.554921] wlan0: beacon loss from AP 00:1b:2f:58:30:76 - sending
probe request

< it is able to reconnect just for a moment, but immediately after
that it fails again in the same way >

Hope it might be useful!

Regards,
Davide
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
