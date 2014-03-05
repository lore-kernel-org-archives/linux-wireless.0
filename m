Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:56214 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502AbaCEKyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 05:54:25 -0500
Date: Wed, 5 Mar 2014 12:54:22 +0200
From: Jouni Malinen <j@w1.fi>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] mac80211: ignore probe response from adjacent
 channels
Message-ID: <20140305105422.GB32093@w1.fi> (sfid-20140305_115428_276311_7830713F)
References: <1393944614-4465-1-git-send-email-emmanuel.grumbach@intel.com>
 <1393944614-4465-2-git-send-email-emmanuel.grumbach@intel.com>
 <20140305090854.GA3544@w1.fi>
 <0BA3FCBA62E2DC44AF3030971E174FB303D7871D@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D7871D@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 05, 2014 at 09:20:07AM +0000, Grumbach, Emmanuel wrote:
> > So I guess you want me to revert the code we currently have in
> > ieee80211_rx_mgmt_beacon ;) Don't know really... If you are associated to
> > an AP and hear its beacons / probe responses on another channel you really
> > have a big problem in your radio?
> 
> FWIW: this logic is there since:
> 
> commit d91f36db51661018f6d54ff5966e283bcec4c545
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Thu Apr 16 13:17:26 2009 +0200
> 
>     mac80211: implement beacon filtering in software

The frequency related areas in this commit are in a location that has a
clear comment about it being for the current BSS. Your patch did not
look like it would be for that case. If it is, the commit log should
really say that clearly.

-- 
Jouni Malinen                                            PGP id EFC895FA
