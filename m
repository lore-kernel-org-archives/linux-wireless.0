Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-47.dex002.intermedia.net ([64.78.21.143]:47621 "EHLO
	dhost002-47.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963AbXB1VJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 16:09:30 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Wed, 28 Feb 2007 13:09:26 -0800
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] d80211: switch STA interfaces to PS mode during scan
Message-ID: <20070228210926.GM31074@devicescape.com>
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net> <20070228203943.11473.88812.stgit@magic.sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070228203943.11473.88812.stgit@magic.sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 28, 2007 at 03:39:43PM -0500, Michael Wu wrote:
> This makes scans switch STA interfaces into PS mode so the AP queues frames
> destined for us while we are scanning. This is achieved by sending a
> nullfunc data frame with the PS mode bit set before scanning commences,
> and a PS poll frame after scanning is completed.

Why bother with PS Poll in this case? Just send data::nullfunc with PS
Poll flag cleared. That will make the AP deliver all buffered frames (if
any).

-- 
Jouni Malinen                                            PGP id EFC895FA
