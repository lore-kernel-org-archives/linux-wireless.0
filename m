Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36754 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab1JGWce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 18:32:34 -0400
Received: by qadb15 with SMTP id b15so3086639qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 15:32:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6U6hFMBhgkjhpjpQk+FpMbDi4X6aW6i70MUWRH73K+AuQ@mail.gmail.com>
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
 <CAB=NE6V1gUSNc4L8sNv-NnDDVSzDB4A=cc_Z7tmZ79Q4LKtbwQ@mail.gmail.com>
 <CAB=NE6VxNKJPQPBbkn9ha1EC6dWawj96B6f-R1XREN1JAcrOQQ@mail.gmail.com> <CAB=NE6U6hFMBhgkjhpjpQk+FpMbDi4X6aW6i70MUWRH73K+AuQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Fri, 7 Oct 2011 15:32:14 -0700
Message-ID: <CAB=NE6Xz26oOudnyw17_1ijqe+L8qwQAGH8qjZEocgHQOY54eg@mail.gmail.com> (sfid-20111008_003238_288471_2201C698)
Subject: Re: [PATCH 0/8] wireless: add DFS master support
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 7, 2011 at 3:29 PM, Luis R. Rodriguez
<mcgrof@qca.qualcomm.com> wrote:
> On Fri, Oct 7, 2011 at 2:11 PM, Luis R. Rodriguez
> <mcgrof@qca.qualcomm.com> wrote:
>> On Tue, Oct 4, 2011 at 5:14 PM, Luis R. Rodriguez
>> <mcgrof@qca.qualcomm.com> wrote:
>>> On Tue, Oct 4, 2011 at 4:47 PM, Luis R. Rodriguez
>>> <mcgrof@qca.qualcomm.com> wrote:
>>>> This set of 8 patches adds DFS master support to the Linux wireless subsystem.
>>>> I've reviewed future possible changes to DFS master regions and it seems that
>>>> we are not going to be having multiple DFS regions for one country, instead
>>>> we'll always have one DFS region for one country.
>>>>
>>>> The changes here are spread out throughout wireless-regdb, crda the kernel and
>>>> lastly iw. The changes made allow for older verions of CRDA to work with new
>>>> wireless-regdb files with DFS region support. If you want DFS master region
>>>> support you'll need to upgrade your CRDA, your kernel and then hope someone
>>>> implements DFS master support for your respective driver.
>>>>
>>>> This patch series does not have specific driver changes, although some seem to
>>>> be backing in the oven right now.
>>>
>>> Here's a puzzle though... If we change this series to use the other
>>> pad byte that was available, the first pad byte, instead of the last
>>> one, we loose backward compatibility support and I cannot figure out
>>> why. What I ended up seeing was that crda sends the message, and for
>>> some reason (return code is 222 from nl_wait_for_ack(), whatever that
>>> is) the kernel rejects it. I suspect it may have to do with some sort
>>> of offset to the *other* data that makes some of the rules output
>>> invalid data for the attribute policy, but at least when I hexdump the
>>> wireless-regdb the only changes I see are in the signature and the pad
>>> shift.
>>>
>>> I got tired of trying though and after seeing flipping the pad bytes
>>> things worked decided to stay with it. In my original RFC in December
>>> I had used u16 instead, but since the data was in the last pad byte
>>> things still worked. So something is fishy about only using the first
>>> pad byte. The change below, as far as I can tell, should not have any
>>> issues but it does with the older version of CRDA and even a new one.
>>
>> Johannes spotted the issue, I'll send the fix, thanks to Johannes.
>> John, Johannes the patches still apply my fix goes on top of these
>> changes, the fix is not addressing a regression introduced by this
>> patchset, instead it fixes a long standing issue which would prevent
>> us from using the next available pad byte.
>
> I'm going to respin this to make use of 2 bits:
>
> 00 unset
> 01 FCC
> 10 ETSI
> 11 JP
>
> We may need some more DFS values later but

Sorry I did not finish this e-mail I meant that we may later have a
requirement for more DFS values but at this time we don't, we should
consider whether or not we will want to leave more bits for usage of
more DFS values and if so how many? Using two bits will give us
support for what we know today but nothing for the future.

If I use two bits I just don't want complains later if we have DFS
regions split in the db spec for future changes.

  Luis
