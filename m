Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4890AC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 07:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0517520835
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 07:03:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0517520835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbeJKO3N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 10:29:13 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53706 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbeJKO3N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 10:29:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAV09-0004TX-Jg; Thu, 11 Oct 2018 09:03:17 +0200
Message-ID: <1539241383.3687.191.camel@sipsolutions.net>
Subject: Re: [PATCH 13/19] wilc: add linux_wlan.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        venkateswara.kaja@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Date:   Thu, 11 Oct 2018 09:03:03 +0200
In-Reply-To: <45c17836-9362-d2ef-9647-514b5c75ec93@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-14-git-send-email-ajay.kathat@microchip.com>
         <1539009674.3687.75.camel@sipsolutions.net>
         <45c17836-9362-d2ef-9647-514b5c75ec93@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-10-11 at 12:30 +0530, Ajay Singh wrote:
> 
> > > +	if (queue_count > FLOW_CONTROL_UPPER_THRESHOLD) {
> > > +		netif_stop_queue(wilc->vif[0]->ndev);
> > > +		netif_stop_queue(wilc->vif[1]->ndev);
> > > +	}
> > 
> > It seems like a pretty bad idea to hard-code two interfaces, we do
> > dynamic addition/removal these days, in *particular* for P2P.
> > 
> 
> Did you mean it not good to call stop queue for both the interfaces.
> Can you please provide some more details about this comments.

No, I mean you should be more dynamic and have e.g. a list of interfaces
(actually, you can use cfg80211's list, I believe!), instead of hard-
coding that you have "wlan0" and "p2p0".

johannes
