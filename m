Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:44733 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaKYUjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 15:39:02 -0500
Received: by mail-ig0-f169.google.com with SMTP id hl2so7435991igb.4
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2014 12:39:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416945354-23346-2-git-send-email-arend@broadcom.com>
References: <1416945354-23346-1-git-send-email-arend@broadcom.com>
	<1416945354-23346-2-git-send-email-arend@broadcom.com>
Date: Tue, 25 Nov 2014 21:39:01 +0100
Message-ID: <CACna6rwjieystZYnHGPiRZkgYWA=x3rOVQ8oGk=ZS4YezWiUkA@mail.gmail.com> (sfid-20141125_213913_477294_1CFA5B4C)
Subject: Re: [PATCH V2 1/2] brcmutil: add helper function to format board revision
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 November 2014 at 20:55, Arend van Spriel <arend@broadcom.com> wrote:
> +/* Produce a human-readable string for boardrev */
> +char *brcmu_boardrev_str(u32 brev, char *buf)
> +{
> +       char c;
> +
> +       if (brev < 0x100) {
> +               snprintf(buf, 8, "%d.%d", (brev & 0xf0) >> 4, brev & 0xf);
> +       } else {
> +               c = (brev & 0xf000) == 0x1000 ? 'P' : 'A';
> +               snprintf(buf, 8, "%c%03x", c, brev & 0xfff);
> +       }
> +       return buf;
> +}

Is this known what do 'P' and 'A' mean? Just curious.
