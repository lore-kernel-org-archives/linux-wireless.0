Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56502 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbcFULNN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 07:13:13 -0400
Message-ID: <1466502087.3170.17.camel@sipsolutions.net> (sfid-20160621_131325_530385_22EA0382)
Subject: Re: [PATCH] iw: support and enable separate build dir
From: Johannes Berg <johannes@sipsolutions.net>
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Maxin B. John" <maxin.john@intel.com>
Date: Tue, 21 Jun 2016 11:41:27 +0200
In-Reply-To: <CAMhs6Yw-ScHvfjsxKGG-teXAYtebsrOEmRzt9-VBepoeNkpjWg@mail.gmail.com> (sfid-20160610_125900_263648_E37B4F59)
References: <1464770416-17514-1-git-send-email-maxin.john@gmail.com>
	 <1465460710.3442.4.camel@sipsolutions.net>
	 <CAMhs6Yw-ScHvfjsxKGG-teXAYtebsrOEmRzt9-VBepoeNkpjWg@mail.gmail.com>
	 (sfid-20160610_125900_263648_E37B4F59)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-06-10 at 13:58 +0300, Maxin B. John wrote:
> Hi Johannes,
> 
> On Thu, Jun 9, 2016 at 11:25 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2016-06-01 at 11:40 +0300, maxin.john@gmail.com wrote:
> > > From: "Maxin B. John" <maxin.john@intel.com>
> > > 
> > > Support separation of SRCDIR and OBJDIR
> > > 
> > Doesn't seem to work:
> > 
> > $ mkdir /tmp/obj
> > $ make clean
> > $ make OBJDIR=/tmp/obj
> > [...]
> >  GEN  version.c
> >  CC   version.o
> > cc: error: version.c: No such file or directory
> > cc: fatal error: no input files
> > compilation terminated.
> > Makefile:104: recipe for target 'version.o' failed
> > make: *** [version.o] Error 1
> > $ ls *.o
> > event.o  genl.o  ibss.o  info.o  interface.o  iw.o  mesh.o  mpath.o
> > mpp.o  ocb.o  phy.o  reg.o  scan.o  station.o  survey.o  util.o
> > 
> > (object files are in the wrong place too)
> 
> I was following the below listed steps to verify this patch:
> 
> # mkdir build
> # cd build
> #  make -f <path>/iw/Makefile
> 

Oh. Any chance you could make both work, since the "make O=..." is
something kernel people are used to/familiar with?

johannes
