Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45452 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965638AbaFQQhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 12:37:12 -0400
Message-ID: <53A06EB1.4040805@broadcom.com> (sfid-20140617_183742_360535_74589ABA)
Date: Tue, 17 Jun 2014 18:37:05 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Chen-Yu Tsai <wens@csie.org>, <linux-wireless@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	<linux-sunxi@googlegroups.com>
Subject: Re: [PATCH v2 4/4] brcmfmac: Fix OOB interrupt not working for BCM43362
References: <1402941407-8210-1-git-send-email-hdegoede@redhat.com> <1402941407-8210-5-git-send-email-hdegoede@redhat.com> <53A02B5A.3070409@broadcom.com> <53A05168.9010604@redhat.com>
In-Reply-To: <53A05168.9010604@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-06-14 16:32, Hans de Goede wrote:
> Hi,
>
> On 06/17/2014 01:49 PM, Arend van Spriel wrote:
>> On 16-06-14 19:56, Hans de Goede wrote:
>>> It has taken me a long long time to get the OOB interrupt working on the
>>> AP6210 sdio wifi/bt module found on various Allwinner A20 boards. In the
>>> end I found these magic register pokes in the cubietruck kernel tree:
>>> https://github.com/cubieboard2/linux-sunxi/commit/7f08ba395617d17e7a711507503d89a50406fe7a
>>>
>>> I'm not entirely sure if this specific to the AP6210 module, or if this
>>> should be done for all BCM43362 sdio devices.
>>
>> Hi Hans,
>>
>> I was still not sure about this one so I asked around. Apart from the nvram settings I emailed earlier one more is needed:
>>
>> sd_gpout=1
>> sd_oobonly=1
>> sd_gpval=1
>> *muxenab=0x11*
>>
>> Could you give that a try?
>
> I seriously doubt that is going to do anything at all, all 4 these keywords do not
> show up when running strings on brcmfmac43362-sdio.bin, where as all the
> keywords used in the brcmfmac43362-sdio.txt shipped with the android on ap6210
> equipped boards do show up, confirming that the keywords are encoded in plain text
> in the firmware file.
>
> Let me know if want me to give it a try anyways and I'll do so.
>
> Perhaps these keywords need a newer firmware version then the one in the
> linux-firmware repository ?

I will checkout the firmware release and see what is built there.

Thanks,
Arend
