Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:62197 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2FZEML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 00:12:11 -0400
Received: from mail0.frost.chambana.net (mail0.frost.chambana.net [209.66.96.68])
	by www19.servergod.com (Postfix) with ESMTP id 3F95211FCB1
	for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 21:01:39 -0700 (PDT)
Received: by mail0.frost.chambana.net (Postfix) with SMTP id D17385C37B7
	for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 04:01:38 +0000
Received: by mail0.frost.chambana.net (Postfix) with ESMTP id 22AE35C37B5
	for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 04:01:38 +0000
MIME-Version: 1.0
from: "Will Hawkins" <hawkinsw@opentechinitiative.org>
subject: =?utf-8?q?Help_tracing_NL80211=5FCMD=5FAUTHENTICATE_as_event_in_IBSS_mode?=
message-id: <24f-4fe93400-17-239c5900@2266046> (sfid-20120626_061218_757773_249E152D)
to: <linux-wireless@vger.kernel.org>
content-type: text/plain; charset="utf-8"
date: Tue, 26 Jun 2012 00:01:38 -0400
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone!

I've been banging my head against a particular problem for a few days without any success. I thought I'd turn to those much smarter for some help and hopefully a breakthrough.

The documentation for nl80211 says the following about the NL80211_CMD_AUTHENTICATE command:
"When used as an event, this reports reception of an Authentication frame in station and IBSS modes when the local MLME processed the frame, i.e., it was for the local STA and was received in correct state."

I very much want this to be true for IBSS modes. However, I cannot seem to trace through the source code to confirm that this actually happens. I can easily follow the code for the case when the interface is in station mode but lose the trail for IBSS. 

As far as I can tell, the only path to nl80211_send_rx_auth (the only place a NL80211_CMD_AUTHENTICATE command is sent to userspace) looks like this:
ieee80211_iface_work invokes ieee80211_sta_rx_queued_mgmt to handle queued management packets received on a station interface. ieee80211_sta_rx_queued_mgmt (eventually) invokes cfg80211_send_rx_auth, after the proper handling. Finally, cfg80211_send_rx_auth invokes nl80211_send_rx_auth.

If anyone can provide any help, I would sincerely appreciate it. I am not looking for hand-holding -- I know everyone is very busy doing their own work. But, I am at my wits' end here so I thought I'd ask for help!

Thanks everyone,
Will

