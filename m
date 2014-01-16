Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41963 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaAPJbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 04:31:52 -0500
Message-ID: <1389864706.4345.1.camel@jlt4.sipsolutions.net> (sfid-20140116_103156_898120_58D2D232)
Subject: Re: [RFC 9/9] mac80211: implement multi-interface CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 16 Jan 2014 10:31:46 +0100
In-Reply-To: <CA+BoTQ=UJNLD3dmzD4PDK1exSJFeWTdpkAHc2YvVbktugw_AyQ@mail.gmail.com> (sfid-20140116_102805_794169_3235EA94)
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
	 <1389787494-7361-10-git-send-email-michal.kazior@tieto.com>
	 <1389792139.4338.6.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=UJNLD3dmzD4PDK1exSJFeWTdpkAHc2YvVbktugw_AyQ@mail.gmail.com>
	 (sfid-20140116_102805_794169_3235EA94)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-16 at 10:28 +0100, Michal Kazior wrote:
> On 15 January 2014 14:22, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-01-15 at 13:04 +0100, Michal Kazior wrote:
> >> This implements a fairly simple multi-interface
> >> CSA. It doesn't support multiple channel
> >> contexts so it doesn't support multi-channel.
> >
> > It seems that this also means that somewhere you need to advertise the
> > multi-switch feature. I guess you need that anyway, but this makes it
> > obvious.
> 
> I don't really understand. Do we really need it? You want to advertise
> it just to cfg80211 or all the way up to userspace?

It seems it would be needed all the way to userspace so it knows whether
it can expect multi-vif CSA to be available? Or would you just want to
try & fail? Wouldn't that potentially impact channel selection since
you'd want to not pick radar channels for multi-vif? Not really sure ...

Maybe the expectation is that internally there will be no drivers that
don't support it, i.e. if a driver implements the cfg80211 API at all
then it must support multi-vif CSA?

johannes

