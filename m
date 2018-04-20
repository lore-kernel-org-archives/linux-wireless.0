Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:57505 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753539AbeDTHVh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 03:21:37 -0400
Subject: Re: [PATCH v2 4/4] ath10k: Enable sta idle power save
To: Kalle Valo <kvalo@codeaurora.org>, govinds@codeaurora.org
Cc: pillair@codeaurora.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, arend.vanspriel@broadcom.com
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
 <1523966821-21903-5-git-send-email-pillair@codeaurora.org>
 <946e582c-2438-872b-eec8-25d9dcb994d9@dd-wrt.com>
 <7a06a34a5fcb97e07a8d79b4d689e781@codeaurora.org>
 <87604oodt4.fsf@kamboji.qca.qualcomm.com>
 <a7dd1b94951725c61034f5be6744b725@codeaurora.org>
 <8736zrjgq6.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <c48c1bae-04c9-55d0-fdb9-d9ae8f7cb843@dd-wrt.com> (sfid-20180420_092141_417458_99FA3298)
Date: Fri, 20 Apr 2018 09:21:33 +0200
MIME-Version: 1.0
In-Reply-To: <8736zrjgq6.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> Yes this is WIFI chip set level power-save(based on idleness) and not
>> related to protocol power save. FW will turn off/scale down the
>> resources(clock/rails) based on opportunity(when ever idle mode is
>> detected). This power save is mostly done in disconnected state. I am
>> not really sure when framework/user-space triggers power-save
>> config(iw dev <devname> set power_save on/off). Then doing this from
>> user-space will be unnecessarily toggling this config or may not be
>> setting at disconnected state.
> I think that 'set power_save' commands affects struct
> ieee80211_bss_conf::ps parameter and I don't think it should be used in
> this case. We already have ath10k_config_ps() for 802.11 level of power
> saving.
>
> Arend again proposed runtime-pm with which I'm not very familiar. But
> why would we want to disable this? Doesn't it make sense to have this
> feature always enabled to save power? wcn3990 is a chip for a mobile
> device anyway.
it might be made for mobile devices but who knows how it is used by the 
market.

Sebastian
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
