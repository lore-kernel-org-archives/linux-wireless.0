Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:20272 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbYLLPiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 10:38:22 -0500
Received: by an-out-0708.google.com with SMTP id d40so689892and.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 07:38:21 -0800 (PST)
Message-ID: <b6c5339f0812120738s4859378eoe8629c5581a5a807@mail.gmail.com> (sfid-20081212_163826_194763_32C4EC02)
Date: Fri, 12 Dec 2008 10:38:20 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Benoit PAPILLAULT" <benoit.papillault@free.fr>
Subject: Re: [ath5k-devel] [PATCH] ath5k : Fix correct padding
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com,
	"Harvey Harrison" <harvey.harrison@gmail.com>
In-Reply-To: <49422598.5050204@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <49418D23.8060905@free.fr> <1229033298.15776.18.camel@brick>
	 <1229033411.8081.91.camel@johannes.berg> <49422598.5050204@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 12, 2008 at 3:49 AM, Benoit PAPILLAULT
<benoit.papillault@free.fr> wrote:
> Nice catch! I wonder how it was working in my preliminary tests. Sorry
> for the duplicates with the same patch for ath9k. The padding/unpadding
> stuff is needed by the hardware, ie the hardware insert padding on RX
> and expect padding on TX, as mentioned in earlier ath5k and madwifi
> source code.

I should clarify: I meant Patrick already posted a fix for ath5k (and
possibly the ensuing discussion led to the ath9k patch).  Anyway, let's
just get a patch in :)

The extra padding on TX side shouldn't hurt anything, OTOH, yeah it is
probably unnecessary to do it for ACK/CTS.

Also take a look at desc.c when setting up TX descriptor:

     frame_len = pkt_len - (hdr_len & 3) + FCS_LEN;

What we have now will be 10 - 2 + 4 = 12 vs what should probably be 14.

-- 
Bob Copeland %% www.bobcopeland.com
