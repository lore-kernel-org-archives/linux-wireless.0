Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43557 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0JIHeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 03:34:04 -0400
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Roaming / offchannel enhancements for broadcast / multicast frames
Date: Sat, 9 Oct 2010 09:33:12 +0200
Cc: Paul Stewart <pstew@google.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Matt Smith <Matt.Smith@atheros.com>,
	Srinivasa Duvvuri <Srinivasa.Duvvuri@atheros.com>,
	Carolyn Waller <Carolyn.Waller@atheros.com>,
	Amod Bodas <Amod.Bodas@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	Bennyam Malavazi <Bennyam.Malavazi@atheros.com>,
	Cliff Holden <Cliff.Holden@atheros.com>,
	Aeolus Yang <Aeolus.Yang@atheros.com>,
	Kevin Hayes <kevin@atheros.com>
References: <AANLkTin9AwTa8x6faFEXBbrGZa4mg3AeDfeEmmdaF9_d@mail.gmail.com> <AANLkTika+07mD==fPioanurwD-_s8aaJFc+nb4ZZOL0J@mail.gmail.com> <AANLkTimBXC9P7pf+-szK3A5FoS2Sjndr8AB9JR=7V-Sr@mail.gmail.com>
In-Reply-To: <AANLkTimBXC9P7pf+-szK3A5FoS2Sjndr8AB9JR=7V-Sr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010090933.13008.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag 09 Oktober 2010 schrieb Luis R. Rodriguez: 
> > There's an additional issue about what happens
> > when we are in the middle of a bgscan and new tx traffic appears.
> 
> We can force going back on channel in this case I think.

This already happens (scan.c):

523                 if (associated && ( !tx_empty || bad_latency ||
524                     listen_int_exceeded))
525                         local->next_scan_state = SCAN_ENTER_OPER_CHANNEL;
526                 else
527                         local->next_scan_state = SCAN_SET_CHANNEL;

When the currently scanned channel is finished and tx traffic arrived
mac80211 will switch back to the operating channel. However, this doesn't
immediately switch back but waits for the channel scan to be completed.
