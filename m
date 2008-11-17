Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:41525 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbYKQPOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 10:14:46 -0500
Received: by rn-out-0910.google.com with SMTP id k40so2007422rnd.17
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 07:14:45 -0800 (PST)
Message-ID: <1ba2fa240811170714j7d0daf5xe718ffa1d4de8f40@mail.gmail.com> (sfid-20081117_161450_423663_CF2C8C88)
Date: Mon, 17 Nov 2008 17:14:44 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1226933141.3902.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226915999.3599.33.camel@johannes.berg>
	 <1ba2fa240811170632s49c38320y18da189bf2432d54@mail.gmail.com>
	 <1226933141.3902.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 17, 2008 at 4:45 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-11-17 at 16:32 +0200, Tomas Winkler wrote:
>
>> IMHO Not the concept but the implementation of this function is wrong.
>
> I disagree.
>
>> It should be no implementation difference between mac notification and
>> reception of one RX frames that triggers oneof the connection step
>> such as association response. If this would be handled in this context
>> and there won't be any locking issue.
>> If driver crashes internally and lost association info it can generate
>> "local disassociation frame" and mac will try to reapply association
>> in a regular flow.
>
> The point is that the whole thing about disassociation is already the
> wrong assumption. As I've outlined, it only works in STA mode, and thus
> the function is generally not very useful.
>
>> I agree that resume/suspend shell be handled properly in the mac80211
>> regardless of this issue.
>
> And it will handle the "firmware crashed" case perfectly too.

You may have a case, anyhow, please show us some RFC before you remove
of mac notify.
Tomas
