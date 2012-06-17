Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34526 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665Ab2FQRMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jun 2012 13:12:54 -0400
Received: by eeit10 with SMTP id t10so1337080eei.19
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jun 2012 10:12:52 -0700 (PDT)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	Schrober <franzschrober@yahoo.de>
Subject: Re: ath9k bug in country domain handling
Date: Sun, 17 Jun 2012 19:12:29 +0200
Message-ID: <1416482.lsS5g7Br9z@sylvesterjr.cmi.ua.ac.be> (sfid-20120617_191304_706591_B64F9CE6)
In-Reply-To: <CAGRGNgXO21GfXm02MigmUdeiYd5osnZVeDRLxz6LEyDCYy5Q+A@mail.gmail.com>
References: <9709270.9fbk3VIit7@sylvesterjr.cmi.ua.ac.be> <1425745.oeb9uPtGCl@sylvesterjr.cmi.ua.ac.be> <CAGRGNgXO21GfXm02MigmUdeiYd5osnZVeDRLxz6LEyDCYy5Q+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sunday 17 June 2012 12:15:47 Julian Calaby wrote:
> There are two places where the country codes and their associated
> restrictions come from:
> 1. The user, by saying "iw reg set XX" or having some other program
> set that for them.
> 2. The driver, by asking the card which country it's been configured for.
> 
> The kernel regulatory framework then takes these two sets of
> regulatory data, finds the intersection of them, and restricts the
> channels and options available for the card based on that.
> 
> Why?
> 
> I'm not sure of the exact details, but I know that most wireless cards
> are configured, by which I mean calibrated, adjusted and tuned to work
> in a particular country. Some are configured for the entire world, but
> most are configured for a single country's requirements. The driver
> cannot assume that if it asks the card to do anything outside the
> country it's been configured for, that it will perform predictably.
> So, for example, if the driver asks your card to use a channel that is
> outside the US's regulatory requirements, the driver cannot guarantee
> that, even if it instructs the card how to use that channel correctly,
> it will actually use that channel in a manner consistent with
> Belgium's regulatory requirements.
> 
> The driver's behaviour when it encounters the unset regulatory
> information on the card will be to use the default information for
> that card. Which in this case is the US regulatory restrictions.
> 
> I hate to say it, but the issue here is *not* the driver itself. The
> supplier of that card has not set it up correctly for Belgium, and the
> driver is compensating for that as best as it can.
> 
> I have a similar card at home in Australia, it's configured for use in
> China, and thankfully the intersection of China's and Australia's
> regulatory requirements are such that I can use it for the purpose I
> purchased it for.
> 

Ow., this is new to me. Thanks a lot for the explanation, now I see why things 
are like they are!

Thanks a lot!
Erwin

