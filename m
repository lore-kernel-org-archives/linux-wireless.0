Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35410 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab3DMAmm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Apr 2013 20:42:42 -0400
Received: by mail-qa0-f46.google.com with SMTP id j8so68280qah.12
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2013 17:42:40 -0700 (PDT)
Message-ID: <5168A9FE.7070506@lwfinger.net> (sfid-20130413_024256_656983_A8CCAA96)
Date: Fri, 12 Apr 2013 19:42:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?IkhhbiBTaGVuKOayiOa2tSki?= <shenhan@google.com>
CC: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	chaoming_li@realsil.com.cn
Subject: Re: [PATCH] Fix uninitialized-variable warnings.
References: <1365703360-19982-1-git-send-email-shenhan@google.com> <1365705330.1929.30.camel@joe-AO722> <51671663.3070707@lwfinger.net> <CACkGtri5R2sgFZd9-M+UCNJ1NOwFS769NJqHUTgWUgtgRnDWow@mail.gmail.com>
In-Reply-To: <CACkGtri5R2sgFZd9-M+UCNJ1NOwFS769NJqHUTgWUgtgRnDWow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/12/2013 05:20 PM, Han Shen(沈涵) wrote:
> Hi, Joe's patch (the 1-line fix) does not work for me. The assignment
> is in a conditional block, when refer to this ofdm_index_old later, I
> still get error -
>
> /mnt/host/source/src/third_party/kernel/files/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:771:31:
> error: 'ofdm_index_old[1]' may be used uninitialized in this function
> [-Werror=maybe-uninitialized]
>       rtlpriv->dm.ofdm_index[i] = ofdm_index_old[i];
>
> (I'm working on 3.4 branch.)

I would get rid of the -Werror=maybe-unitialized. Sometimes gcc generates a 
false warning, and you really should not error the build in that case.

The correct patch needs to initialize the array to 0, and set the element the 
way Joe's patch does.

Larry


