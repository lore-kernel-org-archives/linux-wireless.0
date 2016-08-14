Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0225.hostedemail.com ([216.40.44.225]:45826 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932766AbcHNMHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2016 08:07:08 -0400
Message-ID: <1471176423.5201.7.camel@perches.com> (sfid-20160814_140728_287552_B24E0221)
Subject: Re: [PATCH] Staging: rtl8723au: os_intfs: fixed case statement is
 variable issue
From: Joe Perches <joe@perches.com>
To: sunbing <sunbing@redflag-linux.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, sunbing.linux@gmail.com,
	Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 14 Aug 2016 05:07:03 -0700
In-Reply-To: <E0CA1BD5-A2ED-4FDC-8E58-8024E2F3C24C@redflag-linux.com>
References: <1470924695-14931-1-git-send-email-sunbing@redflag-linux.com>
	 <wrfja8gje395.fsf@redhat.com>
	 <7FC388BC-FD87-44C6-87D3-AC041F1393DB@redflag-linux.com>
	 <wrfj7fbmawl1.fsf@redhat.com>
	 <E0CA1BD5-A2ED-4FDC-8E58-8024E2F3C24C@redflag-linux.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-08-13 at 17:26 +0800, sunbing wrote:
> On Aug 12, 2016, at 22:30, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> > sunbing <sunbing@redflag-linux.com> writes:
> > > On Aug 11, 2016, at 23:25, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> > > > Bing Sun <sunbing@redflag-linux.com> writes:
> > > > > 
> > > > > Fixed sparse parse error:
> > > > > Expected constant expression in case statement.
[]
> > > > Pardon me here, but I find it really hard to see how this change is an
> > > > improvement over the old code in any shape or form.
> > > There is no functional improvement. 
> > > But before this patch, when we do: make C=1 M=drivers/staging/rtl8723au/
> > > An error output: 
> > > drivers/staging/rtl8723au//os_dep/os_intfs.c:287:14: error: Expected
> > > constant expression in case statement
> > > To avoid sparse parse error, a case statement converts to an if statement.
> > > So we got this patch.
> > Hello
> > 
> > I understand this part, but it seems to me we are changing the code due
> > to a broken test case in sparse. Does the warning go away if you use
> > __constant_htons() instead of htons()?
> > 
> > Jes
> Thanks for your guidance.
> 
> 1. If I use __constant_htons, checkpatch.pl will warning:
>     WARNING: __constant_htons should be htons
> 
> 2. In os_intfs.c: rtw_classify8021d, there are only one case statement and a 
> default statement. So, convert "switch case" to "if else" is more readable in my opinion.
> 
> So, I pushed this patch.
> 
> There are some patches convert use of __constant_htons to htons in kernel logs. 
> Will there be a new patch convert to htons in the future if I use  __constant_htons now ?
> 
> After search through kernel code, there are 158 "case htons(...)" statements and 
> 2 "case __constant_htons(...)" statements. Does this mean we can ignore sparse 
> error and use "case htons(...)" ?
> 
> It makes me confused. More help, please.

It's a sparse defect.

Try again after patching sparse with Jes' patch:
http://marc.info/?l=linux-sparse&m=147091200720267&w=3

