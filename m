Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37465 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2IEMkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 08:40:46 -0400
Date: Wed, 5 Sep 2012 07:40:39 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] brcmsmac: fix mismatch in number of custom
 regulatory rules
Message-ID: <20120905124039.GB302@thinkpad-t410> (sfid-20120905_144049_826155_9094F5E1)
References: <1346838562-4818-1-git-send-email-arend@broadcom.com>
 <1346838562-4818-2-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1346838562-4818-2-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 05, 2012 at 11:49:21AM +0200, Arend van Spriel wrote:
> The driver provides the cfg80211 regulatory framework with a set of
> custom rules. However, there was a mismatch in number of rules
> and the actual rules provided. This resulted in setting an invalid
> power level:
> 
> ieee80211 phy0: brcms_ops_config: change channel 13
> ieee80211 phy0: brcms_ops_config: Error setting power_level (8758364)
> 
> Closer look in cfg80211 regulatory blurb showed following bogus rule:
> cfg80211: 0 KHz - -60446948 KHz @ 875836468 KHz), (875836468 mBi, 875836468 mBm)
> 
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Reviewed-by: Piotr Haber <phaber@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Oddly enough I don't see the bogus rule on my machine. But the fix is
obviously correct.

Reviewed-by: Seth Forshee <seth.forshee@canonical.com>

