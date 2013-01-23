Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.saemichips.co.kr ([211.55.81.226]:38809 "EHLO
	mail.ebizcenter.co.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3AWFj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 00:39:57 -0500
Received: from GYJ ([39.115.113.222]:1459)
	by ktpbx.com with [XMail 1.22 PassKorea080324 ESMTP Server]
	id <S6155C2> for <linux-wireless@vger.kernel.org> from <gyj@x-node.co.kr>;
	Wed, 23 Jan 2013 14:14:25 +0900
From: =?ks_c_5601-1987?B?sce/68H4?= <gyj@x-node.co.kr>
To: "'Julian Calaby'" <julian.calaby@gmail.com>
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
References: <000301cdf87b$0ef2a020$2cd7e060$@co.kr> <CAGRGNgU8qDPZCWR0KryJ7_P0En-01AccBAH+qzyCExv9TFRSsQ@mail.gmail.com> <000301cdf911$4eb3d120$ec1b7360$@co.kr> <CAGRGNgVYr90v8-XhCm3-8LC7bafrbXkaD5pGGSvto-HDMParHw@mail.gmail.com>
In-Reply-To: <CAGRGNgVYr90v8-XhCm3-8LC7bafrbXkaD5pGGSvto-HDMParHw@mail.gmail.com>
Subject: RE: AR6003 :: IP packet is not received.
Date: Wed, 23 Jan 2013 14:39:50 +0900
Message-ID: <000e01cdf92c$10163320$30429960$@co.kr> (sfid-20130123_064002_991988_C1289350)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank Julian.
Please see my answer below.
And why the packet that starts at the PC does not expect to get a hint
about the arrival.


-----Original Message-----
From: Julian Calaby [mailto:julian.calaby@gmail.com] 
Sent: Wednesday, January 23, 2013 12:26 PM
To: 권용진
Cc: linux-wireless@vger.kernel.org; ath6kl-devel@qualcomm.com
Subject: Re: AR6003 :: IP packet is not received.

Hi Gueon,

I should have been clearer, I do not speak Korean.

That said, thanks for replying, I've translated it with Google, and
gotten the following:


2013/1/23 권용진 <gyj@x-node.co.kr>:
> Hello Julian. Korean Please're very nice to have.
>
> First'll answer the questions below you, so far, I made
> Once again, we will briefly described.
> 1) wpa_supplicant AP mode operation.
> Attachments (AR6000_Linux_SW_User_Guide.pdf) of page 45 in the simple
example
> Can.
> Hostapd as a test - but the situation is the same.
> 2) AR6003 lan card apparently lived, PC wireless embedded Board
> Were successfully connected (associated).

Just to confirm, it works if the embedded board is the Station and the
PC is the Access Point?
	==> PC is STA, embedded board(V210Board) is AP mode.


> 3) But first IP packet transfer from the PC AR6003 driver from any
> Is not responding.
> Confirmation of this phenomenon loosen all the the debug_mask ath6kl
driver
> Looked OK.
> So, do not receive any response for DHCP needs phenomena
> Showing that speculation.
> 4) embedded Board sends the IP packet to the PC, then it just
> Response from the PC, nor be
> PC from the beginning of IP packet transmission.
> 5) embededBoard, and hold the first ping, PC network settings
> If you modify the DHCP to get its IP address can also come.
> 6), and that was running on the PC ping ping stops from embededBoard also
> Does not like.
> Of course embededBoard back again to force a ping, ping from the PC
> Will be revived.
> [PC continue to do this as a ping-t 192.168.11.1
> Put]
> **) The transfer of the IP packet ping've

But not if the embedded board is the Access Point and the PC is the Station.

> My guess is that the H / W and driver porting seems to have no problem,
just
> that there is something wrong with the settings and ath6kl set the item
cfg80211 and related
> items
> Is there thought.
> I config entry for the wireless LAN on the basis of technical
understanding is not high
> Understanding is not high.

So you're assuming that the driver and hardware work, it's just
configuration settings. I think you're correct.

