Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF29C64EB0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 20:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66505213A2
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 20:38:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66505213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbeJJD5h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 23:57:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:48521 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbeJJD5h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 23:57:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2018 13:38:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,361,1534834800"; 
   d="scan'208";a="87040762"
Received: from jprestwo.jf.intel.com ([10.54.74.38])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Oct 2018 13:38:31 -0700
Message-ID: <926a1d1e65f089767b9316fecc619ef4c70fa008.camel@linux.intel.com>
Subject: Re: [PATCH] mac80211_hwsim: allow setting custom features/iftypes
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Date:   Tue, 09 Oct 2018 13:42:16 -0700
In-Reply-To: <1539116037.3687.143.camel@sipsolutions.net>
References: <20181009174829.15163-1-james.prestwood@linux.intel.com>
         (sfid-20181009_194449_357742_49BD7697) <1539114071.3687.134.camel@sipsolutions.net>
         <0b8356b90053c16e674905ca78707d6a19de0701.camel@linux.intel.com>
         <1539116037.3687.143.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.1-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-09 at 22:13 +0200, Johannes Berg wrote:
> On Tue, 2018-10-09 at 13:12 -0700, James Prestwood wrote:
> 
> > Ok, that makes sense. The intent here was to test logic for
> > detecting
> > and handling supported driver features/iftypes, rather than
> > actually
> > using the features. But I do understand it would be strange for
> > anyone
> > trying to enable a feature, to find that all it does it set a
> > feature
> > bit (although this is exactly what we want :)).
> 
> :-)
> 
> In general, I guess what would work is to be able to *restrict* the
> advertised features over what's currently the case, but I suspect
> that's
> not something that would be so very much useful for you (unless we
> also
> add more features to hwsim).

Actually this would work perfectly. Just being able to disable/restrict
features will work fine. I can change the attribute to take a mask of
disabled/enabled features, but only features that hwsim actually
supports.

> 
> > Would it be acceptable
> > (for now at least) if we just included the iftype piece? I can pull
> > that out into a new patch if so.
> 
> As written, it doesn't make much sense, but again you could restrict
> the
> feature set? There are also the pure software feature types etc., and
> mac80211 will add those in some cases.
> 
> Similar to the features though, you wouldn't want to advertise e.g.
> NAN
> over hwsim, since that requires special operations to be implemented.
> 
> I guess here also I could see perhaps a way to restrict the interface
> types could be worthwhile?
> 
> Though I'd do the implementation with a single u32 attribute with a
> bitmap, rather than the massive nested flags. Which, btw, you
> should've
> used the nested policy support for that I added recently in commit
> 9a659a35ba17 ("netlink: allow NLA_NESTED to specify nested policy to
> validate"), but that point is of course moot if we don't want to do a
> nested attribute :-)

The reason I did it this way was to follow how NL80211 packaged up
iftype support (NL80211_ATTR_SUPPORTED_IFTYPES). We could model this
after how we want the feature support, where we only allow
disabling/enabling features/iftypes that are already supported in the
default configuration. So, for iftypes, my code could remain the same
where I build up a mask of iftypes, but then AND that with a the
default configuration.

Thanks,
James

> 
> johannes
