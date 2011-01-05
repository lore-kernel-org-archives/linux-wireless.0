Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36793 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1AETuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 14:50:00 -0500
Received: by qwa26 with SMTP id 26so16023168qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 11:49:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294256409.12561.8.camel@Joe-Laptop>
References: <1294255328-14322-1-git-send-email-linville@tuxdriver.com>
	<1294256409.12561.8.camel@Joe-Laptop>
Date: Wed, 5 Jan 2011 14:49:59 -0500
Message-ID: <AANLkTi=v3oHGiQjASQqChmmsXHuv=UF17_A9XdeFeFNR@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath5k: move nohwcrypt to ath_common structure
From: Bob Copeland <me@bobcopeland.com>
To: Joe Perches <joe@perches.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 5, 2011 at 2:40 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2011-01-05 at 14:22 -0500, John W. Linville wrote:
>
>> diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
> []
>> +     bool nohwcrypt;
>
>> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
>> -int modparam_nohwcrypt;
>> +static int modparam_nohwcrypt;
>>  module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
>
> bool/int matching?

It used to be the case that you had to use ints here.  Google tells me
that changed about 2 years ago, so bool should be ok.

-- 
Bob Copeland %% www.bobcopeland.com
