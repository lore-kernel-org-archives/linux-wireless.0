Return-Path: <SRS0=a98u=MM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF68C004D2
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 23:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3188E206B2
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 23:39:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T5v5n42L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3188E206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbeJAGOZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 02:14:25 -0400
Received: from mail-oi1-f175.google.com ([209.85.167.175]:45155 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbeJAGOZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 02:14:25 -0400
Received: by mail-oi1-f175.google.com with SMTP id e17-v6so468671oig.12
        for <linux-wireless@vger.kernel.org>; Sun, 30 Sep 2018 16:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fY5pQ4NyWa0WH+7wCXcJFdgV3LTGWCEvmJusdBbUBE0=;
        b=T5v5n42LnLqEiiOEUiXDkt/XcvBJU4/RjBngrZbI4/LgJDx8XySvuMNocs0D0Xft+I
         U3n2Bq9Mw8z2HXg3IlGpSOsnG+z9wC0rJ54bA+WEBW1xhJCjce7oqz4QOvkYO0WvRgaT
         aNCFCmbv/kGD3+aEM0qHt2eSoSulTsAn36wHIyUkiwFe1p8bxshMYYT1Z0ssyQuCmi4N
         7GL8Wxd5q/cf8jS3NPJzCEpjNK4N/Uk8Ps8STASc2XA48NkQQsL1mldxA4NM9jlDhVyR
         4RkCjsoeoj2hwtapFWWLHiEUmaaGwoDsOR87NsKtuHA6EyDNk3F4HwFPxCpH3JJLgG0V
         mz+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fY5pQ4NyWa0WH+7wCXcJFdgV3LTGWCEvmJusdBbUBE0=;
        b=bvx1WGauGnQyrQlcV/a+mcTRZFe3m9P7/q373I9/I86kU7dp2KuHCTrzQmGxYwoSxU
         rg/sd8ceOc0F+wRtQzx02ZUXaBFNnsql0wwN8bjYXBjhDi6uOEEohMEUiQ4PK5DK2Ijv
         G+fvqGtnthe/djBRGINwfJf7adMKXxcpB3qCZ5DonBGScMm3q6DQGUdXzapsGMAgfENu
         s4UU+Kbi3/CSDNNhYoIkKCxow1BYmajivJUTTC/b92fDJqizYsL7Kph4yLmR7ugNmHpf
         1GC8xbhAtbg4mULX8JCigCk2EXhh4yIXtkqYD18fsKk6YspuAZ/U1SuR1oM6n/0vHAew
         NcWA==
X-Gm-Message-State: ABuFfogf4gGSfq2OS8YsZBP8/EbBDpr2W5Tp+NueTmcg3CnjjwMIV0gN
        CcUf9UgDWTaFd7VJbxUhD8nzV/Tv
X-Google-Smtp-Source: ACcGV62lKiMfFRFNYDxTwdiwQugnLMgNuxPaDNhM2AemAXFVfMNZo5yd7EdSetrO5RLdAilJvyJo3w==
X-Received: by 2002:aca:4b56:: with SMTP id y83-v6mr4115423oia.88.1538350767062;
        Sun, 30 Sep 2018 16:39:27 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id b3-v6sm515855oih.0.2018.09.30.16.39.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Sep 2018 16:39:26 -0700 (PDT)
Subject: Re: Problems and suggestions to the kernel module r8723bs
To:     Simon Beginn <simonmicro@simonmicro.de>,
        Bastien Nocera <hadess@hadess.net>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <83c86a2a-0d2a-8119-2831-e9cfab7a43d7@simonmicro.de>
 <f0b67da4-747a-08e3-9744-fce2c74aaddc@lwfinger.net>
 <6e27de67-739f-ee17-eb5f-efb079d1f37f@simonmicro.de>
 <7a47d05c-2f3b-e4d5-ccf1-5c2106d3c93d@lwfinger.net>
 <3a0468ee-e391-3b03-bfc5-36df484bce9d@simonmicro.de>
 <9a7105c0-fd23-c7ff-3e28-62533c24cdb9@lwfinger.net>
 <374c0f3a-aa89-18c5-cd53-0c395ff02a6d@simonmicro.de>
 <72ffad3d-1cdf-f93b-cefc-4ee06872926d@lwfinger.net>
 <d66a0351-ad7a-a993-5184-c91a2aeec28d@simonmicro.de>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <7caaa3e4-3511-1992-b5fe-a77ba3f6f77d@lwfinger.net>
Date:   Sun, 30 Sep 2018 18:39:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <d66a0351-ad7a-a993-5184-c91a2aeec28d@simonmicro.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 9/30/18 12:57 PM, Simon Beginn wrote:
> Hi Larry,
> 
> I experience some other strange behaviors. The chip cant connect to my old ASUS 
> router (RT-N12E_B1) and cant even see the mobile hotspot of my smartphone. So, 
> logically it cant take the best network, if it doesn't connect to my router or 
> my smartphone - even directly lying beside it. I also cant reconnect to my 
> test-network. The networks "Gonzales" and "TPC_install*" are both hosted by my 
> router.
> 
> On 09/28/2018 05:59 PM, Larry Finger wrote:
>> sudo iw dev wlan0 scan | egrep "associated|SSID|signal" 
> 
> Here the requested outputs:
> 
> -> Desk
> BSS d4:6e:0e:5b:bf:ae(on wlan0) -- associated
>      signal: -93.00 dBm
>      SSID: Gonzales
>      signal: -60.00 dBm
>      SSID: Gonzales
>      signal: -52.00 dBm
>      SSID: Gonzales
>      signal: -50.00 dBm
>      SSID: TPC_Install
> 
> -> Place A (beside an other access point)
> 
> BSS d4:6e:0e:5b:bf:ae(on wlan0) -- associated
>      signal: -78.00 dBm
>      SSID: Gonzales
>      signal: -45.00 dBm
>      SSID: Gonzales
>      signal: -65.00 dBm
>      SSID: Gonzales
> 
> 
> And here the full output (only for diagnostic reasons) [at my desk]:
> 
> BSS d4:6e:0e:5b:bf:ae(on wlan0) -- associated
>      TSF: 337615491 usec (0d, 00:05:37)
>      freq: 2447
>      beacon interval: 100 TUs
>      capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
>      signal: -93.00 dBm
>      last seen: 0 ms ago
>      SSID: Gonzales
>      Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0
>      DS Parameter set: channel 8
>      ERP: <no flags>
>      Extended supported rates: 24.0 36.0 48.0 54.0
>      HT capabilities:
>          Capabilities: 0x106e
>              HT20/HT40
>              SM Power Save disabled
>              RX HT20 SGI
>              RX HT40 SGI
>              No RX STBC
>              Max AMSDU length: 3839 bytes
>              DSSS/CCK HT40
>          Maximum RX AMPDU length 32767 bytes (exponent: 0x002)
>          Minimum RX AMPDU time spacing: 16 usec (0x07)
>          HT RX MCS rate indexes supported: 0-15
>          HT TX MCS rate indexes are undefined
>      HT operation:
>           * primary channel: 8
>           * secondary channel offset: below
>           * STA channel width: any
>           * RIFS: 0
>           * HT protection: no
>           * non-GF present: 0
>           * OBSS non-GF present: 0
>           * dual beacon: 0
>           * dual CTS protection: 0
>           * STBC beacon: 0
>           * L-SIG TXOP Prot: 0
>           * PCO active: 0
>           * PCO phase: 0
>      WPA:     * Version: 1
>           * Group cipher: TKIP
>           * Pairwise ciphers: TKIP CCMP
>           * Authentication suites: PSK
>      RSN:     * Version: 1
>           * Group cipher: TKIP
>           * Pairwise ciphers: TKIP CCMP
>           * Authentication suites: PSK
>           * Capabilities: 1-PTKSA-RC 1-GTKSA-RC (0x0000)
>      WMM:     * Parameter version 1
>           * BE: CW 15-1023, AIFSN 3
>           * BK: CW 15-1023, AIFSN 7
>           * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
>           * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
> BSS 30:b5:c2:68:07:2c(on wlan0)
>      TSF: 337615505 usec (0d, 00:05:37)
>      freq: 2412
>      beacon interval: 100 TUs
>      capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
>      signal: -65.00 dBm
>      last seen: 0 ms ago
>      SSID: Gonzales
>      Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0
>      DS Parameter set: channel 1
>      ERP: <no flags>
>      Extended supported rates: 24.0 36.0 48.0 54.0
>      HT capabilities:
>          Capabilities: 0x106e
>              HT20/HT40
>              SM Power Save disabled
>              RX HT20 SGI
>              RX HT40 SGI
>              No RX STBC
>              Max AMSDU length: 3839 bytes
>              DSSS/CCK HT40
>          Maximum RX AMPDU length 32767 bytes (exponent: 0x002)
>          Minimum RX AMPDU time spacing: 16 usec (0x07)
>          HT RX MCS rate indexes supported: 0-15
>          HT TX MCS rate indexes are undefined
>      HT operation:
>           * primary channel: 1
>           * secondary channel offset: above
>           * STA channel width: any
>           * RIFS: 0
>           * HT protection: no
>           * non-GF present: 0
>           * OBSS non-GF present: 0
>           * dual beacon: 0
>           * dual CTS protection: 0
>           * STBC beacon: 0
>           * L-SIG TXOP Prot: 0
>           * PCO active: 0
>           * PCO phase: 0
>      WPA:     * Version: 1
>           * Group cipher: TKIP
>           * Pairwise ciphers: TKIP CCMP
>           * Authentication suites: PSK
>      RSN:     * Version: 1
>           * Group cipher: TKIP
>           * Pairwise ciphers: TKIP CCMP
>           * Authentication suites: PSK
>           * Capabilities: 1-PTKSA-RC 1-GTKSA-RC (0x0000)
>      WMM:     * Parameter version 1
>           * BE: CW 15-1023, AIFSN 3
>           * BK: CW 15-1023, AIFSN 7
>           * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
>           * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
> BSS 1c:b7:2c:7c:9b:30(on wlan0)
>      TSF: 337615512 usec (0d, 00:05:37)
>      freq: 2472
>      beacon interval: 100 TUs
>      capability: ESS Privacy ShortSlotTime APSD (0x0c11)
>      signal: -50.00 dBm
>      last seen: 0 ms ago
>      SSID: Gonzales
>      Supported rates: 1.0* 2.0* 5.5* 11.0* 9.0 18.0 36.0 54.0
>      DS Parameter set: channel 13
>      ERP: Barker_Preamble_Mode
>      Extended supported rates: 6.0 12.0 24.0 48.0
>      HT capabilities:
>          Capabilities: 0x11ee
>              HT20/HT40
>              SM Power Save disabled
>              RX HT20 SGI
>              RX HT40 SGI
>              TX STBC
>              RX STBC 1-stream
>              Max AMSDU length: 3839 bytes
>              DSSS/CCK HT40
>          Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
>          Minimum RX AMPDU time spacing: 4 usec (0x05)
>          HT RX MCS rate indexes supported: 0-15, 32
>          HT TX MCS rate indexes are undefined
>      HT operation:
>           * primary channel: 13
>           * secondary channel offset: no secondary
>           * STA channel width: 20 MHz
>           * RIFS: 0
>           * HT protection: no
>           * non-GF present: 0
>           * OBSS non-GF present: 0
>           * dual beacon: 0
>           * dual CTS protection: 0
>           * STBC beacon: 0
>           * L-SIG TXOP Prot: 0
>           * PCO active: 0
>           * PCO phase: 0
>      RSN:     * Version: 1
>           * Group cipher: CCMP
>           * Pairwise ciphers: CCMP
>           * Authentication suites: PSK
>           * Capabilities: 1-PTKSA-RC 1-GTKSA-RC (0x0000)
>      WMM:     * Parameter version 1
>           * u-APSD
>           * BE: CW 15-1023, AIFSN 3
>           * BK: CW 15-1023, AIFSN 7
>           * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
>           * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
>      BSS Load:
>           * station count: 0
>           * channel utilisation: 11/255
>           * available admission capacity: 31250 [*32us]
>      Overlapping BSS scan params:
>           * passive dwell: 20 TUs
>           * active dwell: 10 TUs
>           * channel width trigger scan interval: 300 s
>           * scan passive total per channel: 200 TUs
>           * scan active total per channel: 20 TUs
>           * BSS width channel transition delay factor: 5
>           * OBSS Scan Activity Threshold: 0.25 %
>      Extended capabilities:
>           * HT Information Exchange Supported
>      Country: FR    Environment: Indoor/Outdoor
>          Channels [1 - 13] @ 16 dBm
> BSS 1c:b7:2c:7c:9b:31(on wlan0)
>      TSF: 337615517 usec (0d, 00:05:37)
>      freq: 2472
>      beacon interval: 100 TUs
>      capability: ESS Privacy ShortSlotTime APSD (0x0c11)
>      signal: -48.00 dBm
>      last seen: 0 ms ago
>      SSID: TPC_Install
>      Supported rates: 1.0* 2.0* 5.5* 11.0* 9.0 18.0 36.0 54.0
>      DS Parameter set: channel 13
>      ERP: Barker_Preamble_Mode
>      Extended supported rates: 6.0 12.0 24.0 48.0
>      HT capabilities:
>          Capabilities: 0x11ee
>              HT20/HT40
>              SM Power Save disabled
>              RX HT20 SGI
>              RX HT40 SGI
>              TX STBC
>              RX STBC 1-stream
>              Max AMSDU length: 3839 bytes
>              DSSS/CCK HT40
>          Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
>          Minimum RX AMPDU time spacing: 4 usec (0x05)
>          HT RX MCS rate indexes supported: 0-15, 32
>          HT TX MCS rate indexes are undefined
>      HT operation:
>           * primary channel: 13
>           * secondary channel offset: no secondary
>           * STA channel width: 20 MHz
>           * RIFS: 0
>           * HT protection: no
>           * non-GF present: 0
>           * OBSS non-GF present: 0
>           * dual beacon: 0
>           * dual CTS protection: 0
>           * STBC beacon: 0
>           * L-SIG TXOP Prot: 0
>           * PCO active: 0
>           * PCO phase: 0
>      RSN:     * Version: 1
>           * Group cipher: CCMP
>           * Pairwise ciphers: CCMP
>           * Authentication suites: PSK
>           * Capabilities: 1-PTKSA-RC 1-GTKSA-RC (0x0000)
>      WMM:     * Parameter version 1
>           * u-APSD
>           * BE: CW 15-1023, AIFSN 3
>           * BK: CW 15-1023, AIFSN 7
>           * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
>           * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
>      BSS Load:
>           * station count: 0
>           * channel utilisation: 11/255
>           * available admission capacity: 31250 [*32us]
>      Overlapping BSS scan params:
>           * passive dwell: 20 TUs
>           * active dwell: 10 TUs
>           * channel width trigger scan interval: 300 s
>           * scan passive total per channel: 200 TUs
>           * scan active total per channel: 20 TUs
>           * BSS width channel transition delay factor: 5
>           * OBSS Scan Activity Threshold: 0.25 %
>      Extended capabilities:
>           * HT Information Exchange Supported
>      Country: FR    Environment: Indoor/Outdoor
>          Channels [1 - 13] @ 16 dBm
> 
> The only difference between the other networks and my routers one is the 
> different "Country" value (at my first look).... And my hotspots network 
> "Lineage 14.1" is not visible too. (And so i cant connect to it too.)
> 
> 
> Thank you and anyone for your/their effort!

Obviously, the driver fails badly at roaming. It has associated with an AP with 
signal of -93 dBm when -50 is available, and appears to associate with the first 
one it sees. Unfortunately, I do not have the necessary understanding of the 
chip or the driver to fix that problem. My only suggestion is that you determine 
the BSSID of the strongest AP and use the connection editor in NetworkManager to 
force a connection to that AP.

Without an over-the-air capture of the beacon from either your old ASUS router 
or the mobile hotspot, I have ne idea why the chip cannot connect to them.

Larry
