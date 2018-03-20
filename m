Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35862 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751481AbeCTS35 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 14:29:57 -0400
Subject: Re: [RFC] ethtool: Support ETHTOOL_GSTATS2 command.
To: Michal Kubecek <mkubecek@suse.cz>
References: <1520452289-14172-1-git-send-email-greearb@candelatech.com>
 <20180320103747.7kcfdu4yzof6bwxw@unicorn.suse.cz>
 <37830d46-762b-2a92-4506-5792a65d2ebd@candelatech.com>
 <20180320182420.u5aa7eny3fbix7fj@unicorn.suse.cz>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        netdev@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <da10fdf8-80a7-9a8a-e56d-92319152fd5e@candelatech.com> (sfid-20180320_193000_747269_192E256D)
Date: Tue, 20 Mar 2018 11:29:54 -0700
MIME-Version: 1.0
In-Reply-To: <20180320182420.u5aa7eny3fbix7fj@unicorn.suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2018 11:24 AM, Michal Kubecek wrote:
> On Tue, Mar 20, 2018 at 08:39:33AM -0700, Ben Greear wrote:
>> On 03/20/2018 03:37 AM, Michal Kubecek wrote:
>>>
>>> IMHO it would be more practical to set "0 means same as GSTATS" as a
>>> rule and make ethtool_get_stats() a wrapper for ethtool_get_stats2() to
>>> avoid code duplication (or perhaps a use fall-through in the switch). It
>>> would also allow drivers to provide only one of the callbacks.
>>
>> Yes, but that would require changing all drivers at once, and would make backporting
>> and out-of-tree drivers harder to manage.  I had low hopes that this feature would
>> make it upstream, so I didn't want to propose any large changes up front.
>
> I don't think so. What I mean is:
>
> (a) driver implements ->get_ethtool_stats2() callback; then we use it
>     for GSTATS2
> (b) driver does not implement get_ethtool_stats2() but implements
>     ->get_ethtool_stats(); then we call for GSTATS2 if level is zero,
>     otherwise GSTATS2 returns -EINVAL
>
> and GSTATS is always translated to GSTATS2 with level 0, either by
> defining ethtool_get_stats() as a wrapper or by fall-through in the
> switch statement.
>
> This way, most drivers could be left untouched and only those which
> would implement non-default levels would provide ->get_ethtool_stats2()
> callback instead of ->get_ethtool_stats().

OK, that makes sense.  I'll wait on feedback from the flags or #defined levels
and re-spin the patch accordingly.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
