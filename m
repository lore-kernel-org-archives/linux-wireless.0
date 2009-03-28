Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:49275 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbZC1DAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 23:00:36 -0400
Received: by wf-out-1314.google.com with SMTP id 29so1643616wff.4
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 20:00:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090328024023.GE5543@bombadil.infradead.org>
References: <20090323162834.154525349@sipsolutions.net> <20090323163053.073748867@sipsolutions.net>
	<20090328024023.GE5543@bombadil.infradead.org>
Date: Fri, 27 Mar 2009 20:00:19 -0700
Message-ID: <43e72e890903272000p2c00f80au92441f8df31bcb24@mail.gmail.com> (sfid-20090328_040040_124902_575B9372)
Subject: Re: [PATCH 6/8] mac80211: add skb length sanity checking
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 27, 2009 at 7:40 PM, Luis R. Rodriguez
<mcgrof@bombadil.infradead.org> wrote:
> On Mon, Mar 23, 2009 at 05:28:40PM +0100, Johannes Berg wrote:
>> We just found a bug in zd1211rw where it would reject
>> packets in the ->tx() method but leave them modified,
>> which would cause retransmit attempts with completely
>> bogus skbs, eventually leading to a panic due to not
>> having enough headroom in those.
>>
>> This patch adds a sanity check to mac80211 to catch
>> such driver mistakes; in this case we warn and drop
>> the skb.
>>
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>
> Heh well this is obviously even a stable candidate and it got
> merged already :D.

Nevermind, I was looking at .30, heh. So if zd1211rw also manged the
skb len in older kernels it seems this is stable candidate. Too lazy
to check right now though.

  Luis
