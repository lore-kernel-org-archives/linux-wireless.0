Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:39624 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYLPNXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 08:23:00 -0500
Received: by qyk4 with SMTP id 4so3176793qyk.13
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 05:22:59 -0800 (PST)
Message-ID: <4947ABAF.9060205@cortland.com> (sfid-20081216_142307_408391_45511CB5)
Date: Tue, 16 Dec 2008 08:22:55 -0500
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
MIME-Version: 1.0
To: Keir <keirlawson@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>, javier@cozybit.com
Subject: Re: Mesh now completely broken on ath5k, latest git
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>
In-Reply-To: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keir wrote:
> Having has no luck with an old rc6 version (basically all plink
> packets were getting lost), I upgraded to the newest git (rc8) however
> now when I run iw dev mesh0 station sump I don't see a single other
> mesh point.  This would imply that presumably beaconing is broken?
>
> Does anyone know a revision for which ath5k is properly working? I am
> yet to find one that works on my system.
>
> Cheers
>
> Keir
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
Beaconing seems broken by Update PCU code 
dd1c9abd167de9bb9457a57694a1ab5e5801a0c1. After this patch, beacon debug 
says beacons sent, but sniffer sees none.

A snapshot of ath5k prior to this and git 12/10 
(b6d06c9669f27db31a0317fc98fedc8ff1ba4822) works for me with 
hostapd/wpa. It's been running for the past few days.

Mesh beaconing also works. I didn't test two nodes; I only sniffed the 
beacons.

I had to comment out 5GHz in caps.c because of too many channels. It's a 
nl80211 buffer size problem that's been discussed.

Steve


