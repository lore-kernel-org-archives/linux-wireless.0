Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:44965 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbYCHOJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Mar 2008 09:09:46 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bruno randolf <bruno@thinktube.com>
Subject: Re: [RFC PATCH] mac80211: use hardware flags for signal/noise units
Date: Sat, 8 Mar 2008 15:09:20 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz,
	mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com
References: <200803082101.24424.bruno@thinktube.com>
In-Reply-To: <200803082101.24424.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803081509.20926.mb@bu3sch.de> (sfid-20080308_140951_828408_CA3CD30F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 08 March 2008 13:01:24 bruno randolf wrote:
>     b43legacy       dBm(?)  dBm     percent jssi(?)
>     b43             dBm(?)  dBm     percent jssi(?)

It seems that SIGNAL should be dBm. But the calculations currently is
broken and you sometimes get bigger noise than signal.
QUAL is a percentage with a pretty randomly chosen upper signal
limit used as base.

