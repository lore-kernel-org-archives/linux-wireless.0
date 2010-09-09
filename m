Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0IIQi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 12:38:58 -0400
To: Steve deRosier <steve@cozybit.com>
Subject: Re: [PATCH 5/9] =?UTF-8?Q?libertas=5Ftf=3A=20Moved=20firmware=20loading?=
 =?UTF-8?Q?=20to=20probe=20in=20order=20to=20fetch=20MAC=20address?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Thu, 09 Sep 2010 18:38:56 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<javier@cozybit.com>
In-Reply-To: <1283988329-44549-6-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com> <1283988329-44549-6-git-send-email-steve@cozybit.com>
Message-ID: <e23a1b600a18f179fa72d2cadf724d17@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed,  8 Sep 2010 16:25:25 -0700, Steve deRosier <steve@cozybit.com>
wrote:
> mac80211 requires that the MAC address be known and set before calling
> ieee80211_register_hw().  If this isn't done, we see bad MAC addresses
> in our packet headers.  In order to make this happen, I had to
restructure
> to have if_sdio_probe load the firmware and get the hardware specs.
> 
> I had to add a if_sdio_update_hw_spec function as if_sdio can't use the
> standard
> command as several required variables aren't setup yet.
> if_sdio_update_hw_spec essentially uses polled io to get the hw spec
> command response from the card.

You should probably keep this for development purposes, but it will break
if your code is built into the kernel. The working model we've adopted to
solve this is to use request_firmware_nowait() in probe, and then only
continue doing work when the firmware loading returns (and then register
with mac80211 etc)

johannes
