Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep12.mx.upcmail.net ([62.179.121.32]:36831 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2K1HLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 02:11:12 -0500
Message-ID: <50B5B915.2030706@think.ch> (sfid-20121128_081115_961245_39A7E7CA)
Date: Wed, 28 Nov 2012 08:11:17 +0100
From: Erich Titl <erich.titl@think.ch>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: regulatory domain settings overwritten
References: <50B470CE.8070402@think.ch> <CAGRGNgVT-Yru2ti9CWgwS5H2cfW=RTeL144zsdAmSRCAsLwOsg@mail.gmail.com> <50B4B7B6.7020205@think.ch> <CAGRGNgXz9L+DBuxii7p+r0m2SEa0Xy1JgDZqGf2-8xWuHBYdfQ@mail.gmail.com>
In-Reply-To: <CAGRGNgXz9L+DBuxii7p+r0m2SEa0Xy1JgDZqGf2-8xWuHBYdfQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050708040103050808090504"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dies ist eine kryptografisch unterzeichnete Nachricht im MIME-Format.

--------------ms050708040103050808090504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Julian

on 27.11.2012 23:55, Julian Calaby wrote:
> Hi Erich,
>=20
> On Tue, Nov 27, 2012 at 11:53 PM, Erich Titl <erich.titl@think.ch> wrot=
e:
>> Hi Julian
>>
=2E..

>=20
> Sorry about that, the last time I explained this, it was for a Chinese
> resident, and I got the codes mixed up.
>=20
> This "default" is part of the specification of how the hardware
> operates. If it hasn't been configured otherwise, it defaults to US
> operation. I'm sure that the Windows driver behaves in exactly the
> same way - this isn't some feature of the Linux driver, it's how the
> card is supposed to work.

I understand that well, but how is the driver supposed to know what the
default is?
In my case I got a card imported by a local OEM which gets them from
Taiwan directly.

=2E.

>=20
> Laws say otherwise. Each country has a different set of regulations
> for how they expect a WiFi card to operate. To make a card that is
> fully compliant with all these sets of regulations would require it to
> be tested against in a way which can prove that it complies with all
> those regulations. In general, as I understand it, cards are usually
> built for a particular market, and tested that they comply with that
> market's regulations, usually then ignoring any other country's
> regulations. Cheaper manufacturers may just use a reference design,
> which is probably built to comply with US regulations, and then just
> use the defaults.

Yes, but in my case the card says 'OK, use the default' and then the
default happens to be hard coded as US in he driver. In my book this is
different from a card saying, 'OH, I believe I am a US card, so please
behave US conformant'.

>=20
> The card is not "open", it's using the default configuration. The
> default configuration is that it's configured for US operation.

No, it is not, the card pretends nothing, the driver does.

>=20
>> So under the worst thinkable circumstances this code won't work for my=

>> environment as, for example, the intersection of the world regdomain a=
nd
>> the US regdomain would AFAIK cut away channels 12 and 13, which are
>> perfectly legal at my domicile and are used by some AP's.
>=20
> If you're using access points on channels 12 and 13, then yeah, using
> a card that is configured for US operation won't work for you.

Indeed and that is what I am ranting about.

>=20
>> I could (and will probably have to) recompile the driver using another=

>> regdomain file, but this is not really satisfactory either. IMHO the
>> regdomain should be chosen as seen fit and not imposed by hard coded
>> limits in the driver.
>=20
> You could recompile the driver to use the Swiss country code as the
> default, however then you'd be using the card in a way which is
> outside of it's specification.
>=20
> It is possible that your particular card cannot work predictably
> enough on channels 12 and 13 to comply with the Swiss regulations
> which is why it's been left at the default configuration.=20

The driver itself cannot be made responsible for the malfunction of the
card. If the card was restricted in any way, the manufacturer can and
IMHO _must_ use the EEPROM value to restrict it's use. This was _not_
done here, as the manufacturer cannot know what the driver author thinks
is the default.

It's also
> possible that it can comply with the regulations perfectly, but has
> never been tested and had the EEPROM set to indicate that it can
> comply with them.

Yes of course, it could be that way, but my past experience in IT leads
me to believe that manufacturers shy away from market specific hardware
design. This is why the CM9 does not specify a country code, but a
'default' setting.

>=20
> The simple fact of the matter is that the card is set to use the
> default configuration. The default configuration is for US operation,
> simple as that. This isn't short sighted Linux developers assuming
> that everyone is in the US, this is a design decision by the company
> that produced the card to give it a sensible default it can comply
> with.

Oh, I don't pretend the developers are short sighted, just that the
person writing the code sat possibly somewhere in the US midwest and his
perception of the world might be restricted to the county border, been
there, seen it. The driver IMHO should be written in a way that it can
meet the local regulatory law, and the default should not be US imposed
by the driver.

Nevertheless, I have patched the driver to do exactly that, if there is
no regdom specified in the EEPROM then use the one specified in the
cfg80211 options. The behaviour of the driver can be controlled right
now by a compile time flag, I might even turn that into a flag passed as
an option at load time.

cheers

Erich


--------------ms050708040103050808090504
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Kryptografische Unterschrift

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
--------------ms050708040103050808090504--
