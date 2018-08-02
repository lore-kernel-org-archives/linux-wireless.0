Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:45717 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeHBJsT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 05:48:19 -0400
Received: by mail-oi0-f54.google.com with SMTP id q11-v6so2282704oic.12
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2018 00:58:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BY1PR02MB11143134B9ABAC9C9929A9C4E7530@BY1PR02MB1114.namprd02.prod.outlook.com>
References: <20180701110804.32415-1-afaerber@suse.de> <BY1PR02MB11147C7443AB9623D6B65798E75A0@BY1PR02MB1114.namprd02.prod.outlook.com>
 <e08cdcfb-207f-bd73-2afd-f775810b72b7@suse.de> <BY1PR02MB11143134B9ABAC9C9929A9C4E7530@BY1PR02MB1114.namprd02.prod.outlook.com>
From: Jian-Hong Pan <starnight@g.ncu.edu.tw>
Date: Thu, 2 Aug 2018 15:52:21 +0800
Message-ID: <CAC=mGzg0uP6ddm-kjev6JAH=GrKX9bT6s2canFOjKsC4rCcVAQ@mail.gmail.com> (sfid-20180802_095826_531560_A82EF90D)
Subject: Re: [RFC net-next 00/15] net: A socket API for LoRa
To: Ben Whitten <Ben.Whitten@lairdtech.com>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <mbrugger@suse.com>,
        Janus Piwek <jpiwek@arroweurope.com>,
        =?UTF-8?Q?Michael_R=C3=B6der?= <michael.roeder@avnet.eu>,
        Dollar Chen <dollar.chen@wtmec.com>,
        Ken Yu <ken.yu@rakwireless.com>,
        =?UTF-8?Q?Konstantin_B=C3=B6hm?= <konstantin.boehm@ancud.de>,
        Jan Jongboom <jan.jongboom@arm.com>,
        Jon Ortego <Jon.Ortego@imst.de>,
        "contact@snootlab.com" <contact@snootlab.com>,
        Brian Ray <brian.ray@link-labs.com>,
        "lora@globalsat.com.tw" <lora@globalsat.com.tw>,
        Alexander Graf <agraf@suse.de>,
        =?UTF-8?Q?Michal_Kube=C4=8Dek?= <mkubecek@suse.cz>,
        Rob Herring <robh@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Steve deRosier <derosier@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        Hasnain Virk <Hasnain.Virk@arm.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2018-07-18 19:28 GMT+08:00 Ben Whitten <Ben.Whitten@lairdtech.com>:
>> Subject: Re: [RFC net-next 00/15] net: A socket API for LoRa
>>
>> + linux-wireless + Stefan + Seth
>>
>> Am 11.07.2018 um 17:21 schrieb Ben Whitten:
>> >> This patchset is clearly not ready for merging, but is being
>> >> submitted for
>> >> discussion, as requested by Jiri, in particular of the design
>> >> choices:
>> >>
>> >> 1) PF_LORA/AF_LORA and associated identifiers are
>> >> proposed to represent
>> >>    this technology. While for an SX1276 - case a) above - it
>> >> might work to
>> >>    layer LoRaWAN as a protocol option for PF_LORA and
>> add
>> >> LoRaWAN address
>> >>    fields to the union in my sockaddr_lora, how would that
>> >> work for devices
>> >>    that only support LoRaWAN but not pure LoRa? Do we
>> >> need both AF_LORA and
>> >>    AF_LORAWAN, or just a separate ETH_P_LORAWAN or
>> >> ARPHRD_LORAWAN?
>> >>
>> >> 2) PF_LORA is used with SOCK_DGRAM here. The
>> >> assumption is that RAW mode
>> >>    would be DGRAM plus preamble plus optional
>> checksum.
>> >>
>> >> 3) Only the transmit path is partially implemented
>> already.
>> >> The assumption
>> >>    is that the devices should go into receive mode by
>> default
>> >> and only
>> >>    interrupt that when asked to transmit.
>> >>
>> >> 4) Some hardware settings need to be supplied
>> externally,
>> >> such as the radio
>> >>    frequency for some modules, but many others can be
>> >> runtime-configured,
>> >>    such as Spreading Factor, Bandwidth, Sync Word, or
>> which
>> >> antenna to use.
>> >>    What settings should be implemented as socket option
>> vs.
>> >> netlink layer
>> >>    vs. ioctl vs. sysfs? What are the criteria to apply?
>> >>
>> >> 5) Many of the modules support multiple modes, such as
>> >> LoRa, LoRaWAN and FSK.
>> >>    Lacking a LoRaWAN implementation, I am currently
>> >> switching them into LoRa
>> >>    mode at probe time wherever possible. How do we
>> deal
>> >> with that properly?
>> >>
>> >>   a) Is there any precedence from the Wifi world for
>> >> dynamically selecting
>> >>      between our own trusted Open Source
>> implementation
>> >> vs. hardware/firmware
>> >>      accelerated and/or certified implementations?
>> >>
>> >>   b) Would a proof of concept for FSK (non-LoRa) modes
>> be
>> >> required for
>> >>      merging any LoRa driver for chipsets that support
>> both?
>> >> Or is there any
>> >>      facility or design guidelines that would allow us to
>> focus
>> >> on LoRa and
>> >>      LoRaWAN and leave non-LoRa radio modes to later
>> >> contributors?
>> >
>> > Down the line I think we should also plan for a CRDA style
>> regdb somewhere in the path for raw LoRa transceivers
>> operating as softMAC, much like with WiFi.
>>
>> Yes, I had raised the topic of wireless-regdb for Stefan's
>> conference -
>> currently it seems to only cover 2.4 GHz, 5 GHz and 60 GHz.
>> Not sure if
>> we can easily extend that to cover 433 MHz, 868 MHz, 915
>> MHz and 923 MHz
>> bands or whether we'd just need something similar... Is
>> 802.15.4 able to
>> share this database with Wifi?
>
> Well the README in the wireless-regdb doesn't bind itself to 80211, there=
 are references to the other ETSI EN specs so this would be the place rathe=
