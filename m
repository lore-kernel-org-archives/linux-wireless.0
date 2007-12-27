Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW2.Sony.CO.JP ([137.153.0.14]:57759 "EHLO mgw2.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbXL0Itu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2007 03:49:50 -0500
Date: Thu, 27 Dec 2007 17:51:49 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: David Miller <davem@davemloft.net>
Subject: Re: : Emit event stream compat iw_point objects correctly.
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20071221.205808.213484078.davem@davemloft.net>
References: <20071221.205808.213484078.davem@davemloft.net>
Message-Id: <20071227173802.6F56.40F06B3A@sm.sony.co.jp> (sfid-20071227_085053_950285_3A59DA27)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi

On Fri, 21 Dec 2007 20:58:08 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> @@ -520,7 +530,7 @@ iwe_stream_add_point(char *	stream,		/* Stream of events */
>  		memcpy(stream + IW_EV_LCP_LEN,
>  		       ((char *) iwe) + IW_EV_LCP_LEN + IW_EV_POINT_OFF,
>  		       IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);

As the alignment of 64bit platforms may be defferent from 32bit one,
should it be like the following?

static inline char *
iwe_stream_add_point(char *	stream,		/* Stream of events */
		     char *	ends,		/* End of stream */
		     struct iw_event *iwe,	/* Payload length + flags */
		     char *	extra,		/* More payload */
		     struct iw_request_info *info)
{
	int	event_len = IW_EV_POINT_LEN + iwe->u.data.length;
	int	point_len = IW_EV_POINT_LEN;
	int	lcp_len = IW_EV_LCP_LEN;

#ifdef CONFIG_COMPAT
	if (info->flags & IW_REQUEST_FLAG_COMPAT) {
		event_len = IW_EV_COMPAT_POINT_LEN + iwe->u.data.length;
		point_len = IW_EV_COMPAT_POINT_LEN;
		lcp_len = IW_EV_COMPAT_LCP_LEN;
	}
#endif

	/* Check if it's possible */
	if(likely((stream + event_len) < ends)) {
		iwe->len = event_len;
		memcpy(stream, (char *) iwe, IW_EV_LCP_PK_LEN);
		memcpy(stream + lcp_len,
		       ((char *) iwe) + IW_EV_LCP_LEN + IW_EV_POINT_OFF,
		       IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
		memcpy(stream + point_len, extra, iwe->u.data.length);
		stream += event_len;
	}
	return stream;
}

(Note that IW_EV_COMPAT_LCP_LEN is just a example; not defined anywhere)

-- 
Masakazu MOKUNO

