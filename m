Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:56540 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab3CMQn7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 12:43:59 -0400
Message-ID: <5140ACCB.4050408@iki.fi> (sfid-20130313_174413_777440_7620578C)
Date: Wed, 13 Mar 2013 18:43:55 +0200
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John W Linville <linville@tuxdriver.com>,
	alessandro.lannocca@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH for 3.9] rtlwifi: rtl8192cu: Fix problem that prevents
 reassociation
References: <51409b0d.AKkQggbo18xQwrFd%Larry.Finger@lwfinger.net>
In-Reply-To: <51409b0d.AKkQggbo18xQwrFd%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13.03.2013 17:28, Larry Finger wrote:
> The driver was failing to clear the BSSID when a disconnect happened. That
> prevented a reconnection. This problem is reported at
> https://bugzilla.redhat.com/show_bug.cgi?id=789605,
> https://bugzilla.redhat.com/show_bug.cgi?id=866786,
> https://bugzilla.redhat.com/show_bug.cgi?id=906734, and
> https://bugzilla.kernel.org/show_bug.cgi?id=46171.
> 
> Thanks to Jussi Kivilinna for making the critical observation
> that led to the solution.
> 
> Reported-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> Tested-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> Tested-by: Alessandro Lannocca <alessandro.lannocca@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>
> ---
> 
> John,
> 
> As you can see by the number of bug reports, this patch should be
> pushed as soon as possible.
> 
> Thanks,
> 
> Larry
> ---
> 
>  base.h         |    3 +
>  pci.c          |    2 -

Seems like leak from another patch/change?

>  rtl8192cu/hw.c |   87 ++++++++++++++++++++++-----------------------------------
>  3 files changed, 39 insertions(+), 53 deletions(-)
> 

<snip>

>  
> Index: linux-2.6/drivers/net/wireless/rtlwifi/base.h
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/rtlwifi/base.h
> +++ linux-2.6/drivers/net/wireless/rtlwifi/base.h
> @@ -143,5 +143,8 @@ extern struct attribute_group rtl_attrib
>  int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
>  			 bool isht, u8 desc_rate, bool first_ampdu);
>  bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb);
> +struct sk_buff *rtl_make_del_ba(struct ieee80211_hw *hw,
> +				u8 *sa, u8 *bssid, u16 tid);
> +void rtl_lps_change_work_callback(struct work_struct *work);
>  
>  #endif
> Index: linux-2.6/drivers/net/wireless/rtlwifi/pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/rtlwifi/pci.c
> +++ linux-2.6/drivers/net/wireless/rtlwifi/pci.c
> @@ -939,7 +939,7 @@ static void _rtl_pci_prepare_bcn_tasklet
>  	return;
>  }
>  
> -static void rtl_lps_leave_work_callback(struct work_struct *work)
> +void rtl_lps_leave_work_callback(struct work_struct *work)
>  {
>  	struct rtl_works *rtlworks =
>  	    container_of(work, struct rtl_works, lps_leave_work);
> 

