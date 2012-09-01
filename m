Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56796 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2IAKIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2012 06:08:09 -0400
Received: by iahk25 with SMTP id k25so2389890iah.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Sep 2012 03:08:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK678xgwEwjoxciyNe5qv0N_+Bxi8EmUjzf9E07dLPt2nf-wHg@mail.gmail.com>
References: <CAK678xgwEwjoxciyNe5qv0N_+Bxi8EmUjzf9E07dLPt2nf-wHg@mail.gmail.com>
Date: Sat, 1 Sep 2012 13:08:09 +0300
Message-ID: <CAK678xhKap=7EeChJ4TNeSMwwAecVOMvO609X=83avvK57KLbQ@mail.gmail.com> (sfid-20120901_120850_880198_46F58A29)
Subject: Re: rtl8192cu: no beacon transmission in AP mode with Asus USB-N13
From: coekbe <coekbe@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 30, 2012 at 11:11 PM, coekbe <coekbe@gmail.com> wrote:
> Hi All,
>
> I created an Access Point using hostapd and the following USB stick:
>
> ID 0b05:17ab ASUSTek Computer, Inc. USB-N13 802.11n Network Adapter
> (rev. B1) [Realtek RTL8192CU]
>
> The problem is that I cannot see any beacon frames in data captured
> from the air. I cannot see beacon frames in the hostapd created
> mon.wlan0 interface on the AP either.

Looks like rtlwifi, rtl8192cu driver code does not contain any calls
to ieee80211_beacon_get() or ieee80211_beacon_get_tim() (except in
pci.c) so I guess beacon frames are missing simply because that
functionality was never programmed. (Realtek vendor driver does
transmit beacon frames, though.)

Colin
