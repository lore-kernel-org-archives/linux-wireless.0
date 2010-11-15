Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60141 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab0KOTKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 14:10:16 -0500
Message-ID: <4CE18592.8090804@candelatech.com>
Date: Mon, 15 Nov 2010 11:10:10 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Scanning improvements for multiple VIFS.
References: <4CDDCC72.6070006@candelatech.com> <4CDDE324.3070801@candelatech.com> <4b2689e6064549781b072ac8956bcc1a@localhost>
In-Reply-To: <4b2689e6064549781b072ac8956bcc1a@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2010 09:19 PM, Johannes Berg wrote:
>>> In nl80211_trigger_scan, if rdev->scan_req is != NULL,
>>> instead of returning EBUSY, what if we set a flag in
>>> the VIF that said "I want scan results too."
>>>
>>> Then, when whatever is scanning is finished, it would send
>>> scan results to all interested vifs.
>
> But the scans results could technically be different
> if they've been done on a different interface. Besides,
> you can handle it in userspace. You've been trying for
> weeks to avoid changing your userspace by changing the
> kernel, which is still the wrong approach.

I just attempted to start wpa_supplicant to control 30
STAs.  It still seems to scan sequentially.

I guess I need to hack wpa_supplicant to cache scan
results?

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

