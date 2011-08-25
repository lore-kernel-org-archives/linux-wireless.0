Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40843 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1HYRq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 13:46:58 -0400
Received: by pzk37 with SMTP id 37so2815971pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 10:46:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314248900.5054.45.camel@jlt3.sipsolutions.net>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
 <1314236452-7226-3-git-send-email-thomas@cozybit.com> <1314248900.5054.45.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 25 Aug 2011 10:46:38 -0700
Message-ID: <CAPjQAd9EXmRE8vWFRD0gmiWtoMpz47iFGQttGLxDL-ht8Bawgg@mail.gmail.com> (sfid-20110825_194702_089717_86845AAB)
Subject: Re: [PATCH 2/9] mac80211: Limit amount of HWMP frames and forwarded
 data packets in queues on mesh interfaces
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org,
	Pedro Larbig <pedro.larbig@carhs.de>, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 10:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-08-24 at 18:40 -0700, Thomas Pedersen wrote:
>> From: Pedro Larbig <pedro.larbig@carhs.de>
>>
>> To avoid contention problems in a mesh network's high load areas, this patch
>> adds a 2-stage packet dropping mechanism:
>> * If the transmit queue for HWMP frames is filled with 256 or more packets,
>> additional HWMP frames will be dropped
>> * If the transmit queue for forwarded packets is at 384 or more, drop those,
>> too
>
>> +     /* Frames going through ieee80211_tx_skb will be on the voice queue,
>> +      * Therefor we need to check only IEEE80211_AC_VO */
>> +     if (unlikely(skb_queue_len(&local->pending[IEEE80211_AC_VO]) >=
>> +        MESH_MGMT_QUEUE_LEN)) {
>> +             kfree_skb(skb);
>> +             I802_DEBUG_INC(local->tx_handlers_drop_mesh_mgmt);
>> +             return;
>> +     }
>
> I still don't think this should be done. If the HW queue is full, we
> will get a stop_queue from the driver, this could also tell mesh to stop
> forwarding or so.

Oh, I see, ieee80211_stop_queue().

Thanks!

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
