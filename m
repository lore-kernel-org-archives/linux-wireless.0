Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B582C64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 10:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C4862075C
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 10:05:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C4862075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbeJIRVw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 13:21:52 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:50750 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbeJIRVv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 13:21:51 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9otY-0001NR-U5; Tue, 09 Oct 2018 12:05:41 +0200
Message-ID: <1539079529.3687.107.camel@sipsolutions.net>
Subject: Re: [PATCH 02/19] wilc: add coreconfigurator.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        venkateswara.kaja@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Date:   Tue, 09 Oct 2018 12:05:29 +0200
In-Reply-To: <99c3417a-7e7b-ed55-6ab4-66bf56b4c449@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-3-git-send-email-ajay.kathat@microchip.com>
         <1539008207.3687.53.camel@sipsolutions.net>
         <99c3417a-7e7b-ed55-6ab4-66bf56b4c449@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-09 at 15:12 +0530, Ajay Singh wrote:

> > > +static inline enum sub_frame_type get_sub_type(u8 *header)
> > > +{
> > > +	return ((enum sub_frame_type)(header[0] & 0xFC));
> > > +}
> > 
> > remove, use include/linux/ieee80211.h.
> > 
> 
> Did you mean to use '& IEEE80211_FCTL_STYPE' to get the frame sub type,
> instead of adding this API.

Perhaps, but I suspect you can do mostly with ieee80211_is_probe_resp()
and friends.

> > > +static inline u8 get_to_ds(u8 *header)
> > > +{
> > > +	return (header[1] & 0x01);
> > > +}
> > > +
> > > +static inline u8 get_from_ds(u8 *header)
> > > +{
> > > +	return ((header[1] & 0x02) >> 1);
> > > +}
> > 
> > dito
> > 
> 
> Ack.  

For this you have ieee80211_has_tods()/_fromds()/_a4() instead.

johannes
