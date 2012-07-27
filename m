Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40196 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2G0VgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 17:36:14 -0400
Received: by weyx8 with SMTP id x8so2365272wey.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 14:36:13 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Subject: Re: [PATCH 2/2] mac80211: Add transmit power control support (TPC) for ACK packets
Date: Fri, 27 Jul 2012 23:36:09 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes.berg@intel.com, nbd@openwrt.org
References: <1343404809-70329-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1343404809-70329-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1343404809-70329-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201207272336.09898.chunkeey@googlemail.com> (sfid-20120727_233618_734042_775A3B17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 July 2012 18:00:09 Thomas Huehn wrote:
> This patch adds support to annotate and change the power-level of ACK
> packets. To map hardware specific ack power capabilities to mac80211
> one new hw flag is defined:
> 
> @IEEE80211_HW_SUPPORTS_TPC_ACK_GLOBAL:
> 	Power level of ack packets is adjustable and processed in a
> 	global manner, per hw rather than per ack packet or link.
> 
> The struct hw_config is extended by ack_power a global power level in
> dBm to be used for all acknowledgement_packets. A new config change
> event IEEE80211_CONF_CHANGE_ACK_POWER is defined to reacte with driver
> specific function calls to ack_power changes from the mac80211.

I know this is kind of an odd. But as carl9170 has TPC settings
for BlockACK, CF-End and QoS-Null frames, it wouldn't be possible
to extend "ACK" to "response".

NB: The HW has also TPC control registers for ERP(RTS/CTS)
but that's sort of a different issue.

Regards,
	Chr
