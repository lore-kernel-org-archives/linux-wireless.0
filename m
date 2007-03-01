Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:40746 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965172AbXCAPLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 10:11:11 -0500
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id D41CF8CAD2
	for <linux-wireless@vger.kernel.org>; Thu,  1 Mar 2007 16:11:08 +0100 (CET)
Received: from flatcat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id D35E5F6A0
	for <linux-wireless@vger.kernel.org>; Thu,  1 Mar 2007 15:12:08 +0000 (UTC)
Received: from [127.0.0.1] (flatcat.home.warmcat.com [127.0.0.1])
	by flatcat.home.warmcat.com (Postfix) with ESMTP id F3B4AB2807A
	for <linux-wireless@vger.kernel.org>; Thu,  1 Mar 2007 15:11:07 +0000 (GMT)
Message-ID: <45E6ED0B.20100@warmcat.com>
Date: Thu, 01 Mar 2007 15:11:07 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Question about packet injection
References: <45E41A9E.2020908@warmcat.com> <20070227164727.GA10048@devicescape.com> <45E497A1.90400@warmcat.com>
In-Reply-To: <45E497A1.90400@warmcat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

As suggested here I migrated my daemon to using a per-physical device 
monitor mode interface it creates and destroys from usermode, together 
with libpcap for filtering and receiving broadcasts and that seems to be 
working okay.  So that is half the battle to get the broadcast system 
working with mac80211 out of the box without patches.

However, if I inject a captured packet - with a PRISM header prepended - 
down the Monitor mode interface using pcap_inject(), I see it appear on 
the libpcap captured output okay, but it does not go out on the air AFAICT.

Is this in fact the correct way to try to inject a packet with fine 
control over its encryption and rate?  If so is it expected to currently 
work on iwlwifi 0.0.8 or rt2x00 (rt73usb) from CVS 2008-02-14?

-Andy
