Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:60335 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752912Ab1ARTcc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 14:32:32 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Tue, 18 Jan 2011 11:32:18 -0800
Subject: RE: [PATCH] mwifiex: remove duplicated NULL checks
Message-ID: <477F20668A386D41ADCC57781B1F704307F4E1BB91@SC-VEXCH1.marvell.com>
References: <1295033760-31108-1-git-send-email-bzhao@marvell.com>
 <AANLkTi=BMTLa36FXW7nNHKu8=PgPCJC517vsmDDNZcYj@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F704307F4E1BA0D@SC-VEXCH1.marvell.com>
 <AANLkTi=UfKkYcX6CF9bQ84+anr74DKS-tXuH61NASObf@mail.gmail.com>
In-Reply-To: <AANLkTi=UfKkYcX6CF9bQ84+anr74DKS-tXuH61NASObf@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

> -----Original Message-----
> From: Julian Calaby [mailto:julian.calaby@gmail.com]
> Sent: Monday, January 17, 2011 7:26 PM
> To: Bing Zhao
> Cc: linux-wireless@vger.kernel.org; John W. Linville; Johannes Berg; Amitkumar Karwar; Kiran Divekar;
> Frank Huang
> Subject: Re: [PATCH] mwifiex: remove duplicated NULL checks
> 
> On Tue, Jan 18, 2011 at 14:07, Bing Zhao <bzhao@marvell.com> wrote:
> > Hi Julian,
> >
> >> -----Original Message-----
> >> From: Julian Calaby [mailto:julian.calaby@gmail.com]
> >> Sent: Friday, January 14, 2011 6:59 PM
> >> To: Bing Zhao
> >> Cc: linux-wireless@vger.kernel.org; John W. Linville; Johannes Berg; Amitkumar Karwar; Kiran
> Divekar;
> >> Frank Huang
> >> Subject: Re: [PATCH] mwifiex: remove duplicated NULL checks
> >>
> >> On Sat, Jan 15, 2011 at 06:36, Bing Zhao <bzhao@marvell.com> wrote:
> >> > From: Amitkumar Karwar <akarwar@marvell.com>
> >> >
> >> > Some functions have unnecessory NULL check for an input parameter
> >> > because the caller to those functions is already checking the parameter
> >> > for NULL before calling them.
> >>
> >> It may be more readable and efficient to eliminate the NULL checks in
> >> the callers - and adjust the code to inform the callers of the case
> >> where the pointer passed is null and make the callers to properly
> >> handle this case.
> >
> > Thank you very much for your comments.
> >
> > There are still some cases that the NULL check needs to be done at the first place. For example,
> >
> [snip]
> 
> In this case, dropping the null check is the right thing to do, given
> that you can guarantee that all callers of mwiflex_init_cmd_node()
> will check that the pointer isn't null before calling it.
> 
> >> This should also make the driver more robust as failures can be passed
> >> up the stack to places that can deal with them more effectively than
> >> just printing a message.
> >
> > I could have misunderstood your point, however. If so, could you please explain a little bit more
> on how you would make the changes based on above example?
> 
> I was referring more to that fact that functions that appear to do
> things, e.g. mwifiex_init_cmd_node(), don't return anything - hence if
> something fails within them, e.g. being passed a null pointer, they
> can't notify their caller, e.g. mwifiex_prepare_cmd() that something
> has gone wrong.
> 
> That said, I haven't looked at the code except through your patches,
> so I can't say if this is a scenario that actually could happen, and
> whether this added functionality is worthwhile.

Thanks for your comments.

mwifiex_init_cmd_node() just initializes the cmd_node structure with variables that have been validated before. But what you said makes sense in general. The function should return something to the caller if anything can go wrong.

Best regards,

Bing

> 
> Thanks,
> 
> --
> Julian Calaby
> 
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/
