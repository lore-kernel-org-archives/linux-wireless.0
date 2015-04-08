Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:12634 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbbDHHcr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2015 03:32:47 -0400
Message-ID: <5524D99C.1050902@broadcom.com> (sfid-20150408_093315_613746_A967552E)
Date: Wed, 8 Apr 2015 09:32:44 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcmsmac: Move each system tracepoints to their own header
References: <20150407121148.17207bd8@gandalf.local.home>
In-Reply-To: <20150407121148.17207bd8@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/07/15 18:11, Steven Rostedt wrote:
>
> Every tracing file must have its own TRACE_SYSTEM defined.
> The brcmsmac tracepoint header broke this and added in the middle
> of the file:
>
>   #undef TRACE_SYSTEM
>   #define TRACE_SYSTEM brcmsmac
>
>   #undef TRACE_SYSTEM
>   #define TRACE_SYSTEM brcmsmac_tx
>
>   #undef TRACE_SYSTEM
>   #define TRACE_SYSTEM brcmsmac_msg
>
> Unfortunately, this broke new code in the ftrace infrastructure.
> Moving each of these TRACE_SYSTEMs into their own trace file with
> just one TRACE_SYSTEM per file fixes the issue.
>
> Cc: Arend van Spriel<arend@broadcom.com>

All right. Go ahead and change Cc: into Acked-by:

Regards,
Arend

> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> ---
>
> Requesting an Acked-by so I can pull this into my tree where this is a
> prerequisite for my new code.
>
>   .../brcm80211/brcmsmac/brcms_trace_brcmsmac.h      | 102 ++++++++++
>   .../brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h  |  88 ++++++++
>   .../brcm80211/brcmsmac/brcms_trace_brcmsmac_tx.h   | 110 ++++++++++
>   .../brcm80211/brcmsmac/brcms_trace_events.h        | 225 +--------------------
>   4 files changed, 305 insertions(+), 220 deletions(-)
>   create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_brcmsmac.h
>   create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h
>   create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_brcmsmac_tx.h
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_brcmsmac.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_brcmsmac.h
> new file mode 100644
> index 000000000000..a0da3248b942
> --- /dev/null
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_brcmsmac.h
> @@ -0,0 +1,102 @@
> +/*
> + * Copyright (c) 2011 Broadcom Corporation
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
> + * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
> + * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
> + * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +#if !defined(__TRACE_BRCMSMAC_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define __TRACE_BRCMSMAC_H
> +
> +#include<linux/tracepoint.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM brcmsmac
> +
> +/*
> + * We define a tracepoint, its arguments, its printk format and its
> + * 'fast binary record' layout.
> + */
> +TRACE_EVENT(brcms_timer,
> +	/* TPPROTO is the prototype of the function called by this tracepoint */
> +	TP_PROTO(struct brcms_timer *t),
> +	/*
> +	 * TPARGS(firstarg, p) are the parameters names, same as found in the
> +	 * prototype.
> +	 */
> +	TP_ARGS(t),
> +	/*
> +	 * Fast binary tracing: define the trace record via TP_STRUCT__entry().
> +	 * You can think about it like a regular C structure local variable
> +	 * definition.
> +	 */
> +	TP_STRUCT__entry(
> +		__field(uint, ms)
> +		__field(uint, set)
> +		__field(uint, periodic)
> +	),
> +	TP_fast_assign(
> +		__entry->ms = t->ms;
> +		__entry->set = t->set;
> +		__entry->periodic = t->periodic;
> +	),
> +	TP_printk(
> +		"ms=%u set=%u periodic=%u",
> +		__entry->ms, __entry->set, __entry->periodic
> +	)
> +);
> +
> +TRACE_EVENT(brcms_dpc,
> +	TP_PROTO(unsigned long data),
> +	TP_ARGS(data),
> +	TP_STRUCT__entry(
> +		__field(unsigned long, data)
> +	),
> +	TP_fast_assign(
> +		__entry->data = data;
> +	),
> +	TP_printk(
> +		"data=%p",
> +		(void *)__entry->data
> +	)
> +);
> +
> +TRACE_EVENT(brcms_macintstatus,
> +	TP_PROTO(const struct device *dev, int in_isr, u32 macintstatus,
> +		 u32 mask),
> +	TP_ARGS(dev, in_isr, macintstatus, mask),
> +	TP_STRUCT__entry(
> +		__string(dev, dev_name(dev))
> +		__field(int, in_isr)
> +		__field(u32, macintstatus)
> +		__field(u32, mask)
> +	),
> +	TP_fast_assign(
> +		__assign_str(dev, dev_name(dev));
> +		__entry->in_isr = in_isr;
> +		__entry->macintstatus = macintstatus;
> +		__entry->mask = mask;
> +	),
> +	TP_printk("[%s] in_isr=%d macintstatus=%#x mask=%#x", __get_str(dev),
> +		  __entry->in_isr, __entry->macintstatus, __entry->mask)
> +);
> +#endif /* __TRACE_BRCMSMAC_H */
> +
> +#ifdef CONFIG_BRCM_TRACING
> +
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH .
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_FILE brcms_trace_brcmsmac
> +#include<trace/define_trace.h>
> +
> +#endif /* CONFIG_BRCM_TRACING */
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h
> new file mode 100644
> index 000000000000..0e8a69ab909f
> --- /dev/null
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h
> @@ -0,0 +1,88 @@
> +/*
> + * Copyright (c) 2011 Broadcom Corporation
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
> + * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
> + * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
> + * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +#if !defined(__TRACE_BRCMSMAC_MSG_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define __TRACE_BRCMSMAC_MSG_H
> +
> +#include<linux/tracepoint.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM brcmsmac_msg
> +
> +#define MAX_MSG_LEN	100
> +
> +DECLARE_EVENT_CLASS(brcms_msg_event,
> +	TP_PROTO(struct va_format *vaf),
> +	TP_ARGS(vaf),
> +	TP_STRUCT__entry(
> +		__dynamic_array(char, msg, MAX_MSG_LEN)
> +	),
> +	TP_fast_assign(
> +		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
> +				       MAX_MSG_LEN, vaf->fmt,
> +				       *vaf->va)>= MAX_MSG_LEN);
> +	),
> +	TP_printk("%s", __get_str(msg))
> +);
> +
> +DEFINE_EVENT(brcms_msg_event, brcms_info,
> +	TP_PROTO(struct va_format *vaf),
> +	TP_ARGS(vaf)
> +);
> +
> +DEFINE_EVENT(brcms_msg_event, brcms_warn,
> +	TP_PROTO(struct va_format *vaf),
> +	TP_ARGS(vaf)
> +);
> +
> +DEFINE_EVENT(brcms_msg_event, brcms_err,
> +	TP_PROTO(struct va_format *vaf),
> +	TP_ARGS(vaf)
> +);
> +
> +DEFINE_EVENT(brcms_msg_event, brcms_crit,
> +	TP_PROTO(struct va_format *vaf),
> +	TP_ARGS(vaf)
> +);
> +
> +TRACE_EVENT(brcms_dbg,
> +	TP_PROTO(u32 level, const char *func, struct va_format *vaf),
> +	TP_ARGS(level, func, vaf),
> +	TP_STRUCT__entry(
> +		__field(u32, level)
> +		__string(func, func)
> +		__dynamic_array(char, msg, MAX_MSG_LEN)
> +	),
> +	TP_fast_assign(
> +		__entry->level = level;
> +		__assign_str(func, func);
> +		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
> +				       MAX_MSG_LEN, vaf->fmt,
> +				       *vaf->va)>= MAX_MSG_LEN);
> +	),
> +	TP_printk("%s: %s", __get_str(func), __get_str(msg))
> +);
> +#endif /* __TRACE_BRCMSMAC_MSG_H */
> +
> +#ifdef CONFIG_BRCM_TRACING
> +
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH .
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_FILE brcms_trace_brcmsmac_msg
> +#include<trace/define_trace.h>
> +
> +#endif /* CONFIG_BRCM_TRACING */
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_brcmsmac_tx.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_brcmsmac_tx.h
> new file mode 100644
> index 000000000000..cf2cc070f1e5
> --- /dev/null
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_brcmsmac_tx.h
> @@ -0,0 +1,110 @@
> +/*
> + * Copyright (c) 2011 Broadcom Corporation
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
> + * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
> + * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
> + * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +#if !defined(__TRACE_BRCMSMAC_TX_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define __TRACE_BRCMSMAC_TX_H
> +
> +#include<linux/tracepoint.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM brcmsmac_tx
> +
> +TRACE_EVENT(brcms_txdesc,
> +	TP_PROTO(const struct device *dev,
> +		 void *txh, size_t txh_len),
> +	TP_ARGS(dev, txh, txh_len),
> +	TP_STRUCT__entry(
> +		__string(dev, dev_name(dev))
> +		__dynamic_array(u8, txh, txh_len)
> +	),
> +	TP_fast_assign(
> +		__assign_str(dev, dev_name(dev));
> +		memcpy(__get_dynamic_array(txh), txh, txh_len);
> +	),
> +	TP_printk("[%s] txdesc", __get_str(dev))
> +);
> +
> +TRACE_EVENT(brcms_txstatus,
> +	TP_PROTO(const struct device *dev, u16 framelen, u16 frameid,
> +		 u16 status, u16 lasttxtime, u16 sequence, u16 phyerr,
> +		 u16 ackphyrxsh),
> +	TP_ARGS(dev, framelen, frameid, status, lasttxtime, sequence, phyerr,
> +		ackphyrxsh),
> +	TP_STRUCT__entry(
> +		__string(dev, dev_name(dev))
> +		__field(u16, framelen)
> +		__field(u16, frameid)
> +		__field(u16, status)
> +		__field(u16, lasttxtime)
> +		__field(u16, sequence)
> +		__field(u16, phyerr)
> +		__field(u16, ackphyrxsh)
> +	),
> +	TP_fast_assign(
> +		__assign_str(dev, dev_name(dev));
> +		__entry->framelen = framelen;
> +		__entry->frameid = frameid;
> +		__entry->status = status;
> +		__entry->lasttxtime = lasttxtime;
> +		__entry->sequence = sequence;
> +		__entry->phyerr = phyerr;
> +		__entry->ackphyrxsh = ackphyrxsh;
> +	),
> +	TP_printk("[%s] FrameId %#04x TxStatus %#04x LastTxTime %#04x "
> +		  "Seq %#04x PHYTxStatus %#04x RxAck %#04x",
> +		  __get_str(dev), __entry->frameid, __entry->status,
> +		  __entry->lasttxtime, __entry->sequence, __entry->phyerr,
> +		  __entry->ackphyrxsh)
> +);
> +
> +TRACE_EVENT(brcms_ampdu_session,
> +	TP_PROTO(const struct device *dev, unsigned max_ampdu_len,
> +		 u16 max_ampdu_frames, u16 ampdu_len, u16 ampdu_frames,
> +		 u16 dma_len),
> +	TP_ARGS(dev, max_ampdu_len, max_ampdu_frames, ampdu_len, ampdu_frames,
> +		dma_len),
> +	TP_STRUCT__entry(
> +		__string(dev, dev_name(dev))
> +		__field(unsigned, max_ampdu_len)
> +		__field(u16, max_ampdu_frames)
> +		__field(u16, ampdu_len)
> +		__field(u16, ampdu_frames)
> +		__field(u16, dma_len)
> +	),
> +	TP_fast_assign(
> +		__assign_str(dev, dev_name(dev));
> +		__entry->max_ampdu_len = max_ampdu_len;
> +		__entry->max_ampdu_frames = max_ampdu_frames;
> +		__entry->ampdu_len = ampdu_len;
> +		__entry->ampdu_frames = ampdu_frames;
> +		__entry->dma_len = dma_len;
> +	),
> +	TP_printk("[%s] ampdu session max_len=%u max_frames=%u len=%u frames=%u dma_len=%u",
> +		  __get_str(dev), __entry->max_ampdu_len,
> +		  __entry->max_ampdu_frames, __entry->ampdu_len,
> +		  __entry->ampdu_frames, __entry->dma_len)
> +);
> +#endif /* __TRACE_BRCMSMAC_TX_H */
> +
> +#ifdef CONFIG_BRCM_TRACING
> +
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH .
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_FILE brcms_trace_brcmsmac_tx
> +#include<trace/define_trace.h>
> +
> +#endif /* CONFIG_BRCM_TRACING */
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
> index 871781e6a713..cbf2f06436fc 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
> @@ -14,9 +14,8 @@
>    * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>    */
>
> -#if !defined(__TRACE_BRCMSMAC_H) || defined(TRACE_HEADER_MULTI_READ)
> -
> -#define __TRACE_BRCMSMAC_H
> +#ifndef __BRCMS_TRACE_EVENTS_H
> +#define __BRCMS_TRACE_EVENTS_H
>
>   #include<linux/types.h>
>   #include<linux/device.h>
> @@ -34,222 +33,8 @@ static inline void trace_ ## name(proto) {}
>   static inline void trace_ ## name(proto) {}
>   #endif
>
> -#undef TRACE_SYSTEM
> -#define TRACE_SYSTEM brcmsmac
> -
> -/*
> - * We define a tracepoint, its arguments, its printk format and its
> - * 'fast binary record' layout.
> - */
> -TRACE_EVENT(brcms_timer,
> -	/* TPPROTO is the prototype of the function called by this tracepoint */
> -	TP_PROTO(struct brcms_timer *t),
> -	/*
> -	 * TPARGS(firstarg, p) are the parameters names, same as found in the
> -	 * prototype.
> -	 */
> -	TP_ARGS(t),
> -	/*
> -	 * Fast binary tracing: define the trace record via TP_STRUCT__entry().
> -	 * You can think about it like a regular C structure local variable
> -	 * definition.
> -	 */
> -	TP_STRUCT__entry(
> -		__field(uint, ms)
> -		__field(uint, set)
> -		__field(uint, periodic)
> -	),
> -	TP_fast_assign(
> -		__entry->ms = t->ms;
> -		__entry->set = t->set;
> -		__entry->periodic = t->periodic;
> -	),
> -	TP_printk(
> -		"ms=%u set=%u periodic=%u",
> -		__entry->ms, __entry->set, __entry->periodic
> -	)
> -);
> -
> -TRACE_EVENT(brcms_dpc,
> -	TP_PROTO(unsigned long data),
> -	TP_ARGS(data),
> -	TP_STRUCT__entry(
> -		__field(unsigned long, data)
> -	),
> -	TP_fast_assign(
> -		__entry->data = data;
> -	),
> -	TP_printk(
> -		"data=%p",
> -		(void *)__entry->data
> -	)
> -);
> -
> -TRACE_EVENT(brcms_macintstatus,
> -	TP_PROTO(const struct device *dev, int in_isr, u32 macintstatus,
> -		 u32 mask),
> -	TP_ARGS(dev, in_isr, macintstatus, mask),
> -	TP_STRUCT__entry(
> -		__string(dev, dev_name(dev))
> -		__field(int, in_isr)
> -		__field(u32, macintstatus)
> -		__field(u32, mask)
> -	),
> -	TP_fast_assign(
> -		__assign_str(dev, dev_name(dev));
> -		__entry->in_isr = in_isr;
> -		__entry->macintstatus = macintstatus;
> -		__entry->mask = mask;
> -	),
> -	TP_printk("[%s] in_isr=%d macintstatus=%#x mask=%#x", __get_str(dev),
> -		  __entry->in_isr, __entry->macintstatus, __entry->mask)
> -);
> -
> -#undef TRACE_SYSTEM
> -#define TRACE_SYSTEM brcmsmac_tx
> -
> -TRACE_EVENT(brcms_txdesc,
> -	TP_PROTO(const struct device *dev,
> -		 void *txh, size_t txh_len),
> -	TP_ARGS(dev, txh, txh_len),
> -	TP_STRUCT__entry(
> -		__string(dev, dev_name(dev))
> -		__dynamic_array(u8, txh, txh_len)
> -	),
> -	TP_fast_assign(
> -		__assign_str(dev, dev_name(dev));
> -		memcpy(__get_dynamic_array(txh), txh, txh_len);
> -	),
> -	TP_printk("[%s] txdesc", __get_str(dev))
> -);
> -
> -TRACE_EVENT(brcms_txstatus,
> -	TP_PROTO(const struct device *dev, u16 framelen, u16 frameid,
> -		 u16 status, u16 lasttxtime, u16 sequence, u16 phyerr,
> -		 u16 ackphyrxsh),
> -	TP_ARGS(dev, framelen, frameid, status, lasttxtime, sequence, phyerr,
> -		ackphyrxsh),
> -	TP_STRUCT__entry(
> -		__string(dev, dev_name(dev))
> -		__field(u16, framelen)
> -		__field(u16, frameid)
> -		__field(u16, status)
> -		__field(u16, lasttxtime)
> -		__field(u16, sequence)
> -		__field(u16, phyerr)
> -		__field(u16, ackphyrxsh)
> -	),
> -	TP_fast_assign(
> -		__assign_str(dev, dev_name(dev));
> -		__entry->framelen = framelen;
> -		__entry->frameid = frameid;
> -		__entry->status = status;
> -		__entry->lasttxtime = lasttxtime;
> -		__entry->sequence = sequence;
> -		__entry->phyerr = phyerr;
> -		__entry->ackphyrxsh = ackphyrxsh;
> -	),
> -	TP_printk("[%s] FrameId %#04x TxStatus %#04x LastTxTime %#04x "
> -		  "Seq %#04x PHYTxStatus %#04x RxAck %#04x",
> -		  __get_str(dev), __entry->frameid, __entry->status,
> -		  __entry->lasttxtime, __entry->sequence, __entry->phyerr,
> -		  __entry->ackphyrxsh)
> -);
> -
> -TRACE_EVENT(brcms_ampdu_session,
> -	TP_PROTO(const struct device *dev, unsigned max_ampdu_len,
> -		 u16 max_ampdu_frames, u16 ampdu_len, u16 ampdu_frames,
> -		 u16 dma_len),
> -	TP_ARGS(dev, max_ampdu_len, max_ampdu_frames, ampdu_len, ampdu_frames,
> -		dma_len),
> -	TP_STRUCT__entry(
> -		__string(dev, dev_name(dev))
> -		__field(unsigned, max_ampdu_len)
> -		__field(u16, max_ampdu_frames)
> -		__field(u16, ampdu_len)
> -		__field(u16, ampdu_frames)
> -		__field(u16, dma_len)
> -	),
> -	TP_fast_assign(
> -		__assign_str(dev, dev_name(dev));
> -		__entry->max_ampdu_len = max_ampdu_len;
> -		__entry->max_ampdu_frames = max_ampdu_frames;
> -		__entry->ampdu_len = ampdu_len;
> -		__entry->ampdu_frames = ampdu_frames;
> -		__entry->dma_len = dma_len;
> -	),
> -	TP_printk("[%s] ampdu session max_len=%u max_frames=%u len=%u frames=%u dma_len=%u",
> -		  __get_str(dev), __entry->max_ampdu_len,
> -		  __entry->max_ampdu_frames, __entry->ampdu_len,
> -		  __entry->ampdu_frames, __entry->dma_len)
> -);
> -
> -#undef TRACE_SYSTEM
> -#define TRACE_SYSTEM brcmsmac_msg
> -
> -#define MAX_MSG_LEN	100
> -
> -DECLARE_EVENT_CLASS(brcms_msg_event,
> -	TP_PROTO(struct va_format *vaf),
> -	TP_ARGS(vaf),
> -	TP_STRUCT__entry(
> -		__dynamic_array(char, msg, MAX_MSG_LEN)
> -	),
> -	TP_fast_assign(
> -		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
> -				       MAX_MSG_LEN, vaf->fmt,
> -				       *vaf->va)>= MAX_MSG_LEN);
> -	),
> -	TP_printk("%s", __get_str(msg))
> -);
> -
> -DEFINE_EVENT(brcms_msg_event, brcms_info,
> -	TP_PROTO(struct va_format *vaf),
> -	TP_ARGS(vaf)
> -);
> -
> -DEFINE_EVENT(brcms_msg_event, brcms_warn,
> -	TP_PROTO(struct va_format *vaf),
> -	TP_ARGS(vaf)
> -);
> -
> -DEFINE_EVENT(brcms_msg_event, brcms_err,
> -	TP_PROTO(struct va_format *vaf),
> -	TP_ARGS(vaf)
> -);
> -
> -DEFINE_EVENT(brcms_msg_event, brcms_crit,
> -	TP_PROTO(struct va_format *vaf),
> -	TP_ARGS(vaf)
> -);
> -
> -TRACE_EVENT(brcms_dbg,
> -	TP_PROTO(u32 level, const char *func, struct va_format *vaf),
> -	TP_ARGS(level, func, vaf),
> -	TP_STRUCT__entry(
> -		__field(u32, level)
> -		__string(func, func)
> -		__dynamic_array(char, msg, MAX_MSG_LEN)
> -	),
> -	TP_fast_assign(
> -		__entry->level = level;
> -		__assign_str(func, func);
> -		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
> -				       MAX_MSG_LEN, vaf->fmt,
> -				       *vaf->va)>= MAX_MSG_LEN);
> -	),
> -	TP_printk("%s: %s", __get_str(func), __get_str(msg))
> -);
> +#include "brcms_trace_brcmsmac.h"
> +#include "brcms_trace_brcmsmac_tx.h"
> +#include "brcms_trace_brcmsmac_msg.h"
>
>   #endif /* __TRACE_BRCMSMAC_H */
> -
> -#ifdef CONFIG_BRCM_TRACING
> -
> -#undef TRACE_INCLUDE_PATH
> -#define TRACE_INCLUDE_PATH .
> -#undef TRACE_INCLUDE_FILE
> -#define TRACE_INCLUDE_FILE brcms_trace_events
> -
> -#include<trace/define_trace.h>
> -
> -#endif /* CONFIG_BRCM_TRACING */

