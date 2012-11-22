Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49901 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab2KVUoe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 15:44:34 -0500
Message-ID: <1353573266.9806.14.camel@jlt4.sipsolutions.net> (sfid-20121122_214447_895151_E6BBF2E3)
Subject: Re: [PATCH v2] mac80211: support radiotap vendor namespace RX data
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 22 Nov 2012 09:34:26 +0100
In-Reply-To: <50ADE0E3.2020909@neratec.com>
References: <1353061591-22284-1-git-send-email-johannes@sipsolutions.net>
	  <87ehjtygci.fsf@purkki.adurom.net>
	 <1353063966.9490.1.camel@jlt4.sipsolutions.net>
	 <50ADE0E3.2020909@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-22 at 09:22 +0100, Wojciech Dubowik wrote:
> Shouldn't all functions between ieee80211_rx
> and remove_monitor_info map header with
> (struct ieee80211_hdr *)(skb->data + status->vendor_radiotap_len) ?
> 
> Otherwise function like should_drop_frame uses header mapped over
> potential vendor data.

Huh, yes, how did I miss that. It only applies to should_drop_frame()
though, or do you see any other place?

johannes

