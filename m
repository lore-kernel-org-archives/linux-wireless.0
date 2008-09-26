Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65268 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbYIZDyq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 23:54:46 -0400
Subject: Re: [PATCH] iwl3945: added channel sysfs entry
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
In-Reply-To: <1222334592.10563.59.camel@johannes.berg>
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
	 (sfid-20080924_080231_170139_3D180880) <1222245882.18015.62.camel@johannes.berg>
	 <1222328058.2510.470.camel@debian.sh.intel.com>
	 <1222334592.10563.59.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 11:54:02 +0800
Message-Id: <1222401242.2510.519.camel@debian.sh.intel.com> (sfid-20080926_055459_970890_6D0B66C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-09-25 at 03:23 -0600, Johannes Berg wrote:
> Not that I understand why you need that since iw shows all channels
> you
> are registering (albeit with possibly a few more flags like
> "disabled"),
> but yeah, if anything all this stuff should be in debugfs.

The real user for the function is the automated test cases of our
validation team running nightly. Greppig dmesg is not reliable and iw is
not mature enough (at least not included in major distros). We will move
it to debugfs for now. After iw is as common as iwconfig, we will
eventually remove this.

> There's also
> this little fact that this channel list shouldn't ever get used, you
> should be (and afaik are since I fixed it) using what the regdomain is
> enforcing, and you're already printing the channel list when enough
> debugging flags are set on driver load.

This is used for debugging especially during the time regdomain is under
development. I've received quite a few bug reports that is due to
CONFIG_WIRELESS_OLD_REGULATORY is not enabled. I need at least a way to
tell the users this is due to your misconfig your regdomain or your
hardware is not capable to work on that channel.

Thanks,
-yi

