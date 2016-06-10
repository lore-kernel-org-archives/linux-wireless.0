Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35062 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483AbcFJK7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 06:59:00 -0400
Received: by mail-io0-f196.google.com with SMTP id n127so8458027iof.2
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2016 03:58:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465460710.3442.4.camel@sipsolutions.net>
References: <1464770416-17514-1-git-send-email-maxin.john@gmail.com> <1465460710.3442.4.camel@sipsolutions.net>
From: "Maxin B. John" <maxin.john@gmail.com>
Date: Fri, 10 Jun 2016 13:58:58 +0300
Message-ID: <CAMhs6Yw-ScHvfjsxKGG-teXAYtebsrOEmRzt9-VBepoeNkpjWg@mail.gmail.com> (sfid-20160610_125912_798912_F12624ED)
Subject: Re: [PATCH] iw: support and enable separate build dir
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Maxin B. John" <maxin.john@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, Jun 9, 2016 at 11:25 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2016-06-01 at 11:40 +0300, maxin.john@gmail.com wrote:
>> From: "Maxin B. John" <maxin.john@intel.com>
>>
>> Support separation of SRCDIR and OBJDIR
>>
> Doesn't seem to work:
>
> $ mkdir /tmp/obj
> $ make clean
> $ make OBJDIR=/tmp/obj
> [...]
>  GEN  version.c
>  CC   version.o
> cc: error: version.c: No such file or directory
> cc: fatal error: no input files
> compilation terminated.
> Makefile:104: recipe for target 'version.o' failed
> make: *** [version.o] Error 1
> $ ls *.o
> event.o  genl.o  ibss.o  info.o  interface.o  iw.o  mesh.o  mpath.o
> mpp.o  ocb.o  phy.o  reg.o  scan.o  station.o  survey.o  util.o
>
> (object files are in the wrong place too)

I was following the below listed steps to verify this patch:

# mkdir build
# cd build
#  make -f <path>/iw/Makefile
# ls *.o
bitrate.o  coalesce.o  connect.o  cqm.o  event.o  genl.o  ibss.o  info.o
interface.o  iw  iw.o  link.o  mesh.o  mpath.o  mpp.o  ocb.o  offch.o  p2p.o
phy.o  ps.o  reason.o  reg.o  roc.o  scan.o  sections.o  station.o  status.o
survey.o  util.o  vendor.o  version.c  version.o  wowlan.o

> johannes

Best Regards,
Maxin
