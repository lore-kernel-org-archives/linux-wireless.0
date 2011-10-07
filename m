Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58058 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1JGVMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 17:12:06 -0400
Received: by qyk7 with SMTP id 7so4082145qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 14:12:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6V1gUSNc4L8sNv-NnDDVSzDB4A=cc_Z7tmZ79Q4LKtbwQ@mail.gmail.com>
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com> <CAB=NE6V1gUSNc4L8sNv-NnDDVSzDB4A=cc_Z7tmZ79Q4LKtbwQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Fri, 7 Oct 2011 14:11:46 -0700
Message-ID: <CAB=NE6VxNKJPQPBbkn9ha1EC6dWawj96B6f-R1XREN1JAcrOQQ@mail.gmail.com> (sfid-20111007_231211_624937_6DB151AB)
Subject: Re: [PATCH 0/8] wireless: add DFS master support
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 4, 2011 at 5:14 PM, Luis R. Rodriguez
<mcgrof@qca.qualcomm.com> wrote:
> On Tue, Oct 4, 2011 at 4:47 PM, Luis R. Rodriguez
> <mcgrof@qca.qualcomm.com> wrote:
>> This set of 8 patches adds DFS master support to the Linux wireless subsystem.
>> I've reviewed future possible changes to DFS master regions and it seems that
>> we are not going to be having multiple DFS regions for one country, instead
>> we'll always have one DFS region for one country.
>>
>> The changes here are spread out throughout wireless-regdb, crda the kernel and
>> lastly iw. The changes made allow for older verions of CRDA to work with new
>> wireless-regdb files with DFS region support. If you want DFS master region
>> support you'll need to upgrade your CRDA, your kernel and then hope someone
>> implements DFS master support for your respective driver.
>>
>> This patch series does not have specific driver changes, although some seem to
>> be backing in the oven right now.
>
> Here's a puzzle though... If we change this series to use the other
> pad byte that was available, the first pad byte, instead of the last
> one, we loose backward compatibility support and I cannot figure out
> why. What I ended up seeing was that crda sends the message, and for
> some reason (return code is 222 from nl_wait_for_ack(), whatever that
> is) the kernel rejects it. I suspect it may have to do with some sort
> of offset to the *other* data that makes some of the rules output
> invalid data for the attribute policy, but at least when I hexdump the
> wireless-regdb the only changes I see are in the signature and the pad
> shift.
>
> I got tired of trying though and after seeing flipping the pad bytes
> things worked decided to stay with it. In my original RFC in December
> I had used u16 instead, but since the data was in the last pad byte
> things still worked. So something is fishy about only using the first
> pad byte. The change below, as far as I can tell, should not have any
> issues but it does with the older version of CRDA and even a new one.

Johannes spotted the issue, I'll send the fix, thanks to Johannes.
John, Johannes the patches still apply my fix goes on top of these
changes, the fix is not addressing a regression introduced by this
patchset, instead it fixes a long standing issue which would prevent
us from using the next available pad byte.

  Luis
