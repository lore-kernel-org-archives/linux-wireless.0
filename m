Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64642 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750927AbcIMH2y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 03:28:54 -0400
Subject: Re: [PATCH v6 1/3] Documentation: dt: net: add ath9k wireless device
 binding
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
References: <20160821143105.27487-1-martin.blumenstingl@googlemail.com>
 <20160906214623.20424-1-martin.blumenstingl@googlemail.com>
 <20160906214623.20424-2-martin.blumenstingl@googlemail.com>
 <3b93ec95-ec7c-863a-06b7-fab4f2688855@rempel-privat.de>
 <CAFBinCAOQmk3KY1b+D1iKAOEBfasYyei681cae4PbD+201mzbQ@mail.gmail.com>
Cc: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        mcgrof@do-not-panic.com, mark.rutland@arm.com, robh+dt@kernel.org,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, nbd@nbd.name, arnd@arndb.de
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <f09d7e1e-a497-a8d7-46fe-6b9706686b26@rempel-privat.de> (sfid-20160913_092859_635330_B54B3877)
Date: Tue, 13 Sep 2016 09:28:11 +0200
MIME-Version: 1.0
In-Reply-To: <CAFBinCAOQmk3KY1b+D1iKAOEBfasYyei681cae4PbD+201mzbQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eCN7lRfgmlgfXNqfUoo01Pkd3OsX97dFt"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eCN7lRfgmlgfXNqfUoo01Pkd3OsX97dFt
Content-Type: multipart/mixed; boundary="vfoIpIQPVowbgohFtLMsXM1cjS4uE03MG";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
 linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
 mcgrof@do-not-panic.com, mark.rutland@arm.com, robh+dt@kernel.org,
 kvalo@codeaurora.org, chunkeey@googlemail.com, arend.vanspriel@broadcom.com,
 julian.calaby@gmail.com, bjorn@mork.no, nbd@nbd.name, arnd@arndb.de
Message-ID: <f09d7e1e-a497-a8d7-46fe-6b9706686b26@rempel-privat.de>
Subject: Re: [PATCH v6 1/3] Documentation: dt: net: add ath9k wireless device
 binding
References: <20160821143105.27487-1-martin.blumenstingl@googlemail.com>
 <20160906214623.20424-1-martin.blumenstingl@googlemail.com>
 <20160906214623.20424-2-martin.blumenstingl@googlemail.com>
 <3b93ec95-ec7c-863a-06b7-fab4f2688855@rempel-privat.de>
 <CAFBinCAOQmk3KY1b+D1iKAOEBfasYyei681cae4PbD+201mzbQ@mail.gmail.com>
In-Reply-To: <CAFBinCAOQmk3KY1b+D1iKAOEBfasYyei681cae4PbD+201mzbQ@mail.gmail.com>

--vfoIpIQPVowbgohFtLMsXM1cjS4uE03MG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 09.09.2016 um 22:57 schrieb Martin Blumenstingl:
> On Fri, Sep 9, 2016 at 9:48 AM, Oleksij Rempel <linux@rempel-privat.de>=
 wrote:
>>> +Optional properties:
>>> +- reg: Address and length of the register set for the device.
>>> +- qca,clk-25mhz: Defines that a 25MHz clock is used
>>
>> Some SoCs even Atheros WiSoCs use WiFi clock for System Clock. In this=

>> case we need to use clock framework any way, so why not in this case t=
oo?
>> Provide dummy static clock in DT and connect it with this node?
>>
>>         osc25m: oscillator {
>>                 compatible =3D "fixed-clock";
>>                 #clock-cells =3D <0>;
>>                 clock-frequency =3D <25000000>;
>>                 clock-accuracy =3D <30000>;
>>         };
>>
>>         acc: clock-controller@80040000 {
>>                 compatible =3D "some-clock-controller";
>>                 #clock-cells =3D <1>;
>>                 clocks =3D <&osc25m>;
>>                 reg =3D <0x80040000 0x204>;
>>         };
>>
>>
>> &pci0 {
>>         ath9k@168c,002d {
>>                 compatible =3D "pci168c,002d";
>>                 reg =3D <0x7000 0 0 0 0x1000>;
>>                 clocks =3D <&osc25m>;
>>                 qca,disable-5ghz;
>>         };
>> };
>>
>>
>> driver will need to use clk_get and compare frequency instead of
>> of_property_read_bool(np, "qca,clk-25mhz"). In this case you will need=

