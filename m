Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760490AbXHHXHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 19:07:21 -0400
Date: Wed, 8 Aug 2007 16:06:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: superh allmodconfig
Message-Id: <20070808160619.1b483888.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/b44.c: In function `b44_sync_dma_desc_for_cpu':
drivers/net/b44.c:159: error: implicit declaration of function `dma_sync_single_range_for_cpu'

This is actually an sh problem.  It hit sparc64 too but davem fixed
it.  Seems that secveral architectures are lagging a bit in the PCI
API area, and b44 is using things whcih other drivers are not.
