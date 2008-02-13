Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from root-server.richard-scherping.de ([217.160.107.144]:60124 "EHLO
	p15125984.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbYBMJHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 04:07:03 -0500
Message-ID: <47B2B332.1030404@scherping.de> (sfid-20080213_090722_073703_AC6DE8A0)
Date: Wed, 13 Feb 2008 10:06:58 +0100
From: Richard Scherping <richard@scherping.de>
MIME-Version: 1.0
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: linux-wireless@vger.kernel.org
Subject: [HOTFIX] Re: mac80211/iwl4965: ad-hoc broken in 2.6.25-rc1
References: <47B1F422.4060501@scherping.de> <D936D925018D154694D8A362EEB0892003A461BF@orsmsx416.amr.corp.intel.com> <47B2268D.7060205@scherping.de>
In-Reply-To: <47B2268D.7060205@scherping.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> iwl4965: I iwl4965_tx_skb Dropping - !iwl4965_is_associated: 
> iwl4965_is_associated(priv)=1; priv->assoc_id=0; 
> priv->assoc_station_added=1

Simply uncommenting the check for priv->assoc_id to be non-zero (line 2938 in iwl4965-base.c) made ad-hoc working. Thanks for helping me to find this!
Does this change have any negative side effects?

Richard