>> to define source clock only one time and reuse it by all affected DT
>> nodes. If we have 40MHz clock you will only need to change it in
>> fixed-clock.
> that does sound like a good idea, thanks for that input!
> However, I will remove the property for the first version because I am
> trying to get PCI(e) devices supported. OF support for AHB (WiSoC)
> needs more work (in other places, like ahb.c) anyways.
> But this suggestion should be remembered!
>=20
>>> +- qca,no-eeprom: Indicates that there is no physical EEPROM connecte=
d to the
>>> +                     ath9k wireless chip (in this case the calibrati=
on /
>>> +                     EEPROM data will be loaded from userspace using=
 the
>>> +                     kernel firmware loader).
>>> +- qca,disable-2ghz: Overrides the settings from the EEPROM and disab=
les the
>>> +                     2.4GHz band. Setting this property is only need=
ed
>>> +                     when the RF circuit does not support the 2.4GHz=
 band
>>> +                     while it is enabled nevertheless in the EEPROM.=

>>> +- qca,disable-5ghz: Overrides the settings from the EEPROM and disab=
les the
>>> +                     5GHz band. Setting this property is only needed=
 when
>>> +                     the RF circuit does not support the 5GHz band w=
hile
>>> +                     it is enabled nevertheless in the EEPROM.
>>
>> This option can be reused for every WiFi controller. Not only for qca.=

>> So may be instead of adding vendor specific name, make it reusable for=

>> all vendors. Instead of qca,disable-5ghz and qca,disable-2ghz make
>> disable-5ghz and disable-2ghz?
> I am personally fine with anything that fits best into the grand
> scheme of things.
> There are three scenarios I can think of which may be influenced by
> devicetree configuration:
> a) let the driver decide automatically whether the 2.4GHz and/or 5GHz
> band is/are enabled
> b) explicitly disable either bands (because the driver thinks due to
> whatever reason that a band is supported while in reality it isn't)
> c) explicitly enable a band (for example because the driver cannot
> automagically detect which band should be enabled)
>=20
> for ath9k we default to a) but also allow b): the EEPROM (device
> specific calibration data) contains information about which bands are
> enabled (or not). But some manufacturers are shipping devices for
> example with the 5G band enabled, while the actual hardware doesn't
> support it.
>=20
> Felix' mt76 driver for example defaults to case a) but allows
> overriding (=3D forcefully enabling or disabling) a specific band.
>=20
> If we decide how this should look like in the devicetree then I can go
> ahead and implement it accordingly.

To avoid possible conflict with other device-tree bindings i would
suggest this kind of naming:
ieee80211-5ghz-enalbe
ieee80211-5ghz-disable
ieee80211-2.4ghz-enalbe
ieee80211-2.4ghz-disable

i assume at some point we would get even more eeprom overrides. For
example disable/enable some modulation and so on.

we would need 80211 specific functions to read this overrides from
device-tree and/or acpi.

any feedback from DT maintainers?
--=20
Regards,
Oleksij


--vfoIpIQPVowbgohFtLMsXM1cjS4uE03MG--

--eCN7lRfgmlgfXNqfUoo01Pkd3OsX97dFt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlfXqpMACgkQHwImuRkmbWls4gD7B0zeVZW3xptz5TRfZuvpgvrC
fihJcQGMtEv3rC6UfmoA+QF9xkau+RiS0FrHjrGylKORUTybF+iIUs3Br6i04Sn8
=NMB9
-----END PGP SIGNATURE-----

--eCN7lRfgmlgfXNqfUoo01Pkd3OsX97dFt--
