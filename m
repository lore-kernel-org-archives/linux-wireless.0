Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43559 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1BDKru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 05:47:50 -0500
Received: by wwi17 with SMTP id 17so183464wwi.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 02:47:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19787.54182.293274.705139@gargle.gargle.HOWL>
References: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
	<19787.47298.50879.401166@gargle.gargle.HOWL>
	<AANLkTim_7Xup048eGxz2HWj0AqRS_+jvC1LqgCdU9ZOh@mail.gmail.com>
	<19787.54182.293274.705139@gargle.gargle.HOWL>
Date: Fri, 4 Feb 2011 16:17:49 +0530
Message-ID: <AANLkTimfONC20SyM=OA9Fykkt91ZsU19XEBiC7uDnVY8@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath9k: Drain txq before sending a nullfunc frame.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 4, 2011 at 3:53 PM, Sujith <m.sujith@gmail.com> wrote:
> Vivek Natarajan wrote:
>> So, will it be appropriate to add stop and wake queue while calling
>> ath_drain_all_txq?
>
> Am not sure. I happened to look at that comment and thought it a bit
> odd that the caller is expected to call wake_queues().
>
>> Currently, flush() is called only when mac80211 is moving to off
>> channel. Even if we call flush before sending nullfunc frame for power
>> save, a question arises if it should be done with drop = true or
>> false.  If set as false, there is a possibility that the frames might
>> be still around in the hw when nullfunc is sent and the same issue
>> might pop up.
>
> "Still around in the hw" ?
>
> ath_drain_all_txq() will stop HW DMA first and then remove all the
> pending frames in all HW queues and add them to the free buffer list.
>

This is true for retry_tx set as false(for ath_draintxq) but if the
retry is set, I suppose the frame will be in the hw queue till all the
hw retries(20) and sw retries(10) (200 retries in total)are over. This
will take a lot of time for completion if the channel is busy.

> When flush() is called, the driver would empty its HW queues and then
> mac80211 would proceed to send the nullfunc frame. Isn't this the fix
> that you require ?

I am thinking of calling ath_drain_all_txq() in flush() and the only
query is should the retry_tx be set.

>> We were considering yet another approach too:
>> In this case, if a nullfunc frame for PS comes to the driver when
>> there are pending frames in the hw queue(the frames queued before
>> 100ms and still pending because of highly noisy environment), silently
>> drop the frame so that mac80211 will try once again after 100ms to go
>> to PS. The issue that I face here is, ath9k does not know whether this
>> frame is actually for PS or for fake sleep before scanning.
>
> Well, silently dropping frames is generally frowned upon. :)

return -ENOMEM is what I meant though mac80211 does not check the
return status here.

Vivek.
