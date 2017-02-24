Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:34998 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbdBXMQC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 07:16:02 -0500
Received: by mail-qk0-f181.google.com with SMTP id u188so16607525qkc.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 04:16:01 -0800 (PST)
Subject: Re: brcmfmac: problem using WPS with wpa_supplicant on BCM43362
To: =?UTF-8?Q?J=c3=b6rg_Krause?= <joerg.krause@embedded.rocks>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1487881302.20481.3.camel@embedded.rocks>
 <dd241eff-7e0d-26c1-1758-b3f4d51bc359@broadcom.com>
 <1487929408.3812.3.camel@embedded.rocks>
 <ce3bf3a5-2cd7-eb77-bb7d-57df8388e1ba@broadcom.com>
 <1487932016.3812.10.camel@embedded.rocks>
Cc: brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9c8e71d8-c6af-1d2b-3d91-ac791bc33327@broadcom.com> (sfid-20170224_131651_949590_038BBE20)
Date: Fri, 24 Feb 2017 13:15:52 +0100
MIME-Version: 1.0
In-Reply-To: <1487932016.3812.10.camel@embedded.rocks>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24-2-2017 11:26, Jörg Krause wrote:
> Hi Arend,
> 
> On Fri, 2017-02-24 at 10:58 +0100, Arend Van Spriel wrote:
>> On 24-2-2017 10:43, Jörg Krause wrote:
>>> Hi Arend,
>>>
>>> On Fri, 2017-02-24 at 09:16 +0100, Arend Van Spriel wrote:
>>>>
>>>> On 23-2-2017 21:21, Jörg Krause wrote:
>>>>> Hi,
>>>>>
>>>>> I am using Linux Kernel v4.9.9 and wpa_supplicant 2.6. When
>>>>> running
>>>>> 'wpa_cli wps_pin any', the following messages are printed:
>>>>>
>>>>> """
>>>>>> wps_pin any         
>>>>>
>>>>> [ 4011.779108] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set
>>>>> error :
>>>>> -30
>>>>> [ 4011.786190] brcmfmac: brcmf_config_ap_mgmt_ie: Set Beacon IE
>>>>> Failed
>>>>> """
>>>>>
>>>>> .. and nothing happens. The data sheet for the BCM43362 states
>>>>> that
>>>>> the
>>>>> module supports WPS.
>>>>
>>>> Hi Jörg,
>>>>
>>>> We have never tested WPS with brcmfmac. Most of it is in firmware
>>>> so
>>>> it
>>>> might work. We had some fixes related to setting management IE,
>>>> but
>>>> it
>>>> should be in 4.9. I did not check it (yet).
>>>
>>> As it turns out, WPS does not work if a network configuration in
>>> wpa_supplicant has the flag `mode=2` (access point mode) set:
>>>
>>> """
>>> ctrl_interface=/var/run/wpa_supplicant
>>> update_config=1
>>>
>>> network={
>>> 	ssid="AP"
>>> 	key_mgmt=NONE
>>> 	mode=2
>>> 	id_str="ap"
>>> }
>>> """
>>>
>>> Setting mode=2 for a network and having ap_scan=1 (default) means
>>> if no
>>> APs matching to the currently enabled networks are found, a new
>>> network
>>>  (IBSS or AP mode operation) may be initialized (if configured).
>>>
>>> So, WPS does not work if the interface is operating in AP mode. I
>>> wonder, if this is a desired behavior? At least, wpa_supplicant
>>> does
>>> not complain, but prints "WPS-PBC-ACTIVE", but no messages are
>>> following, until "WPS-TIMEOUT".
>>
>> So what do you expect exactly? Are you trying to connect with some
>> other
>> device to this AP interface?
> 
> Sorry, I got confused. The device operating in AP mode shall be
> connected to some other AP as a station. Of course, WPS cannot be used
> to do so as long as the interface is operation in AP mode, as the
> device should be the WPS enrollee and not the registrar. My bad! Thanks
> for pointing that out.
> 
> So, to use WPS for connecting the device to another AP I have to bring
> the interface into an non-AP mode first.
> 
> So, I can confirm that using WPS works when the interface is
> unconfigured. However, if the in the interface is in AP mode and WPS is
> started the error messages pop up.

You mean the message you emailed earlier as below?

[ 4011.779108] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set
error :
-30
[ 4011.786190] brcmfmac: brcmf_config_ap_mgmt_ie: Set Beacon IE
Failed

You get firmware error -30 which is BCME_NOTFOUND. This can happen in
firmware upon deleting an IE. However, it is hard to say what is exactly
happening without knowing the message content that goes to firmware. You
can enable firmware console logging to see if you get any message
regarding this, eg. "wlc_del_ie: IE not in list". Do insmod with
debug=0x00100000.

	if (total_ie_buf_len) {
		err  = brcmf_fil_bsscfg_data_set(ifp, "vndr_ie", iovar_ie_buf,
						 total_ie_buf_len);
		if (err)
			brcmf_err("vndr ie set error : %d\n", err);
	}

If this happens in the .start_ap() callback the error is ignored so it
should not affect AP operation although beacon may not be setup properly.

Regards,
Arend
