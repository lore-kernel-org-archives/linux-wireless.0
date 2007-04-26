Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:30016 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754071AbXDZDWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2007 23:22:48 -0400
Message-ID: <4630166E.6060000@linux.intel.com>
Date: Wed, 25 Apr 2007 20:03:10 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <20070423184814.7029.8413.stgit@magic.sourmilk.net> <462EE107.8040005@linux.intel.com> <20070425181656.GD5875@tuxdriver.com>
In-Reply-To: <20070425181656.GD5875@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Tue, Apr 24, 2007 at 10:03:03PM -0700, James Ketrenos wrote:
> 
>> (I would like to see hw_scan remain since iwlwifi uses it -- which we hope 
>> to submit as soon as the code restructuring is complete)
> 
> I was going to mention this in response to Michael's patch, but then
> I checked your current iwlwifi git tree.  There your hw_scan routine
> is commented-out, so I figured you didn't want/need it anymore...?

One of the changes in iwlwifi caused the hwscan to start locking the system and at the time it was easier to comment it out and focus on other issues (rate scaling was broken as well)  

When the hw scanning does work, its returns scan results a lot faster to the user without as much processing overhead, so we'll definitely want to switch back to using the hwscan for iwlwifi.

James
