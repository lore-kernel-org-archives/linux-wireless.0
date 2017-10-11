Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:35015 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752314AbdJKRrT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 13:47:19 -0400
Message-ID: <1507744033.3552.55.camel@perches.com> (sfid-20171011_194912_187837_C3FD6318)
Subject: Re: [PATCH] rtl8xxxu: mark expected switch fall-throughs
From: Joe Perches <joe@perches.com>
To: David Laight <David.Laight@ACULAB.COM>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Wed, 11 Oct 2017 10:47:13 -0700
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD009123C@AcuExch.aculab.com>
References: <20171010193027.GA23108@embeddedor.com>
         <1507717237.3552.48.camel@perches.com>
         <063D6719AE5E284EB5DD2968C1650D6DD009123C@AcuExch.aculab.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-11 at 12:54 +0000, David Laight wrote:
> From: Joe Perches
> > Sent: 11 October 2017 11:21
> > On Tue, 2017-10-10 at 14:30 -0500, Gustavo A. R. Silva wrote:
> > > In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> > > where we are expecting to fall through.
> > 
> > perhaps use Arnaldo's idea:
> > 
> > https://lkml.org/lkml/2017/2/9/845
> > https://lkml.org/lkml/2017/2/10/485
> 
> gah, that is even uglier and requires a chase through
> headers to find out what it means.

Sure, if you think __fallthrough; isn't self-documenting.

	case foo;
		bar;
		__fallthrough;
	case baz;
		etc...



		
