Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37525 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab3FKMhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 08:37:46 -0400
Message-ID: <1370954261.8356.39.camel@jlt4.sipsolutions.net> (sfid-20130611_143749_917948_6C931D54)
Subject: Re: [PATCH v2] cfg80211: Allow TDLS peer AID to be configured for
 VHT
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Jun 2013 14:37:41 +0200
In-Reply-To: <20130527152402.GC12369@jouni.qca.qualcomm.com>
References: <20130516171108.GA27497@jouni.qca.qualcomm.com>
	 <1369427943.13623.8.camel@johannes>
	 <20130527152402.GC12369@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-05-27 at 18:24 +0300, Jouni Malinen wrote:
> VHT uses peer AID in the PARTIAL_AID field in TDLS frames. The current
> design for TDLS is to first add a dummy STA entry before completing TDLS
> Setup and then update information on this STA entry based on what was
> received from the peer during the setup exchange.
> 
> In theory, this could use NL80211_ATTR_STA_AID to set the peer AID just
> like this is used in AP mode to set the AID of an association station.
> However, existing cfg80211 validation rules prevent this attribute from
> being used with set_station operation. To avoid interoperability issues
> between different kernel and user space version combinations, introduce
> a new nl80211 attribute for the purpose of setting TDLS peer AID. This
> attribute can be used in both the new_station and set_station
> operations. It is not supposed to be allowed to change the AID value
> during the lifetime of the STA entry, but that validation is left for
> drivers to do in the change_station callback.

Hmm. I guess I accidentally applied the first version, I've now applied
the differences.

johannes

