Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40657 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2EZQZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 12:25:41 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20417.972.888113.821079@gargle.gargle.HOWL> (sfid-20120526_182606_860632_157A35E2)
Date: Sat, 26 May 2012 21:54:44 +0530
To: Ben Greear <greearb@candelatech.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: Anyone doing WiFi throughput tests?
In-Reply-To: <4FC0F8CE.1030303@candelatech.com>
References: <4FC04B5A.1070900@candelatech.com>
	<20416.19680.571601.549629@gargle.gargle.HOWL>
	<4FC0F8CE.1030303@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> We're using WPEA-127N.  We have a dual-core Atom for one system, and
> a quad-core i7 CPU (and two wifi NICs) in another system..  So far, the Atom with
> single NIC is benchmarking better in some tests.  We were only using one of
> the NICs in the i7 for testing, but maybe there is still some interference
> or maybe we just had bad antenna placement or something.

Fiddling with antenna position/placement does help.

> What chipset or brand/model is this?  I see that XB112 mentioned in the WPEA-127N
> description, but maybe that is just a form-factor description?

XB112 is the board and I am using an engineering sample. The WLAN chipset
is AR9380.

> Can you offer any additional details on how you tested this?  You are using the same
> NIC for both AP and station?
> 
> Open-air connection?
> 
> How far away is AP?
> 
> I would like to try to reproduce this result, as it is significantly better
> than what I'm seeing.
> 
> Are you doing any special AP tuning, like using short-guard-intervals
> or similar?  Care to post the wpa_supplicant and hostapd config files?

I am using a DB120 as AP which has dual radio - AR9340/AR9300. The setup is
standard:

STA -------------->  AP -------------------> CONSOLE
       wlan/OTA             gig-ethernet


The AP runs an internal BSP/SDK build and is positioned about 4-5 feet from
the Station. As for the HT parameters, HT40 and short-GI is enabled in both
bands.

Sujith

