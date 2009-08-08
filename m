Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51509 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZHHTgH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 15:36:07 -0400
Subject: Re: [PATCH 16/16] iwlwifi: disable powersave mode
From: reinette chatre <reinette.chatre@intel.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <878whun256.fsf@litku.valot.fi>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
	 <1249684912-22936-17-git-send-email-reinette.chatre@intel.com>
	 <878whun256.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Sat, 08 Aug 2009 12:36:08 -0700
Message-Id: <1249760168.30019.5588.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Thank you for looking at our patches. You have great feedback.

On Sat, 2009-08-08 at 01:25 -0700, Kalle Valo wrote:
> Reinette Chatre <reinette.chatre@intel.com> writes:
> 
> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> >
> > The enabling of powersaving had a big impact on reliability and
> > performance. Throughput on n band suffered especially. With power save
> > support enabled we see significant ping response times, dropped frames, and
> > reduced throughput. These are captured in the following bug reports:
> >
> > http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2051
> > http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2053
> >
> > Disable power save by default, add "iwl_support_ps" module parameter
> > that can be used to enable it again.
> 
> You are again creating driver specific parameters. But we should be
> moving away from this and instead use just generic interfaces. Please,
> think three times (or even more) whenever creating new driver specific
> interfaces, be it module parameters, sysfs files etc.. It's a
> maintenance nightmare and also very confusing for the users. We need to
> focus on nl80211 and make it work properly with all drivers.

What we have done here is not intended to be maintained at all - this is
why the module parameter description reads "power save support
(deprecated) (default disabled)" - it is deprecated from the beginning.

> 
> For the problem at hand, I see two options:
> 
> 1. Users seeing the problem disable power save either via wext or with
>    CONFIG_CFG80211_DEFAULT_PS and everyone else still can use power
>    save. The issue will be investigated and fixed. If the AP is buggy,
>    there isn't much we can do.

Please take a look at those bug reports. What we are seeing is huge ping
delays ( > 1000ms rtt), dropped frames which is stalling connections,
and throughput dropping in half. This is too severe to have powersave
enabled at this time.

> 
> 2. If you think the problem is widespread, remove
>    IEEE80211_HW_SUPPORTS_PS from the driver, fix the issues and renable
>    power save support.

Yes - this is the goal of this patch. At the same time we would also
like to make it easier for the people who are testing this issue right
now and having the module parameter makes their life easier.


This module parameter is a temporary measure used to help us fix the
power save issues. When the issues have been resolved we will enable
power save support by default and remove the module parameter.


Reinette



