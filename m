Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11FEC64EB0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 20:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89D812085B
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 20:57:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89D812085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727596AbeJJEPy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 00:15:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:8904 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725748AbeJJEPy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 00:15:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2018 13:57:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,361,1534834800"; 
   d="scan'208";a="97556438"
Received: from jprestwo.jf.intel.com ([10.54.74.38])
  by fmsmga001.fm.intel.com with ESMTP; 09 Oct 2018 13:57:07 -0700
Message-ID: <3ad2f173861bf6b3f6b5c87616561bdd352cdc2e.camel@linux.intel.com>
Subject: Re: [PATCH] mac80211_hwsim: allow setting custom features/iftypes
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Date:   Tue, 09 Oct 2018 14:00:51 -0700
In-Reply-To: <1539118073.3687.153.camel@sipsolutions.net>
References: <20181009174829.15163-1-james.prestwood@linux.intel.com>
         (sfid-20181009_194449_357742_49BD7697) <1539114071.3687.134.camel@sipsolutions.net>
         <0b8356b90053c16e674905ca78707d6a19de0701.camel@linux.intel.com>
         <1539116037.3687.143.camel@sipsolutions.net>
         <926a1d1e65f089767b9316fecc619ef4c70fa008.camel@linux.intel.com>
         <1539118073.3687.153.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.1-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-09 at 22:47 +0200, Johannes Berg wrote:
> On Tue, 2018-10-09 at 13:42 -0700, James Prestwood wrote:
> 
> > > In general, I guess what would work is to be able to *restrict*
> > > the
> > > advertised features over what's currently the case, but I suspect
> > > that's not something that would be so very much useful for you
> > > (unless we
> > > also add more features to hwsim).
> > 
> > Actually this would work perfectly. Just being able to
> > disable/restrict
> > features will work fine. I can change the attribute to take a mask
> > of
> > disabled/enabled features, but only features that hwsim actually
> > supports.
> 
> Well I guess you really only need *disabled* ones since the default
> would remain to have all enabled, and you can't change them on the
> fly,
> only set them at radio creation, right?

Yes, disabling features is really what we needed ultimately. And
changing them on the fly is not needed.

> 
> > The reason I did it this way was to follow how NL80211 packaged up
> > iftype support (NL80211_ATTR_SUPPORTED_IFTYPES).
> 
> Ok, but I still think a bitmap would make more sense, back then for
> some
> reason I/we didn't (like to) do bitmaps, but these days I think it's
> the
> much better representation.
> 
> > We could model this
> > after how we want the feature support, where we only allow
> > disabling/enabling features/iftypes that are already supported in
> > the
> > default configuration. So, for iftypes, my code could remain the
> > same
> > where I build up a mask of iftypes, but then AND that with a the
> > default configuration.
> 
> Sort of.
> 
> Yes, I think we would want to have a list/mask of *enabled*
> (extended)
> features/interface types, unlike what I said above to just have a
> mask
> of disabled features; if we do a mask of disabled ones then one
> basically has to list all current and *future ones* to have
> predictable
> output, that's not going to be feasible.
> 
> So yes, we want a list of *enabled* ones.
> 
> However, I think we want to reject configurations that list more
> enabled
> features than we currently support, because otherwise again you end
> up
> with unpredictability if the hwsim version changes underneath your
> tool
> or test case.

Ok, yeah this makes sense.

> 
> So I think the algorithm should be:
> 
> valid_features = <current list>;
> enabled_features = nla_get_whatever(...);
> 
> if (enabled_features & ~valid_features) {
> 	NL_SET_ERR_ATTR_MSG(...);
> 	return -EINVAL;
> }
> 
> // use enabled_features instead of the current list later


Ok, thanks for your help/suggestions. Ill get a patch together with the
talked about changes.

> 
> johannes
