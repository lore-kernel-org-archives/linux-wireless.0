Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59740 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754009AbeFTJ1g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 05:27:36 -0400
Date: Wed, 20 Jun 2018 12:27:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@01.org, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: kbuild-all@01.org, Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V3 2/2] brcmfmac: handle monitor mode marked msgbuf
 packets
Message-ID: <20180620092705.vshna6bxs7ambpjh@mwanda> (sfid-20180620_112743_482983_094F992D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180619154809.25698-3-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rafał,

I love your patch! Perhaps something to improve:

[auto build test WARNING on wireless-drivers-next/master]
[also build test WARNING on v4.18-rc1 next-20180619]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Rafa-Mi-ecki/brcmfmac-detect-firmware-support-for-monitor-interface/20180620-012610
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master

smatch warnings:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c:1166 brcmf_msgbuf_process_rx_complete() error: we previously assumed 'ifp' could be null (see line 1161)

# https://github.com/0day-ci/linux/commit/71f840a490aca9a2d4e9609641a929c6936c20e2
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 71f840a490aca9a2d4e9609641a929c6936c20e2
vim +/ifp +1166 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c

9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1124  
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1125  
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1126  static void
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1127  brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1128  {
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1129  	struct msgbuf_rx_complete *rx_complete;
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1130  	struct sk_buff *skb;
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1131  	u16 data_offset;
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1132  	u16 buflen;
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19  1133  	u16 flags;
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1134  	u32 idx;
c56caa9db drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Franky Lin       2016-04-11  1135  	struct brcmf_if *ifp;
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1136  
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1137  	brcmf_msgbuf_update_rxbufpost_count(msgbuf, 1);
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1138  
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1139  	rx_complete = (struct msgbuf_rx_complete *)buf;
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1140  	data_offset = le16_to_cpu(rx_complete->data_offset);
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1141  	buflen = le16_to_cpu(rx_complete->data_len);
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1142  	idx = le32_to_cpu(rx_complete->msg.request_id);
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19  1143  	flags = le16_to_cpu(rx_complete->flags);
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1144  
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1145  	skb = brcmf_msgbuf_get_pktid(msgbuf->drvr->bus_if->dev,
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1146  				     msgbuf->rx_pktids, idx);
7d072b404 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Arend van Spriel 2015-05-26  1147  	if (!skb)
7d072b404 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Arend van Spriel 2015-05-26  1148  		return;
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1149  
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1150  	if (data_offset)
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1151  		skb_pull(skb, data_offset);
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1152  	else if (msgbuf->rx_dataoffset)
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1153  		skb_pull(skb, msgbuf->rx_dataoffset);
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1154  
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1155  	skb_trim(skb, buflen);
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1156  
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19  1157  	if ((flags & BRCMF_MSGBUF_PKT_FLAGS_FRAME_MASK) ==
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19  1158  	    BRCMF_MSGBUF_PKT_FLAGS_FRAME_802_11) {
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19  1159  		ifp = msgbuf->drvr->mon_if;
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19  1160  
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19 @1161  		if (!ifp) {
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19  1162  			brcmf_err("Received unexpected monitor pkt\n");
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19  1163  			brcmu_pkt_buf_free_skb(skb);
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19  1164  		}
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19  1165  
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19 @1166  		brcmf_netif_mon_rx(ifp, skb);
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19  1167  		return;
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19  1168  	}
71f840a49 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Rafał Miłecki    2018-06-19  1169  
c56caa9db drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Franky Lin       2016-04-11  1170  	ifp = brcmf_get_ifp(msgbuf->drvr, rx_complete->msg.ifidx);
c56caa9db drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Franky Lin       2016-04-11  1171  	if (!ifp || !ifp->ndev) {
c56caa9db drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Franky Lin       2016-04-11  1172  		brcmf_err("Received pkt for invalid ifidx %d\n",
c56caa9db drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Franky Lin       2016-04-11  1173  			  rx_complete->msg.ifidx);
c56caa9db drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Franky Lin       2016-04-11  1174  		brcmu_pkt_buf_free_skb(skb);
c56caa9db drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Franky Lin       2016-04-11  1175  		return;
c56caa9db drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Franky Lin       2016-04-11  1176  	}
31143e293 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Franky Lin       2016-06-02  1177  
31143e293 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Franky Lin       2016-06-02  1178  	skb->protocol = eth_type_trans(skb, ifp->ndev);
9c349892c drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c Arend van Spriel 2016-04-11  1179  	brcmf_netif_rx(ifp, skb);
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1180  }
9a1bb6025 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c          Hante Meuleman   2014-07-30  1181  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
