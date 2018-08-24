Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:33287 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbeHXGgC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 02:36:02 -0400
Received: by mail-yw1-f65.google.com with SMTP id x67-v6so2611599ywg.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2018 20:03:25 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id m16-v6sm1982878ywd.32.2018.08.23.20.03.23
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Aug 2018 20:03:23 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id m62-v6so1104476ywd.6
        for <linux-wireless@vger.kernel.org>; Thu, 23 Aug 2018 20:03:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180824011540.GA25716@embeddedor.com>
References: <20180824011540.GA25716@embeddedor.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 23 Aug 2018 20:03:22 -0700
Message-ID: <CAGXu5jJxbFzKsV1=xHiKtcx+61QBsK0LYMrwo1vGNWgALzqakw@mail.gmail.com> (sfid-20180824_050335_051950_B7AB9609)
Subject: Re: [PATCH] iwlwifi: d3: use struct_size() in kzalloc()
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 23, 2018 at 6:15 PM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
>
> struct foo {
>         int stuff;
>         void *entry[];
> };
>
> instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);
>
> Instead of leaving these open-coded and prone to type mistakes, we can
> now use the new struct_size() helper:
>
> instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);
>
> This issue was detected with the help of Coccinelle.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
> index 79bdae9..6960318 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
> @@ -1769,8 +1769,7 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
>                 n_matches = 0;
>         }
>
> -       net_detect = kzalloc(sizeof(*net_detect) +
> -                            (n_matches * sizeof(net_detect->matches[0])),
> +       net_detect = kzalloc(struct_size(net_detect, matches, n_matches),
>                              GFP_KERNEL);
>         if (!net_detect || !n_matches)
>                 goto out_report_nd;
> @@ -1785,8 +1784,7 @@ static void iwl_mvm_query_netdetect_reasons(struct iwl_mvm *mvm,
>                 for (j = 0; j < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN; j++)
>                         n_channels += hweight8(fw_match->matching_channels[j]);
>
> -               match = kzalloc(sizeof(*match) +
> -                               (n_channels * sizeof(*match->channels)),
> +               match = kzalloc(struct_size(match, channels, n_channels),
>                                 GFP_KERNEL);
>                 if (!match)
>                         goto out_report_nd;
> --
> 2.7.4
>



-- 
Kees Cook
Pixel Security
