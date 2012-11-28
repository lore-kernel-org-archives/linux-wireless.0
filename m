Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37509 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2K1RGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 12:06:41 -0500
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"mathias.kretschmer@fokus.fraunhofer.de"
	<mathias.kretschmer@fokus.fraunhofer.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>
Subject: Re: [ath9k-devel] [RFC 1/3] nl80211: add spec scan flag
Date: Wed, 28 Nov 2012 17:06:39 +0000
Message-ID: <8887AA04B7EC49479420AE48C5F94A930172CE02@NASANEXD02D.na.qualcomm.com> (sfid-20121128_180645_280780_F6FFD9EF)
In-Reply-To: <1354121848.9345.39.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/28/12 8:57 AM, "Johannes Berg" <johannes@sipsolutions.net> wrote:

>>>BTW, is there any limitation to remain on channel commands, like will
>>>they
>> >work on AP ifaces, Ad-Hoc ifaces, MultiSSID in general, etc?
>> 
>> I hope not. There may be some practical issues with not all drivers
>> supporting this, but remain-on-channel is the mechanism we use for
>> supporting concurrent operations (e.g., P2P negotiations or GAS/ANQP)
>>and
>> making this work in all combinations would be important regardless.
>
>FWIW, right now our plan for iwlwifi is to only really support it with
>the P2P Device wdev, but I'm not sure what implications that has in
>terms of support for GAS/ANQP etc. We might have to revisit that.

GAS/ANQP is pre-association if that makes any difference. Anyway, quite a
few new things will start depending on off channel Action frames and
everything I'm working on this area will most likely be using r-o-c..

>Maybe we should start advertising where it's supported so wpa_s/hostapd
>can disable/enable features appropriately?

Yeah, sounds reasonable. I guess you could also reject the r-o-c command,
but it is cleaner if this can be determined beforehand.

- Jouni

