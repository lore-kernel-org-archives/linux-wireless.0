Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936654Ab3DJMik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 08:38:40 -0400
Message-ID: <1365597512.8388.11.camel@jlt4.sipsolutions.net> (sfid-20130410_143846_945672_ED7197F0)
Subject: Re: [PATCH] mac80211: clear SSID when stoping AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 10 Apr 2013 14:38:32 +0200
In-Reply-To: <1365594465-6405-1-git-send-email-marek.puzyniak@tieto.com>
References: <1365594465-6405-1-git-send-email-marek.puzyniak@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-10 at 13:47 +0200, Marek Puzyniak wrote:
> When AP interface was stopped ssid and ssid_len from bss configuration
> was not cleared. This caused a problem when after AP interface was stopped
> another AP with shorter ssid was created. Previous ssid was not
> overwriten by new one shorter.

I'll take the patch, sans the memset. If this was causing you trouble
you're most likely treating the SSID as a string, which it is not, so
you need to fix your driver.

johannes

