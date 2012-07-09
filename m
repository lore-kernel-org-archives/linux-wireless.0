Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52491 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2GITKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 15:10:40 -0400
Received: by weyx8 with SMTP id x8so1470744wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 12:10:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120709115423.GE2438@redhat.com>
References: <1341834509-11601-1-git-send-email-sgruszka@redhat.com>
	<1341834647.4455.32.camel@jlt3.sipsolutions.net>
	<20120709115423.GE2438@redhat.com>
Date: Mon, 9 Jul 2012 22:10:38 +0300
Message-ID: <CANUX_P23xv5rXynEJHm=boR_g_7YqR1ROOQki6KGv+9LR9KEkg@mail.gmail.com> (sfid-20120709_211043_837404_FDB8761E)
Subject: Re: [RHEL6 PATCH] iwlwifi: remove spurious warning
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> > BZ#837754
>> >
>> > Description:
>> > Some devices do not set SEQ_RX_FRAME flags for few commands that should
>> > not be reclaimed. It was supposed to be fixed in firmware, but it was
>> > not.
>> >
>> > Upstream change also add possibility to configure which commands should
>> > not be reclaimed, but that option is not used - only original 6 commands
>> > are configured. So I did not backport that part, because it make things
>> > somewhat (not necessarily) complex.
>>
>> Yeah, looks fine. I'd hoped it was fixed for iwlwifi drivers (we
>> couldn't remember if it was 4965 only or not) but it turns out it wasn't
>> so this is needed.
>>
>> I don't know if there's anything I should do about this though?
>
> Sorry Johannes that was not intended to go to you and to the public.
>
> Stanislaw
> --

I would be glad to know on what commands this WARN_ON triggers
though... The command name should be printed along with the WARN_ON.
Also it is not really a bug in fw, it is more like a convention that
we (Linux driver developers) don't really like because it creates a
dependency between 2 layers in the driver, but this is another story.
