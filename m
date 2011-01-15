Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38946 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab1AOBUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 20:20:00 -0500
Received: by iwn9 with SMTP id 9so3075916iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 17:20:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295052936.2253.5.camel@mythtv.ewol.com>
References: <1295026029-21130-1-git-send-email-greearb@candelatech.com>
	<AANLkTi=WTUiy1DYNhE12_KZp8QFUrWebY2Cpzud5P0b3@mail.gmail.com>
	<1295052936.2253.5.camel@mythtv.ewol.com>
Date: Sat, 15 Jan 2011 02:20:00 +0100
Message-ID: <AANLkTi=_qAB6aVEbsTBUfpVwTg4GbLsAYbyP0PA2n+NO@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC 1/2] ath9k: Fix up hardware mode and beacons
 with multiple vifs.
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: sbrown@cortland.com
Cc: greearb@candelatech.com, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/15 Steve Brown <sbrown@cortland.com>:
> On Sat, 2011-01-15 at 00:19 +0100, Björn Smedman wrote:
>> This is another comment that is a little out of place but when I see
>> the identifier beacon_interval in this context I cannot help bringing
>> up per-vif settings as a related problem: If I read the code (or
>> rather the lack of code) correctly the beacon interval of the last (or
>> first?) beaconing vif added will be used to set up beacon tx, whereas
>> the actual beacon contents will reflect the beacon intervals
>> configured for individual vifs which may all be different... The same
>> goes for e.g. tx queue configuration, no?
[snip]
> For instance, an ap vif has a ~100ms interval and a mesh vif has a
> ~1000ms interval. I don't see how to avoid a per vif interval.

I agree. We should fix ath9k so it works correctly even if beacon
interval is different for different vifs (within some reasonable
limits).

In the mean time, as a workaround, try to configure the same beacon
interval for all vifs.

/Björn
