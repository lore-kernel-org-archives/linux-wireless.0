Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:40754 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753863Ab2ECRXg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 13:23:36 -0400
Message-ID: <4FA2BF0A.4040307@stericsson.com> (sfid-20120503_192339_535327_DD930298)
Date: Thu, 3 May 2012 19:23:22 +0200
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
To: Kevin Groeneveld <kgroeneveld@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com> <4FA15A70.2020108@stericsson.com> <CABF+-6XbdG_QMa0iQJMpbOsr4bXCq4mDEB6unkM8jxNGWYwFyQ@mail.gmail.com> <4FA23DA0.3030207@stericsson.com> <CABF+-6WjnVxC55iGHwoaL2zJ+_6oLbkVjaqwwLLrQzZxKwwWxw@mail.gmail.com>
In-Reply-To: <CABF+-6WjnVxC55iGHwoaL2zJ+_6oLbkVjaqwwLLrQzZxKwwWxw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kevin,


> However, I have not been able to actually connect
> to any networks. :(
You actually connected :)

AUTH request:
[   17.207870] [WSM] >>> 0x0004 (54) 8e49b458
[   17.207969] --> 36 00 04 40 00 00 00 02 00 03 00 0a 00 00 00 00  
6..@............
[   17.207983] --> 00 00 00 00 01 00 00 00 b0 00 3a 01 c0 3f 0e 87  
..........:..?..
[   17.207994] --> f3 0e 00 80 e1 3d 80 24 c0 3f 0e 87 f3 0e 90 04  
.....=.$.?......
[   17.208005] --> 00 00 01 00 00 00                                ......

AUTH response:
[   17.209535] <-- 2e 00 04 48 00 00 00 00 03 00 00 76 00 08 01 00  
...H.......v....
[   17.209548] <-- b0 00 3a 01 00 80 e1 3d 80 24 c0 3f 0e 87 f3 0e  
..:....=.$.?....
[   17.209559] <-- c0 3f 0e 87 f3 0e a0 00 00 00 02 00 00 00        
.?............
[   17.209570] [WSM] <<< 0x0804 (46)

ASSOC request:
[   17.216524] [WSM] >>> 0x0004 (86) 8e49b418
[   17.216622] --> 56 00 04 60 00 00 00 02 00 03 00 0a 00 00 00 00  
V..`............
[   17.216635] --> 00 00 00 00 01 00 00 00 00 00 3a 01 c0 3f 0e 87  
..........:..?..
[   17.216647] --> f3 0e 00 80 e1 3d 80 24 c0 3f 0e 87 f3 0e a0 04  
.....=.$.?......
[   17.216658] --> 21 04 05 00 00 07 63 77 5f 74 65 73 74 01 08 02  
!.....cw_test...
[   17.216669] --> 04 0b 16 0c 12 18 24 32 04 30 48 60 6c dd 07 00  
......$2.0H`l...
[   17.216680] --> 50 f2 02 00 01 0f                                P.....

ASSOC response:
[   17.223949] <-- 6f 00 04 88 00 00 00 00 03 00 00 78 00 08 01 00  
o..........x....
[   17.223962] <-- 10 00 3a 01 00 80 e1 3d 80 24 c0 3f 0e 87 f3 0e  
..:....=.$.?....
[   17.223974] <-- c0 3f 0e 87 f3 0e b0 00 21 04 00 00 01 c0 01 08  
.?......!.......
[   17.223985] <-- 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18  
.......$2.0H`l..
[   17.223997] <-- 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00  
.P..........'...
[   17.224008] <-- 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00  
BC^.b2/.........
[   17.224019] <-- 00 ff 7f dd 0a 00 03 7f 04 01 00 02 00 40 00     
.............@.
[   17.224030] [WSM] <<< 0x0804 (111)
,

but then you've got almost immediately
[   18.926444] wlan0: Connection to AP c0:3f:0e:87:f3:0e lost.
It looks like mac80211 tries to monitor beacons and they are filtered by 
cw1200 device.

IEEE80211_HW_CONNECTION_MONITOR and / or IEEE80211_HW_BEACON_FILTER flags
(I don't remember, but both of them should be set) should prevent 
mac80211 from
monitoring. Please check if they are set in 
drivers/net/wireless/cw1200/main.c

>
>> Also I see unexpectedly high rate of IRQs, they should not come every now
>> and then..
> Any ideas what could cause this or how I should debug it?
Are you running with SDIO or GPIO IRQ?


With best regards,
Dmitry

