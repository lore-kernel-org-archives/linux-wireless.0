Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:13888 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZAVL2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 06:28:44 -0500
Received: by fk-out-0910.google.com with SMTP id f33so666155fkf.5
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 03:28:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200901221144.27380.helmut.schaa@gmail.com>
References: <200901190955.32818.helmut.schaa@gmail.com>
	 <20090121192329.GB14710@tuxdriver.com>
	 <200901221144.27380.helmut.schaa@gmail.com>
Date: Thu, 22 Jan 2009 13:28:42 +0200
Message-ID: <1ba2fa240901220328s4fe65faeo35176357a19f57fa@mail.gmail.com> (sfid-20090122_122849_853900_718BA005)
Subject: Re: [PATCH 2/2] iwl3945: Remove unused variables
From: Tomas Winkler <tomasw@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 22, 2009 at 12:44 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Mittwoch, 21. Januar 2009 schrieb John W. Linville:
>> On Mon, Jan 19, 2009 at 09:55:32AM +0100, Helmut Schaa wrote:
>> > Fix the following warnings in iwl-3945-rs.c by removing unused variables.
>> >
>> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function 'iwl3945_rate_scale_flush_windows':
>> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c:186: warning: unused variable 'priv'
>> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function 'iwl3945_bg_rate_scale_flush':
>> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c:219: warning: unused variable 'priv'
>> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function 'iwl3945_collect_tx_data':
>> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c:293: warning: unused variable 'priv'
>> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function 'rs_free_sta':
>> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c:441: warning: unused variable 'priv'
>> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function 'iwl3945_get_adjacent_rate':
>> > drivers/net/wireless/iwlwifi/iwl-3945-rs.c:559: warning: unused variable 'priv'
>> >
>> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>>
>> With this applied, I get these:
>>
>>   CC [M]  drivers/net/wireless/iwlwifi/iwl-3945-rs.o
>> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function 'iwl3945_rate_scale_flush_windows':
>> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:199: error: 'priv' undeclared (first use in this function)
>> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:199: error: (Each undeclared identifier is reported only once
>> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:199: error: for each function it appears in.)
>> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function 'iwl3945_bg_rate_scale_flush':
>> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:222: error: 'priv' undeclared (first use in this function)
>> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function 'iwl3945_collect_tx_data':
>> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:293: error: 'priv' undeclared (first use in this function)
>> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function 'rs_free_sta':
>> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:441: error: 'priv' undeclared (first use in this function)
>> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function 'iwl3945_get_adjacent_rate':
>> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:594: error: 'priv' undeclared (first use in this function)
>> make[2]: *** [drivers/net/wireless/iwlwifi/iwl-3945-rs.o] Error 1
>> make[1]: *** [drivers/net/wireless/iwlwifi] Error 2
>> make: *** [drivers/net/wireless/] Error 2
>>
>> Dropping...
>
> Ah, sorry for that. I compiled without CONFIG_IWL_DEBUG. Instead of removing
> these lines they should be surrounded by an CONFIG_IWL_DEBUG check. I'll send
> that soon.

Please use
struct iwl_priv *priv __maybe_unused priv;
look  at  in iwl-agn-rs.c

Thanks
Tomas
