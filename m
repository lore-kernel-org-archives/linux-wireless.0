Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:17924 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaKDFPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 00:15:01 -0500
Date: Tue, 4 Nov 2014 10:46:45 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: [PATCH v2] ath10k: handle ieee80211 header and payload tracing
 separately
Message-ID: <20141104051643.GA14509@qca.qualcomm.com> (sfid-20141104_061544_125836_322F2430)
References: <1414661336-20764-1-git-send-email-rmanohar@qti.qualcomm.com>
 <874muf7t9u.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <874muf7t9u.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 04, 2014 at 01:34:37AM +0200, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
> > For packet log, the transmitted frame 802.11 header alone is sufficient.
> > Recording entire packet is also consuming lot of disk space. To optimize
> > this, tx and rx data tracepoints are splitted into header and payload
> > tracepoints.
> >  
> > -DECLARE_EVENT_CLASS(ath10k_data_event,
> > +#define ATH10K_FRM_HDR_LEN  \
> > +	ieee80211_hdrlen(((struct ieee80211_hdr *)data)->frame_control)
> 
> This macro does not look good. I would recommend to follow what Johannes
> suggested:
>
> "It would be worth hiding that inside the tracepoint's assign function,
> so instead of passing data/len here you'd pass the full skb, or the full
> skb data/skb len, like this:
> 
> ar, skb->data, skb->len
> 
> to both tracers. Then inside the tracer you can do the hdrlen check, and
> that way move the code into the tracing so it's not hit when tracing is
> disabled."
v2 does the same. tracing functions just take ar, skb->data and skb->len.
header check is handled inside tracing funtions.

I do not understand your concerns. :(

-Rajkumar
