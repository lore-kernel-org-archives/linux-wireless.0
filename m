Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38518 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932707AbcI3Ooj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 10:44:39 -0400
Subject: Re: [PATCH v3 1/3] Documentation: dt: net: add mt76 wireless device
 binding
To: Arnd Bergmann <arnd@arndb.de>
References: <20160905095128.80560-1-nbd@nbd.name>
 <201609300041.41876.arnd@arndb.de>
 <3334122f-0d79-f910-a414-5b9cafd9901f@nbd.name>
 <201609301636.43363.arnd@arndb.de>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <557be2b8-5ff1-83ea-f6d1-6421c2465969@nbd.name> (sfid-20160930_164443_122116_B5C89A70)
Date: Fri, 30 Sep 2016 16:44:34 +0200
MIME-Version: 1.0
In-Reply-To: <201609301636.43363.arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-30 16:36, Arnd Bergmann wrote:
> On Friday 30 September 2016, Felix Fietkau wrote:
>> >> >> + pcie0 {
>> >> >> +         mt76@0,0 {
>> >> >> +                 reg = <0x0000 0 0 0 0>;
>> > 
>> > Maybe have an examplep of a real register address other than zero?
>> This is a real example referring to the first device on a PCI bus.
>> I copy&pasted this from a .dts file that we use in LEDE.
> 
> Ok, I see.
> 
>> >> >> +                 device_type = "pci";
>> >> >> +                 mediatek,mtd-eeprom = <&factory 0x8000>;
>> >> >> +                 mediatek,2ghz = <0>;
>> > 
>> > It's not clear what the possible values for the 2ghz property are,
>> > can you be more verbose in the description? How is <0> different
>> > from no property?
>> 0 means disabled, no property means unchanged (compared to EEPROM).
> 
> Maybe have a boolean property instead then to say "mediatek,2ghz-disabled" ?
> 
> If zero is the only possible value, there is no need to put a number in there.
1 is also possible, which will force-enable the capability.

- Felix