> [Now I proceed to rearrange let.]
>
> 2-1] that I use wifi EVM Taiwan USI WM-BN-AQ-01 is a board
> S5PV210 to use the connection.
> 2-2] USI associated with porting drivers from the
> Received Ath6kl_RCPatch4_LinuxRelease.tar.gz file attached files
> Had been included.
> 2-3] USI materials are distributed in ath6kl driver had been included, the
> there was something wrong driver.
> If you run ifconfig wlan0 up drvier null pointer
> had access to the phenomenon would die
> 've Asked a solution and report the problem to the USI, atheros support
> Direct answers that must be received.

So the driver you were provided did not work.

> 2-4], so I search through the internet compat-wireless-3.5.4-1.tar.bz2 the
> Saw the first porting
> But also ath6kl driver contained in this package, a few of the potential
problems and
> Can.
> Ifconfig wlan0 up and down repeatedly on the PC side of the AP name
occasionally
> You see, but not you see the phenomenon that occurs more commonly noticed
> Nl80211's know the exact cause, but I checked the log LOWER_UP
> Well, it did, and which flag, flag set, and also when the SSID from the PC
> Search
> Symptoms do not match.
> RTM_NEWLINK: operstate = 1 ifi_flags = 0x11043
> ([UP] [RUNNING] [LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added

And compat-wireless 3.5.4 partially worked.
	==> yes, Often does not. LOWER_UP.

> 2-5] compat-wireless-3.6.8-1.tar.bz2 customized porting were in the 2-4
> Phenomenon disappeared.
> May disappeared modified as follows. compat-wireless-3.
> 5.4-1 driver was modified from LOWER_UP phenomenon that does not
> Did not see.
> # If 1 / * gyj :: for set option :: set by this always
> RTM_NEWLINK: operstate = 1 ifi_flags = 0x11043 ([UP] [RUNNING]
[LOWER_UP]) by
> Is * /
> static unsigned int suspend_mode = WLAN_POWER_STATE_ON;
> static unsigned int wow_mode = WLAN_POWER_STATE_ON;
> # Else

And compat-wireless 3.6.8 worked, but you had to disable power saving?
	==> yes.

> 2-6] in the firmware image using the Ath6kl_RCPatch4_LinuxRelease.tar.gz
> Image, but had to use the firmware image from the GIT site
> Just bdata.bin from USI and file separately Flyer
> Attachments :: A93F.bin]. A lot of difference in the RSSI values seen on
the PC side
> Can.

Just to confirm, you are using the latest firmware?

There's instructions on the driver's wiki page:
http://linuxwireless.org/en/users/Drivers/ath6kl
	==> I used GIT site firmware.


> 2-7] run-time log file attached.
> 1) hostapd1.conf :: hostapd settings.
> 2) on the ath6kl_boot.txt :: ATH6KL_DBG_BOOT message is received.
> 3) hostapd_start_debug.txt :: hostapd trigger the coming
> Message.
> AP scan on the PC side hayeoseo
> No longer any connection sikyeodo message does not occur.
> PC side, a well-connected
> Appears to be DHCP, DHCP settings during attempts.
> 4) V210Board_ping_hostapd_msg.txt ::
> When you try to ping PC with Embedded Board hostapd
> Appearing debug message.
>
> Thank you for taking the time to read a lot of information.
> Thank you please.

So Access Point mode simply does not work.

Reading the page I linked above, Access Point mode requires hostapd
1.0 or newer.

Have you tried upgrading hostapd to the latest version?
	==> I'm using version 2.0.
			./hostapd -v
			  hostapd v2.0-devel

Other than that, there's not much else I can do. I don't know this
particular hardware and driver.

That said, recent development on it has been to add support for new
versions of the hardware, so it should work.

Can anyone else help?
         ==> Not the person to ask about this issue.

Thanks,

Julian Calaby


==== Original ====

