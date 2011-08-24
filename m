Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49979 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab1HXCaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 22:30:16 -0400
Subject: Re: [RFC] mac80211: Adhoc WPA-NONE packets lost by mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?=E6=9D=8E=E6=9C=9D=E6=98=8E?=
	<chaoming_li@realsil.com.cn>
Cc: linville@tuxdriver.com, 'Larry Finger' <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <F5749057C8FE46CD88E05545135626BB@realsil.com.cn> (sfid-20110823_115916_036908_E0E26086)
References: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net>
	 <1314049818-21839-6-git-send-email-Larry.Finger@lwfinger.net>
	 <F5749057C8FE46CD88E05545135626BB@realsil.com.cn>
	 (sfid-20110823_115916_036908_E0E26086)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 19:30:17 -0700
Message-ID: <1314153017.4573.1.camel@jlt3.sipsolutions.net> (sfid-20110824_043019_986716_034AC2B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-23 at 17:58 +0800, 李朝明 wrote:
> 	
> 	==============================================================
> 	/*
> 	 * RSNA-protected unicast frames should always be
> 	 * sent with pairwise or station-to-station keys,
> 	 * but for WEP we allow using a key index as well.
> 	 */
> 	if (rx->key &&
> 	    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP40 &&
> 	    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP104 &&
> 	    !is_multicast_ether_addr(hdr->addr1))
> 		rx->key = NULL;	
> 	==============================================================
> 
> 	because not only WEP, but IBSS WPA-NONE will also use Group for both
> receiving
> 	and sending unicast and multicast packets.
> 
> 	So I want to ask, why we can't receive WPA-NONE packets here ? Will
> WPA-NONE 
> 	packets cause other issues ?

Well, we'd have to make this depend on WPA-NONE somehow I think.

Do you have to support WPA-NONE or would you be happy with proper RSN
IBSS, which you can implement now?

johannes

