Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50637 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab0D0Bxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 21:53:30 -0400
Received: by pvg2 with SMTP id 2so857020pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 18:53:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BD640F5.8010206@openwrt.org>
References: <1272324216-73349-1-git-send-email-nbd@openwrt.org>
	<20100426232332.GA2079@tuxdriver.com> <4BD621FA.1000405@openwrt.org>
	<20100427001233.GB2079@tuxdriver.com> <t2i43e72e891004261725kdd3c1388jc2758db8a0b7e82@mail.gmail.com>
	<k2y43e72e891004261834w1eb604d0q83f9cd80820e3d8@mail.gmail.com>
	<4BD640F5.8010206@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Apr 2010 18:53:10 -0700
Message-ID: <x2i43e72e891004261853p751a5d5bt9cbb99846b2eb1fb@mail.gmail.com>
Subject: Re: [PATCH 1/2] cfg80211: add ap isolation support
To: Felix Fietkau <nbd@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 26, 2010 at 6:42 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-04-27 3:34 AM, Luis R. Rodriguez wrote:
>> On Mon, Apr 26, 2010 at 5:25 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> On Mon, Apr 26, 2010 at 5:12 PM, John W. Linville
>>> <linville@tuxdriver.com> wrote:
>>>> On Tue, Apr 27, 2010 at 01:30:02AM +0200, Felix Fietkau wrote:
>>>>> On 2010-04-27 1:23 AM, John W. Linville wrote:
>>>>> > On Tue, Apr 27, 2010 at 01:23:35AM +0200, Felix Fietkau wrote:
>>>>> >> This is used to configure APs to not bridge traffic between connected stations.
>>>>> >>
>>>>> >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>>>> >
>>>>> > Is this useful?
>>>>> Yes, if you have an AP with lots of users that aren't expected to
>>>>> communicate with each other (e.g. only for internet access), it can save
>>>>> a lot of airtime by not forwarding every broadcast message emitted from
>>>>> any station.
>>>>> I'm sure there are a more situations where this can be useful.
>>>>
>>>> Ah, OK -- I suppose that makes sense.
>>>
>>> In fact technically IEEE-802.11 2007 section 11.7 states "STAs are not
>>> allowed to transmit frames directly to other STAs in a BSS and should
>>> always rely
>>> on the AP for the delivery of the frames", with the exception being
>>> using DLS direct links for QoS STAs.  This would prevent the STAs from
>>> going into PS mode for as long duration of the stream.
>>>
>>> If the AP does not support this it would just set the result code for
>>> DLS requests to "Not allowed in the BSS". It does not seem the
>>> standard has a way for an AP to teardown an existing DLS links though
>>> (at no reason code for it), so I guess if we ever support DLS we won't
>>> be able to enable this option if a direct links is already
>>> established.
>>
>> Now that I think about it, why is this even required, why not just
>> enforce this all the time and have an option to disable DLS? Are there
>> ways to enable direct STA <--> STA communication on a BSS other than
>> DLS?
> I think allowing/disallowing DLS should be separate from AP isolation.
> In some cases, AP isolation might only be used to reduce the amount of
> broadcast traffic, and DLS wouldn't be a problem then.

So the other way for an AP to forward traffic from STAs on the BSS to
others is to transmit broadcast frames and the purpose of this patch
is to disable that? If so can the description of the command be a
little more descriptive about this? Perhaps annotating that other
communication would not be done unless DLS links are created ?

  Luis
