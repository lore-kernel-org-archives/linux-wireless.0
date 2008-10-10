Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:43272 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbYJJOgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 10:36:52 -0400
Received: by fk-out-0910.google.com with SMTP id 18so464153fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 07:36:50 -0700 (PDT)
Message-ID: <1ba2fa240810100736r34d652f7i37eb8dfe92a2196a@mail.gmail.com> (sfid-20081010_163656_998915_097D8933)
Date: Fri, 10 Oct 2008 16:36:50 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi: bug in iwl_tx_skb
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223645251.3748.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223543081.22490.2.camel@johannes.berg>
	 <1ba2fa240810100520h7d51624fr468aad2c6def62e2@mail.gmail.com>
	 <1223645251.3748.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 3:27 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-10-10 at 14:20 +0200, Tomas Winkler wrote:
>> On Thu, Oct 9, 2008 at 11:04 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > When iwl_txq_update_write_ptr fails, you have a huge problem: the skb is
>> > linked on the queue, the write_ptr has been incremented, but you pretend
>> > you can just free it.
>>
>> It's not freed it's should be picket in the next round. We should
>> really return success to mac80211 in case
>
> No, it _is_ freed, by the caller, because you always return success to
> mac80211 anyway and kfree the skb before. And if you didn't return
> success it'd be just as wrong.

Yes I know,  as I said we should return success there.
Tomas
