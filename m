Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:33267 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936006Ab3DIB2r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 21:28:47 -0400
Date: Tue, 9 Apr 2013 02:28:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sean MacLennan <seanm@seanm.ca>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	David Howells <dhowells@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: The rtl8192e procfs-based debug interface seems very broken
Message-ID: <20130409012837.GZ4068@ZenIV.linux.org.uk> (sfid-20130409_032851_290350_FFC60714)
References: <17570.1365415364@warthog.procyon.org.uk>
 <51634550.3090300@lwfinger.net>
 <20130408184615.38b20264@lappy.seanm.ca>
 <51634BCD.3060304@lwfinger.net>
 <20130408211806.3c5b800b@opus.seanm.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130408211806.3c5b800b@opus.seanm.ca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 08, 2013 at 09:18:06PM -0400, Sean MacLennan wrote:
> The procfs debug code in rtl_debug.c is, ironically, very buggy: it lacks proper locking.
> Since the most useful part of the code (the stats) are available through more
> standard APIs, I think it is best to just delete the whole mess.

OK...  Seeing that I've ended up collecting procfs-related fixes all over
the place this cycle, applied.
