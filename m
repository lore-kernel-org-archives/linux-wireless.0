Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57109 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755624AbYDTTKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 15:10:54 -0400
Date: Sun, 20 Apr 2008 21:10:51 +0200
From: Sebastian Siewior <liber+tas@ml.breakpoint.cc>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: Fix ethtool statistics
Message-ID: <20080420191051.GA12136@Chamillionaire.breakpoint.cc> (sfid-20080420_201057_593194_5C69A897)
References: <1208448814.9212.270.camel@pmac.infradead.org> <200804181149.41838.hs4233@mail.mn-solutions.de> <1208517302.9212.324.camel@pmac.infradead.org> <200804181510.53412.hs4233@mail.mn-solutions.de> <20080420084101.GB7685@Chamillionaire.breakpoint.cc> <1208688992.9212.412.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1208688992.9212.412.camel@pmac.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* David Woodhouse | 2008-04-20 11:56:32 [+0100]:

>On Sun, 2008-04-20 at 10:41 +0200, Sebastian Siewior wrote:
>> The function before lbs_ethtool_get_stats() (in net code that
>> determinate the number of elements, dunno the name right now) is able to
>> return an error. This one could check if the firmware has mesh support.
>
>That's what my second patch does.
got to check that patch.

>> Do I understand this correct: If the firmware has support for mesh
>> devices than we have ethX and mshX and only mshX should return the
>> statistics?
>
>Well, they are _mesh_ statistics :)
yes, but I have two interfaces or just one?

>Yeah, that might be worthwhile.
>
>> I will try to form a patch around Monday that fixes Dan's comments (if
>> nobody else is going to).
>
>Which comments? If we apply your original patch, followed by my patch in
><1208509888.9212.291.camel@pmac.infradead.org> (which for some reason
>only went to wireless-dev, not libertas-dev), then I think it's fine.
The comments were
- everything what deals with mesh should take the mash lock
- check for mesh support before calling lbs_ethtool_get_stats()

If your second patch deals with these than yes it should be fine.

>dwmw2

Sebastian
