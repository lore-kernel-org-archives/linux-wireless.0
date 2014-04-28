Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40493 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbaD1PsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 11:48:07 -0400
Message-ID: <1398700073.4132.2.camel@jlt4.sipsolutions.net> (sfid-20140428_174814_416360_55194A76)
Subject: Re: [PATCH 2/3] mac80211: Support dynamic AP mode channel width
 changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 28 Apr 2014 17:47:53 +0200
In-Reply-To: <1398699982.4132.1.camel@jlt4.sipsolutions.net> (sfid-20140428_174647_065920_FAF317DA)
References: <20140428082225.GA15459@jouni.qca.qualcomm.com>
	 <CA+BoTQ=gP49PDuyYovQmc-jtFwKN6JDOToSsT20ssnJZGaqieQ@mail.gmail.com>
	 (sfid-20140428_105724_959492_6ACA3997) <1398699982.4132.1.camel@jlt4.sipsolutions.net>
	 (sfid-20140428_174647_065920_FAF317DA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-28 at 17:46 +0200, Johannes Berg wrote:

> > Shouldn't interface combinations be verified here? What if there was a
> > bandwidth upgrade (after a downgrade) but in the meantime a vif with a
> > to-be incompatible chandef was brought up?
> 
> Yeah that seems like a potential issue.

Hm, wait, isn't this addressed by this code in
ieee80211_vif_change_bandwidth():

        ctx = container_of(conf, struct ieee80211_chanctx, conf);
        if (!cfg80211_chandef_compatible(&conf->def, chandef)) { 
                ret = -EINVAL;
                goto out;
        }

johannes

