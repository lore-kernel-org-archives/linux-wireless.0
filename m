Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:57026
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbZBBX7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 18:59:51 -0500
Message-ID: <498788F3.5040502@erley.org> (sfid-20090203_005956_283020_150A257D)
Date: Mon, 02 Feb 2009 18:59:47 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] iw: add MCS set parsing
References: <1233617946-25094-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1233617946-25094-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> This adds MCS set parsing to iw. When you can 'iw list' you can
> now see the MCS set actually parsed, this can tell you information
> such as all the RX/TX MCS indexes supported, max TX spatial streams,
> if TX unequal modulation is supported and your max supported HT
> RX data rate.
> 
> This is as per 802.11n Draft 7 on section 7.3.2.57.4 Supported MCS Set field.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Worked for me with ath9k (Supports mcs rates) and rtl8187 (doesn't
support mcs rates) devices in the same system.

Tested-by: Pat Erley <pat-lkml@erley.org>

> ---
> 
> OK now in v2 we don't print the rate if its 0 as the 802.11n Draft 7
> indicates that if its 0 it does not indicate the max supported RX rate.
> It does refer us to 9.6.0e.5.3 though. We'll need to review that I guess
> to get this when this is not set.
> 
>  info.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 59 insertions(+), 0 deletions(-)
> 
> diff --git a/info.c b/info.c
> index bf3b8bd..7ea8f99 100644
> --- a/info.c
> +++ b/info.c
> @@ -1,3 +1,4 @@
> +#include <stdbool.h>
>  #include <errno.h>
>  #include <net/if.h>
>  
> @@ -20,6 +21,24 @@ static void print_flag(const char *name, int *open)
>  	*open = 1;
>  }
>  
> +static void print_mcs_index(unsigned char *mcs)
> +{
> +	unsigned int mcs_bit;
> +
> +	for (mcs_bit = 0; mcs_bit <= 76; mcs_bit++) {
> +		unsigned int mcs_octet = mcs_bit/8;
> +		unsigned int MCS_RATE_BIT = 1 << mcs_bit % 8;
> +		bool mcs_rate_idx_set;
> +
> +		mcs_rate_idx_set = !!(mcs[mcs_octet] & MCS_RATE_BIT);
> +
> +		if (!mcs_rate_idx_set)
> +			continue;
> +
> +		printf("\t\t\tMCS index %d\n", mcs_bit);
> +	}
> +}
> +
>  static int print_phy_handler(struct nl_msg *msg, void *arg)
>  {
>  	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
> @@ -128,10 +147,50 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
>  		}
>  		if (tb_band[NL80211_BAND_ATTR_HT_MCS_SET] &&
>  		    nla_len(tb_band[NL80211_BAND_ATTR_HT_MCS_SET]) == 16) {
> +			/* As defined in 7.3.2.57.4 Supported MCS Set field */
> +			unsigned int tx_max_num_spatial_streams, max_rx_supp_data_rate;
>  			unsigned char *mcs = nla_data(tb_band[NL80211_BAND_ATTR_HT_MCS_SET]);
> +			bool tx_mcs_set_defined, tx_mcs_set_equal, tx_unequal_modulation;
> +
>  			printf("\t\tHT MCS set: %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x\n",
>  				mcs[0], mcs[1], mcs[2], mcs[3], mcs[4], mcs[5], mcs[6], mcs[7],
>  				mcs[8], mcs[9], mcs[10], mcs[11], mcs[12], mcs[13], mcs[14], mcs[15]);
> +
> +			max_rx_supp_data_rate = ((mcs[10] >> 8) & ((mcs[11] & 0x3) << 8));
> +			tx_mcs_set_defined = !!(mcs[12] & (1 << 0));
> +			tx_mcs_set_equal = !(mcs[12] & (1 << 1));
> +			tx_max_num_spatial_streams = (mcs[12] | ((1 << 3) | (1 << 4))) + 1;
> +			tx_unequal_modulation = !!(mcs[12] & (1 << 5));
> +
> +			if (max_rx_supp_data_rate)
> +				printf("\t\tHT Max RX data rate: %d Mbps\n", max_rx_supp_data_rate);
> +			/* XXX: else see 9.6.0e.5.3 how to get this I think */
> +
> +			if (tx_mcs_set_defined) {
> +				if (tx_mcs_set_equal) {
> +					printf("\t\tHT TX/RX MCS rate indexes supported:\n");
> +					print_mcs_index(&mcs[0]);
> +				} else {
> +					printf("\t\tHT RX MCS rate indexes supported:\n");
> +					print_mcs_index(&mcs[0]);
> +
> +					if (tx_unequal_modulation)
> +						printf("TX unequal modulation supported\n");
> +					else
> +						printf("TX unequal modulation not supported\n");
> +
> +					printf("\t\tHT TX Max spatiel streams: %d\n",
> +						tx_max_num_spatial_streams);
> +
> +					printf("\t\tHT TX MCS rate indexes supported may differ\n");
> +				}
> +			}
> +			else {
> +				printf("\t\tHT RX MCS rate indexes supported:\n");
> +				print_mcs_index(&mcs[0]);
> +				printf("\t\tHT TX MCS rates indexes are undefined\n");
> +			}
> +
>  		}
>  #endif
>  

