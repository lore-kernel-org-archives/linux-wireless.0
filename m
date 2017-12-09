Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:38440 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdLITx7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Dec 2017 14:53:59 -0500
Message-ID: <1512849236.26976.43.camel@sipsolutions.net> (sfid-20171209_205402_924382_E592C107)
Subject: Re: Setting TX power on a monitoring interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter =?ISO-8859-1?Q?Gro=DFe?= <pegro@friiks.de>,
        linux-wireless@vger.kernel.org
Date: Sat, 09 Dec 2017 20:53:56 +0100
In-Reply-To: <20171201183446.2c5f8504@fem-net.de> (sfid-20171201_183454_527148_F6A8C87B)
References: <20171120173415.1ae44829@fem-net.de>
         <1511782993.5456.6.camel@sipsolutions.net>
         <20171127160722.4969cd23@friiks.de>
         <1512139742.25588.14.camel@sipsolutions.net>
         <20171201183446.2c5f8504@fem-net.de> (sfid-20171201_183454_527148_F6A8C87B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

(side note - I might reply faster if you don't drop me from Cc, since
then it goes to my inbox in addition to my list folder)

> > I meant to pass the &monitor_sdata.vif pointer instead of the real
> > monitor interface that's coming through cfg80211. The former is virtual
> > and has no netdev, but the diver is aware of it.
> 
> I'm not sure I get where to pass this to what. Do you mean in
> drv_bss_info_changed or ieee80211_set_tx_power?

Should be in ieee80211_set_tx_power, if the interface is you're getting
in (dev/sdata) is MONITOR. You need to do the right locking (or may
already have rtnl, check in nl80211.c) to get local->monitor_sdata, and
then reject the call if that is NULL or pass it through with that sdata
(or the vif from it)

> Assuming you meant ieee80211_set_tx_power, then I'd have to check whether wdev
> is a monitor interface and reject the configuration, if local->monitor_sdata
> doesn't exist?

Right.

> But in ieee80211_set_tx_power no vif pointers get handed around, so I'm
> confused. Sorry.

You have a wdev, that's equivalent. See the "if (wdev)" clause that
gets an sdata from the wdev, and then you have &sdata->vif as the vif.

johannes
