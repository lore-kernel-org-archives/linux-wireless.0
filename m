Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:62408 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbYIOTZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 15:25:19 -0400
Received: by gxk9 with SMTP id 9so25908291gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 12:25:17 -0700 (PDT)
Message-ID: <43e72e890809151225u34673bf4ub9b2e3d7f00c756b@mail.gmail.com> (sfid-20080915_212522_007359_F4718B8C)
Date: Mon, 15 Sep 2008 12:25:17 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] Redesigning aggregation on mac80211
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221506142.3700.75.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890809151203p213fae37ia3bd6871c3bfe2c2@mail.gmail.com>
	 <1221506142.3700.75.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2008 at 12:15 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-09-15 at 12:03 -0700, Luis R. Rodriguez wrote:
>
>> I'll start with Atheros hardware and mac80211. Atheros hardware uses 4
>> main HW queues, one for each AC, and we also have one for beacons,
>> another for queued stuff after beacon (aka "Crap After Beacon") where
>> things like queued frames for broadcast / multicast or for frames for
>> stations in power save mode, and I think another hw queue for uapsd.
>> Right now mac80211 queues skb's for drivers into the netdev_queues.
>> Under the current mac80211 design we have 4 netdev_queues, one for
>> each AC and then there is a number of "aggregation queues". We
>> essentially just declare one "aggregation" queue as we do our own
>> queue mapping internally to our own hardware queues -- and that
>> consist of just mapping frames to each HQ queue as per AC.
>
> Except that declaring one "aggregation queue" also limits you to a
> single aggregation session, no big deal in STA mode but punishable by
> death in AP mode.

Or IBSS/Mesh although I think only IBSS speaks aggregation as per the
specs so far.

  Luis
