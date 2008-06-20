Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44205 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760490AbYFTPhH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 11:37:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
Date: Fri, 20 Jun 2008 17:36:23 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	David Ellingsworth <david@identd.dyndns.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1213739834.3803.137.camel@johannes.berg> <20080620134637.GA8135@elte.hu> <20080620152748.GA21245@elte.hu>
In-Reply-To: <20080620152748.GA21245@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806201736.23916.mb@bu3sch.de> (sfid-20080620_173729_783902_7B339355)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 June 2008 17:27:48 Ingo Molnar wrote:
>  [<c012b361>] local_bh_enable_ip+0xd1/0xe0
>  [<c08d9f9f>] _spin_unlock_bh+0x2f/0x40
>  [<c0471b92>] vortex_timer+0xe2/0x3e0

> real bug or false positive?

Well, a timer runs with IRQs disabled, no? So this would be a bug.

-- 
Greetings Michael.
