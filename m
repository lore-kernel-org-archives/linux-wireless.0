Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55200 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab3BNLTA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 06:19:00 -0500
Message-ID: <1360840730.8210.1.camel@jlt4.sipsolutions.net> (sfid-20130214_121905_830823_23D2592B)
Subject: Re: [PATCH v2 2/3] mac80211: cache mesh beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Thu, 14 Feb 2013 12:18:50 +0100
In-Reply-To: <1360786461-30107-2-git-send-email-thomas@cozybit.com> (sfid-20130213_211540_930271_3D0A9A30)
References: <1360786461-30107-1-git-send-email-thomas@cozybit.com>
	 <1360786461-30107-2-git-send-email-thomas@cozybit.com>
	 (sfid-20130213_211540_930271_3D0A9A30)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-13 at 12:14 -0800, Thomas Pedersen wrote:
> Previously, the entire mesh beacon would be generated each
> time the beacon timer fired. Instead generate a beacon
> head and tail (so the TIM can easily be inserted when mesh
> power save is on) when starting a mesh or the MBSS
> parameters change.
> 
> Also add a mutex for protecting beacon updates and
> preventing leaks.

And I dropped the patch again due to a sparse warning (with RCU sparse
enabled in Kconfig):

net/mac80211/mesh.c:836:9: warning: incorrect type in argument 1 (different address spaces)
net/mac80211/mesh.c:836:9:    expected struct callback_head *head
net/mac80211/mesh.c:836:9:    got struct callback_head [noderef] <asn:4>*<noident>

(btw, should there be locking there in that function?)

johannes

