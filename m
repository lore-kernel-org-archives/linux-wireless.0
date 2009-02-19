Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:50024 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbZBSGJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 01:09:08 -0500
Received: by fk-out-0910.google.com with SMTP id f33so204393fkf.5
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 22:09:06 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] at76c50x-usb: fix Oops on disconnect
References: <c4d76b3b0902161739w2fc3bc6fp31fee6ea082702bf@mail.gmail.com>
	<871vtvqxsq.fsf@litku.valot.fi> <1235012962.6344.4.camel@rainbow>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 19 Feb 2009 08:09:04 +0200
In-Reply-To: <1235012962.6344.4.camel@rainbow> (Jason Andryuk's message of "Wed\, 18 Feb 2009 22\:09\:22 -0500")
Message-ID: <87vdr7hsan.fsf@litku.valot.fi> (sfid-20090219_070913_954903_327AAF52)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

>> Unfortunately the patch is corrupted:
>> 
>> patching file drivers/net/wireless/at76c50x-usb.c
>> Hunk #1 FAILED at 1860.
>> Hunk #2 FAILED at 1900.
>> patch: **** malformed patch at line 80: ieee80211_hw *hw,
>> 
>> Can you resend it?
>
> I the problem was line wrapping from gmail's web interface.
>
> ---
>
> flush_workqueue needs to be called instead of the generic one and the
> associated functions need to be modified to prevent re-adding
> themselves to the workqueue.
>
> The rx_tasklet is also killed in the small (?) chance it is scheduled.

Thanks, the patch was now ok. I'll test the patch and if I found no
issues, I'll send this to John. This might take few days, though.

-- 
Kalle Valo
