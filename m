Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65214 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab0JLRmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 13:42:31 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikjp=dpOOfjnvg=ivkb40_dE+oRLSEkzrycwirV@mail.gmail.com>
References: <20101012163519.a88f2040.sfr@canb.auug.org.au>
	<1286895206-3030-1-git-send-email-linville@tuxdriver.com>
	<AANLkTikjp=dpOOfjnvg=ivkb40_dE+oRLSEkzrycwirV@mail.gmail.com>
Date: Tue, 12 Oct 2010 13:42:30 -0400
Message-ID: <AANLkTim0ryZ29w0ud9=sSbV6LdZhjW410ptpf3XJDYkm@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fix build break from "ath5k: Print out opmode in debugfs"
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Ben Greear <greearb@candelatech.com>,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 12, 2010 at 12:54 PM, Bob Copeland <me@bobcopeland.com> wrote:
>> +#ifdef CONFIG_ATH_DEBUG
>>        ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
>>                  sc->opmode,
>>                  ath_opmode_to_string(sc->opmode) ?
>>                  ath_opmode_to_string(sc->opmode) : "UKNOWN");

Just one other bikeshed color:

if ath_opmode_to_string() returned "UNKNOWN" in the failure case,
we wouldn't need the double-call above.  Yes, it's used by ath9k
too, but IMHO a debugging function that only converts some of the
possible values to strings is pretty developer unfriendly.

That said, I still think tracepoints are a nicer way to do this
kind of thing (you can even do symbolic names for enums).

-- 
Bob Copeland %% www.bobcopeland.com
