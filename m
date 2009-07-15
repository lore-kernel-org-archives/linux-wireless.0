Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22242 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209AbZGOQCW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 12:02:22 -0400
Subject: Re: Unable to load iwlagn module: Failed to register hw (error -17)
From: reinette chatre <reinette.chatre@intel.com>
To: John Ranson <ranson@analager.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <bcd1ba70907142125y35c78cf5v251953eafede0e74@mail.gmail.com>
References: <bcd1ba70907142125y35c78cf5v251953eafede0e74@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 09:02:20 -0700
Message-Id: <1247673740.17896.1983.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Tue, 2009-07-14 at 21:25 -0700, John Ranson wrote:
> [    4.252445] iwlagn 0000:03:00.0: Tunable channels: 11 802.11bg, 13
> 802.11a channels
> [    4.252556] iwlagn 0000:03:00.0: irq 30 for MSI/MSI-X
> [    4.252945] iwlagn 0000:03:00.0: Failed to register hw (error -17)
> [    4.253255] iwlagn 0000:03:00.0: PCI INT A disabled
> [    4.253263] iwlagn: probe of 0000:03:00.0 failed with error -17

This is ieee80211_register_hw() returning error 17 (EEXIST). One spot I
saw where this can happen is if you are trying to register with the same
name (wlanX) already used by another netdevice. Does this sound possible
in your setup?

Johannes - do you perhaps have an idea when this can happen?

Reinette


