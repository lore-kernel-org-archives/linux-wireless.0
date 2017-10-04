Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:46569 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdJDKCw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 06:02:52 -0400
Received: by mail-wm0-f42.google.com with SMTP id m72so21771128wmc.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Oct 2017 03:02:51 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] dt-bindings: add device tree binding for Allwinner
 XR819 SDIO Wi-Fi
To: Icenowy Zheng <icenowy@aosc.io>, Kalle Valo <kvalo@codeaurora.org>
References: <20171003165944.13056-1-icenowy@aosc.io>
 <20171003165944.13056-2-icenowy@aosc.io>
 <871smjxp46.fsf@kamboji.qca.qualcomm.com>
 <E46F3A20-294A-497E-AF71-C77A67AFDB8C@aosc.io>
Cc: Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <59D4B1C8.8020105@broadcom.com> (sfid-20171004_120310_860964_85F0EDC3)
Date: Wed, 4 Oct 2017 12:02:48 +0200
MIME-Version: 1.0
In-Reply-To: <E46F3A20-294A-497E-AF71-C77A67AFDB8C@aosc.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/4/2017 11:03 AM, Icenowy Zheng wrote:
>
>
> 于 2017年10月4日 GMT+08:00 下午5:02:17, Kalle Valo <kvalo@codeaurora.org> 写到:
>> Icenowy Zheng <icenowy@aosc.io> writes:
>>
>>> Allwinner XR819 is a SDIO Wi-Fi chip, which has the functionality to
>> use
>>> an out-of-band interrupt pin instead of SDIO in-band interrupt.
>>>
>>> Add the device tree binding of this chip, in order to make it
>> possible
>>> to add this interrupt pin to device trees.
>>>
>>> Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
>>> Acked-by: Rob Herring <robh@kernel.org>
>>> ---
>>> Changes in v3:
>>> - Renames the node name.
>>> - Adds ACK from Rob.
>>> Changes in v2:
>>> - Removed status property in example.
>>> - Added required property reg.
>>>
>>>   .../bindings/net/wireless/allwinner,xr819.txt      | 38
>> ++++++++++++++++++++++
>>>   1 file changed, 38 insertions(+)
>>>   create mode 100644
>> Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt
>>
>> Like I asked already last time, AFAICS there is no upstream xr819
>> wireless driver in drivers/net/wireless directory. Do we still accept
>> bindings like this for out-of-tree drivers?
>
> See esp8089.
>
> There's also no in-tree driver for it.

The question is whether we should. The above might be a precedent, but 
it may not necessarily be the way to go. The commit message for esp8089 
seems to hint that there is intent to have an in-tree driver:

"""
     Note that at this point there only is an out of tree driver for this
     hardware, there is no clear timeline / path for merging this. Still
     I believe it would be good to specify the binding for this in tree
     now, so that any future migration to an in tree driver will not cause
     compatiblity issues.

     Cc: Icenowy Zheng <icenowy@aosc.xyz>
     Signed-off-by: Hans de Goede <hdegoede@redhat.com>
     Signed-off-by: Rob Herring <robh@kernel.org>
"""

Regardless the bindings are in principle independent of the kernel and 
just describing hardware. I think there have been discussions to move 
the bindings to their own repository, but apparently it was decided 
otherwise.

Regards,
Arend
