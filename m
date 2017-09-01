Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46668 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750878AbdIAFhZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 01:37:25 -0400
Message-ID: <1504244238.31031.24.camel@coelho.fi> (sfid-20170901_073851_169798_BEE3FB04)
From: Luca Coelho <luca@coelho.fi>
To: Joe Perches <joe@perches.com>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>
Date: Fri, 01 Sep 2017 08:37:18 +0300
In-Reply-To: <1504216665.2786.48.camel@perches.com>
References: <20170825082730.31388-1-luca@coelho.fi>
         <20170825082730.31388-2-luca@coelho.fi>
         <1504216665.2786.48.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 1/2] iwlwifi: fix long debug print
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-08-31 at 14:57 -0700, Joe Perches wrote:
> On Fri, 2017-08-25 at 11:27 +0300, Luca Coelho wrote:
> > From: Liad Kaufman <liad.kaufman@intel.com>
> > 
> > There is a debug print that sometimes reaches over
> > 110 chars, thus generating a warning in those cases.
> 
> What emits a warning here?

We have a WARN_ON in iwl-devtrace-msg.h:

#define MAX_MSG_LEN	110

DECLARE_EVENT_CLASS(iwlwifi_msg_event,
	TP_PROTO(struct va_format *vaf),
	TP_ARGS(vaf),
	TP_STRUCT__entry(
		__dynamic_array(char, msg, MAX_MSG_LEN)
	),
	TP_fast_assign(
		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
				       MAX_MSG_LEN, vaf->fmt,
				       *vaf->va) >= MAX_MSG_LEN);
	),
	TP_printk("%s", __get_str(msg))
);

We limit all our tracing messages to 110 bytes.  Anything longer than
that starts getting annoying to read.  In mac80211 we limit it even
further, to 100 bytes, so this is not unique to the iwlwifi driver.

--
Cheers,
Luca.
