Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:35577 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbYCYRNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 13:13:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: silently accept deletion of non-existant key
Date: Tue, 25 Mar 2008 18:12:45 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1206459795-18167-1-git-send-email-linville@tuxdriver.com> <1206462125.16475.303.camel@johannes.berg> <20080325163751.GA19318@tuxdriver.com>
In-Reply-To: <20080325163751.GA19318@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803251812.45916.mb@bu3sch.de> (sfid-20080325_171351_294525_352321E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 25 March 2008 17:37:51 John W. Linville wrote:
> On Tue, Mar 25, 2008 at 05:22:05PM +0100, Johannes Berg wrote:
> > 
> > On Tue, 2008-03-25 at 11:43 -0400, John W. Linville wrote:
> > > From: John W. Linville <linville@linville-t41.local>
> > > 
> > > Otherwise, 'iwconfig wlan0 key off' with no key set results in:
> > > 
> > > 	Error for wireless request "Set Encode" (8B2A) :
> > > 	    SET failed on device wlan0 ; No such file or directory.
> > 
> > And what is the problem with us telling iwconfig that there was no key?
> > You should argue for iwconfig ignoring that particular problem, but I
> > don't think we should do so in the kernel.
> 
> Why is it a problem?  How does it hurt anything?  How is it useful
> to return an error?
> 
> FWIW, other drivers seem to accept it.  I don't see why we need to
> complain.

Well, it makes sense to return an error in this case, but if common
practice is to ignore it in old WE based drivers, we should adhere to that
to preserve userspace ABI compatibility.

So the real question is: Is there any userspace program that relies on
this ABI detail?

-- 
Greetings Michael.
