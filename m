Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48948 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbZHLVx0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 17:53:26 -0400
Subject: Re: [PATCH 16/16] iwlwifi: disable powersave mode
From: reinette chatre <reinette.chatre@intel.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <87k518kgmm.fsf@litku.valot.fi>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
	 <1249684912-22936-17-git-send-email-reinette.chatre@intel.com>
	 <878whun256.fsf@litku.valot.fi> <1249760168.30019.5588.camel@rc-desk>
	 <87k518kgmm.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 14:53:26 -0700
Message-Id: <1250114006.30019.6030.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-08-12 at 11:54 -0700, Kalle Valo wrote:
> reinette chatre <reinette.chatre@intel.com> writes:

> >> You are again creating driver specific parameters. But we should be
> >> moving away from this and instead use just generic interfaces. Please,
> >> think three times (or even more) whenever creating new driver specific
> >> interfaces, be it module parameters, sysfs files etc.. It's a
> >> maintenance nightmare and also very confusing for the users. We need to
> >> focus on nl80211 and make it work properly with all drivers.
> >
> > What we have done here is not intended to be maintained at all - this is
> > why the module parameter description reads "power save support
> > (deprecated) (default disabled)" - it is deprecated from the beginning.
> 
> Yes, I understand this. But creating a new module parameters should be
> added carefully only when really needed, just to avoid confusion within
> users. And it sounds wrong to create a new variable which is deprecated
> from the beginning. If it needs to be deprecated, don't create it at
> all. Simple as that.
> 
> What I'm worried is the complexity of the driver interfaces and
> configuration methods. For iwlwifi power save, after this patch, we have
> now:
> 
> o Wireless Extensions
> o sysfs
> o CONFIG_CFG80211_DEFAULT_PS Kconfig parameter

We could not see how any of the current measures can be used to
accomplish out goal. Fortunately Johannes implemented something that now
can be used to accomplish this.

John, could you please revert this patch? Johannes's new "cfg80211:
allow driver to override PS default" makes it possible for us to have
power save support disabled.

Thank you very much

Reinette


