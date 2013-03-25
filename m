Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog017.obsmtp.com ([74.125.150.74]:51381 "EHLO
	na6sys009bog017.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933102Ab3CYVtm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 17:49:42 -0400
From: John Rhodes <jrhodes@marvell.com>
To: Daniel Drake <dsd@laptop.org>, Bing Zhao <bzhao@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Mon, 25 Mar 2013 14:27:05 -0700
Subject: RE: mwifiex crash when removing interface while scanning
Message-ID: <77956EDC1B917843AC9B7965A3BD78B0639784C502@SC-VEXCH2.marvell.com> (sfid-20130325_224949_201081_E8FEF740)
References: <CAMLZHHS_G3N+UcKqPBWr6JPTWADCNOgdXReL8s3q3GPpYebGvQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE59E@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE6CD@SC-VEXCH1.marvell.com>
	<CAMLZHHRmd+Yfr_72HdfNd+knPJg8KvuAA2WrC0TC0wQ8pOeMeA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE95B@SC-VEXCH1.marvell.com>
	<CAMLZHHR+OCQd_2J8NkmK0CND9vo6VaT73L+rJKJRk7bUknh7Qw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CEC9D@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9D9C1608@SC-VEXCH1.marvell.com>
	<CAMLZHHQyTDHD8q=Q-edSew+KnpaGWOaVwxiK_fjABG9ZC9g-Qg@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D9C2199@SC-VEXCH1.marvell.com>
	<CAMLZHHQYB8wYEq1gppNEMiV0BPfM3qKtujR4=4u1jVww-N6z5w@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD3AE4@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD430D@SC-VEXCH1.marvell.com>
 <CAMLZHHRmyftv4sz+jmozJoAjvRTP-4DF-59C6N22R7tccCJ5WQ@mail.gmail.com>
In-Reply-To: <CAMLZHHRmyftv4sz+jmozJoAjvRTP-4DF-59C6N22R7tccCJ5WQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

We are now also seeing cmd_pending warnings in testing at Marvell in Santa Clara.  Bing is working on a revised patch for this issue.  We'll keep you posted on the progress.  I'll also update the tracking system ticket #479039.

John

-----Original Message-----
From: dsdrake@gmail.com [mailto:dsdrake@gmail.com] On Behalf Of Daniel Drake
Sent: Monday, March 25, 2013 12:39 PM
To: Bing Zhao
Cc: linux-wireless@vger.kernel.org; John Rhodes; Amitkumar Karwar
Subject: Re: mwifiex crash when removing interface while scanning

Hi,

On Tue, Mar 19, 2013 at 12:19 AM, Bing Zhao <bzhao@marvell.com> wrote:
> Hi Daniel,
>
>> > That seems to avoid the issue. I'm worried that it suggests some 
>> > more significant lower-level bug, but I guess for now it would make 
>> > sense to finish off those 2 patches you already posted, and 
>> > investigate the possible cmd_pending leak, before revisiting this.
>>
>> Thanks for testing. I will fine tune the 2 patches and resend the updated version to the list.
>> The cmd_pending leak will be investigated too.
>
> Please try attached patch on top of the 3 patches I sent last Friday.

Thanks for continuing to look at this.

Unfortuntaely the cmd_pending warning is still there and the numbers are now -4 and -5 e.g.
[  128.269912] mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0,
cmd_pending=-5

This is using the same test script used in the opening message on this thread, with uap0 and p2p0 auto-creation disabled, with or without NetworkManager running at the same time.

Thanks
Daniel
