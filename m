Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:39381 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab3KBRGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Nov 2013 13:06:42 -0400
Received: by mail-lb0-f177.google.com with SMTP id u14so4321607lbd.36
        for <linux-wireless@vger.kernel.org>; Sat, 02 Nov 2013 10:06:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzY+RL+ikbSff3a7qb20ExxcSTx6U2xcL5CFr-BgVSOr61A@mail.gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
	<526E20EA.9090203@rempel-privat.de>
	<CAMP44s2Cvw9HF3c3Asuq+bTSD36Gw6PXOUVjAcCD+hf6KB_awg@mail.gmail.com>
	<CABPxzY+xJ7kst-sYwP8RJwMO_zkNYWKaYy=_LS7WQfuxquK24w@mail.gmail.com>
	<CAMP44s0087jYz5AiEaEzwt7GqH9ed8PWE1CmvMPr4Dqn3yE6rA@mail.gmail.com>
	<CABPxzYLwwyFCFw1pEt0v9Xw4kcue1C_RZx0RbTbMrUw=+MWvgQ@mail.gmail.com>
	<CAMP44s0svc2MRKCrZXS5ZYRZNPoomQkcKHdC2m2BGy7di+TCyA@mail.gmail.com>
	<CABPxzYL-Gzbzoc_ui+qUQ6uzoKp=Yq7yLWZvc7PoEjiH3dFczg@mail.gmail.com>
	<CAMP44s3uRF=jNn5ZHZ=QOcvuMoXxsfkxU=VOq3K02Q0qOspEdA@mail.gmail.com>
	<CABPxzYJbNjAwymwUq0pN=YyuCBGy2qz_BKafatHTWK+yH8PbkA@mail.gmail.com>
	<CAMP44s1NOS2p9pKeMLhR7616CzHeHJVJEzcF1tP6tsKfcPhSOQ@mail.gmail.com>
	<CABPxzY+RL+ikbSff3a7qb20ExxcSTx6U2xcL5CFr-BgVSOr61A@mail.gmail.com>
Date: Sat, 2 Nov 2013 11:06:40 -0600
Message-ID: <CAMP44s384vOcMc4vE82gAdVf37YUZfegmPHUSeobPO=gK6ErAw@mail.gmail.com> (sfid-20131102_180645_797506_34CFEB8F)
Subject: Re: I always need a miracle to connect with iwlwifi
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>, ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the crappy format (laptop is stuck).

If the problem is the firmware why does it start working when I
restart the router?

Plus, I should be seeing this problem with other APs.

And what could Windows be doing differently that doesn't exhibit this problem?

On 11/2/13, Krishna Chaitanya <chaitanya.mgit@gmail.com> wrote:
> On Sat, Nov 2, 2013 at 11:16 AM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>>
>> On Tue, Oct 29, 2013 at 8:23 AM, Krishna Chaitanya
>> <chaitanya.mgit@gmail.com> wrote:
>> > On Tue, Oct 29, 2013 at 3:02 AM, Felipe Contreras
>> > <felipe.contreras@gmail.com> wrote:
>>
>> >> Yes, but maybe I overrode the file. I've pushed a new one again. The
>> >> sha-1 is 36c260d8d8c171a24eb1aa7b2ea736b06c9b55b7.
>> >>
>> > Thanks, able to decode now. I am not familiar with the
>> > iwlwifi code, but let me give it a try.
>>
>> Did you find anything?
>
> Not Much, i could see the below pattern repeating
>
>   wpa_supplicant-6915  [003]  5610.786592: drv_return_void:      phy1
>   wpa_supplicant-6915  [003]  5610.786594: drv_sta_state:        phy1
> vif:wlan0(2) sta:e0:1d:3b:46:82:a0 state: 0->1
>   wpa_supplicant-6915  [003]  5610.786597: iwlwifi_dev_hcmd:
> [0000:02:00.0] hcmd 0x18 (sync)
>   irq/44-iwlwifi-6803  [001]  5610.786632: iwlwifi_dev_rx:
> [0000:02:00.0] RX cmd 0x18
>   wpa_supplicant-6915  [003]  5610.786639: drv_return_int:       phy1 - 0
>   wpa_supplicant-6915  [003]  5610.786645: drv_mgd_prepare_tx:   phy1
> vif:wlan0(2)
>   wpa_supplicant-6915  [003]  5610.786645: drv_return_void:      phy1
>   wpa_supplicant-6915  [003]  5610.786663: iwlwifi_dev_tx:
> [0000:02:00.0] TX 1c (90 bytes)
>   irq/44-iwlwifi-6803  [001]  5610.788677: iwlwifi_dev_rx:
> [0000:02:00.0] RX cmd 0x1c
>   irq/44-iwlwifi-6803  [001]  5610.788709: iwlwifi_dev_rx:
> [0000:02:00.0] RX cmd 0xc0
>   irq/44-iwlwifi-6803  [001]  5610.788710: iwlwifi_dev_rx:
> [0000:02:00.0] RX cmd 0xc1
>     kworker/u8:0-1459  [003]  5610.788730: drv_sta_state:        phy1
> vif:wlan0(2) sta:e0:1d:3b:46:82:a0 state: 1->2
>     kworker/u8:0-1459  [003]  5610.788732: drv_return_int:       phy1 - 0
>     kworker/u8:0-1459  [003]  5610.999549: drv_sta_state:        phy1
> vif:wlan0(2) sta:e0:1d:3b:46:82:a0 state: 2->1
>     kworker/u8:0-1459  [003]  5610.999553: drv_return_int:       phy1 - 0
>     kworker/u8:0-1459  [003]  5610.999553: drv_sta_state:        phy1
> vif:wlan0(2) sta:e0:1d:3b:46:82:a0 state: 1->0
>     kworker/u8:0-1459  [003]  5610.999554: drv_return_int:       phy1 - 0
>
> So We move from NONE to AUTH and then AUTH to NONE. iwlwifi_dev_tx is
> transmistting 90 bytes packets
> but auth request is only 43 bytes, could that be association request??
> If yes where is that getting dropped.
>
> So my guess is that we are sending the association request (CMD_TX),
> but its never seen OTA, its lost some where in between.
> Ball goes to the FW :-).
>


-- 
Felipe Contreras
