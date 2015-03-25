Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0042.hostedemail.com ([216.40.44.42]:45372 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751803AbbCYAfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 20:35:01 -0400
Message-ID: <1427243696.12126.24.camel@perches.com> (sfid-20150325_013506_817148_CD0B6E73)
Subject: Re: [PATCH] staging: rtl8723au: Update RT_TRACE macro and uses
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	LKML <linux-kernel@vger.kernel.org>
Date: Tue, 24 Mar 2015 17:34:56 -0700
In-Reply-To: <wrfjegodj4xj.fsf@redhat.com>
References: <1427220609.5642.39.camel@perches.com>
	 <1427238404.12126.17.camel@perches.com> <wrfjegodj4xj.fsf@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-24 at 20:28 -0400, Jes Sorensen wrote:
> Joe Perches <joe@perches.com> writes:
> > Create an rt_trace function using %pV to reduce overall code size.
> > Update the macro uses to remove unnecessary and now harmful parentheses.
[]
> This could be further improved by fixing up all the places where the
> function name is hard coded into the print statement, instead of using
> __func__. In particular as a lot of it is carried over from old code
> and has been renamed since.

There's a cocci script for that.

http://cocci.systeme.lip6.narkive.com/nKXf6Bmy/finding-embedded-function-names

I expect someone will run it one day on staging.


