Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:37254 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423161AbcBQNt4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 08:49:56 -0500
Received: by mail-ig0-f177.google.com with SMTP id 5so15512657igt.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2016 05:49:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgVxB6rRxkz=eR30rbZsfH3irZXy0q3hu43AJC04YEfd7A@mail.gmail.com>
References: <20160215190451.19883.12408.stgit@localhost.localdomain>
	<CAFqt6zb6Qb46n=U=3owVrU+OfSL=qC_w0eQeSmJ91BfRBQkiSw@mail.gmail.com>
	<CAGRGNgVxB6rRxkz=eR30rbZsfH3irZXy0q3hu43AJC04YEfd7A@mail.gmail.com>
Date: Wed, 17 Feb 2016 19:19:55 +0530
Message-ID: <CAFqt6zYnvcoeiV5rF9kpY2u5K8cj+SCxjcHBFPikhEe+VpP97A@mail.gmail.com> (sfid-20160217_145008_226914_AE0A1DCB)
Subject: Re: [PATCH] rt2x00: unterminated strlen of user data
From: Souptick Joarder <jrdr.linux@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Alan <gnomes@lxorguk.ukuu.org.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

On Wed, Feb 17, 2016 at 5:38 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Souptick,
>
> On Tue, Feb 16, 2016 at 5:36 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
>> On Tue, Feb 16, 2016 at 12:34 AM, Alan <gnomes@lxorguk.ukuu.org.uk> wrote:
>>> The buffer needs to be zero terminated in case the user data is not.
>>> Otherwise we run off the end of the buffer.
>>>
>>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>>> ---
>>>  drivers/net/wireless/ralink/rt2x00/rt2x00debug.c |    5 +++--
>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
>>> index 25ee3cb..72ae530 100644
>>> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
>>> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
>>> @@ -478,7 +478,7 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,        \
>>>  {                                                              \
>>>         struct rt2x00debug_intf *intf = file->private_data;     \
>>>         const struct rt2x00debug *debug = intf->debug;          \
>>> -       char line[16];                                          \
>>> +       char line[17];                                          \
>>>         size_t size;                                            \
>>>         unsigned int index = intf->offset_##__name;             \
>>>         __type value;                                           \
>>> @@ -494,7 +494,8 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,        \
>>>                                                                 \
>>>         if (copy_from_user(line, buf, length))                  \
>>>                 return -EFAULT;                                 \
>>> -                                                               \
>>> +       line[16] = 0;
>>
>>             line[length] = '\0';
>>             correct me if I am wrong.                          \
>
> I believe that in this case the data in buf will already be null
> terminated, so ensuring that line is null terminated is only needed if
> there are exactly 16 bytes in buf. IMHO
>
> line[16] = 0;

I think, if there are 16 bytes in buf, we end up loosing 1 byte data.
If there are 15 bytes in buf, buf is already be null terminated.
So is this really required?
Correct me if I am wrong.
>
> is dealing with this bug much more explicitly than
>
> line[length] = 0;
>
> however either will work. (BTW '\0' is identical to 0.)
>
> Thanks,
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/

-Souptick
