Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60972 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1DAMMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 08:12:10 -0400
Received: by wya21 with SMTP id 21so2877825wya.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 05:12:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301658705.3832.21.camel@jlt3.sipsolutions.net>
References: <1301658324-11530-1-git-send-email-vnatarajan@atheros.com>
	<1301658705.3832.21.camel@jlt3.sipsolutions.net>
Date: Fri, 1 Apr 2011 17:42:08 +0530
Message-ID: <AANLkTimRgE+Lors_LNFnWH2cVarswfoKYP582+Xwuf_X@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mac80211: Check for queued frames before entering
 power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 1, 2011 at 5:21 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-04-01 at 17:15 +0530, Vivek Natarajan wrote:
>> In a highly noisy environment, since the driver could not send
>> the packets out in 100ms, some applications stall and eventually
>> fail as mac80211 stops the netdevice queues for flush when power
>> save is triggered. Most of the WMM testcases fail in the Wifi
>> testing because of this.
>> Increasing the dynamic ps timeout to 200-300ms helps but in noisy
>> channel conditions even if there is a continuous tx traffic, mac80211
>> tries to go into PS. The new implementation checks for any frames
>> queued in the driver tx queues and based on that mac80211 decides
>> to go for power save. This also prevents redundant stopping of
>> netdevice queues which helps more applications to run properly.
>
> I think as an API change this needs more justification. Why does this
> need a new callback, for example?

Ideally the driver should enter power save only when there is no tx
frame. When there are about 10 APs in the environment the tx rate of
the driver drops and the application slows down since it has not yet
received ACKs for the frames already queued in the hardware. Since
this ACK may take more than 100ms, stopping the dev queues for
entering PS at this stage breaks applications, WMM test case in my
testing. If there are tx_frames already pending in the queue,
postponing the PS logic helps to avoid redundant queue stops. Since, I
could not find any other way in mac80211 to see if the driver has not
completed the transmission of any frame, a new API to check for
pending frames is used. When power save is enabled by default and in a
noisy environment, this API certainly helps in improving the average
throughput. Any other idea?

Vivek.
