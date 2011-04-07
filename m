Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60779 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab1DGMEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 08:04:34 -0400
Received: by wya21 with SMTP id 21so2147098wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 05:04:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1302177081.3779.11.camel@jlt3.sipsolutions.net>
References: <1301658324-11530-1-git-send-email-vnatarajan@atheros.com>
	<1301658705.3832.21.camel@jlt3.sipsolutions.net>
	<AANLkTimRgE+Lors_LNFnWH2cVarswfoKYP582+Xwuf_X@mail.gmail.com>
	<1302172435.3779.2.camel@jlt3.sipsolutions.net>
	<BANLkTimNaaUyJ2jKG1gZ3WeWPA9E25y3pw@mail.gmail.com>
	<1302177081.3779.11.camel@jlt3.sipsolutions.net>
Date: Thu, 7 Apr 2011 17:34:33 +0530
Message-ID: <BANLkTimcofYdm8r+YnapmUK7nvtntQPBEA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mac80211: Check for queued frames before entering
 power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 7, 2011 at 5:21 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-04-07 at 17:17 +0530, Vivek Natarajan wrote:
>
>> > I'm not sure I understand. Where does the 100ms come from? This code
>> > flushes the TX queues, which can take as much time as it wants, no? How
>> > does it break applications?
>>
>> 100ms is the time after which the dynamic ps timer stops the netif
>> queues and flushes all the frames in the driver. Actually two factors
>> caused the application to timeout:
>>  One is the delay in the flush() for which the netif queues are
>> stopped and eventually the application could not send out the frames.
>> The second is the dropping of frames in the flush() callback when it
>> reaches the timeout period.
>
> Is that an ath9k specific thing? mac80211 never invokes flush() with
> drop=true, at this point. I thought we needed it and added it, but I
> guess we don't really need it.

Currently, ath9k gives a timeout of 200 ms for the pending frames to
complete. After this timeout, the pending frames will be dropped even
if drop is set as false in mac80211.

Vivek.
