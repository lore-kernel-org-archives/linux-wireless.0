Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52861 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2APNCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 08:02:09 -0500
Subject: Re: possible bug in sta_info.c : ieee80211_send_null_response
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4F1414F3.7020007@etit.tu-chemnitz.de> (sfid-20120116_134227_470249_C757A432)
References: <4F1414F3.7020007@etit.tu-chemnitz.de>
	 (sfid-20120116_134227_470249_C757A432)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 14:02:06 +0100
Message-ID: <1326718926.3510.12.camel@jlt3.sipsolutions.net> (sfid-20120116_140213_311796_FC5A2286)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-16 at 13:15 +0100, Marco Porsch wrote:

> ieee80211_xmit is called at the end of the function. Which then calls 
> ieee80211_set_qos_hdr.
> 
> But ieee80211_set_qos_hdr will completely overwrite the QoS header again.
> So, what is wrong here?

You, I think?


void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
                           struct sk_buff *skb)
...
                /* preserve EOSP bit */
                ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
...
                /* qos header is 2 bytes */
                *p++ = ack_policy | tid;   
                *p = ieee80211_vif_is_mesh(&sdata->vif) ?
                        (IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT >> 8) :
0;


johannes

