Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B52C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 11:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B65320684
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 11:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfCHL0k (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 06:26:40 -0500
Received: from mga17.intel.com ([192.55.52.151]:34398 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfCHL0k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 06:26:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Mar 2019 03:26:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,455,1544515200"; 
   d="scan'208";a="140236648"
Received: from kphartnx-mobl1.ger.corp.intel.com ([10.252.28.244])
  by orsmga002.jf.intel.com with ESMTP; 08 Mar 2019 03:26:38 -0800
Message-ID: <c2962648d413efe4c8f08499707f15c6c9bde2a3.camel@intel.com>
Subject: Re: [PATCH v2] cfg80211: Include the PMK and PMKID in
 NL80211_CMD_EXTERNAL_AUTH
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date:   Fri, 08 Mar 2019 13:26:37 +0200
In-Reply-To: <b4a8237564db96d0be471ea93bf32e321adf6d72.camel@sipsolutions.net>
References: <ffc4c9e611784b1367e187d092b846381a4cfdc0.camel@sipsolutions.net>
         <20190206080234.15750-1-luca@coelho.fi>
         <b4a8237564db96d0be471ea93bf32e321adf6d72.camel@sipsolutions.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-02-22 at 13:41 +0100, Johannes Berg wrote:
> > +++ b/net/wireless/nl80211.c
> > @@ -13098,6 +13098,12 @@ static int nl80211_external_auth(struct
> > sk_buff *skb, struct genl_info *info)
> >  	if (!info->attrs[NL80211_ATTR_STATUS_CODE])
> >  		return -EINVAL;
> >  
> > +	if ((info->attrs[NL80211_ATTR_PMK] &&
> > +	     !info->attrs[NL80211_ATTR_PMKID]) ||
> > +	    (info->attrs[NL80211_ATTR_PMKID] &&
> > +	     !info->attrs[NL80211_ATTR_PMK]))
> > +		return -EINVAL;
> 
> This constitutes a netlink API change, so no, can't be right? PMKID
> was
> perfectly reasonable to pass by itself before.

Good point.  Andrei, can you fix this? This can easily be changed to
accept PMKID alone but still do what you want when both are included.

--
Luca.

