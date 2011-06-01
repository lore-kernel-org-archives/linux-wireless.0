Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37284 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab1FABGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 21:06:19 -0400
Received: by bwz15 with SMTP id 15so4123262bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2011 18:06:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinxtWs9_DCEfjivxb2ae6xhfQgG3A@mail.gmail.com>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
 <BANLkTik73ww-bKt+zmUonNWmGB8oLPgTWA@mail.gmail.com> <BANLkTinxtWs9_DCEfjivxb2ae6xhfQgG3A@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Tue, 31 May 2011 18:05:58 -0700
Message-ID: <BANLkTinmPug5v=tmrP-TvAXbtJNiXU5Xng@mail.gmail.com> (sfid-20110601_030623_308801_92B17D13)
Subject: Re: [RFC 00/32] ath9k: add initial support for AR9330
To: Adrian Chadd <adrian@freebsd.org>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 31, 2011 at 5:46 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> Hi,
>
> On 1 June 2011 03:51, Daniel Halperin <dhalperi@cs.washington.edu> wrote:
>> On Tue, May 31, 2011 at 12:36 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
>>> It is a 1x1 chip and supports 2.4GHz only.
>>
>> [snip]
>>
>>>  ath9k: enable antenna diversity for AR9330
>>
>> I'm confused by the combination of these two.
>
> I bet it's like the AR9285 - there's one TX and one RX chain, but two
> RX inputs, two LNAs and some controllable bits to determine how the
> baseband controls how the LNAs are configured/combined for packet RX.
>
> For clarity (heh), see the diversity combining code in recv.c; it
> outlines the various LNA combination modes.

Gotcha. I was under the impression that Atheros has historically
marketed these (misleadingly) as '1x2' devices, e.g., see the '3x3'
devices that have 3 antennas but only 2 chains.

Dan
