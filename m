Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50216 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932277AbcLMPXo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 10:23:44 -0500
Message-ID: <1481642621.20412.4.camel@sipsolutions.net> (sfid-20161213_162347_962784_6FFFF119)
Subject: Re: [PATCH v2 1/2] mac80211: Remove invalid flag operations in mesh
 TSF synchronization
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>, me@bobcopeland.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Dec 2016 16:23:41 +0100
In-Reply-To: <1481159751-4097-1-git-send-email-masashi.honma@gmail.com> (sfid-20161208_021606_564192_26DE0C5C)
References: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com>
         <1481159751-4097-1-git-send-email-masashi.honma@gmail.com>
         (sfid-20161208_021606_564192_26DE0C5C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-12-08 at 10:15 +0900, Masashi Honma wrote:
> mesh_sync_offset_adjust_tbtt() implements Extensible synchronization
> framework ([1] 13.13.2 Extensible synchronization framework). It
> shall
> not operate the flag "TBTT Adjusting subfield" ([1] 8.4.2.100.8 Mesh
> Capability), since it is used only for MBCA ([1] 13.13.4 Mesh beacon
> collision avoidance, see 13.13.4.4.3 TBTT scanning and adjustment
> procedures for detail). So this patch remove the flag operations.
> 

Both applied; I changed this patch to remove ifmsh->adjusting_tbtt
completely since it was now unused.

johannes
