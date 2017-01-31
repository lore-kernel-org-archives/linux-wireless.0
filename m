Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56034 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751580AbdAaTdz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 14:33:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 31 Jan 2017 11:33:49 -0800
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Thomas Pedersen <thomas@eero.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] mac80211: clear failure average upon mesh path
 deactivation
In-Reply-To: <CADjYELxr+OuJxpFUm+OocCaMRmTM1=GZEw1keYOAOCN2T3o4sg@mail.gmail.com>
References: <1485561708-31559-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1485561708-31559-3-git-send-email-rmanohar@qca.qualcomm.com>
 <CADjYELxr+OuJxpFUm+OocCaMRmTM1=GZEw1keYOAOCN2T3o4sg@mail.gmail.com>
Message-ID: <88d1163c1c0ffea8a395f4929b29a7b3@codeaurora.org> (sfid-20170131_203359_591969_FC7F99F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-31 09:51, Thomas Pedersen wrote:
> Hi Rajkumar,
> 
> Thanks this looks good, but..
> 
> On Fri, Jan 27, 2017 at 4:01 PM, Rajkumar Manoharan
> <rmanohar@qca.qualcomm.com> wrote:
>> Mesh moving average should be cleared, whenever mesh paths
>> to the given station are deactivated due to bad link. This will
>> give enough room to analysis more tx status than retaining the
>> current average.
>> 
[...]
>>         ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_ATOMIC);
>>         if (ret)
>> @@ -535,8 +536,11 @@ void mesh_plink_broken(struct sta_info *sta)
>>                                 sdata->u.mesh.mshcfg.element_ttl,
>>                                 mpath->dst, mpath->sn,
>>                                 
>> WLAN_REASON_MESH_PATH_DEST_UNREACHABLE, bcast);
>> +                       paths_deactivated = true;
>>                 }
>>         }
>> +       if (paths_deactivated)
>> +               sta->mesh->fail_avg = 0;
> 
> .. why this indirection? Just reset mesh->fail_avg unconditionally in
> this function?
> 
Hmm... As fixed paths are not affected, resetting fail_avg for fixed 
path may give
wrong metric. no?

-Rajkumar
