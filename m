Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759561Ab0I1HWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 03:22:48 -0400
Subject: Re: [PATCH 2/2] mac80211:  Allow scanning single channel if other
 VIF is associated.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1285632457-27539-2-git-send-email-greearb@candelatech.com>
References: <1285632457-27539-1-git-send-email-greearb@candelatech.com>
	 <1285632457-27539-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 09:22:44 +0200
Message-ID: <1285658564.3885.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 17:07 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This patch aims to decrease channel switching when there is at least one
> interface associated.  This should help multiple station interfaces co-exist
> on the same hardware, especially in WPA mode.

Totally NACK. The code is ugly, complex, and unnecessary.

You can make wpa_s scan the channels one by one, or you can improve the
off-channel behaviour, but this is a workaround that just isn't
appropriate.

johannes

