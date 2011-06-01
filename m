Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36090 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665Ab1FAAqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 20:46:51 -0400
Received: by yxs7 with SMTP id 7so2016495yxs.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2011 17:46:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTik73ww-bKt+zmUonNWmGB8oLPgTWA@mail.gmail.com>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
	<BANLkTik73ww-bKt+zmUonNWmGB8oLPgTWA@mail.gmail.com>
Date: Wed, 1 Jun 2011 08:46:50 +0800
Message-ID: <BANLkTinxtWs9_DCEfjivxb2ae6xhfQgG3A@mail.gmail.com> (sfid-20110601_024654_206829_EFC5E60D)
Subject: Re: [RFC 00/32] ath9k: add initial support for AR9330
From: Adrian Chadd <adrian@freebsd.org>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 1 June 2011 03:51, Daniel Halperin <dhalperi@cs.washington.edu> wrote:
> On Tue, May 31, 2011 at 12:36 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
>> It is a 1x1 chip and supports 2.4GHz only.
>
> [snip]
>
>>  ath9k: enable antenna diversity for AR9330
>
> I'm confused by the combination of these two.

I bet it's like the AR9285 - there's one TX and one RX chain, but two
RX inputs, two LNAs and some controllable bits to determine how the
baseband controls how the LNAs are configured/combined for packet RX.

For clarity (heh), see the diversity combining code in recv.c; it
outlines the various LNA combination modes.


Adrian
