Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35735
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXCHOIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 09:08:10 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: Please pull 'libertas' branch of wireless-2.6
Date: Thu, 8 Mar 2007 15:06:49 +0100
Cc: Christoph Hellwig <hch@infradead.org>,
	Marcelo Tosatti <marcelo@kvack.org>,
	Jeff Garzik <jeff@garzik.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20070227205649.GH5826@tuxdriver.com> <20070307222404.GA23393@infradead.org> <1173321651.12017.6.camel@localhost.localdomain>
In-Reply-To: <1173321651.12017.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703081506.49750.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 March 2007 03:40, Dan Williams wrote:
> We are unhappy with specific knobs _if_and_only_if_ they duplicate
> functionality that's currently available.
> 
> That means, for example, the prism2 WPA ioctls, because WE-19 has
> equivalent functionality.  Other examples include many of the madwifi
> ioctls like auth_mode for which there are WEXT calls.  Others include
> the ones for creating virtual STAs that are now subsumed by mac80211.
> 
> For stuff that's seriously not common among drivers, there's nothing
> else that drivers can do but provide private ioctls.

Exactly.
And, if you add some private tuning knob, you should think about,
if it doesn't really belong to a common place like cfg80211, if other
devices have similiar functionality.

If it's really private to your device, doing some private tuning knob
is perfectly fine. But maybe you should consider sysfs, configfs or something
like that, because iwpriv is going to die with WEXT.

-- 
Greetings Michael.
