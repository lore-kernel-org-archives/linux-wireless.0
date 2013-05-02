Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52090 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab3EBSBO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 14:01:14 -0400
Message-ID: <5182A9DC.6030203@openwrt.org> (sfid-20130502_200119_288279_EB8633E3)
Date: Thu, 02 May 2013 20:01:00 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: Adrian Chadd <adrian@freebsd.org>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH 1/2] ath9k_htc: add STBC TX support
References: <1367482308-9882-1-git-send-email-linux@rempel-privat.de> <1367482308-9882-2-git-send-email-linux@rempel-privat.de> <CAJ-Vmo=rZrHmXD0Os-Mb40jSEywbO-7GHSqL=7iMbkzAfS=+UQ@mail.gmail.com> <5182A341.8050704@rempel-privat.de>
In-Reply-To: <5182A341.8050704@rempel-privat.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-05-02 7:32 PM, Oleksij Rempel wrote:
> Am 02.05.2013 18:55, schrieb Adrian Chadd:
>> On 2 May 2013 01:11, Oleksij Rempel <linux@rempel-privat.de> wrote:
>>
>>> +#define WLAN_RC_TX_STBC_FLAG 0x20 /* TX STBC */
>>> +#define WLAN_RC_RX_STBC_FLAG 0xC0 /* RX STBC ,2 bits */
>>
>> I thought we covered this; why are you marking two bits here?
> 
> becouse firmware checks for two bits (and then use it as bool ;)), so i 
> pass what firmware can handle.
> 
>> Atheros 11n hardware only supports 1-stream STBC RX.
> 
> Did you got my email with lots of assumptions and questions?
> What do you mean by 1-stream STBC RX? After i did some home work on STBC 
> i see that it encoded from at least two spatial streams.
> Is
> 1-stream STBC RX = 2 spatial streams with mirrored data?
> and
> 2-stream STBC RX = 4 spatial streams with mirrored data?
> 
> or
> 
> 1-stream STBC RX = compatibility mode for one stream hardware(so only of 
> two streams received)?
When you're talking about 'streams', please specify where you're talking
about Spatial Streams (Nss, defined by the MCS), or Space-Time Streams
(Nsts). STBC is useful whenever the number of possible Space-Time
streams exceeds the number of Spatial streams, i.e. if the number of tx
chains is bigger than the number of spatial streams.
There's an asymmetry between Rx and Tx here. If a receiver has 1 chain
and the transmitter has 2 chains, tx can use 2 Space-Time streams to
encode 1 Spatial stream to improve the reliability of the signal.
The HT STBC capability field indicates the maximum number of Spatial
Streams, not Space-Time streams. Atheros hardware only supports STBC
with Nss = 1, so announcing 2-stream STBC is definitely wrong.

> That would make sense for 1x1:1 hardware, but if you say all atheros N 
> hardware support only 1-stream STBC RX, will mean that STBC is useless 
> on this hardware.
Only STBC With Nss=1, Nsts=2 is supported, but this does not make it
useless at all. It helps, even if the receiver only has one antenna.

- Felix
