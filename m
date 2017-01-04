Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:32967 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751253AbdADKJU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 05:09:20 -0500
Received: by mail-pf0-f180.google.com with SMTP id d2so82027464pfd.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2017 02:09:19 -0800 (PST)
Subject: Re: [PATCH V5 1/3] dt-bindings: document common IEEE 802.11 frequency
 limit property
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Rob Herring <robh@kernel.org>
References: <20170103225715.14072-1-zajec5@gmail.com>
 <d90127bd-6a9e-2773-fdf9-527afdc004a6@gmail.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <202768c7-b305-7eb0-e42e-dfecd5ec7800@broadcom.com> (sfid-20170104_110924_179384_3F15015B)
Date: Wed, 4 Jan 2017 11:02:13 +0100
MIME-Version: 1.0
In-Reply-To: <d90127bd-6a9e-2773-fdf9-527afdc004a6@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4-1-2017 7:20, Rafał Miłecki wrote:
> Hi Rob,
> 
> On 01/03/2017 11:57 PM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> This new file should be used for properties that apply to all wireless
>> devices.
>>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>> V2: Switch to a single ieee80211-freq-limit property that allows
>> specifying
>>     *multiple* ranges. This resolves problem with more complex rules
>> as pointed
>>     by Felx.
>>     Make description implementation agnostic as pointed by Arend.
>>     Rename node to wifi as suggested by Martin.
>> V3: Use more real-life frequencies in the example.
>> V5: Describe hardware design as possible use for this property
>> ---
>>  .../devicetree/bindings/net/wireless/ieee80211.txt   | 20
>> ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>  create mode 100644
>> Documentation/devicetree/bindings/net/wireless/ieee80211.txt
>>
>> diff --git
>> a/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
>> b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
>> new file mode 100644
>> index 0000000..1c82c16
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
>> @@ -0,0 +1,20 @@
>> +Common IEEE 802.11 properties
>> +
>> +This provides documentation of common properties that are valid for
>> all wireless
>> +devices.
>> +
>> +Optional properties:
>> + - ieee80211-freq-limit : list of supported frequency ranges in KHz.
>> This can be
>> +    used to specify extra hardware limitations caused by e.g. used
>> antennas
>> +    or power amplifiers.
> 
> Do you find this description sufficient now? I'm not sure how/if I could
> answer
> "Where would this data normally come from?" question.
>
> One vendor may hardcode choice of channels in their PHP web UI.
> Another one may do it in Andoid app.
> OpenWrt so far was describing this limitation on their wiki page.
> 
> It doesn't sound like any valuable info if I understand this correctly.
> We also
> don't describe where to get information about amount o RAM. One may just
> check
> the hardware, one may use vendor firmware, one could check product data
> sheet.
> 
> If I missed the point, could you help me get this?


There is probably no easy answer. DT is used to describe device
properties that are not otherwise discoverable (at least that is my rule
of thumb). So what is the "device" in this context? You may consider
just the chip, but in this case it is combination of the chip and its RF
path that determine the frequency range that it can operate in.
Apparently this was assured in user-space due to lack of a better
option. Having this specified in DT seems a viable option getting rid of
having a particular platform impose a requirement upon user-space.

You could consider these properties global as they are describing the
platform, but again this depends on what you consider the "device". If
you want to do this global you may add a global node for wifi properties
and use references to the device.

Regards,
Arend
