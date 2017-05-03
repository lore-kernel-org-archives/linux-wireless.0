Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:35303 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdECI3t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 04:29:49 -0400
Received: by mail-qk0-f180.google.com with SMTP id q1so8675751qkd.2
        for <linux-wireless@vger.kernel.org>; Wed, 03 May 2017 01:29:49 -0700 (PDT)
Subject: Re: [PATCH 0/9] nl80211: add support for PTK/GTK handshake offload
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1493728949-10797-1-git-send-email-arend.vanspriel@broadcom.com>
 <1493790549.2602.5.camel@sipsolutions.net>
 <134ac4a3-63d0-c5f1-2d05-9bcbd573c8b5@broadcom.com>
 <1493799303.2602.6.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <190a84de-7e0a-4012-f1e1-c0dbdbc8c1df@broadcom.com> (sfid-20170503_102953_824790_49625A22)
Date: Wed, 3 May 2017 10:29:46 +0200
MIME-Version: 1.0
In-Reply-To: <1493799303.2602.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/3/2017 10:15 AM, Johannes Berg wrote:
> On Wed, 2017-05-03 at 10:10 +0200, Arend van Spriel wrote:
>>
>> I was asking because we do it for the keys:
> 
> correction: the *temporal* keys :)
> 
>> 	/*
>> 	 * Delete all the keys ... pairwise keys can't really
>> 	 * exist any more anyway, but default keys might.
>> 	 */
>> 	if (rdev->ops->del_key)
>> 		for (i = 0; i < 6; i++)
>> 			rdev_del_key(rdev, dev, i, false, NULL);
>>
>> But I guess the comment explains it as PMK is a pairwise (master)
>> key.
> 
> Well, not really related, but I basically think we can demand better
> from drivers implementing the new functionality.

Yeah, I do it in brcmfmac. I will mention that demand in CMD_SET_PMK 
and/or .set_pmk() description.

Regards,
Arend
