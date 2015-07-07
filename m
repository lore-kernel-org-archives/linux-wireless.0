Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:60001 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757607AbbGGOgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 10:36:00 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "David Lin" <dlin@marvell.com>, "Jonas Gorski" <jogo@openwrt.org>,
	"Chor Teck Law" <ctlaw@marvell.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Pete Hsieh" <peteh@marvell.com>
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
 <CAOiHx=ncv=N33-CC-F0=_dovJ=PGsi3MBB3SEMg51fWcyuMmPg@mail.gmail.com>
 <e90aaab05cfd43fe9c05f738d4fc528a@SC-EXCH02.marvell.com>
 <CAOiHx=nnzfURJk6qeoyaV_qX0HPdtKSvZNmSNxKxypURMpNbkA@mail.gmail.com>
 <op.x1edl6b82s3iss@ecaz>
 <82abdac15d6a469082af54661922f50c@SC-EXCH03.marvell.com>
Date: Tue, 07 Jul 2015 16:35:56 +0200
MIME-Version: 1.0
From: "Imre Kaloz" <kaloz@openwrt.org>
Message-ID: <op.x1eqt6132s3iss@ecaz> (sfid-20150707_163604_472463_CF202736)
In-Reply-To: <82abdac15d6a469082af54661922f50c@SC-EXCH03.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 07 Jul 2015 15:48:38 +0200, Chor Teck Law <ctlaw@marvell.com>  
wrote:

>> >> Will change the title from "Marvell Wireless Wi-Fi driver (mwlwifi)"
>> >> to "Marvell 88W8864/88W8897 PCIe driver with AP support".
>> >
>> > As Imre pointed out, mwifiex also supports AP mode, so this is not a
>> > good description.
>
> We have explained a few times on this... Pls read about the difference  
> of mwifiex vs mwlwifi. There is a NOTE added to the description of  
> KConfig of mwlwifi.
>
> Would the community prefer this description instead: "Marvell  
> 88W8864/88W8897 driver with MAC80211 support"?

I have a different suggestion, please read below.

>> On the short run, changing the description of the drivers could work,
>> but I would suggest dropping (at least) 8897 support from mwifiex in
>> favor of mwlwifi. If supporting the 8766 isn't complicated, I would
>> drop PCIe support completely from there.
>>
>> David, Chor Teck, could you shed some light on the future driver
>> strategy?
>
> The mwlwifi as it is today, only supports said PCIe devices. There is no  
> near term plan for any other devices. But we cannot speak for future.  
> Let's comment based on the current state.

Sure thing, what I was talking about is more like making the driver  
selection less confusing for the enduser.

What I would propose is something along the lines (I have to cheat a bit,  
I know):

mwlwifi: "Marvell Avastar (802.11ac) PCIe support"
mwifiex: "Marvell Avastar (802.11n) support"
mwl8k :  "Marvell TopDog (802.11n) support"



Imre

PS:

Cheating as in mwl8k supports the 8764 Avastar radio and mwifiex supports  
11ac, but well...
