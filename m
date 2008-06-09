Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:8665 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758858AbYFIKJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 06:09:31 -0400
Received: by rv-out-0506.google.com with SMTP id k40so228172rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 03:09:31 -0700 (PDT)
Message-ID: <1ba2fa240806090309y3fa65849l450df776b454f298@mail.gmail.com> (sfid-20080609_120935_579838_21E6B28D)
Date: Mon, 9 Jun 2008 13:09:31 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: CONFIG_IWL4965_HT=n in linux-next
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080609022341.16060b71.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080609015623.6bbc9d88.akpm@linux-foundation.org>
	 <1ba2fa240806090220y4a21d3d2k84143e2a4ee0cb1a@mail.gmail.com>
	 <20080609022341.16060b71.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 9, 2008 at 12:23 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 9 Jun 2008 12:20:14 +0300 "Tomas Winkler" <tomasw@gmail.com> wrote:
>
>> On Mon, Jun 9, 2008 at 11:56 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c: In function 'rs_move_siso_to_other':
>> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1439: error: 'struct iwl_priv' has no member named 'current_ht_config'
>> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1443: error: 'struct iwl_priv' has no member named 'current_ht_config'
>> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c: In function 'rs_move_mimo_to_other':
>> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1530: error: 'struct iwl_priv' has no member named 'current_ht_config'
>> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1534: error: 'struct iwl_priv' has no member named 'current_ht_config'
>>
>> It's a known issue.
>
> Sob.  Well please fix it urgently!  Poeple are trying to get work done
> on top of linux-next.
>
I thought his is a development branch, everybody is on the edge today :)

>> we are about to remove this conditional. Will
>> happen till EOW.
>
>
> I hacked around it:
Why is not good just make it HT=y. Or you need it fixed for this
random config files regression tests
Anyway, if it's so urgent it will be done till EOD  (TMZ:GMT+2), hope
it's good enough,
Tomas

>
> From: Andrew Morton <akpm@linux-foundation.org>
>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff -puN drivers/net/wireless/iwlwifi/iwl-4965-rs.c~drivers-net-wireless-iwlwifi-iwl-4965-rsc-config_iwl4965_ht=n-hack drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> --- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c~drivers-net-wireless-iwlwifi-iwl-4965-rsc-config_iwl4965_ht=n-hack
> +++ a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> @@ -1435,6 +1435,7 @@ static int rs_move_siso_to_other(struct
>                        }
>                        break;
>                case IWL_SISO_SWITCH_GI:
> +#ifdef CONFIG_IWL4965_HT
>                        if (!tbl->is_fat &&
>                                !(priv->current_ht_config.sgf &
>                                                HT_SHORT_GI_20MHZ))
> @@ -1443,7 +1444,7 @@ static int rs_move_siso_to_other(struct
>                                !(priv->current_ht_config.sgf &
>                                                HT_SHORT_GI_40MHZ))
>                                break;
> -
> +#endif
>                        IWL_DEBUG_RATE("LQ: SISO toggle SGI/NGI\n");
>
>                        memcpy(search_tbl, tbl, sz);
> @@ -1526,6 +1527,7 @@ static int rs_move_mimo_to_other(struct
>                        break;
>
>                case IWL_MIMO_SWITCH_GI:
> +#ifdef CONFIG_IWL4965_HT
>                        if (!tbl->is_fat &&
>                                !(priv->current_ht_config.sgf &
>                                                HT_SHORT_GI_20MHZ))
> @@ -1533,6 +1535,7 @@ static int rs_move_mimo_to_other(struct
>                        if (tbl->is_fat &&
>                                !(priv->current_ht_config.sgf &
>                                                HT_SHORT_GI_40MHZ))
> +#endif
>                                break;
>
>                        IWL_DEBUG_RATE("LQ: MIMO toggle SGI/NGI\n");
> _
>
>
