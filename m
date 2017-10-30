Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:60784 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752159AbdJ3Nkn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 09:40:43 -0400
Subject: Re: [PATCH 1/5] wlcore: Use common error handling code in
 wlcore_nvs_cb()
To: Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Eyal Reizer <eyalr@ti.com>, Iain Hunter <drhunter95@gmail.com>,
        James Minor <james.minor@ni.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
References: <dc2b8a7c-b4a9-2f92-12b4-a1d0d6911d7c@users.sourceforge.net>
 <7b40d50f-cdac-bd47-5070-894140f7ceb3@users.sourceforge.net>
 <CAGRGNgULQRFo7T2TKr_=xNY9csYXTnnPc4k1AjS2OQ20zg+cbA@mail.gmail.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <0487c19a-a662-1e74-cba7-12508a0b4307@users.sourceforge.net> (sfid-20171030_144109_379827_F97A5EF7)
Date: Mon, 30 Oct 2017 14:40:25 +0100
MIME-Version: 1.0
In-Reply-To: <CAGRGNgULQRFo7T2TKr_=xNY9csYXTnnPc4k1AjS2OQ20zg+cbA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> @@ -6551,6 +6549,11 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
>>  out:
>>         release_firmware(fw);
>>         complete_all(&wl->nvs_loading_complete);
>> +       return;
>> +
>> +power_off:
> 
> Name this "out_power_off" to match the other labels.

Do you expect a second approach for this patch series then?


>> +       wl1271_power_off(wl);
>> +       goto out_free_nvs;
> 
> Why not put this in front of the out_free_nvs label?

It seems that I can not really follow this suggestion at the moment.


> It looks weird here.

Which detail do you not like?

Regards,
Markus
