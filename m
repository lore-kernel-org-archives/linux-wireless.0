Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:55205 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab0ANVr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 16:47:57 -0500
Received: by pzk1 with SMTP id 1so126465pzk.33
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 13:47:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <995709e41001141227n31cab7aeuae0e5a974fa1afdd@mail.gmail.com>
References: <995709e41001091103t43738262ibb2c4e0c4beab26d@mail.gmail.com>
	 <995709e41001120217r1b6b276ek70658a1142744142@mail.gmail.com>
	 <4B4C8320.8060801@free.fr>
	 <995709e41001120724j7a6627b1g5d90df8fb658ceaa@mail.gmail.com>
	 <43e72e891001120846x453e4052oa93675b86fe4a86d@mail.gmail.com>
	 <995709e41001120914n17cfdb56k664c2b42afe448f6@mail.gmail.com>
	 <43e72e891001120918v70c3be7nd3d3819f0e8b0cd0@mail.gmail.com>
	 <995709e41001122307g2d0e9546g2b3680a6cb0a345d@mail.gmail.com>
	 <b6c5339f1001140815v5c6dfdc7j62f7d71623490216@mail.gmail.com>
	 <995709e41001141227n31cab7aeuae0e5a974fa1afdd@mail.gmail.com>
Date: Thu, 14 Jan 2010 16:47:56 -0500
Message-ID: <b6c5339f1001141347k381bb06alb43648d33039ace2@mail.gmail.com>
Subject: Re: [ath9k-devel] [Moblin Dev] Wireless is keep on disconnecting
From: Bob Copeland <me@bobcopeland.com>
To: Jaswinder Singh Rajput <jaswindermobile@gmail.com>
Cc: davem@davemloft.net, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	arjan@linux.intel.com, "Li, Yan" <yan.i.li@intel.com>,
	dev@moblin.org, alainswb <alainswb@free.fr>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 14, 2010 at 3:27 PM, Jaswinder Singh Rajput
<jaswindermobile@gmail.com> wrote:
> I run these tests on Wireless A/G.
>
> Can you please let me know what are the overheads for this performance
> degradation.

802.11 MAC, plus IP headers, etc.  E.g. in the MAC, a single packet
transmission includes the DCF interfame space, physical layer headers,
an exponential backoff term, plus the time for an ACK from the recipient.

You can get more exact info from the 802.11 spec, but it is something
like (from memory) 34 us for DIFS, another 20 us or so for PLCP,
between 0 and 135 us for backoff term, then 4 us per OFDM symbol,
which for 1500 byte packet at 54 mbps works out to ~224 us.

So, that's ~413 us to send 1500*8 bits, or an actual rate of 29 Mbps
not counting the ACK.  It goes down from there with retransmissions
and the rest.

-- 
Bob Copeland %% www.bobcopeland.com
