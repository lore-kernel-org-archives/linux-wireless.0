Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42159 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbeH1NOX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 09:14:23 -0400
Received: by mail-lj1-f194.google.com with SMTP id f1-v6so796861ljc.9
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2018 02:23:37 -0700 (PDT)
Subject: Re: [PATCH] mac80211: fix to follow standard
To: Yuan-Chi Pang <fu3mo6goo@gmail.com>, johannes@sipsolutions.net
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1535423074-130862-1-git-send-email-fu3mo6goo@gmail.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <9cedcd76-2a05-00dd-2651-3b42d98a3692@cogentembedded.com> (sfid-20180828_112340_693875_0BC374CC)
Date: Tue, 28 Aug 2018 12:23:35 +0300
MIME-Version: 1.0
In-Reply-To: <1535423074-130862-1-git-send-email-fu3mo6goo@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

On 8/28/2018 5:24 AM, Yuan-Chi Pang wrote:

> IEEE 802.11-2016 14.10.8.3 HWMP sequence numbering says:
> If it is a target mesh STA, it shall update its own HWMP SN to
> maximum (current HWMP SN, target HWMP SN in the PREQ element) + 1
> immediately before it generates a PREP element in response to a
> PREQ element.
> 
> Signed-off-by: Yuan-Chi Pang <fu3mo6goo@gmail.com>
> ---
>   net/mac80211/mesh_hwmp.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index 35ad398..6c21a26 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -572,6 +572,11 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>   		forward = false;
>   		reply = true;
>   		target_metric = 0;
> +
> +		if (SN_GT(target_sn, ifmsh->sn)) {
> +			ifmsh->sn = target_sn;
> +		}

    No need for {} enclosing a single statement.

[...]

MBR, Sergei
