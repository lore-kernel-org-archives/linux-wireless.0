Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:37480 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbcAZGwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 01:52:19 -0500
Received: by mail-ig0-f179.google.com with SMTP id h5so45712121igh.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2016 22:52:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A5EFBD.5070400@broadcom.com>
References: <1453294027-12811-1-git-send-email-zajec5@gmail.com>
	<56A5EFBD.5070400@broadcom.com>
Date: Tue, 26 Jan 2016 07:52:19 +0100
Message-ID: <CACna6ryPq+O2yBrKG-9sZYqQ5rhqP2VV81u5qha5WVrP3QmE7Q@mail.gmail.com> (sfid-20160126_075223_771616_FB521B76)
Subject: Re: [RFC PATCH] brcmfmac: set WIPHY_FLAG_HAVE_AP_SME
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 January 2016 at 10:49, Arend van Spriel <arend@broadcom.com> wrote:
> On 20-1-2016 13:47, Rafał Miłecki wrote:
>> Now, the problem with brcmfmac is that it doesn't report support for any
>> management frames in AP mode. It supports sending ACTION (and maybe
>> PROBE_RESP) frames, but it can't pass ACTION to the cfg80211. So even if
>> we report we can send ACTION (as it seems we do), it won't fix the
>> problem.
>>
>> So this patch will trigger another code path in hostapd that due to
>> brcmfmac missing support for receiving & passing ACTION will fail.
>>
>> Do you have any idea how to handle this?
>
> The mgmt_tx callback in brcmfmac was added for P2P functionality. So if
> anything, a check should be added to assure it is only used on P2P
> interfaces.
>
>> Should hostapd drop depndency on ACTION frames? Should brcmfmac fake
>> support for receiving & passing ACTION frames? Or should support for
>> ACTION frames be added indeed?
>
> So why not stick with the current implementation. It may not seem
> optimal to first try one thing and fallback to another, but at least it
> works. I was thinking about trying with use_monitor=0, but looking in
> the code nl80211_setup_ap() that will not resolve it either.

I don't like current implementation as it depends on some failure,
fallback & inconsistent code in hostapd. It seems hacky to me and I
can imagine things going wrong on some simple hostapd change. I beliee
it also doesn't allow brcmfmac to implement monitor mode, because once
it's done, hostapd won't hit the same fallback path.
