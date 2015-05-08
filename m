Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:34510 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbbEHJxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 05:53:54 -0400
Received: by iget9 with SMTP id t9so27882616ige.1
        for <linux-wireless@vger.kernel.org>; Fri, 08 May 2015 02:53:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <554C81D2.8080602@broadcom.com>
References: <1431030535-11083-1-git-send-email-zajec5@gmail.com>
	<554C81D2.8080602@broadcom.com>
Date: Fri, 8 May 2015 11:53:53 +0200
Message-ID: <CACna6rxV_sR1WhrHRwtM8cjengsCbm_iUWzy0n_+fLYmxypmMw@mail.gmail.com> (sfid-20150508_115357_700641_6F1FA6C4)
Subject: Re: [PATCH RFC:rxctl wait timed out] brcmfmac: add BCM43526 USB support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 May 2015 at 11:28, Arend van Spriel <arend@broadcom.com> wrote:
> On 05/07/15 22:28, Rafał Miłecki wrote:
>> I'm trying to add BCM43526 support. This chipset can be found in:
>> 1) Some USB dongles, e.g. Tenda W900U uses revision 2
>> 2) Some routers, e.g. Asus RT-AC53U uses revision 3+
>>
>> Unfortunately attached patch doesn't seem to be enough, brcmfmac doesn't
>> work with my Tenda W900U. I keep getting following error:
>>>
>>> brcmfmac: brcmf_usb_recv_ctl Enter
>>> brcmf_usb_rx_ctlpkt: rxctl wait timed out
>>> brcmfmac: brcmf_fil_cmd_data Failed: -5
>>
>>
>> It seems that:
>> 1) driver sends TX URB and gets completion callback called
>> 2) driver sents RX URB but it never gets completed
>
> Unfortunately this device is a BMAC device. You can tell by the 'high' word
> in the windows driver name. So there is no chance whatsoever to get this
> device going with brcmfmac.

Oh damn, I was sure Broadcom dropped this design back in BCM43236
times, I didn't even suspect newer chipsets may be still using it :(
Shit.

Do you have any idea about BCM43526 rev 3+? The chipsets using 43526b
instead of 43526a. Any chance BCM43526 rev 3+ is normal FullMAC device
just like BCM43236 rev 3+?
