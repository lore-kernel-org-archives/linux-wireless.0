Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49548 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934268AbeAXQUW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 11:20:22 -0500
Message-ID: <1516810820.2508.45.camel@sipsolutions.net> (sfid-20180124_172050_828567_6B590AA3)
Subject: Re: [PATCH 8/8] mt76: validate rx CCMP PN
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Date: Wed, 24 Jan 2018 17:20:20 +0100
In-Reply-To: <7a022b57-af4a-78ee-aa8f-d0cd9eb17685@nbd.name>
References: <20180124151917.70962-1-nbd@nbd.name>
         <20180124151917.70962-8-nbd@nbd.name>
         <1516809416.2508.44.camel@sipsolutions.net>
         <7a022b57-af4a-78ee-aa8f-d0cd9eb17685@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-24 at 17:11 +0100, Felix Fietkau wrote:
> 
> I guess I will have to look into fragmentation. I have a second driver
> pending that only reports the CCMP PN outside of the packet, and for
> performance reasons I really don't want to translate it and move it to a
> place where mac80211 can parse it.
> I'm also looking into doing parallel rx in software to see if I can get
> more performance that way. I think for that I would also need CCMP PN
> validation in the driver.

Fair enough. We also do it, except we just decide that fragmented
packets we don't care and can use mac80211 - but we get the PN in-
frame, just can't always use mac80211 due to parallel RX.

johannes
