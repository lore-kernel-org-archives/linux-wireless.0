Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:32925 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbcGMNvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 09:51:31 -0400
Received: by mail-io0-f177.google.com with SMTP id 38so46678533iol.0
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 06:51:16 -0700 (PDT)
Date: Wed, 13 Jul 2016 09:50:22 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [PATCH] mac80211: End the MPSP even if EOSP frame was not
 received
Message-ID: <20160713135021.GE7819@localhost> (sfid-20160713_155348_457252_4325DC76)
References: <1468393475-2483-1-git-send-email-masashi.honma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468393475-2483-1-git-send-email-masashi.honma@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 13, 2016 at 04:04:35PM +0900, Masashi Honma wrote:
> The mesh STA sends QoS frame with EOSP (end of service period)
> subfiled=1 to end the MPSP(mesh peer service period). Previously, if
> the frame was not acked by peer, the mesh STA did not end the MPSP.
> This patch ends the MPSP even if the QoS frame was no acked.

Hmm, my recollection on this stuff is a little fuzzy.  So we only get
here if the peer sta is in doze state, but it shouldn't do that if we
are in an MPSP.  So, is the real problem that we don't wait for an ack
from the peer before marking ourselves in a MPSP?

-- 
Bob Copeland %% http://bobcopeland.com/
