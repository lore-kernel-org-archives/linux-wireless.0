Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E23C2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 19:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 371062080A
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 19:59:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 371062080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbeJ3Et2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 00:49:28 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47018 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbeJ3Et2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 00:49:28 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gHDgy-00037w-3q; Mon, 29 Oct 2018 20:59:16 +0100
Message-ID: <3025909cb6950d7b8b30b4b659b3676df164e3d0.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: support FTM responder configuration/statistics
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Date:   Mon, 29 Oct 2018 20:58:53 +0100
In-Reply-To: <03f51a115f6d71923c3212af25c470d3@codeaurora.org>
References: <1538623160-25886-1-git-send-email-pradeepc@codeaurora.org>
         (sfid-20181004_051935_494006_E9A4C858) <c832f9007e0a844d3335a0cd9996818f49df2311.camel@sipsolutions.net>
         <765cbdd596e96b7cf73239a4e04b06a7@codeaurora.org>
         <389c2e4819c83330a3b652f2a45ff024ec94cd2c.camel@sipsolutions.net>
         <03f51a115f6d71923c3212af25c470d3@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-10-29 at 11:59 -0700, Pradeep Kumar Chitrapu wrote:
> >  	memset(&params, 0, sizeof(params));
> > +	params.beacon_csa.ftm_responder = -1;
> 
> Hi Johannes,
> 
> Agree with the rest, however, I think this may not be needed because 
> ftm_responder is already being set to -1,
> if NL80211_ATTR_FTM_RESPONDER attribute is not included, in 
> nl80211_parse_beacon, which will be called from
> nl80211_channel_switch. Please let me know if I may have missed 
> something..
> 
>          if (attrs[NL80211_ATTR_FTM_RESPONDER]) {
> 
>          } else {
>                  bcn->ftm_responder = -1;
>          }
> 

Yes, but we may not get there?

        if (!need_new_beacon)
                goto skip_beacons;

        err = nl80211_parse_beacon(rdev, info->attrs, &params.beacon_after);
[...]
skip_beacons:
[...]
	err = rdev_channel_switch(rdev, dev, &params);


johannes

