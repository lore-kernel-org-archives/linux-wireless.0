Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:47910 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3BUBiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 20:38:09 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20773.31273.604966.176099@gargle.gargle.HOWL> (sfid-20130221_023813_776068_72779712)
Date: Thu, 21 Feb 2013 07:06:41 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+:  ath9k:  tx logic locks up after taking attenuation very
 high.
In-Reply-To: <51255360.6060603@candelatech.com>
References: <511935F2.8080103@candelatech.com>
	<20761.34987.125000.908722@gargle.gargle.HOWL>
	<511BC243.8010409@candelatech.com>
	<20770.57339.20017.225929@gargle.gargle.HOWL>
	<51255360.6060603@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
>  From the AP lockup case, dmesg is full of stuff like this:
> 
> [ 1819.538577] vap1: delba from 00:3f:d1:e4:32:51 (initiator) tid 0 reason code 37
> [ 1819.640602] vap1: Rx A-MPDU request on 00:6f:f9:68:b1:31 tid 0 result 0
> [ 1819.690601] vap1: Rx A-MPDU request on 00:01:ab:ba:da:d3 tid 0 result 0
> [ 1819.778013] vap1: RX session timer expired on 00:59:82:d1:d8:8c tid 0
> [ 1819.778040] vap1: Rx BA session stop requested for 00:59:82:d1:d8:8c tid 0 recipient reason: 39
> [ 1819.814600] vap1: delba from 00:59:82:d1:d8:8c (initiator) tid 0 reason code 37
> [ 1819.820010] vap1: RX session timer expired on 00:eb:69:fc:4b:db tid 0
> [ 1819.820034] vap1: Rx BA session stop requested for 00:eb:69:fc:4b:db tid 0 recipient reason: 39
> [ 1819.863631] vap1: delba from 00:eb:69:fc:4b:db (initiator) tid 0 reason code 37
> [ 1819.978012] vap1: RX session timer expired on 00:39:9a:d1:0e:10 tid 0
> [ 1819.978035] vap1: Rx BA session stop requested for 00:39:9a:d1:0e:10 tid 0 recipient reason: 39
> [ 1820.014580] vap1: delba from 00:39:9a:d1:0e:10 (initiator) tid 0 reason code 37

The ADDBA sessions are being torn down aggressively.

> TXERR Filtered:            224          0         0         0

The recipient has gone out of range and frames are being filtered here.
As a quick test, can you disable PowerSave on the client and check if the issue
still happens ?

Sujith
