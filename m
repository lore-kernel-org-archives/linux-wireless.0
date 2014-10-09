Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:40073 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaJIIKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 04:10:46 -0400
Received: by mail-ig0-f174.google.com with SMTP id a13so5859740igq.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 01:10:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412840290.1828.1.camel@jlt4.sipsolutions.net>
References: <1410505130-7271-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1410505130-7271-3-git-send-email-henning.rogge@fkie.fraunhofer.de> <1412840290.1828.1.camel@jlt4.sipsolutions.net>
From: Henning Rogge <hrogge@gmail.com>
Date: Thu, 9 Oct 2014 10:10:25 +0200
Message-ID: <CAGnRvurpXRa295P9eQsaR0HnE5o19HDZfwQRcjHk7wEfBYSbbQ@mail.gmail.com> (sfid-20141009_101051_602774_FCB67614)
Subject: Re: [PATCH v4 2/2] mac80211: implement cfg80211_ops to query mesh
 proxy path table
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless @ vger . kernel . org"
	<linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 9, 2014 at 9:38 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-09-12 at 08:58 +0200, Henning Rogge wrote:
> [...]
>
> In general, this looks fine. However,
>
>> @@ -691,6 +719,9 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
>>
>>       spin_unlock(&tbl->hashwlock[hash_idx]);
>>       read_unlock_bh(&pathtbl_resize_lock);
>> +
>> +     mpp_paths_generation++;
>
> This doesn't seem to be concurrency safe?
>
> Neither is the existing mesh_paths_generation++, I think, so maybe it's
> not something we really need to worry about?

Uhh... I must admit I am not completely sure... this is just my third
kernel patch, so I am still learning about all the arcane locking/RCU
systems of the kernel.

I think it should be reasonable safe. The variable is only increased
(never decreased) and is used as a "information version number" for
the dumps via netlink to the userspace. I think the current userspace
tools ignore the variable completely.

Henning Rogge
