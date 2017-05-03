Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34560 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751601AbdECIPF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 04:15:05 -0400
Message-ID: <1493799303.2602.6.camel@sipsolutions.net> (sfid-20170503_101539_977117_3D93DCC1)
Subject: Re: [PATCH 0/9] nl80211: add support for PTK/GTK handshake offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 03 May 2017 10:15:03 +0200
In-Reply-To: <134ac4a3-63d0-c5f1-2d05-9bcbd573c8b5@broadcom.com> (sfid-20170503_101018_932901_AC012B79)
References: <1493728949-10797-1-git-send-email-arend.vanspriel@broadcom.com>
         <1493790549.2602.5.camel@sipsolutions.net>
         <134ac4a3-63d0-c5f1-2d05-9bcbd573c8b5@broadcom.com>
         (sfid-20170503_101018_932901_AC012B79)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-05-03 at 10:10 +0200, Arend van Spriel wrote:
> 
> I was asking because we do it for the keys:

correction: the *temporal* keys :)

> 	/*
> 	 * Delete all the keys ... pairwise keys can't really
> 	 * exist any more anyway, but default keys might.
> 	 */
> 	if (rdev->ops->del_key)
> 		for (i = 0; i < 6; i++)
> 			rdev_del_key(rdev, dev, i, false, NULL);
> 
> But I guess the comment explains it as PMK is a pairwise (master)
> key.

Well, not really related, but I basically think we can demand better
from drivers implementing the new functionality.

johannes
