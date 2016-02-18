Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33262 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424048AbcBRDnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 22:43:40 -0500
Received: by mail-io0-f177.google.com with SMTP id z135so60593395iof.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2016 19:43:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgVgz7pmDym-c2k6kcmKjLfORcsBJ+eomddp8q3zEfPHSQ@mail.gmail.com>
References: <20160215190451.19883.12408.stgit@localhost.localdomain>
	<CAFqt6zb6Qb46n=U=3owVrU+OfSL=qC_w0eQeSmJ91BfRBQkiSw@mail.gmail.com>
	<CAGRGNgVxB6rRxkz=eR30rbZsfH3irZXy0q3hu43AJC04YEfd7A@mail.gmail.com>
	<CAFqt6zYnvcoeiV5rF9kpY2u5K8cj+SCxjcHBFPikhEe+VpP97A@mail.gmail.com>
	<CAGRGNgVgz7pmDym-c2k6kcmKjLfORcsBJ+eomddp8q3zEfPHSQ@mail.gmail.com>
Date: Thu, 18 Feb 2016 09:13:39 +0530
Message-ID: <CAFqt6zasaAoZB0nS3mLNmzzJN8duJ=w1pgiVQ9Ut3e4yU79kQw@mail.gmail.com> (sfid-20160218_044344_834162_A0BC6163)
Subject: Re: [PATCH] rt2x00: unterminated strlen of user data
From: Souptick Joarder <jrdr.linux@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Alan <gnomes@lxorguk.ukuu.org.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 18, 2016 at 5:49 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Souptick,
>
> On Thu, Feb 18, 2016 at 12:49 AM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
>> Hi Julian,
>>
>> On Wed, Feb 17, 2016 at 5:38 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
>>> Hi Souptick,
>>>
>>> On Tue, Feb 16, 2016 at 5:36 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
>>>> On Tue, Feb 16, 2016 at 12:34 AM, Alan <gnomes@lxorguk.ukuu.org.uk> wrote:
>>>>> The buffer needs to be zero terminated in case the user data is not.
>>>>> Otherwise we run off the end of the buffer.
>>>>>
>>>>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>>>>> ---
>>>>>  drivers/net/wireless/ralink/rt2x00/rt2x00debug.c |    5 +++--
>>>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
>>>>> index 25ee3cb..72ae530 100644
>>>>> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
>>>>> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
>>>>> @@ -478,7 +478,7 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,        \
>>>>>  {                                                              \
>>>>>         struct rt2x00debug_intf *intf = file->private_data;     \
>>>>>         const struct rt2x00debug *debug = intf->debug;          \
>>>>> -       char line[16];                                          \
>>>>> +       char line[17];                                          \
>>>>>         size_t size;                                            \
>>>>>         unsigned int index = intf->offset_##__name;             \
>>>>>         __type value;                                           \
>>>>> @@ -494,7 +494,8 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,        \
>>>>>                                                                 \
>>>>>         if (copy_from_user(line, buf, length))                  \
>>>>>                 return -EFAULT;                                 \
>>>>> -                                                               \
>>>>> +       line[16] = 0;
>>>>
>>>>             line[length] = '\0';
>>>>             correct me if I am wrong.                          \
>>>
>>> I believe that in this case the data in buf will already be null
>>> terminated, so ensuring that line is null terminated is only needed if
>>> there are exactly 16 bytes in buf. IMHO
>>>
>>> line[16] = 0;
>>
>> I think, if there are 16 bytes in buf, we end up loosing 1 byte data.
>> If there are 15 bytes in buf, buf is already be null terminated.
>> So is this really required?
>> Correct me if I am wrong.
>
> Counting in C starts at 0.
>
> We started out with line being a 16 character string, so it initially
> looked like this:
>
> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 <- index
> _ _ _ _ _ _ _ _ _ _ __ __ __ __ __ __ <- data, i.e. line[index]
>
> If we are given a 4 byte null terminated string, we end up with:
>
> 0 1 2 3  4 5 6 7 8 9 10 11 12 13 14 15
> a b c d \0 _ _ _ _ _ __ __ __ __ __ __
>
> If we are given a 15 byte null terminated string, we end up with:
>
> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
> a b c d e f g h i j  k  l  m  n  o \0
>
> If we are given a 16 byte null terminated string, we end up with:
>
> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
> a b c d e f g h i j  k  l  m  n  o  p
>
> Note that it is not null terminated. The call to strlen() will now run
> off into memory that doesn't belong to line and potentially cause a
> crash. This is a bug.
>
> Alan fixed this by adding another character to the string, so it's now
> 17 characters long and line[16] will always be set to 0 after
> copy_from_user() is called. So now line initially looks like:
>
> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
> _ _ _ _ _ _ _ _ _ _ __ __ __ __ __ __ __
>
> If we are given a 4 byte null terminated string, we end up with:
>
> 0 1 2 3  4 5 6 7 8 9 10 11 12 13 14 15 16
> a b c d \0 _ _ _ _ _ __ __ __ __ __ __ \0
>
> If we are given a 15 byte null terminated string, we end up with:
>
> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
> a b c d e f g h i j  k  l  m  n  o \0 \0
>
> If we are given a 16 byte null terminated string, we end up with:
>
> 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
> a b c d e f g h i j  k  l  m  n  o  p \0
>
> Note that the final null terminator is set by the line[16] = 0; line,
> not copy_from_user().
>
> As line is now null terminated, strlen() will behave correctly and
> there is no bug.
>
> There are a few different ways to fix this bug. All of them will
> involve increasing the size of line to 17, and the exact details of
> how we ensure the null terminator is set can vary. Alan has chosen
> what is likely to be the smallest option in compiled code size, the
> fastest, and one of the most obvious options.
>
> Understanding how arrays and strings work in C is essential knowledge
> if you're going to submit or review patches for the Linux kernel.
> Could you please refresh your knowledge on those topics before
> submitting or reviewing any more patches?
    Sorry, error from my side. :(
    Thanks for clarification.

> Thanks,
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
