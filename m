Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:47870 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZFVWqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 18:46:42 -0400
Received: by ewy6 with SMTP id 6so5104529ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2009 15:46:44 -0700 (PDT)
Message-ID: <4A4009C6.8020208@gmail.com>
Date: Mon, 22 Jun 2009 23:46:30 +0100
From: Dmitri Seletski <drjoms@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	gaurav.jauhar@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [ath9k-devel] Pending ath9k bugs June, 2009
References: <43e72e890906220847u4faaeb2paa15365360c3c080@mail.gmail.com> 	<4A3FDAC2.7020209@gmail.com> <43e72e890906221358m4a32d747ge67a5af2f74841e0@mail.gmail.com>
In-Reply-To: <43e72e890906221358m4a32d747ge67a5af2f74841e0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Mon, Jun 22, 2009 at 12:25 PM, Dmitri Seletski<drjoms@gmail.com> wrote:
>   
>> Luis R. Rodriguez wrote:
>>     
>>> We're down to 2 kernel.org bug reports for ath9k:
>>>
>>> http://bugzilla.kernel.org/show_bug.cgi?id=13581
>>> "ath9k doesn't work with newer kernels"
>>> This is a regression between 2.6.29 and 2.6.30, someone needs to look at this.
>>>
>>> http://bugzilla.kernel.org/show_bug.cgi?id=13141
>>> "AR5008/DWA-552 - Very slow"
>>> Patches have been supplied, needs user feedback.
>>>
>>> If you are aware of any other issues please do report.
>>>
>>>   Luis
>>> _______________________________________________
>>> ath9k-devel mailing list
>>> ath9k-devel@lists.ath9k.org
>>> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>>>
>>>       
>> Hello Luis,
>> Was that problem i was bothering you with being solved?
>>     
>
> Oh no, thanks for the reminder, that is another outstanding issue. Can
> you provide the pcap output.
>
>
>   
>> I have attempted to install fresh drivers, but i get:
>>
>>  make
>> /bin/sh: line 0: test: -ge: unary operator expected
>> /bin/sh: line 0: test: -le: unary operator expected
>>     
>
> Hm, some script may not be using /bin/bash appropriately, but you may
> just want to rm -f /bin/sh && ln -s /bin/bash /bin/sh for now.
>
>   Luis
>   

rm -f /bin/sh && ln -s /bin/bash /bin/sh
make
/bin/sh: line 0: test: -ge: unary operator expected
/bin/sh: line 0: test: -le: unary operator expected
make -C /lib/modules/2.6.30-rc8/build
M=/home/dimko/compat-wireless-2009-06-20 modules
make[1]: Entering directory `/usr/src/linux-2.6.30-rc8'
make[1]: *** No rule to make target `modules'.  Stop.
make[1]: Leaving directory `/usr/src/linux-2.6.30-rc8'
make: *** [modules] Error 2



Make still fails.

About pcap, you probably din't get my last email. I have included log
files of tcpdump...
 I have had no packets going through wireless at all, during n only test.

unfortunately i cant compile anything currently

solution with rm -f /bin/sh && ln -s /bin/bash /bin/sh didnt help

compat-wireless-2009-06-20 # make
/bin/sh: line 0: test: -ge: unary operator expected
/bin/sh: line 0: test: -le: unary operator expected
make -C /lib/modules/2.6.30-rc8/build
M=/home/dimko/compat-wireless-2009-06-20 modules
make[1]: Entering directory `/usr/src/linux-2.6.30-rc8'
make[1]: *** No rule to make target `modules'.  Stop.
make[1]: Leaving directory `/usr/src/linux-2.6.30-rc8'
make: *** [modules] Error 2

If you want i can of course can  resubmit  tcpdump test, but i cant
install no ath9k drivers, as such test is pointless, as i only have
built in drivers left...

Sorry for replying to private email.

just to clarify, by all i mean, i cant compile ath9k drivers.
i could compile kernel for example

Regards
Dmitri

