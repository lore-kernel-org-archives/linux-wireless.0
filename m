Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62497 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933098Ab2JXRZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 13:25:17 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so383574wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 10:25:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D075EC214@RockMX01.rock.corp>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D075EC214@RockMX01.rock.corp>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 24 Oct 2012 10:24:55 -0700
Message-ID: <CAG6hwVNuijKqzNnyQMS9dxvRy3YdxuY_WkJ+k5L18yXc7jHe_Q@mail.gmail.com> (sfid-20121024_192527_211547_BF2924DC)
Subject: Re: 802.11s bug in ieee80211_rx_h_mesh_fwding() result in bogus MAC
 in mpp table
To: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chaoxing,

On Wed, Oct 24, 2012 at 9:36 AM, Chaoxing Lin
<Chaoxing.Lin@ultra-3eti.com> wrote:
> And mpp table grows fast, which can affect mpp lookup efficiency severely.
>
> Here is the problem (code line number is based on 3.6.3 kernel)
>
> It happens when user turns on encryption.
>
>
> 1835 #ifdef CONFIG_MAC80211_MESH
> 1836 static ieee80211_rx_result
> 1837 ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
> 1838 {
> ...
> 1849
> 1850     hdr = (struct ieee80211_hdr *) skb->data;
> 1851     hdrlen = ieee80211_hdrlen(hdr->frame_control);
> 1852     mesh_hdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
> ...
> 1865
> 1866     if (mesh_hdr->flags & MESH_FLAGS_AE) {             //CLIN: mesh_hdr is pointed at ENCRYPTED part
>                                                             // if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
> 1867         struct mesh_path *mppath;
> 1868         char *proxied_addr;
> 1869         char *mpp_addr;
> 1870
> 1871         if (is_multicast_ether_addr(hdr->addr1)) {
> 1872             mpp_addr = hdr->addr3;
> 1873             proxied_addr = mesh_hdr->eaddr1;           //CLIN: deference random data result in random MAC for proxied_addr
> 1874         } else {
> 1875             mpp_addr = hdr->addr4;
> 1876             proxied_addr = mesh_hdr->eaddr2;           //CLIN: deference random data result in random MAC for proxied_addr
> 1877         }
> 1878
> 1879         rcu_read_lock();
> 1880         mppath = mpp_path_lookup(proxied_addr, sdata);
> 1881         if (!mppath) {
> 1882             mpp_path_add(proxied_addr, mpp_addr, sdata);  //CLIN: mpp table grows fast, almost as fast as packet in air
> 1883         } else {
> 1884             spin_lock_bh(&mppath->state_lock);
> 1885             if (!ether_addr_equal(mppath->mpp, mpp_addr))
> 1886                 memcpy(mppath->mpp, mpp_addr, ETH_ALEN);
> 1887             spin_unlock_bh(&mppath->state_lock);
> 1888         }
> 1889         rcu_read_unlock();
> 1890     }

<snip>

> The cure is to move below early in this function when packet is encrypted.
>
> 1904     if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
> 1905         goto out;

Yes, I think it makes sense to put that check early in the function.
All forwarded frames need to pass that condition anyway.

Will you submit a proper patch for this?

Thomas
