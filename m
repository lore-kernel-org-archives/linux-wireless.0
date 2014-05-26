Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:56743 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbaEZLRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 07:17:41 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <m3k39fmyqg.fsf@t19.piap.pl>
	<CANUX_P0CyqhFU5fpTMa=q=du2ZkEPkyuvE32VBmFPUejgn0xOA@mail.gmail.com>
	<m3fvk1m2hv.fsf@t19.piap.pl>
Date: Mon, 26 May 2014 13:13:10 +0200
In-Reply-To: <m3fvk1m2hv.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Fri, 23 May 2014 08:29:48 +0200")
MIME-Version: 1.0
Message-ID: <m3sinwlrnd.fsf@t19.piap.pl> (sfid-20140526_131745_524082_1C6F9A85)
Content-Type: text/plain; charset=utf-8
Subject: Re: iwlwifi Microcode SW error and subsequent WARNINGs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

khalasa@piap.pl (Krzysztof Hałasa) writes:

> However, the card doesn't join the ad hoc network. It creates a new IBSS
> instead.

This seems to be caused by uninitialized sdata->u.ibss.last_scan_completed.

I'll post a patch to net/mac80211/ibss.c.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
