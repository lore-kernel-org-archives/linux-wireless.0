Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C95BDC64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 10:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 833ED21479
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 10:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 833ED21479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbeJIRwt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 13:52:49 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51360 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbeJIRwt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 13:52:49 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9pNO-0001r1-PL; Tue, 09 Oct 2018 12:36:30 +0200
Message-ID: <1539081379.3687.112.camel@sipsolutions.net>
Subject: Re: [PATCH 03/19] wilc: add host_interface.h
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        venkateswara.kaja@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Date:   Tue, 09 Oct 2018 12:36:19 +0200
In-Reply-To: <f4ab9830-7892-a062-48c4-5c5c64b5caa0@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-4-git-send-email-ajay.kathat@microchip.com>
         <1539008417.3687.57.camel@sipsolutions.net>
         <f4ab9830-7892-a062-48c4-5c5c64b5caa0@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-09 at 16:04 +0530, Ajay Singh wrote:

> > > +typedef void (*wilc_remain_on_chan_expired)(void *, u32);
> > > +typedef void (*wilc_remain_on_chan_ready)(void *);

> I think as per coding style the typedef for function pointer are allowed.

True, I guess, but why do you need them?

> > > +struct rcvd_net_info {
> > > +	u8 *buffer;
> > > +	u32 len;
> > > +};
> > > +
> > > +struct hidden_net_info {
> > > +	u8  *ssid;
> > > +	u8 ssid_len;
> > > +};
> > > +
> > > +struct hidden_network {
> > > +	struct hidden_net_info *net_info;
> > > +	u8 n_ssids;
> > > +};
> > 
> > This seems really odd - what part doesn't cfg80211 already handle?
> 
> If I understood your question correctly,  you meant what extra
> functionality 'hidden_network' struct is providing.

Pretty much. It seems like you're trying to handle hidden SSIDs in some
way, but ... that's odd.

> Actually this structure is just used to keeps list of SSID's requested
> in cfg80211 'scan' callback which is passed to firmware. The values are
> extracted from 'cfg80211_scan_request[struct cfg80211_ssid *ssids 
> -----  int n_ssids] received during scan.

So then this has nothing to do with hidden SSID?

johannes
