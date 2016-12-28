Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35129 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbcL1UnG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 15:43:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAFBinCBNXdM-xVH9SaPZdFr3X0=k+py9aZ6Qj4ng=v1L-EvS7A@mail.gmail.com>
References: <20161228155955.25518-1-zajec5@gmail.com> <f387d897-a1e9-c932-8317-41246be245b0@broadcom.com>
 <CACna6rwhC=28fCHDzXok8Ka08g3yhcD2VNgQrfUZUCQRGqksOg@mail.gmail.com> <CAFBinCBNXdM-xVH9SaPZdFr3X0=k+py9aZ6Qj4ng=v1L-EvS7A@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 28 Dec 2016 21:43:05 +0100
Message-ID: <CACna6rwZJqYG3yYZ2gWhur8sThZ7Cf6ezAjciOjOkzyoWudB2g@mail.gmail.com> (sfid-20161228_214310_034020_C06BC392)
Subject: Re: [PATCH 1/2] dt-bindings: document common IEEE 802.11 frequency properties
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 December 2016 at 21:39, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> On Wed, Dec 28, 2016 at 9:32 PM, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.co=
m> wrote:
>> On 28 December 2016 at 21:05, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>> On 28-12-16 16:59, Rafa=C5=82 Mi=C5=82ecki wrote:
>>>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>>
>>>> This new file should be used for properties handled at higher level an=
d
>>>> so usable with all drivers.
>>>>
>>>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>> ---
>>>>  .../devicetree/bindings/net/wireless/ieee80211.txt       | 16 +++++++=
+++++++++
>>>>  1 file changed, 16 insertions(+)
>>>>  create mode 100644 Documentation/devicetree/bindings/net/wireless/iee=
e80211.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/wireless/ieee80211.=
txt b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
>>>> new file mode 100644
>>>> index 0000000..c762769
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
>>>> @@ -0,0 +1,16 @@
>>>> +Common IEEE 802.11 properties
>>>> +
>>>> +This provides documentation of common properties that are handled by =
a proper
>>>> +net layer and don't require extra driver code.
>>>
>>> Please do not make any assumptions on how DT properties are handled nor
>>> by what. Just state that these properties apply to all wireless devices
>>> and are applicable to device specific bindings.
>>
>> OK, I'll try to improve this description.
>>
>>
>>>> +Optional properties:
>>>> + - ieee80211-min-center-freq : minimal supported frequency in KHz
>>>> + - ieee80211-max-center-freq : maximal supported frequency in KHz
>>>> +
>>>> +Example:
>>>> +
>>>> +pcie@0,0 {
>>>> +     reg =3D <0x0000 0 0 0 0>;
>>>> +     ieee80211-min-center-freq =3D <2437000>;
>>>> +     ieee80211-max-center-freq =3D <2457000>;
>>>> +};
>>>
>>> Is this the proper level to define it. I was expecting a child node of
>>> the pci(e) controller. Maybe I am misreading the example.
>>
>> This is device node, not a controller node (and yes, it's complete
>> node). You just need to add such a node inside the controller one.
> you should name the node wifi@0,0 instead. I revised my ath9k OF
> binding documentation due to similar concerns (and after seeing the
> result I must admit that they were right). you can have a look at the
> result here: [0]

Thanks for your comment, I'm far from considering myself DT expert, so
I often need help with such things, I'll change this in V2.

--=20
Rafa=C5=82
