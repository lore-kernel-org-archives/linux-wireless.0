Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:64530 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbXJULXz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 07:23:55 -0400
MIME-Version: 1.0
Subject: RE: [PATCH 1/1] mac80211: adding bss_config to low driver ops
Date: Sun, 21 Oct 2007 13:23:49 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB03E6D304@hasmsx411.ger.corp.intel.com> (sfid-20071021_122359_838304_2E62C998)
In-Reply-To: <200710172138.41444.flamingice@sourmilk.net>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Michael Wu" <flamingice@sourmilk.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
Cc: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both remarks true, thanks

-----Original Message-----
From: Michael Wu [mailto:flamingice@sourmilk.net] 
Sent: Thursday, October 18, 2007 3:39 AM
To: Winkler, Tomas
Cc: linville@tuxdriver.com; johannes@sipsolutions.net;
linux-wireless@vger.kernel.org; Rindjunsky, Ron
Subject: Re: [PATCH 1/1] mac80211: adding bss_config to low driver ops

On Wednesday 17 October 2007 19:51:46 you wrote:
> +#define ASSOC_CHNAGED_STATE     (1<<0)
> +#define ASSOC_CHNAGED_AID       (1<<1)
> +#define ASSOC_CHNAGED_ERP       (1<<2)
> +#define ASSOC_CHNAGED_WMM       (1<<3)
> +
s/CHNAGED/CHANGED/

> +		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
> +		wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
> +		ifsta->last_probe = jiffies;
> +		ieee80211_led_assoc(local, bss_data->assoc);
The SIOCGIOAP event should happen on both association and
disassociation, not 
just association.


-Michael Wu
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
