Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57842 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3FKRAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 13:00:14 -0400
Date: Tue, 11 Jun 2013 12:45:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH RESEND] mwifiex: enable/disable tx_amsdu support via
 module parameter
Message-ID: <20130611164547.GC3196@tuxdriver.com> (sfid-20130611_190019_337625_64560DB0)
References: <1370903998-10925-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370903998-10925-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have the original for this one too...

On Mon, Jun 10, 2013 at 03:39:58PM -0700, Bing Zhao wrote:
> From: Avinash Patil <patila@marvell.com>
> 
> This patch disables tx_amsdu support in mwifiex by default.
> tx_amdsu support can be enabled via module parameter at load time.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/wmm.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
> index 4be3d33..944e884 100644
> --- a/drivers/net/wireless/mwifiex/wmm.c
> +++ b/drivers/net/wireless/mwifiex/wmm.c
> @@ -37,6 +37,9 @@
>  /* Offset for TOS field in the IP header */
>  #define IPTOS_OFFSET 5
>  
> +static bool enable_tx_amsdu;
> +module_param(enable_tx_amsdu, bool, 0644);
> +
>  /* WMM information IE */
>  static const u8 wmm_info_ie[] = { WLAN_EID_VENDOR_SPECIFIC, 0x07,
>  	0x00, 0x50, 0xf2, 0x02,
> @@ -1233,7 +1236,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
>  				mwifiex_send_delba(priv, tid_del, ra, 1);
>  			}
>  		}
> -		if (mwifiex_is_amsdu_allowed(priv, tid) &&
> +		if (enable_tx_amsdu && mwifiex_is_amsdu_allowed(priv, tid) &&
>  		    mwifiex_is_11n_aggragation_possible(priv, ptr,
>  							adapter->tx_buf_size))
>  			mwifiex_11n_aggregate_pkt(priv, ptr, INTF_HEADER_LEN,
> -- 
> 1.8.2.3
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
