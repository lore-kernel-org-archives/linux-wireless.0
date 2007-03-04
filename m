Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:46418 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809AbXCDQfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 11:35:41 -0500
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id CF21B8CAD2
	for <linux-wireless@vger.kernel.org>; Sun,  4 Mar 2007 17:35:39 +0100 (CET)
Received: from flatcat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 4EC2BFABF
	for <linux-wireless@vger.kernel.org>; Sun,  4 Mar 2007 16:36:45 +0000 (UTC)
Received: from [127.0.0.1] (flatcat.home.warmcat.com [127.0.0.1])
	by flatcat.home.warmcat.com (Postfix) with ESMTP id 58C16B2807A
	for <linux-wireless@vger.kernel.org>; Sun,  4 Mar 2007 16:35:38 +0000 (GMT)
Message-ID: <45EAF559.5070701@warmcat.com>
Date: Sun, 04 Mar 2007 16:35:37 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Question about PRISM2 header rate field
References: <45EA9E39.6080706@warmcat.com>
In-Reply-To: <45EA9E39.6080706@warmcat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green wrote:

> On a capture of a broadcast which I believe was at 54Mbps, I see the 
> PRISM2 / ieee80211_frame_info field "datarate" is set to 0xf0, or 240 
> decimal.  I looked around at the various different ways of talking about 
> tx rate in the stack and drivers, but none that I found use 0xf0 for 
> 54Mbps.  Is it 48Mbps in units of 200kHz?  Or 54Mbps in units of 225kHz 
> (!!)  Or...?
> 
> I am trying to reissue this captured packet using the management 
> interface (which I can now conjure up) with a rate that I can control, 
> but I did not find any information on the coding for this field.

Well, I discover in fact you need to inject starting only from the 
IEEE802.11 header... and indeed that does work if you do it on the 
"Management Interface".  I found this from hostapd sources, since 
wpa_supplicant doesn't seem to inject packets from userspace, it seems 
to trigger the stack to do canned packets by a huge range of IOCTLs.  So 
I have unencrypted packets in both directions now without patching 
anything on the kernel side :-D  But, there is a but...

The packet seems to go out at a default rate, in my case 1Mbps.  Is 
there in fact a method for requesting the rate for injected packets, or 
is there at the moment a simple equivalence that all broadcasts will go 
out at 1Mbps?

-Andy
