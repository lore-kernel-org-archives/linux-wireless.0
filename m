Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbbEGMEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 08:04:13 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "Gujulan Elango\, Hari Prasath \(H.\)" <hgujulan@visteon.com>
Cc: "devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] staging: rtl8723au : remove goto & return error directly
References: <20150507111652.GA10574@IND12F0122>
Date: Thu, 07 May 2015 08:03:06 -0400
In-Reply-To: <20150507111652.GA10574@IND12F0122> (Gujulan Elango's message of
	"Thu, 7 May 2015 11:22:25 +0000")
Message-ID: <wrfjk2wkoarp.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150507_140416_473150_D6772855)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com> writes:
> Remove the goto and return error directly thereby removing a variable
>
> Signed-off-by: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
> ---
>  drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

NACK!

The goto is cleaner and more consistent, rather than hiding a return in
the middle of the code.

Jes

>
> diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
> index b139ed4..a979048 100644
> --- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
> +++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
> @@ -1209,7 +1209,6 @@ static int cfg80211_rtw_change_iface(struct wiphy *wiphy,
>  	struct rtw_adapter *padapter = wiphy_to_adapter(wiphy);
>  	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
>  	struct wireless_dev *rtw_wdev = wiphy_to_wdev(wiphy);
> -	int ret = 0;
>  
>  	DBG_8723A("%s(%s): call netdev_open23a\n", __func__, ndev->name);
>  
> @@ -1238,14 +1237,12 @@ static int cfg80211_rtw_change_iface(struct wiphy *wiphy,
>  
>  	if (cfg80211_infrastructure_mode(padapter, type) != _SUCCESS) {
>  		rtw_wdev->iftype = old_type;
> -		ret = -EPERM;
> -		goto exit;
> +		return -EPERM;
>  	}
>  
>  	rtw_setopmode_cmd23a(padapter, type);
>  
> -exit:
> -	return ret;
> +	return 0;
>  }
>  
>  void rtw_cfg80211_indicate_scan_done(struct rtw_wdev_priv *pwdev_priv,
