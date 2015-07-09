Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33779 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbGIMIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 08:08:44 -0400
Received: by iggp10 with SMTP id p10so12342047igg.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 05:08:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rzA+BR+eB+BJfDkmNkRuo2kMsDh=DbsNR25NmoRD7QaCw@mail.gmail.com>
References: <CACna6rzfb5-eGD8EgEHM05nJ5FWPnkEkW_fTxNg-3-=PCknv-Q@mail.gmail.com>
	<CACna6rzA+BR+eB+BJfDkmNkRuo2kMsDh=DbsNR25NmoRD7QaCw@mail.gmail.com>
Date: Thu, 9 Jul 2015 14:08:43 +0200
Message-ID: <CACna6rz_0hE=4h9ZjV-H1s94pRtRFV3ojPGtCcfivHywpuJJsg@mail.gmail.com> (sfid-20150709_140853_998470_D5F163A1)
Subject: Re: brcmfmac: _brcmf_set_mac_address: Setting cur_etheraddr failed, -52
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 July 2015 at 12:38, Rafał Miłecki <zajec5@gmail.com> wrote:
> On 9 July 2015 at 09:07, Rafał Miłecki <zajec5@gmail.com> wrote:
>> The problem appears when trying to use more than 1 interface. It gets
>> created correctly, but setting its MAC fails. It results in wlan0-1
>> having the same MAC as wlan0 and finally having two networks (SSIDs)
>> using the same MAC. That obviously doesn't work.
>>
>> The error I see is:
>> brcmfmac: _brcmf_set_mac_address: Setting cur_etheraddr failed, -52
>> with -52 meaning BCME_IE_NOTFOUND.
>
> I managed to find/guess what exactly BCM43602 firmware rejects. It
> doesn't like 2 MAC addresses that differ by the locally administrated
> bit only. In my case it was 00:23:6a:a3:7d:95 + 02:23:6a:a3:7d:95.
>
> When I change MAC addresses to some other combination, e.g.:
> 00:23:6a:a3:7d:95 + 00:23:6a:a3:7d:96
> 02:23:6a:a3:7d:95 + 00:23:6a:a3:7d:96
> it works correctly.

Oh, it appeared to be more tricky. What BCM43602 firmware doesn't
allow is using the same value in the last 2 bits for different BSSes.

Few examples:
00:23:6a:a3:7d:90 + 00:23:6a:a3:7d:91 is GOOD
00:23:6a:a3:7d:90 + 00:23:6a:a3:7d:93 is GOOD
00:23:6a:a3:7d:90 + 00:23:6a:a3:7d:94 is BAD (last two bits are 0x0)
00:23:6a:a3:7d:92 + 00:23:6a:a3:7d:9a is BAD (last two bits are 0x2)

What's weird, all other numbers can be used as you want:
00:23:6A:A3:7D:90 + 00:7D:A3:6A:23:92 is GOOD

-- 
Rafał
