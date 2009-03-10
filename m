Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:35245 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZCJInR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 04:43:17 -0400
Received: by wf-out-1314.google.com with SMTP id 28so2476681wfa.4
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 01:43:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236669384.9658.32.camel@johannes.local>
References: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com>
	 <1236669384.9658.32.camel@johannes.local>
Date: Tue, 10 Mar 2009 01:43:15 -0700
Message-ID: <43e72e890903100143y41a19c5fw2d4e055f36268059@mail.gmail.com> (sfid-20090310_094321_485664_903C4ED7)
Subject: Re: [PATCH 0/4] wireless: use channel bandwidth
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2009 at 12:16 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-03-09 at 22:04 -0400, Luis R. Rodriguez wrote:
>> Few patches which actually make use of the channel bandwidth, lets
>> also send this to userspace as it useful to tell which channels you'll
>> be able to use HT40 or not on as a client.
>
> Can you remind me why we have that max_bandwidth at all? It seems we
> would be able to see whether ht40 fits by checking the above/below
> sideband channel for use permission.

To allow you to create bands for your regulatory domain and give easy
access to the allowed bandwidth. A good example is the world
regulatory domain right now with no HT40 for channels 12, 13 and 14.
cfg80211 does the checks for us only once upon regulatory domain
changes and that work gives us easy access to the allowed possible
channel width. The alternative is to call something like
freq_reg_info() on this call path and do the check in the places we
need.

Originally we had the NO-HT20 and NO-HT40 flags but as it turns out
HT20 is now allowed everywhere and we determine we can just use the
channel bandwidth to figure out whether or not you can use HT40.

  Luis
