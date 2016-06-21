Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34589 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbcFUMJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 08:09:33 -0400
Received: by mail-io0-f169.google.com with SMTP id g13so7463848ioj.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2016 05:08:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1466502087.3170.17.camel@sipsolutions.net>
References: <1464770416-17514-1-git-send-email-maxin.john@gmail.com>
 <1465460710.3442.4.camel@sipsolutions.net> <CAMhs6Yw-ScHvfjsxKGG-teXAYtebsrOEmRzt9-VBepoeNkpjWg@mail.gmail.com>
 <1466502087.3170.17.camel@sipsolutions.net>
From: "Maxin B. John" <maxin.john@gmail.com>
Date: Tue, 21 Jun 2016 15:08:24 +0300
Message-ID: <CAMhs6YxNhRLoSZhBkkc8TewgHsiD9sWBr-aeionfETg85GrRRQ@mail.gmail.com> (sfid-20160621_141028_808094_D9D87CB3)
Subject: Re: [PATCH] iw: support and enable separate build dir
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Maxin B. John" <maxin.john@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Jun 21, 2016 at 12:41 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2016-06-10 at 13:58 +0300, Maxin B. John wrote:
>> Hi Johannes,
>>
>> On Thu, Jun 9, 2016 at 11:25 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Wed, 2016-06-01 at 11:40 +0300, maxin.john@gmail.com wrote:
>> > > From: "Maxin B. John" <maxin.john@intel.com>
>> > >
>> > > Support separation of SRCDIR and OBJDIR
>> > >
>> > Doesn't seem to work:
>> >
>> > $ mkdir /tmp/obj
>> > $ make clean
>> > $ make OBJDIR=/tmp/obj
>> > [...]
>> >  GEN  version.c
>> >  CC   version.o
>> > cc: error: version.c: No such file or directory
>> > cc: fatal error: no input files
>> > compilation terminated.
>> > Makefile:104: recipe for target 'version.o' failed
>> > make: *** [version.o] Error 1
>> > $ ls *.o
>> > event.o  genl.o  ibss.o  info.o  interface.o  iw.o  mesh.o  mpath.o
>> > mpp.o  ocb.o  phy.o  reg.o  scan.o  station.o  survey.o  util.o
>> >
>> > (object files are in the wrong place too)
>>
>> I was following the below listed steps to verify this patch:
>>
>> # mkdir build
>> # cd build
>> #  make -f <path>/iw/Makefile
>>
>
> Oh. Any chance you could make both work, since the "make O=..." is
> something kernel people are used to/familiar with?

I will look into that. Thanks for the suggestion !

> johannes

Best Regards,
Maxin
