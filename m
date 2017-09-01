Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:35317 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752400AbdIAUHm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 16:07:42 -0400
Received: by mail-qt0-f173.google.com with SMTP id x36so5569625qtx.2
        for <linux-wireless@vger.kernel.org>; Fri, 01 Sep 2017 13:07:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG5S3ZTRe52qSWt6WEe6K78brrQqc7+HgN_8OQ+RKC9k1WUMCw@mail.gmail.com>
References: <CAG5S3ZTRe52qSWt6WEe6K78brrQqc7+HgN_8OQ+RKC9k1WUMCw@mail.gmail.com>
From: Thomas Pedersen <thomas@eero.com>
Date: Fri, 1 Sep 2017 13:07:41 -0700
Message-ID: <CADjYELxyuT74Ms30Ohu_a6Ymg6RLctf6mehRmw-poLgLMZWiwQ@mail.gmail.com> (sfid-20170901_220755_362447_35ACB724)
Subject: Re: Incorrect mesh path seq num
To: Greg Maitz <ghh19622@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 31, 2017 at 11:30 PM, Greg Maitz <ghh19622@gmail.com> wrote:
> Hi guys,
>
> I'm seeing a problem when I work on the wireless mesh between two
> linux devices. The root node has 3.18 kernel while the next hop
> station runs 2.6.37 kernel. I found the mpath->sn value is incorrect
> most of the time on the device having 2.6.37 kernel. After examining
> the code, in function hwmp_route_info_get [mesh_hwmp.c], after
> mesh_path_lookup, the sequence number (i.e, mpath->sn) is incorrect.
> For instance, I see mpath->sn having value 0x30950000. It should be
> 0x9530, while the orig_sn is having value 0x9531.

Looks like an endianess bug. Are you testing on two platforms of
different endianess?

> This results in the
> last hop metric to become zero in function mesh_rx_path_sel_frame and
> hwmp_preq_frame_process doesn't get called. Is this a known problem?
> Can anyone provide suggestions to debug further?



-- 
thomas
