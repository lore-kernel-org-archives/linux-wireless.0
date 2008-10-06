Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:35213 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYJFSSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 14:18:35 -0400
Subject: Re: [PATCH v2] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223315348.3778.13.camel@johannes.berg>
References: <1223311803.15196.36.camel@johannes.berg>
	 (sfid-20081006_185054_691408_9EB600FE)  <1223315348.3778.13.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 20:18:52 +0200
Message-Id: <1223317132.11272.219.camel@violet.holtmann.net> (sfid-20081006_201840_351858_64338F4E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> This makes the code surrounding the last few things using
> IWL_SET_BITS16 actually readable and removes the macros
> so nobody will ever consider using them again.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Tested on 5000 hw.
> 
> v2: don't BUG_ON an invalid index because it actually happens!
> 
>  drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   85 +++++++++---------------
>  drivers/net/wireless/iwlwifi/iwl-4965.c    |   15 ++--
>  drivers/net/wireless/iwlwifi/iwl-5000-hw.h |   61 +++++++++--------
>  drivers/net/wireless/iwlwifi/iwl-5000.c    |   41 ++++++-----
>  drivers/net/wireless/iwlwifi/iwl-helpers.h |  102 -----------------------------
>  drivers/net/wireless/iwlwifi/iwl-tx.c      |    6 -
>  6 files changed, 99 insertions(+), 211 deletions(-)
> 
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-4965-hw.h	2008-10-06 18:01:57.207234025 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-4965-hw.h	2008-10-06 19:35:09.488701911 +0200
> @@ -857,18 +857,24 @@ struct iwl_tfd_addr_desc {
>   * A maximum of 255 (not 256!) TFDs may be on a queue waiting for Tx.
>   */
>  struct iwl_tfd_frame {
> -	__le32 val0;
> -	/* __le32 rsvd1:24; */
> -	/* __le32 num_tbs:5; */
> -#define IWL_num_tbs_POS 24
> -#define IWL_num_tbs_LEN 5
> -#define IWL_num_tbs_SYM val0
> -	/* __le32 rsvd2:1; */
> -	/* __le32 padding:2; */
> +	u8 reserved1[3];
> +	u8 num_tbs; /* 5 bits, rest reserved/padding */
>  	struct iwl_tfd_addr_desc addrs[20];
>  	__le32 reserved;
>  } __attribute__ ((packed));
>  
> +static inline u8 iwl_get_num_tbs(struct iwl_tfd_frame *frame)
> +{
> +	return frame->num_tbs & 0x1f;
> +}
> +
> +static inline void iwl_set_num_tbs(struct iwl_tfd_frame *frame, u8 num_tbs)
> +{
> +	BUG_ON(num_tbs >= 20);
> +
> +	frame->num_tbs &= ~0x1f;
> +	frame->num_tbs |= num_tbs;
> +}

what is this magic doing and what is wrong with

	frame->num_tbs = num_tbs & 0x1f

Or do you expect to do something with the upper 3 bits?

Personally I think it is important that we always zero any data
structure and especially the reserved bits of it. Otherwise stuff just
magically seems to work, but it is pure luck if the right bits are set.

The overall patch looks good to me and I think it is the way to go. Less
home grown bit magic the better.

Regards

Marcel


