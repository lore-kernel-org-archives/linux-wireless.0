Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59467 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1BWFet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 00:34:49 -0500
Received: by wwb39 with SMTP id 39so1127573wwb.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 21:34:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298390485.2575.6.camel@gnutoo-laptop>
References: <1298390485.2575.6.camel@gnutoo-laptop>
Date: Wed, 23 Feb 2011 11:04:47 +0530
Message-ID: <AANLkTin0ixVQJA6B6Et1AUqdkhu1b+hv6Gxu_SQWEMzD@mail.gmail.com>
Subject: Re: ath9k stopped queue bug
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 22, 2011 at 9:31 PM, Denis 'GNUtoo' Carikli
<GNUtoo@no-log.org> wrote:
> Hi,
>
> When I transfer large files at high speed(rsync to my x86 router,
> locally, not trough the Internet) I get:
> ping: sendmsg: No buffer space available
>
> And I can't send anymore data.
>
> /sys/kernel/debug/ieee80211/phy*/queues is
> 00: 0x00000000/0
> 01: 0x00000000/0
> 02: 0x00000000/0
> 03: 0x00000000/0
> In normal conditions.
>
> But when I can't send anymore data I've that:
> 00: 0x00000000/0
> 01: 0x00000000/0
> 02: 0x00000001/0
> 03: 0x00000000/0
> or that:
> 00: 0x00000000/0
> 01: 0x00000000/0
> 02: 0x00000001/333
> 03: 0x00000000/0
>
>
> Here's my irc conversation in #linux-wireless on Freeenode about that
> issue:
>
> Feb 22 16:28:38 <GNUtoo|laptop> hi,
> Feb 22 16:29:23 <GNUtoo|laptop> when I rsync to my router at high speed
> over wifi, huge amount of data, I've that:
> Feb 22 16:29:24 <GNUtoo|laptop> ping: sendmsg: No buffer space available
> Feb 22 16:29:27 <GNUtoo|laptop> and wifi breaks
> Feb 22 16:29:30 <GNUtoo|laptop> I've to reconnect
> Feb 22 16:29:40 <GNUtoo|laptop> should I try setting a lower MTU?
> Feb 22 16:29:43 <GNUtoo|laptop> what should I try?
> Feb 22 16:29:53 <GNUtoo|laptop> and why isn't there any more buffer
> space?
> Feb 22 16:31:57 <johill>        sounds like a queue management bug
> Feb 22 16:32:06 <johill>        with packets stuck somewhere
> Feb 22 16:32:09 <johill>        what driver?
> Feb 22 16:34:04 *       an-t (~ant@srv1.gnpx.net) has joined #linux-wireless
> Feb 22 16:34:42 <GNUtoo|laptop> ath9k
> Feb 22 16:34:51 <GNUtoo|laptop> on 2.6.37-020637-generic
> Feb 22 16:34:57 <GNUtoo|laptop> I think that's mainline
> Feb 22 16:35:01 <GNUtoo|laptop> let me check
> Feb 22 16:35:02 <johill>        hm, dunno
> Feb 22 16:35:09 <johill>        there were some queue mgmt things there
> Feb 22 16:35:12 <johill>        don't really konw
> Feb 22 16:35:49 <Chainsaw>      GNUtoo|laptop: Probably useful to share your
> driver DDoS on linux-wireless; some idea of how many files & what size.
> Feb 22 16:36:10 <GNUtoo|laptop> basically what I do is that:
> Feb 22 16:36:20 <GNUtoo|laptop> I use openembedded to cross-compile
> files
> Feb 22 16:36:25 <GNUtoo|laptop> and sync the result with my router
> Feb 22 16:36:26 *       Blues-Man
> (~bluesman@host137-190-dynamic.43-79-r.retail.telecomitalia.it) has
> joined #linux-wireless
> Feb 22 16:36:35 <GNUtoo|laptop> that is an x86 computer with ath9k and
> hostapd
> Feb 22 16:36:52 <GNUtoo|laptop>
> cd /home/gnutoo/embedded/oe/oetmps/eee701/deploy/glibc
> Feb 22 16:36:56 <GNUtoo|laptop> rsync -av -e "ssh -l gnutoo -p 222" *
> router:/var/www/gnutoo.homelinux.org/openembedded/eee701
> Feb 22 16:37:05 <GNUtoo|laptop> is the script I use to sync it
> Feb 22 16:37:37 <johill>        I bet when this happens you never get a ping
> pcket through
> Feb 22 16:38:10 <johill>        and /sys/kernel/debug/ieee80211/phy*/queues is
> non-zero
> Feb 22 16:38:18 <johill>        the info from that file would be useful
> Feb 22 16:38:37 <GNUtoo|laptop> ok I was pastebining the file sizes
> Feb 22 16:38:41 <GNUtoo|laptop> as there are a lot of files....
> Feb 22 16:39:06 <GNUtoo|laptop> ok I'll try to reproduce
> Feb 22 16:39:13 <GNUtoo|laptop> tough that will disconnect me from irc
> Feb 22 16:40:54 <johill>        I bet it'll be 0x0001/n
> Feb 22 16:40:56 <johill>        n > 0
> Feb 22 16:42:16 <GNUtoo|laptop> ping also increase during the huge
> transfer
> Feb 22 16:42:30 <johill>        that's "bufferbloat" but expected now
> Feb 22 16:42:35 <GNUtoo|laptop> ok
> Feb 22 16:42:49 <GNUtoo|laptop> I learned what bufferbloat was not so
> long ago
> Feb 22 16:44:27 *       Topic for #linux-wireless is: User-level discussions
> about wireless LANs on Linux | compat-wireless-2.6 only available for
> kernels >= 2.6.27, work is underway to enable older kernels now that we
> don't use multiqueue on mac80211
> Feb 22 16:44:27 *       Topic for #linux-wireless set by linville at Wed Jul
> 8 21:06:20 2009
> Feb 22 16:44:30 <GNUtoo|laptop> it starts with
> Feb 22 16:44:32 <GNUtoo|laptop> 02: 0x00000001/0
> Feb 22 16:44:41 <GNUtoo|laptop> and then increase to
> Feb 22 16:44:47 <GNUtoo|laptop> 02: 0x00000001/333
> Feb 22 16:44:50 <GNUtoo|laptop> the reset is 0
> Feb 22 16:45:02 <johill>        yeah
> Feb 22 16:45:06 <johill>        as expected
> Feb 22 16:45:08 <GNUtoo|laptop> ok
> Feb 22 16:45:12 <GNUtoo|laptop> what's that exactly?
> Feb 22 16:45:19 <johill>        the reason why the queue is stopped
> Feb 22 16:45:23 <johill>        and the number of packets in the queue
> Feb 22 16:45:24 <GNUtoo|laptop> oh nice
> Feb 22 16:45:32 <johill>        0x000 == not stopped
> Feb 22 16:45:35 <GNUtoo|laptop> ok
> Feb 22 16:45:39 <GNUtoo|laptop> and what's the reason?
> Feb 22 16:45:41 <johill>         /0 = no packets
> Feb 22 16:45:54 <johill>        BIT(0) == driver asked for queue to be stopped
> Feb 22 16:46:03 <johill>        (IEEE80211_QUEUE_STOP_REASON_DRIVER)
> Feb 22 16:46:08 <GNUtoo|laptop> ok
> Feb 22 16:46:11 <johill>        (net/mac80211/ieee80211_i.h)
> Feb 22 16:46:15 <johill>        so driver's fault
> Feb 22 16:46:28 <GNUtoo|laptop> dmesg shows nothing tough
> Feb 22 16:46:37 <GNUtoo|laptop> only normal stuff
> Feb 22 16:46:38 <johill>        yeah not surprising either
> Feb 22 16:46:45 <GNUtoo|laptop> ah debugfs?
> Feb 22 16:46:47 <johill>        queue start/stop happens often enough, no
> logging for it
> Feb 22 16:46:50 <GNUtoo|laptop> or something like that should be used
> Feb 22 16:46:50 <GNUtoo|laptop> ok
> Feb 22 16:49:45 <GNUtoo|laptop> what should I do now?
> Feb 22 16:50:10 <johill>        report a bug on ath9k
>
please try with debug messages enabled sudo modprobe ath9k debug=0x2
(or)
sudo modprobe debug=0x82 (this produces lots of log)

> Denis.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
