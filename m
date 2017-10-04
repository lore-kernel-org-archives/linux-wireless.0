Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.aosc.io ([199.195.250.187]:42879 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751198AbdJDKPS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 06:15:18 -0400
Date: Wed, 04 Oct 2017 18:15:11 +0800
In-Reply-To: <20171004101145.kgjufpcktodppuy3@flea>
References: <20171003165944.13056-1-icenowy@aosc.io> <20171003165944.13056-2-icenowy@aosc.io> <871smjxp46.fsf@kamboji.qca.qualcomm.com> <E46F3A20-294A-497E-AF71-C77A67AFDB8C@aosc.io> <59D4B1C8.8020105@broadcom.com> <20171004101145.kgjufpcktodppuy3@flea>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: [PATCH v3 1/2] dt-bindings: add device tree binding for Allwinner XR819 SDIO Wi-Fi
To: linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
CC: devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
From: Icenowy Zheng <icenowy@aosc.io>
Message-ID: <C4895259-FCDE-4B21-BB15-8F150FC53BE3@aosc.io> (sfid-20171004_121547_597872_327166FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



于 2017年10月4日 GMT+08:00 下午6:11:45, Maxime Ripard <maxime.ripard@free-electrons.com> 写到:
>On Wed, Oct 04, 2017 at 10:02:48AM +0000, Arend van Spriel wrote:
>> On 10/4/2017 11:03 AM, Icenowy Zheng wrote:
>> > 
>> > 
>> > 于 2017年10月4日 GMT+08:00 下午5:02:17, Kalle Valo <kvalo@codeaurora.org>
>写到:
>> > > Icenowy Zheng <icenowy@aosc.io> writes:
>> > > 
>> > > > Allwinner XR819 is a SDIO Wi-Fi chip, which has the
>functionality to
>> > > use
>> > > > an out-of-band interrupt pin instead of SDIO in-band interrupt.
>> > > > 
>> > > > Add the device tree binding of this chip, in order to make it
>> > > possible
>> > > > to add this interrupt pin to device trees.
>> > > > 
>> > > > Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
>> > > > Acked-by: Rob Herring <robh@kernel.org>
>> > > > ---
>> > > > Changes in v3:
>> > > > - Renames the node name.
>> > > > - Adds ACK from Rob.
>> > > > Changes in v2:
>> > > > - Removed status property in example.
>> > > > - Added required property reg.
>> > > > 
>> > > >   .../bindings/net/wireless/allwinner,xr819.txt      | 38
>> > > ++++++++++++++++++++++
>> > > >   1 file changed, 38 insertions(+)
>> > > >   create mode 100644
>> > >
>Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt
>> > > 
>> > > Like I asked already last time, AFAICS there is no upstream xr819
>> > > wireless driver in drivers/net/wireless directory. Do we still
>accept
>> > > bindings like this for out-of-tree drivers?
>> > 
>> > See esp8089.
>> > 
>> > There's also no in-tree driver for it.
>> 
>> The question is whether we should. The above might be a precedent,
>but it
>> may not necessarily be the way to go. The commit message for esp8089
>seems
>> to hint that there is intent to have an in-tree driver:
>> 
>> """
>>     Note that at this point there only is an out of tree driver for
>this
>>     hardware, there is no clear timeline / path for merging this.
>Still
>>     I believe it would be good to specify the binding for this in
>tree
>>     now, so that any future migration to an in tree driver will not
>cause
>>     compatiblity issues.
>> 
>>     Cc: Icenowy Zheng <icenowy@aosc.xyz>
>>     Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>     Signed-off-by: Rob Herring <robh@kernel.org>
>> """
>> 
>> Regardless the bindings are in principle independent of the kernel
>and just
>> describing hardware. I think there have been discussions to move the
>> bindings to their own repository, but apparently it was decided
>otherwise.
>
>Yeah, I guess especially how it could be merged with the cw1200 driver
>would be very relevant to that commit log.

The cw1200 driver seems to still have some legacy platform
data. Maybe they should also be convert to DT.
(Or maybe compatible = "allwinner,xr819" is enough, as
xr819 is a specified variant of cw1200 family)

>
>Maxime
