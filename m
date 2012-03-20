Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40272 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab2CTMHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 08:07:06 -0400
Subject: Re: [PATCH 2/4] compat: backport work_busy()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org
In-Reply-To: <1332214021-9716-3-git-send-email-mcgrof@frijolero.org> (sfid-20120320_042853_043155_41AC0608)
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
	 <1332214021-9716-3-git-send-email-mcgrof@frijolero.org>
	 (sfid-20120320_042853_043155_41AC0608)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Mar 2012 13:07:03 +0100
Message-ID: <1332245223.3329.5.camel@jlt3.sipsolutions.net> (sfid-20120320_130737_033669_7AE6BA84)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 20:26 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
> 
> Best we can do is just tell the users of we are WORK_BUSY_PENDING
> for older kernels. The ckmake log:

[...]

> + * Test whether @work is currently pending or running.  There is no
> + * synchronization around this function and the test result is
> + * unreliable and only useful as advisory hints or for debugging.
> + * Especially for reentrant wqs, the pending state might hide the
> + * running state.

What's this needed for? It seems if it's used only for hints/debugging
we should not need the function, or possibly simply return some
pointless combination like -1?

johannes

