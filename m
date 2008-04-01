Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:40569 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752805AbYDAM5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 08:57:43 -0400
From: bruno randolf <bruno@thinktube.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: mac80211 bug? no data is being transmitted after interface is brought down and then up again
Date: Tue, 1 Apr 2008 21:57:25 +0900
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Thomas =?iso-8859-1?q?B=E4chler?=" <thomas@archlinux.org>,
	linux-wireless@vger.kernel.org
References: <fsm20k$usk$1@ger.gmane.org> <200804011053.19675.bruno@thinktube.com> <1ba2fa240803312327vcedd4a5y520e3d42f9dc3452@mail.gmail.com>
In-Reply-To: <1ba2fa240803312327vcedd4a5y520e3d42f9dc3452@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200804012157.25474.bruno@thinktube.com> (sfid-20080401_135750_801448_01928572)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 April 2008 15:27:06 Tomas Winkler wrote:
> On 4/1/08, bruno randolf <bruno@thinktube.com> wrote:
> > On Tuesday 01 April 2008 04:02:25 John W. Linville wrote:
> > > On Sat, Mar 29, 2008 at 07:32:51PM +0100, Thomas B=E4chler wrote:
> > > > My question is, should this be considered a bug in mac80211?
> > > > IMO, when an interface is brought down and then up again, one o=
f the
> > > > following things should happen:
> > > > 1) Everything works as before
> > > > 2) Nothing works, but the card disassociates from the network.
> > >
> > > #2 would be my vote.
> >
> > why is that? would it be so difficult to provide #1?
>
> Driver should not take policy decision. It should be user controled
> applincation such as NM or ifup script of whatever to decide if to
> reconnect or not.
>
> > from a usability point of view #1 would be clearly better. whatever=
 the
> > state was before, when i bring the interface up it want it to work
> > (associate, join IBSS) and be able to transmit data.
>
> For usuablity point of view you should configure your applicantion or
> script to do reconnection, but it should not be driver call to do
> that.
> There are security issues with this that just get more and more
> compilcated.. In application level you have more options to discover =
your
> environment and handle user preferences. and take the correct call

allright - that seems to be the way to go. thanks for the explanation. =
i guess=20
i'm a little bit behind, still thinking in in terms of iwconfig ;)

bruno
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
