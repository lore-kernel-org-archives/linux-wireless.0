Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:47879 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935233Ab2JXQgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 12:36:07 -0400
Received: from webmail.3eti.com (rockmx01.rock.corp [192.168.200.4]) by mail.ultra-3eti.com with ESMTP id dCrxzD4DkKjZmFK7 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 12:36:04 -0400 (EDT)
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 802.11s bug in ieee80211_rx_h_mesh_fwding() result in bogus MAC in
 mpp table
Date: Wed, 24 Oct 2012 16:36:02 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D075EC214@RockMX01.rock.corp> (sfid-20121024_183612_984599_ED993457)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And mpp table grows fast, which can affect mpp lookup efficiency severely.

Here is the problem (code line number is based on 3.6.3 kernel)

It happens when user turns on encryption.


1835 #ifdef CONFIG_MAC80211_MESH
1836 static ieee80211_rx_result
1837 ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
1838 {
...
1849 
1850     hdr = (struct ieee80211_hdr *) skb->data;
1851     hdrlen = ieee80211_hdrlen(hdr->frame_control);
1852     mesh_hdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
...
1865 
1866     if (mesh_hdr->flags & MESH_FLAGS_AE) {             //CLIN: mesh_hdr is pointed at ENCRYPTED part 
                                                            // if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
1867         struct mesh_path *mppath;
1868         char *proxied_addr;
1869         char *mpp_addr;
1870 
1871         if (is_multicast_ether_addr(hdr->addr1)) {
1872             mpp_addr = hdr->addr3;
1873             proxied_addr = mesh_hdr->eaddr1;           //CLIN: deference random data result in random MAC for proxied_addr
1874         } else {
1875             mpp_addr = hdr->addr4;
1876             proxied_addr = mesh_hdr->eaddr2;           //CLIN: deference random data result in random MAC for proxied_addr
1877         }
1878 
1879         rcu_read_lock();
1880         mppath = mpp_path_lookup(proxied_addr, sdata);
1881         if (!mppath) {
1882             mpp_path_add(proxied_addr, mpp_addr, sdata);  //CLIN: mpp table grows fast, almost as fast as packet in air
1883         } else {
1884             spin_lock_bh(&mppath->state_lock);
1885             if (!ether_addr_equal(mppath->mpp, mpp_addr))
1886                 memcpy(mppath->mpp, mpp_addr, ETH_ALEN);
1887             spin_unlock_bh(&mppath->state_lock);
1888         }
1889         rcu_read_unlock();
1890     }


Below is part of a dump of mpp table. ("proxy" entry is my debugging code, not available in kernel 3.6.3)

/debugfs/ieee80211/phy0/netdev:mesh0 # cat proxy
Dest Addr         Proxied By        Next Hop
00:07:d5:04:74:c1 00:15:6d:84:ff:32 00:15:6d:84:ff:32
e0:ce:da:58:e3:2f 00:15:6d:84:ff:32 00:15:6d:84:ff:32
16:61:07:b2:cd:e7 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d
8a:04:1c:a8:f2:ad 00:15:6d:84:ff:32 00:15:6d:84:ff:32
00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d
1a:e3:bf:17:10:fa 00:15:6d:84:ff:32 00:15:6d:84:ff:32
ea:a8:15:0a:00:cf 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d
1c:db:fb:06:7a:63 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d
48:58:a9:a1:5c:78 00:15:6d:84:ff:32 00:15:6d:84:ff:32
20:c1:ec:93:78:98 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d
66:94:85:35:3b:bb 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d
34:e8:5f:4a:95:cb 00:15:6d:84:ff:32 00:15:6d:84:ff:32
1e:23:8c:6e:bd:d5 00:15:6d:84:ff:32 00:15:6d:84:ff:32
b6:3d:1e:2a:f3:b4 00:15:6d:84:ff:32 00:15:6d:84:ff:32
16:f9:1a:7b:55:34 00:15:6d:84:ff:32 00:15:6d:84:ff:32
8c:e2:ae:c0:23:16 00:15:6d:84:ff:32 00:15:6d:84:ff:32
3c:9e:5a:71:85:d2 00:15:6d:84:ff:32 00:15:6d:84:ff:32
46:27:ff:24:e9:1d 00:15:6d:84:ff:32 00:15:6d:84:ff:32
d4:63:8c:ab:b1:c6 00:15:6d:84:ff:32 00:15:6d:84:ff:32
52:26:25:fe:d9:7a 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d
e4:cf:a6:c7:91:84 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d
46:17:c9:19:60:9a 00:15:6d:84:ff:32 00:15:6d:84:ff:32
ee:9d:46:df:6e:f8 00:15:6d:84:ff:32 00:15:6d:84:ff:32
4e:9d:1f:96:74:e5 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d
00:1c:23:10:b3:62 00:0e:8e:38:36:03 00:0e:8e:38:36:03
e4:ef:e6:1d:2c:35 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d
00:07:d5:04:2d:78 00:0e:8e:38:36:03 00:0e:8e:38:36:03
1a:b4:a6:6f:4b:e0 00:15:6d:84:ff:32 00:15:6d:84:ff:32
30:0c:76:27:16:0f 00:15:6d:84:ff:32 00:15:6d:84:ff:32
c2:e8:02:cb:af:58 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d
8e:01:7e:68:5a:ac 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d
e8:44:db:dd:fd:75 00:15:6d:84:ff:32 00:15:6d:84:ff:32
32:3b:c2:18:2a:fd 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d
ae:23:08:cb:6d:47 00:0e:8e:30:bc:6d 00:0e:8e:30:bc:6d


The cure is to move below early in this function when packet is encrypted.

1904     if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
1905         goto out;
