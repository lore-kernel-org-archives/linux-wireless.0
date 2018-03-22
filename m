Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52122 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751964AbeCVK2Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 06:28:16 -0400
Message-ID: <1521714493.19621.5.camel@sipsolutions.net> (sfid-20180322_112856_188603_3297E89A)
Subject: Re: [RFC v5 0/9] EAPoL over NL80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Thu, 22 Mar 2018 11:28:13 +0100
In-Reply-To: <6c4a389a-55e1-5af2-cac2-1754fce7fabf@gmail.com> (sfid-20180321_161830_319006_32337E45)
References: <20180313215942.29176-1-denkenz@gmail.com>
         <1521645199.2645.34.camel@sipsolutions.net>
         <6c4a389a-55e1-5af2-cac2-1754fce7fabf@gmail.com>
         (sfid-20180321_161830_319006_32337E45)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-21 at 10:18 -0500, Denis Kenzior wrote:
> 
> Sorry.  I assumed people read the change log :)

And I should :-)

> > > - It is unclear to me how AP_VLAN and AP interfaces should synchronize on
> > > conn_owner_nlportid.  This is required for tx_control_port to work.
> > 
> > I'm not really sure what you mean? Technically I guess an AP_VLAN could
> > have a different owner from an AP, but if the AP goes down all the
> > AP_VLANs go down with it already anyway.
> 
> So the issue is that when mac80211 calls cfg80211_rx_control_port and 
> subsequently __nl80211_rx_control_port, we grab the nlportid from the 
> wdev.  So if that isn't synchronized, then AP_VLAN devices won't be 
> sending the EAPoL frames to the right place.

Oh, ok, gotcha. I guess mac80211 would have to sync over the data, just
like it does for other things? You also copied over the
control_port_over_nl80211 setting, so could do the same here?

But no, maybe that doesn't make sense, since ...

Hmm. Ok, I think I see what you're getting at.

The key point seems to be that we don't have any sort of "add VLAN to
AP operation" - it's auto-detected based on the MAC address.

However, it doesn't actually matter at all - we shouldn't get there
with VLAN interface. EAPOL frames are always sent out to the
corresponding AP interface, see ieee80211_rx_h_data:

        if (rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
            unlikely(port_control) && sdata->bss) {
                sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
                                     u.ap);
                dev = sdata->dev;
                rx->sdata = sdata;
        }


> > > - JOIN_IBSS & JOIN_MESH don't seem to support control_port_ethertype or
> > > control_port_no_encrypt.  Should struct cfg80211_crypto_settings parsed inside
> > > nl80211_crypto_settings be added to ibss_params or mesh_config/mesh_setup?
> > 
> > I don't think it matters - they just don't support this now and don't
> > really need to.
> > 
> 
> Except that the eapol over nl80211 flag is being sent in security 
> settings.  This covers STA/AP/P2P_GO/P2P_CLIENT.  We need some way of 
> passing this information for mesh & ibss.

Not sure I understand what you're saying. Can't we just say the flag
isn't permitted in those modes?

johannes
