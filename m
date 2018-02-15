Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:31260 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164330AbeBOXOx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 18:14:53 -0500
Date: Thu, 15 Feb 2018 15:14:45 -0800
From: Jakub Kicinski <kubakici@wp.pl>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: make write with mask access atomic
Message-ID: <20180215151445.52e08b03@cakuba.netronome.com> (sfid-20180216_001457_230184_E926C095)
In-Reply-To: <5bb3bb069bdd4663b69b60b782432c2faddc1efc.1518734856.git.lorenzo.bianconi@redhat.com>
References: <cover.1518734856.git.lorenzo.bianconi@redhat.com>
        <5bb3bb069bdd4663b69b60b782432c2faddc1efc.1518734856.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 15 Feb 2018 23:59:24 +0100, Lorenzo Bianconi wrote:
> Introduce __mt7601u_rr and __mt7601u_vendor_single_wr routines in order
> to make mt7601u_rmw and mt7601u_rmc atomic since it is possible that
> read and write accesses of mt7601u_rmw/mt7601u_rmc can be interleaved
> with a different write operation on the same register.
> Moreover move write trace point in __mt7601u_vendor_single_wr
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Could you provide an example of which accesses make it problematic?
Is this fixing an actual bug?
