Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:33968 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbcHKTH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 15:07:28 -0400
Received: by mail-qk0-f179.google.com with SMTP id p186so5121289qkd.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2016 12:07:28 -0700 (PDT)
Subject: Re: [PATCH 1/4] cfg80211: rdev-ops: remove callback check from
 rdev_set_coalesce()
To: Johannes Berg <johannes@sipsolutions.net>
References: <1470825209-10054-1-git-send-email-arend.vanspriel@broadcom.com>
 <1470919713.12075.8.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ee2929c1-1f1b-ca1e-07d2-a3f43f8b73a8@broadcom.com> (sfid-20160811_210732_227113_BF52C960)
Date: Thu, 11 Aug 2016 21:00:40 +0200
MIME-Version: 1.0
In-Reply-To: <1470919713.12075.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-8-2016 14:48, Johannes Berg wrote:
> On Wed, 2016-08-10 at 12:33 +0200, Arend van Spriel wrote:
>> The wrapper rdev_set_coalesce() checks whether the driver provides
>> the set_coalesce callback and returns -ENOTSUPP if not. However, this
>> check is already performed in nl80211_set_coalesce() resulting in
>> -EOPNOTSUPP. This patch removes check from rdev wrapper function.
> 
> What's the point though? Presumably the compiler will optimise it out,
> and it seems safer to have it this way? Same for all patches in this
> series.

I was in doubt to raise the question first about getting this stuff
consistent, ie. keep rdev-ops as flat as possible, but decided just to
put it out there in patch format. My bad :-)

If you want the rdev-ops to be safe against (future) callers not
checking the callback, it seems you should add a check in all rdev-ops
where the callback is optional.

Regards,
Arend
