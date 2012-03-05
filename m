Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2CEVAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 16:00:42 -0500
Subject: Re: [PATCH] cfg80211/mac80211: report signal strength for mgmt
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20120305204251.GH18128@tuxdriver.com>
References: <1330692035.8542.14.camel@jlt3.sipsolutions.net>
	 <20120305204251.GH18128@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Mar 2012 22:00:39 +0100
Message-ID: <1330981239.3545.12.camel@jlt3.sipsolutions.net> (sfid-20120305_220045_488299_FE9B2836)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-05 at 15:42 -0500, John W. Linville wrote:
> On Fri, Mar 02, 2012 at 01:40:35PM +0100, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Add the signal strength (in dBm only for now) to
> > frames that are received via nl80211's various
> > frame APIs.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  include/linux/nl80211.h |    6 ++++++
> >  include/net/cfg80211.h  |    8 +++++---
> >  net/mac80211/rx.c       |   13 +++++++++++--
> >  net/wireless/mlme.c     |    7 ++++---
> >  net/wireless/nl80211.c  |    9 +++++++--
> >  net/wireless/nl80211.h  |    3 ++-
> >  6 files changed, 35 insertions(+), 11 deletions(-)
> 
>   CC      drivers/net/wireless/ath/ath6kl/wmi.o
> drivers/net/wireless/ath/ath6kl/wmi.c: In function ‘ath6kl_wmi_rx_probe_req_event_rx’:
> drivers/net/wireless/ath/ath6kl/wmi.c:559:3: warning: passing argument 3 of ‘cfg80211_rx_mgmt’ makes integer from pointer without a cast
> include/net/cfg80211.h:3205:6: note: expected ‘int’ but argument is of type ‘u8 *’
> drivers/net/wireless/ath/ath6kl/wmi.c:559:3: warning: passing argument 4 of ‘cfg80211_rx_mgmt’ makes pointer from integer without a cast
> include/net/cfg80211.h:3205:6: note: expected ‘const u8 *’ but argument is of type ‘u16’
> drivers/net/wireless/ath/ath6kl/wmi.c:559:3: error: too few arguments to function ‘cfg80211_rx_mgmt’
> include/net/cfg80211.h:3205:6: note: declared here
> drivers/net/wireless/ath/ath6kl/wmi.c: In function ‘ath6kl_wmi_rx_action_event_rx’:
> drivers/net/wireless/ath/ath6kl/wmi.c:598:2: warning: passing argument 3 of ‘cfg80211_rx_mgmt’ makes integer from pointer without a cast
> include/net/cfg80211.h:3205:6: note: expected ‘int’ but argument is of type ‘u8 *’
> drivers/net/wireless/ath/ath6kl/wmi.c:598:2: warning: passing argument 4 of ‘cfg80211_rx_mgmt’ makes pointer from integer without a cast
> include/net/cfg80211.h:3205:6: note: expected ‘const u8 *’ but argument is of type ‘u16’
> drivers/net/wireless/ath/ath6kl/wmi.c:598:2: error: too few arguments to function ‘cfg80211_rx_mgmt’
> include/net/cfg80211.h:3205:6: note: declared here
> make[3]: *** [drivers/net/wireless/ath/ath6kl/wmi.o] Error 1

Oh crap, I forgot about ath6kl, sorry!

johannes

