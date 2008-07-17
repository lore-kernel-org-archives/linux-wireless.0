Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:37322 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220AbYGQNfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 09:35:39 -0400
Received: by ti-out-0910.google.com with SMTP id b6so3333720tic.23
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2008 06:35:38 -0700 (PDT)
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
	RCU.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Patrick McHardy <kaber@trash.net>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <487F4327.1000107@trash.net>
References: <20080717.051726.226040470.davem@davemloft.net>
	 <487F4327.1000107@trash.net>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 09:35:32 -0400
Message-Id: <1216301732.4726.26.camel@localhost> (sfid-20080717_153548_823744_3C6B58F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-17-07 at 15:03 +0200, Patrick McHardy wrote:

> Actions are also visible
> globally, so this might still be a problem, not sure though since
> they don't refer to their parent (haven't thought about it much yet).

Actions are fine because they are intended to be globaly shared.
[i.e A classifier on ethx with qdiscA:Y (in/egress) can share an action
with  classifer on  ethy with qdiscB:Z (eg/ingress)].
Like you i need to digest the patches to understand the impact on the
rest but one thing i did notice was the last patch (replacement of
pfifo_fast):
prioritization based on TOS/DSCP (setsockopt) would no longer work, some
user space code may suffer (routing daemons likely). One suggestion to
fix it is to load pfifo qdisc (which does what fifo_fast is attempting)
for drivers that are h/ware multiq capable.

cheers,
jamal

