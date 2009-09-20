Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:64877 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbZITPsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2009 11:48:40 -0400
Received: by pxi34 with SMTP id 34so1795861pxi.16
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2009 08:48:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253459430.11702.62.camel@localhost.localdomain>
References: <C6BB22C4F02E0E4AB5B55BD3B1FEDBCD056C4ABD@schickmail.schicknt.com>
	 <1253459430.11702.62.camel@localhost.localdomain>
Date: Sun, 20 Sep 2009 08:48:43 -0700
Message-ID: <45e8e6c40909200848x4209c51dwf96d6fdba21e3222@mail.gmail.com>
Subject: Re: Continuous monitoring of wifi stats
From: Andrey Yurovsky <andrey@cozybit.com>
To: Dan Williams <dcbw@redhat.com>
Cc: John Goyette <jgoyette@schicktech.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 20, 2009 at 8:10 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Wed, 2009-09-16 at 13:24 -0400, John Goyette wrote:
>> Hello all,
>>
>>
>>
>> I am looking for some advice on a Libertas related issue.  I am having a problem with a recent feature we added to our embedded system that continuously monitors wifi statistics, i.e., signal strength.  We are using a Blackfin platform with a Marvell 8686 device in the G-SPI configuration.  Our kernel is based on a 2.6.28.6 release.
>
> Any chance you can grab the driver from 2.6.31 and rebuild it for your
> kernel?  There are a few fixes from earlier this summer for GSPI and
> Power Saving mode from Andrey Yurovsky that may fix your issue.  I'm
> thinking specifically of b3781c74373489fa325ce64efdf72f6c8567b783 and a
> few of the other PS cleanups from July.

I believe that John has the bug fixes in question -- John, can you
summarize your setup (which compat-wireless snapshot, etc)?

>> The problem occurs after pressing Ctrl-C to terminate a user space program that is polling the wireless stats in a loop.  A number of libertas error messages appear indicating a failure to download command 0x0000.  I am pretty sure there is no command 0x0000, so I do not know how it got queued.  Here is a sample of the error messages from dmesg:
>>
>>
>>
>> libertas: command 0x0000 timed out
>> libertas: requeueing command 0x0000 due to timeout (#1)
>> libertas: if_spi_host_to_card: invalid size requested: 0
>> libertas: DNLD_CMD: hw_host_to_card failed: -22
>> libertas: command 0x0000 timed out
>> libertas: requeueing command 0x0000 due to timeout (0000002 <http://schicksw/mantis/view.php?id=2> )
>> libertas: if_spi_host_to_card: invalid size requested: 0
>> libertas: DNLD_CMD: hw_host_to_card failed: -22
>> libertas: command 0x0000 timed out
>> libertas: requeueing command 0x0000 due to timeout (0000003 <http://schicksw/mantis/view.php?id=3> )
>> libertas: if_spi_host_to_card: invalid size requested: 0
>> libertas: DNLD_CMD: hw_host_to_card failed: -22
>> libertas: command 0x0000 timed out
>> libertas: Excessive timeouts submitting command 0x0000
>>
>>
>>
>>
>>
>> This can be reproduced by enabling IEEE Power Savings mode and flooding the card with wireless stats requests by running something like the following from a terminal:
>>
>> while true; do iwconfig eth1;done
>>
>>
>>
>> Let this run for 30-60 secs, and then press Ctrl-C.  With IEEE power savings off, it may take several minutes, but does eventually give the same problem.  I have downloaded the compat-wireless-2.6.30 release and was able to cross-compile it for our kernel.  It helped a little in that it seemed to take longer before the error messaged occurred after pressing ctrl-c, but it did not completely resolve the problem.
>>
>>
>>
>> Has anyone seen something similar?  Are there any more recent patches that may address this issue?
>>
>>
>>
>> Thanks.
>>
>>
>>
>> -John Goyette
>>
>> Schick Technologies, Inc.
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
