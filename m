Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:33756 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbcBDM3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 07:29:19 -0500
Received: by mail-yk0-f181.google.com with SMTP id z13so40342507ykd.0
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 04:29:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1454588396.2564.7.camel@sipsolutions.net>
References: <CABPxzY+HpP=NTrAaUEzV5nFm=LK93m=kxPV14-cdftt+VPsWNw@mail.gmail.com>
 <CA+BoTQ=s_SMgs9zkgYjKOHKDwRORWk-Re7XZ=AiKiHCuNc0L8A@mail.gmail.com> <1454588396.2564.7.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 4 Feb 2016 17:58:59 +0530
Message-ID: <CABPxzYL3mGHyoKE0tkL4yg_4NL+U41+15Bm3f=JPq2vfD+Xnkg@mail.gmail.com> (sfid-20160204_132922_297487_C3C65F2E)
Subject: Re: mac80211_hwsim + iperf + netns
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 4, 2016 at 5:49 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2016-02-04 at 12:32 +0100, Michal Kazior wrote:
>>
>>  ip netns add ns1
>>  ip netns exec ns1 bash # get the PID in the session and don't close
>> it
>>  iw phy phyX set netns $pid_of_that_shell
>>
>
> If you also have a recent enough iw version, you can use
>
> iw phy phyX set netns name ns1
>
My iw has this option, but it throws an error.
Does this command have any prerequisites?

# iw phy phy1 set netns name ns1
Invalid parameter: nsname(name)
Usage:  iw [options] phy <phyname> set netns { <pid> | name <nsname> }

Put this wireless device into a different network namespace:
    <pid>    - change network namespace by process id
    <nsname> - change network namespace by name from /var/run/netns
               or by absolute path (man ip-netns)


Options:
        --debug         enable netlink debugging
#
