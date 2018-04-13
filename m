Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:43541 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751771AbeDMSGk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 14:06:40 -0400
Date: Fri, 13 Apr 2018 11:06:34 -0700
From: Jakub Kicinski <kubakici@wp.pl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mt7601u: use EWMA to calculate avg_rssi
Message-ID: <20180413110634.6942f0f0@cakuba.netronome.com> (sfid-20180413_200643_727923_27F64F63)
In-Reply-To: <1523630678-8100-1-git-send-email-sgruszka@redhat.com>
References: <1523630678-8100-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 13 Apr 2018 16:44:37 +0200, Stanislaw Gruszka wrote:
> avr_rssi is not calculated correctly as we do not divide result
> by 256 (mt76 sum avg_rssi1 and avg_rssi2 and divide by 512).
> However dividing by 256 will make avg_rssi almost the same as
> last rssi value - not really an average. So use EWMA to calculate
> avg_rssi. I've chosen weight_rcp=4 to convergence quicker on signal
> strength changes.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
