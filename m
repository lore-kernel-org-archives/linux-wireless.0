Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:56358 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaJIFo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 01:44:27 -0400
Received: by mail-vc0-f171.google.com with SMTP id hy10so409804vcb.30
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2014 22:44:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21557.20300.648468.965143@gargle.gargle.HOWL>
References: <etPan.5433ced3.74b0dc51.2d48@Mac-Pro.local>
	<CA+BoTQkvUkdkWDLOzu2cz6C6SGWFL2SCgwMDLf=ruaFwP9umjg@mail.gmail.com>
	<21557.20300.648468.965143@gargle.gargle.HOWL>
Date: Thu, 9 Oct 2014 07:44:26 +0200
Message-ID: <CA+BoTQntkp4_RJuhV1A6eH+mHsJZoy0-jj-jEP161O3nm0wn9Q@mail.gmail.com> (sfid-20141009_074431_332771_62A48D8D)
Subject: Re: How to know the information about RTS reception in mac80211 or
 device driver
From: Michal Kazior <michal.kazior@tieto.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Okhwan Lee <ohlee@mwnl.snu.ac.kr>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 October 2014 16:50, Sujith Manoharan <sujith@msujith.org> wrote:
> Michal Kazior wrote:
>> I think you've just found an ath10k bug.
>>
>> I've been running through Rx code lately. I was looking at
>> htt_rx_mpdu_status and noticed it was a bit greedy. I then recalled
>> someone was complaining about RTS reception.
>
> Maybe the RX filter to receive control frames is not set properly in the FW ?
> ath10k doesn't seem to use WMI_10X_PDEV_PARAM_RX_FILTER.

I suspect ath10k is dropping RTS frames in
ath10k_htt_rx_amsdu_allowed() now because RX_ATTENTION_FLAGS_MGMT_TYPE
includes management, control and null function frames. I'm yet to
confirm what ath10k really ends up dropping now though.


Michał
