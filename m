Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60561 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab1DGLr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 07:47:59 -0400
Received: by wya21 with SMTP id 21so2134974wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 04:47:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1302172435.3779.2.camel@jlt3.sipsolutions.net>
References: <1301658324-11530-1-git-send-email-vnatarajan@atheros.com>
	<1301658705.3832.21.camel@jlt3.sipsolutions.net>
	<AANLkTimRgE+Lors_LNFnWH2cVarswfoKYP582+Xwuf_X@mail.gmail.com>
	<1302172435.3779.2.camel@jlt3.sipsolutions.net>
Date: Thu, 7 Apr 2011 17:17:14 +0530
Message-ID: <BANLkTimNaaUyJ2jKG1gZ3WeWPA9E25y3pw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mac80211: Check for queued frames before entering
 power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 7, 2011 at 4:03 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-04-01 at 17:42 +0530, Vivek Natarajan wrote:
>
>> Ideally the driver should enter power save only when there is no tx
>> frame. When there are about 10 APs in the environment the tx rate of
>> the driver drops and the application slows down since it has not yet
>> received ACKs for the frames already queued in the hardware. Since
>> this ACK may take more than 100ms, stopping the dev queues for
>> entering PS at this stage breaks applications, WMM test case in my
>> testing. If there are tx_frames already pending in the queue,
>> postponing the PS logic helps to avoid redundant queue stops. Since, I
>> could not find any other way in mac80211 to see if the driver has not
>> completed the transmission of any frame, a new API to check for
>> pending frames is used. When power save is enabled by default and in a
>> noisy environment, this API certainly helps in improving the average
>> throughput. Any other idea?
>
> I'm not sure I understand. Where does the 100ms come from? This code
> flushes the TX queues, which can take as much time as it wants, no? How
> does it break applications?

100ms is the time after which the dynamic ps timer stops the netif
queues and flushes all the frames in the driver. Actually two factors
caused the application to timeout:
 One is the delay in the flush() for which the netif queues are
stopped and eventually the application could not send out the frames.
The second is the dropping of frames in the flush() callback when it
reaches the timeout period.

> I'll agree that entering powersave is pointless if that means you won't
> be able to transmit all frames. It seems to me that maybe instead we
> should give flush() a timeout, and if it can't complete in that time, we
> can postpone the powersave then?

This seems better as it addresses both the issues I listed above. The
flush() timeout should not be high enough for the application to
timeout and also flush() should not drop any frame. Maybe it can
return a status if the pending frames are not completed in that
timeout so that PS can be deferred. I will check this out.

Thanks,
Vivek.
