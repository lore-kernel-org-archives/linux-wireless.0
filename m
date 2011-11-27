Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49099 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1K0JsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 04:48:09 -0500
MIME-Version: 1.0
Date: Sun, 27 Nov 2011 10:48:09 +0100
Message-ID: <CAA93jw7zdM6+36CnvzcYoSjyMxP+myoX46JSzCGwg7jC5OnwcQ@mail.gmail.com> (sfid-20111127_104816_013405_138DB72B)
Subject: timestamping at the mac80211 layer before it hits tc?
From: Dave Taht <dave.taht@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	bloat-devel <bloat-devel@lists.bufferbloat.net>,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My crazy idea at the moment is that since things can spend inordinate
amounts of time in the txqueue in wireless in particular, that moving
(tcp and packet) timestamping to where it enters the queue rather than
hits the wireless device would make a difference. Unless that's
already how it works.

http://www.bufferbloat.net/issues/304#change-1186

The secondary fallout of that is an easier way to expire (probably
rescheduled) packets that have spent too much time in queue.

Eric had put up a (rfc) tc filter a while back that dumped a timestamp
into the private block of the skb...

but...

I kind of like the idea of reusing the existing hwtstamps concept for
the period "queue entrance to queue exit", as a queue is a 'device',
IMHO.

from linux/skbuff.h

* hwtstamps can only be compared against other hwtstamps from
* the same device.
*
* This structure is attached to packets as part of the
* &skb_shared_info. Use skb_hwtstamps() to get a pointer.
*/
struct skb_shared_hwtstamps {
       ktime_t hwtstamp;
       ktime_t syststamp;
};


Sign me,
lost in a myriad of data paths on a sunday afternoon, wearing an asbestos suit

--
Dave Täht
SKYPE: davetaht
http://www.bufferbloat.net
