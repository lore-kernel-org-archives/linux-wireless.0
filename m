Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f52.google.com ([209.85.128.52]:42865 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab3BUOUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 09:20:10 -0500
Received: by mail-qe0-f52.google.com with SMTP id 6so4354568qeb.11
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2013 06:20:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9D6CE95B@SC-VEXCH1.marvell.com>
References: <CAMLZHHS_G3N+UcKqPBWr6JPTWADCNOgdXReL8s3q3GPpYebGvQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE59E@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE6CD@SC-VEXCH1.marvell.com>
	<CAMLZHHRmd+Yfr_72HdfNd+knPJg8KvuAA2WrC0TC0wQ8pOeMeA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE95B@SC-VEXCH1.marvell.com>
Date: Thu, 21 Feb 2013 08:20:09 -0600
Message-ID: <CAMLZHHR+OCQd_2J8NkmK0CND9vo6VaT73L+rJKJRk7bUknh7Qw@mail.gmail.com> (sfid-20130221_152018_339385_0CBE157D)
Subject: Re: mwifiex crash when removing interface while scanning
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2013 at 6:00 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Hi Daniel,
>
>> >> >     mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0, cmd_pending=-1
>> >> >     eth0      Failed to read scan data : No such device
>> >
>> > After this error message, do you see the sd8787 card is removed from the bus?
>> >
>> > "mmc0: card 0001 removed"
>>
>> No.
>
> That's strange.
> "mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0, cmd_pending=-1" is from
> mwifiex_remove_card().

I haven't dug into the code, but it seems quite normal to me. It makes
sense for mwifiex_remove_card to be called in the rmmod path. And it
makes sense for the kernel not to report that the card was removed,
since it wasn't actually removed. Only the module was unloaded.

>> Under this kernel, I'm not sure if the power is or isn't being cut at
>> this point. I don't think this is relevant though; regular
>
> "we quite regularly will power down the wireless card when it is not
> being actively used..."
>
> I interpreted this statement as "the power to the card is being cut while inactive".
> mwifiex_remove_card() is called seems agrees with it. Perhaps I'm missing something here.

Yes, we will want to make sure that the power is physically cut. I
just haven't verified what the exact behaviour is under 3.8.
Nevertheless, I think this detail is irrelevant, given that
rmmod/insmod cycles work fine, but the problem only occurs when
scanning is involved.

>> insmod/rmmod cycles work fine, the problem only appears when tearing
>> down the interface while a scan is in progress.
>
> Could you add some debug logs in the tear-down path to show where exactly it gets stuck?

I mis-spoke there, sorry. The problem happens on the next modprobe
*after* a teardown when a scan was in progress. The teardown itself
seems to have completed without getting stuck.

If you have any suggestions for where to add debug messages, that
would be appreciated. Otherwise I will look into sprinkling a few
throughout the probe sequences to see if any communication succeeds
before the first error is printed.

Thanks,
Daniel
