Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36642 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbZBTGMu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 01:12:50 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2009 22:12:50 -0800
Date: Thu, 19 Feb 2009 22:12:03 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Tony Vroon <tony@linx.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>
Subject: Re: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
	ranges
Message-ID: <20090220061203.GK4740@tesla> (sfid-20090220_071254_303149_2E11B621)
References: <1234208152.6694.4.camel@localhost> <20090210013941.GA4386@tesla> <1234230689.3793.15.camel@localhost> <20090210020708.GC4386@tesla> <1234379981.4789.7.camel@localhost> <20090214045232.GA5769@tesla> <1234786124.4271.2.camel@localhost> <20090216154733.GA2870@tuxdriver.com> <20090217184230.GA4257@tesla> <20090217190646.GC4257@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090217190646.GC4257@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 17, 2009 at 11:06:46AM -0800, Luis Rodriguez wrote:
> On Tue, Feb 17, 2009 at 10:42:30AM -0800, Luis Rodriguez wrote:
> > On Mon, Feb 16, 2009 at 07:47:33AM -0800, John W. Linville wrote:
> > > On Mon, Feb 16, 2009 at 12:08:44PM +0000, Tony Vroon wrote:
> > > > Just to confirm, if I use my early-boot hook that I used for your iw
> > > > list to set the regulatory domain manually (iw reg set GB) all is well.
> > > > If I allow the driver stack to get to the association stage without
> > > > setting a regulatory domain, I can never get my 802.11A spectrum back
> > > > after the fact.
> > > > Would you still see this as a bug or rather a specific requirement of
> > > > the new interface that hasn't yet been documented?
> > >
> > > Seems like a bug, or at least an unintended consequence of intersection...?
> 
> Sorry for the blank e-mail.
> 
> You are reporting you are disabling OLD_REG and your 5 GHz on iwlagn is disabled
> upon bootup. You also reported from your log:
> 
> cfg80211: Calling CRDA to update world regulatory domain
> cfg80211: calling CRDA failed - unable to update world regulatory domain, using static definition
> 
> This indicates to me your regulatory domain was simply never updated by CRDA. So what
> would have happened is that iwlagn registers its device to mac80211 via ieee80211_register_hw()
> then mac80211 registers it with cfg80211 via wiphy_register(). Upon that call cfg80211 will update
> the device's regulatory ifnromation by calling
> 
> wiphy_update_regulatory(wiphy, REGDOM_SET_BY_CORE);
> 
> This in turn will check to see if it should ignore the request, and in your case
> the check is:
> 
>         if (!last_request)
>                 return true;
>         if (setby == REGDOM_SET_BY_CORE &&
>                   wiphy->custom_regulatory)
>                 return true
> 
> Since iwlagn sets wiphy->custom_regulatory to true and since upon registration setby is
> REGDOM_SET_BY_CORE the device will be ignored to change the regulatory domain. I see I
> currently see no reason why your 5 GHz channels will be disabled unless I'm missing
> something or the card's EEPROM disables them.
> 
> To debug this further we need more information. So please provide the output of both
> the kernel *and*, 'iw list' _prior_ to associating to your AP. Before you do so please
> recompile wireless-testing with these options enabled:
> 
> # Intel debug
> CONFIG_IWL_DEBUG_INFO=y
> 
> # Cfg80211 regulatory debug
> CONFIG_CFG80211_REG_DEBUG=y
> 
> So to re-iterate: I want both your kernel log _and_ 'iw list' output prior to association.

To help isolate that orthogonal issue about having the udev rule not being
created you can also test the new patch series I just posted and enable REG_DEBUG,
this will give us a trace and hopefully we can see if call_usermodehelper() was
the one that failed during early boot.

http://marc.info/?l=linux-wireless&m=123510990625914&w=2

  Luis
