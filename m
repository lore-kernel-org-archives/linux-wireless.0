Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f45.google.com ([209.85.128.45]:51813 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3KICdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 21:33:22 -0500
Received: by mail-qe0-f45.google.com with SMTP id 8so2776829qea.18
        for <linux-wireless@vger.kernel.org>; Fri, 08 Nov 2013 18:33:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87B8D697-4540-4D0E-975B-125531E6833B@net.t-labs.tu-berlin.de>
References: <19772470.YgPhAz9cYD@bentobox>
	<87B8D697-4540-4D0E-975B-125531E6833B@net.t-labs.tu-berlin.de>
Date: Fri, 8 Nov 2013 18:33:19 -0800
Message-ID: <CAJ-VmombLQqJsN50nndqCioFEOy=9cp_-34onQnWnpMoX6360w@mail.gmail.com> (sfid-20131109_033337_615786_701CBA0D)
Subject: Re: [OpenWrt-Devel] [ath9k-devel] ath9k: Deaf QCA9558 when setting rxchainmask
From: Adrian Chadd <adrian@freebsd.org>
To: OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Cc: Sven Eckelmann <sven@open-mesh.com>,
	"simon@open-mesh.com" <simon@open-mesh.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hm, is the 0x5 chainmask triggering the ALT_CHAIN logic?

What are you trying to do? Control the receive antenna config, or the
transmit antenna config?


-a


On 8 November 2013 16:32, Julius Schulz-Zander
<julius@net.t-labs.tu-berlin.de> wrote:
> Hi Sven,
>
> I've asked nbd about this some time ago. It doesn't work if you have gaps in the chain mask! Try chain mask 3 (110) and it should work with 2x2.
>
> Regards,
>  -Julius
>
> On 06.11.2013, at 16:04, Sven Eckelmann <sven@open-mesh.com> wrote:
>
>> Hi,
>>
>> I've needed to test some problems with a QCA9558 Rev 0 based 3x3 2.4G device.
>> During these tests I've wanted to try different antenna configurations to
>> reduce the complexity of the problem. This was done by setting the
>> rxchainmask/txchainsmask to settings like 1, 5 and 7. Unfortunatelly, the
>> setting 5 (antenna 0 and 1) turned the device completely deaf. Here an
>> overview of the settings (excerpt)
>>
>> chainmask | ant 0 | ant 1 | ant 2 | Status
>> 1         | 1     | 0     | 0     | works
>> 5         | 1     | 0     | 1     | deaf
>> 7         | 1     | 1     | 1     | works
>>
>> The antenna setting is used in ath9k at different places but trigger seems to
>> be the AR_PHY_RX_CHAINMASK register write in ar9003_phy.c in the function
>> ar9003_hw_set_chain_masks. Forcing it to 7 instead of the requested 5 avoids
>> this deaf state (but makes the rx chainmask setting useless). Of course, this
>> is not a valid workaround and quite unexpected.
>>
>> The test platform was a current trunk OpenWrt build together with compat-
>> wireless 2013-02-22, compat-wireless 2013-06-27 and backports 2013-10-31. The
>> settings were configured using the txantenna and rxantenna of the OpenWrt
>> wireless config system. Both were always set to the same values during the
>> tests.
>>
>> The deaf state was identified using 1x1 and 2x2 clients which could receive
>> the beacons of the device. The QCA9558 device was then unable to receive the
>> probe request from the clients or any other traffic on the air. This was also
>> checked by a monitor (flags: control) interface on the same phy.
>>
>> Maybe someone knows whether this is a known problem with this SoC or what
>> information can be gathered to debug this problem further.
>>
>> Kind regards,
>>    Sven
>> _______________________________________________
>> ath9k-devel mailing list
>> ath9k-devel@lists.ath9k.org
>> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
> _______________________________________________
> openwrt-devel mailing list
> openwrt-devel@lists.openwrt.org
> https://lists.openwrt.org/cgi-bin/mailman/listinfo/openwrt-devel
