Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33528 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1JTQrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 12:47:55 -0400
Received: by iaek3 with SMTP id k3so3614612iae.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 09:47:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E9F110A.5000608@candelatech.com>
References: <1311607763-12603-1-git-send-email-eliad@wizery.com>
	<1311607763-12603-2-git-send-email-eliad@wizery.com>
	<4E9F110A.5000608@candelatech.com>
Date: Thu, 20 Oct 2011 18:47:54 +0200
Message-ID: <CAB3XZEfEC1myJ8a_p==Ahz2LWLxTqh_DUm=xHZtrJX1yGO+-SQ@mail.gmail.com> (sfid-20111020_184758_702496_019242A5)
Subject: Re: [RFC 1/2] mac80211: fix remain_off_channel regression
From: Eliad Peller <eliad@wizery.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Ben,

On Wed, Oct 19, 2011 at 8:03 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 07/25/2011 08:29 AM, Eliad Peller wrote:
>>
>> i'm not familiar enough with the off_channel flow,
>> but this one looks completely broken - we should
>> remain_off_channel if the work was started, and
>> the work's channel and channel_type are the same
>> as local->tmp_channel and local->tmp_channel_type.
>>
>> however, if wk->chan_type and local->tmp_channel_type
>> coexist (e.g. have the same channel type), we won't
>> remain_off_channel.
>>
>> this behavior was introduced by commit da2fd1f
>> ("mac80211: Allow work items to use existing
>> channel type.")
>>
>> Signed-off-by: Eliad Peller<eliad@wizery.com>
>
> Both Johannes and I agreed with this patch shortly after it
> was posted, and I have just done a quick test with multiple
> stations and it appears to work fine.
>
> Eliad:  Please re-send this patch w/out the RFC, and you
> can add:
>
> Tested-by: Ben Greear <greearb@candelatech.com>
>
it seems that i forgot to resubmit the RFCs as patches.
thanks for testing, i'll submit them shortly.

(John - i see there is some ongoing discussion regarding similar
patches, so feel free to take only some of them, according to the
conclusion)

Eliad.
