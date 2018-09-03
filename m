Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59854 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbeICO7F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 10:59:05 -0400
Message-ID: <1535971161.3437.49.camel@sipsolutions.net> (sfid-20180903_123934_458010_D1E8B55D)
Subject: Re: [PATCH] ath10k: add dynamic vlan support
From: Johannes Berg <johannes@sipsolutions.net>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>
Date: Mon, 03 Sep 2018 12:39:21 +0200
In-Reply-To: <80f8e88e5161f2731e67e1c0e1d7225c@codeaurora.org>
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
         <87r2n5auvq.fsf@kamboji.qca.qualcomm.com>
         <aa04534d-9677-f42e-a239-b230093ef2f5@dd-wrt.com>
         <f8d6d13943ccac22f363d7d4f53d645c@codeaurora.org>
         <1526637270.3805.15.camel@sipsolutions.net>
         <59ff8201-fc1b-8579-d5a9-f4b08621f5ec@codeaurora.org>
         <1527069018.3759.15.camel@sipsolutions.net>
         <eede64cf-ecf3-6697-a338-b7eb4c9bcd27@codeaurora.org>
         <1534408023.3547.64.camel@sipsolutions.net>
         <80f8e88e5161f2731e67e1c0e1d7225c@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry ... this got delayed again.

> I had introduced a change db3bdcb9c3ff (" mac80211: allow AP_VLAN 
> operation on crypto controlled devices ") for supporting VLAN 
> functionality on ath10k devices; this commit has broken 4 addr support 
> on ath10k devices as I was advertising the AP/VLAN support 
> conditionally. Since 4 addr operation is tied to AP/VLAN support, with 
> this change, only the chips which support VLAN functionality can support 
> 4 addr operation but other ath10k chips don't.

Right.

>  From what I can understand from our previous discussions, we had to 
> separate the 4addr support from the AP/VLAN iftype but doing so could 
> lead to backward compatibility issues. I have the code which separates 
> the 4addr functionality from AP/VLAN but the bigger problem is the 
> backward compatibility.

Ok.

> I am hoping that now I have set the context correctly :)

Thanks!

> > I think we have to keep the 4-addr handling in AP_VLAN iftype either
> > way, to not break existing hostapd. We could introduce a separate
> > AP_VLAN_NO_4ADDR and then require updating hostapd to get non-4addr
> > VLAN, but that also seems awkward.
> > 
> > Since hostapd doesn't currently check anything...
> > 
> > Ok, no, I'm confused now. If we just clear WIPHY_FLAG_4ADDR_AP, don't 
> > we
> > get what we want? 4-addr AP_VLAN interfaces would no longer be 
> > permitted
> > to be created?
> 
> As I explained above, the agenda is to provide the driver (in this case, 
> ath10k) a better control for advertising the device capabilities; only 
> few ath10k chips can support VLAN functionality but all of them can 
> support 4 addr operation.

So the problematic part isn't actually the *4-addr* (fake) VLAN, the
problematic part is the actual AP_VLAN - I suppose because that uses a
separate GTK.


So I guess the only, mostly backward compatible way to really separate
the two would be to

1) move WIPHY_FLAG_4ADDR_{AP,STATION} to be nl80211 ext feature flags,
   I guess the STATION always should've been since there's nothing that
   indicates support for it today in the API

along with one of:

2a) Add a new AP_VLAN ext feature flag that indicates the AP_VLAN is not
    only supported for 4-addr

2b) Allow creating an AP_VLAN interface in 4-addr mode in 
    nl80211_new_interface() even when AP_VLAN is not in the supported
    interface combinations, if (and only if) WIPHY_FLAG_4ADDR_AP is set
    (or rather the new extended feature flag after doing 1). Update the
    language in the documentation somewhere indicating this.


Hostapd clearly deals with both 2a and 2b since it never bothers to
check the combinations. As a result, I prefer 2b rather than 2a since it
doesn't add any weird combinations to the API that would be impossible.

johannes
