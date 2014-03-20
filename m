Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:43756 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaCTHMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 03:12:54 -0400
Received: by mail-ob0-f180.google.com with SMTP id wn1so446606obc.25
        for <linux-wireless@vger.kernel.org>; Thu, 20 Mar 2014 00:12:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395238008.4142.15.camel@jlt4.sipsolutions.net>
References: <1394021648-22605-1-git-send-email-michal.kazior@tieto.com>
	<1395238008.4142.15.camel@jlt4.sipsolutions.net>
Date: Thu, 20 Mar 2014 08:12:53 +0100
Message-ID: <CA+BoTQnZGEYXT8nEvvr6iuX+r7aHU1mt6X58yWHja=W3jq+EGw@mail.gmail.com> (sfid-20140320_081257_818075_D49E2EF8)
Subject: Re: [PATCH] mac80211: protect AP VLAN list with local->mtx
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 March 2014 15:06, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-03-05 at 13:14 +0100, Michal Kazior wrote:
>> It was impossible to change chanctx of master AP
>> for AP VLANs because the copy function requires
>> RTNL which can't be simply taken in mac80211 code
>> due to possible deadlocks.
>>
>> This is required for future chanctx reservation
>> that re-bind vifs to new chanctx. This requires
>> safe AP VLAN iteration without RTNL.
>>
>> Now VLANs can be iterated while holding either
>> RTNL or local->mtx because the list is modified
>> while holding both of these locks.
>
> No objection really, but maybe it would make more sense to use
> iflist_mtx?

I used local->mtx because it seemed easier at the time (the lock is
already used on all related codepaths).

Using local->iflist_mtx would add another mutex to for
csa/reservation. I think it shouldn't be hard to do it though. Should
I re-spin? (this will probably need a re-spin of Luca's reservation
patchset and my RFC).


Michał
