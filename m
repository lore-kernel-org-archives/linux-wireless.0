Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbXBMTQJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 14:16:09 -0500
Subject: Re: [PATCH] prism54: correct assignment of DOT1XENABLE in WE-19   codepaths
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1171393331.10344.106.camel@johannes.berg>
References: <1171393222.5329.11.camel@localhost.localdomain>
	 <1171393331.10344.106.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 14:18:26 -0500
Message-Id: <1171394306.5329.24.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-02-13 at 20:02 +0100, Johannes Berg wrote:
> On Tue, 2007-02-13 at 14:00 -0500, Dan Williams wrote:
> > Correct assignment of DOT1XENABLE in WE-19 codepaths.
> > RX_UNENCRYPTED_EAPOL = 1 really means setting DOT1XENABLE _off_, and
> > vice versa.  The original WE-19 patch erroneously reversed that.  This
> > patch fixes association with unencrypted and WEP networks when using
> > wpa_supplicant.
> > 
> > It also adds two missing break statements that, left out, could result
> > in incorrect card configuration.
> > 
> > Please commit to both development and stable branches.

                                          ^^^^^

Right; applicable to anything after _and_ including 2.6.19, which is
when I think the WE-19 patch landed.

Dan

> 
> I guess it could also be applicable for stable?
> 
> johannes

