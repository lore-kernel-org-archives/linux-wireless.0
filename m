Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:40621 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751920AbeCTQMD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 12:12:03 -0400
MIME-Version: 1.0
In-Reply-To: <37830d46-762b-2a92-4506-5792a65d2ebd@candelatech.com>
References: <1520452289-14172-1-git-send-email-greearb@candelatech.com>
 <20180320103747.7kcfdu4yzof6bwxw@unicorn.suse.cz> <37830d46-762b-2a92-4506-5792a65d2ebd@candelatech.com>
From: Steve deRosier <derosier@gmail.com>
Date: Tue, 20 Mar 2018 09:11:21 -0700
Message-ID: <CALLGbRKU_PCk-3ZMBRu6CC-QyaEEPTAOavGVzPpQUdEMQ+s9BQ@mail.gmail.com> (sfid-20180320_171225_323212_10BEFBC8)
Subject: Re: [RFC] ethtool: Support ETHTOOL_GSTATS2 command.
To: Ben Greear <greearb@candelatech.com>
Cc: Michal Kubecek <mkubecek@suse.cz>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 20, 2018 at 8:39 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 03/20/2018 03:37 AM, Michal Kubecek wrote:
>>
>> On Wed, Mar 07, 2018 at 11:51:29AM -0800, greearb@candelatech.com wrote:
>>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> This is similar to ETHTOOL_GSTATS, but it allows you to specify
>>> a 'level'.  This level can be used by the driver to decrease the
>>> amount of stats refreshed.  In particular, this helps with ath10k
>>> since getting the firmware stats can be slow.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>> ---
>>>
>>> NOTE:  I know to make it upstream I would need to split the patch and
>>> remove the #define for 'backporting' that I added.  But, is the
>>> feature in general wanted?  If so, I'll do the patch split and
>>> other tweaks that might be suggested.
>>
>>
>
> Yes, but that would require changing all drivers at once, and would make
> backporting
> and out-of-tree drivers harder to manage.  I had low hopes that this feature
> would
> make it upstream, so I didn't want to propose any large changes up front.
>

Hi Ben,

I find the feature OK, but I'm not thrilled with the arbitrary scale
of "level". Maybe there could be some named values, either on a
spectrum as level already is, similar to the kernel log DEBUG, WARN,
INFO....  type levels. Or named bit flags like the way the ath drivers
do their debug flags for granular results.  Thoughts?

- Steve
