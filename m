Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40062 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2BNHgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 02:36:40 -0500
Subject: Re: RTLWIFI_DEBUG bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Joe Perches <joe@perches.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4F398466.6010607@lwfinger.net> (sfid-20120213_224545_739603_39CB7C5F)
References: <1329142387.3365.6.camel@jlt3.sipsolutions.net>
	 <4F398466.6010607@lwfinger.net> (sfid-20120213_224545_739603_39CB7C5F)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Feb 2012 08:36:36 +0100
Message-ID: <1329204996.3941.0.camel@jlt3.sipsolutions.net> (sfid-20120214_083644_107223_7F938F6E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-13 at 15:45 -0600, Larry Finger wrote:
> On 02/13/2012 08:13 AM, Johannes Berg wrote:
> > config RTLWIFI_DEBUG
> >          tristate "Additional debugging output"
> >          depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192DE
> >          default y
> >
> > should be
> >
> > config RTLWIFI_DEBUG
> >          bool "..."
> >
> > as otherwise
> >
> > +#ifdef CONFIG_RTLWIFI_DEBUG
> >
> > can never be true in a modular build.
> >
> > johannes
> 
> Johannes,
> 
> It is OK as is. The appropriate section of my .config has
> 
> CONFIG_RTL8192CE=m
> CONFIG_RTL8192SE=m
> CONFIG_RTL8192DE=m
> CONFIG_RTL8192CU=m
> CONFIG_RTLWIFI=m
> CONFIG_RTLWIFI_DEBUG=m

Kconfig wise it is fine, but you might as well unset it -- the only use
is an #ifdef which will not match when it's set to m.

johannes

