Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:18342 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZGJTEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 15:04:30 -0400
Received: by wf-out-1314.google.com with SMTP id 26so316820wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2009 12:04:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090710185150.GF2825@tuxdriver.com>
References: <20090707170307.GC2768@tuxdriver.com>
	 <1246989303-19462-1-git-send-email-javier@cozybit.com>
	 <20090710185150.GF2825@tuxdriver.com>
Date: Fri, 10 Jul 2009 12:04:30 -0700
Message-ID: <45e8e6c40907101204g17e66df2vb89243989d297561@mail.gmail.com>
Subject: Re: [PATCH v5] mac80211: Fix regression in mesh forwarding path.
From: Andrey Yurovsky <andrey@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 10, 2009 at 11:51 AM, John W.
Linville<linville@tuxdriver.com> wrote:
> On Tue, Jul 07, 2009 at 10:55:03AM -0700, javier@cozybit.com wrote:
>> From: Javier Cardona <javier@cozybit.com>
>>
>> The removal of the master netdev broke the mesh forwarding path.  This patch
>> fixes it by using the new internal 'pending' queue.
>>
>> As a result of this change, mesh forwarding no longer does the inefficient
>> 802.11 -> 802.3 -> 802.11 conversion that was done before.
>>
>> [Changes since v1]
>> Suggested by Johannes:
>>  - Select queue before adding to mpath queue
>>  - ieee80211_add_pending_skb -> ieee80211_add_pending_skbs
>>  - Remove unnecessary header wme.h
>>
>> Signed-off-by: Javier Cardona <javier@cozybit.com>
>> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
>> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
>
> What tree are you basing this on?

wireless-testing, the latest (re-spun) version applied on top of
commit 5ac0fb5e5044cb578fb352dc65def1a46a2a21aa
