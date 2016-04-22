Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:35356 "EHLO
	mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbcDVVCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2016 17:02:44 -0400
Received: by mail-yw0-f171.google.com with SMTP id g133so118908859ywb.2
        for <linux-wireless@vger.kernel.org>; Fri, 22 Apr 2016 14:02:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461353341.2726.14.camel@perches.com>
References: <CABPxzYLZ2thNWCQ6bQ0-Peic-X-FTpTv4wJxyXVdmBDQDRS8JA@mail.gmail.com>
 <1461353341.2726.14.camel@perches.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sat, 23 Apr 2016 02:32:24 +0530
Message-ID: <CABPxzYJOAFq4hrSpZkx_bmvsUGhR0PmsUvjbnw=ykUeHAVXYqw@mail.gmail.com> (sfid-20160422_230247_878203_1830F9C2)
Subject: Re: Debug prints mac80211 drivers
To: Joe Perches <joe@perches.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 23, 2016 at 12:59 AM, Joe Perches <joe@perches.com> wrote:
>
> On Fri, 2016-04-22 at 17:51 +0530, Krishna Chaitanya wrote:
> > What is the recommended method for adding
> > debug prints in mac80211 based drivers.
> >
> > 1) -DDEBUG + pr_debug ==> used by mac80211, brcm80211
> > 2) -DDEBUG + dev_dbg ==> zd1201
> > 3) dev_printk(KERN_DEBUG) ==> used by iwlwifi
> > 4) printk(KERN_DEBUG) ==> Just to complete the list.
>
> wiphy_dbg -> netif_dbg -> netdev_dbg -> dev_dbg -> pr_debug
Ok, thats what checpatch --strict throws. but still different vendors follow
different standards, so wanted to check if we should go strictly with
checkpatch (or) is there any rationale behind choose each of the variant.

> and CONFIG_DYNAMIC_DEBUG, no -DDEBUG required
Yes, i understand. Till now we had this enabled, so pr_debug
works just fine, but now it is disabled hence the question.

Also there are pros and cons to having control using dyndbg,
user can disable dyndbg, there be missing imp debugs, in this case
having module level (-DDEBUG) helps but if we want entire system
to run in non-debug mode, disabling dyndbg helps.
