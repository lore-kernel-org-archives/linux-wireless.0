Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9568 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1HPNcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 09:32:10 -0400
Message-ID: <4E4A7159.3090004@qca.qualcomm.com> (sfid-20110816_153214_750808_B58062A0)
Date: Tue, 16 Aug 2011 06:32:09 -0700
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Lin Tony-B19295 <B19295@freescale.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"rodrigue@qca.qualcomm.com" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmani@qca.qualcomm.com" <rmani@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
References: <1313060347-665-1-git-send-email-hauke@hauke-m.de> <97D3A72708D04647A5AC84A04996E5B5193114@039-SN1MPN1-002.039d.mgd.msft.net> <4E496CA7.7000604@hauke-m.de> <4E49BAB1.7060303@qca.qualcomm.com> <97D3A72708D04647A5AC84A04996E5B5195381@039-SN1MPN1-002.039d.mgd.msft.net>
In-Reply-To: <97D3A72708D04647A5AC84A04996E5B5195381@039-SN1MPN1-002.039d.mgd.msft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tony,

On 08/15/2011 09:59 PM, Lin Tony-B19295 wrote:
>
> 	Some questions regarding this ath6kl driver.
> 	Does it support all AR6003 card family? As I know there're several types of AR6003 cards

hw2.1.1 is supported and I'm using that for testing. The driver also
supports hw2.0 but I haven't tested that so there might be some issues.
hw1.0 is not supported.

> 	Does it support master mode?

Not yet, but hopefully in the near future.

> I tried the driver, seems it doesn't. need your confirmation.
> 		root@freescale ~$ iwconfig wlan0 mode master
> 		Error for wireless request "Set Mode" (8B06) :
>     		SET failed on device wlan0 ; Invalid argument.

Like Julian said, you need to use hostapd.

> 	Does it support suspend/resume well? From my experiments, seems not. After resuming, connection is lost.

I have a patch pending to add suspend support and will send it as soon
as I find some free time. But the wifi connection will be lost in resume
anyway. If you want to maintain the connection to AP during suspend then
you are looking for wowlan support which ath6kl doesn't currently support.

Kalle
