Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:11656 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbXFHUKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 16:10:11 -0400
Received: by py-out-1112.google.com with SMTP id a29so1425069pyi
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2007 13:10:11 -0700 (PDT)
Message-ID: <43e72e890706081310j47ed891cl1ebb132e65517db3@mail.gmail.com>
Date: Fri, 8 Jun 2007 16:10:10 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jouni Malinen" <jkm@devicescape.com>
Subject: Re: [PATCH V3] mac80211: Set low initial rate in rc80211_simple
Cc: "Jiri Benc" <jbenc@suse.cz>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Larry Finger" <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070608183446.GJ14078@devicescape.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <200706072205.27902.flamingice@sourmilk.net>
	 <20070608112146.2df3608c@griffin.suse.cz>
	 <20070608145821.GD14078@devicescape.com>
	 <43e72e890706081112k76e17827t4c66dbccdcee0e03@mail.gmail.com>
	 <20070608183446.GJ14078@devicescape.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/8/07, Jouni Malinen <jkm@devicescape.com> wrote:
> On Fri, Jun 08, 2007 at 02:12:57PM -0400, Luis R. Rodriguez wrote:
> > On 6/8/07, Jouni Malinen <jkm@devicescape.com> wrote:
> > >There are some odd cases, where disabling the lowest supported rate may
> > >even be required due to regulatory rules..
>
> > Just curious -- are you aware of a regulatory domain where this is the
> > case? Who defines those rules? For example, AFAICT FCC only talk about
> > power, and spectrum ranges. Where would I even look for these type of
> > restrictions?
>
> I don't remember all the details, but one case I've heard of was about
> a rule that specified high bandwidth wireless operations and what
> exactly would be high enough to be acceptable. And no, this was not
> from FCC. Unfortunately, I do not have any good pointers for where to
> look for this type of restrictions in an easy to use form (as in
> something that I could easily understand ;-).

:( We'll have to just start capturing and documenting these type of
weird regulatory anomalies on the wiki.

> One related issue is the requirement for not transmitting continuously
> for longer than a quite short time period before sensing the medium
> again (this is from Japan). This may require at least fragmentation
> based on TX rate (i.e., if low rate is used, fragmentation threshold
> needs to be set lower) and in some cases, it may just be easier to drop
> the lowest TX rates completely to avoid frames that may take long time
> to transmit.

Wow, aren't those regulatory requirements breaking the spec? I wonder
if loading a different rate algorithm depending on regdomain would do
the job in a case like this.

  Luis
