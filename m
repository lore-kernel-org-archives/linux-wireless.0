Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38878 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932855Ab1ISWXB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 18:23:01 -0400
Message-ID: <4E77C0BF.50108@openwrt.org> (sfid-20110920_002313_572570_3DC6A91A)
Date: Tue, 20 Sep 2011 00:22:55 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH v2 2/4] ath9k_hw: clean up tx power handling
References: <1316453903-75710-1-git-send-email-nbd@openwrt.org> <1316453903-75710-2-git-send-email-nbd@openwrt.org> <CAB=NE6XvanRQ6Yje_qHhkfzbLmZn9o5Q+5y1NobJwCyuMLFEvg@mail.gmail.com> <4E77AAFB.1080805@openwrt.org> <CAB=NE6XgSz7zz_ZXaPQEsaue307ipd7Qnzgi5QWr8Y4SS1j=Lg@mail.gmail.com> <4E77B25D.9070907@openwrt.org> <CAB=NE6XLdftXKg5-wvme8Vg7BjGi-TpxQ3G6m=7VnEw89YzXoA@mail.gmail.com> <CAB=NE6XQDqG+En2KWOyKGUVT1SWm1rwMwOxMjpE8CjYfvwvOqw@mail.gmail.com> <4E77BC58.7040204@openwrt.org> <CAB=NE6Vi2sun6vJy=yZSJ9HjHxD17FO-GmXtYybcjLVPSt9+wA@mail.gmail.com> <CAB=NE6UzRhp=51QacoRzMPad0vO1qkNxK3=rayPuYXdjA3ZOJQ@mail.gmail.com>
In-Reply-To: <CAB=NE6UzRhp=51QacoRzMPad0vO1qkNxK3=rayPuYXdjA3ZOJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-20 12:13 AM, Luis R. Rodriguez wrote:
> On Mon, Sep 19, 2011 at 3:12 PM, Luis R. Rodriguez
> <mcgrof@qca.qualcomm.com>  wrote:
>>  On Mon, Sep 19, 2011 at 3:04 PM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>>  On 2011-09-19 11:54 PM, Luis R. Rodriguez wrote:
>>>>
>>>>  On Mon, Sep 19, 2011 at 2:45 PM, Luis R. Rodriguez
>>>>  <mcgrof@qca.qualcomm.com>    wrote:
>>>>>
>>>>>    On Mon, Sep 19, 2011 at 2:21 PM, Felix Fietkau<nbd@openwrt.org>    wrote:
>>>>>>
>>>>>>    I looked at the other ath driver and I see no indication that it's
>>>>>>  related
>>>>>>    to DFS in any way.
>>>>>
>>>>>    I have verified this just now as well, it seems it was only used to
>>>>>    support an ioctl to userspace to enable users to update a tpscale
>>>>>    value but I see no documentation about this. Next question is who in
>>>>>    usersapce sets this. I wonder if its done through userspace after
>>>>>    measuring some TPC reports from STAs.
>>>>
>>>>  So this comes from supporting a "TR-098" specification, which seems to
>>>>  be the "Internet Gateway Device data model for the CPE WAN Management
>>>>  Protocol". I haven't yet been able to map this to the specification
>>>>  respective component:
>>>>
>>>>  http://www.broadband-forum.org/technical/download/TR-098.pdf
>>>
>>>  Interesting. That definitely supports my point that ath9k is the wrong place
>>>  for something like this to be. Let's just get rid of it.
>>
>>  Yeah, I'm now convinced :) die code. But please do add some blurb
>>  about this tumor the code had.
>
> In fact removing the tumor through a separate patch would be appreciated.
I don't think it needs a separate patch. It's dead code directly related 
to the other things that I'm changing, and it does not add any 
functional changes. I'll add a comment, though.

- Felix
