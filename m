Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:60629 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbXCHQdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 11:33:32 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HPLWs-00043v-16
	for linux-wireless@vger.kernel.org; Thu, 08 Mar 2007 11:31:46 -0500
Subject: Re: sparse using insane amounts of memory
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
In-Reply-To: <1173319356.3546.54.camel@johannes.berg>
References: <1173319356.3546.54.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 11:33:28 -0500
Message-Id: <1173371608.21465.12.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-03-08 at 03:02 +0100, Johannes Berg wrote:
> Hi,
> 
> I was running make C=2 over the current wireless-dev tree (as of commit
> 4533da881f2d8c3e0dbb5b3dbc7a919e12438a8a) and reached
> drivers/net/wireless/mac80211/rt2x00/rt2400pci.c when sparse started
> using more and more memory. It went up to about 1 GB. Now I don't know
> whether to blame sparse or if something's wrong with that file but it
> does seem to be a bit excessive... Similar with all the other driver
> files in that directory, yet I've not seen such a case before.

You forgot the version of sparse.  I cannot reproduce the problem with
the current sparse from git
(git://git.kernel.org/pub/scm/linux/kernel/git/josh/sparse.git)

There were some bad bugs fixed recently.  If you are using the snapshot,
please download the latest snapshot now, as they were out-of-date until
very recently.

If you still have the problem, please remove rt2400pci.o and run:

make CC="gcc -save-temps -D__CHECKER__" KBUILD_NOCMDDEP=1

rt2400pci.i will be found in the root of the build tree.  Please see if
you have a problem with it.  If you do, please put it online and post
the URL.

If git sparse resolves the problem, I urge sparse developers to make
another release soon.

-- 
Regards,
Pavel Roskin

