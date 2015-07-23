Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36212 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbbGWAWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 20:22:00 -0400
Received: by iehx8 with SMTP id x8so100264503ieh.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 17:21:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BCEC8D504C0E1149AC1D24D3F78D48EC3CB64C5B@MARCM-SBS2011.marcmltd.local>
References: <BCEC8D504C0E1149AC1D24D3F78D48EC3CB64C5B@MARCM-SBS2011.marcmltd.local>
Date: Thu, 23 Jul 2015 02:21:59 +0200
Message-ID: <CACna6rzV-BwBHo_dO1ersLtO2JVHRqAyyB9rTqt0hp8TuRgDkA@mail.gmail.com> (sfid-20150723_022218_432520_93607D1C)
Subject: Re: Patch for backtrace dump WARNING: CPU: 0 PID: 668 at net/wireless/sme.c:655
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Marc Murphy <marcmltd@marcm.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 July 2015 at 22:14, Marc Murphy <marcmltd@marcm.co.uk> wrote:
> I have been looking at an issue with WPA/WPA2 and joining a specific Access Point SSID that also has a hidden SSID available.  This was with 3.14.47 kernel but it is also present in all 3.x kernels.
> When the AP's are being scanned it there is a warning generated stating that the bssid is empty yet when you inspect what is actually happening in the code it is because there is an SSID string but its length is 0 so it fails to return when it should.
>
> in net/wireless/scan.c there is a function is_bss that should return the cfg80211_bss struct when it finds the matching details.  When the bssid is found but the SSID is empty (valid string "" but with length of 0) it passes through when it should return as the bssid matches.
>
> Patch is as follows:

Please follow
Documentation/SubmittingPatches
Documentation/CodingStyle
(and resend your patch)

You need a clear commit messages, description and use kernel's coding style.
