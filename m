Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36694 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbcC1EJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2016 00:09:11 -0400
MIME-Version: 1.0
In-Reply-To: <1458972892-14169-1-git-send-email-bhumirks@gmail.com>
References: <1458972892-14169-1-git-send-email-bhumirks@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 28 Mar 2016 15:08:50 +1100
Message-ID: <CAGRGNgXg=dNRBsaFvyq4cCSH9vfmHRFT4K0OT+aqyTdtreMq0g@mail.gmail.com> (sfid-20160328_060932_435850_D3A6E1AC)
Subject: Re: [PATCH] Staging: rtl8723au: Remove unused functions
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Joe Perches <joe@perches.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Sat, Mar 26, 2016 at 5:14 PM, Bhumika Goyal <bhumirks@gmail.com> wrote:
> The functions rtw_get_oper_bw23a and rtw_get_oper_ch23aoffset are never
> used anywhere in the kernel. So, remove their definition and prototype.
> Grepped to find occurences.
>
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>


> ---
>  drivers/staging/rtl8723au/core/rtw_wlan_util.c   | 10 ----------
>  drivers/staging/rtl8723au/include/rtw_mlme_ext.h |  2 --
>  2 files changed, 12 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
> index cc2b84b..694cf17 100644
> --- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
> +++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
> @@ -304,21 +304,11 @@ inline void rtw_set_oper_ch23a(struct rtw_adapter *adapter, u8 ch)
>         adapter_to_dvobj(adapter)->oper_channel = ch;
>  }
>
> -inline u8 rtw_get_oper_bw23a(struct rtw_adapter *adapter)
> -{
> -       return adapter_to_dvobj(adapter)->oper_bwmode;
> -}
> -
>  inline void rtw_set_oper_bw23a(struct rtw_adapter *adapter, u8 bw)
>  {
>         adapter_to_dvobj(adapter)->oper_bwmode = bw;
>  }
>
> -inline u8 rtw_get_oper_ch23aoffset(struct rtw_adapter *adapter)
> -{
> -       return adapter_to_dvobj(adapter)->oper_ch_offset;
> -}
> -
>  inline void rtw_set_oper_ch23aoffset23a(struct rtw_adapter *adapter, u8 offset)
>  {
>         adapter_to_dvobj(adapter)->oper_ch_offset = offset;
> diff --git a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
> index ea2a6c9..0e7d3da 100644
> --- a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
> +++ b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
> @@ -461,9 +461,7 @@ void Update23aTblForSoftAP(u8 *bssrateset, u32 bssratelen);
>
>  u8 rtw_get_oper_ch23a(struct rtw_adapter *adapter);
>  void rtw_set_oper_ch23a(struct rtw_adapter *adapter, u8 ch);
> -u8 rtw_get_oper_bw23a(struct rtw_adapter *adapter);
>  void rtw_set_oper_bw23a(struct rtw_adapter *adapter, u8 bw);
> -u8 rtw_get_oper_ch23aoffset(struct rtw_adapter *adapter);
>  void rtw_set_oper_ch23aoffset23a(struct rtw_adapter *adapter, u8 offset);
>
>  void set_channel_bwmode23a(struct rtw_adapter *padapter, unsigned char channel,
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
