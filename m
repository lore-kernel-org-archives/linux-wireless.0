Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab0KMFT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 00:19:58 -0500
To: Ben Greear <greearb@candelatech.com>
Subject: Re: Scanning improvements for multiple VIFS.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Sat, 13 Nov 2010 06:19:56 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
In-Reply-To: <4CDDE324.3070801@candelatech.com>
References: <4CDDCC72.6070006@candelatech.com> <4CDDE324.3070801@candelatech.com>
Message-ID: <4b2689e6064549781b072ac8956bcc1a@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> In nl80211_trigger_scan, if rdev->scan_req is != NULL,
>> instead of returning EBUSY, what if we set a flag in
>> the VIF that said "I want scan results too."
>>
>> Then, when whatever is scanning is finished, it would send
>> scan results to all interested vifs.

But the scans results could technically be different
if they've been done on a different interface. Besides,
you can handle it in userspace. You've been trying for
weeks to avoid changing your userspace by changing the
kernel, which is still the wrong approach.

johannes
