Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36694 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdFBLTh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:19:37 -0400
Received: by mail-qk0-f172.google.com with SMTP id p66so40445029qkf.3
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jun 2017 04:19:32 -0700 (PDT)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake offload
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
 <1495030794.2442.21.camel@sipsolutions.net>
 <1de42f39-1912-349b-e20d-4b5c3c44909f@broadcom.com>
 <1495099355.2553.1.camel@sipsolutions.net>
 <4e0672aa-51bc-115f-32b7-b1a8eb747e5b@broadcom.com>
 <1495104012.2553.3.camel@sipsolutions.net>
 <adcf52eb-cc8f-82de-3820-3f96a0d1f8d3@broadcom.com>
 <1495189263.3274.4.camel@sipsolutions.net>
 <c3c14002-c9c5-490a-2e8f-826d601d0d84@broadcom.com>
 <1495448886.2653.12.camel@sipsolutions.net>
 <29d43b7d-6cb6-0734-6a52-31fa98e9c1bc@broadcom.com>
 <1496050303.2467.3.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <8c101115-1038-ddc0-463f-c38344f740db@broadcom.com> (sfid-20170602_132010_755082_B97A1D50)
Date: Fri, 2 Jun 2017 13:19:13 +0200
MIME-Version: 1.0
In-Reply-To: <1496050303.2467.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/29/2017 11:31 AM, Johannes Berg wrote:
> Hi Arend,
> 
>>> Note that this (checking NEW_KEY) only works when you don't have
>>> any split between AP/client cases. Not sure what's the case for
>>> you.
>>
>> Late response so hopefully you recall, but what do you mean by "any
>> split between AP/client cases"?
> 
> I meant the capability split - let's say you support 4-way-HS only for
> client, but not for AP. Then you have to support the NEW_KEY command
> for the AP case, even if you might not support non-offloaded 4-way-HS
> for the client case.
> 
> So if something supports the following:
> 
>   * client: offloaded 4-way-HS only
>   * AP: not offloaded 4-way-HS only
> 
> Then you have to support NEW_KEY (AP case) and then using NEW_KEY to
> detect whether or not a wpa_s configuration option to not use offloaded
> 4-way-HS can be used will not work correctly.
> 
> I don't really see that this is a sensible configuration, but I could
> imagine it existing if somebody "bolted on" AP functionality for a
> client-side chipset or something like that.
> 
> Again, I think I'm happy to leave this up to you - this kind of
> configuration option should really only be used for debugging anyway,
> so just getting errors later is probably fine.

Hi Johannes,

I was thinking about adding a DOC section in nl80211.h:

/**
  * DOC: WPA/WPA2 temporal key exchange offload
  *
  * By setting @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK flag drivers
  * can indicate offload support of EAPOL handshakes for WPA/WPA2
  * preshared key authentication. In %NL80211_CMD_CONNECT the preshared
  * key should be specified using %NL80211_ATTR_PMK. Drivers supporting
  * this offload may reject the %NL80211_CMD_CONNECT when no preshared
  * key material is provided. For example when that driver does not
  * support setting the temporal keys through %NL80211_CMD_NEW_KEY.
  *
  * Similarly @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X flag can be
  * set by drivers indicating offload support of the PTK/GTK EAPOL
  * handshakes during 802.1X authentication. In order to use the offload
  * the %NL80211_CMD_CONNECT should have %NL80211_ATTR_WANT_1X_4WAY_HS
  * attribute flag. Drivers supporting this offload may reject the
  * %NL80211_CMD_CONNECT when the attribute flag is not present.
  */

Could add description for FT, ie. PMK-R0 handling as well. Do you think 
this change warrants a separate section or not. Any comments on the text 
itself are welcome.

Regards,
Arend
