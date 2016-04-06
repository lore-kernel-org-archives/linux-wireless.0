Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25525 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbcDFJzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 05:55:36 -0400
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Andrei Otcheretianski" <andrei.otcheretianski@intel.com>
Subject: Re: [PATCHv3 RESEND 01/11] cfg80211: add start / stop NAN commands
Date: Wed, 6 Apr 2016 09:55:31 +0000
Message-ID: <20160406095528.GD10595@jouni.qca.qualcomm.com> (sfid-20160406_115539_941993_DD87908C)
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
In-Reply-To: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 29, 2016 at 12:34:59PM +0300, Emmanuel Grumbach wrote:
> This allows user space to start/stop NAN interface.
> A NAN interface is like P2P device in a few aspects: it
> doesn't have a netdev associated to it.
> Add the new interface type and prevent operations that
> can't be executed on NAN interface like scan.

What is the need for this new NAN interface from the view point of
supporting NAN discovery? Are you planning to use the same iface type
eventually for supporting data traffic over NAN interface as well?

> + * @start_nan: Start the NAN interface.
> + * @stop_nan: Stop the NAN interface.

>  struct cfg80211_ops {
> +	int	(*start_nan)(struct wiphy *wiphy, struct wireless_dev *wdev,
> +			     struct cfg80211_nan_conf *conf);
> +	void	(*stop_nan)(struct wiphy *wiphy, struct wireless_dev *wdev);

And similarly from 4/11:
+	int	(*nan_change_conf)(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   struct cfg80211_nan_conf *conf,
+				   u32 changes);

There is no matching cookie (such as transaction id) in these requests
to the driver, are you expecting synchronous response from the driver
for these requests? Or would some kind of event after the operation has
been completed be possible?

-- 
Jouni Malinen                                            PGP id EFC895FA