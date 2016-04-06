Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:34446 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbcDFIUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 04:20:25 -0400
Received: by mail-qg0-f43.google.com with SMTP id c6so30322141qga.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 01:20:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459850188.18188.38.camel@sipsolutions.net>
References: <CAFSVvRfjZszSfovXZ0piPqOgVKH=10sG7pvnvkoWJChL38ifqQ@mail.gmail.com>
	<1459850188.18188.38.camel@sipsolutions.net>
Date: Wed, 6 Apr 2016 11:20:24 +0300
Message-ID: <CAFSVvRcMQx1Vjv=Qwyb525Qq5DzBBD6c=n=-i+pWFFVqHRyAxQ@mail.gmail.com> (sfid-20160406_102032_138187_9B4788B0)
Subject: Re: NETLINK_URELEASE non-bound socket problem (was: [PATCH] Fix local
 DoS in cfg80211 subsystem)
From: Dmitrijs Ivanovs <dmitrijs.ivanovs@ubnt.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	samuel <samuel@sortiz.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Thomas Graf <tgraf@suug.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes!

I will prepare patch which does not send NETLINK_URELEASE for unbound
sockets as you suggest. But I think protocol check in nl80211 is still
needed because port_id is unique per-protocol.

On Tue, Apr 5, 2016 at 12:56 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi Dmitrijs,
>
> Thanks for reporting this problem.
>
>> The patch below corrects this problem in kernel space.
>
> I don't think that this is correct, there are four more users of
> NETLINK_URELEASE (nfnetlink, NFC), and afaict all of them have the same
> bug as nl80211.
>
> Rather than fix all of them, I think we should simply not report
> NETLINK_URELEASE for netlink sockets that weren't bound; if any user
> comes up that requires them later we could add a new event instead.
>
> I can't find what commit introduced this code, it goes back before git
> history, so I don't have the commit log. Maybe it was done for
> nfnetlink log/queue? Certainly both nl80211 and NFC are much newer.
>
>> Also, it is
>> recommended to ensure that user-space applications are not using
>> user-supplied port_id for netlink sockets (which is default in
>> libnl-tiny for example).
>
> This I think we should remove from the commit log - it's misleading and
> there's no point.
>
> johannes
>
