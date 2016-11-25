Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:19850 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755107AbcKYRNX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 12:13:23 -0500
Date: Fri, 25 Nov 2016 17:06:10 +0000
From: Jakub Kicinski <kubakici@wp.pl>
To: Anthony Romano <anthony.romano@coreos.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: wait for clear rxq when stopping mac
Message-ID: <20161125170610.05f06260@jkicinski-Precision-T1700> (sfid-20161125_181352_549645_6E223B77)
In-Reply-To: <20161125111334.31085-1-anthony.romano@coreos.com>
References: <20161125111334.31085-1-anthony.romano@coreos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 25 Nov 2016 03:13:34 -0800, Anthony Romano wrote:
> mt7601u_mac_stop_hw should stop polling the rxq once it remains empty
> but instead continues polling after the rxq status stays clear; bringing
> down the interface takes about six seconds from this alone.
> 
> Speed up path by exiting rxq loop once status repeatedly polls empty.
> 
> Signed-off-by: Anthony Romano <anthony.romano@coreos.com>

Looks correct, the condition was inverted and we don't have to
msleep() when we see values go to zero.  Thanks!

Reviewed-by: Jakub Kicinski <kubakici@wp.pl>
