Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:61459 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbYJ3U5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 16:57:38 -0400
Received: by ey-out-2122.google.com with SMTP id 6so320122eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 13:56:45 -0700 (PDT)
Message-ID: <490A1E16.8020902@gmail.com> (sfid-20081030_215742_585280_3629B20F)
Date: Thu, 30 Oct 2008 20:50:30 +0000
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: Guidelines regarding separate directory
References: <4909EA78.3060700@lwfinger.net>	 (sfid-20081030_181107_189082_5740895D) <1225387309.3690.73.camel@johannes.berg>	 <490A17F3.5050802@gmail.com> <1225399481.7931.5.camel@dv>
In-Reply-To: <1225399481.7931.5.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Thu, 2008-10-30 at 20:24 +0000, Dave wrote:
>> On a similar note, would anyone object to collecting the orinoco files
>> in a subdirectory?
> 
> Fine with me.
> 
>> I'm looking at doing some refactoring of orinoco.c
>> which I think can be split into at least 3 files.
> 
> Maybe it's too late at this point, but it would be nice to support
> Orinoco USB eventually.  It uses modified orinoco.c.  Please keep it in
> mind when splitting.  It may be possible to reuse some of the new parts
> in the USB driver.

That's partly why I'm refactorring. Other things I'm thinking of:

cfg80211 (i.e. disentangling the wext handlers from hermes calls)
hermes II
radiotap

Just don't hold your breath.

>> PS the existing files that would move:
>> orinoco_pci.c
> 
> orinoco_pci.c is a good candidate for removal.  It only supports the
> hardware that is already supported by hostap_pci.

ACK. I'll include that as part of the same series.


Dave.
