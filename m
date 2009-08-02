Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54158 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754307AbZHBW2L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 18:28:11 -0400
Message-ID: <4A7612F8.80802@gmx.de>
Date: Mon, 03 Aug 2009 00:28:08 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ar9170usb crashes during iwconfig for ad-hoc mode
References: <4A759341.1090006@gmx.de>
In-Reply-To: <4A759341.1090006@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2009 03:23 PM, Joerg Albert wrote:
> After
>     ifconfig wlan1 down
>     iwconfig wlan1 mode managed essid huhu
>     ifconfig wlan1 up
>     ifconfig wlan1 down
>     iwconfig wlan1 mode ad-hoc essid huhu_a channel 1
> 
> ar9170 crashes (see below for the syslog).
> 
> It seems like ar9170_op_bss_info_changed() is called with ar->vif == NULL
> (i.e. ((struct ar9170 *)hw->priv)->vif == NULL), while parameter vif != 
> NULL and
> changed & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED) is non-zero.
> ar->vif is passed unchecked to ieee80211_beacon_get().
> 
> Is this something ar9170 is supposed to handle or a bug in 
> cfg80211/mac80211?
> Is a driver's *bss_info_changed proc called while the netdev is closed?

It looks like ar->vif is set to NULL by ar9170_remove_interface() and the one call
of ar9170_op_bss_info_changed() when ad-hoc is configured has changed==BSS_CHANGED_BEACON_ENABLED
with bss_info->enable_beacon == 0.
So it's a bug in the ar9170. I'll try to post a patch.
