Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:58297 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422832AbXCOGmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2007 02:42:01 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HRjd5-0004Xa-PP
	for linux-wireless@vger.kernel.org; Thu, 15 Mar 2007 02:40:04 -0400
Subject: Re: [RFC][PATCH] Add radiotap-based packet injection capability to  monitor mode
From: Pavel Roskin <proski@gnu.org>
To: Andy Green <andy@warmcat.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <45F8E873.4050705@warmcat.com>
References: <45F89DA5.8000206@warmcat.com>
	 <200703150157.02876.flamingice@sourmilk.net> <45F8E873.4050705@warmcat.com>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 02:41:41 -0400
Message-Id: <1173940901.24577.6.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-03-15 at 06:32 +0000, Andy Green wrote:
>   It seemed from the struct ieee80211_radiotap_header header version in 
> Linville's latest FC7 #4 RPM anyway that they were native endian, ie, 
> using u16 in there.  I took from that the args were likewise u16, which 
> was possible since the radiotap part doesn't normally leave the machine. 
>   But having fixed endianness makes more sense.

I posted a patch that annotates radiotap as little-endian, but I haven't
seen any reaction so far.

I'm not aware of any driver that implements radiotap as native endian
(at least intentionally).  All implementation I know are little endian,
even if it means sparse warnings (that's how I became aware of the
problem with the non-annotated include file for radiotap).

-- 
Regards,
Pavel Roskin

