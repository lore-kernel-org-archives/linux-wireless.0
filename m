Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0163.hostedemail.com ([216.40.44.163]:33865 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751824AbcDVWS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2016 18:18:26 -0400
Message-ID: <1461363503.2726.17.camel@perches.com> (sfid-20160423_001837_447142_F0A06D9A)
Subject: Re: Debug prints mac80211 drivers
From: Joe Perches <joe@perches.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 22 Apr 2016 15:18:23 -0700
In-Reply-To: <CABPxzYJOAFq4hrSpZkx_bmvsUGhR0PmsUvjbnw=ykUeHAVXYqw@mail.gmail.com>
References: <CABPxzYLZ2thNWCQ6bQ0-Peic-X-FTpTv4wJxyXVdmBDQDRS8JA@mail.gmail.com>
	 <1461353341.2726.14.camel@perches.com>
	 <CABPxzYJOAFq4hrSpZkx_bmvsUGhR0PmsUvjbnw=ykUeHAVXYqw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-04-23 at 02:32 +0530, Krishna Chaitanya wrote:
> On Sat, Apr 23, 2016 at 12:59 AM, Joe Perches <joe@perches.com> wrote:
> > 
> > 
> > On Fri, 2016-04-22 at 17:51 +0530, Krishna Chaitanya wrote:
> > > 
> > > What is the recommended method for adding
> > > debug prints in mac80211 based drivers.
> > > 
> > > 1) -DDEBUG + pr_debug ==> used by mac80211, brcm80211
> > > 2) -DDEBUG + dev_dbg ==> zd1201
> > > 3) dev_printk(KERN_DEBUG) ==> used by iwlwifi
> > > 4) printk(KERN_DEBUG) ==> Just to complete the list.
> > wiphy_dbg -> netif_dbg -> netdev_dbg -> dev_dbg -> pr_debug
> Ok, thats what checpatch --strict throws. but still different vendors
> follow
> different standards, so wanted to check if we should go strictly with
> checkpatch (or) is there any rationale behind choose each of the
> variant.

Generally the variants are used to produce sufficient
logging information to identify the appropriate device.

Most all debugging printks shouldn't be emitted unless
actually debugging.

> > and CONFIG_DYNAMIC_DEBUG, no -DDEBUG required
> Yes, i understand. Till now we had this enabled, so pr_debug
> works just fine, but now it is disabled hence the question.
> 
> Also there are pros and cons to having control using dyndbg,
> user can disable dyndbg, there be missing imp

imp?

>  debugs, in this case
> having module level (-DDEBUG) helps but if we want entire system
> to run in non-debug mode, disabling dyndbg helps.

Confused:

dynamic debug printks aren't emitted by default
unless DEBUG is also defined or specifically
enabled by the user.

