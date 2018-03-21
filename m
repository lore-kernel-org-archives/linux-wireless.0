Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37828 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752305AbeCUPNV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 11:13:21 -0400
Message-ID: <1521645199.2645.34.camel@sipsolutions.net> (sfid-20180321_161324_987647_BDE617BF)
Subject: Re: [RFC v5 0/9] EAPoL over NL80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 21 Mar 2018 16:13:19 +0100
In-Reply-To: <20180313215942.29176-1-denkenz@gmail.com> (sfid-20180313_225956_569645_D245D7F9)
References: <20180313215942.29176-1-denkenz@gmail.com>
         (sfid-20180313_225956_569645_D245D7F9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> TODO:

That was well-hidden :)

> - It is unclear to me how AP_VLAN and AP interfaces should synchronize on
> conn_owner_nlportid.  This is required for tx_control_port to work.

I'm not really sure what you mean? Technically I guess an AP_VLAN could
have a different owner from an AP, but if the AP goes down all the
AP_VLANs go down with it already anyway.

> - JOIN_IBSS & JOIN_MESH don't seem to support control_port_ethertype or
> control_port_no_encrypt.  Should struct cfg80211_crypto_settings parsed inside
> nl80211_crypto_settings be added to ibss_params or mesh_config/mesh_setup?

I don't think it matters - they just don't support this now and don't
really need to.

johannes
