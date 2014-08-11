Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:22837 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaHKIxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 04:53:05 -0400
Message-ID: <53E8846D.5080003@broadcom.com> (sfid-20140811_105313_291448_6470C1A6)
Date: Mon, 11 Aug 2014 10:53:01 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Daniel Drake <drake@endlessm.com>,
	<brcm80211-dev-list@broadcom.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac: command request size is determined by expected response
 size?
References: <CAD8Lp47RrOtTKqKQirUwSbfsvqzuStc4TOWc8OXUYBzdjhJ_JA@mail.gmail.com>
In-Reply-To: <CAD8Lp47RrOtTKqKQirUwSbfsvqzuStc4TOWc8OXUYBzdjhJ_JA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2014 10:35 AM, Daniel Drake wrote:
> Hi,
>
> Looking at brcmfmac in Linux 3.16 with a BCM43241 SDIO card, I noticed that
> brcmf_construct_reginfo() constructs and submits a really large
> (1.5kb) request to the card. However, the actual request seems really
> small and trivial (a header, the word "chanspecs" and not much more),
> and we end up sending a whole lot of zeroes to fill the 1.5kb
> allocation (MEDLEN).
>
> I can understand that the card may wish to send 1.5kb in response, but
> does the request itself really need to be the same size?

The main reason is indeed that the request buffer is used by the device 
firmware for the response message. That is a design decision in the 
firmware that we must adhere to.

Regards,
Arend
