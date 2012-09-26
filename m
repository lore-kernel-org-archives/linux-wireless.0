Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1615 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab2IZJlw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 05:41:52 -0400
Message-ID: <5062CDD0.2000008@broadcom.com> (sfid-20120926_114158_564330_E8C42EE4)
Date: Wed, 26 Sep 2012 11:41:36 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] brcmfmac: use kcalloc() to prevent integer overflow
References: <20120926072148.GA3956@elgon.mountain>
 <20120926073143.GO13767@mwanda>
In-Reply-To: <20120926073143.GO13767@mwanda>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/26/2012 09:31 AM, Dan Carpenter wrote:
> Speaking of integer overflows, I had a couple other concerns in this
> file.
>
> drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c brcmf_enq_event()
>    4144          total_len = sizeof(struct brcmf_cfg80211_event_q);
>    4145          if (data)
>    4146                  data_len = be32_to_cpu(msg->datalen);
>    4147          else
>    4148                  data_len = 0;
>    4149          total_len += data_len;
>                  ^^^^^^^^^^^^^^^^^^^^^
> This looks very suspicious like a remote exploitable overflow.

Hi Dan,

The event message is generated in our device so I believe there is 
little room for exploits.

>    4150          e = kzalloc(total_len, GFP_ATOMIC);
>
> drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c brcmf_run_escan()
>     882          if (request != NULL) {
>     883                  /* Allocate space for populating ssids in struct */
>     884                  params_size += sizeof(u32) * ((request->n_channels + 1) / 2);
>     885
>     886                  /* Allocate space for populating ssids in struct */
>     887                  params_size += sizeof(struct brcmf_ssid) * request->n_ssids;
>     888          }
>     889
>     890          params = kzalloc(params_size, GFP_KERNEL);
>
> I didn't track back where request comes from so I don't know if
> that's a problem or not.  I figured you would know better than I
> would.

This request comes from user-space, ie. nl80211. cfg80211 does make sure 
that amount channels and ssids are sane (see nl80211_trigger_scan() in 
net/wireless/nl80211.c).

Gr. AvS


