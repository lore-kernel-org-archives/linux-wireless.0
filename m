Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43484 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753188AbdBNNML (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 08:12:11 -0500
Message-ID: <1487077927.4705.14.camel@sipsolutions.net> (sfid-20170214_141302_005417_1463B6B4)
Subject: Re: [RFC V2 1/5] nl80211: allow multiple active scheduled scan
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 14 Feb 2017 14:12:07 +0100
In-Reply-To: <deef3e83-b6d8-f99d-516d-dc6e99013560@broadcom.com> (sfid-20170214_140714_136831_A3105A18)
References: <1484566941-27000-1-git-send-email-arend.vanspriel@broadcom.com>
         <1484566941-27000-2-git-send-email-arend.vanspriel@broadcom.com>
         <1485250815.7244.8.camel@sipsolutions.net>
         <fd4c2573-caea-1cdc-ee33-f010bb0aad58@broadcom.com>
         <1487076714.4705.11.camel@sipsolutions.net>
         <deef3e83-b6d8-f99d-516d-dc6e99013560@broadcom.com>
         (sfid-20170214_140714_136831_A3105A18)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-14 at 14:07 +0100, Arend Van Spriel wrote:

> > No. But there was a size limit on how much older userspace could
> > process before we did the splitting.
> 
> I see. So basically adding stuff to (split_start == 0) is not wanted.

Correct.

> Just trying to get a clear requirement/rule here. Do we (still) know
> the exact size limit?

No, I don't remember. It's pretty ancient versions of iw/wpa_s that
weren't able to deal with it. There was also interaction with the
allocations in the dump function in nl80211 code itself, but we made
those pretty big already and userspace limits came into play iirc.

johannes
