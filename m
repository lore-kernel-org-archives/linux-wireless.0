Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0L1Kw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 05:52:58 -0500
Date: Tue, 28 Dec 2010 11:52:57 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Eric Appleman <erappleman@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi: Intel 3945ABG speed issues finally identified.
Message-ID: <20101228105256.GB2347@redhat.com>
References: <loom.20101223T071403-99@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20101223T071403-99@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 23, 2010 at 06:15:18AM +0000, Eric Appleman wrote:
> I spent most of the day bisecting and testing numerous kernels and my work has
> finally paid off.
> 
> I've found 2 candidate commits.
> 
> a6866ac93e6cb68091326e80b4fa4619a5957644
> 1402364162afbaac1b8a74ee21aeb013e817ac7d
> 
> iwl3945 definitely broke between 2.6.35-rc2 and -rc3.

For sure breakage is between -rc2 and -rc3 ?

We have these commits:
$ git log --pretty=oneline v2.6.35-rc2..v2.6.35-rc3 -- net/mac80211/ drivers/net/wireless/iwlwifi/
b054b747a694927879c94dd11af54d04346aed7d mac80211: fix deauth before assoc
6db6340c42d027b6364d49fa99d69019aca24de4 iwlwifi: add missing rcu_read_lock
35dd0509b21e4b5bab36b9eb80c8dab0322f5007 mac80211: fix function pointer check
7d47618a2ade0cb6d8a0b2597029c383c1662fa0 iwlwifi: move sysfs_create_group to post request firmware
1402364162afbaac1b8a74ee21aeb013e817ac7d iwl3945: fix internal scan
a6866ac93e6cb68091326e80b4fa4619a5957644 iwl3945: enable stuck queue detection on 3945
8b9a4e6e442756f670ef507f09bbc6c11dc0fca6 mac80211: process station blockack action frames from work

Also there are some general network commits.

What I can tell, none of them could cause performance problems in
obvious way. If breakage is really between 2.6.35 -rc2 and -rc3, could
you install 2.6.35 kernel from source, and revert these commits 
one by one to see revert of which commit fix the problem?

Stanislaw 
