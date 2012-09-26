Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:42914 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2IZHcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 03:32:02 -0400
Date: Wed, 26 Sep 2012 10:31:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] brcmfmac: use kcalloc() to prevent integer overflow
Message-ID: <20120926073143.GO13767@mwanda> (sfid-20120926_093206_468953_2206E219)
References: <20120926072148.GA3956@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120926072148.GA3956@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Speaking of integer overflows, I had a couple other concerns in this
file.

drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c brcmf_enq_event()
  4144          total_len = sizeof(struct brcmf_cfg80211_event_q);
  4145          if (data)
  4146                  data_len = be32_to_cpu(msg->datalen);
  4147          else
  4148                  data_len = 0;
  4149          total_len += data_len;
                ^^^^^^^^^^^^^^^^^^^^^
This looks very suspicious like a remote exploitable overflow.

  4150          e = kzalloc(total_len, GFP_ATOMIC);

drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c brcmf_run_escan()
   882          if (request != NULL) {
   883                  /* Allocate space for populating ssids in struct */
   884                  params_size += sizeof(u32) * ((request->n_channels + 1) / 2);
   885  
   886                  /* Allocate space for populating ssids in struct */
   887                  params_size += sizeof(struct brcmf_ssid) * request->n_ssids;
   888          }
   889  
   890          params = kzalloc(params_size, GFP_KERNEL);

I didn't track back where request comes from so I don't know if
that's a problem or not.  I figured you would know better than I
would.

regards,
dan carpenter
