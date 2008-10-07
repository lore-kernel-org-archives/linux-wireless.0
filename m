Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYJGMeO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 08:34:14 -0400
Message-ID: <4ec10026d9f5ace4d4bbc76a2345cc81.squirrel@secure.sipsolutions.net>
In-Reply-To: <200810062328.43943.chunkeey@web.de>
References: <1223322501.3778.20.camel@johannes.berg>
    <200810062245.32965.chunkeey@web.de>
    <1223326065.3778.32.camel@johannes.berg>
    <200810062328.43943.chunkeey@web.de>
Date: Tue, 7 Oct 2008 14:34:10 +0200 (CEST)
Subject: Re: [PATCH] p54: fix build failure
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Christian Lamparter" <chunkeey@web.de>
Cc: "John Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> if only kmail let me disable it! :-)
> Is it off now? If not, I'm really sorry, for all html ****.
> I'll fix it, but it'll take another while.

Seems to be ok now.

>> However,
>>
>> > +int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int
>> > len);
>>
>> How about just killing the export instead? It isn't used anywhere else
>> anyway?
>
> True.
>
> on the other hand: what about stlc45xx (p54spi)?
> These ?SoC? chips don't have any eeprom attached to the I2C, but they
> need calibration data and output power limits like the usb/pci parts as
> well.

Yeah, but it hardly matters now, we can always re-export it when needed.

johannes
