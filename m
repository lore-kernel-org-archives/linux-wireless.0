Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86FBC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 10:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B415620684
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 10:15:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B415620684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbeJAQwM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 12:52:12 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56956 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbeJAQwM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 12:52:12 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g6vEH-0002TC-4h; Mon, 01 Oct 2018 12:15:05 +0200
Message-ID: <1538388895.3126.26.camel@sipsolutions.net>
Subject: Re: [PATCH v5 2/3] mac80211: support FTM responder
 configuration/statistics
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Date:   Mon, 01 Oct 2018 12:14:55 +0200
In-Reply-To: <1537489811-5752-3-git-send-email-pradeepc@codeaurora.org>
References: <1537489811-5752-1-git-send-email-pradeepc@codeaurora.org>
         <1537489811-5752-3-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-09-20 at 17:30 -0700, Pradeep Kumar Chitrapu wrote:
> New bss param ftm_responder is used to notify the driver to
> enable fine timing request (FTM) responder role in AP mode.
> 
> Plumb the new cfg80211 API for FTM responder statistics through to
> the driver API in mac80211.

This patch also doesn't apply right now, please rebase & add the struct
as previously pointed out. That also affects the driver, perhaps, so
please resend that as well.

> +	if (params->ftm_responder != -1) {
> +		sdata->vif.bss_conf.ftm_responder = params->ftm_responder;
> +		err = ieee80211_set_ftm_responder_params(sdata,
> +							 params->lci,
> +							 params->lci_len,
> +							 params->civicloc,
> +							 params->civicloc_len);
> +
> +		if (err < 0)
> +			return err;
> +
> +		changed |= BSS_CHANGED_FTM_RESPONDER;
> +	} else {
> +		sdata->vif.bss_conf.ftm_responder = -1;
> +	}

This seems wrong - you should remove the else branch entirely, afaict?

I think you may also be missing some freeing of the ftm_responder_params
in the end if it didn't get disabled again, but the interface is
removed?

johannes
