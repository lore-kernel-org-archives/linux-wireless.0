Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:60544 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753948AbeDXJJS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 05:09:18 -0400
Subject: Re: [PATCH] ath10k: add dynamic vlan support
To: Kalle Valo <kvalo@codeaurora.org>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
 <87r2n5auvq.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <aa04534d-9677-f42e-a239-b230093ef2f5@dd-wrt.com> (sfid-20180424_110925_517288_BDF15009)
Date: Tue, 24 Apr 2018 11:09:10 +0200
MIME-Version: 1.0
In-Reply-To: <87r2n5auvq.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

consider my comment regarding vlan_ap.
this patch will break wds ap / wds sta support with latest mac80211 (see 
also my post on the wireless mailing list about the breaking patch in 
mac80211)
so AP_VLAN must be masked always for all chipsets. otherwise wds breaks 
and this is not just a guess. i tested it yesterday using this patch and 
found
the cause of the issue

the following lines

   +    if (test_bit(WMI_SERVICE_PER_PACKET_SW_ENCRYPT, ar->wmi.svc_map)) {
+        ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
+        ar->hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_AP_VLAN);
+    }


must be just

+        ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
+        ar->hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_AP_VLAN);

everthing else will cause a regression

Am 24.04.2018 um 10:09 schrieb Kalle Valo:
> Manikanta Pubbisetty <mpubbise@codeaurora.org> writes:
>
>> Mutlicast/broadcast traffic destined for a particular vlan group will
>> always be encrypted in software. To enable dynamic VLANs, it requires
>> driver support for sending software encrypted packets.
>>
>> In ath10k, sending sw encrypted frames is allowed only when we insmod
>> the driver with cryptmode param set to 1, this configuration disables
>> hardware crypto and enables RAW mode implicitly. Since, enabling raw
>> mode has performance impact, this cannot be considered as an ideal
>> solution for supporting VLANs in the driver.
>>
>> As an alternative take, in this approach, cryptographic keys for
>> unicast traffic(per peer PTKs) and keys for non-vlan group traffic
>> will be configured in hardware, allowing hardware encryption for unicast
>> and non-vlan group traffic. Only vlan group traffic will be encrypted in
>> software and pushed to the target with encap mode set to RAW in the TX
>> descriptors.
>>
>> Not all firmwares can support this type of key configuration(having few
>> keys installed in hardware and few only in software); for this purpose a
>> new WMI service flag "WMI_SERVICE_PER_PACKET_SW_ENCRYPT" is introduced to
>> advertise this support.
>>
>> Also, adding the logic required to send sw encrypted frames in raw mode.
>>
>> Tested this change on QCA9984(firmware version 10.4-3.5.3-00057).
>>
>> Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
> Your name in patchwork is wrong and hence my script uses the wrong
> name. Please fix it by registering to patchwork[1] where it's possible
> to change your name during registration, but only one time. If that
> doesn't work then send a request to helpdesk@kernel.org and the admins
> can fix it.
>
> [1] https://patchwork.kernel.org/register/
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
