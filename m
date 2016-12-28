Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35529 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbcL1WWP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 17:22:15 -0500
MIME-Version: 1.0
In-Reply-To: <ddd1bb11-eb4d-7a53-c3ea-5ff5e59ae100@nbd.name>
References: <20161228155955.25518-1-zajec5@gmail.com> <ddd1bb11-eb4d-7a53-c3ea-5ff5e59ae100@nbd.name>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 28 Dec 2016 23:22:13 +0100
Message-ID: <CACna6rxG=Jbac4QC8F5LFvO1N489HtkeuF1brZepa9uC_cxvwQ@mail.gmail.com> (sfid-20161228_232218_533429_EF5357DA)
Subject: Re: [PATCH 1/2] dt-bindings: document common IEEE 802.11 frequency properties
To: Felix Fietkau <nbd@nbd.name>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 December 2016 at 22:35, Felix Fietkau <nbd@nbd.name> wrote:
> On 2016-12-28 16:59, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> This new file should be used for properties handled at higher level and
>> so usable with all drivers.
>>
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>> ---
>>  .../devicetree/bindings/net/wireless/ieee80211.txt       | 16 +++++++++=
+++++++
>>  1 file changed, 16 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/wireless/ieee8=
0211.txt
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/ieee80211.tx=
t b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
>> new file mode 100644
>> index 0000000..c762769
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
>> @@ -0,0 +1,16 @@
>> +Common IEEE 802.11 properties
>> +
>> +This provides documentation of common properties that are handled by a =
proper
>> +net layer and don't require extra driver code.
>> +
>> +Optional properties:
>> + - ieee80211-min-center-freq : minimal supported frequency in KHz
>> + - ieee80211-max-center-freq : maximal supported frequency in KHz
>> +
>> +Example:
>> +
>> +pcie@0,0 {
>> +     reg =3D <0x0000 0 0 0 0>;
>> +     ieee80211-min-center-freq =3D <2437000>;
>> +     ieee80211-max-center-freq =3D <2457000>;
> I'm not sure that's the best way to deal with enabling/disabling bands.
> If we get more bands in the future, there might be unsupported ones in
> the middle, which min/max won't cover.

Maybe we could try specifying list of ranges? E.g.
ieee80211-center-frequencies =3D <2412000 2422000
    2442000 2452>;
or
ieee80211-center-frequencies =3D <2412000 2422000>,
    <2442000 2452>;
for device supporting channels 1, 2, 3, 7, 8, 9?

--=20
Rafa=C5=82