r than duplicating.
> There would need a bit of additional information to capture duty-cycle re=
quirements, however the SRD spec states the maximum bandwidths can be 'The =
whole band', so with a flag set we could hijack this band information for d=
uty-cycle.
> I am unsure if 802.15.4 uses this database, most of the naming seems gear=
ed towards 80211, nl80211, cfg80211 so perhaps we need our own versions of =
these with a common component, I hope the maintainers can give some guidanc=
e here.
>
>> An argument to share with Wifi might be that Semtech's
>> SX1280 and SX1281
>> 2.4 GHz transceivers claim to support LoRa modulation, too.
>> Having two
>> different regulatory DBs interact with LoRa drivers seems a
>> bad idea,
>> and duplicating 2.4 GHz into a new DB doesn't sound
>> appealing either.
>
> Well I'm not sure if the modulation affects regulatory information, just =
bands, power, and techniques like DFS.
> As these chips are 2.4GHz only I expect they are bound by the existing re=
gulatory information we would just need a path to access it.
>
>> https://www.semtech.com/products/wireless-rf/24-ghz-
>> transceivers
>>
>> Meanwhile my attempt to play with netlink during SUSE
>> Hackweek has been
>> going slow and I could use some guidance or a volunteer to
>> contribute: I
>> have a bare skeleton of registration, commands, attributes
>> and multicast
>> groups, but no plan yet how to connect that to the actual
>> drivers to
>> query or apply the settings...
>
> Happy to help, I will be starting from zero on netlink but I can contribu=
te my existing work incorporating Marks comments for sx1301 etal.
>
>> https://git.kernel.org/pub/scm/linux/kernel/git/afaerber/li
>> nux-lora.git/tree/net/lora/netlink.c?h=3Dlora-next

Is this the repository used for the LoRa subsystem now?!!!
If it is, than great!

As the previous mails, I am trying to implement the LoRaWAN
specification as the soft MAC as the MAC layer over LoRa PHY.
This is the the talk about LoRaWAN class module I gave in Netdev Conf
https://www.slideshare.net/chienhungpan/lorawan-class-module-and-subsystem

The expectation is:

socket APIs:
send and receive the data
------------------------------------------------------------
LoRaWAN class module implements MAC:
append the header/footer, encryption/decryption, timing slot and MAC comman=
ds
------------------------------------------------------------
LoRa device drivers:
send and receive the messages for MAC layer
------------------------------------------------------------
LoRa devices

Is it possible that combine the LoRaWAN class module I implemented?
I start from the simplest class A end device's behavior, especially
the timing slot.
Also the encryption/decryption for uplink/downlink data messages.
I can send it as patches.

However, I have 2 problems right now.
1. Which Address and Protocol Family should we use?  PF_LORA or PF_LORAWAN?
2. To test the LoRaWAN class module, adding more procedures in LoRa
device drivers to register as a LoRaWAN device is needed.

Regards,
Jian-Hong Pan

>> > LoRa radios used in Gateway devices are typically relatively
>> high power (capable of 27dBm) and operate in bands with
>> certain restrictions, eg the EU has keep out areas within
>> 868MHz for alarms and SRD devices must abide by certain
>> duty cycle restrictions, there are also maximum powers to
>> consider for sub-bands. (ETSI EN 300 220-2 V3.2.1, Bands K,
>> L, M, N, P, Q)
>>
>> > The certified AT style modules will (should) already have
>> this regulatory data baked in so it only applied to situations
>> where we drive the transceivers directly, but it wouldn't
>> hurt to check that the frequency being asked to transmit on
>> doesn't spill into a restricted band.
>>
>> Some do have configuration options that will need to be set
>> or checked.
>>
>> Regards,
>> Andreas
>>
>> --
>> SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
>> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
>> HRB 21284 (AG N=C3=BCrnberg)
