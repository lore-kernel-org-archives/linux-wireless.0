Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52712 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbbGQMjz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 08:39:55 -0400
Message-ID: <1437136793.1933.12.camel@sipsolutions.net> (sfid-20150717_143957_737312_635D8FE6)
Subject: Re: [PATCH v3 2/5] mac80211: add missing length check for confirm
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Fri, 17 Jul 2015 14:39:53 +0200
In-Reply-To: <1436877119-17577-3-git-send-email-me@bobcopeland.com> (sfid-20150714_143219_590927_15FC051D)
References: <1436877119-17577-1-git-send-email-me@bobcopeland.com>
	 <1436877119-17577-3-git-send-email-me@bobcopeland.com>
	 (sfid-20150714_143219_590927_15FC051D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-07-14 at 08:31 -0400, Bob Copeland wrote:
> Although mesh_rx_plink_frame() already checks that frames have enough
> bytes for the action code plus another two bytes for 
> capability/reason
> code, it doesn't take into account that confirm frames also have an
> additional two-byte aid.  As a result, a corrupt frame could cause a
> subsequent subtraction to wrap around to ill effect.  Add another
> check for this case.
> 
Also applied.

johannes
