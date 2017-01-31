Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:35356 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751749AbdAaTr4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 14:47:56 -0500
Received: by mail-ot0-f169.google.com with SMTP id 65so273937595otq.2
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2017 11:46:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <88d1163c1c0ffea8a395f4929b29a7b3@codeaurora.org>
References: <1485561708-31559-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1485561708-31559-3-git-send-email-rmanohar@qca.qualcomm.com>
 <CADjYELxr+OuJxpFUm+OocCaMRmTM1=GZEw1keYOAOCN2T3o4sg@mail.gmail.com> <88d1163c1c0ffea8a395f4929b29a7b3@codeaurora.org>
From: Thomas Pedersen <thomas@eero.com>
Date: Tue, 31 Jan 2017 11:46:47 -0800
Message-ID: <CADjYELxQw17B5Oa8rwh5bNs-M4SgkCwKKxFAT2m=5UD44A+e8Q@mail.gmail.com> (sfid-20170131_204759_585989_40DCF2C4)
Subject: Re: [PATCH 3/3] mac80211: clear failure average upon mesh path deactivation
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2017 at 11:33 AM, Rajkumar Manoharan
<rmanohar@codeaurora.org> wrote:
> On 2017-01-31 09:51, Thomas Pedersen wrote:
>>
>> Hi Rajkumar,
>>
>> Thanks this looks good, but..
>>
>> On Fri, Jan 27, 2017 at 4:01 PM, Rajkumar Manoharan
>> <rmanohar@qca.qualcomm.com> wrote:
>>>
>>> Mesh moving average should be cleared, whenever mesh paths
>>> to the given station are deactivated due to bad link. This will
>>> give enough room to analysis more tx status than retaining the
>>> current average.
>>>
> [...]
>>>
>>>         ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_ATOMIC);
>>>         if (ret)
>>> @@ -535,8 +536,11 @@ void mesh_plink_broken(struct sta_info *sta)
>>>                                 sdata->u.mesh.mshcfg.element_ttl,
>>>                                 mpath->dst, mpath->sn,
>>>                                 WLAN_REASON_MESH_PATH_DEST_UNREACHABLE,
>>> bcast);
>>> +                       paths_deactivated = true;
>>>                 }
>>>         }
>>> +       if (paths_deactivated)
>>> +               sta->mesh->fail_avg = 0;
>>
>>
>> .. why this indirection? Just reset mesh->fail_avg unconditionally in
>> this function?
>>
> Hmm... As fixed paths are not affected, resetting fail_avg for fixed path
> may give
> wrong metric. no?

I don't think setting fail_avg = 0 will affect existing fixed mpath
code. Anyway metrics should not
affect whether a fixed mpath is chosen.

-- 
thomas
