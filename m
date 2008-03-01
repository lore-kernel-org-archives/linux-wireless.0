Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:56965 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbYCAPwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 10:52:38 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: pull request: wireless-2.6 2008-02-27
Date: Sat, 1 Mar 2008 16:51:12 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>,
	gordonfarquharson@gmail.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080228014125.GI3078@tuxdriver.com> <20080229214240.GH3234@tuxdriver.com> <20080301130133.GA14250@uranus.ravnborg.org>
In-Reply-To: <20080301130133.GA14250@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803011651.13652.mb@bu3sch.de> (sfid-20080301_155242_475256_05EDAB69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 01 March 2008, Sam Ravnborg wrote:
> > This version seems to work, but it is a bit chatty when CROSS_COMPILE
> > is set and you build lots of modules...thoughts?
> 
> We cannot use CROSS_COMPILE to detect a cross build as CROSS_COMPILE
> is used used to select different gcc versions, cccache etc.
> The only relaiably way to detect a cross build is to check
> is ARCH != modified uname -m arch.
> So this check would have to be done in the top-level Makefile.
> 
> And that for shaving 6 bytes of a structure..

Wrong. For maintaining userspace ABI compatibility.
