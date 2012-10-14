Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:50425 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2JNXOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 19:14:55 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so3266234iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Oct 2012 16:14:55 -0700 (PDT)
Message-ID: <507B476C.7070001@lwfinger.net> (sfid-20121015_011459_786312_74A32912)
Date: Sun, 14 Oct 2012 18:14:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org, Joshua.Roys@gtri.gatech.edu,
	linville@tuxdriver.com
Subject: Re: [PATCH] rtlwifi: pass rx setup error code to caller
References: <201210142215.48645.chunkeey@googlemail.com>
In-Reply-To: <201210142215.48645.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2012 03:15 PM, Christian Lamparter wrote:
> If _rtl_usb_receive fails, the device is
> probably not ready. Hence the error code
> should be passed to the caller, so it can
> react accordingly and notify the user.
>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
>   rtlwifi/usb.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>


>
> diff --git a/rtlwifi/usb.c b/rtlwifi/usb.c
> index d7744e1..696d29f 100644
> --- a/rtlwifi/usb.c
> +++ b/rtlwifi/usb.c
> @@ -682,7 +682,7 @@ static int rtl_usb_start(struct ieee80211_hw *hw)
>   		set_hal_start(rtlhal);
>
>   		/* Start bulk IN */
> -		_rtl_usb_receive(hw);
> +		err = _rtl_usb_receive(hw);
>   	}
>
>   	return err;
>

