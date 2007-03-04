Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:47091 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913AbXCDKX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 05:23:57 -0500
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 90E238CAD2
	for <linux-wireless@vger.kernel.org>; Sun,  4 Mar 2007 11:23:55 +0100 (CET)
Received: from flatcat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 18009F521
	for <linux-wireless@vger.kernel.org>; Sun,  4 Mar 2007 10:25:00 +0000 (UTC)
Received: from [127.0.0.1] (flatcat.home.warmcat.com [127.0.0.1])
	by flatcat.home.warmcat.com (Postfix) with ESMTP id 5910CB2807A
	for <linux-wireless@vger.kernel.org>; Sun,  4 Mar 2007 10:23:54 +0000 (GMT)
Message-ID: <45EA9E39.6080706@warmcat.com>
Date: Sun, 04 Mar 2007 10:23:53 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Question about PRISM2 header rate field
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

I can decode captured Monitor Mode PRISM2 headers in a reasonable way, 
except for the rate field.

On a capture of a broadcast which I believe was at 54Mbps, I see the 
PRISM2 / ieee80211_frame_info field "datarate" is set to 0xf0, or 240 
decimal.  I looked around at the various different ways of talking about 
tx rate in the stack and drivers, but none that I found use 0xf0 for 
54Mbps.  Is it 48Mbps in units of 200kHz?  Or 54Mbps in units of 225kHz 
(!!)  Or...?

I am trying to reissue this captured packet using the management 
interface (which I can now conjure up) with a rate that I can control, 
but I did not find any information on the coding for this field.

-Andy
