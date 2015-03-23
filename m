Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:41047 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbbCWVia (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 17:38:30 -0400
Message-ID: <551087A3.4090905@broadcom.com> (sfid-20150323_223834_212601_990C6890)
Date: Mon, 23 Mar 2015 22:37:39 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: broadcast ssid in scheduled scan
References: <55105DA7.3040703@broadcom.com>
In-Reply-To: <55105DA7.3040703@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/23/15 19:38, Arend van Spriel wrote:
> Johannes, Jouni,
>
> I have noticed that under some circumstances wpa_supplicant initiates a
> scheduled scan with broadcast ssid. This is something our firmware can
> not do so could this be avoided? Maybe by adding a feature flag for it.
> I will look into it some more to understand the scenarios in which
> broadcast ssid is used in scheduled scan request. If you know about this
> feel free to let me know.

 From the code in wpa_supplicant_req_sched_scan() it seems the wildcard 
ssid (referred to as broadcast ssid) is added if one or more networks 
are configured without 'scan_ssid=1'. So if none of the networks have 
this option only the broadcast ssid ends up in the request.

Regards,
Arend

> Regards,
> Arend
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

