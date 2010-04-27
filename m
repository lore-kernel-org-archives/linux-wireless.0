Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:56059 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab0D0BmZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 21:42:25 -0400
Message-ID: <4BD640F5.8010206@openwrt.org>
Date: Tue, 27 Apr 2010 03:42:13 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] cfg80211: add ap isolation support
References: <1272324216-73349-1-git-send-email-nbd@openwrt.org> 	<20100426232332.GA2079@tuxdriver.com> <4BD621FA.1000405@openwrt.org> 	<20100427001233.GB2079@tuxdriver.com> <t2i43e72e891004261725kdd3c1388jc2758db8a0b7e82@mail.gmail.com> <k2y43e72e891004261834w1eb604d0q83f9cd80820e3d8@mail.gmail.com>
In-Reply-To: <k2y43e72e891004261834w1eb604d0q83f9cd80820e3d8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-27 3:34 AM, Luis R. Rodriguez wrote:
> On Mon, Apr 26, 2010 at 5:25 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Mon, Apr 26, 2010 at 5:12 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>>> On Tue, Apr 27, 2010 at 01:30:02AM +0200, Felix Fietkau wrote:
>>>> On 2010-04-27 1:23 AM, John W. Linville wrote:
>>>> > On Tue, Apr 27, 2010 at 01:23:35AM +0200, Felix Fietkau wrote:
>>>> >> This is used to configure APs to not bridge traffic between connected stations.
>>>> >>
>>>> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>>> >
>>>> > Is this useful?
>>>> Yes, if you have an AP with lots of users that aren't expected to
>>>> communicate with each other (e.g. only for internet access), it can save
>>>> a lot of airtime by not forwarding every broadcast message emitted from
>>>> any station.
>>>> I'm sure there are a more situations where this can be useful.
>>>
>>> Ah, OK -- I suppose that makes sense.
>>
>> In fact technically IEEE-802.11 2007 section 11.7 states "STAs are not
>> allowed to transmit frames directly to other STAs in a BSS and should
>> always rely
>> on the AP for the delivery of the frames", with the exception being
>> using DLS direct links for QoS STAs.  This would prevent the STAs from
>> going into PS mode for as long duration of the stream.
>>
>> If the AP does not support this it would just set the result code for
>> DLS requests to "Not allowed in the BSS". It does not seem the
>> standard has a way for an AP to teardown an existing DLS links though
>> (at no reason code for it), so I guess if we ever support DLS we won't
>> be able to enable this option if a direct links is already
>> established.
> 
> Now that I think about it, why is this even required, why not just
> enforce this all the time and have an option to disable DLS? Are there
> ways to enable direct STA <--> STA communication on a BSS other than
> DLS?
I think allowing/disallowing DLS should be separate from AP isolation.
In some cases, AP isolation might only be used to reduce the amount of
broadcast traffic, and DLS wouldn't be a problem then.

- Felix
