Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:6863 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbYGNMqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 08:46:42 -0400
Received: by yw-out-2324.google.com with SMTP id 9so2385624ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 05:46:41 -0700 (PDT)
Message-ID: <1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com> (sfid-20080714_144648_163524_E6E0D429)
Date: Mon, 14 Jul 2008 15:46:41 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by low level driver
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1216039127.11189.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	 <1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	 <1216039127.11189.15.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 14, 2008 at 3:38 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-07-14 at 15:31 +0300, Tomas Winkler wrote:
>> This patch makes listen_interval configurable by low level driver.
>
> I'm not sure we we really want that.
>
> With this, you're again putting more features and more decision making
> processes with the driver, I would much prefer this to be worked out in
> mac80211 so we can do it across all drivers.
>
> If this is a knob that should be adjusted then we want to enable users
> to do it, and if it isn't then we can put a value into mac80211 and fix
> it. Having drivers make these kinds of decisions is very bad for uniform
> wireless behaviour.

The same story as with beacon interval. This is for the power
management. It's really hw dependent for how many beacons we can stay
dormant. I really don't know what other vendors do and user should not
guess this.
Thanks
Tomas

> johannes
>
