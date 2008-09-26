Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:50771 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYIZCpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 22:45:09 -0400
Received: by nf-out-0910.google.com with SMTP id d3so293069nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 19:45:08 -0700 (PDT)
Message-ID: <f488382f0809251945u3eb1f0bdgfe8587e8c103b009@mail.gmail.com> (sfid-20080926_044514_952919_9664740C)
Date: Thu, 25 Sep 2008 19:45:07 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC V3] mac80211: re-enable aggregation on 2.6.27
Cc: "Tomas Winkler" <tomas.winkler@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"yi.zhu@intel.com" <yi.zhu@intel.com>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20080926015100.GR6204@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222371297-24498-1-git-send-email-tomas.winkler@intel.com>
	 <f488382f0809251243x472ff579n8ada22e8f7110aae@mail.gmail.com>
	 <20080926015100.GR6204@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 6:51 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
>> I seem to recall that implementing aggregation was causing issues with
>> ath9k
>
> Just ath9k, there are only two aggregation capable drivers in the
> kernel right now, Intel's iwlagn and ath9k. Intel's worked just fine
> in my tests.

Ah, I see.

>> among others (in particular, ath9k was getting slow throughput).
>
> Yes, but it seems this is a general throughput issue now, not just
> related to aggregation. We have been working hard on trying to find
> what the cause to the throughput issue is.
>

I'll keep watching linux-kernel, linux-wireless, ath9k-devel, etc for
updates on this. :)

>> How's throughput with this version of the aggregation patch?
>
> Please test and let us know, try HT40 on 11a. We're keen on resolving
> this just as with the MIB interrupt issue you say ;)

Will do. It will have to wait until Monday though, because I stupidly
left my AirPort Extreme router's AC adapter at home (3 hours away).

> BTW you need more than this patch to get aggregation working. Below
> are the patches you'll need on top of 2.6.27-rc7 to get aggregation
> working (and your MIB interrupt storm fixed) with ath9k:
>
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath9k/2008-09-25

The interrupt storm is gone in Linus' master branch (the patch in
question got merged today or yesterday, it seems). I'll grab the
aggregation patches and start playing with them.

- Steven
