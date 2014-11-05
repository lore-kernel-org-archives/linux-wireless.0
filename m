Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:44655 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaKEJnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 04:43:04 -0500
Date: Wed, 5 Nov 2014 15:14:39 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Michal Kazior" <michal.kazior@tieto.com>
Subject: Re: [PATCH v2] ath10k: handle ieee80211 header and payload tracing
 separately
Message-ID: <20141105094437.GA21839@qca.qualcomm.com> (sfid-20141105_104310_542370_58A02806)
References: <1414661336-20764-1-git-send-email-rmanohar@qti.qualcomm.com>
 <874muf7t9u.fsf@kamboji.qca.qualcomm.com>
 <20141104051643.GA14509@qca.qualcomm.com>
 <87k33a1lli.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87k33a1lli.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 05, 2014 at 03:29:13AM +0200, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
> > On Tue, Nov 04, 2014 at 01:34:37AM +0200, Kalle Valo wrote:
> >> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> >> 
> >> > -DECLARE_EVENT_CLASS(ath10k_data_event,
> >> > +#define ATH10K_FRM_HDR_LEN  \
> >> > +	ieee80211_hdrlen(((struct ieee80211_hdr *)data)->frame_control)
> >> 
> >> This macro does not look good. I would recommend to follow what Johannes
> >> suggested:
> >>
> >
> > v2 does the same. tracing functions just take ar, skb->data and skb->len.
> > header check is handled inside tracing funtions.
> >
> > I do not understand your concerns. :(
> 
> Sorry, I was confusing. I meant that wouldn't it be better to pass the
> skb pointer instead of skb-data and skb->len? I understood that was what
> Johannes suggested.
> 
> But ATH10K_FRM_HDR_LEN is the problem. To simplify this, what if you
> just always send the first 30 bytes (or whatever would be the max header
> length)? Also should you check that skb->len is at least the length
> defined by ieee80211_hdrlen()?
>
The goal of header & payload split is to reduce the amount of data being
collected. Sending maximum header size always will unnecessarily
increase the trace.dat size as hdr_size for mgmt and beacon always be 24.
This will also increase tracing traffic when it is being collected in
remote machine.

since tracepoints are being called only after the preprocessing,
skb->len never be lesser than 802.11 header size.

The macro is defined to ease readability and reduce # of line changes.
I originally thought of naming the macro as IEEE80211_HDR_LEN. But such
definition does not look correct inside driver.

-Rajkumar
