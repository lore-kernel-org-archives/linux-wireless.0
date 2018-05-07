Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:40160 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751764AbeEGEkq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 00:40:46 -0400
Received: by mail-lf0-f42.google.com with SMTP id p85-v6so3178781lfg.7
        for <linux-wireless@vger.kernel.org>; Sun, 06 May 2018 21:40:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADjYELzJU-Y-rVqTX76ve6z7P_u09kkFZy8qXZSfCf1Prjsewg@mail.gmail.com>
References: <CAG5S3ZTRe52qSWt6WEe6K78brrQqc7+HgN_8OQ+RKC9k1WUMCw@mail.gmail.com>
 <CADjYELxyuT74Ms30Ohu_a6Ymg6RLctf6mehRmw-poLgLMZWiwQ@mail.gmail.com>
 <1504531173.27801.0.camel@sipsolutions.net> <CADjYELzJU-Y-rVqTX76ve6z7P_u09kkFZy8qXZSfCf1Prjsewg@mail.gmail.com>
From: Greg Maitz <ghh19622@gmail.com>
Date: Mon, 7 May 2018 14:40:44 +1000
Message-ID: <CAG5S3ZTkFyvTg8-Ley-YCWWxHivLjrafA5NxzMVFjxg__s_J5w@mail.gmail.com> (sfid-20180507_064049_912066_EB47047C)
Subject: Re: Incorrect mesh path seq num
To: Thomas Pedersen <thomas@eero.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, I confirmed it to be due to mismatched structures of
ieee80211_rann_ie between the two versions. Issue resolved.

On Sat, Sep 9, 2017 at 5:58 AM, Thomas Pedersen <thomas@eero.com> wrote:
> On Mon, Sep 4, 2017 at 6:19 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Fri, 2017-09-01 at 13:07 -0700, Thomas Pedersen wrote:
>>> On Thu, Aug 31, 2017 at 11:30 PM, Greg Maitz <ghh19622@gmail.com>
>>> wrote:
>>> > Hi guys,
>>> >
>>> > I'm seeing a problem when I work on the wireless mesh between two
>>> > linux devices. The root node has 3.18 kernel while the next hop
>>> > station runs 2.6.37 kernel. I found the mpath->sn value is
>>> > incorrect
>>> > most of the time on the device having 2.6.37 kernel. After
>>> > examining
>>> > the code, in function hwmp_route_info_get [mesh_hwmp.c], after
>>> > mesh_path_lookup, the sequence number (i.e, mpath->sn) is
>>> > incorrect.
>>> > For instance, I see mpath->sn having value 0x30950000. It should be
>>> > 0x9530, while the orig_sn is having value 0x9531.
>>>
>>> Looks like an endianess bug. Are you testing on two platforms of
>>> different endianess?
>>
>> Even if that's the case, wouldn't it mean some kind of conversion is
>> missing somewhere?
>
> Yes. I looked for a missing conversion, but couldn't find it.
>
> Greg, where / how are you printing mpath->sn? mpath dump or a printk you added?
>
> --
> thomas