2013/1/23 권용진 <gyj@x-node.co.kr>:
> 안녕하세요. Julian.  한국어를 하실수 있다니 대단히 반갑습니다.
>
> 아래 질문하신 내용부터 먼저 답변을 드리고,  지금까지 제가 진행한 내용을
> 다시 한번 간략하게 설명을 드리도록 하겠습니다.
>         1) wpa_supplicant도 AP mode로 동작이 됩니다.
> 첨부파일(AR6000_Linux_SW_User_Guide.pdf)의 page 45에도 간단한 예제가
> 있습니다.
>             그리고 hostapd 로도  시험을 해 보았지만  상황은 동일 합니다.
>         2) AR6003 lan card는 분명히 살았고,  PC에서 embedded Board로 무선
> 연결(associated)도 성공적으로 되었습니다.
>         3) 그런데 PC에서 먼저 IP packet 을 전송하면 AR6003 driver에서 어떤
> 반응도 보이지 않습니다.
>                 [이 현상의 확인은 ath6kl driver의 debug_mask를 모두 풀어서
> 확인을 해 보았습니다.]
>              그래서 DHCP 요구에 대한 어떤 응답도 받지를 못하는 현상을
> 보이고 있다고 추측을 합니다.
>         4) 다만 embedded Board에서 먼저  PC로 IP packet를 보내면  그때는
> PC에서 응답도 될 뿐더러,
>             PC에서 시작되는 IP packet들도 전송이 가능합니다.
>         5) embededBoard에서 먼저 ping을 시켜놓고,  PC에서 network 설정을
> DHCP로 수정하면 IP주소를 받아 올수도 있습니다.
>         6) 그리고 embededBoard에서 ping을 멈추면,  PC에서 실행되던 ping 도
> 같이 되지 않습니다.
>              물론 embededBoard에서 다시 ping을 해주면 PC에서의 ping 도
다시
> 살아 납니다.
>                [PC에서는   ping -t 192.168.11.1 로 계속 수행 시켜
> 놓았습니다.]
>         **) IP packet 의 전송은 ping으로 해 보았습니다.
>
> 저의 추측으로는  H/W 및 driver porting에는 문제가 없을 것 같고, 다만
> cfg80211 과 관련된 항목 설정과 ath6kl 설정 항목에 뭔가 문제가 되는 내용이
> 없을까 생각을 합니다.
> 제가 무선랜 기초 기술에 대한 이해도가 높지 않아서  config 항목들에 대한
> 이해도가 높지 않습니다.
>
>
> [자 이제 제가 지금까지 진행한 내용을 다시 정리해 보겠습니다.]
>
> 2-1] 제가 사용하는 wifi EVM은 대만 USI의 WM-BN-AQ-01 이라는 보드를
> S5PV210에 연결하여 사용하고 있습니다.
> 2-2]  USI로부터 드라이버 porting과 관련하여
> Ath6kl_RCPatch4_LinuxRelease.tar.gz 라는 파일을 받았는데, 첨부된 파일이
> 포함되어져 있었습니다.
> 2-3]  USI 에서 배포한 자료에도 ath6kl driver는 포함되어 있었는데, 그
> driver는 뭔가 문제가 있었습니다.
>           Ifconfig wlan0 up 을 실행하면  drvier에서   null pointer를
> access해서 죽어 버리는 현상을 보였고,
>          USI에 문제점을 report하고 해결책을 물어보았는데, atheros의 지원이
> 직접 받아야 한다는 답변만 받았습니다.
>
> 2-4] 그래서 제가 인터넷 검색을 통해서 compat-wireless-3.5.4-1.tar.bz2 를
> 먼저 porting을 해 보았습니다.
>         그런데 이 package에 포함된 ath6kl driver도 약간의 문제점을
내포하고
> 있습니다.
>         Ifconfig wlan0  up과 down을 반복하면  PC측에서  AP의 이름이 가끔
> 보일때도 있지만,  안 보일때가 더 많이 발생이 되는 현상이 나타났습니다.
>         정확한 원인은 알수가 없지만 nl80211의 log를 확인해 보니,  LOWER_UP
> flag가  set될때도 있고, 그렇치 않은 경우도 있는데 이 flag와 PC에서 SSID
> 검색이
>         되지 않는 현상과 일치 합니다.
>                 RTM_NEWLINK: operstate=1 ifi_flags=0x11043
> ([UP][RUNNING][LOWER_UP])
>                 RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
>
> 2-5] compat-wireless-3.6.8-1.tar.bz2 를 받아서 porting하였더니 위 2-4]의
> 현상은 없어 졌습니다.
>            아래와 같이 수정을 해서 사라졌을수도 있습니다. compat-wireless-
3.
> 5.4-1 driver에서 수정을 했는데 LOWER_UP이 되지 않는 현상을
>             보이지 않았습니다.
>                 #if 1   /* gyj :: for set option ::  이것을 set해서 항상
> RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP]) 가
> 된다. */
>                 static unsigned int suspend_mode=WLAN_POWER_STATE_ON;
>                 static unsigned int wow_mode=WLAN_POWER_STATE_ON;
>                 #else
>
> 2-6] 사용된 펌웨어 이미지는 Ath6kl_RCPatch4_LinuxRelease.tar.gz에도
> 이미지가 있지만  GIT site에서 받은 펌웨어 이미지를 사용했고,
>        다만 bdata.bin은  USI에서 별도로 전단된 파일을 사용하고
> 있습니다[첨부파일:: A93F.bin].  PC측에서 보이는 RSSI값에 많은 차이가
> 있습니다.
>
> 2-7]  실행시 log 파일 첨부.
>         1) hostapd1.conf   :: hostapd의 설정값 입니다.
>         2) ath6kl_boot.txt :: ATH6KL_DBG_BOOT를 on하여 받은 메시지 입니다.
>         3) hostapd_start_debug.txt :: hostapd를 시작 시켰을 때 나오는
> 메시지 입니다.
>                                              PC측에서 AP scan을 하여서
> 연결을 시켜도  더 이상 아무런 메시지는 발생하지 않습니다.
>                                              물론 PC측에서는 잘 연결된
> 것으로 나타나고, DHCP 설정시에는 DHCP 시도도 합니다.
>         4) V210Board_ping_hostapd_msg.txt ::
>                 Embedded Board에서  PC로  ping을 시도할때   hostapd에
> 나오는 debug  메시지 입니다.
>
> 많은 내용을 읽어 주셔서 감사합니다.
> 수고하십시요.
>
> -----Original Message-----
> From: Julian Calaby [mailto:julian.calaby@gmail.com]
> Sent: Tuesday, January 22, 2013 8:36 PM
> To: 권용진
> Cc: linux-wireless@vger.kernel.org; ath6kl-devel@qualcomm.com
> Subject: Re: AR6003 :: IP packet is not received.
>
> Hi Gueon,
>
> I wish I spoke Korean so we could talk easier.
>
> On Tue, Jan 22, 2013 at 7:32 PM, 권용진 <gyj@x-node.co.kr> wrote:
>> Dear ath6kl-devel,
>>
>> I Korea's human-intech Work in a company that is Gueon.
>> I am porting and embeded-board wlan AR6003 chipset features.
>> embeded-board CPU samsung S5PV210, linux kenel-2.6.32 is used.
>
> So you're porting Linux to an embedded board with a Samsung S5PV210
> CPU and a AR6003 wireless chipset.
>
> I assume that you have to use kernel version 2.6.32. I must point out
> that version is rather old and a lot of changes have been made to the
> drivers since then. That said, if needed, you may be able to use
> compat-wireless to get the latest version of the driver running on
> that particular kernel version.
>
>> wpa_supplicant using softAP mode, powered by letting success to other
> client devices (ex: Desktop PC) AP Access.
>>         [wpa_supplicant -i wlan0 -c /home/ath6k/SoftAP/softap.conf -
> Dnl80211 -B]
>>         [version : wpa_supplicant v2.0-devel Copyright (c) 2003-2012]
>>
>> Does not accept the IP address from the DHCP client device(PC), the
> problem occurs.
>
> So exactly what are you trying to do here?
>
> Are you:
>
> 1. Trying to use the embedded board as an access point and connecting
> the PC to it?
>
> 2. Trying to use the PC as an access point and connecting the embedded
> board to it?
>
> wpa_supplicant cannot run an access point. You need to use the hostapd
> program to run an access point.
>
>> I have a problem during the analysis.
>> I spoke to experiment by setting a fixed IP without using a DHCP
>> When embeded-Board from the PC to ping-test responses.
>> However, PC from the embedded-Board to ping-test does not responses.
>>
>> Whether the idea of something I could try?
>
> From what you've described, it sounds like the wireless cards are not
> connecting.
>
> What messages are you getting in the kernel log (dmesg)?
>
> If you run the "ifconfig -a" command, is your wireless card's network
> interface UP and RUNNING?
>
> Can you connect to an access point using this embedded board?
>
> Thanks,
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/
>
>



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/



