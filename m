Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36393 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161245AbXBOU5Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 15:57:25 -0500
Date: Thu, 15 Feb 2007 21:57:22 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] d80211: Add software sequence support
Message-ID: <20070215215722.3db7f3ca@griffin.suse.cz>
In-Reply-To: <200702151548.25041.flamingice@sourmilk.net>
References: <200702141423.27823.IvDoorn@gmail.com>
	<200702151548.25041.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 15 Feb 2007 15:48:20 -0500, Michael Wu wrote:
> I am not so sure that storing this information in struct ieee80211_sta_bss is 
> correct. As far as I can tell, that is strictly for storing information scan 
> results and beacon information. Nothing outside of ieee80211_sta.c uses it. 
> struct sta_info or struct ieee80211_if_ap (sta interfaces have a pointer to 
> the struct ieee80211_if_ap on the master device) may be a better choice. I 
> think struct sta_info is the right one though there is a problem - it isn't 
> allocated until a successful association.

Thinking about it more, sdata should be the correct place. It's more
per-interface thing than per-BSS (although the difference is small in
this particular case).

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
