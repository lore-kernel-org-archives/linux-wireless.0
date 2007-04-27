Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:45335 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755431AbXD0HOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 03:14:18 -0400
Message-ID: <46319E31.4090101@linux.intel.com>
Date: Thu, 26 Apr 2007 23:54:41 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <200704251634.16604.flamingice@sourmilk.net> <46312067.9090005@linux.intel.com> <200704262023.52833.flamingice@sourmilk.net>
In-Reply-To: <200704262023.52833.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:

> How fast is hardware scanning? 

I just hooked the hw scanning back up in iwlwifi (as of iwlwifi-0.0.14)  The driver wasn't calling ieee80211_scan_complete() before to tell the stack the scan was done, so no results were being passing up.

Anyway, I ran a quick test of using hw_scan enabled and disabled on a system with 15 active and 17 passive channels.

	hw scan: 2.2s
	sw scan: 4.7s

So the SW scan wasn't the 10s that I stated before (although it sure felt like 10s before I ran it with 'time')  But anyway... the hw scan is currently beating out sw scanning by ~54%, at least here.

James
