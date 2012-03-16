Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:58432 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760540Ab2CPJ0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 05:26:48 -0400
Message-ID: <4F630757.6070901@etit.tu-chemnitz.de> (sfid-20120316_102652_871731_21F3A891)
Date: Fri, 16 Mar 2012 10:26:47 +0100
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: johannes@sipsolutions.net
CC: linux-wireless@vger.kernel.org
Subject: [mac80211] UAPSD: WLAN_STA_PS flag  cleared prematurely?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

in sta_info.c : ieee80211_sta_ps_deliver_response the 
IEEE80211_TX_STATUS_EOSP is set for all to-be-sent frames, not only for 
the last. But only the last buffered frame actually gets the EOSP flag.


/* set EOSP for the frame */
if (reason == IEEE80211_FRAME_RELEASE_UAPSD &&
     qoshdr && skb_queue_empty(&frames))
	*qoshdr |= IEEE80211_QOS_CTL_EOSP;

info->flags |= IEEE80211_TX_STATUS_EOSP |
        IEEE80211_TX_CTL_REQ_TX_STATUS;


Consequence is, that the WLAN_STA_SP flag gets cleared (multiple times) 
in ieee80211_tx_status before the last frame with EOSP has been sent.
Is this correct?

Regards,
Marco
