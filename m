Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:36724 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdECIKT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 04:10:19 -0400
Received: by mail-wr0-f175.google.com with SMTP id l50so99727735wrc.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 May 2017 01:10:19 -0700 (PDT)
Subject: Re: [PATCH 0/9] nl80211: add support for PTK/GTK handshake offload
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1493728949-10797-1-git-send-email-arend.vanspriel@broadcom.com>
 <1493790549.2602.5.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <134ac4a3-63d0-c5f1-2d05-9bcbd573c8b5@broadcom.com> (sfid-20170503_101048_600761_A97269B3)
Date: Wed, 3 May 2017 10:10:16 +0200
MIME-Version: 1.0
In-Reply-To: <1493790549.2602.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/3/2017 7:49 AM, Johannes Berg wrote:
> On Tue, 2017-05-02 at 13:42 +0100, Arend van Spriel wrote:
>> Another change is the
>> addition of the flag ATTR_WANT_1X_OFFLOAD that user-space has to pass
>> in CONNECT request. Some drivers may need to be aware before the PMK
>> is programmed through SET_PMK request.
> 
> That naming seems a bit questionable - WANT_1X_4WAY_HS or so might be
> better? We don't (want to) offload the 1X handshake after all, so that
> name is a bit confusing IMHO.

Sure. Will do.

>> This series also comes with driver implementation in brcmfmac
>> although it does not use the authorized flag in the ROAM event (yet).
>>
>> The series applies to the master branch of the mac80211-next
>> repository.
> 
> Cool.
> 
>> One remaining open issue is regarding DEL_PMK. The wpa_supplicant
>> patches posted on hostap list do not use it and the .del_pmk() is
>> also not used within cfg80211. Should it be called in
>> __cfg80211_disconnected() just to be sure?
> 
> I don't really think so - once you disconnect surely the PMK for the
> connection is no longer valid. IMHO it's reasonable to require ensuring
> that from drivers, where necessary (mostly, I assume firmware would
> throw away the data anyway)

I was asking because we do it for the keys:

	/*
	 * Delete all the keys ... pairwise keys can't really
	 * exist any more anyway, but default keys might.
	 */
	if (rdev->ops->del_key)
		for (i = 0; i < 6; i++)
			rdev_del_key(rdev, dev, i, false, NULL);

But I guess the comment explains it as PMK is a pairwise (master) key.

Regards,
Arend
