Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:34548 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbZC3MPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 08:15:04 -0400
Received: by ewy9 with SMTP id 9so2025739ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 05:15:00 -0700 (PDT)
Message-ID: <49D0B7C2.1080701@gmail.com> (sfid-20090330_141508_993095_6C58B711)
Date: Mon, 30 Mar 2009 14:14:58 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, mickflemm@gmail.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH] ath5k: reduce exported channel list
References: <1238414729-29358-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1238414729-29358-1-git-send-email-me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2009 02:05 PM, Bob Copeland wrote:
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -64,6 +64,10 @@ static int modparam_nohwcrypt;
>  module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
>  MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
>  
> +static int modparam_all_channels;
> +module_param_named(all_channels, modparam_all_channels, int, 0444);

Make it bool and use S_* constants for perms, please (S_IRUGO). Maybe do
it as a followup also cleaning up the former one.
