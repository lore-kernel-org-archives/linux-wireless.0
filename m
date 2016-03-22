Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38459 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbcCVGvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 02:51:08 -0400
Received: by mail-wm0-f43.google.com with SMTP id l68so149384749wml.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2016 23:51:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1603211830000.26766@nftneq.ynat.uz>
References: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
	<1458123478-1795-2-git-send-email-michal.kazior@tieto.com>
	<alpine.DEB.2.02.1603211830000.26766@nftneq.ynat.uz>
Date: Tue, 22 Mar 2016 07:51:06 +0100
Message-ID: <CA+BoTQ=PWCK6cq83sthqRRt0xYWBOORbb=0+QHM6XVaWCWVhDw@mail.gmail.com> (sfid-20160322_075116_391823_A3F2F0BC)
Subject: Re: [Make-wifi-fast] [RFCv2 1/3] mac80211: implement fq_codel for
 software queuing
From: Michal Kazior <michal.kazior@tieto.com>
To: David Lang <david@lang.hm>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Network Development <netdev@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	codel@lists.bufferbloat.net, make-wifi-fast@lists.bufferbloat.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Tim Shepard <shep@alum.mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 March 2016 at 02:35, David Lang <david@lang.hm> wrote:
> On Wed, 16 Mar 2016, Michal Kazior wrote:
>
>> Since 11n aggregation become important to get the
>> best out of txops. However aggregation inherently
>> requires buffering and queuing. Once variable
>> medium conditions to different associated stations
>> is considered it became apparent that bufferbloat
>> can't be simply fought with qdiscs for wireless
>> drivers.
>
> If the network is quiet enough, don't do any buffering, but in almost all
> situations you are going to need to buffer starting no later than the second
> packet you try to send.
>
> Don't try to make queueing occur, just deal with the queues that form
> naturally because you can't transmit data any faster (and work to keep them
> under some semblence of control)
[...]

This is what already happens. Queues typically start to build up when
hardware tx fifos/queues become busy so by the time they become
available you might have a bunch of frames you can aggregate.

The patch is more about getting rid of qdiscs because it's inherently
hard to teach them how 802.11 aggregation works (per-station per-tid)
and the ever-changing nature of per-station tx conditions.

I'll update the commit log to better reflect what is being done.


Michał
