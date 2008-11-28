Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc2-s25.bay0.hotmail.com ([65.54.246.161]:64875 "EHLO
	bay0-omc2-s25.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbYK1Feq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 00:34:46 -0500
Message-ID: <BAY104-DAV671C2C6DE8B2A05AD785E99040@phx.gbl> (sfid-20081128_063451_695419_24A9F419)
Message-ID: <492F82EA.4030902@hotmail.com>
Date: Fri, 28 Nov 2008 16:34:34 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org,
	  Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
References: <4902DEBB.3050205@hotmail.com>	 <20081025112147.GA12252@Chamillionaire.breakpoint.cc>	 <200810251325.07916.mb@bu3sch.de>	 <20081025112813.GC12252@Chamillionaire.breakpoint.cc>	 <49033782.5040701@hotmail.com>  <491589ED.4090904@hotmail.com>	 <1226149894.3610.8.camel@johannes.berg>  <491653A6.20705@hotmail.com> <1226220992.3614.16.camel@johannes.berg> <4916F1C0.1040703@hotmail.com> <BAY104-DAV1D226EA8FB16BE36E3C84991A0@phx.gbl>
In-Reply-To: <BAY104-DAV1D226EA8FB16BE36E3C84991A0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 2008-11-11 02:13, Shaddy Baddah wrote:
> Ok, after a long hard slog at trying to understand all this, I'm going 
> to have to pause the effort. I am beginning to understand the mechanisms 
> in place... however, I am not totally sure about anything. My first 

Devoting a little bit of time here and there to understanding the 
unaligned accesses, I think I understand a whole lot better now.

First off, I only came to realise that the reason the module seemed to 
continue operations despite reporting the unaligned access error was 
because the exception handler actually emulates the intended operation 
(albeit much slower). Good to know.

I then came to understand that we cannot expect alignment on RX in the 
zd1211rw module. In fact, we might expect that 80211 packets are always 
unaligned, because the 5 byte PLCP prefix in the SKB buffer will always 
push it into an odd address (assuming the SKB buffer is allocated 
aligned). In which case, as detailed in the 
Documentation/unaligned-memory-access.txt, replacing 
compare_ether_addr() with memcmp() is perfectly fine.

After solving that, I was still getting an unaligned access from a 
compare_ether_addr() call in sta_info_get() from mac80211 module. My 
dilemma was whether that module would expect alignment always, in which 
case the same simple function replacement would not be OK. But I saw 
several places where memcmp() is preferred to compare_ether_addr(), 
which I assume indicates that mac80211 does not expect alignment of 
80211 packets passed to it.

Applying Sebastian Andrzej Siewior wireless/zd1211rw: use 
get_unaligned_le16 helper (v2) patch and my two changes quietens down 
the kernel completely. I will submit these two patches in follow up emails.

It is interesting (at least to me) to note that a change between kernel 
versions 2.6.26 and 2.6.28-rc6 fixed something that allowed WPA2 to work 
on sparc64. At least according to my careful verification. Perhaps one 
day, I'll narrow that change down.

Regards,
Shaddy

