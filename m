Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619E5C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 15:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECBB42081B
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 15:59:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AwkpdNOH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECBB42081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbeK2DBf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 22:01:35 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39863 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbeK2DBf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 22:01:35 -0500
Received: by mail-oi1-f196.google.com with SMTP id i6so11350326oia.6
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2018 07:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aJDqJJTJolXdIGj9SNnXtEE8GQr9n2a3zzx7Jjsq0Sw=;
        b=AwkpdNOHJlYynHLzv5ukeoepeztaB+dARk38ydgPQ1jK3k7T2ofgqYevhC6lBO+Ve+
         6XarK5bdlPyZ3qI/GQDySS7mpstvzsDLhcteJTWktsz1icVJrWKx8+7Monp96eWSidqm
         /xEW3CaNOPjP0dDNFQm10pxEXCkX67e9eVyxBJw2K/OGyOCdddM9JH0OTtHbIAdedlQp
         mfBYTdmC4ErPYdc9y7i6s+C77bSpR9WCq98MDBuAPGfDiIAZ+eiqt21xvkenQNBUAwSX
         PRhmXaJYc17e88rddxpn4gP7WGXcD2UqLmS7sL05AjuQH00oxhxLCO51F52qzHKJqqYQ
         rF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aJDqJJTJolXdIGj9SNnXtEE8GQr9n2a3zzx7Jjsq0Sw=;
        b=XdzPRvWCnkfUp256t5N/HM2oYhJiqitE3SK1h885j7OCUT+Ox75mZYlxpdnlFKWxpR
         f9h3WuWxdQlLSYTBePXvleHdGUzgOhpGRLlmxMAtXpTDe2tSwszNeb/tNn/x+GZpJBn0
         +OIdC/1oHDzsXKWEUqDQtEMV2RVdZAeMvSMhsLGincHE1A84W6Yaxi0eoZSMfc5qQ/lm
         JcOiGmDL+MgLDAY5ZwHKcx6TCkoFVO1Yj3b8Jc06iE9bik+gqtb5kXbGF0sFujQAT0H6
         zB7FodGqutHEzSBBLXgGhWJJMWug1XlmolidtL6v+Cc+V2khefV4nXwRuZDBsWMA/CgV
         CYCg==
X-Gm-Message-State: AGRZ1gKmUPHbIY4y1wTi6IgWe+QBtVspyzofJOeQa5MX/v6jvaeRqGSb
        +rY9dMfvCMap9koVW/jLIDoyGp4Xy2olmTuHbeY=
X-Google-Smtp-Source: AJdET5dJKJZQxfLSSdgMOIRLMRmDW0OwGiP52FtryZrpoVAdvFDMVKjwpR4KR9F+s7yBlHvlCbMLsrR5tjreppgwNGQ=
X-Received: by 2002:aca:d056:: with SMTP id h83mr21989309oig.67.1543420766568;
 Wed, 28 Nov 2018 07:59:26 -0800 (PST)
MIME-Version: 1.0
References: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
 <85717463-11e2-e2e3-b08e-b758986687b5@broadcom.com> <1510916848.26896.2.camel@nxp.com>
 <5A0EDC25.7030505@broadcom.com> <1510932224.22506.0.camel@nxp.com>
 <d9a80a75-b3d4-d78e-a5bf-ab31732f040d@broadcom.com> <e14bdc26-5092-18c9-4caa-c45fd1d12984@broadcom.com>
 <1511347672.18886.2.camel@nxp.com> <5A15584A.9090601@broadcom.com>
 <1511450638.9102.1.camel@nxp.com> <5A1FFA17.6000703@broadcom.com>
 <1512413992.18900.3.camel@nxp.com> <CAF7Mx6q6mTOXc=4OFVCHAHd26pyfv5e6pK=TMNmb1S6=FBWUWQ@mail.gmail.com>
 <1512485878.9392.1.camel@nxp.com> <CAOMZO5DXoCFgTtuRRAq_jFjzkzFp6chMCwczXF5Z0bFaNfQnog@mail.gmail.com>
 <5A5E5EBE.7040301@broadcom.com> <1516276016.8817.1.camel@nxp.com>
 <5A61B43C.4000305@broadcom.com> <1521646672.13983.1.camel@nxp.com>
 <5AB4C8D5.40203@broadcom.com> <1521810882.19239.1.camel@nxp.com>
 <1522067092.4780.3.camel@nxp.com> <1522071220.8102.0.camel@nxp.com>
 <05ab43bd-0033-fc45-a992-0a20b91a0e74@broadcom.com> <CABACg+wyLwYQna+HDJyjNA8V1_3cSoMRDyiBpq=K+UXVXDrtBQ@mail.gmail.com>
 <CAHWfWzm8Zwjc2tBQWVqpaa-cMYyEPWmUKYN7rspyb9W9spx2iQ@mail.gmail.com> <CAOMZO5C+r4s3Hn49QbP=0Y+hSYDT5-Y2ZY91E57JvAmq75CXLw@mail.gmail.com>
