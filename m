Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52647 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1H3Vr0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 17:47:26 -0400
Subject: Re: BQL crap and wireless
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=US-ASCII
From: Andrew McGregor <andrewmcgr@gmail.com>
In-Reply-To: <4E5CEC79.3090802@freedesktop.org>
Date: Wed, 31 Aug 2011 09:47:19 +1200
Cc: Adrian Chadd <adrian@freebsd.org>,
	Tom Herbert <therbert@google.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dave Taht <dave.taht@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matt Smith <smithm@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Derek Smithies <derek@indranet.co.nz>, netdev@vger.kernel.org
Message-Id: <9BB251C1-A211-486D-A717-59149AC3A709@gmail.com> (sfid-20110830_234734_995444_6CAFAB2F)
References: <CAB=NE6VuP=AvYiJsYn_Noc1u0Q=jvQPutHRANdSiLP2v48ogfg@mail.gmail.com> <CAB=NE6VwWu5+Hk7=3ghkgiXss9kCqGyS-RWPYtyHRhDsx5r2rA@mail.gmail.com> <CAA93jw7c+Nxc6ZbWZWsQ+F78AoPWU=quSRaOUpT0yRcwJOXsGQ@mail.gmail.com> <4E5C3B47.1050809@freedesktop.org> <CA+mtBx-j_+mrNpntR7CfYOromDnM-ZGzvebpUCjC8Qf14X6u9g@mail.gmail.com> <CAJ-Vmonwur-SXddNwjPEidCMqes+PwbRWFBddfdwTp2jOMu64g@mail.gmail.com> <4E5CEC79.3090802@freedesktop.org>
To: Jim Gettys <jg@freedesktop.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 31/08/2011, at 1:58 AM, Jim Gettys wrote:

> On 08/29/2011 11:42 PM, Adrian Chadd wrote:
>> On 30 August 2011 11:34, Tom Herbert <therbert@google.com> wrote:
>> 
>> C(P) is going to be quite variable - a full frame retransmit of a 4ms
>> long aggregate frame is SUM(exponential backoff, grab the air,
>> preamble, header, 4ms, etc. for each pass.)
>> 
> It's not clear to me that doing heroic measures to compute the cost is
> going to be worthwhile due to the rate at which the costs can change on
> wireless; just getting into the rough ballpark may be enough. But
> buffering algorithms and AQM algorithms are going to need an estimate of
> the *time* it will take to transmit data, more than # of bytes or packets.

That's not heroic measures; mac80211 needs all the code to calculate these times anyway, it's just a matter of collecting together some things we already know and calling the right function.

Andrew