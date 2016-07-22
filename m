Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:42591 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbcGVKvL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 06:51:11 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	Dave Taht <dave@taht.net>
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
Date: Fri, 22 Jul 2016 12:51:05 +0200
In-Reply-To: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name> (Felix Fietkau's
	message of "Tue, 12 Jul 2016 12:09:24 +0200")
Message-ID: <87twfilzdy.fsf@toke.dk> (sfid-20160722_125114_904548_4AC91274)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> Please let me know if you have any ideas.

Two more things to try:

- Andrew McGregor mentioned that some versions of Iperf on OSX has a
  threading bug when running multiple streams against the same server
  instance. So try running two separate instances of iperf on the server
  side, or run netperf instead.

- It could be that HyStart is acting up. You could try disabling it
  (echo 0 > /sys/module/tcp_cubic/parameters/hystart) and see if that
  makes a difference.

-Toke
