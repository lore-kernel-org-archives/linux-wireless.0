Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60739 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2FIRkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 13:40:09 -0400
Received: by weyu7 with SMTP id u7so1218461wey.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jun 2012 10:40:08 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: BA session issue due to old BARs?
Date: Sat, 9 Jun 2012 19:40:03 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Sean Patrick Santos <quantheory@gmail.com>,
	linux-wireless@vger.kernel.org
References: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com> <201206091623.25232.chunkeey@googlemail.com> <4FD363E8.9090508@openwrt.org>
In-Reply-To: <4FD363E8.9090508@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201206091940.04037.chunkeey@googlemail.com> (sfid-20120609_194054_528909_E2B5AF5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 09 June 2012 16:55:36 Felix Fietkau wrote:
> On 2012-06-09 4:23 PM, Christian Lamparter wrote:
>> On Saturday 09 June 2012 14:20:48 Helmut Schaa wrote:
>>> On Sat, Jun 9, 2012 at 2:18 AM, Christian Lamparter wrote:
>>>> On Friday 08 June 2012 09:57:26 Sean Patrick Santos wrote:
>>>>> commit f0425beda4d404a6e751439b562100b902ba9c98
>>>>> Author: Felix Fietkau <nbd@openwrt.org>
>>>>> Date:   Sun Aug 28 21:11:01 2011 +0200
>>>>>
>>>>>     mac80211: retry sending failed BAR frames later instead of tearing down aggr
>>>>>
>>>> Or am I misinterpreting the commit and
>>>> this patch was just a temporary fix since back then mac80211
>>>> had problems with setting up BA session (and they might
>>>> have been fixed in the meantime?!).
>>> As far as I understood tearing down the BA session and then
>>> starting it again has a much higher impact onto throughput
>>> then just resending the BAR after the next successfully sent
>>> AMPDU.
>> Well, at least in case of carl9170 it looks like the resending
>> BARs are confusing the receiver reorder buffer on the other 
>> HT peer. Since it looks like the HT peer dump hardware is still
>> ACKs incoming frames from a carl9170 station, but the software
>> reorder buffer on the HT peer is silently dropping the data frames.
>> [Of course, data frames from other TIDs, MGMT (probes) or null-
>> frames are not reordered... so the connection polling with
>> null-frames does not detect the bad state and won't try to
>> recover).
> I think we need to figure out what exactly confuses the receiver reorder
> buffer of a HT peer. It sounds to me like something is causing a gap in
> sequence number allocation, but I don't know what would do that. Where
> exactly is the connection between BAR retransmission and those reorder
> issues?
The connection is that before the patch the BA session
was torn down when a BAR was not delivered successfully.
Now the code tries to revive the stalled BA sessions by
sending BARs (which at least according to the spec
should work fine as long as the BA session is still active?!).

I guess part of the problem is the implementation of
"11.5.3 Error recovery upon a peer failure" in both peers.
In order to debug this, it would be great to know how the
peers handle a injected frame that has the ACK policy
set to Block ACK but without an active session.
802.11-2007 11.5.3 says (under figure 11-14) that the
frame should be discarded and the receiver has to send
a DELBA. However in mac80211 case (if I didn't miss any
code), the frame is not discarded (in fact it will go
though the rx path unreordered - code is in mac80211/rx.c,
func: ieee80211_rx_reorder_ampdu) and no delba is sent
either... so there's some potential from similar 
"undefinied" behavior in other stacks as well.

Regards,
	Christian
