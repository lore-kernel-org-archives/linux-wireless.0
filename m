Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:32841 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932361AbcJSO1M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 10:27:12 -0400
Received: by mail-qt0-f171.google.com with SMTP id s49so21736292qta.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2016 07:27:11 -0700 (PDT)
Date: Wed, 19 Oct 2016 10:27:06 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Simon Kelley <simon@thekelleys.org.uk>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: Re: [PATCH net-next 2/6] net: use core MTU range checking in
 wireless drivers
Message-ID: <20161019142706.GE18569@redhat.com> (sfid-20161019_162756_990590_D8FEE296)
References: <20161019023333.15760-1-jarod@redhat.com>
 <20161019023333.15760-3-jarod@redhat.com>
 <1476862713.5927.0.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1476862713.5927.0.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 19, 2016 at 09:38:33AM +0200, Johannes Berg wrote:
> On Tue, 2016-10-18 at 22:33 -0400, Jarod Wilson wrote:
> > - set max_mtu in wil6210 driver
> > - set max_mtu in atmel driver
> > - set min/max_mtu in cisco airo driver, remove airo_change_mtu
> > - set min/max_mtu in ipw2100/ipw2200 drivers, remove
> > libipw_change_mtu
> > - set min/max_mtu in p80211netdev, remove wlan_change_mtu
> 
> I guess we should do the same in net/mac80211/iface.c?

Yeah. I thought I'd located all places this needed to happen, but
obviously not. I'll get this added and do another sweep for others I might
have missed.

-- 
Jarod Wilson
jarod@redhat.com
