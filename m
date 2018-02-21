Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:45058 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbeBUTxd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 14:53:33 -0500
Received: by mail-wr0-f181.google.com with SMTP id p104so7803998wrc.12
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2018 11:53:33 -0800 (PST)
Subject: Re: [PATCH 0/3] Export TXQ parameters and statistics via nl80211
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
References: <20180219170224.14816-1-toke@toke.dk>
 <5A8D3445.3040300@broadcom.com> <87bmgiboan.fsf@toke.dk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A8DCE3B.3000607@broadcom.com> (sfid-20180221_205341_859526_CE5172A7)
Date: Wed, 21 Feb 2018 20:53:31 +0100
MIME-Version: 1.0
In-Reply-To: <87bmgiboan.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/21/2018 12:00 PM, Toke Høiland-Jørgensen wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> On 2/19/2018 6:02 PM, Toke Høiland-Jørgensen wrote:
>>> This series adds TXQ parameters and statistics that were previously only
>>> available through debugfs to the nl80211 userspace interface and the
>>> cfg80211 kernel interface. Patches for iw to print the statistics and
>>> change the settings are included.
>>
>> So what is your motivation for having this exposed through nl80211.
>> For the average end-user the stats and parameters are fairly fuzzy.
>
> Two reasons, basically:
>
> 1. Visibility and statistics; this is basically the same information
>     that is available at the qdisc layer (with `tc -s qdisc`), but which
>     has been missing on WiFi interfaces ever sine we switched to the TXQ
>     structure. Having this available has been quite valuable for
>     debugging qdisc setups on wired links, and it's not always feasible
>     to ask users to recompile their kernels with debugfs enabled.
>
> 2. Having visibility into the queues from userspace makes it possible to
>     make decisions based upon (e.g.) which stations are currently
>     backlogged. I'm working on a "policy mode" for the airtime fairness
>     scheduler which will use this capability.

I see. Was just wondering whether there were concrete user-space 
applications planned to use the information. Cool.

>> So can we expect some manual in which is described what parameter
>> should be tweaked based on the retrieved statistics.
>
> Heh, not sure I'll promise a whole manual, but I am happy to write a
> blog post (or wiki page if that's better) explaining what these values
> mean and what insight one might gain from them.

My preference would be to have something on wireless.wiki.kernel.org. 
Another option might be to add kerneldoc section for this.

Regards,
Arend
