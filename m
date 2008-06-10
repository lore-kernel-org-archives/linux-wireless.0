Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50385 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbYFJUDP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 16:03:15 -0400
Subject: Re: http://www.orbit-lab.org/kernel/compat-wireless-2.6/2008/04/
From: Pavel Roskin <proski@gnu.org>
To: Grant Williamson <traxtopel@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <484ECE93.1090501@gmail.com>
References: <484ECE93.1090501@gmail.com>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 16:03:12 -0400
Message-Id: <1213128193.26837.15.camel@dv> (sfid-20080610_220321_050594_BD844A1B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-10 at 14:57 -0400, Grant Williamson wrote:
> Hi,
> 
> I am trying to narrow down a wireless issue I am having with leap on 
> Fedora 9. Seems that in April the issue was fixed in the 
> compat-wireless-2.6 tarball.
> 
> On http://www.orbit-lab.org/kernel/compat-wireless-2.6/2008/04/ most of 
> the archives for April are missing. Is there any
> other mirror where I can find or checkout the archives between 20080407 
> & 20080420?
> 
> I need to track it down so the issue can get fixed on el5.

The snapshots are not suitable for bisecting bugs.  Even a single day
can bring dozens of updates.

This right tool for bisection is git.  Please check out the wireless
tree:

git-clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

Then compile the kernel.  See if the problem exists.  You need to use
reverse logic, since you are looking for a patch that fixed something,
not a patch that broke it.

Thus, if the problem is fixed, mark the revision as "bad" with
"git-bisect bad".  Then find a revision that is likely to have the
problem.  Use "git-tag -l" or an interactive tool, such as qgit or tig.
Check it out with "git-checkout".  Test the kernel.  Mark is with
"git-bisect bad" or "git-bisect good" using the same reversed logic.

Once you find one "good" and one "bad" revision, git-bisect will be
telling you what to test next, and a few tests later, you'll have the
exact change you are looking for.

You can also check logs for the problem or describe it here in case
somebody knows which patch fixed it.

-- 
Regards,
Pavel Roskin
