Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:50899 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbYISRsF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 13:48:05 -0400
Message-ID: <48D3E662.9050902@w1.fi> (sfid-20080919_194810_871368_0E093EB6)
Date: Fri, 19 Sep 2008 20:50:26 +0300
From: Jouni Malinen <j@w1.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Mikko_Virkkil=E4?= <mikko.virkkila@bluegiga.com>
CC: Mattias Nissler <mattias.nissler@gmx.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>, dsd@gentoo.org,
	kune@deine-taler.de, j@w1.fi
Subject: Re: ACK matching [was: TX status reporting with help of an ack	queue]
References: <1221494693.14102.22.camel@virkkmi-linux>	 <1221505251.4511.77.camel@localhost>	 <1221541089.14102.44.camel@virkkmi-linux>	 <200809162018.42576.IvDoorn@gmail.com>  <1221770220.4563.3.camel@localhost>	 <1221776990.4563.19.camel@localhost>	 <1221815294.19539.15.camel@virkkmi-linux>	 <1221817584.4491.29.camel@localhost>	 (sfid-20080919_114701_416600_478C4255)  <1221818057.10419.58.camel@johannes.berg>	 <1221819579.4491.34.camel@localhost>	 (sfid-20080919_122011_765612_F53F8EFC)  <1221820265.10419.78.camel@johannes.berg>	 <1221832302.4514.6.camel@localhost> <1221834033.22224.22.camel@virkkmi-linux>
In-Reply-To: <1221834033.22224.22.camel@virkkmi-linux>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mikko Virkkil=E4 wrote:
> On Fri, 2008-09-19 at 15:51 +0200, Mattias Nissler wrote:
>> On Fri, 2008-09-19 at 12:31 +0200, Johannes Berg wrote:
>>> But you can do workarounds all you want in hostapd, I don't care.

But I do care.. ;-)  As such, I would change that to "you can do
workarounds in your copy of hostapd". And yes, this would likely be the
best location for the workaround.

>>> However, I do think that if the hardware just isn't up to the job y=
ou
>>> should probably buy new hardware, after all, it's dirt cheap. :)

I have never seen wlan design that does not report frame ACK status
properly for transmitted unicast frames. Is it absolutely clear that
that is indeed the case here or could we should be missing some
documentation explaining how this should be done?

> I'd really love for some workaround that would allow AP mode to work.=
=20

The workaround would be to make hostapd generate bogus TX callback
internally with claim for a successfully received ACK when sending
(re)association response. I'm not very keen on including such
functionality and certainly do not consider dropping the correct
behavior because of a broken hw design.

If someone can come up with a clean patch that allows this to be
configured in hostapd.conf without affecting the default behavior, I
could consider applying the changes. However, please keep in mind that
I'm interested in using TX status reporting to improve reliability of
connection setup, so its use is more likely to increase in the future.

> It would be great if it could be deemed that the protocol doesn't rea=
lly
> require CTS protection/status information, and can be made reliable a=
nd
> standards compliant without support for it from the driver.
> Unfortunately I don't have high hopes for that, but I wonder what's M=
r.
> Malinen's opinion?

IEEE 802.11 association state in the AP is changed when receiving an AC=
K
from the STA for a (re)association response frame with success status
(see IEEE Std 802.11-2007, 11.3.2.2). In order to be able to implement
this correctly, AP mode operation require the TX status callback to
provide information for the ACK status of (re)association response
frames.

I would also like to see this status used to speed up recovery from=20
dropped EAPOL frames during IEEE 802.1X EAP authentication, 4-way
handshake and group handshake. In certain environments, this could
improve stability of connection establishment greatly.

- Jouni

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
