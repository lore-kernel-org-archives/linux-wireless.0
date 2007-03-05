Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34819 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848AbXCEOIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 09:08:52 -0500
Date: Mon, 5 Mar 2007 14:08:25 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Please pull 'libertas' branch of wireless-2.6
Message-ID: <20070305140825.GA9982@infradead.org>
References: <20070227205649.GH5826@tuxdriver.com> <45E8CF5E.5090305@garzik.org> <20070303052140.GA31075@infradead.org> <20070304153627.GA32380@dmt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070304153627.GA32380@dmt>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 04, 2007 at 12:36:27PM -0300, Marcelo Tosatti wrote:
> Hi Christoph,
> 
> On Sat, Mar 03, 2007 at 05:21:40AM +0000, Christoph Hellwig wrote:
> > Umm, I can't remember the updated driver ever beeig posted for review.
> 
> http://lists.openwall.net/netdev/2007/02/10/25
> 
> > And to be honest I'd be surprised if it's in a good shape already.
> 
> Constructive comments are welcome... All comments made by Arnd (which
> were many!) have been addressed.

Comments on that versions from a quick read over it:

 - the __le* annotation issue you mentioned in the mail is important.
   We definitvely don't want any new drivers without endianess annotations,
   because there are far too many endianess problems.  Even more so
   in a case of a driver like this one that's only tested on LE hardware
   and has LE device endianess.
 - things like 11d.[ch] don't have business of beeing in a driver,
   this should be somewhere in common code.
 - there shouldn't be a LICENSE file in individual driver directories,
   especially if it's just plain old GPLv2.
 - please get rid of setting -DFOO flags in the Makefile, just use
   these directly as config symbols.
 - there shouldn't be a README file in the driver directory, this
   should be in Documentation/
 - please don't use wlan_* foo types.  a) this should be structs, not
   typedefs, and b) wlan is an utterly generic name for beeing inside
   a driver.  Then again most things using this should be inside
   generic code anyway.. (and yeah, all that is because the driver
   copied braindead linux-wlan-ng code that probably needs a major
   revision anyway)
 - there seems to be lots of tabs vs spaces messups
 - please get rid of the ENTER/LEAVE macros
 - there's an awful lot of headers without clear divided responsibilities,
   there should be only a few ones left (internal interfaces and hw
   interface basically)
 - having lowercase names for lots of hw commands is a very bad idea
   for readability
 - please get rid of all your private ioctls and iwpriv stuff
   (should I add !!!! here)
 - scan.h has very strange almost docbook comments, please convert
   them to real docbook comments and actually run things through
   the tools to make sure it's right.
 - scan.h has vi indentation comment helpers that are contrary to
   linux coding style..
 - the thread.h abstractions are really useless, opencoding them
   would make the code a lot more readable.  And make people
   notice it's actually wrong:
	o the return value from kthread_run needs to be checked
	o wlan_deactivate_thread is not needed at all
	o storing and checking the pid should go away
	o there is no need for an additional waitqueue, you can
	  just use wake_up_process for kernel threads.
 - most of types.h should not be there but you should be using
   the types from include/linux/*80211*
 - version.h shouldn't exist
 - the radiotap header changes should definitively not be in
   a "add a new driver" diff
