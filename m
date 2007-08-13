Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:58837 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S948409AbXHMT6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 15:58:35 -0400
Received: by mu-out-0910.google.com with SMTP id i10so2328917mue
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2007 12:58:31 -0700 (PDT)
Message-ID: <46C0B817.50707@gmail.com>
Date: Mon, 13 Aug 2007 21:59:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	jbenc@suse.cz, flamingice@sourmilk.net, jeff@garzik.org
Subject: Re: [PATCH 1/4] Net: mac80211, remove bitfields from struct ieee80211_tx_packet_data
References: <32694265142306417777@wsc.cz> <1187009029.27916.107.camel@johannes.berg>
In-Reply-To: <1187009029.27916.107.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg napsal(a):
> On Sun, 2007-08-12 at 15:08 +0200, Jiri Slaby wrote:
> 
>> +	if (control->flags & IEEE80211_TXCTL_REQ_TX_STATUS)
>> +		pkt_data->flags |= IEEE80211_TXPD_REQ_TX_STATUS;
>> +	if (control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT)
>> +		pkt_data->flags |= IEEE80211_TXPD_DO_NOT_ENCRYPT;
>> +	if (control->flags & IEEE80211_TXCTL_REQUEUE)
>> +		pkt_data->flags |= IEEE80211_TXPD_REQUEUE;
>> +	if (control->type == IEEE80211_IF_TYPE_MGMT)
>> +		pkt_data->flags |= IEEE80211_TXPD_MGMT_IFACE;
> 
> This looks weird. Can't we just use the same flags?

I don't think, that it must be subset one of each another in the future. (This
is why I created yet another bits defined).

Do we still want the same flags?

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
