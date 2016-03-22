Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33408 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbcCVUYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 16:24:10 -0400
Received: by mail-wm0-f43.google.com with SMTP id l68so208165078wml.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2016 13:24:10 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: Problem with brcmfmac removing extra interface
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
References: <CACna6rzA1JcTjBsozR5nhCH9U9bKwceTNwLzeQ-Ds97NECVaeQ@mail.gmail.com>
 <CACna6rwgOuUtgjduwgQoZPFewZ3Wn2vgXapCvqw1ygbyt3Jqaw@mail.gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Message-ID: <56F1A9E9.5090803@broadcom.com> (sfid-20160322_212543_317796_F70C1F80)
Date: Tue, 22 Mar 2016 21:24:09 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rwgOuUtgjduwgQoZPFewZ3Wn2vgXapCvqw1ygbyt3Jqaw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-3-2016 7:36, Rafał Miłecki wrote:
> On 3 March 2016 at 23:37, Rafał Miłecki <zajec5@gmail.com> wrote:
>> brcmfmac in general is not capable of removing interfaces. If you take
>> a look at brcmf_cfg80211_del_iface implementation, you'll see it
>> returns -EOPNOTSUPP (except for p2p interfaces).
>>
>> However there is problem in handling NL80211_CMD_STOP_AP (with the
>> brcmf_cfg80211_stop_ap callback). Current implementation calls
>> brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1)
>> if mbss support is enabled/used.
>>
>> Above call results in firmware generating BRCMF_E_LINK event. This
>> event is handled with the following forward-traced functions chain:
>> 1) brcmf_notify_connect_status
>> 2) brcmf_notify_connect_status_ap
>> 3) brcmf_remove_interface
>> 4) brcmf_del_if
>> 5) brcmf_net_detach
>> 6) unregister_netdev
>>
>> So the result of NL80211_CMD_STOP_AP is interface being removed. The
>> problem with this behavior is that interface can't be recreated after
>> that:
>> # iw phy phy1 interface add wlan1-1 type __ap
>> [ 3602.929199] brcmfmac: brcmf_ap_add_vif: timeout occurred
>> command failed: I/O error (-5)
>>
>> I hit this problem when trying to restart hostapd using BCM43602 and 2 BSSes.
>>
>> Could you analyze this problem and see if you see some way of solving
>> this problem, please?
> 
> Hi, any ideas / help regarding this issue?

Restarting hostapd obviously is a valid scenario. My guess is we would
need to avoid interface removal in brcmf_notify_connect_status_ap. But
first I would like to know in which state the firmware is upon
brcmf_ap_add_vif. Can you provide a full log with FWCON debug level enabled?

Regards,
Arend
