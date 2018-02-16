Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:11343 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750797AbeBPWiS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 17:38:18 -0500
Date: Fri, 16 Feb 2018 14:38:08 -0800
From: Jakub Kicinski <kubakici@wp.pl>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mt7601u: make write with mask access atomic
Message-ID: <20180216143808.7d95b9c0@cakuba.netronome.com> (sfid-20180216_233821_994410_DD329715)
In-Reply-To: <4a8ec536fda4741ef88618493d0641fbd497314c.1518819577.git.lorenzo.bianconi@redhat.com>
References: <cover.1518819577.git.lorenzo.bianconi@redhat.com>
        <4a8ec536fda4741ef88618493d0641fbd497314c.1518819577.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Feb 2018 23:30:01 +0100, Lorenzo Bianconi wrote:
> Introduce __mt7601u_rr and __mt7601u_vendor_single_wr routines in order
> to make mt7601u_rmw and mt7601u_rmc atomic. This patch does not fix a
> reported issue but makes the usb access more robust to concurrent
> operations on the same register since it is theoretically possible that
> read and write accesses of mt7601u_rmw/mt7601u_rmc can be interleaved with
> a different write operation on the same register.
> Moreover using __mt7601u_rr and __mt7601u_vendor_single_wr in
> mt7601u_rmw/mt7601u_rmc allows to grab vendor_req_mutex mutex once
> instead of twice
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>

Thanks!
