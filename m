Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37322 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933053AbeFTIpS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 04:45:18 -0400
Message-ID: <1529481182.3130.2.camel@sipsolutions.net> (sfid-20180620_104526_250014_56F73AA1)
Subject: Re: [PATCH] mac80211: Fix oops in ieee80211_tx_control_port
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Denis Kenzior <denkenz@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2018 09:53:02 +0200
In-Reply-To: <5B2A0772.4060200@broadcom.com> (sfid-20180620_095116_985132_88265637)
References: <20180619153950.28903-1-denkenz@gmail.com>
         <5B2A0772.4060200@broadcom.com> (sfid-20180620_095116_985132_88265637)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-06-20 at 09:51 +0200, Arend van Spriel wrote:
> On 6/19/2018 5:39 PM, Denis Kenzior wrote:
> > On pre-emption enabled kernels the following oops was being seen due
> > to missing local_bh_disable/local_bh_enable calls.  mac80211 assumes
> > that pre-emption is disabled in the data path.
> 
> No sure if "assumes" is the right term here. It seems like it is
> required and there is probably a good reason for that. Would be nice to
> know what that reason is.

It's using per-CPU data.

johannes
