Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60218 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbeC0Mrx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 08:47:53 -0400
Message-ID: <1522154870.3050.2.camel@sipsolutions.net> (sfid-20180327_144756_755417_C649AFBC)
Subject: Re: [RFC 2/4] nl80211/mac80211: Extend NoAck policy command with
 peer MAC address
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2018 14:47:50 +0200
In-Reply-To: <1522140171-10926-3-git-send-email-vthiagar@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
         <1522140171-10926-3-git-send-email-vthiagar@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-03-27 at 14:12 +0530, Vasanthakumar Thiagarajan wrote:
> 
> - * @set_noack_map: Set the NoAck Map for the TIDs.
> + * @set_noack_map: Set the NoAck Map for the TIDs. When peer is not %NULL NoAck
> + *	map will be applied for that particular peer. When peer is %NULL NoAck
> + *	map will be applied for all the connected stations (except the ones
> + *	which already have per-peer TID map configured) on the netdev.
> + *	Driver should return -ENOSPC when the it does not have room for
> + *	additional entries for per-peer NoAck map.

I guess it should also set the default for new stations when the peer is
not given? At least that's how mac80211 would behave now, afaict.

The question is how that interacts with having enough space - are you
sure this is a concern?

>   * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap for the individual TIDs whether
> - *      No Acknowledgement Policy should be applied.
> + *	No Acknowledgement Policy should be applied. %NL80211_ATTR_MAC is used
> + *	to apply No Acknowledgement policy for a particular connected station.
> + *	Station specific NoAck policy configuration is valid only for STA's
> + *	current connection, i.e. the configuration will not be used when the
> + *	station connects back after disconnection/roaming.
> + *	When user-space does not include %NL80211_ATTR_MAC, the No
> + *	Acknowledgement Policy setting should be treated as per-netdev
> + *	configuration.

Here you describe different semantics - i.e. you didn't describe the
"previous per-station settings are kept" part. I'm not sure that part
makes much sense anyhow?

johannes
