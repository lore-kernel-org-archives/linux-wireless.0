Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37458 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751124AbcITNS5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 09:18:57 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: RE: [PATCH v2] mwifiex: cfg80211 set_default_mgmt_key handler
Date: Tue, 20 Sep 2016 13:18:53 +0000
Message-ID: <68d7c32ee705411685541bf49553f4d3@SC-EXCH04.marvell.com> (sfid-20160920_151901_176829_5831E401)
References: <1473428038-15308-1-git-send-email-akarwar@marvell.com>
 <87twdictrh.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87twdictrh.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Wednesday, September 14, 2016 10:18 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Nishant Sarmukadam; Ganapathi Bhat
> Subject: Re: [PATCH v2] mwifiex: cfg80211 set_default_mgmt_key handler
> 
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > From: Ganapathi Bhat <gbhat@marvell.com>
> >
> > Previously device used to start using IGTK key as Tx key as soon as it
> > gets downloaded in add_key(). This patch implements
> > set_default_mgmt_key handler. We will update Tx key ID in
> set_default_mgmt_key().
> >
> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> > Changes in v2: v1 had a dummy handler. v2 addresses a corner case
> > problem pointed by Jouni in which AP may send frames encrypted with
> > new key when some of the stations are still using old key.
> > ---
> >  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 25
> +++++++++++++++++++++++++
> >  drivers/net/wireless/marvell/mwifiex/fw.h       |  1 +
> >  drivers/net/wireless/marvell/mwifiex/ioctl.h    |  1 +
> >  drivers/net/wireless/marvell/mwifiex/sta_cmd.c  |  5 +++++
> >  4 files changed, 32 insertions(+)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > index 0a03d3f..33e7a74 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> > @@ -484,6 +484,30 @@ mwifiex_cfg80211_add_key(struct wiphy *wiphy,
> > struct net_device *netdev,  }
> >
> >  /*
> > + * CFG802.11 operation handler to set default mgmt key.
> > + */
> > +static int
> > +mwifiex_cfg80211_set_default_mgmt_key(struct wiphy *wiphy,
> > +				      struct net_device *netdev,
> > +				      u8 key_index)
> > +{
> > +	struct mwifiex_private *priv = mwifiex_netdev_get_priv(netdev);
> > +	struct mwifiex_ds_encrypt_key encrypt_key;
> > +	const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
> 
> This should be static const, but...
> 
> > +	wiphy_dbg(wiphy, "set default mgmt key, key index=%d\n",
> key_index);
> > +
> > +	memset(&encrypt_key, 0, sizeof(struct mwifiex_ds_encrypt_key));
> > +	encrypt_key.key_len = WLAN_KEY_LEN_CCMP;
> > +	encrypt_key.key_index = key_index;
> > +	encrypt_key.is_igtk_def_key = true;
> > +	ether_addr_copy(encrypt_key.mac_addr, bc_mac);
> 
> ...can't you use eth_broadcast_addr() here?
> 

Thanks. We have used eth_broadcast_addr() in updated version.

Regards,
Amitkumar Karwar
