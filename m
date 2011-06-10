Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63739 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab1FJNAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 09:00:05 -0400
Received: by gxk21 with SMTP id 21so1739221gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 06:00:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110610090009.GA2503@redhat.com>
References: <1307691952-10980-1-git-send-email-eliad@wizery.com>
	<20110610090009.GA2503@redhat.com>
Date: Fri, 10 Jun 2011 16:00:03 +0300
Message-ID: <BANLkTimoXRSAJAPQ1q7tthQUYAqgDSg23w@mail.gmail.com> (sfid-20110610_150009_844623_B397ABDC)
Subject: Re: [PATCH] mac80211: add cancel_hw_scan() callback
From: Eliad Peller <eliad@wizery.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 10, 2011 at 12:00 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Fri, Jun 10, 2011 at 10:45:52AM +0300, Eliad Peller wrote:
>> When suspending, __ieee80211_suspend() calls ieee80211_scan_cancel(),
>> which will only cancel sw scan. In order to cancel hw scan, the
>> low-level driver has to cancel it in the suspend() callback. however,
>> this is too late, as a new scan_work will be enqueued (while the driver
>> is going into suspend).
>>
>> Add a new cancel_hw_scan() callback, asking the driver to cancel an
>> active hw scan, and call it in ieee80211_scan_cancel().
>
> Looks reasonable, but could you also update a comments?
>
>> +     /*
>> +      * The scan is canceled, but stop work from being pending.
>
> Also this one is not valid and should be removed.
>
sure.
i'll update the comments.
thanks for the review.

Eliad.
