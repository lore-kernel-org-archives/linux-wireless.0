Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43252 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751553AbdFBN47 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 09:56:59 -0400
Message-ID: <1496411817.20223.2.camel@sipsolutions.net> (sfid-20170602_155714_753966_90FC78D9)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake
 offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
Date: Fri, 02 Jun 2017 15:56:57 +0200
In-Reply-To: <8c101115-1038-ddc0-463f-c38344f740db@broadcom.com> (sfid-20170602_131917_345156_76945615)
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
         <8c101115-1038-ddc0-463f-c38344f740db@broadcom.com>
         (sfid-20170602_131917_345156_76945615)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-02 at 13:19 +0200, Arend van Spriel wrote:

> I was thinking about adding a DOC section in nl80211.h:

Sure!

> /**
>   * DOC: WPA/WPA2 temporal key exchange offload
>   *
>   * By setting @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK flag
> drivers
>   * can indicate offload support of EAPOL handshakes for WPA/WPA2

can indicate they support offloading EAPOL ...?

>   * preshared key authentication. In %NL80211_CMD_CONNECT the
> preshared
>   * key should be specified using %NL80211_ATTR_PMK. Drivers
> supporting
>   * this offload may reject the %NL80211_CMD_CONNECT when no
> preshared
>   * key material is provided. For example when that driver does not
>   * support setting the temporal keys through %NL80211_CMD_NEW_KEY.

[...] is provided, for example when [...]

I think? Starting with "For example" seems odd to me.

>   *
>   * Similarly @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X flag can be
>   * set by drivers indicating offload support of the PTK/GTK EAPOL
>   * handshakes during 802.1X authentication. In order to use the
> offload
>   * the %NL80211_CMD_CONNECT should have
> %NL80211_ATTR_WANT_1X_4WAY_HS
>   * attribute flag. Drivers supporting this offload may reject the
>   * %NL80211_CMD_CONNECT when the attribute flag is not present.
>   */
> 
> Could add description for FT, ie. PMK-R0 handling as well. Do you
> think this change warrants a separate section or not. Any comments on
> the text itself are welcome.

I think that's good to have.

johannes
