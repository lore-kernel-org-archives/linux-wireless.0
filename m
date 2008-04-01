Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:63312 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbYDAG1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 02:27:06 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2451586wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 23:27:06 -0700 (PDT)
Message-ID: <1ba2fa240803312327vcedd4a5y520e3d42f9dc3452@mail.gmail.com> (sfid-20080401_072725_150985_DAD70408)
Date: Tue, 1 Apr 2008 09:27:06 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: mac80211 bug? no data is being transmitted after interface is brought down and then up again
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"=?ISO-8859-1?Q?Thomas_B=E4chler?=" <thomas@archlinux.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200804011053.19675.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <fsm20k$usk$1@ger.gmane.org> <20080331190225.GA12933@tuxdriver.com>
	 <200804011053.19675.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/1/08, bruno randolf <bruno@thinktube.com> wrote:
> On Tuesday 01 April 2008 04:02:25 John W. Linville wrote:
> > On Sat, Mar 29, 2008 at 07:32:51PM +0100, Thomas B=E4chler wrote:
> > > My question is, should this be considered a bug in mac80211?
> > > IMO, when an interface is brought down and then up again, one of =
the
> > > following things should happen:
> > > 1) Everything works as before
> > > 2) Nothing works, but the card disassociates from the network.
> >
> > #2 would be my vote.
>
> why is that? would it be so difficult to provide #1?

Driver should not take policy decision. It should be user controled app=
lincation
such as NM or ifup script of whatever to decide if to reconnect or not.

>
> from a usability point of view #1 would be clearly better. whatever t=
he state
> was before, when i bring the interface up it want it to work (associa=
te, join
> IBSS) and be able to transmit data.

=46or usuablity point of view you should configure your applicantion or
script to do reconnection, but it should not be driver call to do
that.
There are security issues with this that just get more and more compilc=
ated.
In application level you have more options to discover your
environment and handle user preferences. and take the correct call

Tomas

> bruno
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
