Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57809 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaKDJ12 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 04:27:28 -0500
Received: by mail-wi0-f177.google.com with SMTP id ex7so8693223wid.4
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 01:27:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <B2CD83211F5FDD478D7EFFF030D107ED2AE2FDE7@hasmsx107.ger.corp.intel.com>
References: <1415090436-12588-1-git-send-email-emmanuel.grumbach@intel.com>
 <CABPxzYKfoO+NYi7Zs+5t6mRU+XwW5u=dKiBMsrzZ5VLO3ABDAg@mail.gmail.com> <B2CD83211F5FDD478D7EFFF030D107ED2AE2FDE7@hasmsx107.ger.corp.intel.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 4 Nov 2014 14:57:07 +0530
Message-ID: <CABPxzYLFx7M=8E1pGYP7b7k-3xL9J8kYJ868BNDgkYgFOQNUQg@mail.gmail.com> (sfid-20141104_102733_673057_80D12D8D)
Subject: Re: [PATCH] mac80211: Increase uapsd max SP frames number
To: "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 4, 2014 at 2:53 PM, Otcheretianski, Andrei
<andrei.otcheretianski@intel.com> wrote:
> The spec doesn't require unlimited to be really "unlimited" and the AP decides when to end the SP, so any value here is ok.
> However for large traffic bursts increasing this value looks reasonable. Also looks like some certification tests expect more frames to be delivered during SP.
> 128 is still kind of arbitrary value
>
>> -----Original Message-----
>> From: Krishna Chaitanya [mailto:chaitanya.mgit@gmail.com]
>> Sent: Tuesday, November 04, 2014 11:03
>> To: Grumbach, Emmanuel
>> Cc: Johannes Berg; linux-wireless; Otcheretianski, Andrei
>> Subject: Re: [PATCH] mac80211: Increase uapsd max SP frames number
>>
>> On Tue, Nov 4, 2014 at 2:10 PM, Emmanuel Grumbach
>> <emmanuel.grumbach@intel.com> wrote:
>> > From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
>> >
>> > Deliver up to 128 frames during SP instead of 8 if unlimited max SP is
>> > specified during association.
>> >
>> > Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
>> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> > ---
>> >  net/mac80211/sta_info.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c index
>> > de494df..3352741 100644
>> > --- a/net/mac80211/sta_info.c
>> > +++ b/net/mac80211/sta_info.c
>> > @@ -1531,7 +1531,7 @@ void ieee80211_sta_ps_deliver_uapsd(struct
>> sta_info *sta)
>> >                 break;
>> >         case 0:
>> >                 /* XXX: what is a good value? */
>> > -               n_frames = 8;
>> > +               n_frames = 128;
>> >                 break;
>> >         }
>> What is criteria for deciding the threshold?
>> Any specific use case for 128?
I understand, thanks for the explanation.
