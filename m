Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web55306.mail.re4.yahoo.com ([206.190.58.185]:30751 "HELO
	web55306.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750739AbZFWEUh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 00:20:37 -0400
Message-ID: <617841.37429.qm@web55306.mail.re4.yahoo.com>
Date: Mon, 22 Jun 2009 21:20:39 -0700 (PDT)
From: X Xiao <austinxxh-linux@yahoo.com>
Reply-To: austinxxh-linux@yahoo.com
Subject: Re: [ath9k-devel] Pending ath9k bugs June, 2009
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dmitri Seletski <drjoms@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


not sure if this helps, compat-wireless-2009-06-20 compiled just fine in openwrt with 2.6.30 kernel.

xxiao

--- On Mon, 6/22/09, Dmitri Seletski <drjoms@gmail.com> wrote:

> From: Dmitri Seletski <drjoms@gmail.com>
> Subject: Re: [ath9k-devel] Pending ath9k bugs June, 2009
> To: "Luis R. Rodriguez" <mcgrof@gmail.com>
> Cc: "linux-wireless" <linux-wireless@vger.kernel.org>, gaurav.jauhar@atheros.com, "Senthil Balasubramanian" <senthilkumar@atheros.com>
> Date: Monday, June 22, 2009, 5:46 PM
> Luis R. Rodriguez wrote:
> > On Mon, Jun 22, 2009 at 12:25 PM, Dmitri
> Seletski<drjoms@gmail.com>
> wrote:
> >   
> >> Luis R. Rodriguez wrote:
> >>     
> >>> We're down to 2 kernel.org bug reports for
> ath9k:
> >>>
> >>> http://bugzilla.kernel.org/show_bug.cgi?id=13581
> >>> "ath9k doesn't work with newer kernels"
> >>> This is a regression between 2.6.29 and
> 2.6.30, someone needs to look at this.
> >>>
> >>> http://bugzilla.kernel.org/show_bug.cgi?id=13141
> >>> "AR5008/DWA-552 - Very slow"
> >>> Patches have been supplied, needs user
> feedback.
> >>>
> >>> If you are aware of any other issues please do
> report.
> >>>
> >>>   Luis
> >>>
> _______________________________________________
> >>> ath9k-devel mailing list
> >>> ath9k-devel@lists.ath9k.org
> >>> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
> >>>
> >>>       
> >> Hello Luis,
> >> Was that problem i was bothering you with being
> solved?
> >>     
> >
> > Oh no, thanks for the reminder, that is another
> outstanding issue. Can
> > you provide the pcap output.
> >
> >
> >   
> >> I have attempted to install fresh drivers, but i
> get:
> >>
> >>  make
> >> /bin/sh: line 0: test: -ge: unary operator
> expected
> >> /bin/sh: line 0: test: -le: unary operator
> expected
> >>     
> >
> > Hm, some script may not be using /bin/bash
> appropriately, but you may
> > just want to rm -f /bin/sh && ln -s /bin/bash
> /bin/sh for now.
> >
> >   Luis
> >   
> 
> rm -f /bin/sh && ln -s /bin/bash /bin/sh
> make
> /bin/sh: line 0: test: -ge: unary operator expected
> /bin/sh: line 0: test: -le: unary operator expected
> make -C /lib/modules/2.6.30-rc8/build
> M=/home/dimko/compat-wireless-2009-06-20 modules
> make[1]: Entering directory `/usr/src/linux-2.6.30-rc8'
> make[1]: *** No rule to make target `modules'.  Stop.
> make[1]: Leaving directory `/usr/src/linux-2.6.30-rc8'
> make: *** [modules] Error 2
> 
> 
> 
> Make still fails.
> 
> About pcap, you probably din't get my last email. I have
> included log
> files of tcpdump...
>  I have had no packets going through wireless at all,
> during n only test.
> 
> unfortunately i cant compile anything currently
> 
> solution with rm -f /bin/sh && ln -s /bin/bash
> /bin/sh didnt help
> 
> compat-wireless-2009-06-20 # make
> /bin/sh: line 0: test: -ge: unary operator expected
> /bin/sh: line 0: test: -le: unary operator expected
> make -C /lib/modules/2.6.30-rc8/build
> M=/home/dimko/compat-wireless-2009-06-20 modules
> make[1]: Entering directory `/usr/src/linux-2.6.30-rc8'
> make[1]: *** No rule to make target `modules'.  Stop.
> make[1]: Leaving directory `/usr/src/linux-2.6.30-rc8'
> make: *** [modules] Error 2
> 
> If you want i can of course can  resubmit 
> tcpdump test, but i cant
> install no ath9k drivers, as such test is pointless, as i
> only have
> built in drivers left...
> 
> Sorry for replying to private email.
> 
> just to clarify, by all i mean, i cant compile ath9k
> drivers.
> i could compile kernel for example
> 
> Regards
> Dmitri
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
