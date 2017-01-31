Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38992 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751608AbdAaTy2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 14:54:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 31 Jan 2017 11:53:40 -0800
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Thomas Pedersen <thomas@eero.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] mac80211: clear failure average upon mesh path
 deactivation
In-Reply-To: <CADjYELxQw17B5Oa8rwh5bNs-M4SgkCwKKxFAT2m=5UD44A+e8Q@mail.gmail.com>
References: <1485561708-31559-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1485561708-31559-3-git-send-email-rmanohar@qca.qualcomm.com>
 <CADjYELxr+OuJxpFUm+OocCaMRmTM1=GZEw1keYOAOCN2T3o4sg@mail.gmail.com>
 <88d1163c1c0ffea8a395f4929b29a7b3@codeaurora.org>
 <CADjYELxQw17B5Oa8rwh5bNs-M4SgkCwKKxFAT2m=5UD44A+e8Q@mail.gmail.com>
Message-ID: <ad799cb0f89a70c0dd096af89363e8ca@codeaurora.org> (sfid-20170131_205441_898377_53C5F30B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-31 11:46, Thomas Pedersen wrote:
> On Tue, Jan 31, 2017 at 11:33 AM, Rajkumar Manoharan wrote:
>> On 2017-01-31 09:51, Thomas Pedersen wrote:
>>> 
[...]
>>>> +       if (paths_deactivated)
>>>> +               sta->mesh->fail_avg = 0;
>>> 
>>> 
>>> .. why this indirection? Just reset mesh->fail_avg unconditionally in
>>> this function?
>>> 
>> Hmm... As fixed paths are not affected, resetting fail_avg for fixed 
>> path
>> may give
>> wrong metric. no?
> 
> I don't think setting fail_avg = 0 will affect existing fixed mpath
> code. Anyway metrics should not
> affect whether a fixed mpath is chosen.
> 
Great. Will remove conditional check. Thanks for your feedback Thomas.

-Rajkumar
