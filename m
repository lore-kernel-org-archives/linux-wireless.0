Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:49779 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3KFQkT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 11:40:19 -0500
Received: by mail-la0-f47.google.com with SMTP id er20so3498379lab.20
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 08:40:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1383733032.14307.21.camel@jlt4.sipsolutions.net>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
 <1383671897-7746-4-git-send-email-mcgrof@do-not-panic.com> <1383733032.14307.21.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 6 Nov 2013 08:39:58 -0800
Message-ID: <CAB=NE6Xy6G5xLxU81jzE+3bmJ1Q-ym7qQst3XzK1umQvKxsSrg@mail.gmail.com> (sfid-20131106_174026_370706_77B75B08)
Subject: Re: [PATCH 03/19] cfg80211: check regulatory request alpha2 early
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 6, 2013 at 2:17 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2013-11-05 at 09:18 -0800, Luis R. Rodriguez wrote:
>> Currently nl80211 allows userspace to send the kernel
>> a bogus regulatory domain with at most 32 rules set
>> and it won't reject it until after its allocated
>> memory. Let's be smart about it and take advantage
>> that the last_request is now available under RCU
>                                                ^^^
>
> I think you mean RTNL?

I meant through RCU but yes it should also say under RTNL, the routine
already does have NL80211_FLAG_NEED_RTNL, as an internal flag set, so
this should be OK. Care to amend the commit log or want me to do it?

  Luis
