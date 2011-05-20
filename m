Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59836 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab1ETNNq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 09:13:46 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 06:13:15 -0700
Message-ID: <4DD668F4.6090308@atheros.com> (sfid-20110520_151349_772612_D9BF9393)
Date: Fri, 20 May 2011 16:13:24 +0300
From: Kalle Valo <kalle.valo@atheros.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: gregkh@suse.de, linville@tuxdriver.com,
	devel@linuxdriverproject.org
Subject: Plan for ath6kl cleanup
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have been thinking about how to get ath6kl out from staging and get
it to a first class citizen under drivers/net/wireless. There's quite a
lot of work to do get ath6kl cleaned up and the prospect of doing all
that through the staging-next tree wasn't that exciting. We would be
sending hundreds of patches and it would take a long time to cleanup the
driver. And the disconnection from the wireless core development also
sounded very daunting (cfg80211 API changes etc.).

So we started to find a faster way to clean up ath6kl and ended up with
a setup where we would have a separate tree in kernel.org just for
ath6kl clean up. Once we think that the driver is ready, we will take
the driver from the cleanup tree and submit as a single patch for
review. As we will submit the driver as a single commit, history doesn't
matter and this makes it possible to use not so perfect patches in our
tree and save a lot of time.

During the transition period we will still fix the important bugs in the
staging driver, and naturally port them to the cleaned up driver. But
once the cleaned up driver is accepted we plan to remove the staging driver.

We already started the cleanup and created ath6kl-clean git tree here:

http://git.kernel.org/?p=linux/kernel/git/kvalo/ath6kl-cleanup.git;a=summary

The tree is based on wireless-testing and I have cherry picked missing
ath6kl patches from staging-next tree. Also the driver is already moved
to drivers/net/wireless/ath/ath6kl directory to make it easy to submit
the driver for review once it's ready.

Everyone is free to send patches and participate in the ath6kl cleanup.
As we don't want to clutter linux-wireless mailing list with hundreds of
useless "staging" patches, please send the patches to kvalo@adurom.com
(have to use my private email due to buggy email servers) and I will
apply them.

We have irc channel #ath6kl on freenode where some of the ath6kl devs
hang out. Feel free to make any questions also there, just give enough
time for people to answer. But naturally linux-wireless mailing list is
the best place to ask questions.

Also the wiki page contains some information and we will start adding more:

http://wireless.kernel.org/en/users/Drivers/ath6kl

Thoughts?

Kalle
