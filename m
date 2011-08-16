Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39609 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab1HPRYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 13:24:23 -0400
Message-ID: <4E4AA7D6.8060208@sipsolutions.net> (sfid-20110816_192426_652251_7A891649)
Date: Tue, 16 Aug 2011 10:24:38 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Guy Eilam <guy@wizery.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: refactor sta_info_insert_rcu to 3 main
 stages
References: <1311715772-8855-1-git-send-email-guy@wizery.com> <1312892417.4109.32.camel@jlt3.sipsolutions.net> <CAA0384753T9EJf_0-kvD7LPzrg1FC_aAKT2ZS8YwUvPtQ8HYxw@mail.gmail.com> (sfid-20110816_191203_119602_5985D45A)
In-Reply-To: <CAA0384753T9EJf_0-kvD7LPzrg1FC_aAKT2ZS8YwUvPtQ8HYxw@mail.gmail.com> (sfid-20110816_191203_119602_5985D45A)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/16/2011 10:11 AM, Guy Eilam wrote:

> I'll make sure that the _ibss and _non_ibss code paths will have
> similar freeing (the freeinng in both cases will be handled outside
> the function like it is in the _non_ibss now).
> The reason I have the might_sleep/locking outside the _non_ibss
> function is because the additions in the next patch. The whole point
> of this refactoring from my point of view was the option to have a
> similar insert function that won't have the locking inside of it.

Ok, fair enough, so it's not possible to move the locking :)

johannes
