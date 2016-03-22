Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:51726 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758453AbcCVJvS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 05:51:18 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Dave Taht <dave.taht@gmail.com>,
	Network Development <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
	Jasmine Strong <jas@eero.com>,
	"codel\@lists.bufferbloat.net" <codel@lists.bufferbloat.net>,
	make-wifi-fast@lists.bufferbloat.net
Subject: Re: [RFCv2 0/3] mac80211: implement fq codel
References: <CAA93jw5AAWua23TbQHZX47XcFLEqU6T=NpxuLqa6FiffBf91Fw@mail.gmail.com>
	<CA+BoTQ=hgkm2AwMb=kinx+Ezf3vjduCKNH4LNRcV_goDWH4_Vg@mail.gmail.com>
Date: Tue, 22 Mar 2016 10:51:12 +0100
In-Reply-To: <CA+BoTQ=hgkm2AwMb=kinx+Ezf3vjduCKNH4LNRcV_goDWH4_Vg@mail.gmail.com>
	(Michal Kazior's message of "Tue, 22 Mar 2016 09:05:32 +0100")
Message-ID: <8737rirgbz.fsf@toke.dk> (sfid-20160322_105125_136229_3F347075)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> traffic-gen generates only BE traffic. Everything else runs UDP_RR
> which doesn't generate a lot of traffic.

Good point. Fixed that: the newest git version of traffic-gen supports a
-t parameter which will be set as the TOS byte on outgoing traffic
(literal; no smart diffserv handling, so you can override the ECN bits
as well).

Added support for a burst-tos test parameter in the Flent burst test
configs which will use this new parameter if set.

-Toke
