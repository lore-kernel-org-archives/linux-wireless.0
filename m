Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:49380 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751304AbcA3DSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 22:18:16 -0500
Message-ID: <1454123891.10099.89.camel@perches.com> (sfid-20160130_041921_055916_C03BEFBD)
Subject: Re: [PATCH] staging: rtl8723au: Fixes unnecessary return warning
From: Joe Perches <joe@perches.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 29 Jan 2016 19:18:11 -0800
In-Reply-To: <CAGRGNgU2EuY9fpe8rhHtA8OLDRC0s5=tcBStqpq=ZbMNrnuf0w@mail.gmail.com>
References: <20160129172908.GA14077@Karyakshetra>
	 <wrfjk2ms465z.fsf@redhat.com>
	 <CAGRGNgWQvdfQc-L9z0NKCyCOorxU0seQ-XvYnZDBWA3QKySrRA@mail.gmail.com>
	 <1454117303.10099.84.camel@perches.com>
	 <CAGRGNgU2EuY9fpe8rhHtA8OLDRC0s5=tcBStqpq=ZbMNrnuf0w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-01-30 at 14:09 +1100, Julian Calaby wrote:
> Hi Joe,

Hello Julian.

> On Sat, Jan 30, 2016 at 12:28 PM, Joe Perches <joe@perches.com>
> wrote:
> > On Sat, 2016-01-30 at 10:17 +1100, Julian Calaby wrote:
> > > On Sat, Jan 30, 2016 at 5:00 AM, Jes Sorensen <Jes.Sorensen@redha
> > > t.com> wrote:
> > > > Bhaktipriya Shridhar <bhaktipriya96@gmail.com> writes:
> > > > > This patch fixes checkpatch.pl warning in rtw_mlme_ext.c
> > > > > file.
> > > > > WARNING: void function return statements are not generally
> > > > > useful
> > []
> > > > > diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> > > > > b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> > []
> > > > > @@ -2657,7 +2657,6 @@ static void issue_probersp(struct
> > > > > rtw_adapter *padapter, unsigned char *da)
> > > > > 
> > > > >       dump_mgntframe23a(padapter, pmgntframe);
> > > > > 
> > > > > -     return;
> > > > >  }
> > > > 
> > > > If you insist on pushing this rather unncessary change, please
> > > > do it
> > > > properly, and remove the blank line before the return statement
> > > > as well.
> > > 
> > > As Jes said, you need to remove the blank lines before the
> > > returns
> > > too. checkpatch should have picked this up, you did run the patch
> > > through checkpatch before you sent it, right?
> > 
> > checkpatch doesn't pick this up.
> > 
> > If you'd like to make it do so, you're welcome to try
> > but it's likely a bit more complicated than it appears.
> 
> I meant the extra blank lines, not the useless return statements.

I understood what you meant.

It's relatively difficult to determine that a line removal
patch causes a blank line to appear before a closing brace.

You're welcome to extend checkpatch to find these things,
but there are likely many additional patch types that need
to be considered.  Remember patches can add, modify and
delete lines.

cheers, Joe
