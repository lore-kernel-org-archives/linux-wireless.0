Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:52800 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965652AbXBTDys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 22:54:48 -0500
Message-ID: <20070219225446.bgyosgww88c8wk80@webmail.spamcop.net>
Date: Mon, 19 Feb 2007 22:54:46 -0500
From: Pavel Roskin <proski@gnu.org>
To: Alex Davis <alex14641@yahoo.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: Kernel bug in bcm43xx-d80211
References: <178298.69840.qm@web50208.mail.yahoo.com>
In-Reply-To: <178298.69840.qm@web50208.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Alex Davis <alex14641@yahoo.com>:

> I merged Michael's changes. It doesn't panic anymore, but I still can't
> associate. Here's the
> output from wpa_supplicant 0.4.9:

I'm sorry!  I didn't realize git would be merging two branches.  I did try my
commands, but I didn't notice the message about merging.

If you merge two branches, you are pulling the bugs from wireless.dev into the
bcm43xx branch.

You need to remove the merge by resetting the local branch to the remote branch.
 Please use this command:

git-reset --hard remotes/bcm43xx/master

bcm43xx is the name you used in the git-remote command.  Perhaps we need some
kind of git wrapper to deal with all that complexity of having multiple remotes
in one repository.  I'll ask in the git list.  It doesn't look like an exotic
case anymore.

Once you have reverted the branch, disable CONFIG_CFG80211 in .config - it's not
ready yet.  This would fix the iwconfig output.

As for association timeout, it's probably unrelated, bit it would be helpful if
you recheck it on clean sources.  It's possible wpa_supplicant doesn't get the
AP MAC address properly.

--
Regards,
Pavel Roskin
