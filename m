Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38878 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbbGIKi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 06:38:59 -0400
Received: by igrv9 with SMTP id v9so190013286igr.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 03:38:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rzfb5-eGD8EgEHM05nJ5FWPnkEkW_fTxNg-3-=PCknv-Q@mail.gmail.com>
References: <CACna6rzfb5-eGD8EgEHM05nJ5FWPnkEkW_fTxNg-3-=PCknv-Q@mail.gmail.com>
Date: Thu, 9 Jul 2015 12:38:58 +0200
Message-ID: <CACna6rzA+BR+eB+BJfDkmNkRuo2kMsDh=DbsNR25NmoRD7QaCw@mail.gmail.com> (sfid-20150709_123903_828569_E6E99E05)
Subject: Re: brcmfmac: _brcmf_set_mac_address: Setting cur_etheraddr failed, -52
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 July 2015 at 09:07, Rafał Miłecki <zajec5@gmail.com> wrote:
> The problem appears when trying to use more than 1 interface. It gets
> created correctly, but setting its MAC fails. It results in wlan0-1
> having the same MAC as wlan0 and finally having two networks (SSIDs)
> using the same MAC. That obviously doesn't work.
>
> The error I see is:
> brcmfmac: _brcmf_set_mac_address: Setting cur_etheraddr failed, -52
> with -52 meaning BCME_IE_NOTFOUND.

I managed to find/guess what exactly BCM43602 firmware rejects. It
doesn't like 2 MAC addresses that differ by the locally administrated
bit only. In my case it was 00:23:6a:a3:7d:95 + 02:23:6a:a3:7d:95.

When I change MAC addresses to some other combination, e.g.:
00:23:6a:a3:7d:95 + 00:23:6a:a3:7d:96
02:23:6a:a3:7d:95 + 00:23:6a:a3:7d:96
it works correctly.

Any idea why Broadcom driver/firmware team decided to reject MAC
address that differ by locally administrated bit only from the already
used one? I don't think there is anything wrong with that in general.

Is there a chance to release fixed firmware?

-- 
Rafał
