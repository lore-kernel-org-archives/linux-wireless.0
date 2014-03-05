Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:56163 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbaCEJI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 04:08:57 -0500
Date: Wed, 5 Mar 2014 11:08:54 +0200
From: Jouni Malinen <j@w1.fi>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: ignore probe response from adjacent
 channels
Message-ID: <20140305090854.GA3544@w1.fi> (sfid-20140305_100903_767471_CC9C40C2)
References: <1393944614-4465-1-git-send-email-emmanuel.grumbach@intel.com>
 <1393944614-4465-2-git-send-email-emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1393944614-4465-2-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 04, 2014 at 04:50:14PM +0200, Emmanuel Grumbach wrote:
> This logic is already implemented in ieee80211_rx_mgmt_beacon.
> The purpose is to ignore probe responses that are received
> on adjacent channels. This can happen in 2.4GHz since
> channels overlap.

Why would this be done? I can understand not updating signal
information, but dropping Probe Response frames completely sounds quite
undesirable. These can be used to help optimize partial scans and any
additional information that can be used without having to change
channels sounds helpful to me.

-- 
Jouni Malinen                                            PGP id EFC895FA
