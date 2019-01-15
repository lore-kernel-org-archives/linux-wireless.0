Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899D1C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6599D20657
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbfAON1C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 08:27:02 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56740 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbfAON1C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 08:27:02 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gjOk6-0007n9-Ih; Tue, 15 Jan 2019 14:26:58 +0100
Message-ID: <42e2c59c035142597f00038b8a67f13a9fb40292.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Authentication offload to user space in AP
 mode
From:   Johannes Berg <johannes@sipsolutions.net>
To:     dasaris@codeaurora.org,
        "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 15 Jan 2019 14:26:56 +0100
In-Reply-To: <7bfaa41538350a2b385b14b00bb0444e@codeaurora.org>
References: <1544779909-27758-1-git-send-email-dasaris@codeaurora.org>
         (sfid-20181214_103219_686121_BC072990) <dd3263b2b3f0850a26b316f9e8cb0cba81dc97c7.camel@sipsolutions.net>
         <B2CD83211F5FDD478D7EFFF030D107EDCD031EAB@HASMSX111.ger.corp.intel.com>
         <7bfaa41538350a2b385b14b00bb0444e@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-12-20 at 16:37 +0530, dasaris@codeaurora.org wrote:
> On 2018-12-18 19:10, Otcheretianski, Andrei wrote:
> > > So, interesting - Andrei also added the PMKID but also the PMK here, 
> > > in a
> > > separate patch:
> > > https://patchwork.kernel.org/patch/10732093/
> > 
> > Yeah, PMK is needed for the devices that offload 4way handshake.
> 
> Thanks. Fine with us too. Will have an updated patchset with the pmkid 
> part removed, as this is already added with the patch by Andrei.

Well, we're still discussing the whole thing :)

You can add the PMKID here as well, and then Andrei just has to rebase
accordingly?

> > > > [...]
> > > > -	if (!info->attrs[NL80211_ATTR_SSID])
> > > > +	if (!info->attrs[NL80211_ATTR_SSID] &&
> > > > +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
> > > > +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
> > > > +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
> > > >  		return -EINVAL;
> > > 
> > > Hm. do we really expect this on AP_VLAN?
> > 
> > Actually I'm not sure about GO neither. P2P doesn't use SAE etc..
> > 
> > Andrei
> 
> Since these vifs are similar to an AP, we have considered external 
> authentication to be applicable for them as well. Please let me know if 
> this is fine . I shall update the patch accordingly.

Sure, I think it's fine. Even if P2P right now doesn't actually
specify/use WPA3/SAE we can still support it, right?

My question was really more about AP_VLAN, because I was expecting the
handshake to still happen on the AP interface, not on the AP_VLAN?

johannes

