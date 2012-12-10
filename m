Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2LJVzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:55:01 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TiBJU-0002yb-Kz
	for linux-wireless@vger.kernel.org; Mon, 10 Dec 2012 22:55:00 +0100
Message-ID: <1355176525.8083.19.camel@jlt4.sipsolutions.net> (sfid-20121210_225507_269247_25470208)
Subject: Re: [PATCH 01/24] regulatory: don't write past array when
 intersecting rules
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 22:55:25 +0100
In-Reply-To: <1354812468-15709-2-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174803_199203_E3EBF5F7)
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
	 <1354812468-15709-2-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121206_174803_199203_E3EBF5F7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-06 at 17:47 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When intersecting rules, we count first to know how many
> rules need to be allocated, and then do the intersection
> into the allocated array. However, the code doing this
> writes past the end of the array because it attempts to
> do all intersections. Make it stop when the right number
> of rules has been reached.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

FWIW, since we currently allocate enough memory here to actually write
past the end of the intended array, I've decided to remove the stable
tag. It doesn't really fix anything -- with the next patch it fixes the
allocation to not be too large, but that doesn't really need to go to
stable.

johannes