In-Reply-To: <CAOMZO5C+r4s3Hn49QbP=0Y+hSYDT5-Y2ZY91E57JvAmq75CXLw@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 28 Nov 2018 13:59:19 -0200
Message-ID: <CAOMZO5DtqVBkWuD0iR5JHEG4G-MoWYYxU8aSu99rW8mpd3+PYQ@mail.gmail.com>
Subject: Re: AP6335 with mainline kernel
To:     cameron@paloaltoinnovation.com
Cc:     Vanessa Ayumi Maegima <van.ayumi@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Vanessa Maegima <vanessa.maegima@nxp.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        embed3d@gmail.com, John Weber <john.weber@technexion.com>,
        Otavio Salvador <otavio@ossystems.com.br>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Cameron,

On Sat, Nov 17, 2018 at 5:10 PM Fabio Estevam <festevam@gmail.com> wrote:

> Could you please test the following patch against mainline that
> implements this suggestion?
> http://dark-code.bulix.org/4m18pb-507579

I finally managed to get Wifi working on the imx7d-pico-pi board using
mainline 4.19.2 without any dts change.

Only change I needed was the one suggested by Arend in the nvram file:
changed boardflags3 entry.from 0x08101188 to 0x101188.

With this change I get:

# iwconfig wlan0 essid ACCESSPOINT
# wpa_passphrase ACCESSPOINT > /etc/wpa.conf
*****
# wpa_supplicant -Dwext -iwlan0 -c /etc/wpa.conf &
# Successfully initialized wpa_supplicant
[   59.091981] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   59.310095] brcmfmac: brcmf_run_escan: error (-52)
[   59.314949] brcmfmac: brcmf_cfg80211_scan: scan error (-52)
ioctl[SIOCSIWSCAN]: Invalid exchange
wlan0: CTRL-EVENT-SCAN-FAILED ret=-1 retry=1
[   60.327177] brcmfmac: brcmf_run_escan: error (-52)
[   60.332152] brcmfmac: brcmf_cfg80211_scan: scan error (-52)
ioctl[SIOCSIWSCAN]: Invalid exchange
wlan0: CTRL-EVENT-SCAN-FAILED ret=-1 retry=1
[   61.344358] brcmfmac: brcmf_run_escan: error (-52)
[   61.349198] brcmfmac: brcmf_cfg80211_scan: scan error (-52)
ioctl[SIOCSIWSCAN]: Invalid exchange
wlan0: CTRL-EVENT-SCAN-FAILED ret=-1 retry=1
wlan0: Trying to associate with 94:2c:b3:31:dc:xx (SSID='ACCESSPOINT'
freq=2462 MHz)
wlan0: Associated with 94:2c:b3:31:dc:xx
wlan0: [   65.266683] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
WPA: Key negotiation completed with 94:2c:b3:31:dc:xx [PTK=CCMP GTK=TKIP]
wlan0: CTRL-EVENT-CONNECTED - Connection to 94:2c:b3:31:dc:xx
completed [id=0 id_str=]

# udhcpc -i wlan0
udhcpc: started, v1.29.3
[   73.015896] random: mktemp: uninitialized urandom read (6 bytes read)
udhcpc: sending discover
udhcpc: sending select for 192.168.0.14
udhcpc: lease of 192.168.0.14 obtained, lease time 3600
[   74.354463] brcmfmac: brcmf_inetaddr_changed: fail to get arp ip
table err:-52
deleting routers
[   74.390701] random: mktemp: uninitialized urandom read (6 bytes read)
adding dns 201.82.0.66
adding dns 201.82.0.61
adding dns 201.6.4.116
#
# ping google.com
PING google.com (216.58.202.174): 56 data bytes
64 bytes from 216.58.202.174: seq=0 ttl=50 time=26.328 ms
64 bytes from 216.58.202.174: seq=1 ttl=50 time=22.751 ms
64 bytes from 216.58.202.174: seq=2 ttl=50 time=48.735 ms
64 bytes from 216.58.202.174: seq=3 ttl=50 time=58.955 ms

If I change the dts as per my last patch the Wifi does not work.

Regards,

Fabio Estevam
