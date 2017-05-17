Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40732 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751637AbdEQNQA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 09:16:00 -0400
Message-ID: <1495026958.2442.11.camel@sipsolutions.net> (sfid-20170517_151605_798771_CD09FA26)
Subject: Re: when to use wdev_lock()
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 17 May 2017 15:15:58 +0200
In-Reply-To: <49584b67-0bdf-0acf-fb98-a7bea5978fbc@broadcom.com> (sfid-20170503_120449_325519_EDC2F7D8)
References: <49584b67-0bdf-0acf-fb98-a7bea5978fbc@broadcom.com>
         (sfid-20170503_120449_325519_EDC2F7D8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Sorry for the long delay.

> I bumped into use of wdev_lock() again with 802.1X 4-way-hs offload 
> stuff. So for .set_pmk() and .del_pmk() it takes wdev_lock(). Is
> there a  rule of thumb when this lock is needed. What is it
> protecting in general  and in the case of pmk configuration.

No, unfortunately it's not very well defined.

One thing that drove this is that mac80211 (and perhaps some full-mac
drivers) uses the same lock to prevent races between their own and
cfg80211's state. So some of the locking is driven by that as well.

I think it may have been done here just for consistency with other
calls.

johannes
