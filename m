Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53926 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbeHOPCK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 11:02:10 -0400
Message-ID: <1534334948.3547.39.camel@sipsolutions.net> (sfid-20180815_141018_271023_F3029EDD)
Subject: Re: [PATCH 1/3] nl80211: add support to configure FTM responder
 functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Aug 2018 14:09:08 +0200
In-Reply-To: <1534293018-4930-2-git-send-email-pradeepc@codeaurora.org>
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
         <1534293018-4930-2-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-14 at 17:30 -0700, Pradeep Kumar Chitrapu wrote:
> 
> +	int ftm_responder;

bool

> + * @NL80211_ATTR_FTM_RESPONDER: attribute which user-space can include in
> + *	%NL80211_CMD_START_AP to enable(1) or disable(0) fine timing measurement
> + *	(FTM) responder functionality.  If not set, it means don't care and
> + *	the device will decide what to use.

Why 0/1 instead of a flag attribute?

Also, I think you need the attributes (LCI/Civic location)?

johannes
