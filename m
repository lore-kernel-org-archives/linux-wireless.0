Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:3233 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758641Ab0EMLEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 07:04:45 -0400
Message-ID: <4BEBDCCA.1040004@gmail.com>
Date: Thu, 13 May 2010 13:04:42 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH v2 04/10] rt2x00: Move rt2x00debug_dump_frame declaration
 	to rt2x00.h.
References: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>	 <1273743418-28383-5-git-send-email-gwingerde@gmail.com> <AANLkTilbzQ1_16u2hjkh6pFSnUmjg8bNRHiJf_g1hPPb@mail.gmail.com>
In-Reply-To: <AANLkTilbzQ1_16u2hjkh6pFSnUmjg8bNRHiJf_g1hPPb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/13/10 11:45, Ivo Van Doorn wrote:
> On Thu, May 13, 2010 at 11:36 AM, Gertjan van Wingerde
> <gwingerde@gmail.com> wrote:
>> This allows rt2x00debug_dump_frame to be used from everywhere.
>>
>> This is preparation for beacon writing clean ups.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> ---
>>  drivers/net/wireless/rt2x00/rt2x00.h      |   35 +++++++++++++++++++++++++++++
>>  drivers/net/wireless/rt2x00/rt2x00debug.c |    1 +
>>  drivers/net/wireless/rt2x00/rt2x00dump.h  |   20 ----------------
>>  drivers/net/wireless/rt2x00/rt2x00lib.h   |   10 --------
>>  4 files changed, 36 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
>> index 6c1ff4c..1329f6c 100644
>> --- a/drivers/net/wireless/rt2x00/rt2x00.h
>> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
>> @@ -1015,6 +1015,41 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
>>                                          enum queue_index index);
>>
>>  /*
>> + * Debugfs handlers.
>> + */
>> +/**
>> + * enum rt2x00_dump_type - Frame type
>> + *
>> + * These values are used for the indicate the type of frame that is being
>> + * dumped:
>> + * @DUMP_FRAME_RXDONE: This frame has been received by the hardware.
>> + * @DUMP_FRAME_TX: This frame is queued for transmission to the hardware.
>> + * @DUMP_FRAME_TXDONE: This frame indicates the device has handled
>> + *     the tx event which has either succeeded or failed. A frame
>> + *     with this type should also have been reported with as a
>> + *     %DUMP_FRAME_TX frame.
>> + * @DUMP_FRAME_BEACON: This beacon frame is queued for transmission to the
>> + *     hardware.
>> + */
>> +enum rt2x00_dump_type {
>> +       DUMP_FRAME_RXDONE = 1,
>> +       DUMP_FRAME_TX = 2,
>> +       DUMP_FRAME_TXDONE = 3,
>> +       DUMP_FRAME_BEACON = 4,
>> +};
> 
> Can't this stay in rt2x00dump.h? The rt2x00dump.h is part of the
> public interface towards
> userspace which can use these defined to determine the frame type.
> We can safely include this header in rt2x00.h since it contains the
> public interface anyway.

Hmpf, it looks like there is a lot of unspecified assumptions about the placement
of information in files and for some functionality. We must get better in documenting
this.
Although it is a bit strange to have a public interface to userspace defined this deep
in the kernel source tree, I'll move it back and put a big fat comment is there that this
actually is the public interface towards userspace and that all this information is to
be kept together.

> 
>> +#ifdef CONFIG_RT2X00_LIB_DEBUGFS
>> +void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
>> +                           enum rt2x00_dump_type type, struct sk_buff *skb);
>> +#else
>> +static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
>> +                                         enum rt2x00_dump_type type,
>> +                                         struct sk_buff *skb)
>> +{
>> +}
>> +#endif /* CONFIG_RT2X00_LIB_DEBUGFS */
> 
> Could you add some documentation to this function?
> 

Off course I can; although that is a bit more than just moving declarations ;-)

---
Gertjan.
